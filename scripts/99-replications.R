#### Preamble ####
# Purpose: Replicated graphs from... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(bayesplot)
library(brms)
library(palmerpenguins)
library(rstanarm)
library(arrow)
library(readr)
library(dataverse)



#### Load data ####
ces2022_data<- dataverse::get_dataframe_by_name(
  filename = "CCES22_Common_OUTPUT_vv_topost.csv",
  dataset = "10.7910/DVN/PR4L8P",
  server = "dataverse.harvard.edu",
  .f = read_csv
) >select(votereg,TS_p2022_party,gender4,educ,race)

#### Clean data ####
clean_data<-
  cces2022_data |>
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

#### Data model ####
set.seed(853)
analysis_data <-
  clean_data
analysis_data$voted_for <- factor(analysis_data$voted_for)
analysis_data$gender <- factor(analysis_data$gender)
analysis_data$education <- factor(analysis_data$education)
analysis_data$race <- factor(analysis_data$race)

analysis_data <- 
  clean_data |> 
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

#### FIGURE 1 ####
clean_data |>
  ggplot(aes(x = education, fill = voted_for)) +
  stat_count(position = "dodge") +
  facet_wrap(facets = vars(gender)) +
  theme_minimal() +
  labs(
    x = "Highest education",
    y = "Number of respondents",
    fill = "Voted for"
  ) +
  coord_flip() +
  scale_fill_brewer(palette = "Set1") +
  theme(legend.position = "bottom")

#### FIGURE 2 ####
clean_data |>
  ggplot(aes(x = education, fill = voted_for)) +
  stat_count(position = "dodge") +
  facet_wrap(facets = vars(race)) +
  theme_minimal() +
  labs(
    x = "Highest education",
    y = "Number of respondents",
    fill = "Voted for"
  ) +
  coord_flip() +
  scale_fill_brewer(palette = "Set1") +
  theme(legend.position = "bottom")

#### FIGURE 3 ####
modelsummary::modelsummary(
  list(
    "Support Dem" = political_preferences
  ),
  statistic = "mad"
)

#### FIGURE 4 ####
mcmc_intervals(political_preferences, prob = 0.9) +
  labs(x = "90 per cent credibility interval")

#### FIGURE 5 ####
set.seed(853)

clean_data <- 
  clean_data |> 
  slice_sample(n = 5000)


pp_check(political_preferences) +
  theme_classic() +
  theme(legend.position = "bottom")




custom_palette <- c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999", "#66C2A5", "#FC8D62", "#8DA0CB", "#E78AC3", "#A6D854", "#FFD92F", "#E5C494")


posterior_vs_prior(political_preferences) +
  theme_minimal() +
  scale_color_manual(values = custom_palette) + 
  theme(legend.position = "bottom") +
  coord_flip()

#### FIGURE 6 ####
plot(political_preferences, "trace")

plot(political_preferences, "rhat")


