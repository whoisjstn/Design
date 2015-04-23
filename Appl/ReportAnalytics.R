
# [START FUNCTION]
# Purpose: Find the average consumption for a repeating period, given the period and the time series.

# This function is the base functionality for determining the average usage within a period. It is expanded on
# further to provide consumer insight within the report.

findAverageConsumption <- function(timeSeries, frequencyValue) {
  
  values <- double()
  
  freqs <- cycle(timeSeries)
  
  for (i in 1:length(freqs)) {
    
    if (freqs[i] == frequencyValue) {
      
      values <- c(values, timeSeries[i])
      
    }
    
  }
  
  return(sum(values)/length(values))
  
}