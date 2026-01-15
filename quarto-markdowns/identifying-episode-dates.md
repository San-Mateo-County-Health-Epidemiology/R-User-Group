# Identifying episode dates
Beth Jump
2023-08-03

## Background

During the COVID-19 pandemic, we were really concerned with “episode
dates” for each case. An episode date was defined as the earliest date
of any of these four dates:

- symptom onset
- specimen collection
- result date
- date of death

We needed a method to calculate episode dates per person efficiently.

## In practice:

Consider these fake data. Here we have symptom onset (`sx_onset`),
specimen collection (`spec_coll`), result (`result`) and death (`dod`)
dates for 5 people with COVID:

``` r
library(tidyverse)

data <- tribble(
  ~record, ~sx_onset, ~spec_coll, ~result, ~dod,
  "1", "2020-04-01", "2020-04-02", "2020-04-05", NA_character_,
  "2", NA_character_, "2020-04-10", "2020-04-10", NA_character_,
  "3", NA_character_, NA_character_, NA_character_, "2020-04-13",
  "4", "2020-04-04", "2020-04-02", "2020-04-03", "2020-04-09",
  "5", "2020-04-08", NA_character_, "2020-04-05", NA_character_,
) %>%
  mutate(across(-c(record), ~ as.Date(.x)))
data
```

    # A tibble: 5 × 5
      record sx_onset   spec_coll  result     dod       
      <chr>  <date>     <date>     <date>     <date>    
    1 1      2020-04-01 2020-04-02 2020-04-05 NA        
    2 2      NA         2020-04-10 2020-04-10 NA        
    3 3      NA         NA         NA         2020-04-13
    4 4      2020-04-04 2020-04-02 2020-04-03 2020-04-09
    5 5      2020-04-08 NA         2020-04-05 NA        

We need to figure out the episode date for each person. One might be
tempted to do something like this:

    data %>%
      mutate(episode_date = case_when(sx_onset <= spec_coll & sx_onset <= result & sx_onset <= dod & !is.na(sx_onset) ~ sx_onset,
                                      coll_date <= result & coll_date <= dod ~ coll_date,
                                      ...))

This will ultimately work, but it’s a headache to think through all of
the logic permutations and even more of a headache to write them out.

Instead, you can simply reshape your data, sort by person and get the
episode date quickly and easily:

``` r
data %>%
  pivot_longer(names_to = "vars",
               values_to = "vals",
               cols = -c(record),
               values_drop_na = T) %>%
  # group data so subsequent operations occur in groups
  group_by(record) %>%
  # sort each group by date (from oldest to newest)
  arrange(vals) %>%
  # slice to keep the first observation per group
  slice(1) %>%
  # ungroup the data
  ungroup() %>%
  # rename the variables 
  rename(episode_date_source = vars,
         episode_date = vals)
```

    # A tibble: 5 × 3
      record episode_date_source episode_date
      <chr>  <chr>               <date>      
    1 1      sx_onset            2020-04-01  
    2 2      spec_coll           2020-04-10  
    3 3      dod                 2020-04-13  
    4 4      spec_coll           2020-04-02  
    5 5      result              2020-04-05  
