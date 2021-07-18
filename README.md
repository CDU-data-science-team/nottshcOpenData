
<!-- README.md is generated from README.Rmd. Please edit that file -->

# nottshcOpenData

<!-- badges: start -->
<!-- badges: end -->

This package demonstrates some of the ways we use R.

## Installation

You can install the developmental version of `nottshcOpenData` using:

``` r
# install.packages("devtools")
devtools::install_github("CDU-data-science-team/nottshcOpenData")
```

You may also have to set up MySQL on your computer if it’s not installed
yet, see <https://db.rstudio.com/best-practices/drivers/>.

## Example

This example demonstrates how to

1.  connect to the server using `connect_mysql()`
2.  query data from the database within R Studio using `get_px_exp()`
3.  tidy the data on the database using `tidy_px_exp()`, and
4.  load the data into the global environment using `dplyr::collect()`

``` r
# Load public package
library(nottshcOpenData)
#> 
#> ── This is nottshcOpenData 0.2.0 ───────────────────────────────────────────────
#> ℹ nottshcOpenData is currently in development, please report any bugs or ideas at:
#> ℹ https://github.com/CDU-data-science-team/nottshcOpenData/issues
#> 
#> ── Connecting to NOTTSHC SUCE Server: ──────────────────────────────────────────
#> conn_mysql_suce <- connect_mysql(database = "SUCE")
```

### 1. Connect to database

``` r
# Create MySQL connection
# Note, the driver may differ on your computer
conn_mysql_suce <- connect_mysql(database = "SUCE",
                                 driver = "MySQL ODBC 8.0 ANSI Driver")
#> ℹ No host name set, using default server: 109.74.194.173
#> ℹ No UID set, using default UID: opendata
#> ℹ No PWD set, using default PWD: letmein
#> 
#> ── Connecting to MySQL ODBC 8.0 ANSI Driver ────────────────────────────────────
#> ✓ Connecting to server: 109.74.194.173
#> ✓ Connecting to database: SUCE
```

### 2. Get data

``` r
# Get database (db_) connection for specified date range 
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
#> # … with more rows, and 19 more variables: Service <dbl>, Listening <dbl>,
#> #   Communication <dbl>, Respect <dbl>, InvCare <dbl>, Positive <int>,
#> #   Improve <chr>, ImpCrit <int>, Imp_N1 <chr>, Imp_N2 <chr>, Best <chr>,
#> #   BestCrit <int>, Best_N1 <chr>, Best_N2 <chr>, Inpatient <int>,
#> #   fftCategory <chr>, TeamN <chr>, DirT <chr>, Division2 <chr>
```

### 3. Tidy data

``` r
# Tidy the data (on the database)
# Next select some variables for this example
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
#>  1 341022 341022_imp  2020-10-06   2340 Unknown… Children and… Communi… Access  
#>  2 341199 341199_imp  2020-11-26    211 Family … Adult mental… Local p… Access  
#>  3 341212 341212_imp  2020-11-26    728 Amber W… Mental healt… Local p… Access  
#>  4 341688 341688_imp  2020-11-28    738 Mansfie… Mental healt… Local p… Access  
#>  5 341844 341844_imp  2020-12-07   2340 Unknown… Children and… Communi… Access  
#>  6 341061 341061_imp  2020-10-21    729 Silver … Mental healt… Local p… Access  
#>  7 341205 341205_imp  2020-11-26    262 EIP LMH… Adult mental… Local p… Access  
#>  8 340791 340791_best 2020-10-09  30801 PCPM     Rushcliffe    Communi… Access  
#>  9 341025 341025_best 2020-10-07   1900 <NA>     Unknown       Unknown  Access  
#> 10 340603 340603_imp  2020-10-16  30105 CHD Cli… Rushcliffe    Communi… Access  
#> # … with more rows, and 4 more variables: subcategory <chr>,
#> #   comment_type <chr>, comment_txt <chr>, crit <dbl>
```

### 4. Collect data

In case the data needs to be loaded from the MySQL database into the
global environment you can use the `collect()` function from `dplyr`.

``` r
# Collect tidy data
df_px_data_tidy <- db_px_data_tidy %>% 
  dplyr::collect()
```
