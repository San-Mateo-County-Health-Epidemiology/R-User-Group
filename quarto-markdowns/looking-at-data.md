# looking at data
Beth Jump
2022-06-16

## Overview

This goes through some basic methods for looking at data. These methods
should be used any time you get a new data set.

``` r
library(tidyverse)

data <- palmerpenguins::penguins
```

## Methods

We’ll focus on some basic methods for reviewing and cleaning your data.
We’ll look at:

- generating summary statistics for a variable
- looking at unique values for a variable
- de-duplicating data

### Summary statistics

The `dplyr::summarize()` function is great for looking at the
distribution of variables in your data set. You can add a `group_by()`
statement before the `summarize()` function to get summary statistics
for specific values within a variable.

Here is one way to get the distribution of `body_mass_g` by penguin
species:

``` r
data %>%
  group_by(species) %>%
  summarize(total = n(),
            min = min(body_mass_g, na.rm = T),
            median = median(body_mass_g, na.rm = T),
            mean = mean(body_mass_g, na.rm = T),
            sd = sd(body_mass_g, na.rm = T),
            max = max(body_mass_g, na.rm = T),
            nas = sum(is.na(body_mass_g))) %>%
  ungroup()
```

    # A tibble: 3 × 8
      species   total   min median  mean    sd   max   nas
      <fct>     <int> <int>  <dbl> <dbl> <dbl> <int> <int>
    1 Adelie      152  2850   3700 3701.  459.  4775     1
    2 Chinstrap    68  2700   3700 3733.  384.  4800     0
    3 Gentoo      124  3950   5000 5076.  504.  6300     1

Base R also has a useful function called `summary()` that will give you
the numeric distribution of a variable with a lot less code than
`summarize()`. Here’s the distribution of `body_mass_g` for all
penguins:

``` r
summary(data$body_mass_g)
```

       Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
       2700    3550    4050    4202    4750    6300       2 

`summary()` also works with categorical variables:

``` r
summary(data$species)
```

       Adelie Chinstrap    Gentoo 
          152        68       124 

### Unique values

You can use `dplyr::distinct()` and `dplyr::count()` to look at the
values within a variable. `distinct()` returns only the values while
`count()` returns the values and their frequencies. If you’re working
with a large data set, `count()` will take longer to run than
`distinct()`.

#### distinct()

``` r
data %>%
  distinct(species)
```

    # A tibble: 3 × 1
      species  
      <fct>    
    1 Adelie   
    2 Gentoo   
    3 Chinstrap

#### count()

``` r
data %>%
  count(species)
```

    # A tibble: 3 × 2
      species       n
      <fct>     <int>
    1 Adelie      152
    2 Chinstrap    68
    3 Gentoo      124

### De-duplicating data

#### Identifying duplicates

You should always check for duplicates in your data. There are many ways
to do this, but my favorite is with `group_by()` and `filter(n() > 1)`.
`filter(n() > 1)` will keep any groups that have more than one
observation in them. If this filter returns an empty data set, then you
know that the selection of variables in your `group_by()` statement will
identify unique observations.

Can we identify unique penguins by only looking at `species`, `island`,
`year`, `sex` and `body_mass_g`?

``` r
data %>%
  group_by(species, island, year, sex, body_mass_g) %>%
  filter(n() > 1) %>%
  arrange(species, island, year, sex, body_mass_g)
```

    # A tibble: 110 × 8
    # Groups:   species, island, year, sex, body_mass_g [50]
       species island bill_length_mm bill_depth_mm flipper_length_mm body_mass_g
       <fct>   <fct>           <dbl>         <dbl>             <int>       <int>
     1 Adelie  Biscoe           35.9          19.2               189        3800
     2 Adelie  Biscoe           35.3          18.9               187        3800
     3 Adelie  Biscoe           38.2          18.1               185        3950
     4 Adelie  Biscoe           40.5          18.9               180        3950
     5 Adelie  Biscoe           36.5          16.6               181        2850
     6 Adelie  Biscoe           36.4          17.1               184        2850
     7 Adelie  Biscoe           42            19.5               200        4050
     8 Adelie  Biscoe           41.1          18.2               192        4050
     9 Adelie  Dream            39.5          17.8               188        3300
    10 Adelie  Dream            37.6          19.3               181        3300
    # ℹ 100 more rows
    # ℹ 2 more variables: sex <fct>, year <int>

