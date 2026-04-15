# Comparing code running time
Beth Jump
2022-10-06

## Background

When you’re processing a lot of data at once it’s important to try to
optimize the speed of your code. If there is a section of your code that
can be written in different ways, you should compare the methods and,
when possible, use the option that runs the fastest.

## Comparing single runs

Here we have some fake data that contains 10,000 rows of two dates:

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

We want to calculate the number of days between these two dates in the
most efficient way possible. We know three different ways to do this:

1.  `base::difftime()`
2.  `lubridate::interval()`
3.  simple math: date2 - date1

We want to know which method is fastest. We can do this by timing each
method and comparing how long each one takes:

### `base::difftime()`

``` r
start <- Sys.time()
data1 <- data %>%
  mutate(date_diff = difftime(date2, date1, units = "days"))
end <- Sys.time()

difftime_time <- end-start
difftime_time
```

    Time difference of 0.008365154 secs

### `lubridate::interval())`

``` r
start <- Sys.time()
data1 <- data %>%
  mutate(date_diff = interval(date2, date1) %/% days(1))
end <- Sys.time()

interval_time <- end-start
interval_time
```

    Time difference of 0.03482413 secs

### simple math

``` r
start <- Sys.time()
data1 <- data %>%
  mutate(date_diff = date2 - date1)
end <- Sys.time()

math_time <- end-start
math_time
```

    Time difference of 0.002719879 secs

Looking at all of the times together, we see that
`lubridate::interval()` is the slowest, followed by `base::difftime()`
and basic math:

         difftime_time   interval_time        math_time
    1 0.008365154 secs 0.03482413 secs 0.002719879 secs

But can we be confident in that? Probably not. We need to compare more
than one run to figure out which method is quickest.

## Comparing multiple runs

It’s always better to compare hundreds or thousands of runs than just
compare one. We can use the `rbenchmark::benchmark()` function to
compare multiple runs at once!

*Note: there are other packages that also do this, I am most familiar
with this one.*

Here we are comparing each method across 1,000 runs.

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
    1  difftime         1000    1.25    1.000      1.17     0.08
    2 lubridate         1000   32.91   26.328     30.44     2.46
    3      math         1000    1.32    1.056      1.09     0.22

When we compare 1,000 runs, we confirm that `lubridate::interval()` is
the slowest, but we also see that `base::difftime()` is slightly faster
than simple math.
