# This script allow you to quick clean your R session
# update documentation and NAMESPACE, localy install the package
# and run the main shinyapp from 'inst/app'
.rs.api.documentSaveAll() # close and save all open file
suppressWarnings(lapply(paste('package:',names(sessionInfo()$otherPkgs),sep=""),detach,character.only=TRUE,unload=TRUE))
rm(list=ls(all.names = TRUE))
 devtools::document(".")
 devtools::load_all(".")

# options(app.prod=FALSE) # TRUE = production mode, FALSE = development mode
# shiny::runApp('inst/app')

ac <- createTdrContext(configFile = getOption("inndxrs.config"), svrname = "Azure")
ac

ac$companies




servername <- "Azure"

str(ac$tdrservers)
servers <- tibble::as_tibble(ac$tdrservers)
server <-  dplyr::filter(servers, servername ==  "Azure")


wd <- here::here()

servers_file <- "C:/Users/MartinduToit/Documents/data-projects/inndxr/inst/app/data/servers.RData"
load(file = servers_file)
View(servers)


cc <- read.inndxrs.config(configFile = getOption("inndxrs.config"))
str(cc)


str(cc$tdrservers)


# i <- 1
# s1 <- list(servername = servers$servername[i], driver = servers$driver[i], serverurl = servers$server[i], database = servers$database[i], uid = servers$uid[i], pwd = servers$pwd[i], port = servers$port[i])
# i <- 2
# s2 <- list(servername = servers$servername[i], driver = servers$driver[i], serverurl = servers$server[i], database = servers$database[i], uid = servers$uid[i], pwd = servers$pwd[i], port = servers$port[i])
# i <- 3
# s3 <- list(servername = servers$servername[i], driver = servers$driver[i], serverurl = servers$server[i], database = servers$database[i], uid = servers$uid[i], pwd = servers$pwd[i], port = servers$port[i])
#
# cc[[6]] <- list(s1, s2, s3)
#
#
# nn <- names(cc)
#
# nn[6] <- "tdrservers"
#
# names(cc) <- nn
#
# configFile = getOption("inndxrs.config")
#
# jsonlite::toJSON(cc)
