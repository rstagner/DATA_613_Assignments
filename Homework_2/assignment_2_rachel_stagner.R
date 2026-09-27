library(tidyverse) #load tidyverse library

college_data <- read_csv("./data/collegedata.csv") #load collegedata.csv

glimpse(college_data) #view the rows and column information for the dataframe

#create a new dataframe that has the requested columns
admission_rates <- college_data |> select(INSTNM, SAT_AVG, ADM_RATE)

#confirming the new dataframe:
glimpse(admission_rates)

cleaned_data <- admission_rates |> drop_na() #drop rows with NA values
glimpse(cleaned_data) #confirm dropped values

#create a new plot 
  ggplot(cleaned_data, aes(x = SAT_AVG, y = ADM_RATE)) + #create the plot
  geom_point(color="blue") +
  labs(x = "Average SAT Score", #apply labels
       y = "Admission Rate", 
       title = "Average SAT Scores versus Admission Rates",
       subtitle = "Each point is an individual college or university") +
  theme_bw() #apply theme
