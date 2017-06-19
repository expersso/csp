Introduction
------------

This package contains the [Correlates of State Policy](http://ippsr.msu.edu/public-policy/correlates-state-policy) dataset, which

> ... includes more than seven-hundred variables, with observations across the U.S. 50 &gt; states and time (1900 – 2016). These variables represent policy outputs or &gt; political, social, or economic factors that may influence policy differences &gt; across the states. The codebook includes the variable name, a short description &gt; of the variable, the variable time frame, a longer description of the variable, &gt; and the variable source(s) and notes.

See website above for suggested citation.

The package allows the user to load and work with the dataset using the R programming language. Crucially, it incorporates the entire codebook into the dataset, which allows for easier filtering, finding units and sources, etc.

Example use
-----------

``` r
library(csp)
library(ggplot2)

data(csp, package = "csp")
dim(csp)
```

    ## [1] 5507541      13

``` r
names(csp)
```

    ##  [1] "year"          "st"            "stateno"       "state"        
    ##  [5] "state_fips"    "state_icpsr"   "variable"      "value"        
    ##  [9] "topic"         "var_desc"      "dates"         "var_long_desc"
    ## [13] "sources_notes"

``` r
csp[1:2, ]
```

    ## # A tibble: 2 x 13
    ##    year    st stateno  state state_fips state_icpsr      variable value
    ##   <dbl> <chr>   <dbl>  <chr>      <dbl>       <dbl>         <chr> <dbl>
    ## 1  1900    AK       2 Alaska          2          81 pollib_median   NaN
    ## 2  1901    AK       2 Alaska          2          81 pollib_median   NaN
    ## # ... with 5 more variables: topic <chr>, var_desc <chr>, dates <chr>,
    ## #   var_long_desc <chr>, sources_notes <chr>

``` r
df <- subset(csp, variable == "real2_pc_inc_quar")
df$value <- as.numeric(df$value)

ggplot(df, aes(x = year, y = value, color = state)) +
  geom_line(show.legend = FALSE) +
  scale_color_grey() +
  theme_light() +
  labs(x = NULL, y = NULL,
       title = df$var_desc[1],
       subtitle = df$var_long_desc[1])
```

![](README_files/figure-markdown_github/unnamed-chunk-2-1.png)

Disclaimer
----------

This package is not affiliated with, nor endorsed by, the Correlates of State Policy Project. All credit go to the original authors, and questions should be directed to them. Please check the [official website](http://ippsr.msu.edu/public-policy/correlates-state-policy) for further details on citations, etc.
