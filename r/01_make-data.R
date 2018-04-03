# Data for workshop
# Author: Lars Dalby
library(tidyverse)
data(mtcars)

data_list <- vector("list", length = 3)

for (i in seq_along(data_list)) {
  mtcars %>% 
  as.tibble() %>% 
  select(site = cyl,
         weight_before = drat,
         weight_after = wt) %>% 
  mutate(site = case_when(site == 4 ~ i + 10,
                         site == 6 ~ i + 20,
                         site == 8 ~ i + 30,
                         TRUE ~ 0),
    site = site+i,
         weight_before = weight_before + rnorm(nrow(.), mean = i+3, sd = 0.1),
         weight_after = weight_before - rnorm(nrow(.), mean = i+3, sd = 0.1)) -> data_list[[i]]
} 

data_list %>% 
  bind_rows() %>% 
  mutate(diff = weight_before-weight_after) %>% 
  filter(diff < 0)


  