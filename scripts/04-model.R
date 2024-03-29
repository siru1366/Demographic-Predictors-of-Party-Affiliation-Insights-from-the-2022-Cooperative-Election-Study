#### Preamble ####
# Purpose: Models political support in the United States
# Author: Sirui Tan 
# Date: 8 March 2024 
# Contact: sirui.tanr@utoronto.ca
# License: MIT
# Pre-requisites: NONE
# Any other information needed? NONE


#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(arrow)

#### Read data ####
set.seed(853)
analysis_data <-
  read_parquet(
    "data/analysis_data/cces2022_clean.parquet")
analysis_data$voted_for <- factor(analysis_data$voted_for)
analysis_data$gender <- factor(analysis_data$gender)
analysis_data$education <- factor(analysis_data$education)
analysis_data$race <- factor(analysis_data$race)

analysis_data <- 
  cces2022 |> 
  slice_sample(n = 5000)

political_preferences <-
  stan_glm(
    voted_for ~ gender + education + race,
    data = analysis_data,
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






