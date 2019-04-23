# Make data for names demo
library(tidyverse)
library(lubridate)
library(here)
library(glue)
library(readxl)
library(pathfinder)

read_sf("/Users/au206907/Desktop/fs_kalo/KaloGIS/temaer/plot.shp",
        as_tibble = TRUE,
        crs = 25832) %>% 
  rename(pole_id = POLE_ID,
         plot_nr = PLOTNR_) -> plots

write_sf(plots, dsn = here("data", "forest", "forest.gpkg"), layer = "plots")

path_desktop("fs_kalo", "vegetation-data-kalo.xlsx") %>%
  read_excel(.name_repair = janitor::make_clean_names) -> veg_data

veg_data %>% 
  group_by(year) %>% 
  nest() %>% 
  mutate(foo = walk2(year, data, ~ write_tsv(.y, path = here("data",glue("{.x}_vegetation-data-kalo.tsv")))))


fs::dir_ls(here("data", "forest")) %>% 
  str_subset("vegetation-data") -> files

tibble(file_path = files) %>% 
  mutate(file_contents = map(file_path, ~ read_tsv(., col_types = "icccdc")),
         file_name = fs::path_file(file_path)) -> data

data %>% 
  select(-file_path) %>% 
  unnest() %>% 
  mutate(year = str_sub(file_name, end = 4))

