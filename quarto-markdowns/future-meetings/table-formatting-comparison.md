# packages for formatting tables
Eamonn Hartmann, Madelyn Sather, Sayema Badar, Beth Jump
2026-05-14

<link href="table-formatting-comparison_files/libs/htmltools-fill-0.5.9/fill.css" rel="stylesheet" />
<script src="table-formatting-comparison_files/libs/htmlwidgets-1.6.4/htmlwidgets.js"></script>
<link href="table-formatting-comparison_files/libs/datatables-css-0.0.0/datatables-crosstalk.css" rel="stylesheet" />
<script src="table-formatting-comparison_files/libs/datatables-binding-0.33/datatables.js"></script>
<script src="table-formatting-comparison_files/libs/jquery-3.6.0/jquery-3.6.0.min.js"></script>
<link href="table-formatting-comparison_files/libs/dt-core-1.13.6/css/jquery.dataTables.min.css" rel="stylesheet" />
<link href="table-formatting-comparison_files/libs/dt-core-1.13.6/css/jquery.dataTables.extra.css" rel="stylesheet" />
<script src="table-formatting-comparison_files/libs/dt-core-1.13.6/js/jquery.dataTables.min.js"></script>
<link href="table-formatting-comparison_files/libs/crosstalk-1.2.2/css/crosstalk.min.css" rel="stylesheet" />
<script src="table-formatting-comparison_files/libs/crosstalk-1.2.2/js/crosstalk.min.js"></script>
<link href="table-formatting-comparison_files/libs/dt-ext-rowgroup-1.13.6/css/rowGroup.dataTables.min.css" rel="stylesheet" />
<script src="table-formatting-comparison_files/libs/dt-ext-rowgroup-1.13.6/js/dataTables.rowGroup.min.js"></script>
<script src="table-formatting-comparison_files/libs/jszip-1.13.6/jszip.min.js"></script>
<script src="table-formatting-comparison_files/libs/pdfmake-1.13.6/pdfmake.js"></script>
<script src="table-formatting-comparison_files/libs/pdfmake-1.13.6/vfs_fonts.js"></script>
<link href="table-formatting-comparison_files/libs/dt-ext-buttons-1.13.6/css/buttons.dataTables.min.css" rel="stylesheet" />
<script src="table-formatting-comparison_files/libs/dt-ext-buttons-1.13.6/js/dataTables.buttons.min.js"></script>
<script src="table-formatting-comparison_files/libs/dt-ext-buttons-1.13.6/js/buttons.html5.min.js"></script>
<script src="table-formatting-comparison_files/libs/dt-ext-buttons-1.13.6/js/buttons.colVis.min.js"></script>
<script src="table-formatting-comparison_files/libs/dt-ext-buttons-1.13.6/js/buttons.print.min.js"></script>

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
  group_by(species, island, sex) %>%
  summarize(mean_bill_len = mean(bill_length_mm, na.rm = T),
            mean_flip_len = mean(flipper_length_mm, na.rm = T),
            mean_body_mass = mean(body_mass_g, na.rm = T),
            .groups = "keep") %>%
  ungroup() %>%
  kable()
```

### Change font type, size, bold, italics

``` r
penguins_kable %>%
  kable_paper(html_font = "Cambria") %>%
  spec_font_size(x = 1)
```

    [1] 12

### Set column widths & heights

### Change font color and background of a cell

### Change color and thickness of lines separating cells

### Format the header of a the table

### Align contents within cell

``` r
penguins_kable 
```

| species   | island    | sex    | mean_bill_len | mean_flip_len | mean_body_mass |
|:----------|:----------|:-------|--------------:|--------------:|---------------:|
| Adelie    | Biscoe    | female |      37.35909 |      187.1818 |       3369.318 |
| Adelie    | Biscoe    | male   |      40.59091 |      190.4091 |       4050.000 |
| Adelie    | Dream     | female |      36.91111 |      187.8519 |       3344.444 |
| Adelie    | Dream     | male   |      40.07143 |      191.9286 |       4045.536 |
| Adelie    | Torgersen | female |      37.55417 |      188.2917 |       3395.833 |
| Adelie    | Torgersen | male   |      40.58696 |      194.9130 |       4034.783 |
| Chinstrap | Dream     | female |      46.57353 |      191.7353 |       3527.206 |
| Chinstrap | Dream     | male   |      51.09412 |      199.9118 |       3938.971 |
| Gentoo    | Biscoe    | female |      45.56379 |      212.7069 |       4679.741 |
| Gentoo    | Biscoe    | male   |      49.47377 |      221.5410 |       5484.836 |

### Merge cells vertically

### Merge cells horizontally

## `tinytable`

## `DT`

The `DT` package creates interactive tables that the end user can
search, filter and sort.

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
  formatStyle(columns = 'species', fontStyle = 'italic')
```

