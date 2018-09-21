context("version.R")

# test_that("Current package version is still latest versions", {
#   library(rvest)
#
#   get_file_url <- function(filetype) {
#     "http://ippsr.msu.edu/public-policy/correlates-state-policy" %>%
#       read_html() %>%
#       html_nodes(xpath = sprintf("//a[contains(@href, '%s')]", filetype)) %>%
#       html_attr("href")
#   }
#
#   expected_filename <- "correlatesofstatepolicyprojectv1_11.dta"
#   current_filename <- basename(get_file_url(".dta"))
#   expect_equal(expected_filename, current_filename)
# })
