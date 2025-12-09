# File management
Beth Jump
2025-01-23

# Overview

While not central to our work as epidemiologists, knowing some basic
file management in R can save you time and allow you to do some pretty
cool things.

We’ll go over some basic functions that hopefully make working with
files from R a bit easier!

# Finding files

## `file.choose()`

Before you do anything in R, you need to import data into R and this
often involves using a file path. You can either type out the path or
you can use the `file.choose()` function. Run the `file.choose()` in
your console and a File Explorer window will open. Navigate to the file
you want to import into R, select **Open** and the path of the file will
appear in the console!

*Note: if you do manually type a path, you should either use a double
back slash `\\` or a single forward slash `/`. A single back slash in R
is an “escape character” and R will get cranky if you try to use one in
a file path. More about escape characters
[here](https://www.w3schools.com/r/r_strings_esc.asp).*

## `here` package

If you don’t want to use a full file path or you don’t have an exact
file path, you can use the `here` function from the
[`here`](https://here.r-lib.org/) package.

This is really useful if you have an R project and want to read data in
from a `data/` directory into a quarto or R markdown that is stored
somewhere else. If you use a full file path, the data needs to be stored
in the same directory or a sub-directory of where your markdown file
lives. With `here::here()` the data can live anywhere in the project!!

# Manipulating files and directories

Let’s start with some basic terminology:

**file**: single file with an extension, ie: .pdf, .docx, .Rmd, .qmd,
etc  
**directory**: also known as a folder. Contains files or can be empty

We’ll go through these in detail, but here is an index of the functions
covered in this file. All of these are base R functions.

| Function        | Purpose                                             |
|-----------------|-----------------------------------------------------|
| `list.files()`  | lists all the files in a directory                  |
| `list.dirs()`   | lists all the directories in a directory            |
| `file.info()`   | gives you information about a file or set of files  |
| `getwd()`       | returns your current working directory              |
| `setwd()`       | allows you to specify a different working directory |
| `dir.create()`  | creates a directory                                 |
| `unlink()`      | deletes a directory                                 |
| `file.copy()`   | copies a file from one place to another             |
| `file.remove()` | deletes a file                                      |

## Viewing files and directories

This will tell you what files are in your current directory

``` r
list.files()
```

     [1] "api-basics.md"                                                         
     [2] "api-basics.qmd"                                                        
     [3] "base-r_functions.md"                                                   
     [4] "base-r_functions.qmd"                                                  
     [5] "base-r_functions_files"                                                
     [6] "base-r_vs_tidyverse.md"                                                
     [7] "base-r_vs_tidyverse.qmd"                                               
     [8] "climate-related-apis.md"                                               
     [9] "climate-related-apis.qmd"                                              
    [10] "conf_int.md"                                                           
    [11] "conf_int.qmd"                                                          
    [12] "data"                                                                  
    [13] "dataset_summary_tables.md"                                             
    [14] "dataset_summary_tables.qmd"                                            
    [15] "dataset_summary_tables_files"                                          
    [16] "date-basics.md"                                                        
    [17] "date-basics.qmd"                                                       
    [18] "dynamic-selecting.md"                                                  
    [19] "dynamic-selecting.qmd"                                                 
    [20] "file-management.qmd"                                                   
    [21] "file-management.rmarkdown"                                             
    [22] "file-type-comparison.md"                                               
    [23] "file-type-comparison.qmd"                                              
    [24] "file-type-comparison_files"                                            
    [25] "functions-part-1.md"                                                   
    [26] "functions-part-1.qmd"                                                  
    [27] "functions-part-2.md"                                                   
    [28] "functions-part-2.qmd"                                                  
    [29] "future-meetings"                                                       
    [30] "ggplot2_gog-and-labelling-plots.md"                                    
    [31] "ggplot2_gog-and-labelling-plots.qmd"                                   
    [32] "ggplot2_gog-and-labelling-plots_files"                                 
    [33] "healthy_places_index_api_function.md"                                  
    [34] "healthy_places_index_api_function.qmd"                                 
    [35] "identifying-and-consolidating-overlapping-date-ranges-longitudinal.md" 
    [36] "identifying-and-consolidating-overlapping-date-ranges-longitudinal.qmd"
    [37] "images"                                                                
    [38] "intro-to-quarto.md"                                                    
    [39] "intro-to-quarto.qmd"                                                   
    [40] "looking-at-data.md"                                                    
    [41] "looking-at-data.qmd"                                                   
    [42] "miscellaneous-things.md"                                               
    [43] "miscellaneous-things.qmd"                                              
    [44] "mutate-across.md"                                                      
    [45] "mutate-across.qmd"                                                     
    [46] "parameters_example.md"                                                 
    [47] "parameters_example.qmd"                                                
    [48] "plotly-basics.md"                                                      
    [49] "plotly-basics.qmd"                                                     
    [50] "probabilistic-matching.md"                                             
    [51] "probabilistic-matching.qmd"                                            
    [52] "r-package-overview.md"                                                 
    [53] "r-package-overview.qmd"                                                
    [54] "r-scripts"                                                             
    [55] "saving-data-for-downstream-analyses.md"                                
    [56] "saving-data-for-downstream-analyses.qmd"                               
    [57] "separate-strings-into-parts.md"                                        
    [58] "separate-strings-into-parts.qmd"                                       
    [59] "separate-wider-and-longer.md"                                          
    [60] "separate-wider-and-longer.qmd"                                         
    [61] "stats-distribution-functions.md"                                       
    [62] "stats-distribution-functions.qmd"                                      
    [63] "stats-distribution-functions_files"                                    
    [64] "strings_regular-expressions.md"                                        
    [65] "strings_regular-expressions.qmd"                                       
    [66] "tidy-data.md"                                                          
    [67] "tidy-data.qmd"                                                         
    [68] "tidy-eval.md"                                                          
    [69] "tidy-eval.qmd"                                                         
    [70] "tidyr-unite.md"                                                        
    [71] "tidyr-unite.qmd"                                                       
    [72] "tidyverse-practice.md"                                                 
    [73] "updating-r-and-rstudio.md"                                             
    [74] "updating-r-and-rstudio.qmd"                                            

You can add arguments to make your search more specific. Here we are
looking for any .qmd (Quarto) files in any directory or sub directory of
the current directory

- `pattern = "*.qmd"` specifies that we’re interested in any `.qmd`
  file  
- `recursive = T` specifies that we want to look in the current
  directory and in any sub-directories. `recursive = F` is the default.
  It only looks in the current directory  
- `full.names = T` returns full file paths for the files

``` r
list.files(pattern = "*.qmd",
           recursive = T,
           full.names = T)
```

     [1] "./api-basics.qmd"                                                        
     [2] "./base-r_functions.qmd"                                                  
     [3] "./base-r_vs_tidyverse.qmd"                                               
     [4] "./climate-related-apis.qmd"                                              
     [5] "./conf_int.qmd"                                                          
     [6] "./dataset_summary_tables.qmd"                                            
     [7] "./date-basics.qmd"                                                       
     [8] "./dynamic-selecting.qmd"                                                 
     [9] "./file-management.qmd"                                                   
    [10] "./file-type-comparison.qmd"                                              
    [11] "./functions-part-1.qmd"                                                  
    [12] "./functions-part-2.qmd"                                                  
    [13] "./future-meetings/getting-data-into-R.qmd"                               
    [14] "./ggplot2_gog-and-labelling-plots.qmd"                                   
    [15] "./healthy_places_index_api_function.qmd"                                 
    [16] "./identifying-and-consolidating-overlapping-date-ranges-longitudinal.qmd"
    [17] "./intro-to-quarto.qmd"                                                   
    [18] "./looking-at-data.qmd"                                                   
    [19] "./miscellaneous-things.qmd"                                              
    [20] "./mutate-across.qmd"                                                     
    [21] "./parameters_example.qmd"                                                
    [22] "./plotly-basics.qmd"                                                     
    [23] "./probabilistic-matching.qmd"                                            
    [24] "./r-package-overview.qmd"                                                
    [25] "./saving-data-for-downstream-analyses.qmd"                               
    [26] "./separate-strings-into-parts.qmd"                                       
    [27] "./separate-wider-and-longer.qmd"                                         
    [28] "./stats-distribution-functions.qmd"                                      
    [29] "./strings_regular-expressions.qmd"                                       
    [30] "./tidy-data.qmd"                                                         
    [31] "./tidy-eval.qmd"                                                         
    [32] "./tidyr-unite.qmd"                                                       
    [33] "./updating-r-and-rstudio.qmd"                                            

Sometimes it’s enough to just know what files are in your directory, but
often you need more information. You can wrap your `list.files()` call
with `file.info()`. This gives you additional information about each
file including: size, create, modified and accessed time and an
indicator for whether or not the file is a file or a directory.

``` r
file.info(list.files(pattern = "*.qmd",
           recursive = T,
           full.names = T))
```

                                                                              size
    ./api-basics.qmd                                                          8655
    ./base-r_functions.qmd                                                    2683
    ./base-r_vs_tidyverse.qmd                                                 5520
    ./climate-related-apis.qmd                                                5938
    ./conf_int.qmd                                                            1565
    ./dataset_summary_tables.qmd                                              6946
    ./date-basics.qmd                                                         4818
    ./dynamic-selecting.qmd                                                   4164
    ./file-management.qmd                                                     7981
    ./file-type-comparison.qmd                                                9609
    ./functions-part-1.qmd                                                    3703
    ./functions-part-2.qmd                                                    4040
    ./future-meetings/getting-data-into-R.qmd                                 3343
    ./ggplot2_gog-and-labelling-plots.qmd                                     3705
    ./healthy_places_index_api_function.qmd                                  10833
    ./identifying-and-consolidating-overlapping-date-ranges-longitudinal.qmd  3631
    ./intro-to-quarto.qmd                                                     3210
    ./looking-at-data.qmd                                                     4665
    ./miscellaneous-things.qmd                                                2758
    ./mutate-across.qmd                                                       2531
    ./parameters_example.qmd                                                  4212
    ./plotly-basics.qmd                                                       3484
    ./probabilistic-matching.qmd                                             11782
    ./r-package-overview.qmd                                                 12687
    ./saving-data-for-downstream-analyses.qmd                                 5810
    ./separate-strings-into-parts.qmd                                         5000
    ./separate-wider-and-longer.qmd                                           5063
    ./stats-distribution-functions.qmd                                        6771
    ./strings_regular-expressions.qmd                                         2225
    ./tidy-data.qmd                                                           5969
    ./tidy-eval.qmd                                                           4804
    ./tidyr-unite.qmd                                                         2472
    ./updating-r-and-rstudio.qmd                                              3143
                                                                             isdir
    ./api-basics.qmd                                                         FALSE
    ./base-r_functions.qmd                                                   FALSE
    ./base-r_vs_tidyverse.qmd                                                FALSE
    ./climate-related-apis.qmd                                               FALSE
    ./conf_int.qmd                                                           FALSE
    ./dataset_summary_tables.qmd                                             FALSE
    ./date-basics.qmd                                                        FALSE
    ./dynamic-selecting.qmd                                                  FALSE
    ./file-management.qmd                                                    FALSE
    ./file-type-comparison.qmd                                               FALSE
    ./functions-part-1.qmd                                                   FALSE
    ./functions-part-2.qmd                                                   FALSE
    ./future-meetings/getting-data-into-R.qmd                                FALSE
    ./ggplot2_gog-and-labelling-plots.qmd                                    FALSE
    ./healthy_places_index_api_function.qmd                                  FALSE
    ./identifying-and-consolidating-overlapping-date-ranges-longitudinal.qmd FALSE
    ./intro-to-quarto.qmd                                                    FALSE
    ./looking-at-data.qmd                                                    FALSE
    ./miscellaneous-things.qmd                                               FALSE
    ./mutate-across.qmd                                                      FALSE
    ./parameters_example.qmd                                                 FALSE
    ./plotly-basics.qmd                                                      FALSE
    ./probabilistic-matching.qmd                                             FALSE
    ./r-package-overview.qmd                                                 FALSE
    ./saving-data-for-downstream-analyses.qmd                                FALSE
    ./separate-strings-into-parts.qmd                                        FALSE
    ./separate-wider-and-longer.qmd                                          FALSE
    ./stats-distribution-functions.qmd                                       FALSE
    ./strings_regular-expressions.qmd                                        FALSE
    ./tidy-data.qmd                                                          FALSE
    ./tidy-eval.qmd                                                          FALSE
    ./tidyr-unite.qmd                                                        FALSE
    ./updating-r-and-rstudio.qmd                                             FALSE
                                                                             mode
    ./api-basics.qmd                                                          666
    ./base-r_functions.qmd                                                    666
    ./base-r_vs_tidyverse.qmd                                                 666
    ./climate-related-apis.qmd                                                666
    ./conf_int.qmd                                                            666
    ./dataset_summary_tables.qmd                                              666
    ./date-basics.qmd                                                         666
    ./dynamic-selecting.qmd                                                   666
    ./file-management.qmd                                                     666
    ./file-type-comparison.qmd                                                666
    ./functions-part-1.qmd                                                    666
    ./functions-part-2.qmd                                                    666
    ./future-meetings/getting-data-into-R.qmd                                 666
    ./ggplot2_gog-and-labelling-plots.qmd                                     666
    ./healthy_places_index_api_function.qmd                                   666
    ./identifying-and-consolidating-overlapping-date-ranges-longitudinal.qmd  666
    ./intro-to-quarto.qmd                                                     666
    ./looking-at-data.qmd                                                     666
    ./miscellaneous-things.qmd                                                666
    ./mutate-across.qmd                                                       666
    ./parameters_example.qmd                                                  666
    ./plotly-basics.qmd                                                       666
    ./probabilistic-matching.qmd                                              666
    ./r-package-overview.qmd                                                  666
    ./saving-data-for-downstream-analyses.qmd                                 666
    ./separate-strings-into-parts.qmd                                         666
    ./separate-wider-and-longer.qmd                                           666
    ./stats-distribution-functions.qmd                                        666
    ./strings_regular-expressions.qmd                                         666
    ./tidy-data.qmd                                                           666
    ./tidy-eval.qmd                                                           666
    ./tidyr-unite.qmd                                                         666
    ./updating-r-and-rstudio.qmd                                              666
                                                                                           mtime
    ./api-basics.qmd                                                         2025-12-08 13:31:03
    ./base-r_functions.qmd                                                   2025-12-08 13:31:03
    ./base-r_vs_tidyverse.qmd                                                2025-12-08 13:31:03
    ./climate-related-apis.qmd                                               2025-12-08 13:31:03
    ./conf_int.qmd                                                           2025-12-08 13:31:03
    ./dataset_summary_tables.qmd                                             2025-12-08 13:31:03
    ./date-basics.qmd                                                        2025-12-08 13:31:03
    ./dynamic-selecting.qmd                                                  2025-12-08 13:31:03
    ./file-management.qmd                                                    2025-12-09 08:44:41
    ./file-type-comparison.qmd                                               2025-12-08 13:31:03
    ./functions-part-1.qmd                                                   2025-12-08 13:31:03
    ./functions-part-2.qmd                                                   2025-12-08 13:31:03
    ./future-meetings/getting-data-into-R.qmd                                2025-12-08 13:31:03
    ./ggplot2_gog-and-labelling-plots.qmd                                    2025-12-08 13:31:03
    ./healthy_places_index_api_function.qmd                                  2025-12-08 13:31:04
    ./identifying-and-consolidating-overlapping-date-ranges-longitudinal.qmd 2025-12-08 13:31:04
    ./intro-to-quarto.qmd                                                    2025-12-08 13:31:04
    ./looking-at-data.qmd                                                    2025-12-08 13:31:04
    ./miscellaneous-things.qmd                                               2025-12-08 13:31:04
    ./mutate-across.qmd                                                      2025-12-08 13:31:04
    ./parameters_example.qmd                                                 2025-12-08 13:31:04
    ./plotly-basics.qmd                                                      2025-12-08 13:31:04
    ./probabilistic-matching.qmd                                             2025-12-08 13:31:04
    ./r-package-overview.qmd                                                 2025-12-08 13:31:04
    ./saving-data-for-downstream-analyses.qmd                                2025-12-08 13:31:04
    ./separate-strings-into-parts.qmd                                        2025-12-08 13:31:04
    ./separate-wider-and-longer.qmd                                          2025-12-08 13:31:04
    ./stats-distribution-functions.qmd                                       2025-12-08 13:31:04
    ./strings_regular-expressions.qmd                                        2025-12-08 13:31:04
    ./tidy-data.qmd                                                          2025-12-08 13:31:04
    ./tidy-eval.qmd                                                          2025-12-08 13:31:04
    ./tidyr-unite.qmd                                                        2025-12-08 13:31:04
    ./updating-r-and-rstudio.qmd                                             2025-12-08 13:31:04
                                                                                           ctime
    ./api-basics.qmd                                                         2025-12-08 13:31:03
    ./base-r_functions.qmd                                                   2025-12-08 13:31:03
    ./base-r_vs_tidyverse.qmd                                                2025-12-08 13:31:03
    ./climate-related-apis.qmd                                               2025-12-08 13:31:03
    ./conf_int.qmd                                                           2025-12-08 13:31:03
    ./dataset_summary_tables.qmd                                             2025-12-08 13:31:03
    ./date-basics.qmd                                                        2025-12-08 13:31:03
    ./dynamic-selecting.qmd                                                  2025-12-08 13:31:03
    ./file-management.qmd                                                    2025-12-08 13:31:03
    ./file-type-comparison.qmd                                               2025-12-08 13:31:03
    ./functions-part-1.qmd                                                   2025-12-08 13:31:03
    ./functions-part-2.qmd                                                   2025-12-08 13:31:03
    ./future-meetings/getting-data-into-R.qmd                                2025-12-08 13:31:03
    ./ggplot2_gog-and-labelling-plots.qmd                                    2025-12-08 13:31:03
    ./healthy_places_index_api_function.qmd                                  2025-12-08 13:31:04
    ./identifying-and-consolidating-overlapping-date-ranges-longitudinal.qmd 2025-12-08 13:31:04
    ./intro-to-quarto.qmd                                                    2025-12-08 13:31:04
    ./looking-at-data.qmd                                                    2025-12-08 13:31:04
    ./miscellaneous-things.qmd                                               2025-12-08 13:31:04
    ./mutate-across.qmd                                                      2025-12-08 13:31:04
    ./parameters_example.qmd                                                 2025-12-08 13:31:04
    ./plotly-basics.qmd                                                      2025-12-08 13:31:04
    ./probabilistic-matching.qmd                                             2025-12-08 13:31:04
    ./r-package-overview.qmd                                                 2025-12-08 13:31:04
    ./saving-data-for-downstream-analyses.qmd                                2025-12-08 13:31:04
    ./separate-strings-into-parts.qmd                                        2025-12-08 13:31:04
    ./separate-wider-and-longer.qmd                                          2025-12-08 13:31:04
    ./stats-distribution-functions.qmd                                       2025-12-08 13:31:04
    ./strings_regular-expressions.qmd                                        2025-12-08 13:31:04
    ./tidy-data.qmd                                                          2025-12-08 13:31:04
    ./tidy-eval.qmd                                                          2025-12-08 13:31:04
    ./tidyr-unite.qmd                                                        2025-12-08 13:31:04
    ./updating-r-and-rstudio.qmd                                             2025-12-08 13:31:04
                                                                                           atime
    ./api-basics.qmd                                                         2025-12-09 08:44:45
    ./base-r_functions.qmd                                                   2025-12-09 08:44:45
    ./base-r_vs_tidyverse.qmd                                                2025-12-09 08:44:45
    ./climate-related-apis.qmd                                               2025-12-09 08:44:45
    ./conf_int.qmd                                                           2025-12-09 08:44:45
    ./dataset_summary_tables.qmd                                             2025-12-09 08:44:45
    ./date-basics.qmd                                                        2025-12-09 08:44:45
    ./dynamic-selecting.qmd                                                  2025-12-09 08:44:45
    ./file-management.qmd                                                    2025-12-09 08:51:14
    ./file-type-comparison.qmd                                               2025-12-09 08:44:45
    ./functions-part-1.qmd                                                   2025-12-09 08:44:45
    ./functions-part-2.qmd                                                   2025-12-09 08:44:45
    ./future-meetings/getting-data-into-R.qmd                                2025-12-09 08:44:45
    ./ggplot2_gog-and-labelling-plots.qmd                                    2025-12-09 08:44:45
    ./healthy_places_index_api_function.qmd                                  2025-12-09 08:44:45
    ./identifying-and-consolidating-overlapping-date-ranges-longitudinal.qmd 2025-12-09 08:44:45
    ./intro-to-quarto.qmd                                                    2025-12-09 08:44:45
    ./looking-at-data.qmd                                                    2025-12-09 08:44:45
    ./miscellaneous-things.qmd                                               2025-12-09 08:44:45
    ./mutate-across.qmd                                                      2025-12-09 08:44:45
    ./parameters_example.qmd                                                 2025-12-09 08:44:45
    ./plotly-basics.qmd                                                      2025-12-09 08:44:45
    ./probabilistic-matching.qmd                                             2025-12-09 08:44:45
    ./r-package-overview.qmd                                                 2025-12-09 08:44:45
    ./saving-data-for-downstream-analyses.qmd                                2025-12-09 08:44:45
    ./separate-strings-into-parts.qmd                                        2025-12-09 08:44:45
    ./separate-wider-and-longer.qmd                                          2025-12-09 08:44:45
    ./stats-distribution-functions.qmd                                       2025-12-09 08:44:45
    ./strings_regular-expressions.qmd                                        2025-12-09 08:44:45
    ./tidy-data.qmd                                                          2025-12-09 08:44:45
    ./tidy-eval.qmd                                                          2025-12-09 08:44:45
    ./tidyr-unite.qmd                                                        2025-12-09 08:44:45
    ./updating-r-and-rstudio.qmd                                             2025-12-09 08:44:45
                                                                             exe
    ./api-basics.qmd                                                          no
    ./base-r_functions.qmd                                                    no
    ./base-r_vs_tidyverse.qmd                                                 no
    ./climate-related-apis.qmd                                                no
    ./conf_int.qmd                                                            no
    ./dataset_summary_tables.qmd                                              no
    ./date-basics.qmd                                                         no
    ./dynamic-selecting.qmd                                                   no
    ./file-management.qmd                                                     no
    ./file-type-comparison.qmd                                                no
    ./functions-part-1.qmd                                                    no
    ./functions-part-2.qmd                                                    no
    ./future-meetings/getting-data-into-R.qmd                                 no
    ./ggplot2_gog-and-labelling-plots.qmd                                     no
    ./healthy_places_index_api_function.qmd                                   no
    ./identifying-and-consolidating-overlapping-date-ranges-longitudinal.qmd  no
    ./intro-to-quarto.qmd                                                     no
    ./looking-at-data.qmd                                                     no
    ./miscellaneous-things.qmd                                                no
    ./mutate-across.qmd                                                       no
    ./parameters_example.qmd                                                  no
    ./plotly-basics.qmd                                                       no
    ./probabilistic-matching.qmd                                              no
    ./r-package-overview.qmd                                                  no
    ./saving-data-for-downstream-analyses.qmd                                 no
    ./separate-strings-into-parts.qmd                                         no
    ./separate-wider-and-longer.qmd                                           no
    ./stats-distribution-functions.qmd                                        no
    ./strings_regular-expressions.qmd                                         no
    ./tidy-data.qmd                                                           no
    ./tidy-eval.qmd                                                           no
    ./tidyr-unite.qmd                                                         no
    ./updating-r-and-rstudio.qmd                                              no
                                                                             uname
    ./api-basics.qmd                                                         ejump
    ./base-r_functions.qmd                                                   ejump
    ./base-r_vs_tidyverse.qmd                                                ejump
    ./climate-related-apis.qmd                                               ejump
    ./conf_int.qmd                                                           ejump
    ./dataset_summary_tables.qmd                                             ejump
    ./date-basics.qmd                                                        ejump
    ./dynamic-selecting.qmd                                                  ejump
    ./file-management.qmd                                                    ejump
    ./file-type-comparison.qmd                                               ejump
    ./functions-part-1.qmd                                                   ejump
    ./functions-part-2.qmd                                                   ejump
    ./future-meetings/getting-data-into-R.qmd                                ejump
    ./ggplot2_gog-and-labelling-plots.qmd                                    ejump
    ./healthy_places_index_api_function.qmd                                  ejump
    ./identifying-and-consolidating-overlapping-date-ranges-longitudinal.qmd ejump
    ./intro-to-quarto.qmd                                                    ejump
    ./looking-at-data.qmd                                                    ejump
    ./miscellaneous-things.qmd                                               ejump
    ./mutate-across.qmd                                                      ejump
    ./parameters_example.qmd                                                 ejump
    ./plotly-basics.qmd                                                      ejump
    ./probabilistic-matching.qmd                                             ejump
    ./r-package-overview.qmd                                                 ejump
    ./saving-data-for-downstream-analyses.qmd                                ejump
    ./separate-strings-into-parts.qmd                                        ejump
    ./separate-wider-and-longer.qmd                                          ejump
    ./stats-distribution-functions.qmd                                       ejump
    ./strings_regular-expressions.qmd                                        ejump
    ./tidy-data.qmd                                                          ejump
    ./tidy-eval.qmd                                                          ejump
    ./tidyr-unite.qmd                                                        ejump
    ./updating-r-and-rstudio.qmd                                             ejump
                                                                             udomain
    ./api-basics.qmd                                                            SMHD
    ./base-r_functions.qmd                                                      SMHD
    ./base-r_vs_tidyverse.qmd                                                   SMHD
    ./climate-related-apis.qmd                                                  SMHD
    ./conf_int.qmd                                                              SMHD
    ./dataset_summary_tables.qmd                                                SMHD
    ./date-basics.qmd                                                           SMHD
    ./dynamic-selecting.qmd                                                     SMHD
    ./file-management.qmd                                                       SMHD
    ./file-type-comparison.qmd                                                  SMHD
    ./functions-part-1.qmd                                                      SMHD
    ./functions-part-2.qmd                                                      SMHD
    ./future-meetings/getting-data-into-R.qmd                                   SMHD
    ./ggplot2_gog-and-labelling-plots.qmd                                       SMHD
    ./healthy_places_index_api_function.qmd                                     SMHD
    ./identifying-and-consolidating-overlapping-date-ranges-longitudinal.qmd    SMHD
    ./intro-to-quarto.qmd                                                       SMHD
    ./looking-at-data.qmd                                                       SMHD
    ./miscellaneous-things.qmd                                                  SMHD
    ./mutate-across.qmd                                                         SMHD
    ./parameters_example.qmd                                                    SMHD
    ./plotly-basics.qmd                                                         SMHD
    ./probabilistic-matching.qmd                                                SMHD
    ./r-package-overview.qmd                                                    SMHD
    ./saving-data-for-downstream-analyses.qmd                                   SMHD
    ./separate-strings-into-parts.qmd                                           SMHD
    ./separate-wider-and-longer.qmd                                             SMHD
    ./stats-distribution-functions.qmd                                          SMHD
    ./strings_regular-expressions.qmd                                           SMHD
    ./tidy-data.qmd                                                             SMHD
    ./tidy-eval.qmd                                                             SMHD
    ./tidyr-unite.qmd                                                           SMHD
    ./updating-r-and-rstudio.qmd                                                SMHD

## Moving files from R

Let’s say we want to save the `palmerpenguins::penguins()` data set for
use within this repository. We will load the data, make a directory and
save the data to that directory.

First we’ll load the `palmerpenguins::penguins()` data into our
environment and will save it as an object called `penguins`

``` r
penguins <- palmerpenguins::penguins
```

Then we’ll create a directory in which to store the data using
`dir.create()`:

``` r
dir.create("data-penguins")
list.dirs()
```

     [1] "."                                                        
     [2] "./base-r_functions_files"                                 
     [3] "./base-r_functions_files/figure-commonmark"               
     [4] "./data"                                                   
     [5] "./data-penguins"                                          
     [6] "./dataset_summary_tables_files"                           
     [7] "./dataset_summary_tables_files/figure-commonmark"         
     [8] "./file-type-comparison_files"                             
     [9] "./file-type-comparison_files/figure-commonmark"           
    [10] "./future-meetings"                                        
    [11] "./ggplot2_gog-and-labelling-plots_files"                  
    [12] "./ggplot2_gog-and-labelling-plots_files/figure-commonmark"
    [13] "./images"                                                 
    [14] "./r-scripts"                                              
    [15] "./stats-distribution-functions_files"                     
    [16] "./stats-distribution-functions_files/figure-commonmark"   

Lastly, we’ll save the `penguins` data in the directory we just created:

``` r
saveRDS(penguins,
        file = "data-penguins/penguins.RDS")

list.files(path = "data-penguins")
```

    [1] "penguins.RDS"

After doing this, we realize that there already is a `data` folder in
our directory:

``` r
list.dirs()
```

     [1] "."                                                        
     [2] "./base-r_functions_files"                                 
     [3] "./base-r_functions_files/figure-commonmark"               
     [4] "./data"                                                   
     [5] "./data-penguins"                                          
     [6] "./dataset_summary_tables_files"                           
     [7] "./dataset_summary_tables_files/figure-commonmark"         
     [8] "./file-type-comparison_files"                             
     [9] "./file-type-comparison_files/figure-commonmark"           
    [10] "./future-meetings"                                        
    [11] "./ggplot2_gog-and-labelling-plots_files"                  
    [12] "./ggplot2_gog-and-labelling-plots_files/figure-commonmark"
    [13] "./images"                                                 
    [14] "./r-scripts"                                              
    [15] "./stats-distribution-functions_files"                     
    [16] "./stats-distribution-functions_files/figure-commonmark"   

We want to move the `penguins` data into the `data/` folder and then
want to delete the original file we wrote and the directory we created.

We can use `file.copy()` to copy the file from the `data-penguins/`
folder to the `data/` folder:

``` r
file.copy(from = "data-penguins/penguins.RDS",
          to = "data/penguins.RDS")
```

    [1] TRUE

``` r
list.files(path = "data")
```

    [1] "file-type-comparison.RDS" "penguins.RDS"            

Then we’ll delete the file from the wrong folder with `file.remove()`:

``` r
# remove the file saved in the wrong directory
file.remove("data-penguins/penguins.RDS")
```

    [1] TRUE

``` r
list.files(path = "data-penguins")
```

    character(0)

And lastly we’ll delete the directory with `unlink()`. Note that you
need to include the `recursive = T` argument for `unlink()` to remove
the directory.

``` r
# delete the directory
unlink("data-penguins", 
       recursive = T)
list.dirs()
```

     [1] "."                                                        
     [2] "./base-r_functions_files"                                 
     [3] "./base-r_functions_files/figure-commonmark"               
     [4] "./data"                                                   
     [5] "./dataset_summary_tables_files"                           
     [6] "./dataset_summary_tables_files/figure-commonmark"         
     [7] "./file-type-comparison_files"                             
     [8] "./file-type-comparison_files/figure-commonmark"           
     [9] "./future-meetings"                                        
    [10] "./ggplot2_gog-and-labelling-plots_files"                  
    [11] "./ggplot2_gog-and-labelling-plots_files/figure-commonmark"
    [12] "./images"                                                 
    [13] "./r-scripts"                                              
    [14] "./stats-distribution-functions_files"                     
    [15] "./stats-distribution-functions_files/figure-commonmark"   

That’s it! You likely won’t use this workflow to move a single file, but
if you want to move a lot of files, this is a great option.

Note: `file.copy()` works with all sorts of files! We use this when we
render the ED Census `.pdf` report each morning. There’s a “bug” that
throws an error if you want to render an R Markdown to a file path that
has spaces in it. You can get around this by rendering your markdown to
a path without spaces, copying the file to the correction location and
then deleting the original file. We render the ED Census report to a
path without spaces, then copy it into the DSAT folder and then delete
it from the original location!

# Working with directories

## Basics

If you’re working within a GitHub repo or R project, the working
directory should be the highest directory in the project. This is the
directory that has the `.gitignore` and `.Rproj` files. You don’t need
to use `setwd()` to specify this, R will default to that directory.

If you’re not working with a GitHub repo or R project, you will probably
need to manually set your working directory with `setwd()`.

You can always check your working directory with `getwd()`

``` r
getwd()
```

## Navigating directories

You can set “absolute” or “relative” directories in R.

An absolute directory is a specific path. You can use the `setwd()`
function or you can to to Session \> Set Working Directory \> Choose
Directory and set the directory using a point and click interface.

<img src="images/set-working-directory.png" width="500" />

A relative directory is a directory that is specified in relation to the
home directory. You can also set relative directories with `setwd()`

This is our current directory:

``` r
getwd()
```

Now lets move one directory down (to a folder further from the main
project). To do this, we need to specify the directory name(s) where we
want to go:

``` r
setwd("data")
getwd()
list.files()
```

Now lets move two directories up (closer to the main project). Note that
here we don’t need to specify the directories by name. `..` means move
to the parent of the current directory.

``` r
setwd("../../")
getwd()
```

There’s a nice explanation of directory shorthand in R
[here](https://stackoverflow.com/questions/37380961/moving-down-a-folder-in-working-directory)
