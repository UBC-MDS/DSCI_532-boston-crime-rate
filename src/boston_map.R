library(tidyverse)
library(rgdal)
library(leaflet)

boston <- readOGR('data/shapefile/Boston_Neighborhoods.shp')

boston_tab <- boston@data

crime <- read_csv('data/records/crime.csv')

# Create vector of areas where we have data
have_data <- c("Downtown", "Charlestown", "East Boston", "Roxbury", "Mattapan", "South Boston", "Dorchester", "South End", "Brighton", "West Roxbury", "Jamaica Plain", "Hyde Park")

# Subset shapefile where we have data
subset_have_data <- subset(boston, boston$Name %in% have_data)

# Create vector where we're missing data
missing <- as.tibble(boston_tab$Name)
tmp <- as.tibble(have_data)

missing <- anti_join(missing, tmp)
missing <- as.character(missing$value)
rm(tmp)

# Subset shapefile where we're missing data
subset_missing_data <- subset(boston, boston$Name %in% missing)

leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addPolygons(data = subset_have_data, weight = 1) %>%
  addPolygons(data = subset_missing_data, weight = 1, color = 'red')


