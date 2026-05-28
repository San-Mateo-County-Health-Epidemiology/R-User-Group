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

Generally, this is how when you should use these packages:

| package      | save as PDF | HTML Quarto | PDF/Typst Quarto | Word Quarto |
|--------------|-------------|-------------|------------------|-------------|
| `flextable`  | x           |             | x                | x           |
| `GT`         | x           | x           | x                |             |
| `kableExtra` | …           | …           | …                | …           |
| `tinytable`  | …           | …           | …                | …           |
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

The **gt** package is a great package to use for tables when your format
is HTML. It offers a wide variety of styling options and is really great
for when you want to dynamically style the table based on the table
contents. There are many different ways to style tables with the **gt**
package, so please see (https://gt.rstudio.com/) for a reference guide
on different styling options.

``` r
library(gt)
```

### Clean data and create GT table

``` r
penguins_table_gt <- penguins %>%
  filter(!if_any(everything(), is.na)) %>%
  select(species, island, sex, bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g) %>%
  mutate(sex = str_to_title(sex)) %>%
  head() %>%
  arrange(sex) %>%
  gt::gt()
```

### Change font type, size, bold, italics

The `opt_table_font()` function can be used to change font type, size,
bold, and italics for the entire table.

``` r
penguins_table_gt %>%
  opt_table_font(font = "Arial",
                 size = "12px",
                 weight = "bold",
                 style = "italic")
```

<div id="qbszwuotvo" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#qbszwuotvo table {
  font-family: Arial, system-ui, 'Segoe UI', Roboto, Helvetica, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#qbszwuotvo thead, #qbszwuotvo tbody, #qbszwuotvo tfoot, #qbszwuotvo tr, #qbszwuotvo td, #qbszwuotvo th {
  border-style: none;
}
&#10;#qbszwuotvo p {
  margin: 0;
  padding: 0;
}
&#10;#qbszwuotvo .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 12px;
  font-weight: bold;
  font-style: italic;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}
&#10;#qbszwuotvo .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#qbszwuotvo .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#qbszwuotvo .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}
&#10;#qbszwuotvo .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#qbszwuotvo .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#qbszwuotvo .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#qbszwuotvo .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: bold;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#qbszwuotvo .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: bold;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#qbszwuotvo .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#qbszwuotvo .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#qbszwuotvo .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#qbszwuotvo .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#qbszwuotvo .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#qbszwuotvo .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}
&#10;#qbszwuotvo .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#qbszwuotvo .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#qbszwuotvo .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#qbszwuotvo .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#qbszwuotvo .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}
&#10;#qbszwuotvo .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#qbszwuotvo .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#qbszwuotvo .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#qbszwuotvo .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}
&#10;#qbszwuotvo .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#qbszwuotvo .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#qbszwuotvo .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#qbszwuotvo .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}
&#10;#qbszwuotvo .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}
&#10;#qbszwuotvo .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}
&#10;#qbszwuotvo .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#qbszwuotvo .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#qbszwuotvo .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#qbszwuotvo .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#qbszwuotvo .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#qbszwuotvo .gt_left {
  text-align: left;
}
&#10;#qbszwuotvo .gt_center {
  text-align: center;
}
&#10;#qbszwuotvo .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#qbszwuotvo .gt_font_normal {
  font-weight: normal;
}
&#10;#qbszwuotvo .gt_font_bold {
  font-weight: bold;
}
&#10;#qbszwuotvo .gt_font_italic {
  font-style: italic;
}
&#10;#qbszwuotvo .gt_super {
  font-size: 65%;
}
&#10;#qbszwuotvo .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#qbszwuotvo .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#qbszwuotvo .gt_indent_1 {
  text-indent: 5px;
}
&#10;#qbszwuotvo .gt_indent_2 {
  text-indent: 10px;
}
&#10;#qbszwuotvo .gt_indent_3 {
  text-indent: 15px;
}
&#10;#qbszwuotvo .gt_indent_4 {
  text-indent: 20px;
}
&#10;#qbszwuotvo .gt_indent_5 {
  text-indent: 25px;
}
&#10;#qbszwuotvo .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}
&#10;#qbszwuotvo div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>

| species | island | sex | bill_length_mm | bill_depth_mm | flipper_length_mm | body_mass_g |
|----|----|----|----|----|----|----|
| Adelie | Torgersen | Female | 39.5 | 17.4 | 186 | 3800 |
| Adelie | Torgersen | Female | 40.3 | 18.0 | 195 | 3250 |
| Adelie | Torgersen | Female | 36.7 | 19.3 | 193 | 3450 |
| Adelie | Torgersen | Female | 38.9 | 17.8 | 181 | 3625 |
| Adelie | Torgersen | Male | 39.1 | 18.7 | 181 | 3750 |
| Adelie | Torgersen | Male | 39.3 | 20.6 | 190 | 3650 |

</div>

The `tab_style()` and `locations()` functions can be used to change font
type, size, bold, and italics for specific rows/columns, the table body,
or the table header.

``` r
penguins_table_gt %>%
  
  # table headers
  tab_style(style = cell_text(size = "16px", 
                              weight = "bold"),
            locations = cells_column_labels(columns = everything())) %>%
  
  # table body
  tab_style(style = cell_text(size = "9px"),
            locations = cells_body()) %>%
  
  # specific row
  tab_style(style = cell_text(style = "italic"),
            locations = cells_body(rows = 1)) %>%
  
  # specific column
  tab_style(style = cell_text(weight = "bold"),
            locations = cells_body(columns = bill_length_mm))
```

