# Dataset summary tables using the Table One package
Julie Bartels
2025-09-16

<script src="dataset_summary_tables_files/libs/kePrint-0.0.1/kePrint.js"></script>
<link href="dataset_summary_tables_files/libs/lightable-0.0.1/lightable.css" rel="stylesheet" />

The **tableone** package in R can be used to make a summary table to
describe your dataset. In epidemiology, this is commonly referred to as
“Table 1”, because it is usually the first table in a journal article
describing the population under study. A bit more about Table 1 here:
https://pubmed.ncbi.nlm.nih.gov/31229583/.

You could calculate these summary statistics manually (or use the
summary function), but this package quickly does these calculations and
formats them nicely into a table.

## Load libraries

``` r
library(dplyr)
library(tidyverse)
library(smcepi) #devtools::install_github("San-Mateo-County-Health-Epidemiology/smcepi")
library(tableone)
library(kableExtra)
```

## Load data

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

There are 8 variables in the palmer penguins dataset. Three of them
(species, island, and sex) are factors, meaning they have a certain
number of levels or potential categorical values. Four of them are
treated as continuous variables in the dataset (bill length, bill depth,
flipper length, and body mass), and then we have year, which we will
treat here as a factor variable with a distinct number of levels (or
years). Some variables have missing (NA) values.

## Format data to create Table 1

**Tableone** requires us to use a vector of variables, which is the
names of the variables in our dataframe. It also requires us to specify
a vector of factor variables, because these factor (or categorical)
variables are treated differently in the table (we calculate
counts/proportions instead of mean/SD).

``` r
vars <- c("species", "island", "bill_length_mm", "bill_depth_mm", "flipper_length_mm",
          "body_mass_g", "sex", "year")
factor_vars <- c("species", "island", "sex", "year")
```

## Create Table 1 output

Within the function to create the table, at minimum, we need to specify
the variables in our dataframe, the factor variables, and the dataset to
be used.

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

We see here that factor variables have a count and proportion of
subjects with each characteristic, and that for continuous variables, we
are given the mean and standard deviation.

## Create Table 1 output with stratification

That was a very simple table - now we will stratify the table by the
“exposure” variable, which in our case is defined as the specific island
within the Archipelago.

To do so, we need to redefine our variables and factor variables, but
exclude “island” from those lists.

``` r
# Re-define vars and factor_vars vectors WITHOUT stratifying variable "island"
vars <- c("species", "bill_length_mm", "bill_depth_mm", "flipper_length_mm",
          "body_mass_g", "sex", "year")
factor_vars <- c("species", "sex", "year")
```

Now, when we run our **CreateTableOne()** function, we define the strata
as “island”. Note here that we have a few other items defined:

- **test = FALSE.** If this were set to true, statistical groupwise
  comparisons would be run to compare the groups in the stratified
  variable, with p-values added to the table. More about this is
  available in the function notes (command: ?CreateTableOne()).
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

Above, we see that for factor variables with two levels (like sex), we
only see one row in the table, for the count and proportion of penguins
in each group that are male. If you want to change this to see only the
penguins that are female, you can reset the order of the levels in the
factor (the default is alphabetical).

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

## Formatting Table 1 output

You may also want to include this table as a formatted output in a
rendered Quarto document, in which case you first clean up some of the
formatting, as below, in a dataframe.

``` r
# Clean table
table1_format <- as.data.frame(print(table1, showAllLevels = TRUE, printToggle = TRUE,
                                     contDigits = 1
                                     )) %>%
  rename("Characteristic" = "level")

# Make characteristic levels in sentence case 
table1_format$Characteristic <- str_to_sentence(table1_format$Characteristic)

# Rename missing variable names as you want them to appear in the final table
table1_format$Characteristic[1] <- "n"
table1_format$Characteristic[5] <- "Bill Length, mm"
table1_format$Characteristic[6] <- "Bill Depth, mm"
table1_format$Characteristic[7] <- "Flipper Length, mm"
table1_format$Characteristic[8] <- "Body mass, g"

# Remove rownames from the table
rownames(table1_format) <- NULL
```

Here, we use the **kableExtra** packages to create a nicely formatted
table that we can render into a Quarto document. There is a lot more
that you can do with **kable** (color, etc). Beginner tips here:
https://www.geeksforgeeks.org/r-language/kable-method-in-r/

