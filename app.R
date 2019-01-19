library(shiny)
library(tidyverse)
library(leaflet)
library(rgdal)
library(shinythemes)
library(shinyWidgets)
library(rsconnect)
library(shinyjs)


# Load data
boston_data <- readOGR('data/shapefile/shape_with_data.shp')
boston_no_data <- readOGR("data/shapefile/shape_no_data.shp")
crime <- read_csv('data/records/crime_cleaned.csv')

# Create lookup table so we can join data

# Vector of choices
crime_choices <- sort(unique(crime$OFFENSE_CODE_GROUP))
month_choices <- c("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")

weekday_choices <- c( "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" )

neighbourhood_choices <- sort(unique(crime$NAME))


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


#nClose on click feature
jscode <- "shinyjs.closeWindow = function() { window.close(); }"


# Define UI for application that draws a map and barchart 

ui <- fluidPage(theme = shinytheme("cosmo"),useShinyjs(),
                inlineCSS(appCSS),extendShinyjs(text = jscode, functions = c("closeWindow")),
                actionButton("close", "Close window"),  
                
  # Loading message
        div(
          id = "loading-content",
          h2("Loading...")
        ),              
  
  # Application title
  titlePanel("Boston Crime"),
  
  # Sidebar with a slider input for 2 tabs and 4 slides 
  
#N avigation bar
  navbarPage("Menu options",
             
# Tab 1 for map             
    tabPanel("Neighhourhood Map",
             sidebarLayout(
               sidebarPanel(
                    pickerInput("crimeFiltered", label = h3("Type of Crime:"),
                                choices = crime_choices,  options = list(`actions-box` = TRUE),multiple = TRUE, selected = crime_choices ),
                    pickerInput("monthFiltered", label = h3("Month:"),
                                choices = month_choices, options = list(`actions-box` = TRUE), multiple = TRUE, selected = month_choices),
                    pickerInput("weekFiltered", label = h3(" Day of The Week:"),
                                choices = weekday_choices, options = list(`actions-box` = TRUE), multiple = TRUE, selected = weekday_choices )),
               mainPanel(
                 leafletOutput("mymap", height = "600px", width = "100%")))),

#Tab 2 for bar chart with seperate sliders     
      tabPanel("Hourly incident graph", 
               sidebarLayout(
                 sidebarPanel(
                   pickerInput("crimeFiltered_c", label = h3("Type of Crime:"),
                               choices = crime_choices,  options = list(`actions-box` = TRUE),multiple = TRUE, selected = crime_choices ),
                   pickerInput("monthFiltered_c", label = h3("Month:"),
                               choices = month_choices, options = list(`actions-box` = TRUE), multiple = TRUE, selected = month_choices),
                   pickerInput("weekFiltered_c", label = h3(" Day of The Week:"),
                               choices = weekday_choices, options = list(`actions-box` = TRUE), multiple = TRUE, selected = weekday_choices ),
                   pickerInput("NeighbourhoodsFiltered_c", label = h3("Boston Neighbourhoods:"),
                               choices = neighbourhood_choices, options = list(`actions-box` = TRUE), multiple = TRUE, selected = neighbourhood_choices)),
                 mainPanel(
                   plotOutput("hour_data", width = "100%")))))
)   
    




# Define server logic required to draw a map and barchart 
server <- function(input, output) {
  
  # Simulate work being done for 1 second this is for the loading screen
  Sys.sleep(1)
 
  
#  Filtering for map   
  crime_filtered <- reactive(
    crime %>%
      filter(OFFENSE_CODE_GROUP %in%input$crimeFiltered, 
             MONTH_NAME %in%  input$monthFiltered, 
             DAY_OF_WEEK %in% input$weekFiltered ) %>%
      group_by(NAME) %>%
      count()
  )

# Filter for barchart   
  crime_filtered2 <- reactive(
    crime %>%
      filter(OFFENSE_CODE_GROUP %in% input$crimeFiltered_c, 
             MONTH_NAME %in%  input$monthFiltered_c, 
             DAY_OF_WEEK %in% input$weekFiltered_c, 
             NAME %in% input$NeighbourhoodsFiltered_c) 
  )
  
  boston_filtered <- reactive(
    delete <- merge(boston_data, crime_filtered(), by.x="Name", by.y="NAME"))
  
  # color_palette <- reactive({
  #   delete_this <- boston_filtered()@data
  #   
  #   colorNumeric("viridis", domain = delete_this$n)})
  
  output$table <- renderDataTable(boston_filtered()@data)
  
 
  # Map output using leaflet   

   output$mymap <- renderLeaflet({
    
    pal <- color_palette()
    
    leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addPolygons(data = boston_filtered(), weight = 1, color = "white", fillColor = ~pal(boston_filtered()@data$n), fillOpacity = 0.65) %>%
      addPolygons(data = boston_no_data, weight = 1, color = "white", fillColor = "gray") %>%
      addLegend(title = "Boston Crime Density <br> 2015 - 2017", pal = colorNumeric('viridis', domain = boston_filtered()@data$n), values = boston_filtered()@data$n) 
  })

# Plot output  for bar chart 
  output$hour_data <- renderPlot({
    
    crime_filtered2() %>%
      ggplot(aes(x=HOUR)) +
      geom_histogram(bins = 24, color = "white", fill = "darkcyan") +
      labs(y = "Frequency", x = "Hour", title = "Number of Incident Cases by Hour for Selected Neighbourhood") +
      theme_classic() + theme(plot.title = element_text(size=26),
                              axis.text.x = element_text(size = 14),
                              axis.text.y = element_text( size = 14),
                              axis.title=element_text(size=18)) +                                                                                          
      scale_x_continuous(limits=c(0, 23), breaks=seq(0,23,1))
    
    
  })
  
  # Hide the loading message when the rest of the server function has executed
  hide(id = "loading-content", anim = TRUE, animType = "fade")    
  show("app-content")
  
  
  # Exit window
  observeEvent(input$close, {
    js$closeWindow()
    stopApp()
  })
}
 
# Run the application 
shinyApp(ui = ui, server = server)
