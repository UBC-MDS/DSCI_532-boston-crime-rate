# LIBRARIES =================================================================================================================================================================================

library(shiny)
library(tidyverse)
library(leaflet)
library(rgdal)
library(shinythemes)
library(shinyWidgets)
library(rsconnect)
library(shinyjs)
library(jcolors)


# LOAD DATA =================================================================================================================================================================================

## Load Shapefiles
boston_data <- readOGR('data/shapefile/shape_with_data.shp')
boston_no_data <- readOGR("data/shapefile/shape_no_data.shp")

## Load Tabular data
crime <- read_csv('data/records/crime_cleaned.csv')


# CREATE VECTORS FOR SELECTION IN SHINY WIDGETS =============================================================================================================================================

## Vector of choices
crime_choices <- sort(unique(crime$OFFENSE_CODE_GROUP))
month_choices <- c("January", 
                   "February",
                   "March",
                   "April", 
                   "May", 
                   "June", 
                   "July", 
                   "August",
                   "September",
                   "October", 
                   "November", 
                   "December")
weekday_choices <- c( "Monday",
                      "Tuesday",
                      "Wednesday", 
                      "Thursday", 
                      "Friday",
                      "Saturday", 
                      "Sunday" )
neighbourhood_choices <- sort(unique(crime$NAME))


# CREATE LOADING SCREEN =====================================================================================================================================================================
appCSS <- "
#loading-content {
position: absolute;
background: #000000;
opacity: 0.9;
z-index: 100;
left: 0;
right: 0;
height: 100%;
text-align: center;
color: #FFFFFF;
}
"


# DEFINE UI FOR APP.  WILL DISPLAY MAP AND BAR CHART ========================================================================================================================================

ui <- fluidPage(theme = shinytheme("cosmo"),useShinyjs(),
                inlineCSS(appCSS), 
                
                # Loading message
                div(
                  id = "loading-content",
                  h2("Loading...")
                ),              
                
                # Application title
                titlePanel("Boston Crime"),
                
                # Sidebar with a slider input for 2 tabs and 4 slides 
                
                #N avigation bar
                navbarPage( "",
                           
                           # Tab 1 for map             
                           tabPanel("Neighbourhood Map",
                                    sidebarLayout(
                                      sidebarPanel(
                                        pickerInput("crimeFiltered", 
                                                    label = h3("Type of Crime:"),
                                                    choices = crime_choices,
                                                    options = list(`actions-box` = TRUE),
                                                    multiple = TRUE,
                                                    selected = crime_choices ),
                                        pickerInput("monthFiltered", 
                                                    label = h3("Month:"),
                                                    choices = month_choices,
                                                    options = list(`actions-box` = TRUE),
                                                    multiple = TRUE, 
                                                    selected = month_choices),
                                        pickerInput("weekFiltered",
                                                    label = h3(" Day of The Week:"),
                                                    choices = weekday_choices, 
                                                    options = list(`actions-box` = TRUE),
                                                    multiple = TRUE, 
                                                    selected = weekday_choices )),
                                      mainPanel(
                                        leafletOutput("mymap", height = "700px", width = "100%")))),
                           
                           #Tab 2 for bar chart with seperate sliders     
                           tabPanel("Hourly Incident Graph", 
                                    sidebarLayout(
                                      sidebarPanel(
                                        pickerInput("crimeFiltered_c",
                                                    label = h3("Type of Crime:"),
                                                    choices = crime_choices, 
                                                    options = list(`actions-box` = TRUE),
                                                    multiple = TRUE, 
                                                    selected = crime_choices ),
                                        pickerInput("monthFiltered_c", 
                                                    label = h3("Month:"),
                                                    choices = month_choices, 
                                                    options = list(`actions-box` = TRUE),
                                                    multiple = TRUE,
                                                    selected = month_choices),
                                        pickerInput("weekFiltered_c", 
                                                    label = h3(" Day of The Week:"),
                                                    choices = weekday_choices,
                                                    options = list(`actions-box` = TRUE),
                                                    multiple = TRUE, 
                                                    selected = weekday_choices ),
                                        pickerInput("NeighbourhoodsFiltered_c",
                                                    label = h3("Boston Neighbourhoods:"),
                                                    choices = neighbourhood_choices,
                                                    options = list(`actions-box` = TRUE),
                                                    multiple = TRUE, 
                                                    selected = neighbourhood_choices)),
                                      mainPanel(
                                        plotOutput("hour_data", height = "700px", width = "100%")))))
)   



