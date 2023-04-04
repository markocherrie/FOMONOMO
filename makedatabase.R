# Load the RSQLite package
library(RSQLite)

# Specify the name and location of the database file
dbname <- "mydatabase.sqlite"

# Connect to the database
con <- dbConnect(RSQLite::SQLite(), dbname)

# Define the SQL statement to create the table
sql <- "CREATE TABLE mytable (
          Date_from TEXT,
          Date_to TEXT,
          Interval TEXT,
          Location TEXT,
          Name TEXT
        )"

# Execute the SQL statement to create the table
dbExecute(con, sql)

# Define some sample data
data <- data.frame(
  Date_from = c("2023-03-23"),
  Date_to = c("2022-03-27"),
  Interval = c("1 year"),
  Location = c("Denver"),
  Name = c("AAG")
)

# Insert the sample data into the table
dbWriteTable(con, "mytable", data, append = TRUE)

# Disconnect from the database
dbDisconnect(con)