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
    CasesPer100K = round(parse_number(`Average Daily Rate`), 1),
    Positivity = round(parse_number(`Percent Positivity`),3) * 100
  ) %>%
  filter(!is.na(County) & !is.na(CasesPer100K)) %>%
  select(Place, County, CasesPer100K, Positivity)

counties <- rio::import("data/weekly-dashboard-data-11-27-2020.xlsx", sheet = "county") %>%
  mutate(
    County = trimws(gsub(" Count[yi]e?s?", "", County)),
    CasesPer100K = round(parse_number(`Average Daily Incidence Rate per 100,000 (Last 14 days)`),1),
    Positivity = round(parse_number(`Percent Positivity (Last 14 days)`), 3) * 100
  ) %>%
  filter(!is.na(County) & !is.na(Positivity & County != "State")) %>%
  select(County, CasesPer100K, Positivity)
