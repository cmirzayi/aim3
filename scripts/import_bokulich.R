# Prepare Bokulich dataset

# Load necessary packages
library(phyloseq)
library(dplyr)

readbioms <- function(x){
  ps <- paste0("data/bokulich/bioms/BIOM/", x, "/otu_table.biom") %>% import_biom
  sam <- paste0("data/bokulich/bioms/mapping_files/", x, "_mapping_file.txt") %>%
    read.table(., sep="\t", header = TRUE, row.names =1)
  sample_data(ps) <- sam
  return(ps)
}

samples <- c("3810", "3811", "3812", "3813", "3814")
lps <- lapply(samples, readbioms)

bokulich <- merge_phyloseq(lps[[1]], lps[[2]], lps[[3]], lps[[4]], lps[[5]])
sample_data(bokulich)