<div id="mdslkasdbb" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#mdslkasdbb table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#mdslkasdbb thead, #mdslkasdbb tbody, #mdslkasdbb tfoot, #mdslkasdbb tr, #mdslkasdbb td, #mdslkasdbb th {
  border-style: none;
}
&#10;#mdslkasdbb p {
  margin: 0;
  padding: 0;
}
&#10;#mdslkasdbb .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}
&#10;#mdslkasdbb .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#mdslkasdbb .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#mdslkasdbb .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}
&#10;#mdslkasdbb .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#mdslkasdbb .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#mdslkasdbb .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#mdslkasdbb .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#mdslkasdbb .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#mdslkasdbb .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#mdslkasdbb .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#mdslkasdbb .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#mdslkasdbb .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#mdslkasdbb .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#mdslkasdbb .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}
&#10;#mdslkasdbb .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#mdslkasdbb .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#mdslkasdbb .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#mdslkasdbb .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#mdslkasdbb .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}
&#10;#mdslkasdbb .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#mdslkasdbb .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#mdslkasdbb .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#mdslkasdbb .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}
&#10;#mdslkasdbb .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#mdslkasdbb .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#mdslkasdbb .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#mdslkasdbb .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}
&#10;#mdslkasdbb .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}
&#10;#mdslkasdbb .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}
&#10;#mdslkasdbb .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#mdslkasdbb .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#mdslkasdbb .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#mdslkasdbb .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#mdslkasdbb .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#mdslkasdbb .gt_left {
  text-align: left;
}
&#10;#mdslkasdbb .gt_center {
  text-align: center;
}
&#10;#mdslkasdbb .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#mdslkasdbb .gt_font_normal {
  font-weight: normal;
}
&#10;#mdslkasdbb .gt_font_bold {
  font-weight: bold;
}
&#10;#mdslkasdbb .gt_font_italic {
  font-style: italic;
}
&#10;#mdslkasdbb .gt_super {
  font-size: 65%;
}
&#10;#mdslkasdbb .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#mdslkasdbb .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#mdslkasdbb .gt_indent_1 {
  text-indent: 5px;
}
&#10;#mdslkasdbb .gt_indent_2 {
  text-indent: 10px;
}
&#10;#mdslkasdbb .gt_indent_3 {
  text-indent: 15px;
}
&#10;#mdslkasdbb .gt_indent_4 {
  text-indent: 20px;
}
&#10;#mdslkasdbb .gt_indent_5 {
  text-indent: 25px;
}
&#10;#mdslkasdbb .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}
&#10;#mdslkasdbb div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>

| species | island | sex | bill_length_mm | bill_depth_mm | flipper_length_mm | body_mass_g |
|----|----|----|----|----|----|----|
| Adelie | Torgersen | Female | 39.5 | 17.4 | 186 | 3800 |
| Adelie | Torgersen | Female | 40.3 | 18.0 | 195 | 3250 |
| Adelie | Torgersen | Female | 36.7 | 19.3 | 193 | 3450 |
| Adelie | Torgersen | Female | 38.9 | 17.8 | 181 | 3625 |
| Adelie | Torgersen | Male | 39.1 | 18.7 | 181 | 3750 |
| Adelie | Torgersen | Male | 39.3 | 20.6 | 190 | 3650 |

</div>

### Set cell width & height

To set widths and heights for the entire table, use `tab_options()`
function. To set widths for specific columns, use the `cols_width()`
function.

``` r
penguins_table_gt %>%
  
  # Set specific column widths
  cols_width(bill_length_mm ~ px(125)) %>%
  
  # Set row height (affects all rows)
  tab_options(data_row.padding = px(0),
              table.width = px(1000))
```

<div id="oclghpkgir" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#oclghpkgir table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#oclghpkgir thead, #oclghpkgir tbody, #oclghpkgir tfoot, #oclghpkgir tr, #oclghpkgir td, #oclghpkgir th {
  border-style: none;
}
&#10;#oclghpkgir p {
  margin: 0;
  padding: 0;
}
&#10;#oclghpkgir .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: 1000px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}
&#10;#oclghpkgir .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#oclghpkgir .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#oclghpkgir .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}
&#10;#oclghpkgir .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#oclghpkgir .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#oclghpkgir .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#oclghpkgir .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#oclghpkgir .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#oclghpkgir .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#oclghpkgir .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#oclghpkgir .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#oclghpkgir .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#oclghpkgir .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#oclghpkgir .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}
&#10;#oclghpkgir .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#oclghpkgir .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#oclghpkgir .gt_row {
  padding-top: 0px;
  padding-bottom: 0px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#oclghpkgir .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#oclghpkgir .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}
&#10;#oclghpkgir .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#oclghpkgir .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#oclghpkgir .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#oclghpkgir .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}
&#10;#oclghpkgir .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#oclghpkgir .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#oclghpkgir .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#oclghpkgir .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}
&#10;#oclghpkgir .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}
&#10;#oclghpkgir .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}
&#10;#oclghpkgir .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#oclghpkgir .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#oclghpkgir .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#oclghpkgir .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#oclghpkgir .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#oclghpkgir .gt_left {
  text-align: left;
}
&#10;#oclghpkgir .gt_center {
  text-align: center;
}
&#10;#oclghpkgir .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#oclghpkgir .gt_font_normal {
  font-weight: normal;
}
&#10;#oclghpkgir .gt_font_bold {
  font-weight: bold;
}
&#10;#oclghpkgir .gt_font_italic {
  font-style: italic;
}
&#10;#oclghpkgir .gt_super {
  font-size: 65%;
}
&#10;#oclghpkgir .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#oclghpkgir .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#oclghpkgir .gt_indent_1 {
  text-indent: 5px;
}
&#10;#oclghpkgir .gt_indent_2 {
  text-indent: 10px;
}
&#10;#oclghpkgir .gt_indent_3 {
  text-indent: 15px;
}
&#10;#oclghpkgir .gt_indent_4 {
  text-indent: 20px;
}
&#10;#oclghpkgir .gt_indent_5 {
  text-indent: 25px;
}
&#10;#oclghpkgir .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}
&#10;#oclghpkgir div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>

| species | island | sex | bill_length_mm | bill_depth_mm | flipper_length_mm | body_mass_g |
|----|----|----|----|----|----|----|
| Adelie | Torgersen | Female | 39.5 | 17.4 | 186 | 3800 |
| Adelie | Torgersen | Female | 40.3 | 18.0 | 195 | 3250 |
| Adelie | Torgersen | Female | 36.7 | 19.3 | 193 | 3450 |
| Adelie | Torgersen | Female | 38.9 | 17.8 | 181 | 3625 |
| Adelie | Torgersen | Male | 39.1 | 18.7 | 181 | 3750 |
| Adelie | Torgersen | Male | 39.3 | 20.6 | 190 | 3650 |

</div>

### Set font color

The `tab_style()` and `locations()` functions can be used to change font
or background color for specific rows/columns and cells.

``` r
penguins_table_gt %>%
    tab_style(style = cell_fill(color = "orange"),
              locations = cells_body(rows = bill_length_mm > 40)) %>%
    
  tab_style(style = cell_text(color = "red"),
            locations = cells_body(columns = bill_length_mm)) %>%
  
  tab_style(style = cell_fill(color = "yellow"),
            locations = cells_body(columns = bill_depth_mm,
                                  rows = bill_depth_mm > 20))
```

