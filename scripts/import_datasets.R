# Goal is to convert every dataset to a phyloseq object with similar metadata
# Ideally the metadata are formatted as cMD metadata tables

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


## Import metadata
metaboku <- read.csv("bokulich/bokulich_metadata.txt", sep= "\t")
combboku <- inner_join(data.frame(sample_data(bokulich)), metaboku)
combboku <- sample_data(combboku)
sample_names(combboku) <- combboku$sample_name
sample_data(bokulich) <- combboku


# Korry
library(phyloseq)
otuKorry <- read.csv("korry/metaphlan/merged/metaphlan_taxonomic_profiles.tsv", sep="\t", strip.white = T, stringsAsFactors = F, row.names = 1)
colnames(otuKorry) <- substr(colnames(otuKorry),1,10)
metaKorry <- read.csv("korry/KorryB_2020_metadata.csv")
samKorry <- sample_data(metaKorry)
sample_names(samKorry) <- samKorry$NCBI_accession

korry <- phyloseq(samKorry, otu_table(otuKorry, taxa_are_rows=TRUE)) #Mismatch due to sample names being SRS while OTU names are SRRs

# Raymond and Vincent
## Both are on cMD so are fetched together
library(curatedMetagenomicData)
meta <- curatedMetagenomicData::sampleMetadata
submeta <- meta %>% filter(study_name=="VincentC_2016" | study_name=="RaymondF_2016")
rayvince <- returnSamples(submeta, "relative_abundance")

## Create Raymond dataset
ray <- subset(rayvince, select =colData(rayvince)$study_name=="RaymondF_2016")
raymond <- makePhyloseqFromTreeSummarizedExperiment(ray, abund_values = "relative_abundance")

## Create Vincent dataset
vince <- subset(rayvince, select=colData(rayvince)$study_name=="VincentC_2016")
vincent <- makePhyloseqFromTreeSummarizedExperiment(vince, abund_values = "relative_abundance")

# Yassour
phyloYassour <- import_biom("Yassour/taxa.biom")
metaYassour <- read.csv("Yassour/YassourM_2016_metadata.csv")
# One of the metadata rows is missing and should be removed
metaYassour$SampleID <- metaYassour$X.SampleID
metaYass <- metaYass[!is.na(metaYassour$SampleID)]
metaYass <- sample_data(metaYass)
sample_names(metaYass) <- metaYass$SampleID
sample_data(phyloYassour) <- metaYass
yassour <- phyloYassour

# Zaura
zaura <- import_biom("Zaura/taxa.biom")
sample_data(zaura)
