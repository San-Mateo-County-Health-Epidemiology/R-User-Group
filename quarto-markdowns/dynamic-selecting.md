# Dynamically selecting variables

2023-03-23

## Overview

Sometimes you want to keep specific variables but you don’t want to have
to type out each variable name. Other times, you’re working with a data
set that might change and you don’t want to refer to variables by name.

`dplyr`’s `select()` function has some helper functions that will allow
you to select the variables you want in a flexible and concise way!

These examples will use the
[palmerpenguins](https://allisonhorst.github.io/palmerpenguins/) data
set.

``` r
library(tidyverse)
library(palmerpenguins) # this loads the penguins data set 

# look at the data
str(penguins)
```

    tibble [344 × 8] (S3: tbl_df/tbl/data.frame)
     $ species          : Factor w/ 3 levels "Adelie","Chinstrap",..: 1 1 1 1 1 1 1 1 1 1 ...
     $ island           : Factor w/ 3 levels "Biscoe","Dream",..: 3 3 3 3 3 3 3 3 3 3 ...
     $ bill_length_mm   : num [1:344] 39.1 39.5 40.3 NA 36.7 39.3 38.9 39.2 34.1 42 ...
     $ bill_depth_mm    : num [1:344] 18.7 17.4 18 NA 19.3 20.6 17.8 19.6 18.1 20.2 ...
     $ flipper_length_mm: int [1:344] 181 186 195 NA 193 190 181 195 193 190 ...
     $ body_mass_g      : int [1:344] 3750 3800 3250 NA 3450 3650 3625 4675 3475 4250 ...
     $ sex              : Factor w/ 2 levels "female","male": 2 1 1 NA 1 2 1 2 NA NA ...
     $ year             : int [1:344] 2007 2007 2007 2007 2007 2007 2007 2007 2007 2007 ...

## Basic use of the `select()` function

We typically use `select()` to pull variables out of a data set by name.

``` r
penguins %>%
  select(species, island, body_mass_g) %>%
  head(5)
```

    # A tibble: 5 × 3
      species island    body_mass_g
      <fct>   <fct>           <int>
    1 Adelie  Torgersen        3750
    2 Adelie  Torgersen        3800
    3 Adelie  Torgersen        3250
    4 Adelie  Torgersen          NA
    5 Adelie  Torgersen        3450

This works, but can get onerous when you’re selecting a lot of variables
and can also cause issues if you’re trying to automate data processing
and there’s a risk the variable names might change.

Luckily, `dplyr`’s `select()` function offers some helper functions to
make your life easier!

## `dplyr` helper functions

### `all_of()`

If there is a minimum set of variables you want to select, you can wrap
the list in `all_of()`. This is also the default behavior of `select()`.
Every variable listed in `select()` must exist in the data set when
you’re using `all_of()`.

``` r
vars <- c("species", "island", "year")

penguins %>%
  select(all_of(vars)) %>%
  head(5)
```

    # A tibble: 5 × 3
      species island     year
      <fct>   <fct>     <int>
    1 Adelie  Torgersen  2007
    2 Adelie  Torgersen  2007
    3 Adelie  Torgersen  2007
    4 Adelie  Torgersen  2007
    5 Adelie  Torgersen  2007

### `any_of()`

`any_of()` is really handy if your data set might change and you just
want to pull any variables that are available in the data set. If you
list a variable that isn’t in the data set, you won’t get an error.

``` r
vars <- c("age", "sex", "year")

penguins %>%
  select(any_of(vars)) %>%
  head(5)
```

    # A tibble: 5 × 2
      sex     year
      <fct>  <int>
    1 male    2007
    2 female  2007
    3 female  2007
    4 <NA>    2007
    5 female  2007

### `matches()`

`matches()` lets you select variables using regular expressions. This is
great if you are looking for variables with a known pattern and don’t
want to manually list them all out.

``` r
penguins %>%
  select(matches("bill|_mm$")) %>%
  head(5)
```

    # A tibble: 5 × 3
      bill_length_mm bill_depth_mm flipper_length_mm
               <dbl>         <dbl>             <int>
    1           39.1          18.7               181
    2           39.5          17.4               186
    3           40.3          18                 195
    4           NA            NA                  NA
    5           36.7          19.3               193

### `everything()`

Lets say you want to keep all the variables in your data set, but you
want to reorder them. You want the `year` variable to go first, followed
by `sex` and then everything else should go to the right of that.
Instead of manually typing out each variable name, you can use
`everything()`:

``` r
penguins %>%
  select(year, sex, everything()) %>%
  head(5)
```

    # A tibble: 5 × 8
       year sex    species island    bill_length_mm bill_depth_mm flipper_length_mm
      <int> <fct>  <fct>   <fct>              <dbl>         <dbl>             <int>
    1  2007 male   Adelie  Torgersen           39.1          18.7               181
    2  2007 female Adelie  Torgersen           39.5          17.4               186
    3  2007 female Adelie  Torgersen           40.3          18                 195
    4  2007 <NA>   Adelie  Torgersen           NA            NA                  NA
    5  2007 female Adelie  Torgersen           36.7          19.3               193
    # ℹ 1 more variable: body_mass_g <int>

### `last_col()`

You can also move variables around by position, but be careful with
this. If variables are added to or removed from your dataset, then you
might end up moving unexpected variables.

If you want to move a column in a specific position, you can use the
`last_col()` helper. If you don’t pass any arguements to the
`last_col()` function, it will move the last column:

``` r
penguins %>%
  select(species, last_col(), everything()) %>%
  head(5)
```

    # A tibble: 5 × 8
      species  year island    bill_length_mm bill_depth_mm flipper_length_mm
      <fct>   <int> <fct>              <dbl>         <dbl>             <int>
    1 Adelie   2007 Torgersen           39.1          18.7               181
    2 Adelie   2007 Torgersen           39.5          17.4               186
    3 Adelie   2007 Torgersen           40.3          18                 195
    4 Adelie   2007 Torgersen           NA            NA                  NA
    5 Adelie   2007 Torgersen           36.7          19.3               193
    # ℹ 2 more variables: body_mass_g <int>, sex <fct>

If you want to move a different variable you pass the position of that
variable relative to the last column into the `last_col()` function.
This is how you’d move the second to last column:

``` r
penguins %>%
  select(species, last_col(1L), everything()) %>%
  head(5)
```

    # A tibble: 5 × 8
      species sex    island    bill_length_mm bill_depth_mm flipper_length_mm
      <fct>   <fct>  <fct>              <dbl>         <dbl>             <int>
    1 Adelie  male   Torgersen           39.1          18.7               181
    2 Adelie  female Torgersen           39.5          17.4               186
    3 Adelie  female Torgersen           40.3          18                 195
    4 Adelie  <NA>   Torgersen           NA            NA                  NA
    5 Adelie  female Torgersen           36.7          19.3               193
    # ℹ 2 more variables: body_mass_g <int>, year <int>

### (non-dplyr) indexing

You can also move things around using the column number:

``` r
penguins %>%
  select(3:ncol(.), 1:2) %>%
  head(5)
```

    # A tibble: 5 × 8
      bill_length_mm bill_depth_mm flipper_length_mm body_mass_g sex    year species
               <dbl>         <dbl>             <int>       <int> <fct> <int> <fct>  
    1           39.1          18.7               181        3750 male   2007 Adelie 
    2           39.5          17.4               186        3800 fema…  2007 Adelie 
    3           40.3          18                 195        3250 fema…  2007 Adelie 
    4           NA            NA                  NA          NA <NA>   2007 Adelie 
    5           36.7          19.3               193        3450 fema…  2007 Adelie 
    # ℹ 1 more variable: island <fct>

### `where()`

Instead of selecting by position, you can select by data type with the
`where()` function. This is great if you want to perform an operation on
all numeric values, change the case of all character values or pull out
all date variables to a separate table.

``` r
penguins %>%
  select(where(is.integer)) %>%
  head(5)
```

    # A tibble: 5 × 3
      flipper_length_mm body_mass_g  year
                  <int>       <int> <int>
    1               181        3750  2007
    2               186        3800  2007
    3               195        3250  2007
    4                NA          NA  2007
    5               193        3450  2007

``` r
penguins %>%
  select(where(is.factor) | where(is.double)) %>%
  head(5)
```

    # A tibble: 5 × 5
      species island    sex    bill_length_mm bill_depth_mm
      <fct>   <fct>     <fct>           <dbl>         <dbl>
    1 Adelie  Torgersen male             39.1          18.7
    2 Adelie  Torgersen female           39.5          17.4
    3 Adelie  Torgersen female           40.3          18  
    4 Adelie  Torgersen <NA>             NA            NA  
    5 Adelie  Torgersen female           36.7          19.3

You can combine the `where()` functions with “regular” selection by
variable name, too.

``` r
penguins %>%
  select(year, where(is.factor)) %>%
  head(5)
```

    # A tibble: 5 × 4
       year species island    sex   
      <int> <fct>   <fct>     <fct> 
    1  2007 Adelie  Torgersen male  
    2  2007 Adelie  Torgersen female
    3  2007 Adelie  Torgersen female
    4  2007 Adelie  Torgersen <NA>  
    5  2007 Adelie  Torgersen female
