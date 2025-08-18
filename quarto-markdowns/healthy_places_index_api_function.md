# Download Healthy Places Index Data using API
Julie Bartels
2025-08-21

## Overview

This document provides functions to streamline the download of Healthy
Places Index 3.0 data, including the 23 indicators that are used for the
Index, as well as selected indicators for the Decision Support part of
the HPI tool.

Users will need to create an individual API key here:
https://map.healthyplacesindex.org/?redirect=false

This code can be adapted and applied for other APIs and data sources.

### Load libraries

``` r
library(httr)
library(jsonlite)
library(readr)
library(dplyr)
library(stringr)
library(purrr)
```

### Create list of census tracts in San Mateo County

This is used to filter HPI data for only tracts in SMC later in the
process. It relies on the user uploading a file that includes the census
tracts that were used for the HPI overall index ranks for census tracts
in SMC.

``` r
HPI_ranks_SMC_censustracts <- read_csv("J:/Epi Data/HPI 3.0/Data/HPI_ranks_SMC_censustracts.csv")
SMC_censustracts <- HPI_ranks_SMC_censustracts %>%
  dplyr::select(geoid, name) %>%
  mutate(geoid = as.character(geoid), 
         name = as.character(name))
```

## Function to download and clean datasets

The HPI API requires parameters for geography, year, indicator, format,
and the user’s API key to download jsons of the HPI indicator data. This
function does the following: 1) Takes the i-th values from vectors of
parameters for geography and year that are coded by the user to create a
specific URL call for an indicator, 2) Gets the data from the API pull
and formats it into a dataframe, 3) Cleans the data grame to remove the
numerator, denominator, and SE variables, and adds a variable for the
quartile of the census tract rating compared to other census tracts in
California, 4) Renames the variables so that they include the name of
the indicator, and 5) Returns the dataframe for the indicator.

This could be edited to apply to other APIs that take different
parameters or include other variables.

``` r
get_data_func <- function(i, newvaluename, newquantname, newpercentilename) {
  params <- list(geography = paste(geography),
                 year = paste(year[i]),
                 indicator = paste(indicator[i]),
                 format = paste(format), 
                 key=api_key)
  res <- GET(url,query=params)  
  data <- as.data.frame(fromJSON(rawToChar(res$content)))
  SMCdata <- SMCdata %>% 
    dplyr::select(-c(numerator, denominator, se)) %>%
    mutate("{newquantname}" := case_when(
      percentile <= 0.25 ~ 1, 
      percentile <= 0.5 & percentile > 0.25 ~ 2,
      percentile <= 0.75 & percentile > 0.5 ~ 3,
      percentile <= 1 & percentile > 0.75 ~ 4
    )) %>%
    rename("{newvaluename}" := value,
           "{newpercentilename}" := percentile)
  return(SMCdata)
}
```

## Inputs for function to download and clean datasets for HPI indicators only

The get_data_func function requires vectors of character variables to
input into the data query parameters. The vectors below are hand-coded
with values for each of the variables we are pulling from the HPI.

Line 82 (“api_key”) requires the user to input their own API key as a
character there.

``` r
url <- "https://api.healthyplacesindex.org/api/hpi"
api_key <- "YOUR API KEY HERE"
geography <- c("tracts")
year <- c("2019", 
          "2019", 
          "2019",
          "2019",
          "2019",
          "2019",
          "2020",
          "2020",
          "2019",
          "2019",
          "2017",
          "2021",
          "2011",
          "2019",
          "2017",
          "2017",
          "2017",
          "2019",
          "2016",
          "2019",
          "2018",
          "2017",
          "2019")

indicator <- c("abovepoverty", 
               "employed", 
               "percapitaincome",
               "bachelorsed",
               "inhighschool",
               "inpreschool",
               "censusresponse",
               "voting",
               "commute",
               "automobile",
               "parkaccess",
               "retail",
               "treecanopy",
               "homeownership",
               "houserepair",
               "ownsevere",
               "rentsevere",
               "uncrowded",
               "dieselpm",
               "h20contam",
               "ozone",
               "pm25",
               "insured")

format <- "json"
```

## Function to pull and collate HPI indicator datasets

The get_data_func function creates a cleaned dataframe for an individual
API pull for one indicator from the HPI website. We want to pull all 23
indicators from the HPI. This function repeats the get_data_func
function for all 23 indicators by creating the inputs (newvaluename,
newquantname, and newpercentilename) from the indicator and year vectors
we created in the prior step.

All of the resulting dataframes are collated into a list called
“results_list”.

Then we combine all of the listed dataframes into one overall dataframe,
and then filter it for census tracts within San Mateo County.

``` r
results_list <- list()

for (i in 1:23) {
  result <- get_data_func(
    i,
    newvaluename = paste0(indicator[i], year[i], "_value"),
    newquantname = paste0(indicator[i], year[i], "_quartile"),
    newpercentilename = paste0(indicator[i], year[i], "_percentileCA")
  )
  results_list[[i]] <- result
}

# Combine results
combined_data <- reduce(results_list, left_join, by = c("geoid", "name", "population"))

# Filter for census tracts in San Mateo County only
combined_data_SMC <- combined_data %>% 
  filter(name %in% SMC_censustracts$name) %>% 
  filter(str_detect(geoid, "0608"))
```

## Inputs for function to download and clean datasets for selected Decision Support indicators

The HPI includes 23 main indicators, as well as others that are in the
“Decision Support” section. Here, we create indicator and year vectors
that are relevant to those decision support indicators, as labeled
throughout the following code chunk.

