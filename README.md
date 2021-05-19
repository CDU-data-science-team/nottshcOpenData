
<!-- README.md is generated from README.Rmd. Please edit that file -->

# nottshcPublic

<!-- badges: start -->
<!-- badges: end -->

This package demonstrates some of the ways we use R.

## Installation

You can install the developmental version of nottshcPublic using:

``` r
# install.packages("devtools")
devtools::install_github("CDU-data-science-team/nottshcPublic")
```

## Example

This example demonstrates how to (1) connect to the server, (2) access
data on the database within R Studio, (3) tidy the data on the database,
and (4) load the data into the global environment.

``` r
# Load public package
library(nottshcPublic)
#> This is nottshcPublic 0.1.1
#> nottshcPublic is currently in development - please report any bugs or ideas at:
#> https://github.com/CDU-data-science-team/nottshcPublic/issues
#> 
#> -- Connecting to nottshc servers: ----------------------------------------------
#> i conn_mysql_suce <- connect_mysql(database = "SUCE")
```

### Connect to database

``` r
# Create MySQL server connection
conn_mysql_suce <- connect_mysql(database = "SUCE")
#> i No host name set, using default server: 109.74.194.173
#> i No UID set, using default UID: opendata
#> i No PWD set, using default PWD: letmein
#> 
#> -- Connecting to MySQL ODBC 8.0 Unicode Driver ---------------------------------
#> v Connecting to server: 109.74.194.173
#> v Connecting to database: SUCE
```

### Get data

``` r
# Get database (db) connection for specified date range 
db_px_data <- get_px_exp(from = "2020-01-01",
                         to = "2020-12-31")

# Look at messy data
db_px_data
#> # Source:   lazy query [?? x 28]
#> # Database: mysql [opendata@:/SUCE]
#>       key TeamC Date       Location  Time formtype    SU carertype Promoter
#>     <int> <dbl> <date>     <chr>    <int> <chr>    <int> <chr>        <int>
#>  1 340577 34220 2020-10-06 <NA>        47 newadult     0 <NA>             4
#>  2 340578 34220 2020-10-06 <NA>        47 cyp         NA <NA>             5
#>  3 340580 34210 2020-10-06 <NA>        47 cyp         NA <NA>             5
#>  4 340581 34210 2020-10-06 <NA>        47 cyp         NA <NA>             5
#>  5 340582 34210 2020-10-06 <NA>        47 newadult     0 <NA>             5
#>  6 340583 34210 2020-10-06 <NA>        47 cyp         NA <NA>             5
#>  7 340584 34210 2020-10-06 <NA>        47 newadult     0 <NA>             5
#>  8 340585 34210 2020-10-06 <NA>        47 newadult     0 <NA>             2
#>  9 340586 30105 2020-10-07 <NA>        47 newadult     0 <NA>             4
#> 10 340587 30105 2020-10-07 <NA>        47 newadult     0 <NA>             5
#> # ... with more rows, and 19 more variables: Service <dbl>, Listening <dbl>,
#> #   Communication <dbl>, Respect <dbl>, InvCare <dbl>, Positive <int>,
#> #   Improve <chr>, ImpCrit <int>, Imp_N1 <chr>, Imp_N2 <chr>, Best <chr>,
#> #   BestCrit <int>, Best_N1 <chr>, Best_N2 <chr>, Inpatient <int>,
#> #   fftCategory <chr>, TeamN <chr>, DirT <chr>, Division2 <chr>
```

### Tidy data

``` r
# Tidy the data and select some variables 
db_px_data_tidy <- db_px_data %>% 
  tidy_px_exp() %>% 
  dplyr::select(key, comment_key, date, team_c, team_n, directorate, division,
                category, subcategory, comment_type, comment_txt, crit)

# Look at tidy data
db_px_data_tidy
#> # Source:   lazy query [?? x 12]
#> # Database: mysql [opendata@:/SUCE]
#>       key comment_key date       team_c team_n   directorate   division category
#>     <int> <chr>       <date>      <dbl> <chr>    <chr>         <chr>    <chr>   
#>  1 341022 341022_imp  2020-10-06   2340 Unknown~ Children and~ Communi~ Access  
#>  2 341199 341199_imp  2020-11-26    211 Family ~ Adult mental~ Local p~ Access  
#>  3 341212 341212_imp  2020-11-26    728 Amber W~ Mental healt~ Local p~ Access  
#>  4 341688 341688_imp  2020-11-28    738 Mansfie~ Mental healt~ Local p~ Access  
#>  5 341844 341844_imp  2020-12-07   2340 Unknown~ Children and~ Communi~ Access  
#>  6 341061 341061_imp  2020-10-21    729 Silver ~ Mental healt~ Local p~ Access  
#>  7 341205 341205_imp  2020-11-26    262 EIP LMH~ Adult mental~ Local p~ Access  
#>  8 340791 340791_best 2020-10-09  30801 PCPM     Rushcliffe    Communi~ Access  
#>  9 341025 341025_best 2020-10-07   1900 <NA>     Unknown       Unknown  Access  
#> 10 340603 340603_imp  2020-10-16  30105 CHD Cli~ Rushcliffe    Communi~ Access  
#> # ... with more rows, and 4 more variables: subcategory <chr>,
#> #   comment_type <chr>, comment_txt <chr>, crit <dbl>
```

### Collect data

In case it is preferred to collect the data from the MySQL server into R
the `collect()` function from `dplyr` can be used to

``` r
# Collect tidy data
df_px_data_tidy <- db_px_data_tidy %>% 
  dplyr::collect()
```
