

# Coursera - Developing Data Products- Course Project

# This app displays state-wise statistics (from a pre-configured list) 
# for individual states in the USA

# ui.R file for the shiny app

library(markdown)

state.x77.extended <- cbind.data.frame(state.x77, 
                                       "Region"=state.region,
                                       "State"=state.abb)
n <- length(colnames(state.x77.extended))

shinyUI
(fluidPage(
  navbarPage(
    "The United States",
     tabPanel(
       "Some Statistics",
       sidebarLayout(
         sidebarPanel( width = 3,
           helpText("Statistics across states"),
           helpText("Please select the statistic to display"),
           # selectInput('state', 'State', 
           #             rownames(state.x77.extended)),
           selectInput('statistic', 'Statistic', 
                       colnames(state.x77.extended)[1:(n-2)])

         ),#sidebarPanel
         mainPanel(width=9,
                   # helpText("State-wise Staistics"),
                   plotOutput("statePlot")

         )#mainPanel
       )#sidebarLayout
      )#tabPanel

  )#navbarPage
  
 )#fluidPage

) #shinyUI