<div id="xgrqisyuke" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#xgrqisyuke table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#xgrqisyuke thead, #xgrqisyuke tbody, #xgrqisyuke tfoot, #xgrqisyuke tr, #xgrqisyuke td, #xgrqisyuke th {
  border-style: none;
}
&#10;#xgrqisyuke p {
  margin: 0;
  padding: 0;
}
&#10;#xgrqisyuke .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}
&#10;#xgrqisyuke .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#xgrqisyuke .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#xgrqisyuke .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}
&#10;#xgrqisyuke .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#xgrqisyuke .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#xgrqisyuke .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#xgrqisyuke .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#xgrqisyuke .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#xgrqisyuke .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#xgrqisyuke .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#xgrqisyuke .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#xgrqisyuke .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#xgrqisyuke .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#xgrqisyuke .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}
&#10;#xgrqisyuke .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#xgrqisyuke .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#xgrqisyuke .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#xgrqisyuke .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#xgrqisyuke .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}
&#10;#xgrqisyuke .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#xgrqisyuke .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#xgrqisyuke .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#xgrqisyuke .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}
&#10;#xgrqisyuke .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#xgrqisyuke .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#xgrqisyuke .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#xgrqisyuke .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}
&#10;#xgrqisyuke .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}
&#10;#xgrqisyuke .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}
&#10;#xgrqisyuke .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#xgrqisyuke .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#xgrqisyuke .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#xgrqisyuke .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#xgrqisyuke .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#xgrqisyuke .gt_left {
  text-align: left;
}
&#10;#xgrqisyuke .gt_center {
  text-align: center;
}
&#10;#xgrqisyuke .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#xgrqisyuke .gt_font_normal {
  font-weight: normal;
}
&#10;#xgrqisyuke .gt_font_bold {
  font-weight: bold;
}
&#10;#xgrqisyuke .gt_font_italic {
  font-style: italic;
}
&#10;#xgrqisyuke .gt_super {
  font-size: 65%;
}
&#10;#xgrqisyuke .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#xgrqisyuke .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#xgrqisyuke .gt_indent_1 {
  text-indent: 5px;
}
&#10;#xgrqisyuke .gt_indent_2 {
  text-indent: 10px;
}
&#10;#xgrqisyuke .gt_indent_3 {
  text-indent: 15px;
}
&#10;#xgrqisyuke .gt_indent_4 {
  text-indent: 20px;
}
&#10;#xgrqisyuke .gt_indent_5 {
  text-indent: 25px;
}
&#10;#xgrqisyuke .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}
&#10;#xgrqisyuke div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>

| species | island | sex | bill_length_mm | bill_depth_mm | flipper_length_mm | body_mass_g |
|----|----|----|----|----|----|----|
| Adelie | Torgersen | Female | 39.5 | 17.4 | 186 | 3800 |
| Adelie | Torgersen | Female | 40.3 | 18.0 | 195 | 3250 |
| Adelie | Torgersen | Female | 36.7 | 19.3 | 193 | 3450 |
| Adelie | Torgersen | Female | 38.9 | 17.8 | 181 | 3625 |
| Adelie | Torgersen | Male | 39.1 | 18.7 | 181 | 3750 |
| Adelie | Torgersen | Male | 39.3 | 20.6 | 190 | 3650 |

</div>

### Set header labels

Use the `cols_label` to change the column names.

``` r
penguins_table_gt %>%
  cols_label(species = "Species", 
             island = "Island", 
             bill_length_mm = "Bill length (mm)",
             bill_depth_mm = "Bill depth (mm)", 
             flipper_length_mm = "Flipper length (mm)",
             body_mass_g = "Body mass (g)", 
             sex = "Sex")
```

<div id="gdpflldlmm" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#gdpflldlmm table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#gdpflldlmm thead, #gdpflldlmm tbody, #gdpflldlmm tfoot, #gdpflldlmm tr, #gdpflldlmm td, #gdpflldlmm th {
  border-style: none;
}
&#10;#gdpflldlmm p {
  margin: 0;
  padding: 0;
}
&#10;#gdpflldlmm .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}
&#10;#gdpflldlmm .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#gdpflldlmm .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#gdpflldlmm .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}
&#10;#gdpflldlmm .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#gdpflldlmm .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#gdpflldlmm .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#gdpflldlmm .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#gdpflldlmm .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#gdpflldlmm .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#gdpflldlmm .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#gdpflldlmm .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#gdpflldlmm .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#gdpflldlmm .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#gdpflldlmm .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}
&#10;#gdpflldlmm .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#gdpflldlmm .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#gdpflldlmm .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#gdpflldlmm .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#gdpflldlmm .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}
&#10;#gdpflldlmm .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#gdpflldlmm .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#gdpflldlmm .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#gdpflldlmm .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}
&#10;#gdpflldlmm .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#gdpflldlmm .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#gdpflldlmm .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#gdpflldlmm .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}
&#10;#gdpflldlmm .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}
&#10;#gdpflldlmm .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}
&#10;#gdpflldlmm .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#gdpflldlmm .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#gdpflldlmm .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#gdpflldlmm .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#gdpflldlmm .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#gdpflldlmm .gt_left {
  text-align: left;
}
&#10;#gdpflldlmm .gt_center {
  text-align: center;
}
&#10;#gdpflldlmm .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#gdpflldlmm .gt_font_normal {
  font-weight: normal;
}
&#10;#gdpflldlmm .gt_font_bold {
  font-weight: bold;
}
&#10;#gdpflldlmm .gt_font_italic {
  font-style: italic;
}
&#10;#gdpflldlmm .gt_super {
  font-size: 65%;
}
&#10;#gdpflldlmm .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#gdpflldlmm .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#gdpflldlmm .gt_indent_1 {
  text-indent: 5px;
}
&#10;#gdpflldlmm .gt_indent_2 {
  text-indent: 10px;
}
&#10;#gdpflldlmm .gt_indent_3 {
  text-indent: 15px;
}
&#10;#gdpflldlmm .gt_indent_4 {
  text-indent: 20px;
}
&#10;#gdpflldlmm .gt_indent_5 {
  text-indent: 25px;
}
&#10;#gdpflldlmm .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}
&#10;#gdpflldlmm div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>

| Species | Island | Sex | Bill length (mm) | Bill depth (mm) | Flipper length (mm) | Body mass (g) |
|----|----|----|----|----|----|----|
| Adelie | Torgersen | Female | 39.5 | 17.4 | 186 | 3800 |
| Adelie | Torgersen | Female | 40.3 | 18.0 | 195 | 3250 |
| Adelie | Torgersen | Female | 36.7 | 19.3 | 193 | 3450 |
| Adelie | Torgersen | Female | 38.9 | 17.8 | 181 | 3625 |
| Adelie | Torgersen | Male | 39.1 | 18.7 | 181 | 3750 |
| Adelie | Torgersen | Male | 39.3 | 20.6 | 190 | 3650 |

</div>

### Add row of labels to header and titles

Use the `tab_header()` function to add table titles. Use the
`tab_spanner()` function to create grouped column headers (spanners).

``` r
penguins_table_gt %>%
  tab_header(title = md("**Penguins Table**"),
             subtitle = "GT Table") %>%
  tab_spanner(label = "Demographics",
              columns = c("species", "island", "sex")) %>%
  tab_spanner(label = "Body Measurements",
              columns = c("bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g"))
```

