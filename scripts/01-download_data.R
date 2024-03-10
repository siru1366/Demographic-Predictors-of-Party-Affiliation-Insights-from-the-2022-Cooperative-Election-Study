#### Preamble ####
# Purpose: Downloads and saves the data from CCES2022
# Author: Sirui Tan
# Date: 8 March 2024 
# Contact: sirui.tan@utoronto.ca 
# License: MIT
# Pre-requisites: No
# Any other information needed? No


#### Workspace setup ####
library(readr)
library(dataverse)
library(tidyverse)


#### Download data ####

ces2022<- dataverse::get_dataframe_by_name(
  filename = "CCES22_Common_OUTPUT_vv_topost.csv",
  dataset = "10.7910/DVN/PR4L8P",
  server = "dataverse.harvard.edu",
  .f = read_csv
) 

  ces2022_raw <-ces2022|>select(votereg,TS_p2022_party,gender4,educ,race)
  write_csv(ces2022_raw, "data/raw_data/ces2022_raw.csv")



         
