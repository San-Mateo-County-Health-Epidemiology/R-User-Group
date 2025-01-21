# File management
Beth Jump
2022-05-05

# Overview

While not central to our work as epidemiologists, knowing some basic
file management in R can save you time and allow you to do some pretty
cool things.

We’ll go over some basic functions that hopefully make working with
files from R a bit easier for you!

# Finding files

## `file.choose()`

Before you do anything in R, you need to import data into R and this
often involves using a file path. You can either type out the path or
you can use the `file.choose()` function. Run the code in your console
and a File Explorer window will open. Navigate to the file you want to
import into R, select **Open** and the path of the file will appear in
the console!

*Note: if you do manually type a path, you should either use a double
back slash `\\` or a single forward slash `/`. A single back slash in R
is an “escape character” and R will get cranky if you try to use one in
a file path. More about escape characters
[here](https://www.w3schools.com/r/r_strings_esc.asp). *

`here` package

# Creating, moving + deleting files

# Working with directories

get current directory

Move one directory up

Move on directory down
