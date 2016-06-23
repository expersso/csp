library(rvest)
library(haven)
library(dplyr)
library(purrr)
library(tidyr)
library(devtools)

get_file <- function(file_name, output_dir = ".") {
  bn <- "http://www.matthewg.org/"
  url <- paste0(bn, file_name)
  file_name <- file.path(output_dir, basename(url))
  download.file(url, file_name, mode = "wb")
  invisible(TRUE)
}

get_title_text <- function(x) {
  sprintf("//table[%s]//preceding-sibling::h1[1]", x)
}

add_topic_var <- function(tbl, topic) {
  tbl$topic <- topic
  tbl
}

get_codebook_df <- function(codebook_file) {
  tmp <- tempfile(fileext = ".html")
  on.exit(unlink(tmp))
  shell(sprintf("pandoc -f docx -t html -o %s  %s", tmp, codebook_file))

  page <- read_html(tmp, "utf-8")
  tbls <- page %>% html_table(FALSE, TRUE, TRUE)

  tbl_topics <- 1:17 %>%
    map(~html_nodes(page, xpath = get_title_text(.x))) %>%
    map_chr(html_text, trim = TRUE)

  map2(tbls, tbl_topics, add_topic_var) %>%
    rbind_all() %>%
    set_names(
      c("variable", "var_desc", "dates", "var_long_desc", "sources_notes", "topic")
      ) %>%
    mutate_each(funs(ic = iconv(., "utf-8", "latin1"))) %>%
    filter(!is.na(var_desc), !variable %in% c("Variable Name", ""))
}

## IO
data_file <- "correlatesofstatepolicyprojectv1.dta"
codebook_file <- "correlatesofstatepolicyprojectv1Codebook.docx"

get_file(data_file, "data-raw")
get_file(codebook_file, "data-raw")

codebook <- get_codebook_df(file.path("data-raw", codebook_file))
csp <- read_stata(file.path("data-raw", data_file)) %>%
  gather(variable, value, -(year:state_icpsr)) %>%
  left_join(codebook)

use_data(csp, overwrite = TRUE)
