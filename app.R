library(shiny)
library(tidyverse)
library(leaflet)
library(rgdal)

# Load data
boston_data <- readOGR('new_shp/shape_with_data.shp')
boston_no_data <- readOGR("new_shp/shape_no_data.shp")
crime <- read_csv('data/records/crime.csv')

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

# Vector of choices
choices <- unique(crime$OFFENSE_CODE_GROUP)

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
           leafletOutput("mymap", height = "700px", width = "100%")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    crime_filtered <- reactive(
        crime %>%
            filter(OFFENSE_CODE_GROUP == crimeFiltered[1])
    )

    output$mymap <- renderLeaflet({
        leaflet() %>%
            # addProviderTiles(providers$CartoDB.Positron) %>%
            addPolygons(data = boston_data, weight = 1, fillColor = "red") %>%
            addPolygons(data = boston_no_data, weight = 1)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
