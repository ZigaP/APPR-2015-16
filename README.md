# Analiza podatkov s programom R, 2015/16

Avtor - Žiga Potrebuješ

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2015/16.

## Analiza ameriškega BDP od leta 1950 naprej

V projektu bom analiziral gibanje šestih spremenljivk - realni BDP ($), realni BDP p.c. ($), rast realnega BDP, CPI, inflacijo in stopnjo brezposelnosti v Ameriki - od leta 1950 naprej. Cilj je opaziti vzorce gibanja teh spremenljivk skozi čas, ter vpliv nemirnejših obdobjih na njih.

Podatke bom pridobival na:
- http://www.multpl.com/us-gdp-inflation-adjusted/table
- http://www.multpl.com/us-real-gdp-per-capita
- http://www.multpl.com/us-real-gdp-growth-rate/table/by-year
- http://www.usinflationcalculator.com/inflation/consumer-price-index-and-annual-percent-changes-from-1913-to-2008/
- http://www.usinflationcalculator.com/inflation/historical-inflation-rates/
- http://www.multpl.com/unemployment/

## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`. Ko ga prevedemo,
se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`. Podatkovni
viri so v mapi `podatki/`. Zemljevidi v obliki SHP, ki jih program pobere, se
shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Spletni vmesnik

Spletni vmesnik se nahaja v datotekah v mapi `shiny/`. Poženemo ga tako, da v
RStudiu odpremo datoteko `server.R` ali `ui.R` ter kliknemo na gumb *Run App*.
Alternativno ga lahko poženemo tudi tako, da poženemo program `shiny.r`.

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `maptools` - za uvoz zemljevidov
* `sp` - za delo z zemljevidi
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `httr` - za pobiranje spletnih strani
* `XML` - za branje spletnih strani
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)
