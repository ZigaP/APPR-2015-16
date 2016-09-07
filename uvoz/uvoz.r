# 2. FAZA
source("lib/libraries.r", encoding = "UTF-8")


naslov1 = "http://www.multpl.com/us-gdp-inflation-adjusted/table"
gdp <- readHTMLTable(naslov1, which=1, encoding = "UTF-8", stringsAsFactors = FALSE)
gdp[[1]] <- strapplyc(gdp[[1]], "([0-9]+)$") %>% as.numeric()
gdp[[2]] <- strapplyc(gdp[[2]], "^([0-9.]+)") %>% as.numeric()
colnames(gdp) <- c("Leto", "BDP (v trilijonih $)")
gdp <- gdp %>% filter(Leto <= 2015 & Leto >= 1950)
gdp <- gdp %>% arrange(Leto)



naslov2 = "http://www.multpl.com/us-real-gdp-per-capita/table/by-year"
gdppc <- readHTMLTable(naslov2, which=1, encoding = "UTF-8", stringsAsFactors = FALSE)
gdppc[[1]] <- strapplyc(gdppc[[1]], "([0-9]+)$") %>% as.numeric()
gdppc[[2]] <- gsub(",", "", gdppc[[2]]) %>% as.numeric()
colnames(gdppc) <- c("Letnica", "BDPp.c. (v $)")
gdppc <- gdppc %>% filter(Letnica <= 2015 & Letnica >= 1950)
gdppc <- gdppc %>% arrange(Letnica)


naslov3 = "http://www.multpl.com/us-real-gdp-growth-rate/table/by-year"
gr <- readHTMLTable(naslov3, which=1, encoding = "UTF-8", stringsAsFactors = FALSE)
gr[[1]] <- strapplyc(gr[[1]], "([0-9]+)$") %>% as.numeric()
gr[[2]] <- strapplyc(gr[[2]], "^([-, 0-9.]+)") %>% as.numeric()
colnames(gr) <- c("Letnica", "Stopnja rasti")
gr <- gr %>% filter(Letnica <= 2015 & Letnica >=1950)
gr <- gr %>% arrange(Letnica)


naslov4 = "http://www.usinflationcalculator.com/inflation/consumer-price-index-and-annual-percent-changes-from-1913-to-2008/"
cpi <- htmlTreeParse(naslov4, encoding = "UTF-8", useInternal = TRUE)
cpi <- readHTMLTable(naslov4,which=1, stringsAsFactors = FALSE)
cpi <- cpi[-c(1,2), c(1, 14)]
cpi <- apply(cpi, 2, . %>% strapplyc("([0-9.]+)") %>% as.numeric(.)) %>% data.frame()
colnames(cpi) <- c("Letnica", "Indeks cen")
cpi <- cpi %>% filter(Letnica <= 2015 & Letnica >= 1950)
cpi <- cpi %>% arrange(Letnica)


naslov5 = "http://www.usinflationcalculator.com/inflation/historical-inflation-rates/"
usinf <- readHTMLTable(naslov5, which=1, encoding = "UTF-8", stringsAsFactors = FALSE)
usinf <- usinf[-c(1), c(1, 14)]
usinf[[1]] <- strapplyc(usinf[[1]], "([0-9]+)$") %>% as.numeric()
usinf[[2]] <- strapplyc(usinf[[2]], "^([-, 0-9.]+)") %>% as.numeric()
colnames(usinf) <- c("Letnica", "Stopnja inflacije (v %)")
usinf <- usinf %>% filter(Letnica <= 2015 & Letnica >= 1950)
usinf <- usinf %>% arrange(Letnica)


naslov6 = "http://www.multpl.com/unemployment/table"
unemp <- readHTMLTable(naslov6, which=1, encoding = "UTF-8", stringsAsFactors = FALSE)
unemp[[1]] <- strapplyc(unemp[[1]], "([0-9]+)$") %>% as.numeric()
unemp[[2]] <- strapplyc(unemp[[2]], "^([0-9.]+)") %>% as.numeric()
colnames(unemp) <- c("Letnica", "Stopnja brezposlenosti (v %)")
unemp <- unemp %>% filter(Letnica <= 2015 & Letnica >= 1950)
unemp <- unemp %>% arrange(Letnica)


skupna.tabela <- cbind(gdp, gdppc, gr, cpi, usinf, unemp)
skupna.tabela <- skupna.tabela[names(skupna.tabela) != "Letnica"]

skupna.tabela2 <- skupna.tabela %>% arrange(-Leto)

naslov7 <- "http://www.usgovernmentspending.com/gdp_by_state" 
stran <- html_session(naslov7) %>% read_html(encoding = "UTF-8") 
GSP_tabele <- stran %>% html_nodes(xpath ="//table") 
GSP <- GSP_tabele %>% .[[7]] %>% html_table(fill = TRUE) 
GSP <- GSP[c(-1,-46,-54),c(2,5)] 
names(GSP) <- c("Država", "GSP (v milijon $)") 
GSP[2] <- apply(GSP[2], 2, .%>% gsub("\\$", "", .) %>% gsub("\\,", "", .)) %>% as.numeric()
GSP3 <- GSP %>% arrange (`GSP (v milijon $)`)



### GRAFI
graf1 <- ggplot(data = gdp, aes(x=Leto, y=`BDP (v trilijonih $)`), height=5, width=5)+
                            geom_line(size=1, color='red')+ggtitle("BDP")
graf2 <- ggplot(data = gdppc, aes(x=Letnica, y=`BDPp.c. (v $)`))+geom_line(size=1, color='darkgreen')+
                            ggtitle("BDP per capita skozi leta")
graf3 <- ggplot(data = gr, aes(x=Letnica, y=`Stopnja rasti`))+geom_line(size=1, color='blue')+
                            ggtitle("Stopnja rasti skozi leta (v%)")
graf4 <- ggplot(data = cpi, aes(x=Letnica, y=`Indeks cen`))+geom_line(size=1, color='orange')+
                            ggtitle("Spreminjanje indeksa cen")
graf5 <- ggplot(data = usinf, aes(x=Letnica, y=`Stopnja inflacije (v %)`))+geom_line(size=1, color='purple')+
                            ggtitle("Stopnja inflacije v ZDA (v %)")
graf6 <- ggplot(data = unemp, aes(x=Letnica, y=`Stopnja brezposlenosti (v %)`))+geom_line(size=1, color='black')+
                            ggtitle("Brezposelnost skozi leta (v %)")



