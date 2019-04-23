# IRSAE R workshop, Kaloe
# Date April 22nd 2019
# Author Lars Dalby

library(tidyverse)
library(sf)

# Let's download an outline of Denmark
raster::getData("GADM", country = "DNK", level = 0) %>% 
  st_as_sf() -> dk

# and plot it
plot(dk["GID_0"], col = "lightgrey")

# Let's see where we are
c(10.4974418, 56.2976386) %>% 
  st_point() %>%
  st_sfc(crs = st_crs(dk)) -> jagtslottet

plot(dk["GID_0"], col = "lightgrey", reset = FALSE)
plot(jagtslottet, col = "blue", cex = 1, bg = "Steelblue1", pch = 21, add = TRUE)

# Interactive using mapview
library(mapview)
mapview(jagtslottet, map.types = "OpenStreetMap.Mapnik")

# Ggplot2 is currently too slow when plotting complex polygons (like dk here)
# Serious speedups are just around the corner (with the release of R 3.6 in April)
# But for e.g. a small number of points it's fine. 

# We use ggmap to get background maps
jagtslottet %>% 
  st_sf() %>% 
  st_transform(crs = 25832) %>% 
  st_buffer(1000) %>% 
  st_transform(crs = 4326) %>% 
  st_bbox() %>% 
  set_names(c("left", "bottom", "right", "top")) %>% 
  get_map(maptype = "toner-background",
          source = "osm") -> the_map

ggmap(the_map) + 
  geom_sf(data = jagtslottet,
          inherit.aes = FALSE,
          colour = "black",
          fill = "lightgrey",
          alpha = .5,
          size = 3,
          shape = 21) +
  theme_void()
  
# Your turn!
