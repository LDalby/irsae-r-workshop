# Solution to execises

library(tidyverse)
library(sf)
library(here)
library(readxl)
library(ggspatial)
library(rnaturalearth)
# Get simple outline of DK (faster to plot)
ne_countries(scale = "medium", country = "denmark", returnclass = "sf") %>% 
  st_transform(crs = 25832) -> dk

# layout a grid of point from which we will calculate distances
dk %>% 
  st_make_grid(cellsize = 5000, what = "centers") %>% 
  st_intersection(dk, .) -> dk_grid

# Turn the dk polygons into lines
dk %>% 
  st_cast("MULTILINESTRING") %>% 
  st_distance(dk_grid) %>% 
  units::set_units("km") %>% 
  as.numeric() -> coast_dist

dk_grid %>% 
  add_column(coast_dist) %>% 
  select(coast_dist) %>% 
  plot()

ggplot() + 
  geom_sf(data = dk_grid, aes(color = coast_dist)) +
  scale_color_viridis_c()


# Hunting stats exercise --------------------------------------------------
# Get the municipalities of DK
raster::getData("GADM", country = "DNK", level = 2)
here("gadm36_DNK_2_sp.rds") %>%
  readRDS() %>%
  st_as_sf() %>%
  janitor::clean_names() %>% 
  select(kommune = name_2) -> municip_dk

# Read in the file you downloaded with hunting stats
fs::path_home("Downloads", "vildtudbytte_2017_kommuner_Atlingand.csv") %>% 
  read_csv2(col_types = "ci") %>% 
  rename(kommune = omr,
         bag = antal) -> hunting_bag

# Let's see if the municipality names match
# Here dplyr::anti_join is really helpful
anti_join(municip_dk, hunting_bag, by = "kommune")
anti_join(hunting_bag, municip_dk, by = "kommune")
# Right, so we need to make these names match.
# GADM got Christiansø wrong, it's considered part of Bornholm.

municip_dk %>% 
  mutate(kommune = case_when(kommune == "Høje Taastrup" ~ "Høje-Taastrup",
                            kommune == "Århus" ~ "Aarhus",
                            kommune == "Christiansø" ~ "Bornholm",
                            kommune == "Brønderslev" ~ "Brønderslev-Dronninglund" ,
                            kommune == "Nordfyns" ~ "Nordfyn",
                            TRUE ~ kommune)) %>%
  group_by(kommune) %>%
  summarise(kommune_fix = unique(kommune)) -> municip_dk


left_join(municip_dk, hunting_bag, by = c("kommune_fix" = "kommune")) %>% 
  mapview::mapview(zcol = "bag")


# Forest exercise ---------------------------------------------------------
library(sf)
library(readxl)
read_sf(here("data", "forest", "forest.gpkg"),
        layer = "plots",
        as_tibble = TRUE) %>% 
  rename(pole_id = POLE_ID,
         plot_nr = PLOTNR_) -> plots

fs::dir_ls(here("data", "forest")) %>% 
  str_subset("vegetation-data") -> files

tibble(file_path = files) %>% 
  mutate(file_contents = map(file_path, ~ read_tsv(., col_types = "icccdc")),
         file_name = fs::path_file(file_path)) -> data

data %>% 
  select(-file_path) %>% 
  unnest() %>% 
  mutate(year = str_sub(file_name, end = 4)) -> veg_data

here("data", "forest", "plant-list.xlsx") %>%
  read_excel(.name_repair = janitor::make_clean_names) -> plants

plants %>% 
  select(standat_code, species = lat_spe, family = lat_fam) %>% 
  distinct() %>% 
  filter(str_count(species, "\\w+") >= 2) -> plants_cleaned

veg_data %>% 
  left_join(plants_cleaned, by = c("corrected_standatcode" = "standat_code")) %>% 
  drop_na() %>% 
  group_by(pole_id) %>% 
  summarise(richness = n_distinct(species)) -> richness

plots %>% 
  left_join(richness) %>% 
  st_transform(crs = 4326) -> forest_inventory

ggplot() +
  # loads background map tiles from a tile source
  annotation_map_tile(zoomin = -1) +
  layer_spatial(forest_inventory, aes(color = richness), size = 3) +
  scale_color_viridis_c()

# Grasses
veg_data %>% 
  left_join(plants_cleaned, by = c("corrected_standatcode" = "standat_code")) %>% 
  drop_na() %>% 
  filter(family == "Poaceae") %>% 
  group_by(pole_id) %>% 
  summarise(richness = n_distinct(species)) %>% 
  arrange(desc(richness))
  