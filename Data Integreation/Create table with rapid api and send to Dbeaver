library(RPostgres)
library(DBI)
library(tidyverse)
library(httr2)
library(lubridate)
# Investigate which symbols we can search for ---------------
library(httr2)


url <- "https://alpha-vantage.p.rapidapi.com/query"

req <- request(url) %>%
  req_headers(
    `x-rapidapi-key` = "xxxxxxxxxxxxxxxxxxxxx",
    `x-rapidapi-host` = "xxxxxxxxxxxxxxxxxx"
  ) %>%
  req_url_query(
    datatype = "json",
    keywords = "microsoft",
    "function" = "SYMBOL_SEARCH"
  )

#Print the Result
resp <- req_perform(req)
resp_text <- resp_body_string(resp)
print(resp_text)

# convert to json 
symbols <- resp %>%
  resp_body_json()

#see if there is a Match
symbols$bestMatches[[1]]
symbols$bestMatches[[2]]

# Extract and Transform  ------------------------------------------
# Extract data from Alpha Vantage
library(httr2)

url <- "https://alpha-vantage.p.rapidapi.com/query"

# Create the request
req <- request(url) %>%
  req_headers(
    `x-rapidapi-key` = "xxxxxxxxxxxxxxxxxxxxx",
    `x-rapidapi-host` = "xxxxxxxxxxxxxxxxxx"
  ) %>%
  req_url_query(
    datatype = "json",
    output_size = "compact",
    interval = "1min",
    "function" = "TIME_SERIES_INTRADAY",  # backticks because "function" is reserved
    symbol = "MSFT"
  )
# Perform the request
resp <- req_perform(req)
# Get response as JSON
data <- resp_body_json(resp)
# Inspect the result
str(data)


# TRANSFORM timestamp to UTC time
timestamp <- lubridate::ymd_hms(names(data$`Time Series (1min)`), tz = "America/New_York")
timestamp <- format(timestamp, tz = "UTC")
# Prepare an empty data.frame to hold results
df <- tibble(timestamp = timestamp,
             open = NA, high = NA, low = NA, close = NA, volume = NA)
# TRANSFORM data into a data.frame
for (i in 1:nrow(df)) {
  df[i,-1] <- as.data.frame(data$`Time Series (1min)`[[i]])
}

# Create table in Postgres ------------------------------------------------
# Put the credentials in this script
# Never push credentials to git!! --> use .gitignore on .credentials.R
source("credentials.R")
# Function to send queries to Postgres
source("psql_queries.R")
# Create a new schema in Postgres on docker
psql_manipulate(cred = cred_psql_docker,
                query_string = "CREATE SCHEMA intg2;")
# Create a table in the new schema
psql_manipulate(cred = cred_psql_docker,
                query_string =
                  "create table intg2.prices (
	id serial primary key,
	timestamp timestamp(0) without time zone ,
	open numeric(30,4),
	high numeric(30,4),
	low numeric(30,4),
	close numeric(30,4),
	volume numeric(30,4));")

# LOAD price data -------------------------------
psql_append_df(cred = cred_psql_docker,
               schema_name = "intg2",
               tab_name = "prices",
               df = df)

# Check results -----------------------------------------------------------
# Check that we can fetch the data again
psql_select(cred = cred_psql_docker,
            query_string =
              "select * from intg2.prices")

# If you wish, your can delete the schema (all the price data) from Postgres
psql_manipulate(cred = cred_psql_docker,
                query_string = "drop SCHEMA intg2 cascade;")