<div class="datatables html-widget html-fill-item" id="htmlwidget-309472a73ea764d8d4ac" style="width:100%;height:auto;"></div>
<script type="application/json" data-for="htmlwidget-309472a73ea764d8d4ac">{"x":{"filter":"none","vertical":false,"data":[["1","2","3","4","5","6"],["Adelie","Adelie","Adelie","Adelie","Adelie","Adelie"],["Biscoe","Biscoe","Dream","Dream","Torgersen","Torgersen"],["female","male","female","male","female","male"],[37.4,40.6,36.9,40.1,37.6,40.6],[187.2,190.4,187.9,191.9,188.3,194.9],[3369.3,4050,3344.4,4045.5,3395.8,4034.8]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>species<\/th>\n      <th>island<\/th>\n      <th>sex<\/th>\n      <th>mean_bill_len<\/th>\n      <th>mean_flip_len<\/th>\n      <th>mean_body_mass<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"initComplete":"function(settings, json) {\n$('body').css({'font-family': 'Calibri'});\n}","columnDefs":[{"className":"dt-right","targets":[4,5,6]},{"orderable":false,"targets":0},{"name":" ","targets":0},{"name":"species","targets":1},{"name":"island","targets":2},{"name":"sex","targets":3},{"name":"mean_bill_len","targets":4},{"name":"mean_flip_len","targets":5},{"name":"mean_body_mass","targets":6}],"order":[],"autoWidth":false,"orderClasses":false,"rowCallback":"function(row, data, displayNum, displayIndex, dataIndex) {\nvar value=data[2]; $(this.api().cell(row, 2).node()).css({'font-size':'20%'});\nvar value=data[3]; $(this.api().cell(row, 3).node()).css({'font-weight':'bold'});\nvar value=data[1]; $(this.api().cell(row, 1).node()).css({'font-style':'italic'});\n}"}},"evals":["options.initComplete","options.rowCallback"],"jsHooks":[]}</script>

### Set column widths & heights

*Note: the internet says this should work but it’s not. Come back!!*

``` r
penguins_dt %>%
  datatable(options = list(
    autoWidth = FALSE,
    columnDefs = list(list(targets = "_all", width = '20px'))))
```

<div class="datatables html-widget html-fill-item" id="htmlwidget-af0850640607003659be" style="width:100%;height:auto;"></div>
<script type="application/json" data-for="htmlwidget-af0850640607003659be">{"x":{"filter":"none","vertical":false,"data":[["1","2","3","4","5","6"],["Adelie","Adelie","Adelie","Adelie","Adelie","Adelie"],["Biscoe","Biscoe","Dream","Dream","Torgersen","Torgersen"],["female","male","female","male","female","male"],[37.4,40.6,36.9,40.1,37.6,40.6],[187.2,190.4,187.9,191.9,188.3,194.9],[3369.3,4050,3344.4,4045.5,3395.8,4034.8]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>species<\/th>\n      <th>island<\/th>\n      <th>sex<\/th>\n      <th>mean_bill_len<\/th>\n      <th>mean_flip_len<\/th>\n      <th>mean_body_mass<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"autoWidth":false,"columnDefs":[{"targets":"_all","width":"20px"},{"className":"dt-right","targets":[4,5,6]},{"orderable":false,"targets":0},{"name":" ","targets":0},{"name":"species","targets":1},{"name":"island","targets":2},{"name":"sex","targets":3},{"name":"mean_bill_len","targets":4},{"name":"mean_flip_len","targets":5},{"name":"mean_body_mass","targets":6}],"order":[],"orderClasses":false}},"evals":[],"jsHooks":[]}</script>

### Change font color and background of a cell

``` r
penguins_dt %>%
  datatable() %>%
  formatStyle('species',  
              color = '#2C92B8') %>%
  formatStyle('sex',
              backgroundColor = '#FFDF20')
```

