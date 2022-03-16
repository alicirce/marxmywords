
# marxmywords

Capital, or Das Kapital, published in 1867 by Karl Marx, is one of the most 
important economic texts of the 19th century. This package makes it 
available for text analysis in R!

## Installation

You can install the development version of marxmywords like so:

``` r
devtools::install("marxmywords/marxmywords")
```

## Example

After loading the package, the text should be available in your namepace. Let's
peek at the table of contents:

``` r
library(marxmywords)
capital_vol1[["toc"]]
```

This object is a named list comprised of different sections of the book. To
combine them into a single character vector, we can do the following:

``` r
book <- capital_vol1_book()
```

You can save it as a txt file or other format:

``` r
writeLines(book, "capital_vol1.txt")
```

Or you can count the number of occurrences of a word:

``` r
vapply(
  capital_vol1[["body"]],
  function(x) {
    sum(lengths(regmatches(tolower(x), gregexpr("linen", tolower(x)))))
  },
  numeric(1)
)
```

