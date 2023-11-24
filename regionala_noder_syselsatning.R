# Regionala noder
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

dalarna_kommuner <- deso %>% 
  filter(lan == lan_kod) %>% 
  group_by (kommun, kommunnamn) %>% 
  summarize(geom = st_union(geom)) %>% 
  ungroup()

tatorter_fil <- "Tatorter_1980_2020.gpkg"
tatorter <- st_layers(tatorter_fil)
print(tatorter)
tatorter <- st_read(tatorter_fil, layer = "To2020_SR99TM", crs = 3006)

tatorter_dalarna <- st_intersection(dalarna_lan, tatorter)
tatorter_buffer <- st_intersection(dalarna_lan, tatorter) %>% 
  st_buffer(400)

bef <- "dag_bef_1kmruta.gpkg"

dag_bef <- st_read(bef)

bef_centroid <- dag_bef %>% 
  st_centroid()

tatort_bef <- st_join(tatorter_buffer, bef_centroid, join=st_intersects)

tatort_bef <- tatort_bef %>% 
  group_by(TATORT) %>% 
  summarize(tot_pop=sum(dagbef))


mapview(tatort_bef, zcol="tot_pop")
View(tatort_bef)
Tatort_cent_dagbef <- tatort_bef %>% 
  st_centroid() %>% 
  filter(tot_pop>=100)
mapview(dalarna_kommuner, lwd=1, alpha.regions=0.3, zcol="kommun", legend=FALSE)+
  mapview(dalarna_lan, lwd=3, alpha.regions=0, legend=FALSE)+
  mapview(Tatort_cent_dagbef, cex="tot_pop", legend= FALSE)

mapview(list(dalarna_kommuner, dalarna_lan, Tatort_cent_dagbef),
        zcol=list("kommun", NULL, "TATORT"), 
        lwd=list(1,3,0), 
        legend=list(FALSE, FALSE, FALSE),
        cex=list(NULL, NULL, "tot_pop"), 
        alpha.regions=list(0.3, 0, 0.7))














