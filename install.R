#!/usr/bin/env Rscript

REPO = 'http://cran.rstudio.com/'
PKGS = c('devtools', 'repr', 'IRdisplay')

install.packages(PKGS, repos=REPO, quiet=TRUE)
devtools::install_github("IRkernel/IRkernel")
IRkernel::installspec(user = FALSE)

source('http://bioconductor.org/biocLite.R')
biocLite("ShortRead")

devtools::install_github('benjjneb/dada2')
