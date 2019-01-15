library(shiny)
library(tidyverse)
library(leaflet)
library(rgdal)
library(lubridate)
library(shinythemes)
library(shinyWidgets)

# Load data
boston_data <- readOGR('new_shp/shape_with_data.shp')
boston_no_data <- readOGR("new_shp/shape_no_data.shp")
crime <- read_csv('data/crime_cleaned.csv')

# Vector of choices
crime_choices <- sort(unique(crime$OFFENSE_CODE_GROUP))

month_choices <- c("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")

weekday_choices <- c( "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" )

neighbourhood_choices <- sort(unique(crime$NEIGHBOURHOOD))

day_choices <- sort(unique(crime$DAY))

# Define UI for application that draws a bar chart/map
ui <- fluidPage(theme = shinytheme("slate"),themeSelector(),

    # Application title
    titlePanel("Boston Criminal Incidences"),


    sidebarLayout(
        sidebarPanel(
          # sliderInput("yearFiltered", label = "Years", min = 2015,
          #             max = 2018, value = c(2015, 2018, 1), sep = ""),
          pickerInput("crimeFiltered", label = h3("Type of Crime:"),
                        choices = crime_choices,  options = list(`actions-box` = TRUE),multiple = TRUE, selected = crime_choices ),
          pickerInput("monthFiltered", label = h3("Month:"),
                      choices = month_choices, options = list(`actions-box` = TRUE), multiple = TRUE, selected = month_choices),
          sliderInput("dayFiltered", label = h3("Day(s) of The month"), min = 1,
                      max = 31, value = c(1, 31, 1), sep = ""),
          pickerInput("weekFiltered", label = h3(" Day of The Week:"),
                      choices = weekday_choices, options = list(`actions-box` = TRUE), multiple = TRUE, selected = weekday_choices ),
          selectInput("NeighbourhoodsFiltered", label = h3("Boston Neighbourhoods:"),
                      choices = neighbourhood_choices )
        ),
        mainPanel(

           leafletOutput("mymap", height = "700px", width = "100%"),
           # dataTableOutput("table"),
           plotOutput("hour_data")

        )
    )
)

# Define server logic required to draw a bar chart/ map
server <- function(input, output) {

    crime_filtered <- reactive(
        crime %>%
            filter(OFFENSE_CODE_GROUP == input$crimeFiltered) %>%
            group_by(NAME, OFFENSE_CODE_GROUP) %>%
            count()
        )
    
    crime_filtered1 <- reactive({
      crime %>% filter( YEAR <= input$yearFiltered[2], 
                        YEAR >= input$yearFiltered[1],  
                        OFFENSE_CODE_GROUP %in% input$crimeFiltered,
                        MONTH_NAME %in%  input$monthFiltered, 
                        DAY <= input$dayFiltered[2], 
                        DAY >=  input$dayFiltered[1],
                        DAY_OF_WEEK %in% input$weekFiltered,
                        NEIGHBOURHOOD == input$NeighbourhoodsFiltered )
    })

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
        crime_filtered1() %>% ggplot(aes(x=HOUR)) +
          geom_bar(stat = "count", fill = "darkcyan") +
          labs(y = "Frequency", title = "Incidents by the Hour") +
          theme_classic() +
          scale_x_continuous(limits=c(0, 23), breaks=seq(0,23,1))

    })
      

}


# Run the application
shinyApp(ui = ui, server = server)
