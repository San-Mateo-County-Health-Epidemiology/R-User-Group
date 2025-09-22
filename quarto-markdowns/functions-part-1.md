# Functions - part 1
Beth Jump
2022-05-19

## Background

A function is a bit of code that performs a specific task. Typically a
function allows for the user to specify inputs using arguments. Let’s
run through how functions work with `sample()` from base R. If you
aren’t familiar with `sample()` you can look at the help text by running
`?sample` in the console.

It is best practice to label your arguments when you use functions. If
you label your arguments, then you don’t need to worry about the order
of the inputs. If you don’t label them, you need to make sure your
inputs are in the correct order.

Let’s sample from this list.

``` r
list <- 1:10
list
```

The ideal way to use this function is by labeling the arguments and
listing the arguments in the correct order:

``` r
sample(x = list, 
       size = 2, 
       replace = F)
```

You can also run this function with unlabeled arguments in the correct
order …

``` r
sample(list, 
       2, 
       F)
```

… and can run this function with labeled arguments in the wrong order:

``` r
sample(replace = FALSE, 
       x = list, 
       size = 2)
```

However you cannot run this function with unlabeled arguments in the
wrong order:

``` r
sample(2, 
       list, 
       FALSE)
```

## Custom functions

### Overview

Sometimes you need to write your own function. The same rules about
labeling arguments and the order of inputs apply here in functions you
write.

Here is a function that multiplies the input by 2. It only takes one
argument so we can run it with a labeled or unlabeled argument.

``` r
times_2 <- function(x) {
  x*2
}

times_2(5)
times_2(x = 5)
```

When writing a function, make sure your inputs are in your function and
all of the variables in your function are defined. This function won’t
work:

``` r
times_4 <- function(x) {
  y*4
}

times_4(2)
```

For this to work, the input should be `y` or the function code should be
`x*4`.

### Function writing process

Let’s say we want to write a function that keeps the first `n` rows of a
data set when the data are sorted by a specified variable. Here’s how I
would approach this.

1.  Write the code I want to use as if it were in a script and not in a
    function.

``` r
library(tidyverse)

data <- palmerpenguins::penguins

data %>%
  arrange(bill_length_mm) %>%
  slice(1:5) %>%
  select(bill_length_mm, everything())
```

2.  Review my code and consider which inputs I want to be able to
    specify in my function. In this example, I probably want to specify:

    - the data frame (`df`)
    - the number of rows to keep (`n`)
    - the variable by which to sort (`sort_var`)

3.  Re-write the code from step 1 as a function.

``` r
top_rows <- function(df, n, sort_var) {
  new <- df %>%
    arrange(get(sort_var)) %>%
    slice(1:n) %>%
    select(sort_var, everything())
  return(new)
}
```

4.  Test the function by comparing the output from step 1 with the
    output from step 3:

``` r
# step 1 code:
data %>%
  arrange(bill_length_mm) %>%
  slice(1:5) %>%
  select(bill_length_mm, everything())

# step 3 code:
top_rows(df = data, n = 5, sort_var = "bill_length_mm")
```

## Discussion - when should you write a new function?

The experts say that if you are running the same code more than once, it
should be a function. I don’t think that’s super practical, so I usually
write functions when I need to do the same thing in multiple scripts and
want to keep the process in sync and have found that works well for me!
