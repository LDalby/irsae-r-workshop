# IRSAE workshop
# Author Lars Dalby

library(tidyverse)

# The iris data as data.frame
iris

# Same as tibble
iris %>% 
  as_tibble()

# Select Species and Petal.xxx columns
iris %>% 
  as_tibble() %>% 
  select(Species,
         starts_with("Petal"))

# Filter to only Sepal.Width <= 3
iris %>% 
  as_tibble() %>% 
  filter(Sepal.Width <= 3)

# Calculate new area column
iris %>% 
  as_tibble() %>% 
  mutate(Sepal.Area = Sepal.Length * Sepal.Width)
