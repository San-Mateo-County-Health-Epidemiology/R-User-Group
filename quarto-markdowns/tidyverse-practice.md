# `tidyverse` practice

2022-11-17

``` r
library(tidyverse)
```

    ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ✔ dplyr     1.1.4     ✔ readr     2.1.5
    ✔ forcats   1.0.0     ✔ stringr   1.5.1
    ✔ ggplot2   3.5.0     ✔ tibble    3.2.1
    ✔ lubridate 1.9.3     ✔ tidyr     1.3.1
    ✔ purrr     1.0.2     
    ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ✖ dplyr::filter() masks stats::filter()
    ✖ dplyr::lag()    masks stats::lag()
    ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors

``` r
library(lubridate)
```

# background: in the COVID data, there is a variable for household id (hh_id). This is meant to link together one or more records (cases or contacts) that live in the same household. If there is only one record for a given household, then the hh_id is usually blank for that person.

<div class="panel-tabset">

## Plot

``` r
print('hey there')
```

    [1] "hey there"

## Data

tab 2!!

</div>

# question 1: how many households do we have —————

## look at the number of cases per household to see if any are weirdly high

sample_data %\>% count(hh_id) %\>% arrange(desc(n))

## filter out the missing hh_ids

sample_data %\>% filter(!is.na(hh_id)) %\>% distinct(hh_id) %\>% count()

# question 2: Who is the first case per household? (use episode date) ———

## group by household id, number the cases and only keep the first case

sample_data %\>% filter(!is.na(hh_id)) %\>% group_by(hh_id) %\>%
filter(n() \> 1) %\>% \# this is optional select(record_id,
episode_date, hh_id) %\>% arrange(hh_id, episode_date) %\>%
mutate(hh_case_num = row_number()) %\>% slice(1) %\>% \# instead of
slice you could also use: filter(hh_case_num == 1) ungroup()

# question 3: What is the average size of a household? —-

## don’t forget to de-duplicate to get one row per household (see distinct step)

sample_data %\>% filter(!is.na(hh_id)) %\>% group_by(hh_id) %\>%
mutate(hh_size = n()) %\>% ungroup() %\>% distinct(hh_id, hh_size) %\>%
summarize(total_hh = n(), min_hh_size = min(hh_size), avg_hh_size =
mean(hh_size), med_hh_size = median(hh_size), max_hh_size =
max(hh_size))

# question 4: can we have a table that shows each record per household and numbers the records by episode date? This can be wide or long. —-

## long

hh_ids_long \<- sample_data %\>% filter(!is.na(hh_id)) %\>%
select(hh_id, record_id, episode_date) %\>% group_by(hh_id) %\>%
arrange(episode_date) %\>% mutate(hh_case_num = row_number()) %\>%
select(hh_id, record_id, hh_case_num, episode_date)

## wide

hh_ids_wide \<- sample_data %\>% filter(!is.na(hh_id)) %\>%
select(hh_id, record_id, episode_date) %\>% group_by(hh_id) %\>%
arrange(episode_date) %\>% mutate(hh_case_num = paste0(“record_id\_”,
row_number())) %\>% select(-episode_date) %\>% pivot_wider(names_from =
hh_case_num, values_from = record_id) %\>% ungroup()

# bonus question 1: of the cases (not households), which sex had the most and which sex had the earliest case (use episode date to determine this)? Try to do this in only one code chunk!

sample_data %\>% group_by(sex) %\>% summarize(case_ct = n(), min_ep_date
= min(episode_date, na.rm = T)) %\>% ungroup() %\>%
arrange(desc(case_ct))

# bonus question 2: create a dataframe that shows the counts and percentages of cases by race_cat. Try to do this in only one code chunk!

sample_data %\>% count(race_cat) %\>% mutate(total_cases = sum(n), prop
= n/total_cases)
