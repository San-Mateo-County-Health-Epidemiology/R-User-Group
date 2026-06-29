# formatting tables - `DT`
Beth Jump
2026-07-09

``` r
library(palmerpenguins)
library(tidyverse)
library(DT)

penguins <- palmerpenguins::penguins
```

## `DT`

The `DT` package creates interactive tables that the end user can
search, filter and sort. `DT` tables are a great option for Shiny
dashboards or other interactive formats.

`DT` tables don’t render in a GitHub-flavored markdown so I’ve just
displayed the code below. If you want to test the code, you can render
these examples on your local machine and you’ll be able to see the
tables.

``` r
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
