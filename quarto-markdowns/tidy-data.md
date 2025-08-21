# tidy data
Beth Jump
2022-03-23

## Background

There’s a great explanation
[here](https://www.statology.org/long-vs-wide-data/#:~:text=A%20dataset%20can%20be%20written,repeat%20in%20the%20first%20column.)
about wide vs long data. Tidy data sits somewhere between wide and long
data. The guiding principle for tidy data is that each variable has its
own column and each observation has its own row. More information on
tidy data is here [here](https://r4ds.had.co.nz/tidy-data.html). Tidy
data often closely resembles long data.

Your data will always be easier to work with in a tidy format. Instead
of performing a calculation or function on a variable that is split
across columns (like you would in a wide format), you can do a
calculation on a single column. You should practice using `pivot_longer`
to get your data into a tidy (long) format.

## Wide and tidy data in action

### Overview

Let’s go through some examples of wide and tidy data with the
`palmerpenguins::penguins` data set, This data is already in a tidy
format:

``` r
library(tidyverse)

data <- palmerpenguins::penguins
head(data)
```

    # A tibble: 6 × 8
      species island    bill_length_mm bill_depth_mm flipper_length_mm body_mass_g
      <fct>   <fct>              <dbl>         <dbl>             <int>       <int>
    1 Adelie  Torgersen           39.1          18.7               181        3750
    2 Adelie  Torgersen           39.5          17.4               186        3800
    3 Adelie  Torgersen           40.3          18                 195        3250
    4 Adelie  Torgersen           NA            NA                  NA          NA
    5 Adelie  Torgersen           36.7          19.3               193        3450
    6 Adelie  Torgersen           39.3          20.6               190        3650
    # ℹ 2 more variables: sex <fct>, year <int>

To illustrate wide vs tidy data, we’ll look at the distribution of
species by year. Here’s our tidy version of those frequencies:

``` r
data_long <- data %>%
  count(year, species)
data_long
```

    # A tibble: 9 × 3
       year species       n
      <int> <fct>     <int>
    1  2007 Adelie       50
    2  2007 Chinstrap    26
    3  2007 Gentoo       34
    4  2008 Adelie       50
    5  2008 Chinstrap    18
    6  2008 Gentoo       46
    7  2009 Adelie       52
    8  2009 Chinstrap    24
    9  2009 Gentoo       44

Here’s our wide version of the frequencies:

``` r
data_wide <- data_long %>% 
  pivot_wider(names_from = species, 
              values_from = n)
data_wide
```

    # A tibble: 3 × 4
       year Adelie Chinstrap Gentoo
      <int>  <int>     <int>  <int>
    1  2007     50        26     34
    2  2008     50        18     46
    3  2009     52        24     44

Note: we often share data in a wide format because our data consumers
aren’t used to looking at long data. It’s OK to share data in a wide
format but it’s best practice to work with data in a long format.

### Summarizing by year

Let’s see how we can get the total number of penguins identified **per
year** with each of our data formats:

Here’s how we could do it with wide data:

``` r
data_wide %>%
  rowwise() %>%
  mutate(total_penguins = sum(Adelie, Chinstrap, Gentoo)) %>%
  ungroup()
```

    # A tibble: 3 × 5
       year Adelie Chinstrap Gentoo total_penguins
      <int>  <int>     <int>  <int>          <int>
    1  2007     50        26     34            110
    2  2008     50        18     46            114
    3  2009     52        24     44            120

And here’s how we could do it with long data:

``` r
data_long %>%
  group_by(year) %>%
  summarize(total_penguins = sum(n),
            .groups = "keep") %>%
  ungroup()
```

    # A tibble: 3 × 2
       year total_penguins
      <int>          <int>
    1  2007            110
    2  2008            114
    3  2009            120

They both required about the same amount of code, but the code in the
long method is more flexible because it doesn’t mention any species
explicitly - it just uses the variable name `species`. If an additional
species were added to this data set, the long code would still work
while the wide code would need to be edited to include the additional
species.

### Summarizing by species

Now let’s see how we can get the total number of penguins identified
**by species** with each of our data formats:

With the wide table, we’d need to sum each species manually:

``` r
data_wide %>%
  mutate(adelie = sum(Adelie),
         chinstrap = sum(Chinstrap),
         gentoo = sum(Gentoo)) %>%
  slice(1) %>%
  select(adelie, chinstrap, gentoo)
```

    # A tibble: 1 × 3
      adelie chinstrap gentoo
       <int>     <int>  <int>
    1    152        68    124

With the long table, this is very easy. We can just take the code from
the previous example and swap `group_by(year)` with `group_by(species)`:

``` r
data_long %>%
  group_by(species) %>%
  summarize(total_penguins = sum(n),
            .groups = "keep") %>%
  ungroup()
```

    # A tibble: 3 × 2
      species   total_penguins
      <fct>              <int>
    1 Adelie               152
    2 Chinstrap             68
    3 Gentoo               124

## Working with tidy data

There are a few helpful functions to know when working with data in a
tidy format:

- `dplyr::lead()`: this pulls the value from the next row into the
  current one
- `dplyr::lag()`: the inverse of lead, this pulls the value from the
  previous row into the current one
- `dplyr::arrange()`: this sorts your data so you know where you’re
  leading and lagging from
- `zoo::rollmean()`: this allows you to calculate a rolling average for
  a variable
- `dplyr::row_number()`: this tells you the row number of an observation
  within a group
- `dplyr::n()`: this tells you the size of the group

### `lead()` and `lag()`

Let’s say we want to know the change in penguins identified by year. We
can use lead and lag to do this. First we’ll calculate the total number
of penguins identified by year:

``` r
spec_by_year <- data %>%
  count(year)
spec_by_year
```

    # A tibble: 3 × 2
       year     n
      <int> <int>
    1  2007   110
    2  2008   114
    3  2009   120

Then we can use `lead()` or `lag()` to get the change:

``` r
spec_by_year %>%
  arrange(year) %>%
  mutate(last_year_ct = lag(n),
         change_from_last_year = n - last_year_ct)
```

    # A tibble: 3 × 4
       year     n last_year_ct change_from_last_year
      <int> <int>        <int>                 <int>
    1  2007   110           NA                    NA
    2  2008   114          110                     4
    3  2009   120          114                     6

We get an `NA` for the first row in `last_year_ct` because it is the
first row in our data set and has nothing to `lag` from. If we were to
do this same process but with `lead()` we would have an `NA` in the last
row.

### `row_number()` and `n()`

We can use `row_number()` and `n()` to identify the smallest and largest
observations in a tidy data set.

Which penguins have the largest and smalled `body_mass_g`?

``` r
data %>%
  arrange(body_mass_g) %>%
  filter(!is.na(body_mass_g)) %>%
  mutate(small_or_large = case_when(row_number() == 1 ~ "smallest",
                                    row_number() == n() ~ "largest")) %>%
  filter(!is.na(small_or_large))
```

    # A tibble: 2 × 9
      species   island bill_length_mm bill_depth_mm flipper_length_mm body_mass_g
      <fct>     <fct>           <dbl>         <dbl>             <int>       <int>
    1 Chinstrap Dream            46.9          16.6               192        2700
    2 Gentoo    Biscoe           49.2          15.2               221        6300
    # ℹ 3 more variables: sex <fct>, year <int>, small_or_large <chr>

### `rollmean()`

If you’re working with many years of data, you might need to calculate
rolling means or sums. This is very easy when your data are in a tidy
format.

We’ll illustrate how to do this with the `palmerpenguins::penguins` data
set, but you would typically apply this code to temporal or grouped
data. I often use this to calculate life expectancy for a 3 or 5 year
period.

Here’s how to calculate a centered rolling average of `body_mass_g` for
groups of 5:

``` r
library(zoo)

data %>%
  select(species, island, sex, body_mass_g) %>% 
  filter(!is.na(body_mass_g)) %>%
  arrange(body_mass_g) %>%
  mutate(roll_avg_5 = rollmean(body_mass_g,
                               5, 
                               na.pad = T,
                               align = "center")) %>%
  head(7)
```

    # A tibble: 7 × 5
      species   island    sex    body_mass_g roll_avg_5
      <fct>     <fct>     <fct>        <int>      <dbl>
    1 Chinstrap Dream     female        2700         NA
    2 Adelie    Biscoe    female        2850         NA
    3 Adelie    Biscoe    female        2850       2840
    4 Adelie    Biscoe    female        2900       2880
    5 Adelie    Dream     female        2900       2890
    6 Adelie    Torgersen female        2900       2905
    7 Chinstrap Dream     female        2900       2920
