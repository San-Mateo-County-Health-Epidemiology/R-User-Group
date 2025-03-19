# parameters_example
Hanley Kingston
2025-01-09

When run as a stand-along script, the parameters specified in the yaml
will be loaded as named elements in a list named params. When rendered
using the render() function in another script, updated params can be
passed as a named list to the params argument, and the above params will
be used as defaults.

## Save params as their own objects

``` r
person <- params$person
message <- params$message
exclamation <- params$exclamation
```

## Write string using parameter inputs

``` r
cat(paste0(person, ",\n", message, ifelse(exclamation == TRUE, "!", "."), "\n\n"))
```

    Simba,
    Hello!

     Mowgli,
    Hello!

     Mufasa,
    Hello!

## Rendering using a separate script

This markdown can also be rendered through a separate script using:

``` r
rmarkdown::render(
  "parameters_example.qmd",
  output_file = "<output_file>.md",
  params = list(
    person = "<person(s)>",
    message = "<message(s)>",
    exclamation = "<T/F>"),
  envir = new.env())
```

For any parameter not specified, the value in the .qmd yaml will be used
as a default.

For an example of rending this markdown with different inputs passed
through a for-loop, see: r-scripts//render_parameters_example.R

## Other notes

- Do not use rm(list = ls()). This will erase the parameters passed in
  the yaml

- params accepts strings and booleans. To pass other types of R objects
  to params, use !expr for quarto and !r for R Markdown. For example…

  - list_param: !expr list(“thing2”, “thing1”, 48)

  - vector_param: !r c(1,3,4)
