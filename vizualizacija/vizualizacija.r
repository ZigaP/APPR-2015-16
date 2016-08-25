#3. FAZA - UVOZ ZEMLJEVIDOV
zda <- uvozi.zemljevid("http://baza.fmf.uni-lj.si/states_21basic.zip", "states")

row.names(GSP) <- GSP[[1]]
GSP2 <- preuredi(GSP, zda, "STATE_NAME")

zda$GSP <- GSP2$`GSP..v.milijon...`
usa <- pretvori.zemljevid(zda)

##CONTINENTAL
ZEM_CONT <- usa %>% filter(! STATE_NAME %in% c("Alaska", "Hawaii"))

ZDA.K <- ggplot() + geom_polygon(data = ZEM_CONT,
                                aes(x = long, y = lat,
                                    group = group, fill = GSP), color = "grey")

ZDA.K <- ZDA.K + scale_fill_gradient(low = "#776633", high = "#443344")+ 
  guides(fill = guide_colorbar(title = "GSP (v milijardan $)")) + 
  ggtitle("BDP po zveznih državah (v milijardah $)")

ZDA.K <- ZDA.K + labs(x="", y="")+ scale_y_continuous(breaks=NULL)+ 
  scale_x_continuous(breaks=NULL)+ theme_minimal()


capitals.cont <- capitals %>% filter(! state %in% c("Alaska", "Hawaii"))


ZDA.K <- ZDA.K + geom_point(data = capitals.cont, color = "green", 
                          aes(x = long, y = lat, shape = US.capital, size = US.capital)) +
  geom_text(data = capitals.cont, 
            aes(x = long, y = lat, label = capital, vjust = US.capital, size = US.capital)) +
  scale_shape_manual(values = c(20, 15), guide = FALSE) + 
  scale_size_manual(values = c(3, 5), guide = FALSE) + 
  discrete_scale(aesthetics = "vjust", scale_name = NULL, palette = . %>% c(0, 2), guide = FALSE) 

print(ZDA.K)

#NE - CONTINENTAL

ZEM_NCONT <- usa %>% filter(STATE_NAME %in% c("Alaska", "Hawaii"))

ZDA.NK <- ggplot() + geom_polygon(data = ZEM_NCONT,
                                 aes(x = long, y = lat,
                                     group = group, fill = GSP), color = "grey")

ZDA.NK <- ZDA.NK + scale_fill_gradient(low = "#776633", high = "#443344")+ 
  guides(fill = guide_colorbar(title = "GSP (v milijardan $)")) + 
  ggtitle("BDP po zveznih državah (v milijardah $)")

ZDA.NK <- ZDA.NK + labs(x="", y="")+ scale_y_continuous(breaks=NULL)+ 
  scale_x_continuous(breaks=NULL)+ theme_minimal()


capitals.Ncont <- capitals %>% filter(state %in% c("Alaska", "Hawaii"))


ZDA.NK <- ZDA.NK + geom_point(data = capitals.Ncont, color = "green", 
                            aes(x = long, y = lat, shape = US.capital, size = US.capital)) +
  geom_text(data = capitals.Ncont, 
            aes(x = long, y = lat, label = capital, vjust = US.capital, size = US.capital)) +
  scale_shape_manual(values = c(20, 15), guide = FALSE) + 
  scale_size_manual(values = c(5, 8), guide = FALSE) + 
  discrete_scale(aesthetics = "vjust", scale_name = NULL, palette = . %>% c(0, 2), guide = FALSE) 

print(ZDA.NK)
