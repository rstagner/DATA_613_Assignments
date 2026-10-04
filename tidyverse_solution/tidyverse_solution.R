if(!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, gapminder, broom)

#Question 1

#create the tribble dt, as per the instructions 
tribble( ~x,    ~y,    ~w,    ~z,
         210,   300,   220,   180,
         102,   100,   119,   187,
         176,   175,   188,   173,
         87,    95,   91,     94,
         202,   210,  234,    218,
         110,   122,  131,    128,
) -> dt

dt_mean <- map(dt, mean) #uses the purr command 'map' to find the mean of each column of dt
dt_mean

dt_sd <- map (dt, sd) #uses 'map' to find the sd of each column
dt_sd

dt_sqrt <- map_df(dt, sqrt) #uses 'map_df' and the function 'sqrt' to find the square root of each value
dt_sqrt

summary(dt) #use the summary function in base r to calculate summary stats for dt


#Question 2

#making the example solution loop function with 10 reps 

exp_means_loop <- function(n = 5, reps = 10) {
  means <- vector(mode = "numeric", length = reps) #creates a empty vector

for (i in 1:reps) {                #repeats = "reps"
  means[i] <- mean(rexp(n, rate = 1)) #draw n, take the mean, and store it in means
}

output <- data.frame(sample_mean = means) #creates a df from the means vector

#creates a histogram of the results
ggplot(output, aes(sample_mean)) +
  geom_histogram(binwidth = 0.1, fill = "blue", color = "white") +
  labs(title = paste("Means of", n, "draws from Exp(rate = 1)"),
       x = "Sample mean",
       y = "Count"
       )
}

exp_means_loop()

#Question 2a

#adding the map function and upping the reps to 10000

exp_means_loop_2a <- function(n = 5, reps = 10000) {

means_2a <- map_dbl(1:reps, function(i) mean(rexp(n, rate = 1))) #map function creates & fills vector

output_2a <- data.frame(sample_mean = means_2a) #creates a df from the means vector
  
#creates a histogram of the results
ggplot(output_2a, aes(sample_mean)) +
  geom_histogram(binwidth = 0.1, fill = "blue", color = "white") +
  labs(title = paste("Means of", n, "draws from Exp(rate = 1)"),
       x = "Sample mean",
       y = "Count"
  )
}

exp_means_loop_2a()

#2b using a replicate function

exp_means_loop_2b <- function(n = 5, reps = 10000) {
  
  means_2b <- replicate(reps, mean(rexp(n, rate = 1))) #replicate function creates & fills vector
  
  output_2b <- data.frame(sample_mean = means_2b) #creates a df from the means vector
  
  #creates a histogram of the results
  ggplot(output_2b, aes(sample_mean)) +
    geom_histogram(binwidth = 0.1, fill = "blue", color = "white") +
    labs(title = paste("Means of", n, "draws from Exp(rate = 1)"),
         x = "Sample mean",
         y = "Count"
    )
}
exp_means_loop_2b()

#2c using for loops for samples of 5, 10, 20

#create a loop that runs the function from 2a (with the map function) with
#the requested number of reps 

for (n in c(5, 10, 20)) {
  print(exp_means_loop_2a(n))
}

#Question 3

head(mtcars)
ncol(mtcars)
seq_along(mtcars)
mtcars[[1]]


q3_output <- vector("double", ncol(mtcars)) #creates the vector with same # of columns as the original df
for (i in seq_along(mtcars)) {      #I learned the fcn seq_along is to find position numbers
  q3_output[[i]] <- sd(mtcars[[i]]) #the for loop that takes each column and calculates sd
}
names(q3_output) <- names(mtcars) #labels the vector columns with the original column names from the df
q3_output

#Question 4

start_date <- mdy("01-01-2015") #create the start date
end_date <- mdy("12-31-2025") #creates the end date

dates <- seq(start_date, end_date, by = "2 months") #creates the sequence

#create a df that will extract each of the required information for each date
date_table <- data.frame(
  date = dates,
  year = year(dates),
  quarter = quarter(dates),
  ISO_week = isoweek(dates)
)

head(date_table) #prints the first few rows of the resulting table to confirm 