``` r
kable(table1_format,
      caption = "Characteristics of penguins from Torgersen, Biscoe, and Dream islands, Palmer Archipelago, Antarctica",
      escape = FALSE
      ) %>% 
  kable_styling() %>%
  add_header_above(c(" " = 2, "Island" = 3)) %>% # the numbers here are for the number of columns
  pack_rows("N", start_row = 1, end_row = 1) %>%
  pack_rows("Species (n, (%))", start_row = 2, end_row = 4) %>%
  pack_rows("Measurements (mean (SD))", start_row = 5, end_row = 8) %>%
  pack_rows("Sex (n, (%))", start_row = 9, end_row = 10) %>%
  pack_rows("Year (n, (%))", start_row = 11, end_row = 13)
```

<table class="table" data-quarto-postprocess="true"
style="margin-left: auto; margin-right: auto;">
<caption>Characteristics of penguins from Torgersen, Biscoe, and Dream
islands, Palmer Archipelago, Antarctica</caption>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 20%" />
</colgroup>
<thead>
<tr>
<th colspan="2" data-quarto-table-cell-role="th"
style="empty-cells: hide; border-bottom: hidden"></th>
<th colspan="3" data-quarto-table-cell-role="th"
style="text-align: center; border-bottom: hidden; padding-bottom: 0; padding-left: 3px; padding-right: 3px;"><div
style="border-bottom: 1px solid #ddd; padding-bottom: 5px; ">
Island
</div></th>
</tr>
<tr>
<th style="text-align: left;"
data-quarto-table-cell-role="th">Characteristic</th>
<th style="text-align: left;"
data-quarto-table-cell-role="th">Overall</th>
<th style="text-align: left;"
data-quarto-table-cell-role="th">Biscoe</th>
<th style="text-align: left;"
data-quarto-table-cell-role="th">Dream</th>
<th style="text-align: left;"
data-quarto-table-cell-role="th">Torgersen</th>
</tr>
</thead>
<tbody>
<tr data-grouplength="1">
<td colspan="5" style="border-bottom: 1px solid"><strong>N</strong></td>
</tr>
<tr>
<td style="text-align: left; padding-left: 2em;"
data-indentlevel="1">n</td>
<td style="text-align: left;">344</td>
<td style="text-align: left;">168</td>
<td style="text-align: left;">124</td>
<td style="text-align: left;">52</td>
</tr>
<tr data-grouplength="3">
<td colspan="5" style="border-bottom: 1px solid"><strong>Species (n,
(%))</strong></td>
</tr>
<tr>
<td style="text-align: left; padding-left: 2em;"
data-indentlevel="1">Adelie</td>
<td style="text-align: left;">152 (44.2)</td>
<td style="text-align: left;">44 (26.2)</td>
<td style="text-align: left;">56 (45.2)</td>
<td style="text-align: left;">52 (100.0)</td>
</tr>
<tr>
<td style="text-align: left; padding-left: 2em;"
data-indentlevel="1">Chinstrap</td>
<td style="text-align: left;">68 (19.8)</td>
<td style="text-align: left;">0 ( 0.0)</td>
<td style="text-align: left;">68 (54.8)</td>
<td style="text-align: left;">0 ( 0.0)</td>
</tr>
<tr>
<td style="text-align: left; padding-left: 2em;"
data-indentlevel="1">Gentoo</td>
<td style="text-align: left;">124 (36.0)</td>
<td style="text-align: left;">124 (73.8)</td>
<td style="text-align: left;">0 ( 0.0)</td>
<td style="text-align: left;">0 ( 0.0)</td>
</tr>
<tr data-grouplength="4">
<td colspan="5" style="border-bottom: 1px solid"><strong>Measurements
(mean (SD))</strong></td>
</tr>
<tr>
<td style="text-align: left; padding-left: 2em;"
data-indentlevel="1">Bill Length, mm</td>
<td style="text-align: left;">43.9 (5.5)</td>
<td style="text-align: left;">45.3 (4.8)</td>
<td style="text-align: left;">44.2 (6.0)</td>
<td style="text-align: left;">39.0 (3.0)</td>
</tr>
<tr>
<td style="text-align: left; padding-left: 2em;"
data-indentlevel="1">Bill Depth, mm</td>
<td style="text-align: left;">17.2 (2.0)</td>
<td style="text-align: left;">15.9 (1.8)</td>
<td style="text-align: left;">18.3 (1.1)</td>
<td style="text-align: left;">18.4 (1.3)</td>
</tr>
<tr>
<td style="text-align: left; padding-left: 2em;"
data-indentlevel="1">Flipper Length, mm</td>
<td style="text-align: left;">200.9 (14.1)</td>
<td style="text-align: left;">209.7 (14.1)</td>
<td style="text-align: left;">193.1 (7.5)</td>
<td style="text-align: left;">191.2 (6.2)</td>
</tr>
<tr>
<td style="text-align: left; padding-left: 2em;"
data-indentlevel="1">Body mass, g</td>
<td style="text-align: left;">4201.8 (802.0)</td>
<td style="text-align: left;">4716.0 (782.9)</td>
<td style="text-align: left;">3712.9 (416.6)</td>
<td style="text-align: left;">3706.4 (445.1)</td>
</tr>
<tr data-grouplength="2">
<td colspan="5" style="border-bottom: 1px solid"><strong>Sex (n,
(%))</strong></td>
</tr>
<tr>
<td style="text-align: left; padding-left: 2em;"
data-indentlevel="1">Female</td>
<td style="text-align: left;">165 (49.5)</td>
<td style="text-align: left;">80 (49.1)</td>
<td style="text-align: left;">61 (49.6)</td>
<td style="text-align: left;">24 ( 51.1)</td>
</tr>
<tr>
<td style="text-align: left; padding-left: 2em;"
data-indentlevel="1">Male</td>
<td style="text-align: left;">168 (50.5)</td>
<td style="text-align: left;">83 (50.9)</td>
<td style="text-align: left;">62 (50.4)</td>
<td style="text-align: left;">23 ( 48.9)</td>
</tr>
<tr data-grouplength="3">
<td colspan="5" style="border-bottom: 1px solid"><strong>Year (n,
(%))</strong></td>
</tr>
<tr>
<td style="text-align: left; padding-left: 2em;"
data-indentlevel="1">2007</td>
<td style="text-align: left;">110 (32.0)</td>
<td style="text-align: left;">44 (26.2)</td>
<td style="text-align: left;">46 (37.1)</td>
<td style="text-align: left;">20 ( 38.5)</td>
</tr>
<tr>
<td style="text-align: left; padding-left: 2em;"
data-indentlevel="1">2008</td>
<td style="text-align: left;">114 (33.1)</td>
<td style="text-align: left;">64 (38.1)</td>
<td style="text-align: left;">34 (27.4)</td>
<td style="text-align: left;">16 ( 30.8)</td>
</tr>
<tr>
<td style="text-align: left; padding-left: 2em;"
data-indentlevel="1">2009</td>
<td style="text-align: left;">120 (34.9)</td>
<td style="text-align: left;">60 (35.7)</td>
<td style="text-align: left;">44 (35.5)</td>
<td style="text-align: left;">16 ( 30.8)</td>
</tr>
</tbody>
</table>

Finally, you might want to save your formatted table as an image. In
that case, you can use the **save_kable()** function from the
**kableExtra** package to save the image as an html. Theoretically, this
should work to save as pdf, png, or jpg, but this has been generating
some errors lately.

``` r
kable(table1_format,
      caption = "Characteristics of penguins from Torgersen, Biscoe, and Dream islands, Palmer Archipelago, Antarctica",
      escape = FALSE
      ) %>% 
  kable_styling() %>%
  add_header_above(c(" " = 2, "Island" = 3)) %>% # the numbers here are for the number of columns
  pack_rows("N", start_row = 1, end_row = 1) %>%
  pack_rows("Species (n, (%))", start_row = 2, end_row = 4) %>%
  pack_rows("Measurements (mean (SD))", start_row = 5, end_row = 8) %>%
  pack_rows("Sex (n, (%))", start_row = 9, end_row = 10) %>%
  pack_rows("Year (n, (%))", start_row = 11, end_row = 13) %>%
  save_kable("table1_format.html")
```
