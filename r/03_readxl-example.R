# IRSAE R workshop, Kaloe
# Date April 23rd 2019
# Author Lars Dalby

library(readxl)
library(here)

# Let's read the data:
read_excel(here("data", "readxl-example-data.xlsx"))

# Hmm wrong sheet, let's try again
read_excel(here("data", "readxl-example-data.xlsx"),
           sheet = "data")

# Better, but quite messy. Let's see if we can get only the data
read_excel(here("data", "readxl-example-data.xlsx"),
           sheet = "data", range = cell_cols("C:E"))

# There are plenty more options, for when things get really ugly
?read_excel