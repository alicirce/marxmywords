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

#' Capital, Volume II (1885)
#'
#' This volume of Capital was written by Marx in 1863-1878, and edited by Engels
#' for publication in 1885. This version of Capital was taken from the
#' Marx/Engels Internet Archive (marxists.org), and is based on the revised
#' second edition (1893).
#'
#' The text is stored as a data frame with four columns. The main text is
#' included in the "body" section. Note that the footnote numbering re-starts at
#' the beginning of each chapter.
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
"capital_vol2"

#' Capital, Volume III (1894)
#'
#' This volume of Capital was assembled from notes written by Marx between
#' 1863-1883 by Engels, and was first published in 1894. This version was taken
#' from the Marx/Engels Internet Archive (marxists.org), which was based on the
#' 1959 Edition from the Institute of Marxism-Leninism of the USSR.
#'
#' The text is stored as a data frame with four columns. The main text is
#' included in the "body" section. Note that the footnote numbering re-starts at
#' the beginning of each chapter.
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
"capital_vol3"

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

  # Table of Contents reformatting:
  # Add some white space padding to make levels clear
  tc <- capital_vol1$text[capital_vol1$section == "toc"]
  tc <- gsub("^Section", "  Section", tc)
  tc[grepl("^[A-Z]\\.", tc)] <- paste0("    ", tc[grepl("^[A-Z]\\.", tc)])
  tc[grepl("^[0-9]\\.", tc)] <- paste0("      ", tc[grepl("^[0-9]\\.", tc)])
  tc[grepl("^[a-z]\\.", tc)] <- paste0("        ", tc[grepl("^[a-z]\\.", tc)])

  # Footnote reformatting:
  # Numbering re-starts at each chapter, for legibility, add chapter titles
  fn_bound <- capital_vol1[capital_vol1$section == "footnotes", ]
  fn_bound$sort <- 1L
  footnote_headers <- data.frame(
    section = "footnotes",
    part = 0L,
    chapter = 0L:33L,
    text = c("Footnotes", paste0("Chapter ", 1:33)),
    sort = 0L
  )
  fn_bound <- rbind(fn_bound, footnote_headers)
  fn_bound <- fn_bound[with(fn_bound, order(chapter, sort)), ]

  c("Capital by Karl Marx (1867)",
    tc,
    capital_vol1$text[capital_vol1$section == "body"],
    fn_bound$text,
    "Credits",
    capital_vol1$text[capital_vol1$section %in% c("credits")]
  )
}

