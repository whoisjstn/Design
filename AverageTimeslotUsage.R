
# This function provides the required calculations to determine the average consumption during the time slot with the given
# frequency value for the provided time series.

# This will be used to implement the top five usage periods functionality of the application.

# Now that this function works, it will have to be applied to each frequency value whenever a file is uploaded. This will
# allow all of the average consumption rates for each time period to be compared, and then ranked.

# The top five values along with their respective frequency values will be returned, allowing the top five average usage
# periods to be determined.


findAverageConsumption <- function(timeSeries, frequencyValue) {
  
  values <- double()
  
  freqs <- cycle(timeSeries)
  
  for (i in 1:length(freqs)) {
    
    if (freqs[i] == frequencyValue) {
      
      values <- c(values,ts[i])
      
    }
    
  }
  
  # return(median(values))                --> This could also be a useful value.
  
  return(sum(values)/length(values))
  
}