The user will need to input their api_key here as well. Note that the
URL here is slightly different from the previous one.

``` r
url <- "https://api.healthyplacesindex.org/api/support"
api_key <- "YOUR API KEY HERE"
geography <- c("tracts")
year <- c("2019", # Race/Ethnicity Diversity Index 2019
          "2010", # Residential segregation (all Non-White) 2010
          "2010", # Residential segregation (Asian) 2010
          "2010",  # Residential segregation (Black or African American) 2010
          "2010", # Residential segregation (Hispanic or Latino) 2010
          "2016", # Impervious surface cover 2016
          "2015", # Urban heat island index 2015
          "2018", # Extreme heat days above 100 degrees (2035-2064)
          "2018", # Extreme heat days above 100 degrees (2035-2064) - above historical baseline
          "2009", # Population in Sea Level Rise Inundation Area - 2009
          "2007", # Wildfire Risk - 2007
          "2019", # Households with Broadband Internet 2019
          "2019", # New Residents 2019
          "2015", # Park Acres 2015
          "2017", # Supermarket Access 2017
          "2017", # Traffic Impacts 2017
          "2012", # Transit Access 2012
          "2018", # Walkability Score 2018
          "2019", # Ambulatory Difficulty 2019
          "2018", # Asthma Percent 2018
          "2018", # Cancer (except skin cancer) Percent 2018
          "2018", # Cognitive difficulty Percent 2018
          "2018", # Coronary heart disease Percent 2018
          "2018", # Diagnosed Diabetes Percent 2018
          "2019", # Hearing Difficulty 2019,
          "2018", # High Blood Pressure Percent 2018
          "2015", # Life Expectancy at Birth 2015
          "2018", # Low Birthweight Infants 2018
          "2018", # Mental Health Not Good 2018
          "2018", # Obesity 2018
          "2019", # Self-Care Difficulty 2019
          "2019", # Vision Difficulty 2019
          "2018", # Binge Drinking 2018
          "2019", # Children in Poverty 2019
          "2019", # Older Adults 65+ Below Poverty 2019
          "2019", # Older Adults 65+ Living Alone 2019
          "2016", # Students Eligible for Free and Reduced Meal Program 2016
          "2018" # Social Vulnerability Index 2018
)

indicator <- c("diversity_index", # Race/Ethnicity Diversity Index 2019
               "iod_nonwhite", # Residential segregation (all Non-White) 2010
               "iod_asian", # Residential segregation (Asian) 2010
               "iod", # Residential segregation (Black or African American) 2010
               "iod_latino", # Residential segregation (Hispanic or Latino) 2010
               "impervsurf", # Impervious surface cover 2016
               "uhii", # Urban heat island index 2015
               "daysabove100f_2035_2064", # Extreme heat days above 100 degrees (2035-2064)
               "eh_rcp8.5_2035_2064", # Extreme heat days above 100 degrees (2035-2064) - above historical baseline
               "sealevel", # Population in Sea Level Rise Inundation Area - 2009
               "wildfire", # Wildfire Risk - 2007
               "broadband", # Households with Broadband Internet 2019
               "recentmove", # New Residents 2019
               "parkacres_per1000", # Park Acres 2015
               "supermkts", # Supermarket Access 2017
               "traffic_impacts", # Traffic Impacts 2017
               "transitaccess", # Transit Access 2012
               "walkability", # Walkability Score 2018
               "difficultyambulatory", # Ambulatory Difficulty 2019
               "casthma", # Asthma Percent 2018
               "cancer", # Cancer (except skin cancer) Percent 2018
               "difficultycognitive", # Cognitive difficulty Percent 2018
               "chd", # Coronary heart disease Percent 2018
               "diabetes", # Diagnosed Diabetes Percent 2018
               "difficultyhearing", # Hearing Difficulty 2019,
               "bphigh", # High Blood Pressure Percent 2018
               "leb", # Life Expectancy at Birth 2015,
               "lbw", # Low Birthweight Infants 2018
               "mhlth", # Mental Health Not Good 2018
               "obesity", # Obesity 2018
               "difficultyselfcare", # Self-Care Difficulty 2019
               "difficultyvision", # Vision Difficulty 2019
               "binge", # Binge Drinking 2018
               "childpoverty", # Children in Poverty 2019
               "poverty65", # Older Adults 65+ Below Poverty 2019
               "livealone65", # Older Adults 65+ Living Alone 2019
               "frm", # Students Eligible for Free and Reduced Meal Program 2016
               "svi" # Social Vulnerability Index 2018
)

format <- "json"
```

## Function to pull and collate selected Decision Support indicator datasets

This is the same function as above, except that the results list and the
combined result dataframe are named with “decision” to distinguish from
our prior data pull.

``` r
results_list_decision <- list()

for (i in 1:38) {
  result <- get_data_func(
    i,
    newvaluename = paste0(indicator[i], year[i], "_value"),
    newquantname = paste0(indicator[i], year[i], "_quartile"),
    newpercentilename = paste0(indicator[i], year[i], "_percentileCA")
  )
  results_list_decision[[i]] <- result
}

# Combine results
combined_data_decision <- reduce(results_list_decision, left_join, by = c("geoid", "name", "population"))
combined_data_decision_SMC <- combined_data %>% 
  filter(name %in% SMC_censustracts$name) %>%
  filter(str_detect(geoid, "0608"))
```
