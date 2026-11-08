#load packages
pacman::p_load(rvest, tidyverse, xml2, ipumsr)

# Part 2 - The Data Challenge
# Extract 1990 State Populations Status (Table NP1) for all states
# First, define the request
nhgis_request <- define_extract_agg(
  collection = "nhgis",
  description = "NHGIS Data via IPUMS API",
  datasets = ds_spec(
    "1990_STF1",
    data_tables = "NP1",
    geog_levels = "state"
  )
)
# Second, submit the request
submit_extract(nhgis_request, api_key = Sys.getenv("IPUMS_API_KEY"))

# Wait 
nhgis_request <- wait_for_extract(
  "nhgis:1",
  initial_delay_seconds = 0,
  max_delay_seconds = 300,
  timeout_seconds = 10800,
  verbose = TRUE,
  api_key = Sys.getenv("IPUMS_API_KEY")
)

# Download
downloaded_files <- download_extract(
  nhgis_request,
  download_dir = getwd(),
  overwrite = FALSE,
  progress = TRUE,
  api_key = Sys.getenv("IPUMS_API_KEY")
)

# Read the File
data_file <- "nhgis0001_csv.zip"
nhgis_data <- read_ipums_agg(data_file)

#look at file metadata
ipums_var_info(nhgis_data)

#Part 3 - Data Cleaning
#select and rename columns

nhgis_clean <- nhgis_data |> 
  select(
    gisjoin = GISJOIN,
    year = YEAR,
    state_abbr = STUSAB,
    division = DIVISIONA,
    region = REGIONA,
    state_name = STATE,
    state_code = STATEA,
    land_area = AREALAND,
    water_area = AREAWAT,
    total_pop = ET1001
  )

#Check to make sure it worked
head(nhgis_clean) 

#Part 4 Find Population Density
head(nhgis_clean) #check column types

nhgis_clean <- nhgis_clean |> 
  mutate(
    land_area = parse_number(land_area), #need to convert this to numeric from chr
    pop_density = total_pop / land_area #calculate the new column
  )

head(nhgis_clean) #check to make sure it worked

#Part 5 calculate Water Share

nhgis_clean <- nhgis_clean |> 
  mutate(
    water_area = parse_number(water_area), #convert water area to numeric
    water_share = water_area / (land_area + water_area) #calculate the new column
  )

head(nhgis_clean) #check work

#Section 2

#load the website into a variable
url <- "https://en.wikipedia.org/wiki/List_of_U.S._states_and_territories_by_population"

#reading the hmtl page
state_rankings <- read_html(url)

state_rankings |> 
  html_element("table.wikitable.sortable") |>
  html_table()

#install the janitor package
install.packages("janitor")

#clean the names
clean_table <- state_rankings |>
  janitor::clean_names()

head(clean_table)

#Section 2 with the code from the Example File
wikiurl <- read_html(
  "https://en.wikipedia.org/wiki/List_of_U.S._states_and_territories_by_population"
)

datatables <- wikiurl |>
  html_table()

ranking_table <- datatables[[1]]
ranking_table

#Part 2 - Clean the names

#View the column names
names(ranking_table)

names(ranking_table) <- c(
  "rank",
  "state",
  "population_estimate_2025",
  "population_2020",
  "house_seats",
  "house_seat_percent",
  "population_per_electoral_vote_2020",
  "population_per_house_seat_2020",
  "us_population_percent_2020",
  "electoral_college_percent_2020"
)

#get rid of the first row of extra text & the last 4 rows of summary data
clean_table <- ranking_table |>
  slice(2:(n() - 4))

#view the table
clean_table

#Part 3 - Fix the column types

clean_table2 <- clean_table |> mutate(
  rank = as.integer(rank),
  population_estimate_2025 = parse_number(population_estimate_2025),
  population_2020 = parse_number(population_2020),
  house_seats = parse_number(house_seats),
  house_seat_percent = (parse_number(house_seat_percent)/100),
  population_per_electoral_vote_2020 = parse_number(population_per_electoral_vote_2020),
  population_per_house_seat_2020 = parse_number(population_per_house_seat_2020),
  us_population_percent_2020 = (parse_number(us_population_percent_2020)/100),
  electoral_college_percent_2020 = (parse_number(electoral_college_percent_2020)/100)
)

#check work
glimpse(clean_table2)
