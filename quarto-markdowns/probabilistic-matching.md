# probabilistic matching
Beth Jump
2022-08-11

## Overview

Probabilistic matching is a method of matching that lets you match
values that aren’t exactly the same. This method is particularly helpful
when matching names across data sets.

There are two packages I like to use when doing probabilistic matching:

- `RecordLinkage`
- `FastLink`

Each package has its pros and cons, so I typically use both when
matching. My process for doing probabilistic matching is:

1.  Clean data and do an exact match
2.  Run `RecordLinkage::compare.linkage()` to get probabilistic matches
    for unmatched records
3.  Run `fastLink::fastLink()` to get probabilistic matches for
    unmatched records
4.  Compare matches from `RecordLinkage` and `fastLink`
5.  Re-run records that only matched with `fastLink` back through
    `RecordLinkage`
6.  Manually review probabilistic matches and combine with exact matches

## Using RecordLinkage

### Set up

`compare.linkage()` is a powerful but particular function. Before using
it, you need to prepare your data in a very specific way:

- rename the variables in each of your data sets so they have the exact
  same names, are in the same order and are coded the same way: both use
  M/F/U for sex, all characters are lowercase, all years are 4 digits,
  etc
- split dates into their composite parts. Instead of `dob` you should
  have `dob_y`, `dob_m` and `dob_d`
- remove any fields that you don’t want to compare
- if you have a record id, you should put this in the first position in
  both data sets. `compare.linkage()` compares variables by position so
  `data1.col1` is compared with `data2.col1`, `data1.col2` with
  `data2.col2`, etc.

These two data sets could be run through `compare.linkage()`
successfully:

**data1**

| record_id | first_name | last_name | dob_y | dob_m | dob_d | sex |
|-----------|------------|-----------|-------|-------|-------|-----|
| 1A        | Leia       | Morgana   | 1960  | 7     | 27    | F   |

**data2**

| person_number | first_name | last_name | dob_y | dob_m | dob_d | sex |
|---------------|------------|-----------|-------|-------|-------|-----|
| 1000          | Leya       | Morgan    | 1962  | 7     | 27    | F   |

### Using `compare.linkage()`

`compare.linkage()` has many arguments. I typically use these:

- `dataset1`: this is where you put the first data set you want to match
- `dataset2`: this is where you put the second data set you want to
  match
- `blockfld`: this is where you pass a list (`list()`) of variables you
  want to match. These variables should be listed in the same order as
  they appear in your data
- `exclude`: this is a list of numbers that indicate the position of
  variables to exclude. If you pass a `1`, it will exclude the first
  variable in both data sets from the match
- `strcmp`: I set this to `T` when I’m matching string variables.

Here’s how we’d use this for the data shown above:

``` r
rl_matches <- compare.linkage(dataset1 = data1, 
                              dataset2 = data2,
                              blockfld = list("first_name", "last_name", "dob_y", "dob_m", "dob_d"),
                              exclude = 1,
                              strcmp = T)
rl_pairs <- rl_matches$pairs
```

### Reviewing matches

The `rl_pairs` table will have a column for each of the variables passed
to the `blockfld` argument and will have columns called `id1` and `id2`
which correspond to the row numbers in datasets 1 and 2 where the
matches can be found.

This is how the matches might look if we ran the data from above through
`compare.linkage()`:

| id1 | id2 | first_name | last_name | dob_y | dob_m | dob_d | sex |
|-----|-----|------------|-----------|-------|-------|-------|-----|
| 1   | 960 | 0.8        | 0.9       | 0.67  | 1     | 1     | 1   |

By looking at `id1` and `id2`, we can see that this is the match of row
1 of `dataset1` and row 960 of `dataset2`.

For each of the variables passed through `blockfld`, we get a
coefficient between 0 and 1. 1 is a perfect match and 0 is no match
(though the method for figuring that out is not clear to me).