<div class="datatables html-widget html-fill-item" id="htmlwidget-e6a835cdd9cbf93b4b06" style="width:100%;height:auto;"></div>
<script type="application/json" data-for="htmlwidget-e6a835cdd9cbf93b4b06">{"x":{"filter":"none","vertical":false,"data":[["1","2","3","4","5","6"],["Adelie","Adelie","Adelie","Adelie","Adelie","Adelie"],["Biscoe","Biscoe","Dream","Dream","Torgersen","Torgersen"],["female","male","female","male","female","male"],[37.4,40.6,36.9,40.1,37.6,40.6],[187.2,190.4,187.9,191.9,188.3,194.9],[3369.3,4050,3344.4,4045.5,3395.8,4034.8]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>species<\/th>\n      <th>island<\/th>\n      <th>sex<\/th>\n      <th>mean_bill_len<\/th>\n      <th>mean_flip_len<\/th>\n      <th>mean_body_mass<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"columnDefs":[{"className":"dt-right","targets":[4,5,6]},{"orderable":false,"targets":0},{"name":" ","targets":0},{"name":"species","targets":1},{"name":"island","targets":2},{"name":"sex","targets":3},{"name":"mean_bill_len","targets":4},{"name":"mean_flip_len","targets":5},{"name":"mean_body_mass","targets":6}],"order":[],"autoWidth":false,"orderClasses":false,"rowCallback":"function(row, data, displayNum, displayIndex, dataIndex) {\nvar value=data[1]; $(this.api().cell(row, 1).node()).css({'color':'#2C92B8'});\nvar value=data[3]; $(this.api().cell(row, 3).node()).css({'background-color':'#FFDF20'});\n}"}},"evals":["options.rowCallback"],"jsHooks":[]}</script>

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

