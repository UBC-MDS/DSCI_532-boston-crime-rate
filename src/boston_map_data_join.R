subset_have_data@data %>%
  left_join(tmp, by = c("Name" = "NAME"))

subset_have_data@data <- left_join(tmp, by = c("Name" = "NAME"))

delete <- merge(subset_have_data, tmp, by.x="Name", by.y="NAME")

delete@data

bins <- c(0, 5, 10, 15, 20, 25, Inf)
pal <- colorNumeric("viridis", domain = tmp$n)

leaflet() %>%
  # addProviderTiles(providers$CartoDB.Positron) %>%
  addPolygons(data = delete, weight = 1, color = "white", fillColor = ~pal(n), fillOpacity = 0.65) %>%
  addPolygons(data = subset_missing_data, color = "white",weight = 1, fillColor = 'gray', fillOpacity = 0.65) %>%
  addLegend(title = "Boston Crime Density <br> 2015 - 2017",pal = pal, values = tmp$n)


