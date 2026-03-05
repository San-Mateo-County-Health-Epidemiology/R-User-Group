# Age adjusted rates
Beth Jump
2026-03-05

## Background

Age adjusting rates removes confounding due to age and allows you to
compare the rates of an event across groups with different age
distributions. More detailed information in that
[here](https://www.health.ny.gov/diseases/chronic/ageadj.htm).

My rule of thumb is to calculate and use age adjusted rates whenever I
can. I don’t usually spend time comparing the underlying age
distributions. As long as you have population denominators and aren’t
stratifying by age, then you can and should calculate age adjusted
rates.

These are the general steps for calculating an age adjusted rate:

1.  Get the number of events and the estimated population by age group
2.  Calculate crude rates for each age group
3.  Apply the standard population weights from the 2000 US census to the
    crude rate for each age group
4.  Sum the weighted crude rates to get the age adjusted rate

## Examples

We’ll use the US 2000 population weights for the examples below.

``` r
library(tidyverse)
library(here)
library(zoo)

pop_weights <- rio::import(here('data', 'standard_population_weights_us_2000.xlsx')) %>%
  select(-c(characteristic, standard_pop))
```

### Introductory example

We’ll start with a basic example using made up data. Here we have two
populations: group A and group B. We have some information about the
frequency of an event and estimates of the population for each age
group.

``` r
data <- tribble(
  ~group, ~age_group, ~event_count, ~population,
  # group a
  'a', '0-9', 0, 100, 
  'a', '10-19', 0, 150, 
  'a', '20-29', 0, 150, 
  'a', '30-39', 0, 200, 
  'a', '40-49', 1, 300, 
  'a', '50-59', 5, 350, 
  'a', '60-69', 60, 500, 
  'a', '70-79', 200, 800,
  'a', '80+', 400, 1000, 
  # group b
  'b', '0-9', 0, 100, 
  'b', '10-19', 5, 150, 
  'b', '20-29', 20, 500, 
  'b', '30-39', 50, 800, 
  'b', '40-49', 60, 1000, 
  'b', '50-59', 50, 800, 
  'b', '60-69', 20, 500, 
  'b', '70-79', 5, 150,
  'b', '80+', 1, 100
)
data
```

    # A tibble: 18 × 4
       group age_group event_count population
       <chr> <chr>           <dbl>      <dbl>
     1 a     0-9                 0        100
     2 a     10-19               0        150
     3 a     20-29               0        150
     4 a     30-39               0        200
     5 a     40-49               1        300
     6 a     50-59               5        350
     7 a     60-69              60        500
     8 a     70-79             200        800
     9 a     80+               400       1000
    10 b     0-9                 0        100
    11 b     10-19               5        150
    12 b     20-29              20        500
    13 b     30-39              50        800
    14 b     40-49              60       1000
    15 b     50-59              50        800
    16 b     60-69              20        500
    17 b     70-79               5        150
    18 b     80+                 1        100

We can start by comparing the crude rates. When we do that, we see that
group A has a rate that is more than 3x higher than group B:

``` r
data %>% 
  group_by(group) %>% 
  summarize(total_events = sum(event_count), 
            total_pop = sum(population),
            .groups = "keep") %>% 
  ungroup() %>%
  mutate(crude_rate = total_events/total_pop)
```

    # A tibble: 2 × 4
      group total_events total_pop crude_rate
      <chr>        <dbl>     <dbl>      <dbl>
    1 a              666      3550     0.188 
    2 b              211      4100     0.0515

However, the population structures of these two groups are really
different. Group A is generally older while group B is exactly
symmetrical around the 40-49 year old group. Because the age structures
are different, we need to age adjust these rates in order to compare
them.

First we use the proportions from the US census file to apply the
population weights to the crude rates in each age group:

``` r
weighted_rates <- data %>%
  left_join(pop_weights, 
            by = c("age_group" = "age_category")) %>%
  mutate(crude = event_count/population*100000,
         weighted_crude = crude*standard_pop_weights) %>%
  rename(pop_wght = standard_pop_weights)
weighted_rates
```

    # A tibble: 18 × 7
       group age_group event_count population pop_wght  crude weighted_crude
       <chr> <chr>           <dbl>      <dbl>    <dbl>  <dbl>          <dbl>
     1 a     0-9                 0        100   0.141      0             0  
     2 a     10-19               0        150   0.145      0             0  
     3 a     20-29               0        150   0.136      0             0  
     4 a     30-39               0        200   0.154      0             0  
     5 a     40-49               1        300   0.151    333.           50.4
     6 a     50-59               5        350   0.110   1429.          158. 
     7 a     60-69              60        500   0.0723 12000           867. 
     8 a     70-79             200        800   0.0578 25000          1446. 
     9 a     80+               400       1000   0.0326 40000          1306. 
    10 b     0-9                 0        100   0.141      0             0  
    11 b     10-19               5        150   0.145   3333.          483. 
    12 b     20-29              20        500   0.136   4000           545. 
    13 b     30-39              50        800   0.154   6250           960. 
    14 b     40-49              60       1000   0.151   6000           907. 
    15 b     50-59              50        800   0.110   6250           690. 
    16 b     60-69              20        500   0.0723  4000           289. 
    17 b     70-79               5        150   0.0578  3333.          193. 
    18 b     80+                 1        100   0.0326  1000            32.6

Then we sum the `weighted_crude` rates in each group to get the age
adjusted rate. When we do this, we find that the age adjusted rate is
actually higher in group B even though the crude rate is lower.

``` r
weighted_rates %>%
  group_by(group) %>%
  summarize(total_events = sum(event_count),
            total_pop = sum(population),
            crude_rate = total_events/total_pop*100000,
            adjusted_rate = round(sum(weighted_crude, na.rm = T), 1),
            .groups = "keep") %>%
  ungroup()
```

    # A tibble: 2 × 5
      group total_events total_pop crude_rate adjusted_rate
      <chr>        <dbl>     <dbl>      <dbl>         <dbl>
    1 a              666      3550     18761.         3826.
    2 b              211      4100      5146.         4098.

By removing the confounding due to age, we can now compare the rates and
say the rate of the event is higher in group B!

### Calculating multiple rates at once

Often you need to calculate more than one age adjusted rate at once. In
the first example, we calculated two groups at once. As long as your
data are structured similarly, you can use the same method to calculate
many rates at once.

Here we have real denominators from the CA Department of Finance P3
estimate for California and for San Mateo County. We are making up
numerator values:

``` r
dof_denoms <- rio::import(here('data', 'dof-pop-estimates.xlsx'))

numerator = c(sample(26000:52000, size = 63, replace = T), sample(500:1000, size = 63, replace = T))

data1 <- dof_denoms %>%
  arrange(geography) %>%
  cbind(numerator)

data1 %>%
  arrange(age_cat, year, geography) %>% 
  slice(1:10)
```

       geography year age_cat population numerator
    1         CA 2020     0-9    4921778     41252
    2        SMC 2020     0-9      85593       633
    3         CA 2021     0-9    4790871     35558
    4        SMC 2021     0-9      83193       736
    5         CA 2022     0-9    4695166     35136
    6        SMC 2022     0-9      81846       920
    7         CA 2023     0-9    4590366     42364
    8        SMC 2023     0-9      80560       687
    9         CA 2024     0-9    4475403     38969
    10       SMC 2024     0-9      79069       884

Let’s calculate an age adjusted rate for CA and SMC for each year in the
data. We can do this by adjusting the `group_by()` statement from the
code above.

``` r
data1 %>%
  left_join(pop_weights, 
            by = c("age_cat" = "age_category")) %>%
  mutate(crude = numerator/population*100000,
         weighted_crude = crude*standard_pop_weights) %>%
  # now the group_by has year and geography:
  group_by(year, geography) %>%
  summarize(total_num = sum(numerator),
            total_pop = sum(population),
            crude_rate = total_num/total_pop*100000,
            adjusted_rate = round(sum(weighted_crude, na.rm = T), 1),
            .groups = "keep") %>%
  ungroup()
```

    # A tibble: 14 × 6
        year geography total_num total_pop crude_rate adjusted_rate
       <dbl> <chr>         <int>     <dbl>      <dbl>         <dbl>
     1  2020 CA           330970  39535726       837.          834.
     2  2020 SMC            6572    761474       863.          827.
     3  2021 CA           371576  39229543       947.          921.
     4  2021 SMC            7306    748738       976.          931.
     5  2022 CA           350670  39149809       896.          892.
     6  2022 SMC            6938    743000       934.          901.
     7  2023 CA           386110  39123861       987.          970.
     8  2023 SMC            6417    740929       866.          862.
     9  2024 CA           384541  39172742       982.          961.
    10  2024 SMC            7061    740468       954.          958 
    11  2025 CA           350894  39232359       894.          856.
    12  2025 SMC            6952    740262       939.          905 
    13  2026 CA           333120  39323732       847.          822.
    14  2026 SMC            6737    740593       910.          885.

### Calculating age adjusted rates for rolling sums

When I calculate age adjusted rates, I’m often asked to do it for
multiple timeframes, typically: single year, 3-year and 5-year rolling
sums.

First I calculate the rolling sums with the `zoo::rollsum()` function
and then I re-use the code from above. Here’s some code to calculate 3
and 5 year right aligned rolling sums.

Make sure you use `group_by()` and `arrange()` to ensure your data are
grouped and sorted correctly to calculate a rolling sum (or average).

``` r
roll_sum <- data1 %>%
  # create data groups
  group_by(geography, age_cat) %>%
  # sort by year within groups
  arrange(year) %>%
  # calculate the right-aligned rolling sums 
  mutate(num_3 = rollsum(numerator, 3, align = "right", na.pad = T),
         num_5 = rollsum(numerator, 5, align = "right", na.pad = T),
         pop_3 = rollsum(population, 3, align = "right", na.pad = T),
         pop_5 = rollsum(population, 5, align = "right", na.pad = T)) %>%
  rename(num_1 = numerator,
         pop_1 = population) %>%
  ungroup()

roll_sum %>%
  filter(age_cat == '0-9' & geography == "SMC") %>%
  head(6)
```

    # A tibble: 6 × 9
      geography  year age_cat pop_1 num_1 num_3 num_5  pop_3  pop_5
      <chr>     <dbl> <chr>   <dbl> <int> <int> <int>  <dbl>  <dbl>
    1 SMC        2020 0-9     85593   633    NA    NA     NA     NA
    2 SMC        2021 0-9     83193   736    NA    NA     NA     NA
    3 SMC        2022 0-9     81846   920  2289    NA 250632     NA
    4 SMC        2023 0-9     80560   687  2343    NA 245599     NA
    5 SMC        2024 0-9     79069   884  2491  3860 241475 410261
    6 SMC        2025 0-9     76983   624  2195  3851 236612 401651

Reshape the data so all of the numerator and denominator variable names
are in a column and all of the values are in a another column:

``` r
roll_sum1 <- roll_sum %>%
  pivot_longer(names_to = "name",
               values_to = "estimate",
               cols = matches("^num|^pop"),
               values_drop_na = T) 
roll_sum1 %>%
  filter(year == 2026 & age_cat == '0-9' & geography == "SMC") 
```

    # A tibble: 6 × 5
      geography  year age_cat name  estimate
      <chr>     <dbl> <chr>   <chr>    <dbl>
    1 SMC        2026 0-9     pop_1    75201
    2 SMC        2026 0-9     num_1      553
    3 SMC        2026 0-9     num_3     2061
    4 SMC        2026 0-9     num_5     3668
    5 SMC        2026 0-9     pop_3   231253
    6 SMC        2026 0-9     pop_5   393659

Separate the variable containing the numerator and denominator variable
names (`name`) into two columns `num_denom` and `year_count`:

``` r
roll_sum2 <- roll_sum1 %>%
  separate(name, 
           c("num_denom", "year_count"),
           sep = "_") 

roll_sum2 %>%
  filter(year == 2026 & age_cat == '0-9' & geography == "SMC") 
```

    # A tibble: 6 × 6
      geography  year age_cat num_denom year_count estimate
      <chr>     <dbl> <chr>   <chr>     <chr>         <dbl>
    1 SMC        2026 0-9     pop       1             75201
    2 SMC        2026 0-9     num       1               553
    3 SMC        2026 0-9     num       3              2061
    4 SMC        2026 0-9     num       5              3668
    5 SMC        2026 0-9     pop       3            231253
    6 SMC        2026 0-9     pop       5            393659

Reshape the data so you have a column for numerator values and a column
for denominator values:

``` r
roll_sum3 <- roll_sum2 %>%
  pivot_wider(names_from = num_denom,
              values_from = estimate) 

roll_sum3 %>%
  filter(year == 2026 & age_cat == '0-9' & geography == "SMC") 
```

    # A tibble: 3 × 6
      geography  year age_cat year_count    pop   num
      <chr>     <dbl> <chr>   <chr>       <dbl> <dbl>
    1 SMC        2026 0-9     1           75201   553
    2 SMC        2026 0-9     3          231253  2061
    3 SMC        2026 0-9     5          393659  3668

Now you can use the same code we’ve used before to calculate age
adjusted rates for the single years and rolling sums. Just add
`year_count` to the `group_by()` step:

``` r
roll_sum4 <- roll_sum3 %>% 
  left_join(pop_weights, 
            by = c("age_cat" = "age_category")) %>%
  mutate(crude = num/pop*100000,
         weighted_crude = crude*standard_pop_weights) %>%
  # now the group_by has year, geography and year_count:
  group_by(year, geography, year_count) %>%
  summarize(total_num = sum(num),
            total_pop = sum(pop),
            crude_rate = total_num/total_pop*100000,
            adjusted_rate = round(sum(weighted_crude, na.rm = T), 1),
            .groups = "keep") %>%
  ungroup() 
roll_sum4 %>%
  filter(year == 2026)
```

    # A tibble: 6 × 7
       year geography year_count total_num total_pop crude_rate adjusted_rate
      <dbl> <chr>     <chr>          <dbl>     <dbl>      <dbl>         <dbl>
    1  2026 CA        1             333120  39323732       847.          822.
    2  2026 CA        3            1068555 117728833       908.          879.
    3  2026 CA        5            1805335 196002503       921.          899.
    4  2026 SMC       1               6737    740593       910.          885.
    5  2026 SMC       3              20750   2221323       934.          916.
    6  2026 SMC       5              34105   3705252       920.          901.
