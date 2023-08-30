#we will earn about the 5 key dplyr functions
  # 1. filter()
  #   pick observations by value
  # 2. arrange()
  #   reorder the rows
  # 3. select()
  #   pick vars by name
  # 4. mutate()
  #   create new vars with functions of existing vars
  # 5. summarize()
  #   collapse down to a summary
  # *** all work with group_by()

library(nycflights13)
library(tidyverse)
flights
# --------------------------------------------------------------------------------
# FILTER()
#grab flights on the first day of the year
filter(flights, month == 1, day == 1)
#can assign it
jan1 <- filter(flights, month == 1, day == 1)
#can assign it and print it
(jan1 <- filter(flights, month == 1, day == 1))
#good idea to use near() rather than ==
#grab flights in nov or dec
filter(flights,month==11 | month==12)
#another shorthand way too write
(nov_dec <- filter(flights,month %in% c(11,12)))
# use is.na(x) to find missing vals

#In a single pipeline for each condition, find all flights that meet the condition:

  # Had an arrival delay of two or more hours
    filter(flights, arr_delay>=2)
  # Flew to Houston (IAH or HOU)
    filter(flights,dest %in% c('IAH','HOU'))
  # Were operated by United, American, or Delta
    flights$carrier %>% unique()
    filter(flights, carrier %in% c('UA','AA','DL'))
  # Departed in summer (July, August, and September)
    filter(flights,month %in% c(7,8,9))
  # Arrived more than two hours late, but didn’t leave late
    filter(flights,dep_delay <= 0 & arr_delay > 0)
  # Were delayed by at least an hour, but made up over 30 minutes in flight
      ### STUMPED

  # how many flights have a missing dep_time? what else missing? What these rep?
    filter(flights, dep_time %>% is.na())
    filter(flights, dep_time %>% is.na()) %>% count()
      # also missing arr_time, dep_delay, arr_delay 
      # they could represent cancelled flights.
  
# -------------------------------------------------------------------------------- 
# ARRANGE()
    #changes order of rows
    
  #use arrange to shift NAs to start
    arrange(flights, dep_time %>% is.na() %>% desc())
  # sort flights to find the most delayed flights
    arrange(flights, desc(dep_delay))
  #find the flights that left the earliest
    arrange(flights, dep_time)
  #sort flights to find the fastest flight
    arrange(flights, air_time)
  #furthest travel
    arrange(flights, distance)
  #shortest travel
    arrange(flights, desc(distance))


# --------------------------------------------------------------------------------
# SELECT()
  #grab collumns
  #good with:
    # starts_with
    # ends_with
    # contains
    # matches (regular expressions)
    # num_range
    # everything() if you want to change order but keep all cols
  #rename() is a better way to rename variables
    
  variables <- c("year", "month", "day", "dep_delay", "arr_delay")
  select(flights, any_of(variables))
  select(flights, contains('TIME')) #not case sensitive
  
# --------------------------------------------------------------------------------
# MUTATE()
  #adds cols to data
  #Narrow your data
  flights_sml <- select(flights,
                        year:day,
                        ends_with('delay'),
                        distance,
                        air_time)
flights_sml  
mutate(flights_sml,
  gain = dep_delay - arr_delay,
  speed = distance / air_time * 60,
  .after = day)
#transmute()
  # only if you want to only look at the new cols you made

