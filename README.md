
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hcesNutR <img src="man/figures/logo.png" align="right" height="139" alt="" />

<!-- badges: start -->
<!-- badges: end -->

The goal of hcesR is to create a package that will help with the
analysis of the Household Consumption Expenditure Survey (HCES) data. A
good source of HCES data is [the world bank microdata
repository](https://microdata.worldbank.org/). The package will contain
functions that will help with the analysis of HCES data. The package
also contains a
[sample_hces.dta](dzvoti.github.io/hcesNutR/data/sample_hces.dta) used
to demonstrate the use of the functions in the package, you can download
this data after installing the package by running
`hcesNutR::sample_hces()` in your R console. The package is still under
development and will be updated regularly.

## Reporting bugs

Please report any bugs or issues
[here](www.github.com/dzvoti/hcesNutR/issues).

## Installation

You can install the development version of hcesR2 from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("dzvoti/hcesNutR")
#> Downloading GitHub repo dzvoti/hcesNutR@HEAD
#> Warning in untar2(tarfile, files, list, exdir, restore_times): skipping pax
#> global extended headers

#> Warning in untar2(tarfile, files, list, exdir, restore_times): skipping pax
#> global extended headers
#> ggplot2 (3.4.3 -> 3.4.4) [CRAN]
#> vroom   (1.6.3 -> 1.6.4) [CRAN]
#> sp      (2.0-0 -> 2.1-1) [CRAN]
#> Installing 3 packages: ggplot2, vroom, sp
#> Installing packages into 'C:/Users/sbzlm3/AppData/Local/Temp/RtmpAH5YSo/temp_libpath82ec3fe92a8d'
#> (as 'lib' is unspecified)
#> package 'ggplot2' successfully unpacked and MD5 sums checked
#> package 'vroom' successfully unpacked and MD5 sums checked
#> package 'sp' successfully unpacked and MD5 sums checked
#> 
#> The downloaded binary packages are in
#>  C:\Users\sbzlm3\AppData\Local\Temp\Rtmp6dTppo\downloaded_packages
#> ── R CMD build ─────────────────────────────────────────────────────────────────
#>          checking for file 'C:\Users\sbzlm3\AppData\Local\Temp\Rtmp6dTppo\remotes69a07076509b\dzvoti-hcesNutR-bed3b7f/DESCRIPTION' ...     checking for file 'C:\Users\sbzlm3\AppData\Local\Temp\Rtmp6dTppo\remotes69a07076509b\dzvoti-hcesNutR-bed3b7f/DESCRIPTION' ...   ✔  checking for file 'C:\Users\sbzlm3\AppData\Local\Temp\Rtmp6dTppo\remotes69a07076509b\dzvoti-hcesNutR-bed3b7f/DESCRIPTION' (466ms)
#>       ─  preparing 'hcesNutR': (547ms)
#>    checking DESCRIPTION meta-information ...     checking DESCRIPTION meta-information ...   ✔  checking DESCRIPTION meta-information
#>   Warning:     Warning: unit_names_n_codes_df.Rd:16: unknown macro '\entries'
#>    Warning: unit_names_n_codes_df.Rd:17: unknown macro '\priority'
#>       ─  checking for LF line-endings in source and make files and shell scripts
#>       ─  checking for empty or unneeded directories
#>      NB: this package now depends on R (>=        NB: this package now depends on R (>= 3.5.0)
#>        WARNING: Added dependency on R >= 3.5.0 because serialized objects in
#>      serialize/load version 3 cannot be read in older versions of R.
#>      File(s) containing such objects:
#>        'hcesNutR/data/combined_food_list_v26072023.rds'
#>        'hcesNutR/data/consumption_unit_matches_v4_20092023.rds'
#>        'hcesNutR/data/matched_food_items_and_codes_v1_0_1_21092023.rds'
#>        'hcesNutR/data/matched_food_items_and_codes_v2_0_1_26092023.rds'
#>        'hcesNutR/data/non_standard_food_list.rds'
#>        'hcesNutR/data/standard_food_list.rds'
#>        'hcesNutR/data/standard_name_mappings_pairs.rds'
#>   ─  building 'hcesNutR_0.1.0.tar.gz'
#>      
#> 
#> Installing package into 'C:/Users/sbzlm3/AppData/Local/Temp/RtmpAH5YSo/temp_libpath82ec3fe92a8d'
#> (as 'lib' is unspecified)
```

``` r
library(hcesNutR)
```

## Example

This is a basic example which shows you the use of the functions in the
package. The example uses the
[sample_hces.dta](dzvoti.github.io/hcesNutR/data/sample_hces.dta) data
that is included in the package. You can download the data by running
`hcesNutR::sample_hces()` in your R console. The data is randomly
generated to mimic the structure of the [Fifth Integrated Household
Survey
2019-2020](https://microdata.worldbank.org/index.php/catalog/3818/related-materials)
an HCES of Malawi. The variables and structure of this data is found
[here](https://microdata.worldbank.org/index.php/catalog/3818/related-materials)

## Import and explore the sample data

``` r
# Import the data using the haven package from the tidyverse
sample_hces <-
  haven::read_dta(here::here("data", "mwi-ihs5-sample-data", "HH_MOD_G1_vMAPS.dta"))
```

``` r
# Preview first 5 rows
sample_hces |>
head() |>
  knitr::kable()
```

| case_id      | HHID                             | hh_g00_1 | hh_g00_2 | hh_g01 | hh_g01_oth | hh_g02 | hh_g03a | hh_g03b | hh_g03b_label | hh_g03b_oth | hh_g03c | hh_g03c_1 | hh_g04a | hh_g04b | hh_g04b_label | hh_g04b_oth | hh_g04c | hh_g04c_1 | hh_g05 | hh_g06a | hh_g06b | hh_g06b_label | hh_g06b_oth | hh_g06c | hh_g06c_1 | hh_g07a | hh_g07b | hh_g07b_label | hh_g07b_oth | hh_g07c | hh_g07c_1 |
|:-------------|:---------------------------------|---------:|---------:|-------:|:-----------|-------:|--------:|:--------|--------------:|:------------|--------:|----------:|--------:|:--------|--------------:|:------------|--------:|----------:|-------:|--------:|:--------|--------------:|:------------|--------:|----------:|--------:|:--------|--------------:|:------------|--------:|----------:|
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |        2 |        2 |      2 |            |    101 |      NA |         |            NA |             |      NA |        NA |      NA |         |            NA |             |      NA |        NA |     NA |      NA |         |            NA |             |      NA |        NA |      NA |         |            NA |             |      NA |        NA |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |        2 |        2 |      2 |            |    102 |      NA |         |            NA |             |      NA |        NA |      NA |         |            NA |             |      NA |        NA |     NA |      NA |         |            NA |             |      NA |        NA |      NA |         |            NA |             |      NA |        NA |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |        2 |        2 |      2 |            |    103 |      NA |         |            NA |             |      NA |        NA |      NA |         |            NA |             |      NA |        NA |     NA |      NA |         |            NA |             |      NA |        NA |      NA |         |            NA |             |      NA |        NA |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |        2 |        2 |      1 |            |    104 |       1 | 59      |            59 |             |      NA |        NA |      NA |         |            NA |             |      NA |        NA |     NA |      NA |         |            NA |             |      NA |        NA |      NA |         |            NA |             |      NA |        NA |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |        2 |        2 |      2 |            |    105 |      NA |         |            NA |             |      NA |        NA |      NA |         |            NA |             |      NA |        NA |     NA |      NA |         |            NA |             |      NA |        NA |      NA |         |            NA |             |      NA |        NA |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |        2 |        2 |      2 |            |    106 |      NA |         |            NA |             |      NA |        NA |      NA |         |            NA |             |      NA |        NA |     NA |      NA |         |            NA |             |      NA |        NA |      NA |         |            NA |             |      NA |        NA |

### Trim the data

In this example we will use `hcesNutR` functions to demonstrate
processing of `total` consumption data. The `total` consumption data is
the data that contains the total consumption of each food item by each
household. The other consumption columns contain values for consumption
from sources i.e. gifted, purchased, ownProduced. The workflow for
processing these is the same as demonstrated below.

``` r
# Trim the data to total consumption
sample_hces <-
  sample_hces |> 
  dplyr::select(case_id:HHID, hh_g01:hh_g03c_1)

# Preview
sample_hces |>
  head(5) |>
  knitr::kable()
```

| case_id      | HHID                             | hh_g01 | hh_g01_oth | hh_g02 | hh_g03a | hh_g03b | hh_g03b_label | hh_g03b_oth | hh_g03c | hh_g03c_1 |
|:-------------|:---------------------------------|-------:|:-----------|-------:|--------:|:--------|--------------:|:------------|--------:|----------:|
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |      2 |            |    101 |      NA |         |            NA |             |      NA |        NA |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |      2 |            |    102 |      NA |         |            NA |             |      NA |        NA |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |      2 |            |    103 |      NA |         |            NA |             |      NA |        NA |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |      1 |            |    104 |       1 | 59      |            59 |             |      NA |        NA |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |      2 |            |    105 |      NA |         |            NA |             |      NA |        NA |

## hcesnutR workflow

### Column Naming Conventions and Renaming

The sample_hces data is in stata format which contains data with short
column name codes that have associated “question” labels that explain
the contents of the data. To make the column names more interpretable,
the package provides the `rename_hces` function, which can be used to
rename the column codes to standard hces names used downstream.

The `rename_hces` function uses column names from the
`standard_name_mappings_pairs` dataset within the package.
Alternatively, a user can create their own name pairs or manually rename
their columns to the `standard` names.

It is important to note that all downstream functions in the `hcesNutR`
package work with standard names and will not work with the short column
names. Therefore, it is recommended to use the `rename_hces()` function
to ensure that the column names are consistent with the package’s naming
conventions.

For more information on how to use the `rename_hces` function, please
refer to the function’s documentation:
[`rename_hces`](https://dzvoti.github.io/hcesNutR/reference/rename_hces.html).

``` r
# Rename the variables
sample_hces <-
  hcesNutR::rename_hces(sample_hces, country_name = "MWI", survey_name = "IHS5")
#> 
#> ...
#> The following columns were renamed:
#> 
#>   hces_standard_name survey_variable_names
#> 1               hhid                  HHID
#> 2             consYN                hh_g01
#> 3           item_oth            hh_g01_oth
#> 4          item_code                hh_g02
#> 5         cons_quant               hh_g03a
#> 6         cons_unitA               hh_g03b
#> 7          cons_unit         hh_g03b_label
#> 8      cons_unit_oth           hh_g03b_oth
#> 9     cons_unit_size               hh_g03c

# View the results
sample_hces |>
  head(5) |>
  knitr::kable()
```

| case_id      | hhid                             | consYN | item_oth | item_code | cons_quant | cons_unitA | cons_unit | cons_unit_oth | cons_unit_size | hh_g03c_1 |
|:-------------|:---------------------------------|-------:|:---------|----------:|-----------:|:-----------|----------:|:--------------|---------------:|----------:|
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |      2 |          |       101 |         NA |            |        NA |               |             NA |        NA |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |      2 |          |       102 |         NA |            |        NA |               |             NA |        NA |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |      2 |          |       103 |         NA |            |        NA |               |             NA |        NA |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |      1 |          |       104 |          1 | 59         |        59 |               |             NA |        NA |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |      2 |          |       105 |         NA |            |        NA |               |             NA |        NA |

### Remove unconsumed food items

HCES surveys administer a standard questionaire to each household where
they are asked to conform whether they consumed the food items on their
standard list. If a household did not consume a food item, the value of
the ‘consYN’ is set to a constant. The `remove_unconsumed` function
removes all food items that were not consumed by the household. The
function takes in a data frame and the name of the column that contains
the consumption information. The function also takes in the value that
indicates that the food item was consumed.

``` r
# Remove unconsumed food items
sample_hces <- hcesNutR::remove_unconsumed(sample_hces, consCol = "consYN", consVal = 1)
#> Removing unconsumed food item records...
#> Unconsumed food item records removed succesfully
#> Number of records removed : 12488
#> Number of records remaining : 1712
#> 
#> ...
#> ...

# Preview the results
sample_hces
#> # A tibble: 1,712 × 10
#>    case_id      hhid          item_oth item_code cons_quant cons_unitA cons_unit
#>    <chr>        <chr>         <chr>    <dbl+lbl>      <dbl> <chr>      <dbl+lbl>
#>  1 201011000001 ee2d2915a43d… ""       104 [Mai…        1   59         59 [TABL…
#>  2 201011000001 ee2d2915a43d… ""       208 [Coc…        8   23         23 [OTHE…
#>  3 201011000001 ee2d2915a43d… ""       301 [Bea…        2.5 23         23 [OTHE…
#>  4 201011000001 ee2d2915a43d… ""       307 [Gro…        6   23         23 [OTHE…
#>  5 201011000001 ee2d2915a43d… ""       311 [Gro…        7.5 23         23 [OTHE…
#>  6 201011000001 ee2d2915a43d… ""       403 [Tan…        7.5 23         23 [OTHE…
#>  7 201011000001 ee2d2915a43d… "BIRD"   515 [Oth…        5.5 23         23 [OTHE…
#>  8 201011000001 ee2d2915a43d… ""       602 [Ban…        9   9B          9 [PIEC…
#>  9 201011000001 ee2d2915a43d… ""       604 [Pin…        2.5 23         23 [OTHE…
#> 10 201011000001 ee2d2915a43d… ""       701 [Fre…        3.5 23         23 [OTHE…
#> # ℹ 1,702 more rows
#> # ℹ 3 more variables: cons_unit_oth <chr>, cons_unit_size <dbl+lbl>,
#> #   hh_g03c_1 <dbl+lbl>
# Preview the results as table

sample_hces |>
  head(5) |>
  knitr::kable()
```

| case_id      | hhid                             | item_oth | item_code | cons_quant | cons_unitA | cons_unit | cons_unit_oth   | cons_unit_size | hh_g03c_1 |
|:-------------|:---------------------------------|:---------|----------:|-----------:|:-----------|----------:|:----------------|---------------:|----------:|
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |          |       104 |        1.0 | 59         |        59 |                 |             NA |        NA |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |          |       208 |        8.0 | 23         |        23 | MEDIUM PACKET   |             NA |        NA |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |          |       301 |        2.5 | 23         |        23 | TBE             |             NA |        NA |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |          |       307 |        6.0 | 23         |        23 | SMALL TINA FLAT |             NA |        NA |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |          |       311 |        7.5 | 23         |        23 | JAG             |             NA |        NA |

### Create two columns from each dbl+lbl column

The `create_dta_labels` function creates two columns from each dbl+lbl
(double plus label) column. The first column contains the numeric values
and the second column contains the labels. The function takes in a data
frame and finds all columns that contains the double plus label column.
The function returns a data frame with the new columns.

``` r
# Split dbl+lbl columns
sample_hces <- hcesNutR::create_dta_labels(sample_hces)

# Preview
sample_hces
#> # A tibble: 1,712 × 14
#>    case_id    hhid  item_oth item_code_code item_code_name cons_quant cons_unitA
#>    <chr>      <chr> <chr>             <dbl> <chr>               <dbl> <chr>     
#>  1 201011000… ee2d… ""                  104 Maize grain (…        1   59        
#>  2 201011000… ee2d… ""                  208 Cocoyam (masi…        8   23        
#>  3 201011000… ee2d… ""                  301 Bean, white           2.5 23        
#>  4 201011000… ee2d… ""                  307 Ground bean (…        6   23        
#>  5 201011000… ee2d… ""                  311 Groundnut (Sh…        7.5 23        
#>  6 201011000… ee2d… ""                  403 Tanaposi/Rape         7.5 23        
#>  7 201011000… ee2d… "BIRD"              515 Other (specif…        5.5 23        
#>  8 201011000… ee2d… ""                  602 Banana                9   9B        
#>  9 201011000… ee2d… ""                  604 Pineapple             2.5 23        
#> 10 201011000… ee2d… ""                  701 Fresh milk            3.5 23        
#> # ℹ 1,702 more rows
#> # ℹ 7 more variables: cons_unit_code <dbl>, cons_unit_name <chr>,
#> #   cons_unit_oth <chr>, cons_unit_size_code <dbl>, cons_unit_size_name <chr>,
#> #   hh_g03c_1_code <dbl>, hh_g03c_1_name <chr>

# Preview the results as table
sample_hces |>
  head(5) |>
  knitr::kable()
```

| case_id      | hhid                             | item_oth | item_code_code | item_code_name           | cons_quant | cons_unitA | cons_unit_code | cons_unit_name  | cons_unit_oth   | cons_unit_size_code | cons_unit_size_name | hh_g03c_1\_code | hh_g03c_1\_name |
|:-------------|:---------------------------------|:---------|---------------:|:-------------------------|-----------:|:-----------|---------------:|:----------------|:----------------|--------------------:|:--------------------|----------------:|:----------------|
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |          |            104 | Maize grain (not as ufa) |        1.0 | 59         |             59 | TABLESPOON      |                 |                  NA | NA                  |              NA | NA              |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |          |            208 | Cocoyam (masimbi)        |        8.0 | 23         |             23 | OTHER (SPECIFY) | MEDIUM PACKET   |                  NA | NA                  |              NA | NA              |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |          |            301 | Bean, white              |        2.5 | 23         |             23 | OTHER (SPECIFY) | TBE             |                  NA | NA                  |              NA | NA              |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |          |            307 | Ground bean (nzama)      |        6.0 | 23         |             23 | OTHER (SPECIFY) | SMALL TINA FLAT |                  NA | NA                  |              NA | NA              |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |          |            311 | Groundnut (Shelled)      |        7.5 | 23         |             23 | OTHER (SPECIFY) | JAG             |                  NA | NA                  |              NA | NA              |

### Data cleaning

Some HCES data surveys split consumption food item or their consumption
units into multiple columns. The `concatenate_columns` function cleans
the data by combining the split columns into one column. The function
can exclude values from contatenation by specifying the whole or part of
values to be excluded.

#### Example 1: Concatenate food item names

``` r
# Merge food item names
sample_hces <-
  hcesNutR::concatenate_columns(sample_hces,
                                c("item_code_name", "item_oth"),
                                "SPECIFY",
                                "item_code_name")

# Preview the results as table
sample_hces |>
  head(5) |>
  knitr::kable()
```

| case_id      | hhid                             | item_code_code | cons_quant | cons_unitA | cons_unit_code | cons_unit_name  | cons_unit_oth   | cons_unit_size_code | cons_unit_size_name | hh_g03c_1\_code | hh_g03c_1\_name | item_code_name           |
|:-------------|:---------------------------------|---------------:|-----------:|:-----------|---------------:|:----------------|:----------------|--------------------:|:--------------------|----------------:|:----------------|:-------------------------|
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |            104 |        1.0 | 59         |             59 | TABLESPOON      |                 |                  NA | NA                  |              NA | NA              | MAIZE GRAIN (NOT AS UFA) |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |            208 |        8.0 | 23         |             23 | OTHER (SPECIFY) | MEDIUM PACKET   |                  NA | NA                  |              NA | NA              | COCOYAM (MASIMBI)        |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |            301 |        2.5 | 23         |             23 | OTHER (SPECIFY) | TBE             |                  NA | NA                  |              NA | NA              | BEAN, WHITE              |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |            307 |        6.0 | 23         |             23 | OTHER (SPECIFY) | SMALL TINA FLAT |                  NA | NA                  |              NA | NA              | GROUND BEAN (NZAMA)      |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |            311 |        7.5 | 23         |             23 | OTHER (SPECIFY) | JAG             |                  NA | NA                  |              NA | NA              | GROUNDNUT (SHELLED)      |

#### Example 2: Concatenate food item units

``` r
# Merge consumption unit names. For units it is essential to remove parentesis as they are the major cause of duplicate units
sample_hces <-
  hcesNutR::concatenate_columns(
    sample_hces,
    c(
      "cons_unit_name",
      "cons_unit_oth",
      "cons_unit_size_name",
      "hh_g03c_1_name"
    ),
    "SPECIFY",
    "cons_unit_name",
    TRUE
  )

# Preview the results as table
sample_hces |>
  head(5) |>
  knitr::kable()
```

| case_id      | hhid                             | item_code_code | cons_quant | cons_unitA | cons_unit_code | cons_unit_size_code | hh_g03c_1\_code | item_code_name           | cons_unit_name  |
|:-------------|:---------------------------------|---------------:|-----------:|:-----------|---------------:|--------------------:|----------------:|:-------------------------|:----------------|
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |            104 |        1.0 | 59         |             59 |                  NA |              NA | MAIZE GRAIN (NOT AS UFA) | TABLESPOON      |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |            208 |        8.0 | 23         |             23 |                  NA |              NA | COCOYAM (MASIMBI)        | MEDIUM PACKET   |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |            301 |        2.5 | 23         |             23 |                  NA |              NA | BEAN, WHITE              | TBE             |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |            307 |        6.0 | 23         |             23 |                  NA |              NA | GROUND BEAN (NZAMA)      | SMALL TINA FLAT |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d |            311 |        7.5 | 23         |             23 |                  NA |              NA | GROUNDNUT (SHELLED)      | JAG             |

### Use the `select` and `rename` functions from the dplyr package to subset the columns containing food item name , food item code, food unit name and food unit code

``` r
sample_hces <- sample_hces |>
  dplyr::select(
    case_id,
    hhid,
    item_code_name,
    item_code_code,
    cons_unit_name,
    cons_unitA,
    cons_quant
  ) |>
  dplyr::rename(food_name = item_code_name,
                food_code = item_code_code,
                cons_unit_code = cons_unitA)

sample_hces |>
  head(5) |>
  knitr::kable()
```

| case_id      | hhid                             | food_name                | food_code | cons_unit_name  | cons_unit_code | cons_quant |
|:-------------|:---------------------------------|:-------------------------|----------:|:----------------|:---------------|-----------:|
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | MAIZE GRAIN (NOT AS UFA) |       104 | TABLESPOON      | 59             |        1.0 |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | COCOYAM (MASIMBI)        |       208 | MEDIUM PACKET   | 23             |        8.0 |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | BEAN, WHITE              |       301 | TBE             | 23             |        2.5 |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | GROUND BEAN (NZAMA)      |       307 | SMALL TINA FLAT | 23             |        6.0 |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | GROUNDNUT (SHELLED)      |       311 | JAG             | 23             |        7.5 |

### Match survey food items to standard food items

The `match_food_names` function is useful for standardising survey food
names. This is feasible due to an internal dataset of standard food item
names matched with their corresponding survey food names for supported
surveys. Alternatively users can use their own food matching names by
passing a csv to the function. See hcesNutR::food_list for csv
structure.

``` r
sample_hces <-
  match_food_names_v2(
    sample_hces,
    country = "MWI",
    survey = "IHS5",
    food_name_col = "food_name",
    food_code_col = "food_code",
    overwrite = FALSE
  )
#> 
#>  There are 76 out of 1712 rows, which represents 4.44% of the data. The missing values are shown in the pop up view:

sample_hces |>
  head(5) |>
  knitr::kable()
```

| case_id      | hhid                             | food_name                | food_code | cons_unit_name  | cons_unit_code | cons_quant | matched_food_name        | matched_food_code | food_match_source      |
|:-------------|:---------------------------------|:-------------------------|----------:|:----------------|:---------------|-----------:|:-------------------------|:------------------|:-----------------------|
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | MAIZE GRAIN (NOT AS UFA) |       104 | TABLESPOON      | 59             |        1.0 | MAIZE GRAIN (NOT AS UFA) | 104               | MWI-IHS5-standard-list |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | COCOYAM (MASIMBI)        |       208 | MEDIUM PACKET   | 23             |        8.0 | COCOYAM (MASIMBI)        | 208               | MWI-IHS5-standard-list |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | BEAN, WHITE              |       301 | TBE             | 23             |        2.5 | BEAN, WHITE              | 301               | MWI-IHS5-standard-list |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | GROUND BEAN (NZAMA)      |       307 | SMALL TINA FLAT | 23             |        6.0 | GROUND BEAN (NZAMA)      | 307               | MWI-IHS5-standard-list |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | GROUNDNUT (SHELLED)      |       311 | JAG             | 23             |        7.5 | GROUNDNUT (SHELLED)      | 311               | MWI-IHS5-standard-list |

### Match survey consumption units to standard consumption units

The `match_food_units_v2` function is useful for standardising survey
consumption units. This is feasible due to an internal dataset of
standard consumption units matched with their corresponding survey
consumption units for supported surveys. Alternatively users can
download our template from `hcesNutR::unit_names_n_codes_df` and modify
it to use their own consumption unit matching names.

``` r
sample_hces <-
  match_food_units_v2(
    sample_hces,
    country = "MWI",
    survey = "IHS5",
    unit_name_col = "cons_unit_name",
    unit_code_col = "cons_unit_code",
    matches_csv = NULL,
    overwrite = FALSE
  )
#> 
#>  There are 15 out of 1712 rows with unmatched units, which represents 0.88% of the data. The missing values are shown in the pop up view:

sample_hces |>
  head(5) |>
  knitr::kable()
```

| case_id      | hhid                             | food_name                | food_code | cons_unit_name  | cons_unit_code | cons_quant | matched_food_name        | matched_food_code | food_match_source      | matched_cons_unit_name | matched_cons_unit_code | cons_unit_code_source |
|:-------------|:---------------------------------|:-------------------------|----------:|:----------------|:---------------|-----------:|:-------------------------|:------------------|:-----------------------|:-----------------------|:-----------------------|:----------------------|
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | MAIZE GRAIN (NOT AS UFA) |       104 | TABLESPOON      | 59             |        1.0 | MAIZE GRAIN (NOT AS UFA) | 104               | MWI-IHS5-standard-list | TABLE SPOON            | 59                     | 2                     |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | COCOYAM (MASIMBI)        |       208 | MEDIUM PACKET   | 23             |        8.0 | COCOYAM (MASIMBI)        | 208               | MWI-IHS5-standard-list | MEDIUM PACKET          | 51                     | 2                     |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | BEAN, WHITE              |       301 | TBE             | 23             |        2.5 | BEAN, WHITE              | 301               | MWI-IHS5-standard-list | TBE                    | 22                     | 2                     |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | GROUND BEAN (NZAMA)      |       307 | SMALL TINA FLAT | 23             |        6.0 | GROUND BEAN (NZAMA)      | 307               | MWI-IHS5-standard-list | SMALL TINA FLAT        | 25A                    | 2                     |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | GROUNDNUT (SHELLED)      |       311 | JAG             | 23             |        7.5 | GROUNDNUT (SHELLED)      | 311               | MWI-IHS5-standard-list | JAG                    | 23                     | 4                     |

### Add regions and districts to the data

Identify the HCES module that contains household identifiers. In some
cases this will already be present in the HCES data and should be
skipped. From the household identifiers select the ones that are
required and add to the data. In this example we will add the region and
district identifiers to the data from the hh_mod_a\_filt.dta file.

``` r
# Import household identifiers from the hh_mod_a_filt.dta file
household_identifiers <-
  haven::read_dta(here::here("data", "mwi-ihs5-sample-data", "hh_mod_a_filt_vMAPS.dta")) |>
  # subset the identifiers and keep only the ones needed.
  dplyr::select(case_id, HHID, region) |>
  dplyr::rename(hhid = HHID)

# Add the identifiers to the data
sample_hces <-
  dplyr::left_join(sample_hces, household_identifiers, by = c("hhid", "case_id"))

sample_hces |>
  head() |>
  knitr::kable()
```

| case_id      | hhid                             | food_name                | food_code | cons_unit_name  | cons_unit_code | cons_quant | matched_food_name        | matched_food_code | food_match_source      | matched_cons_unit_name | matched_cons_unit_code | cons_unit_code_source | region |
|:-------------|:---------------------------------|:-------------------------|----------:|:----------------|:---------------|-----------:|:-------------------------|:------------------|:-----------------------|:-----------------------|:-----------------------|:----------------------|-------:|
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | MAIZE GRAIN (NOT AS UFA) |       104 | TABLESPOON      | 59             |        1.0 | MAIZE GRAIN (NOT AS UFA) | 104               | MWI-IHS5-standard-list | TABLE SPOON            | 59                     | 2                     |      3 |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | COCOYAM (MASIMBI)        |       208 | MEDIUM PACKET   | 23             |        8.0 | COCOYAM (MASIMBI)        | 208               | MWI-IHS5-standard-list | MEDIUM PACKET          | 51                     | 2                     |      3 |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | BEAN, WHITE              |       301 | TBE             | 23             |        2.5 | BEAN, WHITE              | 301               | MWI-IHS5-standard-list | TBE                    | 22                     | 2                     |      3 |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | GROUND BEAN (NZAMA)      |       307 | SMALL TINA FLAT | 23             |        6.0 | GROUND BEAN (NZAMA)      | 307               | MWI-IHS5-standard-list | SMALL TINA FLAT        | 25A                    | 2                     |      3 |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | GROUNDNUT (SHELLED)      |       311 | JAG             | 23             |        7.5 | GROUNDNUT (SHELLED)      | 311               | MWI-IHS5-standard-list | JAG                    | 23                     | 4                     |      3 |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | TANAPOSI/RAPE            |       403 | BAKERY DONAS    | 23             |        7.5 | TANAPOSI/RAPE            | 403               | MWI-IHS5-standard-list | BAKERY DONAS           | 23                     | 4                     |      3 |

### Create a measure id column

The `create_measure_id` function creates a measure id column that is
used to identify the consumption measure of each food item. The function
takes in a data frame and the name of the column that contains the
consumption information. The function also takes in the value that
indicates that the food item was consumed.

``` r
# Create measure id column
sample_hces <-
  create_measure_id(
    sample_hces,
    country = "MWI",
    survey = "IHS5",
    cols = c("region", "matched_cons_unit_code", "matched_food_code"),
    include_ISOs = FALSE
  )

sample_hces |>
  head(5) |>
  knitr::kable()
```

| case_id      | hhid                             | food_name                | food_code | cons_unit_name  | cons_unit_code | cons_quant | matched_food_name        | matched_food_code | food_match_source      | matched_cons_unit_name | matched_cons_unit_code | cons_unit_code_source | region | measure_id |
|:-------------|:---------------------------------|:-------------------------|----------:|:----------------|:---------------|-----------:|:-------------------------|:------------------|:-----------------------|:-----------------------|:-----------------------|:----------------------|-------:|:-----------|
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | MAIZE GRAIN (NOT AS UFA) |       104 | TABLESPOON      | 59             |        1.0 | MAIZE GRAIN (NOT AS UFA) | 104               | MWI-IHS5-standard-list | TABLE SPOON            | 59                     | 2                     |      3 | 3-59-104   |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | COCOYAM (MASIMBI)        |       208 | MEDIUM PACKET   | 23             |        8.0 | COCOYAM (MASIMBI)        | 208               | MWI-IHS5-standard-list | MEDIUM PACKET          | 51                     | 2                     |      3 | 3-51-208   |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | BEAN, WHITE              |       301 | TBE             | 23             |        2.5 | BEAN, WHITE              | 301               | MWI-IHS5-standard-list | TBE                    | 22                     | 2                     |      3 | 3-22-301   |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | GROUND BEAN (NZAMA)      |       307 | SMALL TINA FLAT | 23             |        6.0 | GROUND BEAN (NZAMA)      | 307               | MWI-IHS5-standard-list | SMALL TINA FLAT        | 25A                    | 2                     |      3 | 3-25A-307  |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | GROUNDNUT (SHELLED)      |       311 | JAG             | 23             |        7.5 | GROUNDNUT (SHELLED)      | 311               | MWI-IHS5-standard-list | JAG                    | 23                     | 4                     |      3 | 3-23-311   |

### Import food conversion factors.

The available data comes with a \`food_conversion fcators file which has
conversion fcators that link the food names and units to their
corresponding

``` r
# Import food conversion factors file
IHS5_conv_fct <-
  readr::read_csv(here::here("data","mwi-ihs5-sample-data","IHS5_UNIT_CONVERSION_FACTORS_vMAPS.csv"))
#> Rows: 2391 Columns: 7
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ","
#> chr (4): food_item_name, unit_code, unit_name, measure_id
#> dbl (3): region, food_item_code, factor
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

IHS5_conv_fct |>
  head(10) |>
  knitr::kable()
```

| region | food_item_name                  | food_item_code | unit_code | unit_name              | measure_id | factor |
|-------:|:--------------------------------|---------------:|:----------|:-----------------------|:-----------|-------:|
|      1 | MAIZE UFA MGAIWA (NORMAL FLOUR) |            101 | 97        | BASIN                  | 1-97-101   |  3.400 |
|      2 | MAIZE UFA MGAIWA (NORMAL FLOUR) |            101 | 97        | BASIN                  | 2-97-101   |  3.400 |
|      3 | MAIZE UFA MGAIWA (NORMAL FLOUR) |            101 | 97        | BASIN                  | 3-97-101   |  3.400 |
|      3 | MAIZE UFA MGAIWA (NORMAL FLOUR) |            101 | 84        | CUP                    | 3-84-101   |  0.445 |
|      3 | MAIZE UFA MGAIWA (NORMAL FLOUR) |            101 | 82        | 3LITRE BUCKET          | 3-82-101   |  2.328 |
|      1 | MAIZE UFA MGAIWA (NORMAL FLOUR) |            101 | 25        | TINA                   | 1-25-101   |  0.323 |
|      2 | MAIZE UFA MGAIWA (NORMAL FLOUR) |            101 | 25        | TINA                   | 2-25-101   |  0.245 |
|      3 | MAIZE UFA MGAIWA (NORMAL FLOUR) |            101 | 25        | TINA                   | 3-25-101   |  0.300 |
|      1 | MAIZE UFA MGAIWA (NORMAL FLOUR) |            101 | 26        | 5 LITRE BUCKET CHIGOBA | 1-26-101   |  3.880 |
|      2 | MAIZE UFA MGAIWA (NORMAL FLOUR) |            101 | 26        | 5 LITRE BUCKET CHIGOBA | 2-26-101   |  3.880 |

Check if the conversion factors file contain all the expected conversion
factors for the hces data being processed.

``` r
# Check conversion factors 
check_conv_fct(hces_df = sample_hces, conv_fct_df = IHS5_conv_fct)
#> There are 1334 out of 1408 have missing conversion factors.
#> This represents 94.74% of the data.
#> Please fix your conversion factors file before trying again.
#> NOTE: Use View() to see the missing conversion factors.
#> # A tibble: 1,334 × 15
#>    case_id    hhid  food_name food_code cons_unit_name cons_unit_code cons_quant
#>    <chr>      <chr> <chr>         <dbl> <chr>          <chr>               <dbl>
#>  1 201011000… e6ff… MAIZE UF…       103 KILOGRAMME     1                     6  
#>  2 201011000… e569… FINGER M…       107 KILOGRAM       23                    2.5
#>  3 201011000… aaf8… SPAGHETT…       114 KILOGRAM       23                    6.5
#>  4 201011000… 032c… BEAN, BR…       302 KILOGRAM       23                    1  
#>  5 201011000… dd9a… FRESH FI…      5031 KILOGRAMME     1                     8.5
#>  6 201011000… 6bb7… TINNED M…       512 KILOGRAMME     1                     0.5
#>  7 201011000… 23d0… FREEZES …       906 KILOGRAMME     1                     5  
#>  8 201011000… e6ff… PEARL MI…       109 HEAP           10                    5  
#>  9 201011000… b52b… BREAD           111 HEAP           10                    7  
#> 10 201011000… 11bd… INFANT F…       116 HEAP           10                    3  
#> # ℹ 1,324 more rows
#> # ℹ 8 more variables: matched_food_name <chr>, matched_food_code <chr>,
#> #   food_match_source <chr>, matched_cons_unit_name <chr>,
#> #   matched_cons_unit_code <chr>, cons_unit_code_source <chr>, region <dbl>,
#> #   measure_id <chr>
```

Calculate weight of food items in kilograms.

``` r
sample_hces <-
  apply_wght_conv_fct(
    hces_df = sample_hces,
    conv_fct_df = IHS5_conv_fct,
    factor_col = "factor",
    measure_id_col = "measure_id",
    wt_kg_col = "wt_kg",
    cons_qnty_col = "cons_quant",
    allowDuplicates = TRUE
  )

sample_hces |>
  head(10) |>
  knitr::kable()
```

| case_id      | hhid                             | food_name                | food_code | cons_unit_name     | cons_unit_code | cons_quant | matched_food_name                       | matched_food_code | food_match_source      | matched_cons_unit_name | matched_cons_unit_code | cons_unit_code_source | region | measure_id | factor | wt_kg |
|:-------------|:---------------------------------|:-------------------------|----------:|:-------------------|:---------------|-----------:|:----------------------------------------|:------------------|:-----------------------|:-----------------------|:-----------------------|:----------------------|-------:|:-----------|-------:|------:|
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | MAIZE GRAIN (NOT AS UFA) |       104 | TABLESPOON         | 59             |        1.0 | MAIZE GRAIN (NOT AS UFA)                | 104               | MWI-IHS5-standard-list | TABLE SPOON            | 59                     | 2                     |      3 | 3-59-104   |     NA |    NA |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | COCOYAM (MASIMBI)        |       208 | MEDIUM PACKET      | 23             |        8.0 | COCOYAM (MASIMBI)                       | 208               | MWI-IHS5-standard-list | MEDIUM PACKET          | 51                     | 2                     |      3 | 3-51-208   |     NA |    NA |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | BEAN, WHITE              |       301 | TBE                | 23             |        2.5 | BEAN, WHITE                             | 301               | MWI-IHS5-standard-list | TBE                    | 22                     | 2                     |      3 | 3-22-301   |     NA |    NA |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | GROUND BEAN (NZAMA)      |       307 | SMALL TINA FLAT    | 23             |        6.0 | GROUND BEAN (NZAMA)                     | 307               | MWI-IHS5-standard-list | SMALL TINA FLAT        | 25A                    | 2                     |      3 | 3-25A-307  |     NA |    NA |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | GROUNDNUT (SHELLED)      |       311 | JAG                | 23             |        7.5 | GROUNDNUT (SHELLED)                     | 311               | MWI-IHS5-standard-list | JAG                    | 23                     | 4                     |      3 | 3-23-311   |     NA |    NA |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | TANAPOSI/RAPE            |       403 | BAKERY DONAS       | 23             |        7.5 | TANAPOSI/RAPE                           | 403               | MWI-IHS5-standard-list | BAKERY DONAS           | 23                     | 4                     |      3 | 3-23-403   |     NA |    NA |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | BIRD                     |       515 | N/A                | 23             |        5.5 | OTHER POULTRY - GUINEA FOWL, DOVES, ETC | 509               | maps-team              | N/A                    | 23                     | 4                     |      3 | 3-23-509   |     NA |    NA |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | BANANA                   |       602 | PIECE MEDIUM       | 9B             |        9.0 | BANANA                                  | 602               | MWI-IHS5-standard-list | PIECE MEDIUM           | 9B                     | 1                     |      3 | 3-9B-602   |   0.08 |  0.72 |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | PINEAPPLE                |       604 | SMALL BOX TEA BAGS | 23             |        2.5 | PINEAPPLE                               | 604               | MWI-IHS5-standard-list | SMALL BOX TEA BAGS     | 23                     | 4                     |      3 | 3-23-604   |     NA |    NA |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | FRESH MILK               |       701 | QUARTER            | 23             |        3.5 | FRESH MILK                              | 701               | MWI-IHS5-standard-list | QUARTER                | 80                     | 2                     |      3 | 3-80-701   |     NA |    NA |

# Calculate AFE/AME and add to the data

## Assumptions

Merge HH demographic data with AME/AFE factors Men’s weight: 65kg
(assumption) Women’s weight: 55kg (from DHS) PAL: 1.6X the BMR

## Import data required

In order to calculate the AFE and AME metrics we require the following
data: - Household roster with the sex and age of each individual -
Household health - AFE and AME factors

``` r
# Import data of the roster and health modules of the IHS5 survey
ihs5_roster <-
  haven::read_dta(here::here("data", "mwi-ihs5-sample-data", "HH_MOD_B_vMAPS.dta"))
ihs5_health <-
  haven::read_dta(here::here("data", "mwi-ihs5-sample-data", "HH_MOD_D_vMAPS.dta"))

# Import data of the AME/AFE factors and specifications
ame_factors <-
  read.csv(here::here(
    "data",
    "mwi-ihs5-sample-data",
    "IHS5_AME_FACTORS_vMAPS.csv"
  )) |>
  janitor::clean_names()

ame_spec_factors <-
  read.csv(here::here("data", "mwi-ihs5-sample-data", "IHS5_AME_SPEC_vMAPS.csv")) |>
  janitor::clean_names() |>
  # Rename the population column to cat and select the relevant columns
  dplyr::rename(cat = population) |>
  dplyr::select(cat, ame_spec, afe_spec)
```

## Extra energy requirements for pregnancy

``` r
# # Extra energy requirements for pregnancy and Illness
pregnantPersons <- ihs5_health |>
    dplyr::filter(hh_d05a == 28 | hh_d05b == 28) |> # NOTE: 28 is the code for pregnancy in this survey
    dplyr::mutate(ame_preg = 0.11, afe_preg = 0.14) |> # NOTE: where do these values come from, DHS?
    dplyr::select(HHID, ame_preg, afe_preg)

# Preview
pregnantPersons |>
    head() |>
    knitr::kable()
```

| HHID | ame_preg | afe_preg |
|:-----|---------:|---------:|

# Process HH roster data

``` r
# Process the roster data and rename variables to be more intuitive
aMFe_summaries <- ihs5_roster |>
  # Rename the variables to be more intuitive
  dplyr::rename(sex = hh_b03, age_y = hh_b05a, age_m = hh_b05b) |>
  dplyr::mutate(age_m_total = (age_y * 12 + age_m)) |> # NOTE: why not just use age as below.
  # Add the AME/AFE factors to the roster data
  dplyr::left_join(ame_factors, by = c("age_y" = "age")) |> # Why use only age here and neglect months e.g 4.9years is close to 5 No??
  dplyr::mutate(
    ame_base = dplyr::case_when(sex == 1 ~ ame_m, sex == 2 ~ ame_f),
    afe_base = dplyr::case_when(sex == 1 ~ afe_m, sex == 2 ~ afe_f),
    age_u1_cat = dplyr::case_when(
      # NOTE: Round here will ensure that decimals are not ommited in the calculation.
      round(age_m_total) %in% 0:5 ~ "0-5 months",
      round(age_m_total) %in% 6:8 ~ "6-8 months",
      round(age_m_total) %in% 9:11 ~ "9-11 months"
    )
  ) |>
  # Add the AME/AFE factors for the specific age categories
  dplyr::left_join(ame_spec_factors, by = c("age_u1_cat" = "cat")) |>
  # Dietary requirements for children under 1 year old
  dplyr::mutate(
    ame_lac = dplyr::case_when(age_y < 2 ~ 0.19),
    afe_lac = dplyr::case_when(age_y < 2 ~ 0.24)
  ) |>
  dplyr::rowwise() |>
  # TODO: Will it not be better to have the pregnancy values added at the same time here?
  dplyr::mutate(ame = sum(c(ame_base, ame_spec, ame_lac), na.rm = TRUE),
                afe = sum(c(afe_base, afe_spec, afe_lac), na.rm = TRUE)) |>
  # Calculate number of individuals in the households
  dplyr::group_by(HHID) |>
  dplyr::summarize(
    hh_persons = dplyr::n(),
    hh_ame = sum(ame),
    hh_afe = sum(afe)
  ) |>
  # Merge with the pregnancy and illness data
  dplyr::left_join(pregnantPersons, by = "HHID") |>
  dplyr::rowwise() |>
  dplyr::mutate(hh_ame = sum(c(hh_ame, ame_preg), na.rm = T),
                hh_afe = sum(c(hh_afe, afe_preg), na.rm = T)) |>
  dplyr::ungroup() |>
  # Fix single household factors
  dplyr::mutate(
    hh_ame = dplyr::if_else(hh_persons == 1, 1, hh_ame),
    hh_afe = dplyr::if_else(hh_persons == 1, 1, hh_afe)
  ) |>
  dplyr::select(HHID, hh_persons, hh_ame, hh_afe) |>
  dplyr::rename(hhid = HHID)

# Preview
aMFe_summaries |> head() |> knitr::kable()
```

| hhid                             | hh_persons | hh_ame | hh_afe |
|:---------------------------------|-----------:|-------:|-------:|
| 032c1ecdd61b169337828a2dfea5fe41 |          9 |   7.13 |   9.00 |
| 0407a23ba7a92640fd4a1cac86332930 |          3 |   2.77 |   3.50 |
| 044f7b15139e65707a4aee879ee3b8c8 |          5 |   2.95 |   3.73 |
| 05149c2e93c758f40e0198a01a80dde1 |          5 |   3.07 |   3.88 |
| 0703626bfdb45f5269243b2c397309e8 |          4 |   2.02 |   2.55 |
| 0f48328d013904487684c19e56c8f04c |          4 |   3.08 |   3.90 |

# Join the AFE/AME data to our Household Consumption and Expenditure survey data

``` r
sample_hces <- sample_hces |> 
  dplyr::left_join(aMFe_summaries)
#> Joining with `by = join_by(hhid)`

sample_hces |> 
  head(10) |> 
  knitr::kable()
```

| case_id      | hhid                             | food_name                | food_code | cons_unit_name     | cons_unit_code | cons_quant | matched_food_name                       | matched_food_code | food_match_source      | matched_cons_unit_name | matched_cons_unit_code | cons_unit_code_source | region | measure_id | factor | wt_kg | hh_persons | hh_ame | hh_afe |
|:-------------|:---------------------------------|:-------------------------|----------:|:-------------------|:---------------|-----------:|:----------------------------------------|:------------------|:-----------------------|:-----------------------|:-----------------------|:----------------------|-------:|:-----------|-------:|------:|-----------:|-------:|-------:|
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | MAIZE GRAIN (NOT AS UFA) |       104 | TABLESPOON         | 59             |        1.0 | MAIZE GRAIN (NOT AS UFA)                | 104               | MWI-IHS5-standard-list | TABLE SPOON            | 59                     | 2                     |      3 | 3-59-104   |     NA |    NA |         10 |      9 |  11.39 |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | COCOYAM (MASIMBI)        |       208 | MEDIUM PACKET      | 23             |        8.0 | COCOYAM (MASIMBI)                       | 208               | MWI-IHS5-standard-list | MEDIUM PACKET          | 51                     | 2                     |      3 | 3-51-208   |     NA |    NA |         10 |      9 |  11.39 |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | BEAN, WHITE              |       301 | TBE                | 23             |        2.5 | BEAN, WHITE                             | 301               | MWI-IHS5-standard-list | TBE                    | 22                     | 2                     |      3 | 3-22-301   |     NA |    NA |         10 |      9 |  11.39 |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | GROUND BEAN (NZAMA)      |       307 | SMALL TINA FLAT    | 23             |        6.0 | GROUND BEAN (NZAMA)                     | 307               | MWI-IHS5-standard-list | SMALL TINA FLAT        | 25A                    | 2                     |      3 | 3-25A-307  |     NA |    NA |         10 |      9 |  11.39 |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | GROUNDNUT (SHELLED)      |       311 | JAG                | 23             |        7.5 | GROUNDNUT (SHELLED)                     | 311               | MWI-IHS5-standard-list | JAG                    | 23                     | 4                     |      3 | 3-23-311   |     NA |    NA |         10 |      9 |  11.39 |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | TANAPOSI/RAPE            |       403 | BAKERY DONAS       | 23             |        7.5 | TANAPOSI/RAPE                           | 403               | MWI-IHS5-standard-list | BAKERY DONAS           | 23                     | 4                     |      3 | 3-23-403   |     NA |    NA |         10 |      9 |  11.39 |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | BIRD                     |       515 | N/A                | 23             |        5.5 | OTHER POULTRY - GUINEA FOWL, DOVES, ETC | 509               | maps-team              | N/A                    | 23                     | 4                     |      3 | 3-23-509   |     NA |    NA |         10 |      9 |  11.39 |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | BANANA                   |       602 | PIECE MEDIUM       | 9B             |        9.0 | BANANA                                  | 602               | MWI-IHS5-standard-list | PIECE MEDIUM           | 9B                     | 1                     |      3 | 3-9B-602   |   0.08 |  0.72 |         10 |      9 |  11.39 |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | PINEAPPLE                |       604 | SMALL BOX TEA BAGS | 23             |        2.5 | PINEAPPLE                               | 604               | MWI-IHS5-standard-list | SMALL BOX TEA BAGS     | 23                     | 4                     |      3 | 3-23-604   |     NA |    NA |         10 |      9 |  11.39 |
| 201011000001 | ee2d2915a43d589af42a8b88c279698d | FRESH MILK               |       701 | QUARTER            | 23             |        3.5 | FRESH MILK                              | 701               | MWI-IHS5-standard-list | QUARTER                | 80                     | 2                     |      3 | 3-80-701   |     NA |    NA |         10 |      9 |  11.39 |