No. All of the rows in the table are duplicates.

Can we identify unique penguins by looking at `species`, `island`,
`year`, `sex`, `body_mass_g`, `flipper_length_mm` and `bill_length_mm`?

``` r
data %>%
  group_by(species, island, year, sex, body_mass_g, flipper_length_mm, bill_length_mm) %>%
  filter(n() > 1) %>%
  arrange(species, island, year, sex, body_mass_g)
```

    # A tibble: 0 × 8
    # Groups:   species, island, year, sex, body_mass_g, flipper_length_mm,
    #   bill_length_mm [0]
    # ℹ 8 variables: species <fct>, island <fct>, bill_length_mm <dbl>,
    #   bill_depth_mm <dbl>, flipper_length_mm <int>, body_mass_g <int>, sex <fct>,
    #   year <int>

We can!!

#### De-duplicating methods

You can de-duplicate data indiscriminately with `distinct()` or you can
do it a bit more carefully with a combination of `group_by()`,
`arrange()` and `slice()` or if you need to combine groups, you can use
`summarize()`.

If we only want to keep one penguin of each species on each island, but
don’t care which penguin we keep, we can use `distinct()`.

``` r
data %>%
  distinct(species, island, .keep_all = T)
```

    # A tibble: 5 × 8
      species   island    bill_length_mm bill_depth_mm flipper_length_mm body_mass_g
      <fct>     <fct>              <dbl>         <dbl>             <int>       <int>
    1 Adelie    Torgersen           39.1          18.7               181        3750
    2 Adelie    Biscoe              37.8          18.3               174        3400
    3 Adelie    Dream               39.5          16.7               178        3250
    4 Gentoo    Biscoe              46.1          13.2               211        4500
    5 Chinstrap Dream               46.5          17.9               192        3500
    # ℹ 2 more variables: sex <fct>, year <int>

If we’re doing downstream analyses, we probably want to select our
penguins a bit more carefully. We can do this with `group_by()`,
`arrange()` and `slice()`. Here’s how we would keep the penguin with the
smallest bill length for each species and island:

``` r
data %>%
  group_by(species, island) %>%
  arrange(bill_length_mm) %>%
  slice(1) %>%
  ungroup()
```

    # A tibble: 5 × 8
      species   island    bill_length_mm bill_depth_mm flipper_length_mm body_mass_g
      <fct>     <fct>              <dbl>         <dbl>             <int>       <int>
    1 Adelie    Biscoe              34.5          18.1               187        2900
    2 Adelie    Dream               32.1          15.5               188        3050
    3 Adelie    Torgersen           33.5          19                 190        3600
    4 Chinstrap Dream               40.9          16.6               187        3200
    5 Gentoo    Biscoe              40.9          13.7               214        4650
    # ℹ 2 more variables: sex <fct>, year <int>

If we want to calculate summary statistics about sub-groups, we can use
`summarize()` to get these values and de-duplicate our data. Here’s how
to get the average bill length for each species and island:

``` r
data %>%
  group_by(species, island) %>%
  summarize(avg_bill_length = mean(bill_length_mm, na.rm = T),
            .groups = "keep") %>%
  ungroup()
```

    # A tibble: 5 × 3
      species   island    avg_bill_length
      <fct>     <fct>               <dbl>
    1 Adelie    Biscoe               39.0
    2 Adelie    Dream                38.5
    3 Adelie    Torgersen            39.0
    4 Chinstrap Dream                48.8
    5 Gentoo    Biscoe               47.5