<div id="nzqujazxgm" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#nzqujazxgm table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#nzqujazxgm thead, #nzqujazxgm tbody, #nzqujazxgm tfoot, #nzqujazxgm tr, #nzqujazxgm td, #nzqujazxgm th {
  border-style: none;
}
&#10;#nzqujazxgm p {
  margin: 0;
  padding: 0;
}
&#10;#nzqujazxgm .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}
&#10;#nzqujazxgm .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#nzqujazxgm .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#nzqujazxgm .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}
&#10;#nzqujazxgm .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#nzqujazxgm .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#nzqujazxgm .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#nzqujazxgm .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#nzqujazxgm .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#nzqujazxgm .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#nzqujazxgm .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#nzqujazxgm .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#nzqujazxgm .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#nzqujazxgm .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#nzqujazxgm .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}
&#10;#nzqujazxgm .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#nzqujazxgm .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#nzqujazxgm .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#nzqujazxgm .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#nzqujazxgm .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}
&#10;#nzqujazxgm .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#nzqujazxgm .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#nzqujazxgm .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#nzqujazxgm .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}
&#10;#nzqujazxgm .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#nzqujazxgm .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#nzqujazxgm .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#nzqujazxgm .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}
&#10;#nzqujazxgm .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}
&#10;#nzqujazxgm .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}
&#10;#nzqujazxgm .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#nzqujazxgm .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#nzqujazxgm .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#nzqujazxgm .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#nzqujazxgm .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#nzqujazxgm .gt_left {
  text-align: left;
}
&#10;#nzqujazxgm .gt_center {
  text-align: center;
}
&#10;#nzqujazxgm .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#nzqujazxgm .gt_font_normal {
  font-weight: normal;
}
&#10;#nzqujazxgm .gt_font_bold {
  font-weight: bold;
}
&#10;#nzqujazxgm .gt_font_italic {
  font-style: italic;
}
&#10;#nzqujazxgm .gt_super {
  font-size: 65%;
}
&#10;#nzqujazxgm .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#nzqujazxgm .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#nzqujazxgm .gt_indent_1 {
  text-indent: 5px;
}
&#10;#nzqujazxgm .gt_indent_2 {
  text-indent: 10px;
}
&#10;#nzqujazxgm .gt_indent_3 {
  text-indent: 15px;
}
&#10;#nzqujazxgm .gt_indent_4 {
  text-indent: 20px;
}
&#10;#nzqujazxgm .gt_indent_5 {
  text-indent: 25px;
}
&#10;#nzqujazxgm .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}
&#10;#nzqujazxgm div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>

<table class="gt_table" style="width:100%;"
data-quarto-postprocess="true" data-quarto-disable-processing="false"
data-quarto-bootstrap="false">
<colgroup>
<col style="width: 14%" />
<col style="width: 14%" />
<col style="width: 14%" />
<col style="width: 14%" />
<col style="width: 14%" />
<col style="width: 14%" />
<col style="width: 14%" />
</colgroup>
<thead>
<tr class="gt_heading">
<th colspan="7"
class="gt_heading gt_title gt_font_normal"><strong>Penguins
Table</strong></th>
</tr>
<tr class="gt_heading">
<th colspan="7"
class="gt_heading gt_subtitle gt_font_normal gt_bottom_border">GT
Table</th>
</tr>
<tr class="gt_col_headings gt_spanner_row">
<th colspan="3" id="Demographics"
class="gt_center gt_columns_top_border gt_column_spanner_outer"
data-quarto-table-cell-role="th" scope="colgroup"><div
class="gt_column_spanner">
Demographics
</div></th>
<th colspan="4" id="Body Measurements"
class="gt_center gt_columns_top_border gt_column_spanner_outer"
data-quarto-table-cell-role="th" scope="colgroup"><div
class="gt_column_spanner">
Body Measurements
</div></th>
</tr>
<tr class="gt_col_headings">
<th id="species"
class="gt_col_heading gt_columns_bottom_border gt_center"
data-quarto-table-cell-role="th" scope="col">species</th>
<th id="island"
class="gt_col_heading gt_columns_bottom_border gt_center"
data-quarto-table-cell-role="th" scope="col">island</th>
<th id="sex" class="gt_col_heading gt_columns_bottom_border gt_left"
data-quarto-table-cell-role="th" scope="col">sex</th>
<th id="bill_length_mm"
class="gt_col_heading gt_columns_bottom_border gt_right"
data-quarto-table-cell-role="th" scope="col">bill_length_mm</th>
<th id="bill_depth_mm"
class="gt_col_heading gt_columns_bottom_border gt_right"
data-quarto-table-cell-role="th" scope="col">bill_depth_mm</th>
<th id="flipper_length_mm"
class="gt_col_heading gt_columns_bottom_border gt_right"
data-quarto-table-cell-role="th" scope="col">flipper_length_mm</th>
<th id="body_mass_g"
class="gt_col_heading gt_columns_bottom_border gt_right"
data-quarto-table-cell-role="th" scope="col">body_mass_g</th>
</tr>
</thead>
<tbody class="gt_table_body">
<tr>
<td class="gt_row gt_center" headers="species">Adelie</td>
<td class="gt_row gt_center" headers="island">Torgersen</td>
<td class="gt_row gt_left" headers="sex">Female</td>
<td class="gt_row gt_right" headers="bill_length_mm">39.5</td>
<td class="gt_row gt_right" headers="bill_depth_mm">17.4</td>
<td class="gt_row gt_right" headers="flipper_length_mm">186</td>
<td class="gt_row gt_right" headers="body_mass_g">3800</td>
</tr>
<tr>
<td class="gt_row gt_center" headers="species">Adelie</td>
<td class="gt_row gt_center" headers="island">Torgersen</td>
<td class="gt_row gt_left" headers="sex">Female</td>
<td class="gt_row gt_right" headers="bill_length_mm">40.3</td>
<td class="gt_row gt_right" headers="bill_depth_mm">18.0</td>
<td class="gt_row gt_right" headers="flipper_length_mm">195</td>
<td class="gt_row gt_right" headers="body_mass_g">3250</td>
</tr>
<tr>
<td class="gt_row gt_center" headers="species">Adelie</td>
<td class="gt_row gt_center" headers="island">Torgersen</td>
<td class="gt_row gt_left" headers="sex">Female</td>
<td class="gt_row gt_right" headers="bill_length_mm">36.7</td>
<td class="gt_row gt_right" headers="bill_depth_mm">19.3</td>
<td class="gt_row gt_right" headers="flipper_length_mm">193</td>
<td class="gt_row gt_right" headers="body_mass_g">3450</td>
</tr>
<tr>
<td class="gt_row gt_center" headers="species">Adelie</td>
<td class="gt_row gt_center" headers="island">Torgersen</td>
<td class="gt_row gt_left" headers="sex">Female</td>
<td class="gt_row gt_right" headers="bill_length_mm">38.9</td>
<td class="gt_row gt_right" headers="bill_depth_mm">17.8</td>
<td class="gt_row gt_right" headers="flipper_length_mm">181</td>
<td class="gt_row gt_right" headers="body_mass_g">3625</td>
</tr>
<tr>
<td class="gt_row gt_center" headers="species">Adelie</td>
<td class="gt_row gt_center" headers="island">Torgersen</td>
<td class="gt_row gt_left" headers="sex">Male</td>
<td class="gt_row gt_right" headers="bill_length_mm">39.1</td>
<td class="gt_row gt_right" headers="bill_depth_mm">18.7</td>
<td class="gt_row gt_right" headers="flipper_length_mm">181</td>
<td class="gt_row gt_right" headers="body_mass_g">3750</td>
</tr>
<tr>
<td class="gt_row gt_center" headers="species">Adelie</td>
<td class="gt_row gt_center" headers="island">Torgersen</td>
<td class="gt_row gt_left" headers="sex">Male</td>
<td class="gt_row gt_right" headers="bill_length_mm">39.3</td>
<td class="gt_row gt_right" headers="bill_depth_mm">20.6</td>
<td class="gt_row gt_right" headers="flipper_length_mm">190</td>
<td class="gt_row gt_right" headers="body_mass_g">3650</td>
</tr>
</tbody>
</table>

