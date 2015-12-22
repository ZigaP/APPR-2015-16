library(rvest)
library(dplyr)
library(gsubfn)
library(httr)
library(XML)
require(ggplot2)

# Uvozimo funkcije za pobiranje in uvoz zemljevida.
source("lib/uvozi.zemljevid.r", encoding = "UTF-8")