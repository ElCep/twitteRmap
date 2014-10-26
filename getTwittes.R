#Autors F.Zottele (Fondazion E.Mach (IT)) and E.DELAY (GEOLAB, université de Limoges (FR))
#Script for download 45 twittes with twitter API for dev


rm(list=ls())

setwd("~/git/datablogvinometro/twitteR/data/")
library(lubridate)
endDay = today()
startDay = endDay - 1*weeks()

library(twitteR)
load("../cred.RData")
registerTwitterOAuth(twitCred)

tweets = searchTwitter("terroir", n=45, since=as.character(startDay), until=as.character(endDay))
tweets = twListToDF(tweets)

userInfo = lookupUsers(tweets$screenName)
userFrame = twListToDF(userInfo)
locatedUsers = !is.na(userFrame$location)
userFrame = userFrame[locatedUsers,]

dataToMap <- data.frame()
library(ggmap)

for (i in 1:length(tweets[,1])) {
  if (!is.na(tweets$longitude[i])) {
    dataToMap = rbind(dataToMap,data.frame(date=tweets$created[i],lon=as.numeric(tweets$longitude[i]), lat=as.numeric(tweets$latitude[i])))
  } else {
    user = tweets$screenName[i]
    userIDX = which(userFrame$screenName==user)
    if (length(userIDX) > 0) {
      location = geocode(userFrame$location[userIDX],override_limit=TRUE,messaging=FALSE)
      dataToMap = rbind(dataToMap,data.frame(date=tweets$created[i],lon=location$lon[1], lat=location$lat[1]))
      Sys.sleep(1.5)
    }
  }
}

write.csv(dataToMap,paste("csv/data",Sys.time(),".csv",sep=""))
