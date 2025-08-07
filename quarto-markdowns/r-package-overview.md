# R package basics
Beth Jump
2025-08-07

## Overview

“In R, the fundamental unit of shareable code is the package. A package
bundles together code, data, documentation, and tests, and is easy to
share with others.” [R Packages
(2e)](https://r-pkgs.org/introduction.html).

While we typically access packages published by other people on the
CRAN, we can also write our own packages and host them on GitHub
(relatively easy) or the CRAN (takes a lot more testing and validation).
The book [R Packages (2e)](https://r-pkgs.org/introduction.html) goes
through all of the technical details on how to make an R package, so
here we’ll go over some basics and some things I’ve learned about making
packages.

### Functions vs sourcing scripts

There are two main ways to ensure code is being processed uniformly in a
series of scripts:

1.  functions
2.  sourcing scripts

Functions are great for small, discrete tasks like getting the newest
file in a folder, reading in a certain type of file, or formatting a
chart in a specific way. Sourced scripts are best for long processes
that need to be done the same way every time.

In most cases you can use either a function or a sourced script. Some
limitations for functions:

- Functions can only return one object. You can get around this by
  making a function return a list of object, but generally if you need
  more than object returned, you might want to consider a sourced
  script.
- Functions tend to be a bit trickier to troubleshoot because you have
  named inputs that you need to address before running the code. In a
  sourced script you’re explicilty running code so you can easily change
  lines without worrying about renaming ojects or inputs.

If you’re accessing data from Azure with a sourced script, consider
using a SQL view instead! A view is a stored SQL query. When you call
the SQL view it runs the code and gives you the output as a 2x2 table.
The one drawback is that unlike a sourced script in R, a view will only
return one 2x2 object.

### Packages vs local functions

Once you’ve decided you definitely are going to use a function instead
of a sourced script, you then need to think about whether or not it
makes sense to create an R package to publish your function. Writing,
publishing and maintaining an R package takes quite a bit of work and
when you make updates to your functions, you need to re-test and
re-document your work which can take time.

My rule of thumb is to put generalizable, discrete functions (formatting
a chart, connecting to Azure, etc) into R packages but to keep large
functions used to process specific data sets (ex: my function to clean
and format VRBIS) as “local” R functions that are saved as R scripts in
projects on GitHub. I do this because I don’t want to go through the
whole process of updating and re-publishing my VRBIS function every time
a column is added to that data set.

## Package basics

Before you write your own package, I highly suggest you go through [this
exercise](https://r-pkgs.org/whole-game.html) and create a “toy”
package.

#### Naming functions

Each function you write should have one purpose and the name should
clearly reflect that purpose without being too long. Like object names,
your function names should also follow the [tidyverse style guide for
object names](https://style.tidyverse.org/syntax.html).

- Good names: `fetch_vrbis()`, `clean_vrbis()`
- Less good names: `fetchVrbis()`, `clean.Vrbis()`

#### Referencing other packages in your functions

If your function references any functions that aren’t included in base
R, you need to do a few things:

1.  In the actual function, you need to use the `package::function`
    notation to clearly tell R where to find the referenced function.
    Ex: `dplyr::filter()` instead of just `filter()`.
2.  You also need to import or suggest any external packages in your
    `DESCRIPTION` file. It’s not always clear whether to import or
    suggest a package, but [this
    page](https://r-pkgs.org/dependencies-mindset-background.html#sec-dependencies-imports-vs-suggests)
    gives some guidelines.
3.  If there is an external function that you’re using a lot in your
    package and you don’t want to have to reference its package every
    time you use it, you can add that function to the `NAMESPACE` file.
    If you’re using any tidyverse syntax, you will need to do this to
    use the pipe `%>%`.

In addition to referencing functions from other packages, you can also
write functions that reference other functions in your package. I did
this with the [life expectancy
functions](https://github.com/San-Mateo-County-Health-Epidemiology/smcepi/blob/main/R/life-expectancy.R).
The `life_table()` function only exists to be referenced by the
`make_life_table()` function. When you use the `smcepi` package, the
`life_table()` function isn’t available for use as it doesn’t have the
`@export` tag in the documentation.

### Writing functions

When writing a function for a package, you really want to think about
how the code will be used an do your best to make your function as
user-friendly as possible. Let’s go through an example with a function I
wrote to get the newest file in a folder.

Originally, I had a chunk of code that I would copy from script to
script:

    file <- file.info(list.files(path = "",
                                 pattern = "*.csv",
                                 full.names = T)) %>%
      data.frame() %>%
      rownames_to_column("file") %>%
      arrange(ctime) %>%
      slice(1) %>%
      pull(file)

This generally worked well, but eventually I got sick of copying and
re-writing this code every time I needed the newest file in a folder.
When I decided to make it a function, I changed two things: I rewrote
the function in base R and I added some options for the user to decide
how they wanted to select their file.

#### tidyverse to base R

To rewrite this function to be used in a package, I would have needed to
reference the packages for each function. ex:

    file <- file.info(list.files(path = "",
                                 pattern = "*.csv",
                                 full.names = T)) %>%
      data.frame() %>%
      tibble::rownames_to_column("file") %>%
      dplyr::arrange(ctime) %>%
      dplyr::slice(1) %>%
      dplyr::pull(file)

This is a small function, so adding package references wouldn’t be that
hard. But if any of the referenced packages change how their function
works, those changes would also affect my function. I didn’t want to
worry about that, so I rewrote this in base R:

    get_file_path <- function(directory = getwd(), pattern = NULL, sort_method = "created date", sort_type = "newest", include_directories = FALSE) {
      files <- list.files(path = directory,
                          pattern = pattern,
                          full.names = T)
      files <- file.info(files)
      
      files["sort_col"] <- files[[sort_method]]
      rownames(files[order(files$sort_col, decreasing = sort_type),][1,])
    }

Writing the function in base R means I don’t need to add any packages as
dependencies in my package and, as base R functions are generally very
stable, I don’t need to worry about changes that might affect my
function.

#### adding user options

When I just used the code to select files, I could change how the files
were sorted, decide to get full file paths and whether or not to include
directories in my results. I wanted to include those options in my
function so I added some arguments:

`get_file_path <- function(directory = getwd(), pattern = NULL, sort_method = "created date", sort_type = "newest", include_directories = FALSE)`

You can set function defaults by setting arguments equal to values. By
default this function looks in the working directory for the newest
created file and won’t include directories in the output.

Because I added user inputs, I also needed to add some checks in my
function to ensure these inputs were handled correctly.

`rlang::arg_match()`: this compares the input for `sort_method` to the
list specified to make sure the input is in that list.

`switch()` recodes the input to a different value. This is a stylistic
choice. If I had made the inputs `"ctime"`, `"mtime"` and `"atime"`, I
wouldn’t have needed the `switch()`.

    # ensure a valid sort method was inputted ---------------------
    sort_method <- rlang::arg_match(sort_method, c("created date","modified date", "accessed date"))

    switch(sort_method,
           `created date` = {sort_method = "ctime"},
           `modified date` = {sort_method = "mtime"},
           `accessed date` = {sort_method = "atime"})

### Documentation

Documentation is the most important part of your function. If people
don’t know how to use your function, they won’t use it. R makes it
pretty easy to write documentation for a function. Put your cursor in
your function, then go up to the top toolbar and select **Code \> Insert
Roxygen Skeleton**. That will give you the outline to write your
documentation.

I don’t love the default the roxygen skeleton. It doesn’t have some
inputs included like `description`. I typically use an outline that I
took partially from the `tidyr::separate` documentation on github.
Here’s the documentation I wrote for `get_file_path()`:

    #' Get file path for a file stored in a folder with multiple versions of a file
    #'
    #' @description
    #' If you have multiple versions of the same data set stored in a folder, this will pull the newest or oldest file path. You can enter a path and/or a pattern to look for.
    #'
    #' @usage get_file_path(directory = getwd(),
    #'              pattern = NULL,
    #'              sort_method = "created date",
    #'              sort_type = "newest",
    #'              include_directories = FALSE)
    #'
    #' @param directory a string specifying the directory in which you want to look. It defaults to the working directory
    #' @param pattern a string and/or regular expression specifying which files you're interested in
    #' @param sort_method
    #'   * `"created date"` (the default): sort by the date the file was created
    #'  * `"modified date"`: sort by the date the file was last modified
    #'  * `"accessed date"`: sort by the date the file was last accessed
    #' @param sort_type
    #'   * `"newest"` (the default): get the newest file based on sort method
    #'  * `"oldest"`: get the oldest file based on sort method
    #' @param include_directories boolean to indicate whether or not directories should be included in your results
    #'
    #' @return the file path as a string
    #' @export
    #'
    #' @examples
    #' \dontrun{
    #'
    #' # get the file that was most recently accessed in a directory
    #' get_file_path(sort_method = "accessed date", sort_type = "newest")
    #'
    #' # get the first file that was created in a different directory
    #' get_file_path(directory = "data", sort_type = "newest")
    #'
    #' # get the most recently modified parquet file in a directory
    #' get_file_path(directory = "data", pattern = "*.parquet",
    #'               sort_method = "modified date", sort_type = "newest")
    #'
    #'}

Enclosing code in brackets precented by `\dontrun` allows you to include
example code without running the code. By default example code is run
when the package is rendered.

### Testing your functions

When building a function, you should also include at least one test per
function. The
[`testthat`](https://testthat.r-lib.org/reference/index.html) package
has lots of functions to help with this. When building tests you should
consider validating:

- that your error messages work as expected
- that your function outputs an object of the class and dimensions
  expected

Try to strike a balance between writing comprehensive tests and not
spending days testing every little thing that might go wrong. Here are
some example tests I wrote for `get_file_path()`.

    ## make sure the output is a string ----
    test_that("output is a string", {

      path <- get_file_path(sort_method = "accessed date", sort_type = "newest")
      expect_true(is.character(path))

    })

    ## check the input validation ----
    test_that("input validation - sort_method", {

      expect_true(is.character(get_file_path(sort_method = "created date")))
      expect_true(is.character(get_file_path(sort_method = "accessed date")))
      expect_true(is.character(get_file_path(sort_method = "modified date")))
      expect_error(get_file_path(sort_method = "ctime"))

    })

The fill list of tests is
[here](https://github.com/San-Mateo-County-Health-Epidemiology/smcepi/blob/main/tests/testthat/test_file-management.R).
