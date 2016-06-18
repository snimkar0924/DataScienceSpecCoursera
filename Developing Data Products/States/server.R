# Coursera - Developing Data Products- Course Project

# server.R file for the shiny app - States

library(shiny)
library(ggplot2)

state.x77.extended <- cbind.data.frame(state.x77, 
                                       "Region"=state.region,
                                       "State"=state.abb)
n <- length(colnames(state.x77.extended))

shinyServer(function(input, output) {
 
    output$statePlot <- renderPlot({

      ylab <- colnames(state.x77.extended)[which(colnames(state.x77.extended) == input$statistic)] 
      g <- ggplot(state.x77.extended,
                  aes(x = State, 
                      y = state.x77.extended[,input$statistic], 
                      colour = Region)) +
        geom_point() +
        theme(axis.text.x = element_text(angle = 90, hjust = 1, size = 10)) +
        ylab(ylab) +
        ggtitle(paste("State-wise Statistic -", ylab))

      plot(g)

  })
})