To parse through all the potential matches, I add some additional logic
to flag which matches I want to definitely keep. I play around with
these parameters each time I run `compare.linkage()` as the exact
coefficients tend to depend on the data.

``` r
rl_all_matches <- rl_pairs %>%
  left_join(data1_unmatch, by = c("id1" = "row_number")) %>%
  left_join(data2_unmatch, by = c("id2" = "row_number")) %>%
  rowwise() %>% 
  mutate(all_name = sum(first_name.x, last_name.x),
         dob_y.x = case_when(dob_y.y == dob_y ~ 1, TRUE ~ dob_y.x),
         dob_m.x = case_when(dob_m.y == dob_m ~ 1, TRUE ~ dob_m.x),
         dob_d.x = case_when(dob_d.y == dob_d ~ 1, TRUE ~ dob_d.x),
         match = case_when(first_name.x == 1 & last_name.x == 1 & dob_y.x == 1 & dob_m.x == 1 & dob_d.x == 1 ~ "exact",
                           first_name.x == 1 & last_name.x > 0.5 & 
                             dob_y.x == 1 & dob_m.x == 1 & dob_d.x == 1 ~ "fname + dob",
                           first_name.x >= 0.75 & last_name.x == 1 & dob_y.x == 1 & dob_m.x == 1 & dob_d.x == 1 ~ "lname + dob",
                           first_name.x == 1 & last_name.x == 1 & abs(as.numeric(dob_y) - as.numeric(dob_y.y)) < 10 & 
                             ((dob_y.x == 1 & dob_m.x == 1) | (dob_y.x == 1 & dob_d.x == 1) | (dob_m.x == 1 & dob_d.x == 1)) ~ "name + 2 dob elements",
                           first_name.x > 0.6 & last_name.x > 0.615 & all_name > 1.8 & dob_y.x == 1 & dob_m.x == 1 & dob_d.x == 1 ~ "sim name + same dob",
                           first_name.x > 0.5 & last_name.x > 0.5 & all_name > 1.8 & dob_y.x == 1 ~ "sim name + same year",
                           first_name.x > 0.88 & last_name.x > 0.9 & abs(as.numeric(dob_y) - as.numeric(dob_y.y)) < 10 & 
                             ((dob_y.x == 1 & dob_m.x == 1) |
                                (dob_y.y == dob_y & dob_m.y == dob_m) |
                                (dob_y.x == 1 & dob_d.x == 1) |
                                (dob_y.y == dob_y & dob_d.y == dob_d) |
                                (dob_m.x == 1 & dob_d.x == 1) |
                                (dob_m.y == dob_m & dob_d.y == dob_d)) ~ "sim name + 2 dob elements",
                           TRUE ~ "probably no match"))

rl_prob_matches <- rl_all_matches %>%
  filter(!match %in% c("probably no match", "sim name + same year"))
```

`rl_prob_matches` is a data frame of records that are likely matches.

## Using fastLink

`fastLink` provides probabilistic matches a lot more quickly than
`RecordLinkage`. This is great because it runs quickly and requires less
computing power, but it returns a lot less detail about the matches than
`RecordLinkage` which is a major disadvantage. I never use `fastLink`
alone - I always use it in combination with `RecordLinkage`.

### Set up

Like `RecordLinkage` you need to prepare your data before using
`fastLink`. You should:

- put the record id in the first column of each data set. This will be
  used to join your data back to the matches.
- rename the variables in each of your data sets so they have the exact
  same names, are in the same order and are coded the same way: both use
  M/F/U for sex, all characters are lowercase, all years are 4 digits,
  etc
- split dates into their composite parts. Instead of `dob` you should
  have `dob_y`, `dob_m` and `dob_d`
- remove any fields that you don’t want to compare

Unlike `RecordLinkage`, you don’t need to stress about the position of
your variables as `fastLink` goes by variable name and not variable
position.

### Using `fastLink()`

The arguments for `fastLink()` are quite similar to the arguments for
`compare.linkage()`. I typically use these arguments:

