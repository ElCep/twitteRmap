twitteRmap
==========

Pour pouvoir utiliser ce script vous devez disposer d'un compte [twitter devel]
(https://dev.twitter.com/). Une fois que vous avez un token vous pouvez générer
une sorte de fichier de signature ('cred.RData'), en utilisant le code suivant :

        reqURL = "https://api.twitter.com/oauth/request_token"
        accessURL = "http://api.twitter.com/oauth/access_token"
        authURL = "http://api.twitter.com/oauth/authorize"
        consumerKey = "blabla"
        consumerSecret = "blabla"

        library(twitteR)
        twitCred = OAuthFactory$new(consumerKey=consumerKey,consumerSecret=consumerSecret,requestURL=reqURL,accessURL=accessURL,authURL=authURL)
        twitCred$handshake()
        save(twitCred, file="../cred.RData")

Vous êtes enfin en mesure de récupérer des tweets sur le sujet que vous souhaitez
avec le script [getTwittes.R](getTwittes.R), et je vous propose dans le script
[mapTwitteR.R](mapTwitteR.R) de générer une carte à partir de ces données.

Note : il vous vaudra un fond de carte au format shapeFile pour ça !
        
