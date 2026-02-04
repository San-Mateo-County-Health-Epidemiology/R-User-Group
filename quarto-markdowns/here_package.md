# Use here package to call and save files
Julie Bartels
2026-02-04

## Overview

This tutorial explains how to use the *here* package to call, run, and
save files. This is useful because as long as you are within an R
project, you don’t need to use long file paths, which can be
inconvenient, provide information about how your files are stored, and
are not necessarily replicable across users.

## Here package

You will need to load the **here** package:

``` r
# install.packages('here')
library(here)
```

    here() starts at <working directory>/Julie/Cal-EIS/R projects/R-User-Group

When you run this, you see that the package tells you within which
directory (folder), you are operating. In our case, the last part of the
directory file path should read “/R-User-Group”.

### Using the here package to write/save/load dataframes

As long as the directory you want to save to is located within your
overall project directory (“/R-User-Group”), you can write your
dataframe using the **here** package.

The structure of the code is as follows.

- Within the *write_csv()* function, call *here()* within the **here**
  package. Note: I am using here::here, because there is another package
  with a *here()* function, so I want to ensure I am calling the
  *here()* within the **here** package.

- Starting with the directory below the main project folder, include the
  name of the directory in quotation marks, followed by a comma. For the
  following example file path
  (“/R-User-Group/data/raw/hospitalizations), you would write (”data”,
  “raw”, “hospitalizations”).

- Then once you have listed all the necessary folders, you include the
  name of the specific file (.csv, .xlsx, .RDS) within quotation marks.

For example, we will create a csv of the palmer penguins dataset and
save it to data (and then delete it).

### Side note: pacman package

This is a fun tip - when you need to load a bunch of packages, you can
use the **pacman** package. This is just a little bit of a cleaner look
to your code.

``` r
# Load pacman package
# install.packages('pacman')
library(pacman)

# Load packages to prepare the data and conduct analysis
# install.packages('palmerpenguins')
p_load(dplyr, tidyverse, palmerpenguins)
```

``` r
# Make dataframe of penguin data
penguin_data <- palmerpenguins::penguins

head(penguin_data)
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

``` r
# Save penguin dataframe to data folder in /R-User-Group
penguin_data %>%
  write_csv(here::here("data", "penguin_data.csv"))
```

If you check the data folder, it should be there - we can then use the
**here** package to load this csv, just for fun:

``` r
# Remove penguin_data from our global environment
rm(penguin_data)

# Load penguin_data from the data folder
penguin_data <- read_csv(here::here("data", "penguin_data.csv"))
```

Now we will remove the penguin dataframe from the folder, also using the
*here* package.

``` r
file.remove(here::here("data", "penguin_data.csv"))
```

Finally, we clean up the global environment - this is just good practice
to keep things tidy!

``` r
rm(penguin_data)
```
