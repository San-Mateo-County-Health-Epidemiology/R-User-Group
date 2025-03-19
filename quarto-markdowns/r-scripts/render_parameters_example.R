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
messages <- list("Happy birthday", "Get lost")

# Render for each input ----------------------------------------
i <- 1
for (person in people_names) {
  for(message in messages){
    output_file <- paste0("Report", i, "_", Sys.Date(), ".docx") #by default, will save to the same location as the.qmd file
    rmarkdown::render("./quarto-markdowns/paramaters_example.qmd", 
                      output_file = output_file, 
                      params = list(person = person,
                                    message = message),
                                    #we don't provide the exclamation argument, so it will use the default (TRUE)
                      envir = new.env()) #Don't save environmental variables from knitting (does not clear the current working environment)
    i <- i+1
  }
}

