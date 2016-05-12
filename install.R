#!/usr/bin/env Rscript

REPO = c('http://irkernel.github.io/', 'http://cran.rstudio.com/')
PKGS = c('devtools', 'repr', 'IRkernel', 'IRdisplay')

install.packages(PKGS, repos=REPO, quiet=TRUE)
IRkernel::installspec(user = FALSE)

source('http://bioconductor.org/biocLite.R')
biocLite()

devtools::install_github('benjjneb/dada2')
