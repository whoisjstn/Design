# This file provides assorted queries that are needed by the Hydro Analytics Platform.

# [START FUNCTION]
# Purpose: retrieve a list of homes from the database.

# This function reads the database for a list of available homes to be analyzed.

getHomesAvailable <- function(con) {
  
  rs <- dbGetQuery(con, 'SELECT * FROM homes')
  
  return(rs["home_id"])
  
}

# [END FUNCTION]

# [START FUNCTION]
# Purpose: retrieve readings associated with a home from the database.

# This function provides home-specific information for analytic purposes.

getHomeReadings <- function(con, targetHome, recordMax) {
  
  homeQuery <- paste("(SELECT * FROM readings WHERE home_id =", targetHome ,"ORDER BY period DESC LIMIT", recordMax,
        ") ORDER BY period ASC")
  
  homeReadings <- dbGetQuery(con, homeQuery)
  
  return(homeReadings)
  
}

# [END FUNCTION]