<div class="datatables html-widget html-fill-item" id="htmlwidget-1374007253eb72d4602f" style="width:100%;height:auto;"></div>
<script type="application/json" data-for="htmlwidget-1374007253eb72d4602f">{"x":{"filter":"none","vertical":false,"data":[["1","2","3","4","5","6"],["Adelie","Adelie","Adelie","Adelie","Adelie","Adelie"],["Biscoe","Biscoe","Dream","Dream","Torgersen","Torgersen"],["female","male","female","male","female","male"],[37.4,40.6,36.9,40.1,37.6,40.6],[187.2,190.4,187.9,191.9,188.3,194.9],[3369.3,4050,3344.4,4045.5,3395.8,4034.8]],"container":"<table class=\"cell-border compact stripe\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>species<\/th>\n      <th>island<\/th>\n      <th>sex<\/th>\n      <th>mean_bill_len<\/th>\n      <th>mean_flip_len<\/th>\n      <th>mean_body_mass<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"columnDefs":[{"className":"dt-right","targets":[4,5,6]},{"orderable":false,"targets":0},{"name":" ","targets":0},{"name":"species","targets":1},{"name":"island","targets":2},{"name":"sex","targets":3},{"name":"mean_bill_len","targets":4},{"name":"mean_flip_len","targets":5},{"name":"mean_body_mass","targets":6}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>

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

<div class="datatables html-widget html-fill-item" id="htmlwidget-cad33dd6e3fe03ce035b" style="width:100%;height:auto;"></div>
<script type="application/json" data-for="htmlwidget-cad33dd6e3fe03ce035b">{"x":{"filter":"none","vertical":false,"data":[["1","2","3","4","5","6"],["Adelie","Adelie","Adelie","Adelie","Adelie","Adelie"],["Biscoe","Biscoe","Dream","Dream","Torgersen","Torgersen"],["female","male","female","male","female","male"],[37.4,40.6,36.9,40.1,37.6,40.6],[187.2,190.4,187.9,191.9,188.3,194.9],[3369.3,4050,3344.4,4045.5,3395.8,4034.8]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>species<\/th>\n      <th>island<\/th>\n      <th>sex<\/th>\n      <th>mean_bill_len<\/th>\n      <th>mean_flip_len<\/th>\n      <th>mean_body_mass<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"initComplete":"function(settings, json) {\n$(this.api().table().header()).css({'background-color': '#000', 'color': '#ffce00', 'font-style': 'bold'});\n}","columnDefs":[{"className":"dt-right","targets":[4,5,6]},{"orderable":false,"targets":0},{"name":" ","targets":0},{"name":"species","targets":1},{"name":"island","targets":2},{"name":"sex","targets":3},{"name":"mean_bill_len","targets":4},{"name":"mean_flip_len","targets":5},{"name":"mean_body_mass","targets":6}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":["options.initComplete"],"jsHooks":[]}</script>

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

<div class="datatables html-widget html-fill-item" id="htmlwidget-ea1165533c9c9451b6ef" style="width:100%;height:auto;"></div>
<script type="application/json" data-for="htmlwidget-ea1165533c9c9451b6ef">{"x":{"filter":"none","vertical":false,"class":"display","data":[["Biscoe","Biscoe","Dream","Dream","Torgersen","Torgersen"],["Adelie","Adelie","Adelie","Adelie","Adelie","Adelie"],["female","male","female","male","female","male"],[37.4,40.6,36.9,40.1,37.6,40.6],[187.2,190.4,187.9,191.9,188.3,194.9],[3369.3,4050,3344.4,4045.5,3395.8,4034.8]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th rowspan=\"2\">Island<\/th>\n      <th colspan=\"2\">Species &amp; sex<\/th>\n      <th colspan=\"3\">Mean measurements<\/th>\n    <\/tr>\n    <tr>\n      <th>species<\/th>\n      <th>sex<\/th>\n      <th>mean_bill_len<\/th>\n      <th>mean_flip_len<\/th>\n      <th>mean_body_mass<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"columnDefs":[{"className":"dt-right","targets":[3,4,5]},{"name":"island","targets":0},{"name":"species","targets":1},{"name":"sex","targets":2},{"name":"mean_bill_len","targets":3},{"name":"mean_flip_len","targets":4},{"name":"mean_body_mass","targets":5}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>

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

<div class="datatables html-widget html-fill-item" id="htmlwidget-309c2409f6e543e1bfbd" style="width:100%;height:auto;"></div>
<script type="application/json" data-for="htmlwidget-309c2409f6e543e1bfbd">{"x":{"filter":"none","vertical":false,"data":[["1","2","3","4","5","6"],["Biscoe","Biscoe","Dream","Dream","Torgersen","Torgersen"],["Adelie","Adelie","Adelie","Adelie","Adelie","Adelie"],["female","male","female","male","female","male"],[37.4,40.6,36.9,40.1,37.6,40.6],[187.2,190.4,187.9,191.9,188.3,194.9],[3369.3,4050,3344.4,4045.5,3395.8,4034.8]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>island<\/th>\n      <th>species<\/th>\n      <th>sex<\/th>\n      <th>mean_bill_len<\/th>\n      <th>mean_flip_len<\/th>\n      <th>mean_body_mass<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"columnDefs":[{"targets":"_all","className":"dt-head-center"},{"targets":[1,2,3],"className":"dt-left"},{"targets":[4,5,6],"className":"dt-right"},{"orderable":false,"targets":0},{"name":" ","targets":0},{"name":"island","targets":1},{"name":"species","targets":2},{"name":"sex","targets":3},{"name":"mean_bill_len","targets":4},{"name":"mean_flip_len","targets":5},{"name":"mean_body_mass","targets":6}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>

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

<div class="datatables html-widget html-fill-item" id="htmlwidget-17937091cfabd1b6b8bd" style="width:100%;height:auto;"></div>
<script type="application/json" data-for="htmlwidget-17937091cfabd1b6b8bd">{"x":{"filter":"none","vertical":false,"extensions":["RowGroup"],"data":[["Biscoe","Biscoe","Dream","Dream","Torgersen","Torgersen"],["Adelie","Adelie","Adelie","Adelie","Adelie","Adelie"],["female","male","female","male","female","male"],[37.4,40.6,36.9,40.1,37.6,40.6],[187.2,190.4,187.9,191.9,188.3,194.9],[3369.3,4050,3344.4,4045.5,3395.8,4034.8]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th>island<\/th>\n      <th>species<\/th>\n      <th>sex<\/th>\n      <th>mean_bill_len<\/th>\n      <th>mean_flip_len<\/th>\n      <th>mean_body_mass<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"rowGroup":{"dataSrc":1},"columnDefs":[{"targets":1,"visible":false},{"className":"dt-right","targets":[3,4,5]},{"name":"island","targets":0},{"name":"species","targets":1},{"name":"sex","targets":2},{"name":"mean_bill_len","targets":3},{"name":"mean_flip_len","targets":4},{"name":"mean_body_mass","targets":5}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>

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

<div class="datatables html-widget html-fill-item" id="htmlwidget-7a416017a7ae0e95c952" style="width:100%;height:auto;"></div>
<script type="application/json" data-for="htmlwidget-7a416017a7ae0e95c952">{"x":{"filter":"none","vertical":false,"extensions":["Buttons"],"data":[["1","2","3","4","5","6"],["Biscoe","Biscoe","Dream","Dream","Torgersen","Torgersen"],["Adelie","Adelie","Adelie","Adelie","Adelie","Adelie"],["female","male","female","male","female","male"],[37.4,40.6,36.9,40.1,37.6,40.6],[187.2,190.4,187.9,191.9,188.3,194.9],[3369.3,4050,3344.4,4045.5,3395.8,4034.8]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>island<\/th>\n      <th>species<\/th>\n      <th>sex<\/th>\n      <th>mean_bill_len<\/th>\n      <th>mean_flip_len<\/th>\n      <th>mean_body_mass<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"dom":"Bfrtip","buttons":["copy","csv","excel","print","pdf"],"columnDefs":[{"className":"dt-right","targets":[4,5,6]},{"orderable":false,"targets":0},{"name":" ","targets":0},{"name":"island","targets":1},{"name":"species","targets":2},{"name":"sex","targets":3},{"name":"mean_bill_len","targets":4},{"name":"mean_flip_len","targets":5},{"name":"mean_body_mass","targets":6}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>
