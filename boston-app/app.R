#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)

data <- read_csv('data/records/crime.csv')
# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Boston Neighbourhood Criminal Incidents",
              windowTitle = "Boston Crime app"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("yearInput", "Select the desired year range of past data.",
                     min = 2015, max = 2018, value = c(15, 30)),
         selectInput("crimeInput", h3("Select a Type of  Crime"), 
                     choices = list("All" = 1, "Aggravated Assault" = 2,
                                    "Aircraft" = 3, ), selected = 1))

      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$distPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
      x    <- faithful[, 2] 
      bins <- seq(min(x), max(x), length.out = input$bins + 1)
      
      # draw the histogram with the specified number of bins
      hist(x, breaks = bins, col = 'darkgray', border = 'white')
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

