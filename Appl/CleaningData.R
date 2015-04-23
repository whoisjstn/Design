
# This file contains the functions:

# - cleanData: Used to format data from a CSV to meet the required specifications for database storage.

# - uploadNewReadings: Used to insert new reading records into the database as required without overwriting
#    previous entries.

#-----------------------------------------------------------------------------------------------------------

# [START FUNCTION]
# Purpose: Take a CSV file as an input, and format for database storage.

# The data table needs to be in the following format to be added to the database:
# || home_id        | TimeStamp with Date and 24-Hour Time | Electricity Consumed ||
# || INT 9 DIGITS   | DATETIME 'YYYY-MM-DD HH:MM:SS'       | INT XX.XXXXX         ||

# So, we need to do some reformatting of the data frame:

cleanData <- function(gbInput) {
  
  gbInput$home_id <- gbInput[,1]
  
  gbInput$period <- paste(gbInput[,2], gbInput[,3], gbInput[,4])
  
  gbInput$period <- strptimeDate(gbInput$period, "%m/%d/%Y %I:%M:%S %p")
  
  gbInput$period <- format(gbInput$period, format="%Y-%m-%d %H:%M:%S")
  
  gbInput$consumption <- gbInput[,5]
  
  gbInput <- subset(gbInput, select = c(home_id, period, consumption))
  
  return(gbInput)
  
}

# After performing the above function on a CSV input, the data should be ready to read into the database.

# [END FUNCTION]

# [START FUNCTION]
# Purpose: upload a properly formatted set of readings to the readings table in the MySQL database.

# The database needs to be able to take in data from a data frame in various ways, without overwriting the existing
# readings that are available in the database. This allows for new readings to be inserted into the database as
# necessary.

uploadNewReadings <- function(cleanedData) {
  
  # Create A Connection to the HAP MySQL Database.
  con <- dbConnect(MySQL(), user='root', password='', dbname='gbtest', host='localhost')
  
  # Query the database to upload the new readings.
  dbWriteTable(con, 'readings', cleanedData, overwrite = FALSE, append = TRUE, row.names = NA)

}

# [END FUNCTION]



























