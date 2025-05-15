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

1.  Save over a “main” file and then save copies of your data to an
    archive. When you do this, you can set your reports to look to the
    “main” file.

<!-- -->

    main_folder
    │   data.csv    
    │
    └───archive
    │   │   data_20250101.csv
    │   │   data_20250108.csv
    │   │   data_20250115.csv
    │   │   data_20250122.csv
    │   │   ...

2.  Save the file with the date appended and have a folder of dated
    files. When you do this, you need to include logic in your R file or
    script to pull the newest file each time.

<!-- -->

    main_folder
    │   README.md
    │   file001.txt    
    │
    └───folder1
    │   │   file011.txt
    │   │   file012.txt
    │   │
    │   └───subfolder1
    │       │   file111.txt
    │       │   file112.txt
    │       │   ...
    │   
    └───folder2
        │   file021.txt
        │   file022.txt

## Content
