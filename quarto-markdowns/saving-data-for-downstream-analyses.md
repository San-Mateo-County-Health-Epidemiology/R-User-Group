# Saving data for downstream analyses
Beth Jump
2022-05-05

## Overview

Sometimes you need to save data for downstream analyses or to load into
a different data visualization tool like Power BI. This goes through how
to save those data and also considerations about what should be (or not
be) in those files.

## Structure

If you are saving data that you’ll use in a separate R process or in a
Power BI report, there are two good ways to save your data:

### Option 1:

Save over a “main” file and then save copies of your data to an archive.
When you do this, you can set your reports to look to the “main” file
since the data in that file will update each time you overwrite it.

#### file structure

    main_folder
    │   data.csv    
    │
    └───archive
    │   │   data_20250101.csv
    │   │   data_20250108.csv
    │   │   data_20250115.csv
    │   │   data_20250122.csv
    │   │   ...

#### code

You run this each time you update the data that will be used in the
downstream reports.

First you overwrite the “main” file that is used in the reports:

    write_csv(data, "main_folder/data.csv")

Then you write the same file to an archive with the date included in the
file name:

    date <- stringr::str_replace_all(Sys.Date(), "-", "")

    write_csv(data, paste0("main_folder/archive/data_", date, ".csv"))

### Option 2

Save the file with the date appended and have a folder of dated files.
When you do this, you need to include logic in your R file or script to
pull the newest file each time. You can easily set up this logic in your
R script (consider smcepi::get_file_path()) or in Power BI with
PowerQuery.

#### file structure

    main_folder
    │
    └───data
    │   │   data_20250101.csv
    │   │   data_20250108.csv
    │   │   data_20250115.csv
    │   │   data_20250122.csv
    │   │   ...

#### code

Here you just save one copy of the file. Like the example above, you
should add the date into the file name when you save it.

    date <- stringr::str_replace_all(Sys.Date(), "-", "")

    write_csv(data, paste0("main_folder/data/data_", date, ".csv"))

### Recommendation:

If you’re saving tables for Power BI, use option 1. It’s super easy to
point Power BI to static file paths and as long as you don’t change the
structure of your tables you won’t have any problems.

If you’re saving tables for R or other statistical software analysis,
you should use option 2. It’s easy to load the newest file in a folder
and is also a bit easier to track what you’re doing when you can see the
date of the file in the path.

## Content
