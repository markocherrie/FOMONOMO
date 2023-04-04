# Load the RSQLite package
library(RSQLite)


adddata<-function(newdata){
# Specify the name and location of the database file
dbname <- "mydatabase.sqlite"

# Connect to the database
con <- dbConnect(RSQLite::SQLite(), dbname)

# Insert the new data into the table
dbWriteTable(con, "mytable", newdata, append = TRUE)

# Disconnect from the database
dbDisconnect(con)
}


adddata(newdata)