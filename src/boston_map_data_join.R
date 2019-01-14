# Load data
boston_data <- readOGR('new_shp/shape_with_data.shp')
boston_no_data <- readOGR("new_shp/shape_no_data.shp")
crime <- read_csv('data/records/crime.csv')

# Create vector of areas where we have data
have_data <- c("Downtown", "Charlestown", "East Boston", "Roxbury", "Mattapan", "South Boston", "Dorchester", "South End", "Brighton", "West Roxbury", "Jamaica Plain", "Hyde Park")

# Create lookup table so we can join data
lookup <- tribble(
  ~DISTRICT, ~NAME,
  "A1", "Downtown",
  "A15", "Charlestown",
  "A7", "East Boston",
  "B2", "Roxbury",
  "B3", "Mattapan",
  "C6", "South Boston",
  "C11", "Dorchester",
  "D4", "South End",
  "D14", "Brighton",
  "E5", "West Roxbury",
  "E13", "Jamaica Plain",
  "E18", "Hyde Park"
)

# We need to filter the data before we join.
tmp <- crime %>%
  left_join(lookup, by = c("DISTRICT" = "DISTRICT")) %>%
  group_by(NAME, OFFENSE_CODE_GROUP) %>%
  filter(OFFENSE_CODE_GROUP == "Homicide") %>%
  count()


# Subset shapefile where we have data
boston_data@data <- left_join(boston_data@data, tmp, by = c("Name" = "NAME"))


# Create vector where we're missing data
missing <- as.tibble(boston_tab$Name)
tmp1 <- as.tibble(have_data)
missing <- anti_join(missing, tmp1)
missing <- as.character(missing$value)


# Subset shapefile where we're missing data
subset_missing_data <- subset(boston, boston$Name %in% missing)
writeOGR(subset_missing_data, dsn = "new_shp", layer = "shape_no_data", driver="ESRI Shapefile")


delete <- merge(subset_have_data, tmp, by.x="Name", by.y="NAME")

bins <- c(0, 5, 10, 15, 20, 25, Inf)
pal <- colorNumeric("viridis", domain = tmp$n)

leaflet() %>%
  # addProviderTiles(providers$CartoDB.Positron) %>%
  addPolygons(data = delete, weight = 1, color = "white", fillColor = ~pal(n.x), fillOpacity = 0.65) %>%
  addPolygons(data = subset_missing_data, color = "white",weight = 1, fillColor = 'gray', fillOpacity = 0.65) %>%
  addLegend(title = "Boston Crime Density <br> 2015 - 2017",pal = pal, values = tmp$n)


