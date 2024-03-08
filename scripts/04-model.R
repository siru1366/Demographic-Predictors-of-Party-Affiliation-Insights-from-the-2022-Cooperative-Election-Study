#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(rstanarm)

#### Read data ####
set.seed(853)
cces2022 <-
  read_csv(
    "data/analysis_data/cces2022_clean.csv")
cces2022$voted_for <- factor(cces2022$voted_for)
cces2022$gender <- factor(cces2022$gender)
cces2022$education <- factor(cces2022$education)
cces2022$race <- factor(cces2022$race)

cces2022_reduced <- 
  cces2022 |> 
  slice_sample(n = 5000)

political_preferences <-
  stan_glm(
    voted_for ~ gender + education + race,
    data = cces2022_reduced,
    family = binomial(link = "logit"),
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = 
      normal(location = 0, scale = 2.5, autoscale = TRUE),
    seed = 853
  )

saveRDS(
  political_preferences,
  file = "models/political_preferences.rds"
)






