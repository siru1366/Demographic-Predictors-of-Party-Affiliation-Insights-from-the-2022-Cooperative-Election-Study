#### Preamble ####
# Purpose: Cleans the raw plane data recorded by two observers..... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 6 April 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]

#### Workspace setup ####
library(arrow)
library(tidyverse)
library(dplyr)


#### Clean data ####


cces2022 <-
  read_csv(
    "data/raw_data/ces2022_raw.csv",col_types =
      cols(
        "votereg" = col_integer(),
        "TS_p2022_party" = col_integer(),
        "gender4" = col_integer(),
        "educ" = col_integer(),
        "race" = col_integer()
      )
  )


cces2022<-
  cces2022 |>
  filter(votereg == 1,
         TS_p2022_party %in% c(1, 6)
         )|>
  mutate(
    voted_for = if_else(TS_p2022_party == 1, "Dem", "Rep"),
    voted_for = as_factor(voted_for),
    gender = if_else(gender4 == 1, "Male", "Female"),
    gender = case_when(
      gender4 == 1 ~ "Man",
      gender4 == 2 ~ "Woman",
      gender4 == 3 ~ "Non-binary",
      gender4 == 4 ~ "Other"
    ),
    gender = factor(
      gender,
      levels = c(
        "Man",
        "Woman",
        "Non-binary",
        "Other"
      )
    ),
    education = case_when(
      educ == 1 ~ "No HS",
      educ == 2 ~ "High school graduate",
      educ == 3 ~ "Some college",
      educ == 4 ~ "2-year",
      educ == 5 ~ "4-year",
      educ == 6 ~ "Post-grad"
    ),
    education = factor(
      education,
      levels = c(
        "No HS",
        "High school graduate",
        "Some college",
        "2-year",
        "4-year",
        "Post-grad"
      )
    ),
    race = case_when(
      race == 1 ~ "White",
      race == 2 ~ "Black",
      race == 3 ~ "Hispanic",
      race == 4 ~ "Asian",
      race == 5 ~ "Native American",
      race == 6 ~ "Middle Eastern",
      race == 7 ~ "Two or more races",
      race == 8 ~ "Other"
    ),
    race = factor(
      race,
      levels = c(
        "White",
        "Black",
        "Hispanic",
        "Asian",
        "Native American",
        "Middle Eastern",
        "Two or more races",
        "Other"
      )
    )
  ) |>
  select(voted_for, gender, education,race)

#### Save data ####
write_parquet(cces2022, "data/analysis_data/cces2022_clean.parquet")