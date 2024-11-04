#################################################
#
# test out ways to save a file
# 
# details here:
# comparison: https://tomaztsql.wordpress.com/2022/05/08/comparing-performances-of-csv-to-rds-parquet-and-feather-data-types/
#
#################################################

rm(list = ls())

library(tidyverse)
library(writexl)
library(readxl)
library(arrow)
library(readr)
library(microbenchmark)

# setup ------------------------------------------
dir.create("file-testing")
setwd("./file-testing")

## create dataset ----
### this code was adapted from here: https://medium.com/@tomazkastrun/comparing-performances-of-file-formats-in-r-csv-to-rds-parquet-and-feather-b6e3a83712e6
n_rows <- 100000

data <- data.frame(
  replicate(10, sample(0:10000, n_rows, rep = TRUE)),
  replicate(10, runif(n_rows, 0.0, 1.0)),
  string = replicate(n_rows, paste(sample(c(letters, LETTERS), 10, rep = T), collapse = ""))
)

# test out ways to write data --------------------
test_num <- 100

benchmark_write <- data.frame(summary(microbenchmark(
  ".csv" = write.csv(data, file = "data_csv.csv"),
  ".xlsx" = write_xlsx(data, "data_xlsx.xlsx"),
  ".Rdata" = save(data, file = "data_rda.Rdata"),
  ".RDS" = save(data, file = "data_rds.RDS"),
  ".parquet" = write_parquet(data, "data_parquet.parquet"),
  ".feather" = write_feather(data, "data_feather.feather"),
  ".arrow" = write_csv_arrow(data, "data_arrow.arrow"),
  times = test_num))
  ) %>%  
  rename_with(~paste0("write_", .x))

benchmark_read <- data.frame(summary(microbenchmark(
  ".csv" = read_csv("data_csv.csv"),
  ".xlsx" = read_xlsx("data_xlsx.xlsx"),
  ".Rdata" = load("data_rda.Rdata"),
  ".RDS" = load("data_rds.RDS"),
  ".parquet" = read_parquet("data_parquet.parquet"),
  ".feather" = read_feather("data_feather.feather"),
  ".arrow" = read_csv_arrow("data_arrow.arrow"),
  times = test_num))
) %>%
  rename_with(~paste0("read_", .x))

file_sizes <- file.info(list.files(pattern = "^data_.*")) %>%
  data.frame() %>%
  rownames_to_column("file") %>%
  mutate(size_kb = size/1000) %>%
  select(file, size_kb)
  
file_type_comp <- file_sizes %>%
  mutate(file_type = str_extract(file, "\\.[A-Za-z]*")) %>%
  select(file_type, everything(), - file) %>%
  left_join(benchmark_write, by = c("file_type" = "write_expr")) %>%
  left_join(benchmark_read, by = c("file_type" = "read_expr")) 

save(file_type_comp, file = "quarto-markdowns/data/file-type-comparison.RDS")
