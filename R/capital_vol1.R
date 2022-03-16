#' Combine Capital Vol I components into a single character vector
#'
#' The data provided in this package separates out the components of the
#' text into lists to facilitate analysis, but it can also be handy to have
#' all of it in a single character vector. For example, you can then use a
#' function like `writeLines` to print it as a text file!
#'
#' @export

capital_vol1_book <- function() {
  fn_unnested <- unlist(
    lapply(
      names(capital_vol1$footnotes),
      function(x) {
        c(gsub("_0|_", " ", x), capital_vol1$footnotes[[x]])
      }
    ),
    use.names = FALSE
  )
 c(
   "Capital by Karl Marx (1867)",
   capital_vol1$toc,
   unlist(capital_vol1$body, use.names = FALSE),
   "Footnotes",
   fn_unnested
  )
}


#' Capital, Volume I, by Karl Marx (1867)
#'
#' This version of Capital was taken from the Marx/Engels Internet Archive
#' (marxists.org), which was based on the first English edition (1887),
#' translated by Samuel Moore and Edward Aveling, and edited by Frederick
#' Engels.
#'
#' To facilitate analysis and locating of footnotes (don't skip the footnotes
#' on a read!), the main text and footnotes are provided as named lists, with
#' the names taking the form "Chapter_01" to "Chapter_33".
#'
#' @format A named list, containing:
#' \describe{
#'   \item{toc}{Table of Contents: a character vector}
#'   \item{body}{Main text, named list, separated by chapter}
#'   \item{footnotes}{Footnotes, named list, separated by chapter}
#'   \item{credits}{credits, a character vector of length 1}
#' }
#' @source \url{https://www.marxists.org/archive/marx/works/1867-c1/}
"capital_vol1"
