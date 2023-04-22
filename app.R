library(shiny)
library(RSQLite)

# Specify the name and location of the database file
dbname <- "mydatabase.sqlite"

# Define the Shiny UI
ui <- fluidPage(
  
  # title panel
  titlePanel(tags$h1("FOMO NOMO ", style = "font-family: sans-serif;", tags$hr(style = "margin-bottom: 10px;"))),
  
  # Two-column layout with input fields on the left and data table on the right
  fluidRow(
    column(width = 4,
           # Input fields for Date_from, Date_to, and Name
           textInput("date_from", "Date From (YYYY-MM-DD):"),
           textInput("date_to", "Date To (YYYY-MM-DD):"),
           textInput("name", "Name:"),
           # Submit button to insert the new data into the database
           actionButton("submit", "Submit"),
           # Refresh button to reload the data table
           actionButton("refresh", "Refresh")
    ),
    column(width = 8,
           # Table to display the current data in the database
           dataTableOutput("mytable")
    )
  )
)

# Define the Shiny server
server <- function(input, output, session) {
  # Connect to the database
  con <- dbConnect(RSQLite::SQLite(), dbname)
  
  # Define a reactive expression to read the current data from the database
  mydata <- reactiveValues(data = NULL)
  
  observe({
    mydata$data <- dbGetQuery(con, "SELECT * FROM mytable")
  })
  
  # Update the table output whenever the mydata reactive expression changes
  output$mytable <- renderDataTable({
    mydata$data
  })
  
  # Define an event observer for the submit button
  observeEvent(input$submit, {
    
    con <- dbConnect(RSQLite::SQLite(), dbname)
    
    
    # Create a data frame with the new data
    newdata <- data.frame(
      Date_from = input$date_from,
      Date_to = input$date_to,
      Name = input$name
    )
    # Insert the new data into the database
    dbWriteTable(con, "mytable", newdata, append = TRUE)
    # Clear the input fields
    updateTextInput(session, "date_from", value = "")
    updateTextInput(session, "date_to", value = "")
    updateTextInput(session, "name", value = "")
  })
  
  # Define an event observer for the refresh button
  observeEvent(input$refresh, {
    con <- dbConnect(RSQLite::SQLite(), dbname)
    mydata$data <- dbGetQuery(con, "SELECT * FROM mytable")
  })
  
  # Disconnect from the database when the app is closed
  observe({
    on.exit(dbDisconnect(con))
  })
}

# Run the Shiny app
shinyApp(ui, server)