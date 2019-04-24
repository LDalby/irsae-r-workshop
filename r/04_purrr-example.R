# IRSAE R workshop, Kaloe
# Date April 24th 2019
# Author Lars Dalby
# This example is adapted from:
# https://serialmentor.com/blog/2016/6/13/reading-and-combining-many-tidy-data-files-in-R

library(tidyverse)
library(lubridate)

fs::dir_ls(here("data")) %>% 
  str_subset("soil_data") -> files

tibble(file_path = files) %>% 
  mutate(file_contents = map(file_path, ~ read_tsv(., col_types = "di")),
         file_name = fs::path_file(file_path)) -> data 

data %>% 
  select(-file_path) %>% 
  unnest() %>% 
  mutate(date = ymd(str_sub(file_name, end = 10)))