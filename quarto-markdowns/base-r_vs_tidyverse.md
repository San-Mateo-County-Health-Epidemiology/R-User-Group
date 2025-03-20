# Base R vs tidyverse
Beth Jump
2025-03-17

# Overview

Here we’ll compare the two most common ways of coding in R: base R and
tidyverse. Note that data.table is another method, but it’s generally
only used in big data processing so we’re not going to focus on it here.
For more about data.table, see
[here](https://cran.r-project.org/web/packages/data.table/vignettes/datatable-intro.html).

Base R involves coding with only the functions that are native to R
while tidyverse is a set of packages that need to be installed and don’t
come with the “base” installation of R. If you already use and like
tidyverse, there is no reason to switch to base R! It’s just good to
know the basics of base R in case you need to use it. You might
need/want to use base R when:

- you’re developing a package. It’s easier to use base R that to include
  other packages as dependencies
- statistical things are often written in base R because they rely
  heavily on vectors
- if you’re running R code somewhere you don’t have a lot of control
  over which packages are installed

# Basic differences

Base R tends to be faster and better for manipulating vectors whereas
tidyverse has clearer syntax, is better for data manipulation and makes
prettier plots.

We’ll compare base R and tidyverse for:

- data set manipulation
- string manipulation

Then we’ll talk about things that are the same and focus on the `apply`
functions from base R.

## Base R

- The structure of R objects is really important in base R.
  - A list has one dimension and you fetch items from a list with the
    index ie `list[2]`.  
  - A data frame has two dimensions and you fetch data from a data frame
    list this: `data[rows, columns]`  
- All variables must be referenced in relation to the data frame in
  which they belong. You use a `$` to fetch a variable from a data
  frame. Ex: `data$variable`.
- There is no “chaining” of functions like there is in tidyverse.

## tidyverse

- All chains or functions start with a data frame and then R assumes
  that all variables referenced exist in the original data frame.
- Because tidyverse was developed cohesively, the syntax for functions
  is generally consistent across all tidyverse functions (except the `+`
  with ggplot). This is unlike base R (think about the functions for
  manipulating files, ie `dir.create()` to make a directory. and
  `unlink()` to delete a directory.)
- A quick work about tidyverse syntax. All tidyverse functions have the
  data frame as the first argument. This can be specified one of two
  equivalent ways:
  - `data %>% select(col)`  
  - `select(data, col)`

In these examples we’ll use the
[`palmerpenguins`](https://allisonhorst.github.io/palmerpenguins/) data
set.

``` r
library(tidyverse)
library(palmerpenguins)

data <- palmerpenguins::penguins
```

# Data set manipulation

## Looking at a data set

### Base R

``` r
str(data)
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

### tidyverse

``` r
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

## Selecting columns

### Base R

``` r
# by position
data[, 1:2]
```

    # A tibble: 344 × 2
       species island   
       <fct>   <fct>    
     1 Adelie  Torgersen
     2 Adelie  Torgersen
     3 Adelie  Torgersen
     4 Adelie  Torgersen
     5 Adelie  Torgersen
     6 Adelie  Torgersen
     7 Adelie  Torgersen
     8 Adelie  Torgersen
     9 Adelie  Torgersen
    10 Adelie  Torgersen
    # ℹ 334 more rows

``` r
# by name (note the variable names are in quotes)
data[, c("species", "island", "sex")]
```

    # A tibble: 344 × 3
       species island    sex   
       <fct>   <fct>     <fct> 
     1 Adelie  Torgersen male  
     2 Adelie  Torgersen female
     3 Adelie  Torgersen female
     4 Adelie  Torgersen <NA>  
     5 Adelie  Torgersen female
     6 Adelie  Torgersen male  
     7 Adelie  Torgersen female
     8 Adelie  Torgersen male  
     9 Adelie  Torgersen <NA>  
    10 Adelie  Torgersen <NA>  
    # ℹ 334 more rows

### tidyverse

``` r
# by position 
data %>%
  select(1:2)
```

    # A tibble: 344 × 2
       species island   
       <fct>   <fct>    
     1 Adelie  Torgersen
     2 Adelie  Torgersen
     3 Adelie  Torgersen
     4 Adelie  Torgersen
     5 Adelie  Torgersen
     6 Adelie  Torgersen
     7 Adelie  Torgersen
     8 Adelie  Torgersen
     9 Adelie  Torgersen
    10 Adelie  Torgersen
    # ℹ 334 more rows

``` r
# by name
data %>%
  select(species, island, sex)
```

    # A tibble: 344 × 3
       species island    sex   
       <fct>   <fct>     <fct> 
     1 Adelie  Torgersen male  
     2 Adelie  Torgersen female
     3 Adelie  Torgersen female
     4 Adelie  Torgersen <NA>  
     5 Adelie  Torgersen female
     6 Adelie  Torgersen male  
     7 Adelie  Torgersen female
     8 Adelie  Torgersen male  
     9 Adelie  Torgersen <NA>  
    10 Adelie  Torgersen <NA>  
    # ℹ 334 more rows

## Selecting rows

### Base R

``` r
data[1:10,]
```

    # A tibble: 10 × 8
       species island    bill_length_mm bill_depth_mm flipper_length_mm body_mass_g
       <fct>   <fct>              <dbl>         <dbl>             <int>       <int>
     1 Adelie  Torgersen           39.1          18.7               181        3750
     2 Adelie  Torgersen           39.5          17.4               186        3800
     3 Adelie  Torgersen           40.3          18                 195        3250
     4 Adelie  Torgersen           NA            NA                  NA          NA
     5 Adelie  Torgersen           36.7          19.3               193        3450
     6 Adelie  Torgersen           39.3          20.6               190        3650
     7 Adelie  Torgersen           38.9          17.8               181        3625
     8 Adelie  Torgersen           39.2          19.6               195        4675
     9 Adelie  Torgersen           34.1          18.1               193        3475
    10 Adelie  Torgersen           42            20.2               190        4250
    # ℹ 2 more variables: sex <fct>, year <int>

### tidyverse

``` r
data %>%
  slice(1:10)
```

    # A tibble: 10 × 8
       species island    bill_length_mm bill_depth_mm flipper_length_mm body_mass_g
       <fct>   <fct>              <dbl>         <dbl>             <int>       <int>
     1 Adelie  Torgersen           39.1          18.7               181        3750
     2 Adelie  Torgersen           39.5          17.4               186        3800
     3 Adelie  Torgersen           40.3          18                 195        3250
     4 Adelie  Torgersen           NA            NA                  NA          NA
     5 Adelie  Torgersen           36.7          19.3               193        3450
     6 Adelie  Torgersen           39.3          20.6               190        3650
     7 Adelie  Torgersen           38.9          17.8               181        3625
     8 Adelie  Torgersen           39.2          19.6               195        4675
     9 Adelie  Torgersen           34.1          18.1               193        3475
    10 Adelie  Torgersen           42            20.2               190        4250
    # ℹ 2 more variables: sex <fct>, year <int>

## Filtering data

### Base R

``` r
# note that filters go in the "rows" position because you're filtering based on row values. 
data[data$sex == "male" & !is.na(data$sex),]
```

    # A tibble: 168 × 8
       species island    bill_length_mm bill_depth_mm flipper_length_mm body_mass_g
       <fct>   <fct>              <dbl>         <dbl>             <int>       <int>
     1 Adelie  Torgersen           39.1          18.7               181        3750
     2 Adelie  Torgersen           39.3          20.6               190        3650
     3 Adelie  Torgersen           39.2          19.6               195        4675
     4 Adelie  Torgersen           38.6          21.2               191        3800
     5 Adelie  Torgersen           34.6          21.1               198        4400
     6 Adelie  Torgersen           42.5          20.7               197        4500
     7 Adelie  Torgersen           46            21.5               194        4200
     8 Adelie  Biscoe              37.7          18.7               180        3600
     9 Adelie  Biscoe              38.2          18.1               185        3950
    10 Adelie  Biscoe              38.8          17.2               180        3800
    # ℹ 158 more rows
    # ℹ 2 more variables: sex <fct>, year <int>

### tidyverse

``` r
data %>%
  filter(sex == "male" & !is.na(sex))
```

    # A tibble: 168 × 8
       species island    bill_length_mm bill_depth_mm flipper_length_mm body_mass_g
       <fct>   <fct>              <dbl>         <dbl>             <int>       <int>
     1 Adelie  Torgersen           39.1          18.7               181        3750
     2 Adelie  Torgersen           39.3          20.6               190        3650
     3 Adelie  Torgersen           39.2          19.6               195        4675
     4 Adelie  Torgersen           38.6          21.2               191        3800
     5 Adelie  Torgersen           34.6          21.1               198        4400
     6 Adelie  Torgersen           42.5          20.7               197        4500
     7 Adelie  Torgersen           46            21.5               194        4200
     8 Adelie  Biscoe              37.7          18.7               180        3600
     9 Adelie  Biscoe              38.2          18.1               185        3950
    10 Adelie  Biscoe              38.8          17.2               180        3800
    # ℹ 158 more rows
    # ℹ 2 more variables: sex <fct>, year <int>

## Making new variables

### Base R

``` r
data$sex_new <- ifelse(is.na(data$sex),
                       "unknown",
                       as.character(data$sex))
unique(data$sex_new)
```

    [1] "male"    "female"  "unknown"

### tidyverse

``` r
data %>%
  mutate(sex_new = case_when(is.na(sex) ~ "unknown",
                             TRUE ~ as.character(sex))) %>%
  distinct(sex_new)
```

    # A tibble: 3 × 1
      sex_new
      <chr>  
    1 male   
    2 female 
    3 unknown

## summarize

### Base R

``` r
# with the summary function 
summary(data$species)
```

       Adelie Chinstrap    Gentoo 
          152        68       124 

``` r
summary(data$bill_length_mm)
```

       Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
      32.10   39.23   44.45   43.92   48.50   59.60       2 

``` r
# if you need a specific measure
mean(data$flipper_length_mm, na.rm = T)
```

    [1] 200.9152

### tidyverse

``` r
# here you can really only use summarize which is more typing than base R
data %>% 
  summarize(mean_bill = mean(bill_length_mm, na.rm = T),
            mean_flip = mean(flipper_length_mm, na.rm = T))
```

    # A tibble: 1 × 2
      mean_bill mean_flip
          <dbl>     <dbl>
    1      43.9      201.

## Plotting

### Base R

``` r
plot(x = data$bill_length_mm,
     y = data$flipper_length_mm,
     type = "p")
```

![](base-r_vs_tidyverse_files/figure-commonmark/unnamed-chunk-14-1.png)

### tidyverse

``` r
ggplot(data) +
  geom_point(aes(x = bill_length_mm,
                 y = flipper_length_mm))
```

![](base-r_vs_tidyverse_files/figure-commonmark/unnamed-chunk-15-1.png)

# String manipulation

Basically, if you’re using base R you want to use the `gsub` functions
and if you’re using tidyverse you want `stringr`. Both can use regular
expressions and get you where you want to go!

# Things that are the same

Some things in base R have no equivalent in tidyverse because they don’t
need to. Think of:

- loops
- if and where statements
- ???

# A note about `apply`

Some of the most common functions you’ll see from base R are the `apply`
functions. Here is a [good
overview](https://www.r-bloggers.com/2022/03/complete-tutorial-on-using-apply-functions-in-r/)
on the apply functions in case you want to use them one day!