- `dfA`: this is where you put the first data set you want to match
- `dfB`: this is where you put the second data set you want to match
- `varnames`: this is where you pass a list (`list()`) of variables you
  want to match. These variables should be listed in the same order as
  they appear in your data
- `stringdist.match`: this is where you pass a list of string variables
  you want to match
- `partial.match`: this is where you pass a list of string variables for
  which you want a partial match

Here’s how this would look with the data from above:

``` r
fl_matches <- fastLink(dfA = data1, 
                       dfB = data2,
                       varnames = c("first_name", "last_name", "dob_d", "dob_m", "dob_y", "sex"),
                       stringdist.match = c("first_name", "last_name"),
                       partial.match = c("first_name", "last_name"),
                       n.cores = 1)

fl_matches1 <- getMatches(data1, data2, fl_matches)
```

### Reviewing matches

The `fl_matches1` table includes a few “sets” of columns:

- the first columns are all of the variables from `dfA`
- `dfB.match[, names.dfB]`: this is the record_id from `dfB`
- `gamma.n`: these provide a 0, 1, 2 for each variable passed to the
  `varnames` argument. A 2 is a pefect match, a 1 is a partial and a 0
  is not a match
- `posterior`: this is a coefficient between 0 and 1 for the entire
  match with a 1 being a perfect match.

This is how the matches might look if we ran the data from above through
`fastLink()` - be sure to scroll to the right:

| record_id | first_name | last_name | dob_y | dob_m | dob_d | sex | dfB.match\[, names.dfB\] | gamma.1 | gamma.2 | gamma.3 | gamma.4 | gamma.5 | posterior |
|----|----|----|----|----|----|----|----|----|----|----|----|----|----|
| 1 | Leia | Morgana | 1960 | 7 | 27 | F | 960 | 1 | 1 | 0 | 2 | 2 | 0.934 |

Like with `compare.linkage()`, I like to add some additional logic to
parse through potential matches:

``` r
## get probable matches ----
fl_all_matches <- fl_matches1 %>%
  rename(person_number = `dfB.match[, names.dfB]`) %>%
  left_join(data2, by = c("sfn")) %>%
  select(record_id, matches(".x"), person_number, matches(".y"), matches("gamma"), posterior, -matches("row_number")) %>%
  rename(gamma_first = gamma.1, # ranges from 0 - 2 
         gamma_last = gamma.2,
         gamma_by = gamma.3,
         gamma_bm = gamma.4,
         gamma_bd = gamma.5,
         gamma_sex = gamma.6) %>%
  mutate(across(matches("dob"), ~ as.numeric(.x)),
         dob_match_ct = case_when(dob_y.x == dob_y.y & dob_m.x == dob_m.y & dob_d.x == dob_d.y ~ 3,
                                  dob_y.x == dob_y.y & dob_m.x == dob_m.y ~ 2,
                                  dob_y.x == dob_y.y & dob_d.x == dob_d.y ~ 2,
                                  dob_m.x == dob_m.y & dob_d.x == dob_d.y ~ 2,
                                  dob_y.x == dob_y.y ~ 1,
                                  dob_m.x == dob_m.y ~ 1,
                                  dob_d.x == dob_d.y ~ 1,
                                  TRUE ~ 0),
         year_dif = abs(dob_y.x - dob_y.y))

fl_prob_matches <- fl_all_matches %>%
  mutate(match = case_when(dob_match_ct == 3 & posterior > 0.91 ~ "good posterior + same dob",
                           dob_y.x == dob_y.y & dob_m.x == dob_d.y & dob_d.x == dob_m.y & posterior > 0.91 ~ "good posterior + transposed dob",
                           dob_match_ct == 2 & year_dif <= 10 & posterior >= 0.99 ~ "high posterior + sim dob",
                           TRUE ~ "probably no match")) %>%
  filter(!match %in% c("probably no match"))
```

`fl_all_matches` is a data set of all likely fastLink matches!