</div>

### Align contents within cell

Use the `cols_align()` function to align the contents within a cell.

``` r
penguins_table_gt %>%
  cols_align(align = "center",
             columns = everything()) %>%
  cols_align(align = "left",
             columns = c("bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g"))
```

<div id="fttqbvfruw" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#fttqbvfruw table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#fttqbvfruw thead, #fttqbvfruw tbody, #fttqbvfruw tfoot, #fttqbvfruw tr, #fttqbvfruw td, #fttqbvfruw th {
  border-style: none;
}
&#10;#fttqbvfruw p {
  margin: 0;
  padding: 0;
}
&#10;#fttqbvfruw .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}
&#10;#fttqbvfruw .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#fttqbvfruw .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#fttqbvfruw .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}
&#10;#fttqbvfruw .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#fttqbvfruw .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#fttqbvfruw .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#fttqbvfruw .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#fttqbvfruw .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#fttqbvfruw .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#fttqbvfruw .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#fttqbvfruw .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#fttqbvfruw .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#fttqbvfruw .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#fttqbvfruw .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}
&#10;#fttqbvfruw .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#fttqbvfruw .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#fttqbvfruw .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#fttqbvfruw .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#fttqbvfruw .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}
&#10;#fttqbvfruw .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#fttqbvfruw .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#fttqbvfruw .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#fttqbvfruw .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}
&#10;#fttqbvfruw .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#fttqbvfruw .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#fttqbvfruw .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#fttqbvfruw .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}
&#10;#fttqbvfruw .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}
&#10;#fttqbvfruw .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}
&#10;#fttqbvfruw .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#fttqbvfruw .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#fttqbvfruw .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#fttqbvfruw .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#fttqbvfruw .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#fttqbvfruw .gt_left {
  text-align: left;
}
&#10;#fttqbvfruw .gt_center {
  text-align: center;
}
&#10;#fttqbvfruw .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#fttqbvfruw .gt_font_normal {
  font-weight: normal;
}
&#10;#fttqbvfruw .gt_font_bold {
  font-weight: bold;
}
&#10;#fttqbvfruw .gt_font_italic {
  font-style: italic;
}
&#10;#fttqbvfruw .gt_super {
  font-size: 65%;
}
&#10;#fttqbvfruw .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#fttqbvfruw .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#fttqbvfruw .gt_indent_1 {
  text-indent: 5px;
}
&#10;#fttqbvfruw .gt_indent_2 {
  text-indent: 10px;
}
&#10;#fttqbvfruw .gt_indent_3 {
  text-indent: 15px;
}
&#10;#fttqbvfruw .gt_indent_4 {
  text-indent: 20px;
}
&#10;#fttqbvfruw .gt_indent_5 {
  text-indent: 25px;
}
&#10;#fttqbvfruw .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}
&#10;#fttqbvfruw div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>

| species | island | sex | bill_length_mm | bill_depth_mm | flipper_length_mm | body_mass_g |
|----|----|----|----|----|----|----|
| Adelie | Torgersen | Female | 39.5 | 17.4 | 186 | 3800 |
| Adelie | Torgersen | Female | 40.3 | 18.0 | 195 | 3250 |
| Adelie | Torgersen | Female | 36.7 | 19.3 | 193 | 3450 |
| Adelie | Torgersen | Female | 38.9 | 17.8 | 181 | 3625 |
| Adelie | Torgersen | Male | 39.1 | 18.7 | 181 | 3750 |
| Adelie | Torgersen | Male | 39.3 | 20.6 | 190 | 3650 |

</div>

## `kable and kableExtra`

## `tinytable`

## `DT`
# packages for formatting tables
Eamonn Hartmann, Madelyn Sather, Sayema Badar, Beth Jump
2026-05-14

<script src="table-formatting-comparison_files/libs/kePrint-0.0.1/kePrint.js"></script>

<link href="table-formatting-comparison_files/libs/lightable-0.0.1/lightable.css" rel="stylesheet" />


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

Generally, this is how when you should use these packages:

| package      | save as PDF | HTML Quarto | PDF/Typst Quarto | Word Quarto |
|--------------|-------------|-------------|------------------|-------------|
| `flextable`  | x           |             | x                | x           |
| `GT`         | …           | …           | …                | …           |
| `kableExtra` | …           | …           | …                | …           |
| `tinytable`  | …           | …           | …                | …           |
| `DT`         | …           | …           | …                | …           |

``` r
library(palmerpenguins)
library(tidyverse)

penguins <- palmerpenguins::penguins
```

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

