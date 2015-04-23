
# This file generates the User Interface for the 4450 shiny web application.

library(RMySQL)   # Provides the RMySQL Package for data storage purposes.

# Connection to HAP MySQL database.
con <- dbConnect(MySQL(), user='root', password='', dbname='gbtest', host='localhost')

source("supportQueries.R")

shinyUI(
  
  fluidPage(
    
    titlePanel("4450 Design Project: Hydro Analytics"),
    
    sidebarLayout(position = "right",
                  
                  sidebarPanel(
                    
                    h6("Control Menu"),
                    
                    selectInput("homeSelector", label=h3("Home Selector"), getHomesAvailable(con)),
                    
                    selectInput("comparatorHomeSelector", label=h3("Comparison Selector"), c("No Comparator", getHomesAvailable(con))),
                    
                    selectInput("fcRangeSelector", label=h3("Days to Forecast"), c(1:30))
                    
                  ),
                  
                  mainPanel(
                    
                    h6("Hydro Analytics"),
                    
                    p("This project is an analytics platform designed to take in user electricity consumption data and perform
                       calculations that will help electricity consumers make sense of their energy usage patterns. This includes
                       illustrating their consumption over time, providing basic forecasting of future consumption, as well as
                       other useful indicators such as top usage periods."),
                    
                    tabsetPanel(
                      
                      #tabPanel("File Upload",
                                 
                        #fileInput("file", label=h3("Green Button Data Upload"))
                        
                      #),
                      
                      tabPanel("Consumption Graph",
                               
                        plotOutput("DataGraph")
                        
                        #, dateRangeInput("dateRange", label=h3("Graphed Time Frame"))
                               
                      ),
                      
                      tabPanel("Consumption Breakdown",
                               
                        plotOutput("ComponentsGraph")
                               
                      ),
                      
                      tabPanel("Consumption Readings",
                      
                        tableOutput("readingsTable") 
                               
                      ),
                      
                      tabPanel("Top Usage Periods",
                      
                        plotOutput("highUsageGraph")
                              
                      )
                       
                    )
        
                  )
    ) 
    
  )
  
)