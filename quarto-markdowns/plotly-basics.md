# plotly basics
Beth Jump
2022-07-14

## Overview

While `ggplot2` is wonderful for static charts, `plotly` is amazing for
interactive graphs. Unfortunately, you can’t display rendered charts
when knitting gfm markdowns hosted on GitHub (as this one is) but if you
want to see how plotly works, you can run this code in your own R
session. When you run it yourself, take some time to play around with
the rendered! You can hover over data to see values, zoom in and out and
even toggle values on and off.

This is just an overview of how to use plotly. When you want to create
future plotly charts, you should use the [plotly
website](https://plotly.com/r/) for examples. It’s really well done and
has lots of code to copy!

*Note: when you look for plotly help online, be sure to include “R” in
your search (ex: “R plotly how to add title”) as there is also a plotly
package for python. *

## Usage

We’re going to walk through how to make a basic scatterplot.

``` r
library(tidyverse)
library(lubridate)
library(plotly)
library(palmerpenguins)

str(penguins)
```

The way you build a `plotly` chart is quite similar to how you build a
`ggplot` chart. You start with the `plot_ly()` function to tell R you’re
building a `plotly` chart. Then you use `add_trace()` to add layers
(lines, bars, etc) to the chart. Within `add_trace()` you can map
variables to `x`, `y`, `color` and other arguments. When you map a
variable to an argument, it should be prefixed with a `~`. For example:
`x = ~date, y = ~count`.

Here’s code to make a basic scatter plot of `bill_length_mm` and
`flipper_length_mm` colored by `species`:

``` r
penguins %>%
  plot_ly() %>%
  add_trace(x = ~bill_length_mm, 
            y = ~flipper_length_mm,
            type = "scatter",
            mode = "markers",
            color = ~species)
```

Note that you can pass the `add_trace()` information to the `plot_ly()`
function, but if you might add additional layers (traces) to your chart,
it’s probably better to just use `add_trace()`. Here’s how you could
make the same chart as above using `plot_ly()` instead of `add_trace()`:

``` r
penguins %>%
  plot_ly(x = ~bill_length_mm, 
          y = ~flipper_length_mm,
          type = "scatter",
          mode = "markers",
          color = ~species)
```

If you don’t love the default colors, you can change them manually:

``` r
penguins %>%
  plot_ly() %>%
  add_trace(x = ~bill_length_mm, 
            y = ~flipper_length_mm,
            type = "scatter",
            mode = "markers",
            color = ~species,
            colors = c("green", "orange", "blue"))
```

You can add labels to your chart using `layout()`. You can specify the
text, font size, font family, color, etc. within the `title`, `xaxis`
and `yaxis` arguments. Below we’ve specified the font size for the
`xaxis`:

``` r
penguins %>%
  plot_ly() %>%
  add_trace(x = ~bill_length_mm, 
            y = ~flipper_length_mm,
            type = "scatter",
            mode = "markers",
            color = ~species,
            colors = c("green", "orange", "blue")) %>%
  layout(title = "Flipper and bill length of Palmer Penguins", 
         xaxis = list(title = list(text = "Bill Length (mm)", font = list(size = 14))),
         yaxis = list(title = "Flipper Length (mm)"))
```
