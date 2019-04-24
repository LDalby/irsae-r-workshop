# IRSAE R workshop, Kaloe
# Date April 24th 2019
# Author Lars Dalby

library(tidyverse)

# The iris data as data.frame
iris

# Same as tibble 
iris %>% 
  as_tibble()

# Same as tibble (janitor >= vers. 1.2.0 to get make_clean_names)
iris %>% 
  as_tibble(.name_repair = janitor::make_clean_names) -> iris_clean
iris_clean

# Select species and petal_xxx columns
iris_clean %>% 
  select(species,
         starts_with("petal"))

# Filter to only sepal_width <= 3
iris_clean %>% 
  filter(sepal_width <= 3)

# Calculate new area column
iris_clean %>% 
  mutate(sepal_area = sepal_length * sepal_width)
  

# Summarize into species wise averages
iris_clean %>% 
  mutate(sepal_area = sepal_length * sepal_width) %>% 
  group_by(species) %>% 
  summarise(avg_area = mean(sepal_area))

# Nice one! But not particulaly tidy - can we sort by avg_area?
# Sure! Meet arrange()
iris_clean %>% 
  mutate(sepal_area = sepal_length * sepal_width) %>% 
  group_by(species) %>% 
  summarise(avg_area = mean(sepal_area)) %>% 
  arrange(avg_area)


