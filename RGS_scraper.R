library(rvest)

# Define the URL of the website to scrape
url <- "https://www.rgs.org/research/annual-international-conference/"

# Load the HTML content of the website
page <- read_html(url)

# Extract the elements that contain the main text
text_elements <-  page %>%
  html_node(".wysiwyg") %>%
  html_text() 
  
library(stringr)

date_pattern <- "(?:Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)?\\s?\\d{1,2}\\s+(?:January|February|March|April|May|June|July|August|September|October|November|December)\\s?(?:\\d{4})?"
preceding_words_pattern <- paste0("(.{1,70})", date_pattern)
preceding_words <- str_extract_all(text, preceding_words_pattern)


dates <- unlist(str_extract_all(text_elements, date_pattern))

date_obj <- as.character(as.POSIXct(dates, format = "%A %d %B"))

newdata <- data.frame(
  Date_from = c(date_obj[1]),
  Date_to = c(date_obj[2]),
  Interval = c("1 year"),
  Location = c("London/online"),
  Name = c("RGS (with IBG)")
)


# Print the dates
print(dates)