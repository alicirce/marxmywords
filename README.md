
# marxmywords <img src="man/figures/marxsticker_small.png" align="right"/>

Capital, or Das Kapital, published in 1867 by Karl Marx, is one of the most 
important economic texts of the 19th century. This package makes it 
available for text analysis in R!

## Installation

You can install the development version of marxmywords like so:

``` r
devtools::install_github("alicirce/marxmywords")
```

## Example

After loading the package, the text should be available in your namepace. Let's
peek at the table of contents:

``` r
library(marxmywords)
library(dplyr)
capital_vol1 %>%
  filter(section == "toc")
```

This object is a dataframe. The text itself is stored in the column `text`,
the other columns indicate which section, part and chapter the text came from. 
Read more about the structure and source of this data frame in the package 
documentation:

```r
help(capital_vol1)
```

If you'd like to print it out to a text file to read as a book, there is a
convenience function:
``` r
book <- capital_vol1_book()
writeLines(book, "capital_vol1.txt")
```

Or you can count the number of occurrences of a word:

``` r
capital_vol1 %>%
  mutate(
    n_linen = stringr::str_count(text, "linen"),
    n_coat  = stringr::str_count(text, "coat"),
  ) %>%
  summarize(
    tot_linen = sum(n_linen),
    tot_coat  = sum(n_coat)
  )
```
