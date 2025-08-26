# strings and regular expressions
Beth Jump
2022-08-11

## Overview

If you’re working with string variables, I recommend leaning heavily on
the `stringr` package and using regular expressions. The [`stringr`
cheat sheet](https://rstudio.github.io/cheatsheets/strings.pdf), is a
great overview of the package and also has some regular expression
shortcuts.

Regular expressions are a method for identifying patterns in strings.
We’ll review some below and you can also practice regular expressions
with this [tutorial](https://regexone.com/).

`separate()` and `unite()` from the `tidyr` package are also helpful for
splitting or combining string variables in data sets.

When dealing with string variables, I recommend testing out the
functions on a list or variable before you try using it within a mutate
step. It’s easier to play and test things out on a couple of variables
instead of a giant vector that is part of a large data set.

## String manipulation

We’ll use these data to run through some string cleaning tasks below.

``` r
library(tidyverse)

data <- data.frame(
  phones = c("650-555-9023", "(415)123-6789", "6509984567", "(650)4456374"),
  emails = c("hogwarts14@yahoo.com", "hpotter@hogwarts.edu", "wildraccoon101@gmail.com", "rweasley@hogwarts.edu")
)
data
```

             phones                   emails
    1  650-555-9023     hogwarts14@yahoo.com
    2 (415)123-6789     hpotter@hogwarts.edu
    3    6509984567 wildraccoon101@gmail.com
    4  (650)4456374    rweasley@hogwarts.edu

#### 1. Format the phone numbers so that they all follow the same pattern.

``` r
data1 <- data %>%
  mutate(phones = str_replace_all(phones, "\\-|\\(|\\)", ""))
data1
```

          phones                   emails
    1 6505559023     hogwarts14@yahoo.com
    2 4151236789     hpotter@hogwarts.edu
    3 6509984567 wildraccoon101@gmail.com
    4 6504456374    rweasley@hogwarts.edu

#### 2. Copy the phone area code into a new variable called `area_code`.

``` r
data2 <- data1 %>%
  mutate(area_code = str_sub(phones, 1, 3))
data2
```

          phones                   emails area_code
    1 6505559023     hogwarts14@yahoo.com       650
    2 4151236789     hpotter@hogwarts.edu       415
    3 6509984567 wildraccoon101@gmail.com       650
    4 6504456374    rweasley@hogwarts.edu       650

#### 3. Create a new variable called `hogwarts_student` and flag the `hogwarts.edu` emails.

``` r
data3 <- data2 %>%
  mutate(hogwarts_student = case_when(str_detect(emails, "hogwarts.edu$") ~ 1, 
                                      TRUE ~ 0))
data3
```

          phones                   emails area_code hogwarts_student
    1 6505559023     hogwarts14@yahoo.com       650                0
    2 4151236789     hpotter@hogwarts.edu       415                1
    3 6509984567 wildraccoon101@gmail.com       650                0
    4 6504456374    rweasley@hogwarts.edu       650                1

#### 4. Split the email into three variables, `user`, `domain` and `extension`.

``` r
data4 <- data3 %>%
  separate(emails, 
           c("user", "domain", "extension"),
           sep = "\\@|\\.")
data4
```

          phones           user   domain extension area_code hogwarts_student
    1 6505559023     hogwarts14    yahoo       com       650                0
    2 4151236789        hpotter hogwarts       edu       415                1
    3 6509984567 wildraccoon101    gmail       com       650                0
    4 6504456374       rweasley hogwarts       edu       650                1
