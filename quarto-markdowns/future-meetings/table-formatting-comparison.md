# packages for formatting tables
Eamonn Hartmann, Madelyn Sather, Sayema Badar, Beth Jump
2026-05-14

## Background

There are many packages you can use to format a table in Quarto. This
document goes over 5 of them:

- [flextable](https://ardata-fr.github.io/flextable-book/)
- [GT](https://gt.rstudio.com/)
- [kable and
  kableExtra](https://cran.r-project.org/web/packages/kableExtra/vignettes/awesome_table_in_html.html)
- [tinytable](https://vincentarelbundock.github.io/tinytable/)
- [DT](https://rstudio.github.io/DT/)

In each section below, a different package is used to format the
`palmerpenguins::penguins` data set. The code will go over how to:

- change the font type, font size and whether the font is regular,
  **bold** or *italic*
- set column widths and heights
- change the font color and the background of the cell
- change the color and thickness of lines separating cells
- format the header of the table
- align text in a column (text should always be left aligned, numbers
  should always be right aligned)
- merge cells vertically and horizontally.

### Compatible formats

Generally, this is when you should use these packages:

| package      | save as PDF | HTML Quarto | PDF/Typst Quarto | Word Quarto |
|--------------|-------------|-------------|------------------|-------------|
| `flextable`  | x           |             | x                | x           |
| `GT`         | …           | …           | …                | …           |
| `kableExtra` | …           | …           | …                | …           |
| `tinytable`  | x           | x           | x                | x           |
| `DT`         | …           | …           | …                | …           |

``` r
library(palmerpenguins)
library(tidyverse)

palmerpenguins::penguins
```

    # A tibble: 344 × 8
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
    # ℹ 334 more rows
    # ℹ 2 more variables: sex <fct>, year <int>

## `flextable`

``` r
library(flextable)
library(officer)
```

### Clean data and create flextable

``` r
penguins_table <- penguins %>%
  filter(!if_any(everything(), is.na)) %>%
  select(species, island, sex, bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g) %>%
  mutate(sex = str_to_title(sex)) %>%
  head() %>%
  arrange(sex) %>%
  flextable()
```

### Change font type, size, bold, italics

For each of the following functions, use `i =` to change the font
parameters of a specific row and use `j =` to change the font parameters
of a specific column.

``` r
penguins_table %>%  
  font(fontname = "Arial", part = "all") %>%
  fontsize(size = 12, part = "body") %>% 
  bold(bold = TRUE, part = "header") %>% 
  italic(italic = TRUE, part = "header") 
```

![](table-formatting-comparison_files/figure-commonmark/unnamed-chunk-4-1.png)

### Set cell width & height

For `width()`, use `j =` to adjust the width of a specific column. For
`height()`, use `i =` to adjust the height of a specific row.

``` r
penguins_table %>%    
  width(width = 1.2, unit = "in") %>%
  height(height = 0.5, part = "header")
```

![](table-formatting-comparison_files/figure-commonmark/unnamed-chunk-5-1.png)

### Set font color

The `officer` package is required to change the color of the font and
background of cells and the thickness of the lines separating the cells.

``` r
custom_line <- fp_border(color = "grey", style = "solid", width = 1)

penguins_table %>%  
  color(i = 6, j = 5, color = "red", part = "body") %>% 
  bg(i = 2, j = 4, bg = "yellow", part = "body") %>% 
  border_inner(border = custom_line)
```

![](table-formatting-comparison_files/figure-commonmark/unnamed-chunk-6-1.png)

### Set header labels

``` r
penguins_table %>%
  set_header_labels(species = "Species", 
    island = "Island", bill_length_mm = "Bill length (mm)",
    bill_depth_mm = "Bill depth (mm)", flipper_length_mm = "Flipper length (mm)",
    body_mass_g = "Body mass (g)", sex = "Sex", year = "Year")
```

![](table-formatting-comparison_files/figure-commonmark/unnamed-chunk-7-1.png)

### Add row of labels to header

``` r
penguins_table %>%
  add_header_row(values = c("Demographics", "Body measurements"), colwidths = c(3, 4)) %>%
  align(i = 1, part = "header", align = "left")
```

![](table-formatting-comparison_files/figure-commonmark/unnamed-chunk-8-1.png)

### Align contents within cell

``` r
penguins_table %>%
  align(j = c(1:3), align = "left") %>%
  align(j = c(4:7), align = "right")
```

![](table-formatting-comparison_files/figure-commonmark/unnamed-chunk-9-1.png)

### Merge cells vertically

``` r
penguins_table %>%
  merge_v(j = ~ species + island)
```

![](table-formatting-comparison_files/figure-commonmark/unnamed-chunk-10-1.png)

### Merge cells horizontally

The `merge_h()` function merges adjacent cells with duplicate values in
the same row.

``` r
penguins_table %>%
  merge_h()
```

![](table-formatting-comparison_files/figure-commonmark/unnamed-chunk-11-1.png)

### `autofit()`

The `autofit()` function can be used to adjust the size of cells to fit
the size of the cell’s contents.

``` r
penguins_table %>%
  autofit()
```

![](table-formatting-comparison_files/figure-commonmark/unnamed-chunk-12-1.png)

## `GT`

## `kable and kableExtra`

## `tinytable`

``` r
library(tinytable)
```

### Clean data and create tinytable

``` r
penguins_table <- penguins %>%
  filter(!if_any(everything(), is.na)) %>%
  select(species, island, sex, bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g) %>%
  mutate(sex = str_to_title(sex)) %>%
  head() %>%
  arrange(sex) %>%
  tt()
```

### Change font type, size, bold, italics

`tinytable` allows for the use of a single function to customize font
type and size using `i =` to change the font parameters of a specific
row and `j =` to change the font parameters of a specific column.

``` r
penguins_table %>%  
  # style the header to be bold and italicized 
  style_tt(i = 0, bold = TRUE, italic = TRUE) %>% 
  # style the full table to be Arial, size 12 
  style_tt(fontname = "Arial", fontsize = 12)
```

| ***species*** | ***island*** | ***sex*** | ***bill_length_mm*** | ***bill_depth_mm*** | ***flipper_length_mm*** | ***body_mass_g*** |
|----|----|----|----|----|----|----|
| Adelie | Torgersen | Female | 39.5 | 17.4 | 186 | 3800 |
| Adelie | Torgersen | Female | 40.3 | 18.0 | 195 | 3250 |
| Adelie | Torgersen | Female | 36.7 | 19.3 | 193 | 3450 |
| Adelie | Torgersen | Female | 38.9 | 17.8 | 181 | 3625 |
| Adelie | Torgersen | Male | 39.1 | 18.7 | 181 | 3750 |
| Adelie | Torgersen | Male | 39.3 | 20.6 | 190 | 3650 |

## `DT`
