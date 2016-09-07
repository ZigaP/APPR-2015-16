# 4. faza: Analiza podatkov
source("lib/libraries.r", encoding = "UTF-8")

## GRUPIRANJE

rownames(GSP) <- GSP$Država
GSP <- GSP[-1]

n <- 5 #DRŽAVE NA 5 skupin

GSP.norm <- scale(GSP,scale=FALSE) #povprečje BDP ter tabela po regijah z odstopanji od povprečja..
k <- kmeans(GSP.norm, n, nstart = 1000) #države razdelim v 5 skupin glede na povprečja
drzave <- row.names(GSP)
m <- match(zda$STATE_NAME, drzave)
zda$skupina <- factor(k$cluster[drzave[m]])


ZEM1 <- ggplot() + geom_polygon(data = pretvori.zemljevid(zda), 
                                aes(x=long, y=lat, group=group, fill=skupina),
                                color = "grey")

ZEM1 <- ZEM1 + labs(x="", y="")+
  scale_y_continuous(breaks=NULL)+
  scale_x_continuous(breaks=NULL)+
  theme_minimal()


##CENTROIDI
razdalje <- apply(k$centers, 1, function(y) apply(GSP.norm, 1, function(x) sum((x-y)^2)))
min.razdalje <- apply(razdalje, 2, min)
manj.razdalje <- apply(razdalje, 1, function(x) x == min.razdalje)
najblizje <- apply(manj.razdalje[,apply(manj.razdalje, 2, any)], 2, which)
centroidi <- names(najblizje)[order(najblizje)]

capitals.cent <- capitals %>% filter(state %in% centroidi)

ZEM1 <- ZEM1 + geom_point(data = capitals.cent, color = "black", 
                              aes(x = long, y = lat, shape = US.capital, size = US.capital)) +
  geom_text(data = capitals.cent, 
            aes(x = long, y = lat, label = state, vjust = US.capital, size = US.capital)) +
  scale_shape_manual(values = c(20,15), guide = FALSE) + 
  scale_size_manual(values = c(3, 5), guide = FALSE) + 
  discrete_scale(aesthetics = "vjust", scale_name = NULL, palette = . %>% c(0, 2), guide = FALSE) 


ZEM1 <- ZEM1 + ggtitle("Centroidi")
#print(ZEM1)


###
model.loess <- loess(data = gdp, Leto ~ gdp$`BDP (v trilijonih $)`)
aprbdp <- graf1 + geom_smooth(method = "loess")
sum(model.loess$residuals^2) # 70.56724

model.lm <- lm(data = gdp, Leto ~ gdp$`BDP (v trilijonih $)`)
aprbdp2 <- graf1 + geom_smooth(method = "lm")
sum(model.lm$residuals^2) # 782.3755

### NAREDIM NAPOVEDI, ZA BDP V LETIH 2016:2030 V ZDA

model.lm <- lm(data = gdp, gdp$`BDP (v trilijonih $)`~  Leto  )
Napoved <- predict(model.lm, data.frame(Leto = seq(2016,2030,1)))
NAPOVED  <- data.frame(Napoved, row.names = (2016:2030))

