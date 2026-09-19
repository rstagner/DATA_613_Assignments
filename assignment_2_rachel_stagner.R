library(tidyverse) #load tidyverse library

college_data <- read_csv("./data/collegedata.csv") #load collegedata.csv

glimpse(college_data) #view the rows and column information for the dataframe

#create a new dataframe that has the requested columns
admission_rates <- college_data |> select(INSTNM, SAT_AVG, ADM_RATE)

#confirming the new dataframe:
glimpse(admission_rates)
