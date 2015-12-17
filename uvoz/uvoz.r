# 2. FAZA

library(rvest)
library(dplyr)
library(gsubfn)
library(httr)
library(XML)

naslov1 = "http://www.multpl.com/us-gdp-inflation-adjusted/table"
gdp <- htmlTreeParse(naslov1, encoding = "UTF-8", useInternal = TRUE)
gdp <- readHTMLTable(naslov1,which=1, stringsAsFactors = FALSE)
gdp[[1]] <- strapplyc(gdp[[1]], "([0-9]+)$") %>% as.numeric()
gdp[[2]] <- strapplyc(gdp[[2]], "^([0-9.]+)") %>% as.numeric()
colnames(gdp) <- c("Leto", "BDP (v trilijonih $)")
gdp <- gdp %>% filter(Leto <= 2014 & Leto >= 1950)


naslov2 = "http://www.multpl.com/us-real-gdp-per-capita/table/by-year"
gdppc <- htmlTreeParse(naslov2, encoding = "UTF-8", useInternal = TRUE)
gdppc <- readHTMLTable(naslov2,which=1, stringsAsFactors = FALSE)
gdppc[[1]] <- strapplyc(gdppc[[1]], "([0-9]+)$") %>% as.numeric()
gdppc[[2]] <- gsub(",", "", gdppc[[2]]) %>% as.numeric()
colnames(gdppc) <- c("Letnica", "BDP p.c. (v $)")
gdppc <- gdppc %>% filter(Letnica < 2015 & Letnica >= 1950)


naslov3 = "http://www.multpl.com/us-real-gdp-growth-rate/table/by-year"
gr <- htmlTreeParse(naslov3, encoding = "UTF-8", useInternal = TRUE)
gr <- readHTMLTable(naslov3,which=1, stringsAsFactors = FALSE)
gr[[1]] <- strapplyc(gr[[1]], "([0-9]+)$") %>% as.numeric()
gr[[2]] <- strapplyc(gr[[2]], "^([-, 0-9.]+)") %>% as.numeric()
colnames(gr) <- c("Letnica", "Stopnja razvoja")
gr <- gr %>% filter(Letnica <= 2014 & Letnica >=1950)


naslov4 = "http://www.usinflationcalculator.com/inflation/consumer-price-index-and-annual-percent-changes-from-1913-to-2008/"
cpi <- htmlTreeParse(naslov4, encoding = "UTF-8", useInternal = TRUE)
cpi <- readHTMLTable(naslov4,which=1, stringsAsFactors = FALSE)
cpi <- cpi[-c(1,2), c(1, 14)]
cpi <- apply(cpi, 1:2, . %>% as.character(.) %>% as.numeric(.)) %>% data.frame()
colnames(cpi) <- c("Letnica", "Indeks cen")
cpi <- cpi %>% filter(Letnica <= 2014 & Letnica >= 1950)
cpi <- cpi %>% arrange(desc(Letnica))


naslov5 = "http://www.usinflationcalculator.com/inflation/historical-inflation-rates/"
usinf <- htmlTreeParse(naslov5, encoding = "UTF-8", useInternal = TRUE)
usinf <- readHTMLTable(naslov5,which=1, stringsAsFactors = FALSE)
usinf <- usinf[-c(1), c(1, 14)]
usinf[[1]] <- strapplyc(usinf[[1]], "([0-9]+)$") %>% as.numeric()
usinf[[2]] <- strapplyc(usinf[[2]], "^([-, 0-9.]+)") %>% as.numeric()
colnames(usinf) <- c("Letnica", "Stopnja inflacije (v %)")
usinf <- usinf %>% filter(Letnica <= 2014 & Letnica >= 1950)
usinf <- usinf %>% arrange(desc(Letnica))


naslov6 = "http://www.multpl.com/unemployment/table"
unemp <- htmlTreeParse(naslov6, encoding = "UTF-8", useInternal = TRUE)
unemp <- readHTMLTable(naslov6,which=1, stringsAsFactors = FALSE)
unemp[[1]] <- strapplyc(unemp[[1]], "([0-9]+)$") %>% as.numeric()
unemp[[2]] <- strapplyc(unemp[[2]], "^([0-9.]+)") %>% as.numeric()
colnames(unemp) <- c("Letnica", "Stopnja brezposelnosti (v %)")
unemp <- unemp %>% filter(Letnica <= 2014 & Letnica >= 1950)


skupna.tabela <- cbind(gdp, gdppc, gr, cpi, usinf, unemp)

