# formatting tables - `kableExtra`
Beth Jump
2026-06-25

<script src="table-formatting-kableextra_files/libs/kePrint-0.0.1/kePrint.js"></script>
<link href="table-formatting-kableextra_files/libs/lightable-0.0.1/lightable.css" rel="stylesheet" />

See
[here](https://github.com/San-Mateo-County-Health-Epidemiology/R-User-Group/blob/main/quarto-markdowns/table-formatting-comparison.md)
for information about other packages for formatting tables.

``` r
library(palmerpenguins)
library(tidyverse)
library(kableExtra)
library(here)

penguins <- palmerpenguins::penguins
```

## `kable and kableExtra`

`kable` and `kableExtra` are a great option for making HTML tables. This
[guide](https://cran.r-project.org/web/packages/kableExtra/vignettes/awesome_table_in_html.html)
includes tons of examples of customization for `kableExtra` tables!

### Clean data and create kable table

``` r
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
k1 <- penguins_kable %>%
  kable_paper(html_font = "Cambria", font_size = 16) %>%
  row_spec(1:3, bold = TRUE, font_size = 10) %>%
  column_spec(4:6, italic = TRUE)
```

![](table-formatting-images/kableextra1.png)

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
