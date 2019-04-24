# IRSAE R workshop, Kaloe
# Date April 22nd 2019
# Author Lars Dalby

# Exercises --------------------------------------------------------------
# Your turn!

# 1.1) Make a plot of your study site/s. Play around with different background maps
# 1.2) Add a scalebar


# 2) Hunting stat maps
# Go to http://fauna.au.dk/en/hunting-and-game-management/bag-statistics/statistics-online-since-1941/map/
# choose a species (ask a friend to translate the DK species names)
# Download (csv) (omr = municipality, antal = numbers)
# Use GADM data at municipality level to link the numbers reported shot to.
# Main goal: recreate the map shown on the website above for the species you've chosen.
# Use plot() or mapview() for plotting - ggplot is slow.

# 3) Plot plant species richness of the local forests
# Using the data in the forest folder, produce a richness map
# What is the max richness of all years? of 2016? Which plot
# has the most species of Poaceae

# 4) Calculate the distance to the coast for DK
# 4.1) Plot a raster map showing the distance
# Is it true that there is no more than 50 km to the coast
# anywhere in DK?
# I recommend using the package rnaturalearth to get a simpler map 
# of DK. Otherwise the calculations can take some time...