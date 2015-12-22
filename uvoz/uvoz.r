# 2. FAZA
library(rvest)
library(dplyr)
library(gsubfn)
library(httr)
library(XML)
library(ggplot2)


naslov1 = "http://www.multpl.com/us-gdp-inflation-adjusted/table"
gdp <- readHTMLTable(naslov1, which=1, encoding = "UTF-8", stringsAsFactors = FALSE)
gdp[[1]] <- strapplyc(gdp[[1]], "([0-9]+)$") %>% as.numeric()
gdp[[2]] <- strapplyc(gdp[[2]], "^([0-9.]+)") %>% as.numeric()
colnames(gdp) <- c("Leto", "BDP (v trilijonih $)")
gdp <- gdp %>% filter(Leto <= 2014 & Leto >= 1950)
gdp <- gdp %>% arrange(Leto)


naslov2 = "http://www.multpl.com/us-real-gdp-per-capita/table/by-year"
gdppc <- readHTMLTable(naslov2, which=1, encoding = "UTF-8", stringsAsFactors = FALSE)
gdppc[[1]] <- strapplyc(gdppc[[1]], "([0-9]+)$") %>% as.numeric()
gdppc[[2]] <- gsub(",", "", gdppc[[2]]) %>% as.numeric()
colnames(gdppc) <- c("Leto", "BDPp.c. (v $)")
gdppc <- gdppc %>% filter(Leto < 2015 & Leto >= 1950)
gdppc <- gdppc %>% arrange(Leto)


naslov3 = "http://www.multpl.com/us-real-gdp-growth-rate/table/by-year"
gr <- readHTMLTable(naslov3, which=1, encoding = "UTF-8", stringsAsFactors = FALSE)
gr[[1]] <- strapplyc(gr[[1]], "([0-9]+)$") %>% as.numeric()
gr[[2]] <- strapplyc(gr[[2]], "^([-, 0-9.]+)") %>% as.numeric()
colnames(gr) <- c("Leto", "Stopnja rasti")
gr <- gr %>% filter(Leto <= 2014 & Leto >=1950)
gr <- gr %>% arrange(Leto)


naslov4 = "http://www.usinflationcalculator.com/inflation/consumer-price-index-and-annual-percent-changes-from-1913-to-2008/"
cpi <- htmlTreeParse(naslov4, encoding = "UTF-8", useInternal = TRUE)
cpi <- readHTMLTable(naslov4,which=1, stringsAsFactors = FALSE)
cpi <- cpi[-c(1,2), c(1, 14)]
cpi <- apply(cpi, 2, . %>% strapplyc("([0-9.]+)") %>% as.numeric(.)) %>% data.frame()
colnames(cpi) <- c("Leto", "Indeks cen")
cpi <- cpi %>% filter(Leto <= 2014 & Leto >= 1950)
cpi <- cpi %>% arrange(Leto)


naslov5 = "http://www.usinflationcalculator.com/inflation/historical-inflation-rates/"
usinf <- readHTMLTable(naslov5, which=1, encoding = "UTF-8", stringsAsFactors = FALSE)
usinf <- usinf[-c(1), c(1, 14)]
usinf[[1]] <- strapplyc(usinf[[1]], "([0-9]+)$") %>% as.numeric()
usinf[[2]] <- strapplyc(usinf[[2]], "^([-, 0-9.]+)") %>% as.numeric()
colnames(usinf) <- c("Leto", "Stopnja inflacije (v %)")
usinf <- usinf %>% filter(Leto <= 2014 & Leto >= 1950)
usinf <- usinf %>% arrange(Leto)


naslov6 = "http://www.multpl.com/unemployment/table"
unemp <- readHTMLTable(naslov6, which=1, encoding = "UTF-8", stringsAsFactors = FALSE)
unemp[[1]] <- strapplyc(unemp[[1]], "([0-9]+)$") %>% as.numeric()
unemp[[2]] <- strapplyc(unemp[[2]], "^([0-9.]+)") %>% as.numeric()
colnames(unemp) <- c("Leto", "Stopnja brezposlenosti (v %)")
unemp <- unemp %>% filter(Leto <= 2014 & Leto >= 1950)
unemp <- unemp %>% arrange(Leto)


skupna.tabela <- cbind(gdp, gdppc, gr, cpi, usinf, unemp)
skupna.tabela <- skupna.tabela[names(skupna.tabela) != "Leto"]
rownames(skupna.tabela) <- c(1950:2014)


### GRAFI
graf1 <- ggplot(data = gdp, aes(x=Leto, y=`BDP (v trilijonih $)`))+geom_line(color='red')+
                            ggtitle("BDP")
graf2 <- ggplot(data = gdppc, aes(x=Leto, y=`BDPp.c. (v $)`))+geom_line(color='green')+
                            ggtitle("BDP per capita skozi leta")
graf3 <- ggplot(data = gr, aes(x=Leto, y=`Stopnja rasti`))+geom_line(color='blue')+
                            ggtitle("Stopnja rasti skozi leta")
graf4 <- ggplot(data = cpi, aes(x=Leto, y=`Indeks cen`))+geom_line(color='orange')+
                            ggtitle("Spreminjanje indeksa cen")
graf5 <- ggplot(data = usinf, aes(x=Leto, y=`Stopnja inflacije (v %)`))+geom_line(color='purple')+
                            ggtitle("Spreminjanje inflacije v ZDA")
graf6 <- ggplot(data = unemp, aes(x=Leto, y=`Stopnja brezposlenosti (v %)`))+geom_line(color='black')+
                            ggtitle("Brezposelnost skozi leta")
