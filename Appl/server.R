
# This file provides the server functionality for the 4450 shiny web application.

library(forecast) # Provides the Forecast Package for forecasting purposes.
library(RMySQL)   # Provides the RMySQL Package for data storage purposes.
library(ggplot2) # Provides the GGPlot2 Package for graphing purposes.
library(lubridate) # Provides the Lubridate Package for date manipulation purposes

source("ReportAnalytics.R") # Imports the file containing the Reporting Functionality.
source("Forecasting.R") # Imports the file containing the Forecasting Functionality.
source("CleaningData.R") # Imports the file containing the Data Cleaning Functionality.
source("supportQueries.R") # Imports the file containing the support SQL Queries in R.

# Connection to HAP MySQL database.
con <- dbConnect(MySQL(), user='root', password='', dbname='gbtest', host='localhost')

# The below is the code to run the shiny server.

shinyServer(
  
  function(input, output) {
    
    # Provides updating for the Drop-down selector.
    
    output$homeSelector <- renderPrint({input$select})
    
    output$comparatorHomeSelector <- renderPrint({input$select})
    
    output$fcRangeSelector <- renderPrint({input$select})
    
    # Provides updating for the consumption data graph.
    
    output$DataGraph <- renderPlot({
      
      homeReadings <- getHomeReadings(con, input$homeSelector, 720)
      
      fc <- createTBATSForecast(con, input$homeSelector, 720, input$fcRangeSelector)
      
      if(as.character(input$comparatorHomeSelector != "No Comparator")) {
        
        comparatorReadings <- getHomeReadings(con, input$comparatorHomeSelector, 720)
        
        comparatorTS <- ts(comparatorReadings[,3], frequency = 24)
        
      }
      
      par(mar=c(6,4,4,2))
      
      par(oma=c(4,1,1,1))
      
      plot(fc, main=paste("Last 30 Days of Consumption and", input$fcRangeSelector, "day(s) of Forecasted Consumption"),
           xlab="", ylab="Electricity Consumption (KWH)",
           xaxt="n")
      
      if(as.character(input$comparatorHomeSelector) != "No Comparator") {
        
        lines(comparatorTS, col= "red")
        
      }
      
      dateLabels <- seq(as.Date(homeReadings[1,2]), by="day", length.out=(31+as.numeric(input$fcRangeSelector)))
      
      axis(1, at=1:(31+as.numeric(input$fcRangeSelector)), labels=dateLabels, las=2)
      mtext("Date", side=1, line=5.2)
      
      par(fig = c(0, 1, 0, 1), oma = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), new = TRUE)
      
      plot(0, 0, type = "n", bty = "n", xaxt = "n", yaxt = "n")
        
      legend("bottom", xpd = TRUE, horiz = TRUE, lty = 1, col = c("black","red", "blue"),
               legend = c("Selected Home","Comparison Home", "Forecasted Consumption"))

    })
    
    # Provides updating for the Components Graph.
    
    output$ComponentsGraph <- renderPlot({
              
      homeReadings <- getHomeReadings(con, input$homeSelector, 168)
        
      tsdata <- ts(homeReadings[,3], frequency = 24)
        
      components <- decompose(tsdata)
      
      par(mar=c(6,4,4,2))
      
      par(oma=c(4,1,1,1))
      
      dateLabels <- seq(as.Date(homeReadings[1,2]), by="day", length.out=8)
      
      steps <- seq(from = 1, to = 8, length.out=8)
      
      plot(components, xaxt = "n", xlab = "")
      
      axis(1, at=1:8, labels=dateLabels, las=2, line = 6)
      
      mtext("Date", side=1, line=6)
      
    })
    
    # Provides updating for the data readings table.
    
    output$readingsTable <- renderTable({
      
      homeReadings <- getHomeReadings(con, input$homeSelector, 9000)
      
    })
    
    # Provides updating for the usage period averaging table.
    
    output$highUsageGraph <- renderPlot({
        
      homeReadings <- getHomeReadings(con, input$homeSelector, 9000)
      
      last24Readings <- getHomeReadings(con, input$homeSelector, 24)
      
      tsdata <- ts(homeReadings[,3], frequency = 24)
        
      averages <- vector(length = 24)
        
      for (i in 1:24) {
          
        averages[i] <- findAverageConsumption(tsdata, i)
          
      }
      
      tsAverages <- ts(averages)
      
      tsLastDay <- ts(last24Readings[,3])
      
      xMax <- max(last24Readings[,3],averages)
        
      times <-c("12 AM","1 AM","2 AM","3 AM","4 AM","5 AM","6 AM","7 AM","8 AM","9 AM","10 AM","11 AM",
                  "12 PM","1 PM","2 PM","3 PM","4 PM","5 PM","6 PM","7 PM","8 PM","9 PM","10 PM","11 PM")
      
      par(oma=c(4,1,1,1))
      
      plot(tsLastDay, main="Average Electricity Usage by Time of Day", 
           xlab="", ylab="Electricity Used",
           xaxt = "n", ylim=c(0,xMax))
      
      lines(tsAverages, col="green")
      
      axis(1, at=1:24, labels=times, las=2)
      
      mtext("Time Period (Usage in the Hour beginning at...)", side=1, line=4)
      
      par(fig = c(0, 1, 0, 1), oma = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), new = TRUE)
      
      plot(0, 0, type = "n", bty = "n", xaxt = "n", yaxt = "n")
      
      legend("bottom", xpd = TRUE, horiz = TRUE, lty = 1, col = c("black","green"),
             legend = c("Last 24 Hours","Average Consumption"))
      
  })
    
}
   
)