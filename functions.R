# Load packages
library(knitr)
library(ggplot2)
library(devtools)
library(readr)
library(viridis)
library(here)
library(flextable)
library(dplyr)
library(tidyverse)
library(RODBC)
library(ggplot2)
library(getPass)


# Check the akfishcondition package is installed
if(!("akfishcondition" %in% installed.packages())) {
  devtools::install_github("afsc-gap-products/akfishcondition")
}

library(akfishcondition)
pkg_version <- packageVersion("akfishcondition")