# DEFINE SERVER FOR APP.  APPLYS FILTERING MECHANISMS TO MAP AND BAR CHART PROJECTIONS ======================================================================================================

server <- function(input, output) {
  
  # Simulate work being done for 1 second this is for the loading screen
  Sys.sleep(1)
  
  
  #  Filtering for map   
  crime_filtered <- reactive({
    validate(
      need(input$crimeFiltered != "", "Please select at least one crime"),
      need(input$monthFiltered %in% month_choices, "Please select at least one month"),
      need(input$weekFiltered %in% weekday_choices , "Please select at least one day of the week")
      
    )
    
    crime %>%
      filter(OFFENSE_CODE_GROUP %in% input$crimeFiltered, 
             MONTH_NAME %in%  input$monthFiltered, 
             DAY_OF_WEEK %in% input$weekFiltered ) %>%
      group_by(NAME) %>%
      count()
  })
  
  # Filter for barchart   
  crime_filtered2 <- reactive({
    validate(
      need(input$crimeFiltered_c != "", "Please select at least one crime"),
      need(input$monthFiltered_c %in% month_choices, "Please select at least one month"),
      need(input$weekFiltered_c %in% weekday_choices , "Please select at least one day of the week"),
      need(input$NeighbourhoodsFiltered_c %in% neighbourhood_choices , "Please select at least one neighbourhood")
    )
    
    
    crime %>%
      filter(OFFENSE_CODE_GROUP %in% input$crimeFiltered_c, 
             MONTH_NAME %in%  input$monthFiltered_c, 
             DAY_OF_WEEK %in% input$weekFiltered_c, 
             NAME %in% input$NeighbourhoodsFiltered_c) 
  })
  
  # Merge filtered data to shapefile
  boston_filtered <- reactive(
    delete <- merge(boston_data, crime_filtered(), by.x="Name", by.y="NAME"))
  
  # Create colour palette function to be applied to data through filter selections
  color_palette <- reactive({
    domain <- boston_filtered()@data
    
    colorNumeric( "viridis", domain = domain$n)})
  
  # If we want to include a table somewhere, uncomment this line
  # output$table <- renderDataTable(boston_filtered()@data)
  
  
  # Map output using leaflet   
  output$mymap <- renderLeaflet({
    
    pal <- color_palette()
    
    leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addPolygons(data = boston_filtered(), 
                  weight = 1, color = "white",
                  fillColor = ~pal(boston_filtered()@data$n), 
                  fillOpacity = 0.65) %>%
      addPolygons(data = boston_no_data, weight = 1, color = "white", fillColor = "gray") %>%
      addLegend(title = "Boston Crime Density <br> 2015 - 2017", 
                pal = colorNumeric( "viridis", domain = boston_filtered()@data$n), 
                values = boston_filtered()@data$n) 
  })
  
  # Plot output  for bar chart 
  output$hour_data <- renderPlot({
    
    crime_filtered2() %>% 
      ggplot(aes(x = HOUR)) +
      coord_polar(theta = "x", start = -pi/45) +
      geom_bar(stat = "count", color = "gray", fill = "darkcyan") +
      scale_x_continuous(limits = c(-.5, 23.5), 
                         breaks = seq(0, 23), labels = seq(0,23))  +
      ylab("Frequency") +
      xlab("Time (Hour)") +
      theme_classic() + theme(plot.title = element_text(size=26),
                              axis.text.x = element_text(size = 14),
                              axis.text.y = element_text( size = 14),
                              axis.title=element_text(size=18),
                              axis.ticks.x=element_blank(), 
                              axis.line=element_blank())                                                                                         
    
    
    
  })
  
  # Hide the loading message when the rest of the server function has executed
  hide(id = "loading-content", anim = TRUE, animType = "fade")    
  show("app-content")
  
  
}

# RUN APPLICATION ===========================================================================================================================================================================
shinyApp(ui = ui, server = server)
