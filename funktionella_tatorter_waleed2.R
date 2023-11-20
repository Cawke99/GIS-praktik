# Regionala noder

#1 Funktionella tätorter
# består av småorter som ska slås samman i Dalarna - merge

#2 Skapa en buffer på 400 m runt varje ort i Dalarna


# libraries
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, sf, sp, httr, mapview, leaflet, dplyr)


# ChatGPTs lösning på hur vi skulle få in hela, valda, kommuner via kommunkod

# File path to GeoPackage
deso_fil <- "DeSO_2018_v2.gpkg"

# Read spatial data
deso <- st_read(deso_fil)
lan_kod <- "20"
dalarna_lan <- deso %>% 
  filter(lan == lan_kod) %>% 
  group_by (lan, lannamn) %>% 
  summarize(geom = st_union(geom)) %>% 
  ungroup()

# Define lan_kod
#lan_kod <- c("20", "19", "17", "21", "23", "18", "03")



####### lägg till filter på smaorter, tatorter och fritidshus (rad 32-53) ##########

smaorter_fil <- "Smaorter_1990_2020.gpkg"
smaorter <- st_layers(smaorter_fil)

smaorter <- st_read(smaorter_fil, layer = "So2020_SR99TM", crs = 3006)

  
#print(smaorter)
#mapview(smaorter)


tatorter_fil <- "Tatorter_1980_2020.gpkg"
tatorter <- st_layers(tatorter_fil)
print(tatorter)
tatorter <- st_read(tatorter_fil, layer = "To2020_SR99TM", crs = 3006)

fritidshus_fil <- "Fritidshusomraden_2000_2020.gpkg"
fritidshus <- st_layers(fritidshus_fil)
print(fritidshus)
fritidshus <- st_read(fritidshus_fil, layer = "Fo2020_SR99TM", crs = 3006)



osm_landuse_fil <- "gis_osm_landuse_a_free_1.shp"
osm_landuse <- st_read(osm_landuse_fil)
glimpse(osm_landuse)

#osm_landuse <- osm_landuse %>% 
  #st_transform(crs = 3006)
#st_crs(osm_landuse)

#industri_omr <- osm_landuse %>% 
  #filter(fclass == "industrial")
# 
# handels_omr <- osm_landuse %>% 
#   filter(fclass == "retail")
# 
# commerc_omr <- osm_landuse %>% 
#   filter(fclass == "commercial")



#mapview(industri_dalarna, col.regions = "grey") +
# mapview(handel_dalarna, col.regions = "blue") +
# mapview(commerciell_dalarna, col.regions = "red") + 
# mapview(lan, zcol = "lan", alpha.regions = 0.5) +
# mapview(smaorter, col.regions = "orange") +
# mapview(tatorter, col.regions = "darkorange") +
# mapview(fritidshus, col.regions = "green")

# Tatorter <- 


#mapview(osm_landuse)

# Buffer 400 m

##############################################################################
############# Regionala noder endast Dalarnas Län ############################
##############################################################################


landuse_lan <- st_intersection(dalarna_lan, osm_landuse)
# summary(landuse_lan)
# mapview(landuse_lan)


industri_omr <- landuse_lan %>% 
  filter(fclass == "industrial")
mapview(landuse_lan)

handels_omr <- osm_landuse %>% 
  filter(fclass == "retail")

commerc_omr <- osm_landuse %>% 
  filter(fclass == "commercial")



# Skapa urval för smaorter, tatorter och fritidshus i Dalarnas län



################ Göra urval för lager inom Dalarnas län #####################

smaorter_dalarna <- st_intersection(dalarna_lan, smaorter)
tatorter_dalarna <- st_intersection(dalarna_lan, tatorter)
fritidshus_dalarna <- st_intersection(dalarna_lan, fritidshus)

industri_dalarna <- st_intersection(dalarna_lan, industri_omr)
#mapview(industri_dalarna)

handel_dalarna <- st_intersection(dalarna_lan, handels_omr)
#mapview(handel_dalarna)

commerciell_dalarna <- st_intersection(dalarna_lan, commerc_omr)


mapview(industri_dalarna, col.regions = "grey") +
  mapview(handel_dalarna, col.regions = "blue") +
  mapview(commerciell_dalarna, col.regions = "red") + 
  # mapview(lan, zcol = "lan", alpha.regions = 0.5) +
  mapview(smaorter_dalarna, col.regions = "orange") +
  mapview(tatorter_dalarna, col.regions = "darkorange") +
  mapview(fritidshus_dalarna, col.regions = "green") +
  mapview(dalarna_lan, zcol = "lannamn", alpha.regions = 0.1)


################## Buffert 400 m #######################

smaorter_buffer <- st_intersection(dalarna_lan, smaorter) %>% 
  st_buffer(400)

tatorter_buffer <- st_intersection(dalarna_lan, tatorter) %>% 
  st_buffer(400)

fritidshus_buffer <- st_intersection(dalarna_lan, fritidshus) %>% 
  st_buffer(400)

industri_buffer <- st_intersection(dalarna_lan, industri_omr) %>% 
  st_buffer(400)

handel_buffer <- st_intersection(dalarna_lan, handels_omr) %>% 
  st_buffer(400)

commerciell_buffer <- st_intersection(dalarna_lan, commerc_omr) %>% 
  st_buffer(400)

#spatial join

handel_com <- st_join(handel_buffer, commerciell_buffer, join=st_intersects)
mapview(handel_com, col.regions="green")+
  mapview(handel_buffer, col.regions="blue")+
  mapview(commerciell_buffer, col.regions="red")

mapview(smaorter_buffer) + mapview(smaorter_dalarna)


mapview(industri_buffer, col.regions = "grey") +
  mapview(handel_buffer, col.regions = "blue") +
  mapview(commerciell_buffer, col.regions = "red") + 
  # mapview(lan, zcol = "lan", alpha.regions = 0.5) +
  mapview(smaorter_buffer, col.regions = "orange") +
  mapview(tatorter_buffer, col.regions = "darkorange") +
  mapview(fritidshus_buffer, col.regions = "green") +
  mapview(dalarna_lan, zcol = "lannamn", alpha.regions = 0.1)
