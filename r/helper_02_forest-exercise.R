# Make data for names demo
library(tidyverse)
library(lubridate)
library(here)
library(glue)
library(readxl)
library(pathfinder)

read_sf("/Users/au206907/Downloads/lada/plot_proj.shp",
        as_tibble = TRUE) -> plots

write_sf(plots, dsn = here("data", "forest", "forest.gpkg"), layer = "plots")

path_desktop("fs_kalo", "vegetation-data-kalo.xlsx") %>%
  read_excel(.name_repair = janitor::make_clean_names) -> veg_data

veg_data %>% 
  group_by(year) %>% 
  nest() %>% 
  mutate(foo = walk2(year, data, ~ write_tsv(.y, path = here("data",glue("{.x}_vegetation-data-kalo.tsv")))))




