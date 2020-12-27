# Get data from Covid Act Now API
# Need free API key from CovidActNow.org stored in an R environment variable COVID_ACT_NOW

library(dplyr)
library(httr)

my_url <- paste0("https://api.covidactnow.org/v2/states.csv?apiKey=", Sys.getenv("COVID_ACT_NOW"))

my_raw_result <- httr::GET(my_url)

latest_data <- httr::content(my_raw_result)

rio::export(latest_data, "data/latest_covid_by_state.csv")

my_url2 <- paste0("https://api.covidactnow.org/v2/states.timeseries.csv?apiKey=", Sys.getenv("COVID_ACT_NOW"))
download.file(my_url2, "data/all_covid_by_state.csv")


# Get Census regions
download.file("https://raw.githubusercontent.com/cphalpert/census-regions/master/us%20census%20bureau%20regions%20and%20divisions.csv", destfile = "data/census_regions.csv")
my_js_
