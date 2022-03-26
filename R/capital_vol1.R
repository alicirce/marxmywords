#' Capital, Volume I, by Karl Marx (1867)
#'
#' This version of Capital was taken from the Marx/Engels Internet Archive
#' (marxists.org), which was based on the first English edition (1887),
#' translated by Samuel Moore and Edward Aveling, and edited by Frederick
#' Engels.
#'
#' The text is stored as a data frame with four columns. The main text is
#' included in the "body" section, but don't skip the footnotes on a read,
#' they're a lot of fun. Note that the footnote numbering re-starts at the
#' beginning of each chapter.
#'
#' @format A data frame, containing four columns:
#' \describe{
#'   \item{section}{
#'     Section of book, one of:
#'       "toc" (Table of Contents),
#'       "body" (main text),
#'       "footnotes" (footnotes),
#'      "credits" (list of transcribers and HTML markup contributors)
#'     }
#'   \item{part}{Part of text; the main text is divided into 8 parts}
#'   \item{chapter}{Chapter of text: the main text is divided into 33 chapters}
#'   \item{text}{Text, usually about one paragraph or footnote per row. (This
#'     depends on how the HTML markup was done.)}
#' }
#' @source \url{https://www.marxists.org/archive/marx/works/1867-c1/}
"capital_vol1"

#' Combine Capital Vol I components into a single character vector
#'
#' The data provided in this package separates out the components of the
#' text into lists to facilitate analysis, but it can also be handy to have
#' all of it in a single character vector. For example, you can then use a
#' function like `writeLines` to print it as a text file!
#'
#' @export

capital_vol1_book <- function() {
  capital_vol1 <- getExportedValue(getNamespace(packageName()), "capital_vol1")
  capital_vol1$sort <- 1L

  # Numbering re-starts at each chapter, for legibility, add chapter titles
  footnote_headers <- data.frame(
    section = "footnotes",
    part = 0L,
    chapter = 0L:33L,
    text = c("Footnotes", paste0("Chapter ", 1:33)),
    sort = 0L
  )
  fn_bound <- rbind(
    capital_vol1[capital_vol1$section == "footnotes", ],
    footnote_headers
  )
  fn_bound <- fn_bound[with(fn_bound, order(chapter, sort)), ]
  fn_bound$sort <- NULL
  capital_vol1$sort <- NULL

  rebind <- rbind(
    capital_vol1[capital_vol1$section %in% c("toc", "body"), ],
    fn_bound,
    data.frame(section = "credits", part = 1L, chapter = 1L, text = "Credits"),
    capital_vol1[capital_vol1$section %in% c("credits"), ]
  )

  c("Capital by Karl Marx (1867)", rebind$text)
}

