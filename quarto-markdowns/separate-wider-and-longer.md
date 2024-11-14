# `separate_wider` and `separate_longer` functions
Eamonn Hartmann, Hanley Kingston, Beth Jump
2024-10-17

## Overview

The `separate()` function from `tidyr` has been superceded by variations
of the `separate_wider()` and `separate_longer()` functions. According
to the help text, `separate()` won’t go away but it will only be updated
for critical bug fixes.

## Usage

We’ll walk through examples of how to use each function.

### `separate_wider_position()`

``` r
phone_data <- data.frame(
  name = c("bob", "Jo", "Josie"),
  phone = c(18034567819, 11231234596, 12345678901))

separate_wider_position(phone_data,
               cols = phone,
               widths = c("county" = 1, "areacode" = 3, "prefix" = 3, "num" = 4))
```

    # A tibble: 3 × 5
      name  county areacode prefix num  
      <chr> <chr>  <chr>    <chr>  <chr>
    1 bob   1      803      456    7819 
    2 Jo    1      123      123    4596 
    3 Josie 1      234      567    8901 

### `separate_wider_delim()`

This example feels really similar to how we typically use `separate()`.
`separate_wider_delim()` will separate a variable into the specified
columns based on a delimiter. In this example we’re splitting based on a
comma.

Note that unlike with `separate()` in `separate_wider_delim()` we use
the `too_few` argument (instead of the `fill` argument) to specify what
we want to do when there aren’t enough values in a variable.

``` r
vaccines <- data.frame(
  id = 1:10,
  vax_info = c("Moderna, Moderna, Moderna", 
               "Moderna, Moderna, Moderna", 
               "Moderna, Moderna, Pfizer, Pfizer, Pfizer Bivalent Booster", 
               "Pfizer, Pfizer, Pfizer", 
               "Pfizer, Pfizer, Pfizer, Pfizer, Pfizer Bivalent Booster", 
               "Moderna, Moderna, Pfizer, Pfizer Bivalent Booster, Pfizer BioNTech", 
               "Pfizer, Pfizer", 
               "J&J, Pfizer, Pfizer Bivalent Booster, Pfizer BioNTech", 
               "Pfizer, Pfizer, Pfizer, Pfizer Bivalent Booster", 
               "Moderna, Moderna, Pfizer, Pfizer, Pfizer Bivalent Booster, Pfizer Bivalent Booster")
)

vaccines %>% 
  separate_wider_delim(cols = vax_info, 
                       delim = ",", 
                       names = paste0("vax_", 1:6), 
                       too_few = "align_start")
```

    # A tibble: 10 × 7
          id vax_1   vax_2      vax_3                      vax_4         vax_5 vax_6
       <int> <chr>   <chr>      <chr>                      <chr>         <chr> <chr>
     1     1 Moderna " Moderna" " Moderna"                  <NA>          <NA>  <NA>
     2     2 Moderna " Moderna" " Moderna"                  <NA>          <NA>  <NA>
     3     3 Moderna " Moderna" " Pfizer"                  " Pfizer"     " Pf…  <NA>
     4     4 Pfizer  " Pfizer"  " Pfizer"                   <NA>          <NA>  <NA>
     5     5 Pfizer  " Pfizer"  " Pfizer"                  " Pfizer"     " Pf…  <NA>
     6     6 Moderna " Moderna" " Pfizer"                  " Pfizer Biv… " Pf…  <NA>
     7     7 Pfizer  " Pfizer"   <NA>                       <NA>          <NA>  <NA>
     8     8 J&J     " Pfizer"  " Pfizer Bivalent Booster" " Pfizer Bio…  <NA>  <NA>
     9     9 Pfizer  " Pfizer"  " Pfizer"                  " Pfizer Biv…  <NA>  <NA>
    10    10 Moderna " Moderna" " Pfizer"                  " Pfizer"     " Pf… " Pf…

### `separate_wider_regex()`

`separate_wider_regex()` allows you to split up a string based on string
patterns. It might be useful if you’re handling something with a defined
pattern, like emails, but probably won’t be the first `separate()`
function you reach for.

``` r
emails <- data.frame(
  id = 1:4,
  email = c("pumpkins@yahoo.com", "love4squash@gmail.com", "sp00kys3ason@hotmail.com", "black_cats@aol.com")
)

emails %>% 
  separate_wider_regex(cols = email, 
                       patterns = c(usename = "^[A-Za-z0-9_]*", 
                                    sep_1 = "\\@", 
                                    domain = "[A-Za-z]*", 
                                    sep_2 = "\\.", 
                                    type = "[A-Za-z]*$"), 
                       too_few = "align_start")
```

    # A tibble: 4 × 6
         id usename      sep_1 domain  sep_2 type 
      <int> <chr>        <chr> <chr>   <chr> <chr>
    1     1 pumpkins     @     yahoo   .     com  
    2     2 love4squash  @     gmail   .     com  
    3     3 sp00kys3ason @     hotmail .     com  
    4     4 black_cats   @     aol     .     com  

Another example of `separate_wider_regex()`…

``` r
phone_data <- data.frame(
  name = c("bob", "Jo", "Josie"),
  phone = c("+1 (803) 456-7819", "+1 (123) 123-4596", "+1 (234) 567-8901"))

separate_wider_regex(phone_data,
                     cols = phone,
                     #The full pattern must be represented in the regex but only named components become columns
                     patterns = c("\\+", "country" = "[0-9]", 
                                  " \\(", "areacode" = "[0-9]{3}", "\\)",
                                  " ", "prefix" = "[0-9]{3}",
                                  "-", "num" = "[0-9]{4}"), 
                     too_few = "align_start")
```

    # A tibble: 3 × 5
      name  country areacode prefix num  
      <chr> <chr>   <chr>    <chr>  <chr>
    1 bob   1       803      456    7819 
    2 Jo    1       123      123    4596 
    3 Josie 1       234      567    8901 

### `separate_longer_delim()`

`separate_longer_delim()` allows you to split up a string based on a
common delimiter. This can be useful when sorting through several
defined strings such as diagnosis codes. This example reproduces the
output for discharge diagnosis codes in ESSENCE and displays how to sort
through multiple diagnosis codes.

``` r
data <- data.frame(
  id = c(1:5),
  discharge_diagnosis = c(";F15;R46;I10;", ";F16;E11;M54;", ";T42;G47;", ";T43;J45;", ";F17;R41;"))

separate_icd_codes <- data %>%  
  group_by(id) %>%
  separate_longer_delim(discharge_diagnosis, delim = ";") %>%
  filter(discharge_diagnosis != "")
```

### `separate_longer_position()`

This version of `separate_longer()` is probably useful in a very
specific situation, but I can’t think of a time when I would use it. It
will split a variable into strings of a given length specified by the
`width =` argument.

Here’s an example anyway. If you think of something better, please let
us know!

``` r
birth_dates <- data.frame(
  id = 1:4,
  dob = c("20011220", "19911031", "20120415", "19870202")
)

birth_dates %>% 
  separate_longer_position(cols = dob, 
                           width = 4, 
                           keep_empty = TRUE)
```

      id  dob
    1  1 2001
    2  1 1220
    3  2 1991
    4  2 1031
    5  3 2012
    6  3 0415
    7  4 1987
    8  4 0202
