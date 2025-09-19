# Dataset summary tables using the Table One package
Julie Bartels
2025-09-18

The **tableone** package in R can be used to make a summary table to
describe your dataset. In epidemiology, this is commonly referred to as
“Table 1”, because it is usually the first table in a journal article
describing the population under study. A bit more about Table 1 here:
https://pubmed.ncbi.nlm.nih.gov/31229583/.

You could calculate these summary statistics manually (or use the
summary function), but this package quickly does these calculations and
formats them nicely into a table.

### Load libraries

``` r
library(dplyr)
library(tidyverse)
library(smcepi) #devtools::install_github("San-Mateo-County-Health-Epidemiology/smcepi")
library(tableone)
library(flextable)
```

### Load data

``` r
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

There are 8 variables in the palmer penguins dataset. - Factor
(categorical) variables: species, island, and sex. - Continuous
variables: bill length, bill depth, flipper length, and body mass We
will treat year as a factor variable here. Some variables have missing
(NA) values.

## Creating Table 1

### Format data

**Tableone** requires us to input a vector of variable names in our
dataframe, and to separately specify a vector of factor variables,
because these are treated differently in the table (counts/proportions
are calculated instead of mean/SD for factors).

``` r
vars <- c("species", "island", "bill_length_mm", "bill_depth_mm", "flipper_length_mm",
          "body_mass_g", "sex", "year")
factor_vars <- c("species", "island", "sex", "year")
```

### Table 1

Within the function to create the table, we need to specify the
variables, factor variables, and dataset to be used.

``` r
CreateTableOne(
  vars = vars,
  factorVars = factor_vars,
  data = data, 
  includeNA = FALSE # Change to TRUE to include missing (NA) as a regular factor level for factor variables
  )
```

                                   
                                    Overall         
      n                                 344         
      species (%)                                   
         Adelie                         152 (44.2)  
         Chinstrap                       68 (19.8)  
         Gentoo                         124 (36.0)  
      island (%)                                    
         Biscoe                         168 (48.8)  
         Dream                          124 (36.0)  
         Torgersen                       52 (15.1)  
      bill_length_mm (mean (SD))      43.92 (5.46)  
      bill_depth_mm (mean (SD))       17.15 (1.97)  
      flipper_length_mm (mean (SD))  200.92 (14.06) 
      body_mass_g (mean (SD))       4201.75 (801.95)
      sex = male (%)                    168 (50.5)  
      year (%)                                      
         2007                           110 (32.0)  
         2008                           114 (33.1)  
         2009                           120 (34.9)  

In the table, factor variables have a count and proportion of subjects
with each characteristic, and continuous variables have the mean and
standard deviation.

### Table 1 with stratification

That was a very simple table - now we will stratify by the “exposure”
variable, which in our case is defined as islands within the
Archipelago.

To do so, we need to redefine variables and factor variables, excluding
“island” from those lists.

``` r
# Re-define vars and factor_vars vectors WITHOUT stratifying variable "island"
vars <- c("species", "bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g", "sex", "year")
factor_vars <- c("species", "sex", "year")
```

Now, when we run our **CreateTableOne()** function, we define the strata
as “island”. Note here that we have a few other items defined:

- **test = FALSE.** If this were set to true, statistical groupwise
  comparisons would be run to compare the groups in the stratified
  variable, with p-values added to the table. More about this is
  available in the function notes.
  - There is a lot of discussion about whether p-values or statistical
    tests should be included in Table 1:
    https://epitodate.com/the-balance-test-fallacy-why-you-shouldnt-put-p-values-in-table-1/.
- **addOverall = TRUE.** We use this to add an overall column (not
  stratified) to the table.

``` r
table1 <- CreateTableOne(
  vars = vars,
  factorVars = factor_vars,
  strata = "island", 
  data = data, 
  test = FALSE, # Change to TRUE to get chi.sq and ANOVA results
  addOverall = TRUE)
