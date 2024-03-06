#### Preamble ####
# Purpose: Downloads and saves the data from [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(readr)
library(dataverse)
library(tidyverse)
# [...UPDATE THIS...]

#### Download data ####
# [...ADD CODE HERE TO DOWNLOAD...]

ces2022<- dataverse::get_dataframe_by_name(
  filename = "CCES22_Common_OUTPUT_vv_topost.csv",
  dataset = "10.7910/DVN/PR4L8P",
  server = "dataverse.harvard.edu",
  .f = read_csv
) 

  ces2022_raw <-ces2022|>select(votereg,TS_p2022_party,gender4,educ,race)
  write_csv(ces2022_raw, "data/raw_data/ces2022_raw.csv")



         
