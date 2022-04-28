# Prepare Bokulich dataset

# Load necessary packages
library(phyloseq)
library(dplyr)

readbioms <- function(x){
  ps <- paste0("bokulich/bioms/BIOM/", x, "/otu_table.biom") %>% import_biom()
  sam <- paste0("bokulich/bioms/mapping_files/", x, "_mapping_file.txt") %>%
    read.table(., sep="\t", header = TRUE, row.names =1)
  sample_data(ps) <- sam
  return(ps)
}

samples <- c("46311", "46315", "46296", "46322", "46319")
lps <- lapply(samples, readbioms)

bokulich <- merge_phyloseq(lps[[1]], lps[[2]], lps[[3]], lps[[4]], lps[[5]])
sample_data(bokulich)$sample_name <- rownames(sample_data(bokulich))


# Import metadata
metaboku <- read.csv("bokulich/bokulich_metadata.txt", sep= "\t")
combboku <- inner_join(data.frame(sample_data(bokulich)), metaboku)
combboku <- sample_data(combboku)
sample_names(combboku) <- combboku$sample_name
sample_data(bokulich) <- combboku
