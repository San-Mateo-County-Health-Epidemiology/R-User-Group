# `dplyr` practice part 1
Beth Jump
2022-11-17

## Background

[`dplyr`](https://dplyr.tidyverse.org/) is a package within the
[`tidyverse`](https://tidyverse.org/) ecosystem that is focused on basic
data wrangling.

## Examples

We’re going to walk through how to solve some basic data tasks using
functions from the `dplyr` package using the
[palmerpenguins](https://allisonhorst.github.io/palmerpenguins/) data
set.

``` r
library(dplyr)
data <- palmerpenguins::penguins_raw
```

There are six questions and example solutions below. If your solution
code is different but you get to the same answer, that is totally fine!

### 1. How many unique studies are in this data set and how many penguins are in each?

You can use the `count()` or `distinct()` function to get the names of
unique studies, but only `count` will tell you how many records are in
each study. `distinct()` will only give you the study names.

``` r
data %>%
  count(studyName)
```

    # A tibble: 3 × 2
      studyName     n
      <chr>     <int>
    1 PAL0708     110
    2 PAL0809     114
    3 PAL0910     120

A more verbose way to solve this would be with `group_by()` and
`summarize()`:

``` r
data %>%
  group_by(studyName) %>%
  summarize(penguin_ct = n()) %>%
  ungroup()
```

    # A tibble: 3 × 2
      studyName penguin_ct
      <chr>          <int>
    1 PAL0708          110
    2 PAL0809          114
    3 PAL0910          120

### 2. Which penguin (use `Individual ID`) weighs the least (`Body Mass (g)`) in each study?

Here can use a combination of `group_by()`, `arrange()` and `slice()`.

``` r
data %>%
  group_by(studyName) %>%
  arrange(`Body Mass (g)`) %>%
  slice(1) %>%
  ungroup() %>%
  select(studyName, `Individual ID`, `Body Mass (g)`)
```

    # A tibble: 3 × 3
      studyName `Individual ID` `Body Mass (g)`
      <chr>     <chr>                     <dbl>
    1 PAL0708   N85A1                      2900
    2 PAL0809   N72A1                      2700
    3 PAL0910   N63A1                      2900

### 3. What are the average and median flipper lengths of the all penguins in each study?

Like the previous question, you need to use `group_by()` but here you
also should use the `summarize()` function.

``` r
data %>%
  filter(!is.na(`Flipper Length (mm)`)) %>%
  group_by(studyName) %>%
  summarize(penguin_ct = n(),
            mean_flipper = mean(`Flipper Length (mm)`),
            median_flipper = median(`Flipper Length (mm)`)) %>%
  ungroup()
```

    # A tibble: 3 × 4
      studyName penguin_ct mean_flipper median_flipper
      <chr>          <int>        <dbl>          <dbl>
    1 PAL0708          109         197.            195
    2 PAL0809          114         203.            200
    3 PAL0910          119         203.            199

### 4. Create a table where within each species, penguins are numbered from largest Culmen Length to smallest.

If you use the `row_number()` function within a `mutate()` step, it will
number records. Make sure you’ve sorted your data with `arrange()` so
that your numbers are assigned as expected.

``` r
data %>%
  group_by(Species) %>%
  arrange(desc(`Culmen Length (mm)`)) %>%
  mutate(record_num = row_number()) %>%
  ungroup() %>%
  select(Species, `Culmen Length (mm)`, record_num) %>%
  arrange(record_num, Species)
```

    # A tibble: 344 × 3
       Species                                   `Culmen Length (mm)` record_num
       <chr>                                                    <dbl>      <int>
     1 Adelie Penguin (Pygoscelis adeliae)                       46            1
     2 Chinstrap penguin (Pygoscelis antarctica)                 58            1
     3 Gentoo penguin (Pygoscelis papua)                         59.6          1
     4 Adelie Penguin (Pygoscelis adeliae)                       45.8          2
     5 Chinstrap penguin (Pygoscelis antarctica)                 55.8          2
     6 Gentoo penguin (Pygoscelis papua)                         55.9          2
     7 Adelie Penguin (Pygoscelis adeliae)                       45.6          3
     8 Chinstrap penguin (Pygoscelis antarctica)                 54.2          3
     9 Gentoo penguin (Pygoscelis papua)                         55.1          3
    10 Adelie Penguin (Pygoscelis adeliae)                       44.1          4
    # ℹ 334 more rows

### Bonus 1: Which island had the most penguins and which has the earliest egg?

`n()` and `min()` within a summarize function will give you the number
per group and the minimum of a given value respectively.

``` r
data %>%
  group_by(Island) %>%
  summarize(penguin_ct = n(),
            earliest_egg = min(`Date Egg`, na.rm = T)) %>%
  ungroup()
```

    # A tibble: 3 × 3
      Island    penguin_ct earliest_egg
      <chr>          <int> <date>      
    1 Biscoe           168 2007-11-10  
    2 Dream            124 2007-11-09  
    3 Torgersen         52 2007-11-09  

### Bonus 2: Create a table that shows the breakdown by sex (count and percent) by island.

You don’t need to format the `percent` variable, but you can using the
`percent()` function from the [`scales`](https://scales.r-lib.org/)
package.

``` r
data %>%
  count(Island, Sex) %>%
  group_by(Island) %>%
  mutate(total = sum(n),
         pct = scales::percent(n/total, accuracy = 0.1))
```

    # A tibble: 9 × 5
    # Groups:   Island [3]
      Island    Sex        n total pct  
      <chr>     <chr>  <int> <int> <chr>
    1 Biscoe    FEMALE    80   168 47.6%
    2 Biscoe    MALE      83   168 49.4%
    3 Biscoe    <NA>       5   168 3.0% 
    4 Dream     FEMALE    61   124 49.2%
    5 Dream     MALE      62   124 50.0%
    6 Dream     <NA>       1   124 0.8% 
    7 Torgersen FEMALE    24    52 46.2%
    8 Torgersen MALE      23    52 44.2%
    9 Torgersen <NA>       5    52 9.6% 
