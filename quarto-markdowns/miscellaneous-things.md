# Miscellaneous things
Beth Jump
2025-03-26

Here we’ll look at some miscellaneous R things including: using pipes,
looking for files and Git commands from the terminal

## 1. `%>%` vs `|>`

TL;DR: this is just an FYI in case you see the `|>` in someone’s code
and wonder about it!

There is a nice summary of the difference
[here](https://www.tidyverse.org/blog/2023/04/base-vs-magrittr-pipe/).
Essentially, `|>` is a pipe operator that is native to R while the `%>%`
comes from the `magrittr` package.

The two pipes operate really similary thought `%>%` seems to have more
advanced capabilities. I don’t plan to switch from the `%>%` to `|>`
except in cases where I don’t want to use any external packages (ex:
when writing an R package).

## 2. Looking for files and folders

On 2025-01-23, we looked at functions for file management. One of the
functions we looked at is `list.files()`. Details on how to use
`list.files()` are in the 2025-01-03 markdown, in the help text and on
stackoverflow.

We didn’t talk about this last time, but `list.files()` and `dir()` are
a great way to look for files or folders within a folder or set of
folders.

### Looking for folders

Ex: I couldn’t find the folder where I save COVID data. I knew it should
be in the Epi Data folder but the folder wasn’t there. I ran this code
to see where the folder had moved:

``` r
dir(path = "J:/Epi Data",
    pattern = "COVID",
    recursive = T)
```

Setting `recursive = T` means you will look in all sub-folders within
the `path` you specify. If `recursive = F`, you’ll only look in the top
folder.

### Looking for files

Ex: I was asked to look for all Stata `.do` files in a particular set of
folders. I ran this code to find all `.do` files in a given directory.

`.` means “every character except a new line” and `*` means zero or more
of those. So `.*` means there can be anything characters or no
characters. It’s a great way of adding uncertainty to your text
searches.

``` r
list.files(pattern = ".*.do",
           full.names = T,
           recursive = T)
```

Ex: I couldn’t remember where I saved the most recent estimates I
produced for life expectancy. I ran this code to find the newest files.
Here I also used the `file.info()` function.

``` r
excel_files <- file.info(list.files(path = "Data Requests/PHE",
                                    pattern = ".*.xlsx",
                                    recursive = T)) %>%
  data.frame()
```

## 3. Git commands in the terminal

More details
[here](https://github.com/San-Mateo-County-Health-Epidemiology/.github-private/blob/main/profile/git-commands-terminal.md)
