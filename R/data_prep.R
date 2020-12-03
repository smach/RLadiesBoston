library(dplyr)
library(rio)
library(readr)

options(scipen = 999)
county_list <- rio::import("data/MACountiesAndPlaces.xlsx") %>%
  mutate(
    Place = gsub("*", "", Place, fixed = TRUE),
    Place = tolower(Place),
    County = gsub("((Dukes)|(Nantucket))", "Dukes and Nantucket", County)
  )
county_lookup <- county_list$County
names(county_lookup) <- trimws(county_list$Place)

places <- rio::import("data/weekly-dashboard-data-11-27-2020.xlsx", sheet = "City_town") %>%
  mutate(
    Place = trimws(gsub("*", "", `City/Town`, fixed = TRUE)),
    County = county_lookup[tolower(Place)],
    Cases = readr::parse_integer(`Two Week Case Counts`),
    Positivity = readr::parse_number(`Percent Positivity`)
  ) %>%
  filter(!is.na(County) & !is.na(Cases)) %>%
  select(Place, County, Cases, Positivity)

counties <- rio::import("data/weekly-dashboard-data-11-27-2020.xlsx", sheet = "county") %>%
  mutate(
    County = trimws(gsub(" Count[yi]e?s?", "", County)),
    Positivity = round(readr::parse_number(`Percent Positivity (Last 14 days)`), 3)
  ) %>%
  filter(!is.na(County) & !is.na(Positivity & County != "State")) %>%
  select(County, Cases = `Case Count (Last 14 Days)`, Positivity)
