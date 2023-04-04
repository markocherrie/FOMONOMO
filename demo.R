# run the setup

file.remove("mydatabase.sqlite")
source("makedatabase.R")
source("RGS_scraper.R")
source("addnewdata.R")
runApp()