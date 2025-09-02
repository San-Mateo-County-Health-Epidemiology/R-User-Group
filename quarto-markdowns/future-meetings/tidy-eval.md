# Tidy evaluation
Beth Jump
2025-09-04

## Background

For some background on tidy evaluation (a type of non-standard
evaluation) check out Jenny Bryant’s talk from 2019 and this overview of
[Programming with
`dplyr`](https://dplyr.tidyverse.org/articles/programming.html#introduction).
Essentially, tidy evaluation is what lets us reference variables without
reference to their data frame in `tidyverse` functions.

I’m not going to get into the technical details here - I’ll just go over
how it intersects with our work and how to deal with it.

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

`data` is an object in our environment that contains these data. We can
reference `data` without quotes because it’s an object.

The `species` column is a part of the `data` object but it does not
exist as its own object in our R environment. To reference the column,
we need to tell R how to find it. We can do this the base R way where we
explicilty reference the data:

``` r
data$species
```

      [1] Adelie    Adelie    Adelie    Adelie    Adelie    Adelie    Adelie   
      [8] Adelie    Adelie    Adelie    Adelie    Adelie    Adelie    Adelie   
     [15] Adelie    Adelie    Adelie    Adelie    Adelie    Adelie    Adelie   
     [22] Adelie    Adelie    Adelie    Adelie    Adelie    Adelie    Adelie   
     [29] Adelie    Adelie    Adelie    Adelie    Adelie    Adelie    Adelie   
     [36] Adelie    Adelie    Adelie    Adelie    Adelie    Adelie    Adelie   
     [43] Adelie    Adelie    Adelie    Adelie    Adelie    Adelie    Adelie   
     [50] Adelie    Adelie    Adelie    Adelie    Adelie    Adelie    Adelie   
     [57] Adelie    Adelie    Adelie    Adelie    Adelie    Adelie    Adelie   
     [64] Adelie    Adelie    Adelie    Adelie    Adelie    Adelie    Adelie   
     [71] Adelie    Adelie    Adelie    Adelie    Adelie    Adelie    Adelie   
     [78] Adelie    Adelie    Adelie    Adelie    Adelie    Adelie    Adelie   
     [85] Adelie    Adelie    Adelie    Adelie    Adelie    Adelie    Adelie   
     [92] Adelie    Adelie    Adelie    Adelie    Adelie    Adelie    Adelie   
     [99] Adelie    Adelie    Adelie    Adelie    Adelie    Adelie    Adelie   
    [106] Adelie    Adelie    Adelie    Adelie    Adelie    Adelie    Adelie   
    [113] Adelie    Adelie    Adelie    Adelie    Adelie    Adelie    Adelie   
    [120] Adelie    Adelie    Adelie    Adelie    Adelie    Adelie    Adelie   
    [127] Adelie    Adelie    Adelie    Adelie    Adelie    Adelie    Adelie   
    [134] Adelie    Adelie    Adelie    Adelie    Adelie    Adelie    Adelie   
    [141] Adelie    Adelie    Adelie    Adelie    Adelie    Adelie    Adelie   
    [148] Adelie    Adelie    Adelie    Adelie    Adelie    Gentoo    Gentoo   
    [155] Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo   
    [162] Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo   
    [169] Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo   
    [176] Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo   
    [183] Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo   
    [190] Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo   
    [197] Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo   
    [204] Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo   
    [211] Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo   
    [218] Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo   
    [225] Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo   
    [232] Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo   
    [239] Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo   
    [246] Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo   
    [253] Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo   
    [260] Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo   
    [267] Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo    Gentoo   
    [274] Gentoo    Gentoo    Gentoo    Chinstrap Chinstrap Chinstrap Chinstrap
    [281] Chinstrap Chinstrap Chinstrap Chinstrap Chinstrap Chinstrap Chinstrap
    [288] Chinstrap Chinstrap Chinstrap Chinstrap Chinstrap Chinstrap Chinstrap
    [295] Chinstrap Chinstrap Chinstrap Chinstrap Chinstrap Chinstrap Chinstrap
    [302] Chinstrap Chinstrap Chinstrap Chinstrap Chinstrap Chinstrap Chinstrap
    [309] Chinstrap Chinstrap Chinstrap Chinstrap Chinstrap Chinstrap Chinstrap
    [316] Chinstrap Chinstrap Chinstrap Chinstrap Chinstrap Chinstrap Chinstrap
    [323] Chinstrap Chinstrap Chinstrap Chinstrap Chinstrap Chinstrap Chinstrap
    [330] Chinstrap Chinstrap Chinstrap Chinstrap Chinstrap Chinstrap Chinstrap
    [337] Chinstrap Chinstrap Chinstrap Chinstrap Chinstrap Chinstrap Chinstrap
    [344] Chinstrap
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
