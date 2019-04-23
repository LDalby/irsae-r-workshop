# IRSAE R workshop, Kaloe
# Date April 23rd 2019
# Author Lars Dalby

# list columns

iris %>% 
  as_tibble(.name_repair = janitor::make_clean_names) -> iris

iris %>% 
  group_by(species) %>% 
  nest() -> iris_nested

iris_nested %>% 
  mutate(fit = map(data, ~ lm(sepal_width ~ petal_width, data = .x)),
         rsq = map_dbl(fit, ~ summary(.x)[["r.squared"]])) %>% 
  arrange(desc(rsq))

ggplot(iris, aes(sepal_width, petal_width)) +
  geom_point(aes(color = species)) + 
  geom_smooth(method = "lm", aes(group = species), color = "darkgrey") +
  hrbrthemes::theme_ipsum_rc()
