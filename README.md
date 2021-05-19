
<!-- README.md is generated from README.Rmd. Please edit that file -->

# nottshcPublic

<!-- badges: start -->
<!-- badges: end -->

The goal of nottshcPublic is to …

## Installation

You can install the released version of nottshcPublic from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("nottshcPublic")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(nottshcPublic)
#> This is nottshcPublic 0.1.1
#> nottshcPublic is currently in development - please report any bugs or ideas at:
#> https://github.com/CDU-data-science-team/nottshcPublic/issues
#> 
#> -- Connecting to nottshc servers: ----------------------------------------------
#> i conn_mysql_suce <- connect_mysql(database = "SUCE")
## basic example code
```

### Connect to database

``` r
conn_mysql_suce <- connect_mysql(database = "SUCE")
#> No host name set, using default ...
#> No UID_MYSQL_SUCE set, defaulting to 'opendata' ...
#> No PWD_MYSQL_SUCE set, defaulting to 'letmein' ...
#> 
#> -- Connecting to MySQL ODBC 8.0 Unicode Driver ---------------------------------
#> v Connecting to server: 109.74.194.173
#> v Connecting to database: SUCE
```

### Get data

``` r
db_px_data <- get_px_exp(open_data = TRUE)
db_px_data
#> # Source:   SQL [?? x 28]
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
db_px_data_tidy <- db_px_data %>% 
  tidy_px_exp()

db_px_data_tidy
#> # Source:   lazy query [?? x 23]
#> # Database: mysql [opendata@:/SUCE]
#>       key comment_key date       location team_c team_n   directorate   division
#>     <int> <chr>       <date>     <chr>     <dbl> <chr>    <chr>         <chr>   
#>  1 341022 341022_imp  2020-10-06 <NA>       2340 Unknown~ Children and~ Communi~
#>  2 341199 341199_imp  2020-11-26 <NA>        211 Family ~ Adult mental~ Local p~
#>  3 341212 341212_imp  2020-11-26 <NA>        728 Amber W~ Mental healt~ Local p~
#>  4 341688 341688_imp  2020-11-28 <NA>        738 Mansfie~ Mental healt~ Local p~
#>  5 341844 341844_imp  2020-12-07 <NA>       2340 Unknown~ Children and~ Communi~
#>  6 342094 342094_imp  2021-03-06 <NA>       1613 HMP Lin~ Offender hea~ Forensic
#>  7 342101 342101_imp  2021-03-07 <NA>        412 West Co~ CAMHS         Local p~
#>  8 342176 342176_imp  2021-03-10 <NA>        802 Kempton~ High secure ~ Forensic
#>  9 342281 342281_imp  2021-03-14 <NA>       1202 Jade Wa~ High secure ~ Forensic
#> 10 342342 342342_imp  2021-02-17 <NA>      30801 PCPM     Rushcliffe    Communi~
#> # ... with more rows, and 15 more variables: su <int>, service <dbl>,
#> #   listening <dbl>, communication <dbl>, respect <dbl>, inv_care <dbl>,
#> #   positive <int>, category <chr>, subcategory <chr>, comment_type <chr>,
#> #   comment_txt <chr>, type_category <chr>, type_num <chr>, code <chr>,
#> #   crit <dbl>
```
