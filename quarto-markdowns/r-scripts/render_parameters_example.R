################################################
#
# 03b: render word markdown for parameters_example.Rmd
#
################################################
#clean data environment
rm(list = ls())
library(rmarkdown)
library(dplyr)


# Define parameter inputs ----------------------------------------
people_names <- list(c("Tom", "Bob"), "Jerry")
message <- list("Happy birthday", "Get lost")

# Render for each input ----------------------------------------
for (i in 1:2) {
  output_file <- paste0("Report", i, "_", Sys.Date(), ".docx") #by default, will save to the same location as the.qmd file
  rmarkdown::render("./quarto-markdowns/paramaters_example.qmd", 
                    output_file = output_file, 
                    params = list(person = people_names[[i]],
                                  message = message[[i]]),
                    envir = new.env())
}

