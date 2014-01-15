#Autors : E.DELAY (GEOLAB, université de Limoges (FR))and F.Zottele (Fondazion E.Mach (IT))
#Script merge data from twitteR script and map it with hexagon cell for couned twittes

rm(list=ls())

setwd("~/git/datablogvinometro/twitteR/data/csv/")
# library(lubridate)
# endDay = today()
# startDay = endDay - 1*weeks()


# dataToMap<-read.csv("dataToMap.csv", head=T)
##GGPLOTS maps
require("rgdal") # requires sp, will use proj.4 if installed
require("rgeos")
require("maptools")
require("hexbin")
require("ggplot2")
require("plyr")

##load files and merging
l.file<-list.files(path = ".")
AgrTwittes<-read.csv(paste(l.file[1]), head=T)
for (i in 2:length(l.file)){
  tps<-read.csv(paste(l.file[i]),head=T)
  AgrTwittes<-rbind(AgrTwittes,tps)
}




##Remove duplicated twittes
cleaner<-duplicated(AgrTwittes$date)
cleanTwittes<-AgrTwittes[!cleaner,]

cleanTwittes$date<-as.POSIXct(cleanTwittes$date)
##difint min and max for date
minT<-min(cleanTwittes$date)
maxT<-max(cleanTwittes$date)
nbTwittes<-length(cleanTwittes$date)

##readSHP
##Prepare word shp
word<-readOGR(dsn="../world/ne_110m_admin_0_countries.shp", layer="ne_110m_admin_0_countries")

#transforme shp to df for ggplot
word@data$id<-rownames(word@data)
word.point<-fortify(word,region="id")
word.df<-join(word.point,word@data, by="id")

a<-fortify(cleanTwittes)

#plot with ggplot
wp<-ggplot()+
  geom_polygon(data=word.df,aes(long,lat,group=group))+
  geom_hex(data=cleanTwittes,aes(lon,lat),bins = 55,alpha=8/10)+
  theme_bw()+
  labs(title = paste(nbTwittes,"twittes entre",minT,"et",maxT, "sur 'terroir'"))
  coord_equal()
print(wp)

