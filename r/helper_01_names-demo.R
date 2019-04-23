# Make data for names demo
library(tidyverse)
library(lubridate)
library(here)
library(glue)

soil_data <- tibble(ph = rnorm(10, 7),
                    site = 1:10)
sample_dates <- as.Date(ymd("2018-06-01"):ymd("2018-06-05"), "1970-01-01")

walk(sample_dates, ~write_tsv(soil_data, here("data", glue("{.x}_soil_data.tsv"))))


