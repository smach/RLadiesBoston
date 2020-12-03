library(dplyr)
library(rio)
library(readr)

county_list <- rio::import("data/MACountiesAndPlaces.xlsx") %>%
  mutate(
    Place = gsub("*", "", Place, fixed = TRUE),
    Place = tolower(Place)
  )
county_lookup <- county_list$County
names(county_lookup) <- trimws(county_list$Place)

mydata <- rio::import("data/weekly-dashboard-data-11-27-2020.xlsx", sheet = "City_town") %>%
  mutate(
    Place = trimws(gsub("*", "", `City/Town`, fixed = TRUE)),
    County = county_lookup[tolower(Place)],
    Cases = readr::parse_integer(`Total Case Counts`),
    Positivity = readr::parse_number(`Percent Positivity`)
  ) %>%
  filter(!is.na(County) & !is.na(Cases)) %>%
  select(Place, County, Cases, Positivity)
