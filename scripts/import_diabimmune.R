library(readxl)
setwd("/mnt/STORE1/bighome/cmirzayi/aim3/data")
meta <- read_excel("vatanen (diabimmune)/aad0917.SuppTable1 (3).xls")
otu <- read.delim(file="vatanen (diabimmune)/diabimmune.txt", header=TRUE, sep="\t", fill = TRUE)

head(otu)
import_qiime(otufilename = "vatanen (diabimmune)/diabimmune.txt")