```

Factor variables with two levels (e.g., sex), are shown in one row in
the table, for the count and proportion of penguins in each group that
are male. If you want to change this to see only the penguins that are
female, you can reset the order of the levels in the factor (the default
is alphabetical order).

``` r
data$sex <- factor(data$sex, levels = c("male", "female"))
```

If we want to see the count and proportion for both male and female
penguins, we can print the table and set **showAllLevels = TRUE**.

``` r
print(table1, showAllLevels = TRUE)
```

                                   Stratified by island
                                    level     Overall          Biscoe          
      n                                           344              168         
      species (%)                   Adelie        152 (44.2)        44 (26.2)  
                                    Chinstrap      68 (19.8)         0 ( 0.0)  
                                    Gentoo        124 (36.0)       124 (73.8)  
      bill_length_mm (mean (SD))                43.92 (5.46)     45.26 (4.77)  
      bill_depth_mm (mean (SD))                 17.15 (1.97)     15.87 (1.82)  
      flipper_length_mm (mean (SD))            200.92 (14.06)   209.71 (14.14) 
      body_mass_g (mean (SD))                 4201.75 (801.95) 4716.02 (782.86)
      sex (%)                       female        165 (49.5)        80 (49.1)  
                                    male          168 (50.5)        83 (50.9)  
      year (%)                      2007          110 (32.0)        44 (26.2)  
                                    2008          114 (33.1)        64 (38.1)  
                                    2009          120 (34.9)        60 (35.7)  
                                   Stratified by island
                                    Dream            Torgersen       
      n                                 124               52         
      species (%)                        56 (45.2)        52 (100.0) 
                                         68 (54.8)         0 (  0.0) 
                                          0 ( 0.0)         0 (  0.0) 
      bill_length_mm (mean (SD))      44.17 (5.95)     38.95 (3.03)  
      bill_depth_mm (mean (SD))       18.34 (1.13)     18.43 (1.34)  
      flipper_length_mm (mean (SD))  193.07 (7.51)    191.20 (6.23)  
      body_mass_g (mean (SD))       3712.90 (416.64) 3706.37 (445.11)
      sex (%)                            61 (49.6)        24 ( 51.1) 
                                         62 (50.4)        23 ( 48.9) 
      year (%)                           46 (37.1)        20 ( 38.5) 
                                         34 (27.4)        16 ( 30.8) 
                                         44 (35.5)        16 ( 30.8) 

## Export Table 1

### Save Table 1 as csv

You can save this table as a csv so that you can edit it and use the
calculations elsewhere.

``` r
table1_output <- print(table1, showAllLevels = TRUE, 
                      printToggle = FALSE, # This prevents the table from printing below
                      contDigits = 1, # Round to 1 decimal place for continuous variables
                      noSpaces = TRUE # Remove extra spaces from dataframe
)
write.csv(table1_output, file = "table1_output.csv")
```

### Formatting Table 1 output

You may also want to include this table as a formatted output in a
rendered Quarto markdown. We will clean up some of the formatting below.

``` r
# Clean table
table1_format <- as.data.frame(print(table1, 
                                     showAllLevels = TRUE, 
                                     printToggle = TRUE,
                                     contDigits = 1,
                                     noSpaces = TRUE
                                     )) %>%
  rename("Characteristic" = "level") %>%
  mutate(Category = rownames(.)) %>%
  select(c(Category, Characteristic, Overall, Biscoe, Dream, Torgersen))
# Remove rownames from the table
rownames(table1_format) <- NULL

table1_format <- table1_format %>%
  mutate(Category = c("N", "Species", "Species", "Species", 
                      "Measurements", "Measurements", "Measurements", "Measurements",
                      "Sex", "Sex",
                      "Year", "Year", "Year"),
         Characteristic = c("n", "Adelie", "Chinstrap", "Gentoo", 
                            "Bill Length, mm", "Bill Depth, mm", "Flipper Length, mm", "Body mass, g",
                            "Female", "Male",
                            "2007", "2008", "2009"))
```

### Export Table 1 as png

You can make a flextable, and then export the flextable as a png to add
to reports, send to collaborators, etc.

``` r
table1_format_flex <- as_grouped_data(table1_format, groups = "Category") %>%
  as_flextable(hide_grouplabel = TRUE) %>% # this hides "Category:" from each group label
  bold(bold = TRUE, part=c("header")) %>% # bold column headers
  align(i = ~ !is.na(Category), align = "left") %>% # align category group labels
  bold(i = ~ !is.na(Category)) %>% # bold group category labels
  add_header_row(., top = TRUE, 
                     values = c("", "Island"), 
                     colwidths = c(2, 3)) %>%
  align(align = "center", part = "header") %>% # align header
  autofit() # fit to screen

table1_format_flex
```

![](dataset_summary_tables_files/figure-commonmark/unnamed-chunk-11-1.png)

``` r
save_as_image(table1_format_flex, path = "table1.png")
```
