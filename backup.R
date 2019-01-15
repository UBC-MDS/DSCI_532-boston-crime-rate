library(shiny)
library(tidyverse)
library(leaflet)
library(rgdal)

# Load data
boston_data <- readOGR('new_shp/shape_with_data.shp')
boston_no_data <- readOGR("new_shp/shape_no_data.shp")
crime <- read_csv('data/crime_cleaned2.csv')

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

# Vector of choices
choices <- sort(unique(crime$OFFENSE_CODE_GROUP))

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Boston Crime"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("crimeFiltered", label = h3("Select here:"),
                  choices = choices)
    ),
    mainPanel(
      leafletOutput("mymap", height = "700px", width = "100%"),
      plotOutput("hour_data")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  crime_filtered <- reactive(
    crime %>%
      filter(OFFENSE_CODE_GROUP == input$crimeFiltered) %>%
      group_by(NAME, OFFENSE_CODE_GROUP) %>%
      count()
  )
  
  crime_filtered2 <- reactive(
    crime %>%
      filter(OFFENSE_CODE_GROUP == input$crimeFiltered)
  )
  
  boston_filtered <- reactive(
    delete <- merge(boston_data, crime_filtered(), by.x="Name", by.y="NAME")
  )
  
  color_palette <- reactive({
    delete_this <- boston_filtered()@data
    
    colorNumeric("viridis", domain = delete_this$n)
  })
  
  output$table <- renderDataTable(boston_filtered()@data)
  
  output$mymap <- renderLeaflet({
    
    pal <- color_palette()
    
    leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addPolygons(data = boston_filtered(), weight = 1, color = "white", fillColor = ~pal(boston_filtered()@data$n), fillOpacity = 0.65) %>%
      addPolygons(data = boston_no_data, weight = 1, color = "white", fillColor = "gray") %>%
      addLegend(title = "Boston Crime Density <br> 2015 - 2017", pal = colorNumeric('viridis', domain = boston_filtered()@data$n), values = boston_filtered()@data$n) 
  })
  
  output$hour_data <- renderPlot({
    
    crime_filtered2() %>%
      ggplot(aes(x=HOUR)) +
      geom_histogram(bins = 24, color = "white") +
      labs(y = "Count", x = "Hour of Day\n\n") +
      theme_test()
    
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
