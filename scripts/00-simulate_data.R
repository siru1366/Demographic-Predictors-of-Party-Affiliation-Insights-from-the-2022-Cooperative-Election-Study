#### Preamble ####
# Purpose: Simulates... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(testthat)

#### Simulate data ####
set.seed(853)

num_obs <- 1000

us_political_preferences <- tibble(
  education = sample(0:4, size = num_obs, replace = TRUE),
  gender = sample(0:1, size = num_obs, replace = TRUE),
  race = sample(0:1, size = num_obs, replace = TRUE),
  support_prob = ((education + gender+race) / 5),
) |>
  mutate(
    supports_biden = if_else(runif(n = num_obs) < support_prob, "yes", "no"),
    education = case_when(
      education == 0 ~ "< High school",
      education == 1 ~ "High school",
      education == 2 ~ "Some college",
      education == 3 ~ "College",
      education == 4 ~ "Post-grad"
    ),
    gender = if_else(gender == 0, "Male", "Female"),
    race = if_else(gender == 0, "White", "Black")
  ) |>
  select(-support_prob, supports_biden, gender, education,race)

#### Test data ####
test_that("Number of observations is correct", {
  expect_equal(nrow(us_political_preferences), num_obs)
})

test_that("Education levels are categorized correctly", {
  expect_true(all(us_political_preferences$education %in% c("< High school", "High school", "Some college", "College", "Post-grad")))
})

test_that("Gender categories are assigned correctly", {
  expect_true(all(us_political_preferences$gender %in% c("Male", "Female")))
})

test_that("Race categories are assigned correctly", {
  expect_true(all(us_political_preferences$race %in% c("White", "Black")))
})

test_that("Support for Biden is categorized correctly", {
  expect_true(all(us_political_preferences$supports_biden %in% c("yes", "no")))
})

test_that("Probability calculation for supports_biden is within the expected range", {
  expect_true(all(us_political_preferences$supports_biden %in% c("yes", "no")))
})


