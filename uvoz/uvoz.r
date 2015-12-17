# 2. FAZA

library(rvest)
library(dplyr)
library(gsubfn)
library(httr)
library(XML)

naslov1 = "http://www.multpl.com/us-gdp-inflation-adjusted/table"
gdp <- htmlTreeParse(naslov1, encoding = "UTF-8", useInternal = TRUE)
gdp <- readHTMLTable(naslov1,which=1)


naslov2 = "http://www.multpl.com/us-real-gdp-per-capita/table/by-year"
gdppc <- htmlTreeParse(naslov2, encoding = "UTF-8", useInternal = TRUE)
gdppc <- readHTMLTable(naslov2,which=1)
gdppc <- gdppc[-c(1, 2, 67:nrow(gdppc)),]


naslov3 = "http://www.multpl.com/us-real-gdp-growth-rate/table/by-year"
gr <- htmlTreeParse(naslov3, encoding = "UTF-8", useInternal = TRUE)
gr <- readHTMLTable(naslov3,which=1)

naslov4 = "http://www.usinflationcalculator.com/inflation/consumer-price-index-and-annual-percent-changes-from-1913-to-2008/"
cpi <- htmlTreeParse(naslov4, encoding = "UTF-8", useInternal = TRUE)
cpi <- readHTMLTable(naslov4,which=1)
cpi <- cpi[-c(1:3, nrow(cpi)), -c(1:13)]
cpi <- apply(cpi, 2, . %>% as.character(.) %>% as.numeric(.)) %>% data.frame()

naslov5 = "http://www.usinflationcalculator.com/inflation/historical-inflation-rates/"
usinf <- htmlTreeParse(naslov5, encoding = "UTF-8", useInternal = TRUE)
usinf <- readHTMLTable(naslov5,which=1)
usinf <- usinf[c(1, 14), -c(1:37)]

naslov6 = "http://www.multpl.com/unemployment/table"
unemp <- htmlTreeParse(naslov6, encoding = "UTF-8", useInternal = TRUE)
unemp <- readHTMLTable(naslov6,which=1)

skupna <- cbind(cpi, cpi, cpi)

