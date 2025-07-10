# Base R functions
Beth Jump
2025-07-10

``` r
library(tidyverse)
```

## Background

R was originally created for statisticians and there are some very handy
functions in base R and in the `stats` package (which is included with
the R installation).

## `sample()`

The `sample()` function allows you to select a sample from a list of
numbers. This is helpful both for randomly picking numbers from an array
and for generating a fake set of observations from a distribution.
Consider these two examples:

- We want to randomly select three unique numbers between 0-100:

``` r
set.seed(7)

sample(x = 0:100,
       size = 3)
```

    [1] 41 82 30

Note that we aren’t using the `replace` argument because by default
`replace = FALSE`. If we didn’t care about selecting the same number
twice, we could set `replace = TRUE`.

`set.seed()` ensures that each person running the code has the same
‘randomness’ and results that you have when you run it. More information
[here](https://www.statology.org/set-seed-in-r/).

- We want to generate some fake data from a set of numbers

``` r
dist <- sample(x = 0:5,
               size = 100000,
               replace = T,
               prob = c(10, 9, 5, rep(1, 3)))

dist %>%
  data.frame() %>%
  rename(var = 1) %>%
  ggplot() + 
  geom_bar(aes(x = var))
```

![](base-r_functions_files/figure-commonmark/unnamed-chunk-3-1.png)

## `rep()`

The `rep()` function repeats an element a given number of times. Let’s
say you want to make a variable and you need the value `"yellow"` listed
three times. Instead of typing: `c("yellow", "yellow", "yellow")` you
can use:

``` r
rep("yellow", 3)
```

    [1] "yellow" "yellow" "yellow"

You might not use this very often, but if you find yourself typing the
same thing over and over consider using `rep()` instead.

## `replicate()`

`rep()` simply repeats the same element or result over and over while
`replicate()` will actually re-run code a specified number of times. We
used `replicate()` when we [compared the size, read and save times of
different types of
files](https://github.com/San-Mateo-County-Health-Epidemiology/R-User-Group/blob/a40a9f5eec3c8f3b3ba4b83cb5d0cfb35124ab8e/quarto-markdowns/r-scripts/file-type-comparison.R).

Here’s a quick example to show how the two are different.

If you repeat (`rep()`) the same sample 5 times, the result is just the
result from the first `sample()` printed five times:

``` r
rep(sample(1:10, 2), 
    5)
```

     [1] 8 7 8 7 8 7 8 7 8 7

If you `replicate()` the same sample 5 times, you’ll get 5 unique
results because the code is actually run 5 times:

``` r
replicate(5, 
          sample(1:10, 2))
```

         [,1] [,2] [,3] [,4] [,5]
    [1,]    8    7    1    7   10
    [2,]    2    3    9    8    4

You can override the defaults and change the mean and standard deviation
of your normal distribution:

``` r
rnorm(10000, mean = 6, sd = 10) %>%
  data.frame() %>%
  rename(var = 1) %>%
  ggplot() + 
  geom_histogram(aes(x = var, y = ..density..))
```

![](base-r_functions_files/figure-commonmark/unnamed-chunk-7-1.png)

If your data need to have a certain shape, using `rnorm()` (or one of
the `_norm()` functions) is likely a better option than trying to play
around with the parameters of `sample()`.

### pnorm()

You can use `pnorm()` to get a p-value from a z-score, though you might
need to manipulate the results a bit. `pnorm()` gives you the area from
the left edge of the curve to the inputted z-score.

Here we are calculating the probability of seeing a z-score of -2 or
less than -2 on a normal distribution:

``` r
pnorm(-2)
```

    [1] 0.02275013

Here we are calculating the probability of seeing a z-score of 1 or less
than 1 on a normal distribution:

``` r
pnorm(1)
```

    [1] 0.8413447

If we wanted the probability of seeing a z-score of 1 or greater, we can
calculate it one of two ways:

``` r
1 - pnorm(1)
```

    [1] 0.1586553

``` r
pnorm(-1)
```

    [1] 0.1586553

A p-value is the probability of observing a given z-score or a more
extreme z-score if the observed value is on the normal distribution.

### qnorm()

`qnorm()` is the inverse of `pnorm()` as it will give you the z-score
for a given p-value. Here is the z-score we would need to see to get a
p-value of 0.025:

``` r
qnorm(0.025)
```

    [1] -1.959964

Note that like `pnorm()` this is just the left side. A z-score of -2
means that value is 2 standard units less than the mean and a z-score of
2 means the value is 2 standard units greater than the mean.

### dnorm()

`dnorm()` gives you the probability of observing your z-score exactly.
This isn’t super useful for a normal distribution as we typically don’t
care about the probability of our z-score - we typically just want to
know if our value is part of the observed distribution - but this is
useful in the binomial distribution where we might be interested in the
probability of the exact number of successes.

If we want to know the probability we’ll have a z-score of 0 on a normal
distribution, we can run this to find out the probability is ~40%.

``` r
dnorm(0)
```

    [1] 0.3989423

Just for fun, here’s how this would work on a binomial distribution.
Reminder that a binomial distribution is a distribution generated by two
outcomes. Think of the results of flipping a coin:

``` r
dbinom(4, 10,  0.5)
```

    [1] 0.2050781
