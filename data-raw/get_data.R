library(rvest)
library(haven)
library(tidyverse)
library(devtools)

get_file_url <- function(filetype) {
  "http://ippsr.msu.edu/public-policy/correlates-state-policy" %>%
    read_html() %>%
    html_nodes(xpath = sprintf("//a[contains(@href, '%s')]", filetype)) %>%
    html_attr("href")
}

get_file <- function(url, output_dir = ".") {
  file_name <- file.path(output_dir, basename(url))
  download.file(url, file_name, mode = "wb")
  invisible(TRUE)
}

add_names_as_row <- function(df, new_names = NULL, ...) {
  new_row <- names(df) %>% set_names()
  out <- lift(partial(add_row, .data = df))(new_row, ...)
  if(!is.null(new_names)) {
    out <- set_names(out, new_names)
  }
  out
}

get_title_text <- function(x) {
  sprintf("//table[%s]//preceding-sibling::h1[1]", x)
}

get_codebook_df <- function(codebook_file) {

  tmp <- tempfile(fileext = ".html")
  on.exit(unlink(tmp))
  shell(sprintf("pandoc -f docx -t html -o %s  %s", tmp, codebook_file))

  page <- read_html(tmp, "utf-8")
  tbls <- html_table(page, TRUE, TRUE, TRUE)

  garbled <- map_lgl(tbls, ~names(.)[1] != "Variable Name")

  tbls[garbled] <- tbls[garbled] %>%
    map(add_names_as_row,
        new_names = c("Variable Name", "Variable-Short Description", "Dates",
                      "Variable-Longer Description", "Sources and Notes"),
        .before = 1
    )

  tbl_topics <- seq_along(tbls) %>%
    map_chr(~page %>%
              html_nodes(xpath = get_title_text(.x)) %>%
              html_text(TRUE))

  tbls %>%
    map(~mutate_all(., as.character)) %>%
    set_names(tbl_topics) %>%
    bind_rows(.id = "topic") %>%
    set_names(c("topic", "variable", "var_desc", "dates",
                "var_long_desc", "sources_notes")) %>%
    mutate_all(funs(iconv(., "utf-8", "latin1"))) %>%
    filter(!is.na(var_desc), variable != "")
}

## IO
data_url <- get_file_url(".dta")
codebook_url <- get_file_url(".docx")
data_file <- file.path("data-raw", basename(data_url))
codebook_file <- file.path("data-raw", basename(codebook_url))

get_file(data_url, "data-raw")
get_file(codebook_url, "data-raw")

codebook <- get_codebook_df(codebook_file)
csp <- read_stata(data_file) %>%
  gather(variable, value, -(year:state_icpsr)) %>%
  left_join(codebook) %>%
  zap_formats() %>%
  mutate(value = as.numeric(value))

use_data(csp, overwrite = TRUE)
