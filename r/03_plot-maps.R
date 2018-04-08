# IRSAE R workshop, Kaloe
# Date April 9th 2018
# Author Lars Dalby

library(tidyverse)
library(sf)

# We'll be needing the development version of ggplot2, so let's grab that one
devtools::install_github("tidyverse/ggplot2")
library(ggplot2)

# Let's download an outline of Denmark
raster::getData("GADM", country = "DNK", level = 1) %>% 
  st_as_sf() -> dk

# and plot it
ggplot(dk) +
  geom_sf() + 
  theme_bw()

# Let's see where we are
c(10.4974418, 56.2976386) %>% 
  st_point() %>%
  st_sfc(crs = st_crs(dk)) %>% 
  st_sf() -> jagtslottet

ggplot(dk) +
  geom_sf() + 
  geom_sf(data = jagtslottet, color = "blue", size = 3) +
  theme_bw()

# Interactive using mapview
library(mapview)
mapview(jagtslottet, map.types = "OpenStreetMap.Mapnik")