`kable` and `kableExtra` are a great option for making HTML tables. This
[guide](https://cran.r-project.org/web/packages/kableExtra/vignettes/awesome_table_in_html.html)
includes tons of examples of customization for `kableExtra` tables!

### Clean data and create kable table

``` r
library(kableExtra)

penguins_kable <- penguins %>%
  filter(!if_any(everything(), is.na)) %>%
  group_by(island, species, sex) %>%
  summarize(mean_bill_len = mean(bill_length_mm, na.rm = T),
            mean_flip_len = mean(flipper_length_mm, na.rm = T),
            mean_body_mass = mean(body_mass_g, na.rm = T),
            .groups = "keep") %>%
  ungroup() %>%
  kable()
```

### Change font type, size, bold, italics

You can set the `font_size` in the kable theme or in `row_spec()` but it
doesn’t work if you set it in `column_spec()`

``` r
penguins_kable %>%
  kable_paper(html_font = "Cambria", font_size = 16) %>%
  row_spec(1:3, bold = TRUE, font_size = 10) %>%
  column_spec(4:6, italic = TRUE)
```

| island    | species   | sex    | mean_bill_len | mean_flip_len | mean_body_mass |
|:----------|:----------|:-------|--------------:|--------------:|---------------:|
| Biscoe    | Adelie    | female |      37.35909 |      187.1818 |       3369.318 |
| Biscoe    | Adelie    | male   |      40.59091 |      190.4091 |       4050.000 |
| Biscoe    | Gentoo    | female |      45.56379 |      212.7069 |       4679.741 |
| Biscoe    | Gentoo    | male   |      49.47377 |      221.5410 |       5484.836 |
| Dream     | Adelie    | female |      36.91111 |      187.8519 |       3344.444 |
| Dream     | Adelie    | male   |      40.07143 |      191.9286 |       4045.536 |
| Dream     | Chinstrap | female |      46.57353 |      191.7353 |       3527.206 |
| Dream     | Chinstrap | male   |      51.09412 |      199.9118 |       3938.971 |
| Torgersen | Adelie    | female |      37.55417 |      188.2917 |       3395.833 |
| Torgersen | Adelie    | male   |      40.58696 |      194.9130 |       4034.783 |

### Set column widths & heights

You can easily set column widths with the `width` argument. Making the
columns taller is a bit less straightforward but using the
`extra_css = "padding: 10px"` works. You can change the “10px” to
however many pixels or inches you want.

``` r
penguins_kable %>%
  kable_classic() %>%
  column_spec(1:2, width = c('30%', '30%')) %>%
  row_spec(1:4,
           extra_css = "padding: 10px")
```

| island    | species   | sex    | mean_bill_len | mean_flip_len | mean_body_mass |
|:----------|:----------|:-------|--------------:|--------------:|---------------:|
| Biscoe    | Adelie    | female |      37.35909 |      187.1818 |       3369.318 |
| Biscoe    | Adelie    | male   |      40.59091 |      190.4091 |       4050.000 |
| Biscoe    | Gentoo    | female |      45.56379 |      212.7069 |       4679.741 |
| Biscoe    | Gentoo    | male   |      49.47377 |      221.5410 |       5484.836 |
| Dream     | Adelie    | female |      36.91111 |      187.8519 |       3344.444 |
| Dream     | Adelie    | male   |      40.07143 |      191.9286 |       4045.536 |
| Dream     | Chinstrap | female |      46.57353 |      191.7353 |       3527.206 |
| Dream     | Chinstrap | male   |      51.09412 |      199.9118 |       3938.971 |
| Torgersen | Adelie    | female |      37.55417 |      188.2917 |       3395.833 |
| Torgersen | Adelie    | male   |      40.58696 |      194.9130 |       4034.783 |

### Change font color and background of a cell

`row_spec()` and `column_spec()` allow you to color specific rows and
columns by position.

``` r
penguins_kable %>%
  kable_minimal() %>%
  row_spec(1:3, color = "#2C92B8") %>%
  column_spec(4:6, background = "darkgrey", color = "white")
```

| island    | species   | sex    | mean_bill_len | mean_flip_len | mean_body_mass |
|:----------|:----------|:-------|--------------:|--------------:|---------------:|
| Biscoe    | Adelie    | female |      37.35909 |      187.1818 |       3369.318 |
| Biscoe    | Adelie    | male   |      40.59091 |      190.4091 |       4050.000 |
| Biscoe    | Gentoo    | female |      45.56379 |      212.7069 |       4679.741 |
| Biscoe    | Gentoo    | male   |      49.47377 |      221.5410 |       5484.836 |
| Dream     | Adelie    | female |      36.91111 |      187.8519 |       3344.444 |
| Dream     | Adelie    | male   |      40.07143 |      191.9286 |       4045.536 |
| Dream     | Chinstrap | female |      46.57353 |      191.7353 |       3527.206 |
| Dream     | Chinstrap | male   |      51.09412 |      199.9118 |       3938.971 |
| Torgersen | Adelie    | female |      37.55417 |      188.2917 |       3395.833 |
| Torgersen | Adelie    | male   |      40.58696 |      194.9130 |       4034.783 |

### Change color and thickness of lines separating cells

The easiest way to do this is by using the different themes
(`kable_minimal`, `kable_paper`, etc) that are built into the
`kableExtra` package. If you want to change the lines on a specific
cell, you can try playing around with LaTeX as proposed
[here](https://stackoverflow.com/questions/77647118/how-to-add-horizontal-lines-in-kable-and-the-bottom-line-being-thicker-and-orang).

### Format the header of a the table

In `kableExtra` you can format the header with the `row_spec()` function
by referring to the top row as 0.

``` r
penguins_kable %>%
  row_spec(0, font_size = 18, bold = T, italic = T)
```

| island    | species   | sex    | mean_bill_len | mean_flip_len | mean_body_mass |
|:----------|:----------|:-------|--------------:|--------------:|---------------:|
| Biscoe    | Adelie    | female |      37.35909 |      187.1818 |       3369.318 |
| Biscoe    | Adelie    | male   |      40.59091 |      190.4091 |       4050.000 |
| Biscoe    | Gentoo    | female |      45.56379 |      212.7069 |       4679.741 |
| Biscoe    | Gentoo    | male   |      49.47377 |      221.5410 |       5484.836 |
| Dream     | Adelie    | female |      36.91111 |      187.8519 |       3344.444 |
| Dream     | Adelie    | male   |      40.07143 |      191.9286 |       4045.536 |
| Dream     | Chinstrap | female |      46.57353 |      191.7353 |       3527.206 |
| Dream     | Chinstrap | male   |      51.09412 |      199.9118 |       3938.971 |
| Torgersen | Adelie    | female |      37.55417 |      188.2917 |       3395.833 |
| Torgersen | Adelie    | male   |      40.58696 |      194.9130 |       4034.783 |

Here’s how to add an additional header above the table.

``` r
penguins_kable %>%
  add_header_above(c("", "Species & sex" = 2, "Avg measurements" = 3), bold = TRUE)
```

<table style="width:100%;" data-quarto-postprocess="true">
<colgroup>
<col style="width: 16%" />
<col style="width: 16%" />
<col style="width: 16%" />
<col style="width: 16%" />
<col style="width: 16%" />
<col style="width: 16%" />
</colgroup>
<thead>
<tr>
<th data-quarto-table-cell-role="th"
style="text-align: left; empty-cells: hide; border-bottom: hidden;"></th>
<th colspan="2" data-quarto-table-cell-role="th"
style="text-align: center; border-bottom: hidden; padding-bottom: 0; padding-left: 3px; padding-right: 3px; font-weight: bold;"><div
style="border-bottom: 1px solid #ddd; padding-bottom: 5px; ">
Species &amp; sex
</div></th>
<th colspan="3" data-quarto-table-cell-role="th"
style="text-align: center; border-bottom: hidden; padding-bottom: 0; padding-left: 3px; padding-right: 3px; font-weight: bold;"><div
style="border-bottom: 1px solid #ddd; padding-bottom: 5px; ">
Avg measurements
</div></th>
</tr>
<tr>
<th style="text-align: left;"
data-quarto-table-cell-role="th">island</th>
<th style="text-align: left;"
data-quarto-table-cell-role="th">species</th>
<th style="text-align: left;" data-quarto-table-cell-role="th">sex</th>
<th style="text-align: right;"
data-quarto-table-cell-role="th">mean_bill_len</th>
<th style="text-align: right;"
data-quarto-table-cell-role="th">mean_flip_len</th>
<th style="text-align: right;"
data-quarto-table-cell-role="th">mean_body_mass</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;">Biscoe</td>
<td style="text-align: left;">Adelie</td>
<td style="text-align: left;">female</td>
<td style="text-align: right;">37.35909</td>
<td style="text-align: right;">187.1818</td>
<td style="text-align: right;">3369.318</td>
</tr>
<tr>
<td style="text-align: left;">Biscoe</td>
<td style="text-align: left;">Adelie</td>
<td style="text-align: left;">male</td>
<td style="text-align: right;">40.59091</td>
<td style="text-align: right;">190.4091</td>
<td style="text-align: right;">4050.000</td>
</tr>
<tr>
<td style="text-align: left;">Biscoe</td>
<td style="text-align: left;">Gentoo</td>
<td style="text-align: left;">female</td>
<td style="text-align: right;">45.56379</td>
<td style="text-align: right;">212.7069</td>
<td style="text-align: right;">4679.741</td>
</tr>
<tr>
<td style="text-align: left;">Biscoe</td>
<td style="text-align: left;">Gentoo</td>
<td style="text-align: left;">male</td>
<td style="text-align: right;">49.47377</td>
<td style="text-align: right;">221.5410</td>
<td style="text-align: right;">5484.836</td>
</tr>
<tr>
<td style="text-align: left;">Dream</td>
<td style="text-align: left;">Adelie</td>
<td style="text-align: left;">female</td>
<td style="text-align: right;">36.91111</td>
<td style="text-align: right;">187.8519</td>
<td style="text-align: right;">3344.444</td>
</tr>
<tr>
<td style="text-align: left;">Dream</td>
<td style="text-align: left;">Adelie</td>
<td style="text-align: left;">male</td>
<td style="text-align: right;">40.07143</td>
<td style="text-align: right;">191.9286</td>
<td style="text-align: right;">4045.536</td>
</tr>
<tr>
<td style="text-align: left;">Dream</td>
<td style="text-align: left;">Chinstrap</td>
<td style="text-align: left;">female</td>
<td style="text-align: right;">46.57353</td>
<td style="text-align: right;">191.7353</td>
<td style="text-align: right;">3527.206</td>
</tr>
<tr>
<td style="text-align: left;">Dream</td>
<td style="text-align: left;">Chinstrap</td>
<td style="text-align: left;">male</td>
<td style="text-align: right;">51.09412</td>
<td style="text-align: right;">199.9118</td>
<td style="text-align: right;">3938.971</td>
</tr>
<tr>
<td style="text-align: left;">Torgersen</td>
<td style="text-align: left;">Adelie</td>
<td style="text-align: left;">female</td>
<td style="text-align: right;">37.55417</td>
<td style="text-align: right;">188.2917</td>
<td style="text-align: right;">3395.833</td>
</tr>
<tr>
<td style="text-align: left;">Torgersen</td>
<td style="text-align: left;">Adelie</td>
<td style="text-align: left;">male</td>
<td style="text-align: right;">40.58696</td>
<td style="text-align: right;">194.9130</td>
<td style="text-align: right;">4034.783</td>
</tr>
</tbody>
</table>

### Align contents within cell

By default, `kableExtra` aligns text to the left and numbers to the
right, which is excellent!! If you want to align all of the cells in the
table, you can use `align = "c"` (or `"l"` or `"r"`) in the `kbl()`
function.

``` r
penguins[1:4, 1:4] %>%
  kable(align = 'rccl')
```

| species |  island   | bill_length_mm | bill_depth_mm |
|--------:|:---------:|:--------------:|:--------------|
|  Adelie | Torgersen |      39.1      | 18.7          |
|  Adelie | Torgersen |      39.5      | 17.4          |
|  Adelie | Torgersen |      40.3      | 18.0          |
|  Adelie | Torgersen |       NA       | NA            |

### Merge cells vertically

The `collapse_rows()` function makes this super easy!

``` r
penguins_kable %>%
  kable_paper(full_width = F) %>%
  column_spec(1, bold = T) %>%
  collapse_rows(columns = 1:2, valign = "top")
```

| island    | species   | sex    | mean_bill_len | mean_flip_len | mean_body_mass |
|:----------|:----------|:-------|--------------:|--------------:|---------------:|
| Biscoe    | Adelie    | female |      37.35909 |      187.1818 |       3369.318 |
|           |           | male   |      40.59091 |      190.4091 |       4050.000 |
|           | Gentoo    | female |      45.56379 |      212.7069 |       4679.741 |
|           |           | male   |      49.47377 |      221.5410 |       5484.836 |
| Dream     | Adelie    | female |      36.91111 |      187.8519 |       3344.444 |
|           |           | male   |      40.07143 |      191.9286 |       4045.536 |
|           | Chinstrap | female |      46.57353 |      191.7353 |       3527.206 |
|           |           | male   |      51.09412 |      199.9118 |       3938.971 |
| Torgersen | Adelie    | female |      37.55417 |      188.2917 |       3395.833 |
|           |           | male   |      40.58696 |      194.9130 |       4034.783 |

### Merge cells horizontally

It doesn’t seem like you can merge columns in `kableExtra` but you can
group sets of rows with `pack_rows()` which might come in handy.

``` r
penguins_kable %>%
  pack_rows(index = c("Group 1" = 4,
                      "Group 2" = 4, 
                      "Group 3" = 2),
            label_row_css = "background-color: #666; color: #fff;")
```

| island      | species   | sex    | mean_bill_len | mean_flip_len | mean_body_mass |
|-------------|-----------|--------|---------------|---------------|----------------|
| **Group 1** |           |        |               |               |                |
| Biscoe      | Adelie    | female | 37.35909      | 187.1818      | 3369.318       |
| Biscoe      | Adelie    | male   | 40.59091      | 190.4091      | 4050.000       |
| Biscoe      | Gentoo    | female | 45.56379      | 212.7069      | 4679.741       |
| Biscoe      | Gentoo    | male   | 49.47377      | 221.5410      | 5484.836       |
| **Group 2** |           |        |               |               |                |
| Dream       | Adelie    | female | 36.91111      | 187.8519      | 3344.444       |
| Dream       | Adelie    | male   | 40.07143      | 191.9286      | 4045.536       |
| Dream       | Chinstrap | female | 46.57353      | 191.7353      | 3527.206       |
| Dream       | Chinstrap | male   | 51.09412      | 199.9118      | 3938.971       |
| **Group 3** |           |        |               |               |                |
| Torgersen   | Adelie    | female | 37.55417      | 188.2917      | 3395.833       |
| Torgersen   | Adelie    | male   | 40.58696      | 194.9130      | 4034.783       |

### Bonus: adding plots into the table

`kableExtra` makes it pretty easy to add tiny plots to your table! See
[here](https://cran.r-project.org/web/packages/kableExtra/vignettes/awesome_table_in_html.html#Insert_Images_into_Columns)
(you need to scroll down a bit to the section just before `Row Spec`)
for an example!

## `tinytable`

## `DT`

The `DT` package creates interactive tables that the end user can
search, filter and sort. These don’t render in a GitHub-flavored
markdown so I’ve just displayed the code below. If you want to test
these out, you can render this on your local machine and you’ll be able
to see the tables.

``` r
library(DT)

penguins_dt <- penguins %>%
  filter(species == "Adelie" &
           !is.na(sex)) %>%
  group_by(species, island, sex) %>%
  summarize(mean_bill_len = mean(bill_length_mm, na.rm = T),
            mean_flip_len = mean(flipper_length_mm, na.rm = T),
            mean_body_mass = mean(body_mass_g, na.rm = T),
            .groups = "keep") %>%
  ungroup() %>%
  mutate(across(where(is.numeric), ~ round(.x, 1)))
```

### Change font type, size, bold, italics

You can change font size, weight and italics using the `formatStyle()`
function. You need to use JavaScript notation to change the font (see
`list(initComplete())`).

You can try to do any of these things with JavaScript notation. See
[here](https://stackoverflow.com/questions/44101055/changing-font-size-in-r-datatables-dt)
for how to change font size using Javascript.

``` r
penguins_dt %>%
  datatable(options = list(
    initComplete = JS(
      "function(settings, json) {",
      "$('body').css({'font-family': 'Calibri'});",
      "}"))) %>%
  formatStyle(columns = 'island', fontSize = '20%') %>%
  formatStyle(columns = 'sex', fontWeight = 'bold') %>%
  formatStyle(columns = 'species', fontStyle = 'italic') %>%
  kbl(escape = FALSE) %>%
  kable_paper() %>%
  save_kable(file = "table1.html", self_contained = F)
```

### Set column widths & heights

``` r
penguins_dt %>%
  datatable(options = list(
    autoWidth = FALSE,
    columnDefs = list(list(targets = "_all", width = '20px'))))
```

### Change font color and background of a cell

``` r
penguins_dt %>%
  datatable() %>%
  formatStyle('species',  
              color = '#2C92B8') %>%
  formatStyle('sex',
              backgroundColor = '#FFDF20')
```

### Change color and thickness of lines separating cells

I couldn’t find an easy way to edit the color and thickness of lines
separating cells. Instead I’ve included information on how to generally
style a table.

Here is a [guide](https://datatables.net/manual/styling/classes) to the
options available for styling a DT table. Just list all of the options
you want to enable in the `class` argument. Options should be separated
by a space, not a comma. In the example below our table has cell
borders, is compact and striped.

``` r
penguins_dt %>%
  datatable(class = 'cell-border compact stripe')
```

### Format the header of the table

Here is how to change the text color and background and make the font
bold using JavaScript notation.

``` r
penguins_dt %>%
  datatable(options = list(
  initComplete = JS(
    "function(settings, json) {",
    "$(this.api().table().header()).css({'background-color': '#000', 'color': '#ffce00', 'font-style': 'bold'});",
    "}")
))
```

Here is how to make a totally custom header (taken from
[here](https://rstudio.github.io/DT/)).

``` r
penguins_dt <- penguins_dt %>%
  select(island, everything())

sketch <- htmltools::withTags(table(
  class = 'display',
  thead(
    tr(
      th(rowspan = 2, 'Island'),
      th(colspan = 2, 'Species & sex'),
      th(colspan = 3, 'Mean measurements')
    ),
    tr(
      lapply(colnames(penguins_dt[2:ncol(penguins_dt)]), th)
    )
  )
))

penguins_dt %>%
  select(island, everything()) %>%
  datatable(container = sketch, rownames = F)
```

### Align contents within cell

Here we’re centering all (`_all`) headers, left aligning text columns
and right aligning numerical columns.

``` r
penguins_dt %>%
  datatable(options = list(columnDefs = list(
    list(targets = "_all", className = "dt-head-center"), # Center header text
    list(targets = 1:3, className = 'dt-left'),
    list(targets = 4:6, className = 'dt-right'))))
```

### Merge cells horizontally

Here’s how to use values from a column to group output by value. Note:
the grouping column is specified by the number here,
`list(dataSrc = c(1))`. Unlike normal R things, the indexing here starts
at 0, not 1. So if you wanted to group by the first column you’d use a
0, the second column you’d use a 1, etc.

I haven’t figured out how to change the column alignment of the grouped
variable.

``` r
penguins_dt %>%
  datatable(rownames = FALSE, 
           extensions = 'RowGroup', 
           options = list(rowGroup = list(dataSrc = c(1)),
                          columnDefs = list(list(targets = 1, visible = FALSE))))
```

### Merge cells horizontally

This [stack
overflow](https://stackoverflow.com/questions/39484118/shiny-merge-cells-in-dtdatatable)
post goes over how to do this in Shiny but I don’t fully get it.

### Bonus: exporting `datatable` data

If you include a `DT` table in a Quarto doc or R Shiny dashboard, you
can allow end users to download the data right from your doc!
[Source](https://www.r-bloggers.com/2021/05/datatable-editor-dt-package-in-r/).

``` r
penguins_dt %>%
  datatable(extensions = 'Buttons',
            options = list(dom='Bfrtip',
                           buttons=c('copy', 'csv', 'excel', 'print', 'pdf')))
```
