library(dplyr)
library(rvest)
url <- "https://diabimmune.broadinstitute.org/diabimmune/data/15/"
url %>%
  read_html() %>%
  html_elements("a") %>%
  html_attr("href") %>%
  download.file(., destfile = basename(.))
