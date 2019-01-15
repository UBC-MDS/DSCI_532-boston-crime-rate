library(shiny)
library(tidyverse)
library(leaflet)
library(rgdal)
library(lubridate)
library("shinythemes")
library(shinyWidgets)

# Load data
boston_data <- readOGR('new_shp/shape_with_data.shp')
boston_no_data <- readOGR("new_shp/shape_no_data.shp")
crime <- read_csv('data/records/crime.csv')




# Create a new column in order to provide a neighbourhood name and written months 
crime <- crime %>% mutate( NEIGHBOURHOOD = 
                                 case_when(
                                   crime$DISTRICT == "A1" ~ "Downtown", 
                                   crime$DISTRICT == "A15"~ "Charlestown",
                                   crime$DISTRICT == "A7" ~ "East Boston",
                                   crime$DISTRICT == "B2" ~ "Roxbury",
                                   crime$DISTRICT == "B3" ~ "Mattapan",
                                   crime$DISTRICT ==  "C6" ~ "South Boston",
                                   crime$DISTRICT ==  "C11"~ "Dorchester",
                                   crime$DISTRICT ==  "D4" ~ "South End",
                                   crime$DISTRICT ==  "D14" ~ "Brighton",
                                   crime$DISTRICT ==  "E5" ~ "West Roxbury",
                                   crime$DISTRICT ==  "E13" ~ "Jamaica Plain",
                                   crime$DISTRICT ==  "E18" ~ "Hyde Park",
                                   
                                   
                                   TRUE ~ as.character(crime$DISTRICT)
                                 ), 
                           MONTH_NAME = 
                             case_when(
                               crime$MONTH == 1 ~ "January", 
                               crime$MONTH == 2 ~ "February",
                               crime$MONTH == 3 ~ "March",
                               crime$MONTH == 4 ~ "April",
                               crime$MONTH == 5 ~ "May",
                               crime$MONTH == 6 ~ "June",
                               crime$MONTH == 7 ~ "July",
                               crime$MONTH == 8 ~ "August",
                               crime$MONTH == 9 ~ "September",
                               crime$MONTH == 10 ~ "October",
                               crime$MONTH == 11 ~ "November",
                               crime$MONTH == 12 ~ "December",
                               
                               
                               TRUE ~ as.character(crime$MONTH)),
                           
                           
                           DAY = day(OCCURRED_ON_DATE)
                           
                           )  %>% 
  filter(DISTRICT !=is.na(DISTRICT))



# Vector of choices
crime_choices <- sort(unique(crime$OFFENSE_CODE_GROUP))

month_choices <- c("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")

# day_choices <-  unique(crimes$DAY)
weekday_choices <- c( "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" )

neighbourhood_choices <- sort(unique(crime$NEIGHBOURHOOD))


day_choices <- sort(unique(crime$DAY))

# Define UI for application that draws a bar chart/map
ui <- fluidPage(theme = shinytheme("slate"),themeSelector(),

    # Application title
    titlePanel("Boston Criminal Incidences"),

    
    sidebarLayout(
        sidebarPanel(
          sliderInput("yearFiltered", label = "Years", min = 2015, 
                      max = 2018, value = c(2015, 2018, 1), sep = ""),
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
          plotOutput("hour_data")
          
           
        )
    )
)

# Define server logic required to draw a bar chart/ map
server <- function(input, output) {
  
#Filtering the data  
    crime_filtered <- reactive({
      crime %>% filter( YEAR <= input$yearFiltered[2], 
                        YEAR >= input$yearFiltered[1],  
                        OFFENSE_CODE_GROUP %in% input$crimeFiltered,
                        MONTH_NAME %in%  input$monthFiltered, 
                        DAY <= input$dayFiltered[2], 
                        DAY >=  input$dayFiltered[1],
                        DAY_OF_WEEK %in% input$weekFiltered,
                        NEIGHBOURHOOD == input$NeighbourhoodsFiltered )
    })
      output$hour_data <- renderPlot({
        crime_filtered() %>% ggplot(aes(x=HOUR)) +
          geom_bar(stat = "count", fill = "darkcyan") + 
          labs(y = "Frequency", title = "Incidents by the Hour") +
          theme_classic() +
          scale_x_continuous(limits=c(0, 23), breaks=seq(0,23,1))  
        
          
    })
  
}


# Run the application 
shinyApp(ui = ui, server = server)
