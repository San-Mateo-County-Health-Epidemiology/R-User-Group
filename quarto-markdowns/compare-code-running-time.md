# Comparing code running time
Beth Jump
2022-10-06

## Background

When you’re processing a lot of data at once, it’s important to try and
optimize the speed of your code. If there is a secion of your code that
can be written in different ways, you should compare the methods and,
when possible, use the one that runs the fasted. The first step to doing
this is knowing how long your code takes to run.

## Comparing single runs

Here we have some fake data that is just two dates:

``` r
library(rbenchmark)
library(tidyverse)

data <- data.frame(
  date1 = seq.Date(Sys.Date() - days(9999), Sys.Date(), 1),
  date2 = rep(Sys.Date(), 1000)
)

head(data, 10)
```

            date1      date2
    1  1998-11-29 2026-04-15
    2  1998-11-30 2026-04-15
    3  1998-12-01 2026-04-15
    4  1998-12-02 2026-04-15
    5  1998-12-03 2026-04-15
    6  1998-12-04 2026-04-15
    7  1998-12-05 2026-04-15
    8  1998-12-06 2026-04-15
    9  1998-12-07 2026-04-15
    10 1998-12-08 2026-04-15

We want to calculate the time between these two dates in the most
efficient way possible. We know three different ways to do this:

1.  `base::difftime()`
2.  `lubridate::interval()`
3.  simple math: date2 - date1

We want to know which is fastest! We can do this the long way by using
each method and comparing how long each one takes:

### `base::difftime()`

``` r
start <- Sys.time()
data1 <- data %>%
  mutate(date_diff = difftime(date2, date1, units = "days"))
end <- Sys.time()

difftime_time <- end-start
difftime_time
```

    Time difference of 0.01015401 secs

### `lubridate::interval())`

``` r
start <- Sys.time()
data1 <- data %>%
  mutate(date_diff = interval(date2, date1) %/% days(1))
end <- Sys.time()

interval_time <- end-start
interval_time
```

    Time difference of 0.035496 secs

### simple math

``` r
start <- Sys.time()
data1 <- data %>%
  mutate(date_diff = date2 - date1)
end <- Sys.time()

math_time <- end-start
math_time
```

    Time difference of 0.002799988 secs

``` r
data.frame(
  difftime_time, interval_time, math_time
)
```

        difftime_time interval_time        math_time
    1 0.01015401 secs 0.035496 secs 0.002799988 secs

## Comparing multiple runs

By comparing one run, we can see that the `lubridate::interval()` method
is ~2 times slower than the `base::difftime()` and simple math methods.
But, we don’t know if those results will hold true every time. It’s
better to compare hundreds or thousands of runs than to just compare
one.

We can use the `rbenchmark::benchmark()` function to compare multiple
runs!

``` r
benchmark("difftime" = {
  data1 <- data %>%
    mutate(date_diff = difftime(date2, date1, units = "days"))
},
"lubridate" = {
  data1 <- data %>%
    mutate(date_diff = interval(date2, date1) %/% days(1))
},
"math" = {
  data1 <- data %>%
    mutate(date_diff = date2 - date1)
},
replications = 1000,
columns = c("test", "replications", "elapsed",
            "relative", "user.self", "sys.self"))
```

           test replications elapsed relative user.self sys.self
    1  difftime         1000    1.12    1.000      0.97     0.16
    2 lubridate         1000   34.81   31.080     32.31     2.50
    3      math         1000    1.41    1.259      1.23     0.17

When we compare 1,000 runs, we confirm that `lubridate::interval()` is
the slowest, but we also see that `base::difftime()` is slightly faster
than simple math.
