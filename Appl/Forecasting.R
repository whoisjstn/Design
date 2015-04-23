
source("supportQueries.R")

# [START FUNCTION]
# Purpose: Creates a forecast for a home based on their past electricity consumption.

# This function reads the information stored in the database to produce a forecast of a home's future
# energy consumption.

createTBATSForecast <- function(con, targetHome, inputReadings, fcLength) {
  
  readingsQuery <- paste("(SELECT * FROM readings WHERE home_id =", targetHome ,"ORDER BY period DESC LIMIT", as.numeric(inputReadings),
                         ") ORDER BY period ASC")
  
  homeReadings <- dbGetQuery(con, readingsQuery)
  
  homeTS <- ts(homeReadings[,3], frequency = 24)
  
  y <- msts(homeTS, seasonal.periods=c(24,168))
  
  fit <- tbats(y)
  
  fc <- forecast(fit, h = as.numeric(fcLength)*24)
  
  return(fc)
  
}

# [END FUNCTION]

# [START FUNCTION]
# Purpose: Graph a forecast model over the time frame as provided by the user.

# This function reads the information stored in the database to produce a forecast of a home's future
# energy consumption.

graphForecast <- function(forecastObject, startDate, EndDate) {
  
  
  
  
}







