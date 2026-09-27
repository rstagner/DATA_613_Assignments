if(!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, gapminder, broom)

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
