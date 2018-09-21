Introduction
------------

Since the Correlates of State Policy project now provides their data in
an easy-to-use CSV file, this package is deprecated. To read the data
into R, just use:

``` r
uri <- "http://ippsr.msu.edu/sites/default/files/correlatesofstatepolicyprojectv2_1.csv"
csp <- read.csv(uri)
str(csp)
```

See [their
website](http://ippsr.msu.edu/public-policy/correlates-state-policy) for
up-to-date information.

This package contains the [Correlates of State
Policy](http://ippsr.msu.edu/public-policy/correlates-state-policy)
dataset version 1.11, which

> … includes more than seven-hundred variables, with observations across
> the U.S. 50 &gt; states and time (1900 – 2016). These variables
> represent policy outputs or &gt; political, social, or economic
> factors that may influence policy differences &gt; across the states.
> The codebook includes the variable name, a short description &gt; of
> the variable, the variable time frame, a longer description of the
> variable, &gt; and the variable source(s) and notes.

Suggested citation:

> Jordan, Marty P. and Matt Grossmann. 2016. The Correlates of State
> Policy Project v.1.0. East Lansing, MI: Institute for Public Policy
> and Social Research (IPPSR).

The package allows the user to load and work with the dataset using the
R programming language. Crucially, it incorporates the entire codebook
into the dataset, which allows for easier filtering, finding units and
sources, etc.

Example use
-----------

``` r
library(csp)
library(ggplot2)

data(csp, package = "csp")
dim(csp)
names(csp)
csp[1:2, ]
```

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

Disclaimer
----------

This package is not affiliated with, nor endorsed by, the Correlates of
State Policy Project. All credit go to the original authors, and
questions should be directed to them. Please check the [official
website](http://ippsr.msu.edu/public-policy/correlates-state-policy) for
further details on citations, etc.
