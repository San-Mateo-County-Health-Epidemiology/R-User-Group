# Tidy evaluation intro
Beth Jump
2025-09-04

## Background

For some background on tidy evaluation (a type of non-standard
evaluation) check out [Jenny Bryant’s talk from
2019](https://www.youtube.com/watch?v=2BXPLnLMTYo) and this overview of
[Programming with
`dplyr`](https://dplyr.tidyverse.org/articles/programming.html#introduction).
Essentially, tidy evaluation is what lets us reference variables as if
they were standalone objects in `tidyverse` functions.

I’m not going to get into the technical details here - I’ll just go over
how it intersects with our work and some methods for dealing with it.
This is a very high level overview but hopefully gives you enough
information to handle these situations and to dig deeper if you’re
interested.

Consider the `palmerpenguins::penguins` data set:

``` r
library(tidyverse)
data <- palmerpenguins::penguins
glimpse(data)
```

    Rows: 344
    Columns: 8
    $ species           <fct> Adelie, Adelie, Adelie, Adelie, Adelie, Adelie, Adel…
    $ island            <fct> Torgersen, Torgersen, Torgersen, Torgersen, Torgerse…
    $ bill_length_mm    <dbl> 39.1, 39.5, 40.3, NA, 36.7, 39.3, 38.9, 39.2, 34.1, …
    $ bill_depth_mm     <dbl> 18.7, 17.4, 18.0, NA, 19.3, 20.6, 17.8, 19.6, 18.1, …
    $ flipper_length_mm <int> 181, 186, 195, NA, 193, 190, 181, 195, 193, 190, 186…
    $ body_mass_g       <int> 3750, 3800, 3250, NA, 3450, 3650, 3625, 4675, 3475, …
    $ sex               <fct> male, female, female, NA, female, male, female, male…
    $ year              <int> 2007, 2007, 2007, 2007, 2007, 2007, 2007, 2007, 2007…

`data` is an object in our environment that contains this data set. We
can reference `data` without quotes because it’s an object.

The `species` column is a part of the `data` object but it does not
exist as its own object in our R environment. To reference the column,
we need to tell R how to find it. We can do this the base R way where we
explicitly reference the data:

``` r
head(data$species, 5)
```

    [1] Adelie Adelie Adelie Adelie Adelie
    Levels: Adelie Chinstrap Gentoo

Or we can use tidy evaluation with the `tidyverse` functions:

``` r
data %>%
  select(species)
```

    # A tibble: 344 × 1
       species
       <fct>  
     1 Adelie 
     2 Adelie 
     3 Adelie 
     4 Adelie 
     5 Adelie 
     6 Adelie 
     7 Adelie 
     8 Adelie 
     9 Adelie 
    10 Adelie 
    # ℹ 334 more rows

## In practice

Generally speaking, we don’t need to know *how* tidy evaluation works,
we just need to know that it works with `tidyverse` functions. The place
where it breaks down is when we want to write functions that use
`tidyverse` syntax and want to pass variables as arguments.

### Motivating example

Let’s say you want to write a function that lets a user easily generate
summary statistics for a given grouping variable. The tidyverse code
would look something like this:

``` r
data %>%
  group_by(species) %>%
  summarize(min = min(body_mass_g, na.rm = T),
            mean = mean(body_mass_g, na.rm = T),
            medin = median(body_mass_g, na.rm = T),
            max = max(body_mass_g, na.rm = T),
            .groups = "keep") %>%
  ungroup() 
```

    # A tibble: 3 × 5
      species     min  mean medin   max
      <fct>     <int> <dbl> <dbl> <int>
    1 Adelie     2850 3701.  3700  4775
    2 Chinstrap  2700 3733.  3700  4800
    3 Gentoo     3950 5076.  5000  6300

But if you want to write this as a function, you might be tempted to do
something like this, which will not work:

``` r
summarize_fun <- function(data, grouping_var) {
  
  data %>%
    group_by(grouping_var) %>%
    summarize(min = min(body_mass_g, na.rm = T),
              mean = mean(body_mass_g, na.rm = T),
              medin = median(body_mass_g, na.rm = T),
              max = max(body_mass_g, na.rm = T),
              .groups = "keep") %>%
    ungroup() 

}

summarize_fun(data, species)
```

This doesn’t work because you’re not accounting for tidy evaluation.
You’re referencing the `grouping_var` as if it were an object in your
environment when it’s not - it’s a subset of an object.

### Passing variables as arguments in a function

There are a couple of ways around this:

1.  Pass specific variables through the function
2.  Allow for the user to specify the variables with a `...`

### 1. Pass specific variables through the function

If you just wrap the `grouping_var` in the function with double curly
brackets, the function will work!

``` r
summarize_fun <- function(data, grouping_var) {
  
  data %>%
    group_by({{ grouping_var }}) %>%
    summarize(min = min(body_mass_g, na.rm = T),
              mean = mean(body_mass_g, na.rm = T),
              medin = median(body_mass_g, na.rm = T),
              max = max(body_mass_g, na.rm = T),
              .groups = "keep") %>%
    ungroup() 
}

summarize_fun(data, species)
```

    # A tibble: 3 × 5
      species     min  mean medin   max
      <fct>     <int> <dbl> <dbl> <int>
    1 Adelie     2850 3701.  3700  4775
    2 Chinstrap  2700 3733.  3700  4800
    3 Gentoo     3950 5076.  5000  6300

### 2. Allow for the user to specify the variables with a `...`

Instead of designating a specific argument for a variable, you can use a
`...` to pull a variable into your function and have it work with tidy
evaluation:

``` r
summarize_fun <- function(data, ...) {
  
  data %>%
    group_by(...) %>%
    summarize(min = min(body_mass_g, na.rm = T),
              mean = mean(body_mass_g, na.rm = T),
              medin = median(body_mass_g, na.rm = T),
              max = max(body_mass_g, na.rm = T),
              .groups = "keep") %>%
    ungroup() 
}

summarize_fun(data, species)
```

    # A tibble: 3 × 5
      species     min  mean medin   max
      <fct>     <int> <dbl> <dbl> <int>
    1 Adelie     2850 3701.  3700  4775
    2 Chinstrap  2700 3733.  3700  4800
    3 Gentoo     3950 5076.  5000  6300

A big upside of this is that your user can pass multiple variables to a
single argument, which is really helpful in a `group_by()` step:

``` r
summarize_fun(data, species, sex)
```

    # A tibble: 8 × 6
      species   sex      min  mean medin   max
      <fct>     <fct>  <int> <dbl> <dbl> <int>
    1 Adelie    female  2850 3369. 3400   3900
    2 Adelie    male    3325 4043. 4000   4775
    3 Adelie    <NA>    2975 3540  3475   4250
    4 Chinstrap female  2700 3527. 3550   4150
    5 Chinstrap male    3250 3939. 3950   4800
    6 Gentoo    female  3950 4680. 4700   5200
    7 Gentoo    male    4750 5485. 5500   6300
    8 Gentoo    <NA>    4100 4588. 4688.  4875

Though if you want your user to specify different variables for
different parts of your function, you might be better off with
specifically labelled arguments.
