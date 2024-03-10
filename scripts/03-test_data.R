#### Preamble ####
# Purpose: Tests... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(testthat)
library(arrow)

#### Test data ####
cces2022 <-
  read_parquet(file = here::here("data/analysis_data/cces2022_clean.parquet"))

test_that("Number of observations is correct", {
  expect_true(nrow(cces2022) > 0)
})

test_that("All records have valid values for voted_for", {
  expect_true(all(cces2022$voted_for %in% c("Dem", "Rep")))
})

test_that("All records have valid values for gender", {
  expect_true(all(cces2022$gender %in% c("Man", "Woman", "Non-binary", "Other")))
})


test_that("All records have valid values for education", {
  expect_true(all(cces2022$education %in% c("No HS", "High school graduate", "Some college", "2-year", "4-year", "Post-grad")))
})

test_that("All records have valid values for race", {
  expect_true(all(cces2022$race %in% c("White", "Black", "Hispanic", "Asian", "Native American", "Middle Eastern", "Two or more races", "Other")))
})

test_that("No missing values in the dataset", {
  expect_false(any(is.na(cces2022)))
})
