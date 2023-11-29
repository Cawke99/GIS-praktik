#Ladda ner data från inbyggt dataset i R och skapa en dataframe med namnet "data" som innehåller geometri och attributdata
#download data 
#download library contain getdata function
install.packages("raster")
library(raster)
library(dplyr)
library(sf)
library(mapview)
#data av göteborgs kommun
data <- getData("GADM", country = "SWE", level = 2)
mapview(data)
#välj bara göteborgs kommun
data <- data[data$NAME_2 == "Göteborg",]
mapview(data)
#visa kommuner i göteborgs kommun
#visa vägar i göteborgs kommun
#visa motorvägar i göteborgs kommun
#visa järnvägar i göteborgs kommun
