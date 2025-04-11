# Confidence Intervals
Eamonn Hartmann
2025-04-03

- [How to calculate confidence intervals by
  hand](#how-to-calculate-confidence-intervals-by-hand)
- [How to calculate confidence intervals for rates in
  R](#how-to-calculate-confidence-intervals-for-rates-in-r)

Confidence intervals display values that one would expect the true
estimate to fall within if you replicate the analysis many times. If a
study has a 95% confidence interval, then the true value would exist
within the confidence interval 95% of the time if you were to replicate
the analysis.

## How to calculate confidence intervals by hand

Notation:

- Number of events: x

- Sample size: n

- z-score: z

- Confidence level: CI

To manually calculate confidence intervals, begin by calculating the
rate $$
\frac{x}{n} $$

``` r
library(tidyverse)

smc_drug_rate <- 119/733081
```

Then, calculate the standard error, which is the standard deviation of
the sampling distribution $$ \sqrt{x / n^2} $$

Next, calculate the margin of error, which represents the amount of
random sampling error $$ z*\sqrt{x / n^2}) $$

If you are calculating a 95% confidence interval, use a z-score of 1.96
when calculating the margin of error (99% CI: 2.576, 90% CI: 1.645).

``` r
smc_drug_rate_se <- sqrt(119/ (733081)^2)

smc_drug_rate_me <- smc_drug_rate_se*1.96
```

Finally, calculate the lower and upper confidence intervals and multiply
by designated multiplier (e.g., 100,000). Formula:
$$ (x/n-z*\sqrt{x / n^2}),(x/n+z*\sqrt{x / n^2}) $$

``` r
smc_drug_rate_lower_ci <- round((smc_drug_rate - smc_drug_rate_me)*100000, digits = 1)

smc_drug_rate_upper_ci <- round((smc_drug_rate + smc_drug_rate_me)*100000, digits = 1)

smc_drug_rate_ci_manual <- data.frame(lower_ci = smc_drug_rate_lower_ci,
                                      upper_ci = smc_drug_rate_upper_ci)
```

## How to calculate confidence intervals for rates in R

The prop.test function can be utilized to test the null hypothesis that
the proportions in one or more groups are the same. The function allows
for specification of the alternative hypothesis (one-sided or two-sided)
and the size of the confidence interval.

``` r
smc_2023_prop_test <- data.frame(deaths = 119,
                                    smc_pop = 733081) 

prop_test <- prop.test(smc_2023_prop_test$deaths, smc_2023_prop_test$smc_pop, conf.level = 0.95)
```

The results produce a list of the test statistic, parameter, p-value,
estimate, and confidence intervals. To extract the confidence interval
only, use Base R (\$conf.int) to further specify the lower and upper
confidence interval values by specifying \[1\] or \[2\]. If you are
multiplying your rate, make sure to multiple your confidence interval by
the same value to ensure statistical congruency.

``` r
smc_2023_drug_rate_ci <- smc_2023_prop_test %>%
    mutate(crude_rate = round(deaths/smc_pop*100000, digits = 2),
            lower_ci = round(prop.test(deaths, smc_pop, conf.level = 0.95)$conf.int[1]*100000, digits = 2), 
            upper_ci = round(prop.test(deaths, smc_pop, conf.level = 0.95)$conf.int[2]*100000, digits = 2))
```
