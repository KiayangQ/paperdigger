
<!-- README.md is generated from README.Rmd. Please edit that file -->

# paperdigger

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The goal of paperdigger is to automatically download academic paper from
sci-hub

## Installation

You can install the package from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("KiayangQ/paperdigger")
```

## usage

To call the shinyapp

``` r
library(paperdigger)
## basic example code
paper_dig()
```

To use the R function

``` r
library(paperdigger)
## basic example code
sci_loc("ad.bib",original="Database)
```
