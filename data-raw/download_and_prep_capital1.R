# Capital is broken up by chapter at this site:
home <- "https://www.marxists.org/archive/marx/works/1867-c1/"
# This script compiles each chapter together, and tidies it up a bit.

library(rvest)
library(dplyr)

lpad <- function(x, n = 2){
  paste0(strrep(0,n - nchar(x)), x)
}

rm_slashr <- function(s) {
  gsub("\\r", "", s)
}

rm_footnotes <- function(v) {
  v[!grepl("^( )*footnotes", tolower(v))]
}

tidy_whitespace <- function(v) {
  # White space removal
  v <- unlist(strsplit(v, "\\n"))
  v <- v[!grepl("^ *$", v)]
  unique(gsub("^ *", "", v))
}

prettify_toc <- function(toc) {
  tc <- tidy_whitespace(toc)

  # White space addition
  # Hierarchy: chapter, section, capital letters, numbers, lower letters
  tc <- gsub("^Section", "  Section", tc)
  tc[grepl("^[A-Z]\\.", tc)] <- paste0("    ", tc[grepl("^[A-Z]\\.", tc)])
  tc[grepl("^[0-9]\\.", tc)] <- paste0("      ", tc[grepl("^[0-9]\\.", tc)])
  tc[grepl("^[a-z]\\.", tc)] <- paste0("        ", tc[grepl("^[a-z]\\.", tc)])
  tc
}

prettify_credits <- function(credits) {
  tidied_credits <- gsub("(.*by )| \\(.*", "", tidy_whitespace(credits)) %>%
    strsplit(" & ") %>%
    unlist() %>%
    strsplit(" and ") %>%
    unlist() %>%
    unique() %>%
    paste0(collapse = ", ")
  paste0("Transcription, HTML mark-up and proofreading by ", tidied_credits)
}

#-----
# Bind chapters together:
# Extract title, tables of contents, text, and footnotes separately,
# then recombine.
text_tags <- c("indentb", "fst", "quoteb", "quotec")
fn_tags <- c("information", "transcriber") # ch17 and 25 use transcriber class
full_text <- list()
full_toc <- c()
full_fn <- list()
full_credits <- c()

for (chapter in lpad(1:33)) {
  chapter_name <- paste("Chapter", chapter, sep = "_")
  pretty_chapter_name <- paste("Chapter", as.numeric(chapter), sep = " ")
  # read page & get attributes
  link <- paste0(home, "ch", chapter, ".htm")
  page <- read_html(link) %>%
    html_elements("p,h3,h4,h5,h6")
  section_type <- html_attr(page, name = "class")

  # sort page into text types
  basic_text_idx <- which(is.na(section_type)) # excludes blockquotes etc
  special_text_idx <- which(section_type %in% text_tags)
  information_idx <- which(section_type %in% fn_tags)
  fn_start <- information_idx[1]
  fn_end <- tail(information_idx, 1)

  if (any(section_type == "toc", na.rm = TRUE)) {
    # if there's a toc, first row is just "contents", so increment by 1
    # elements of toc are tagged "index", "indexa" or "indentb"
    # (note that indentb can also be main text)
    # main text/titles starts with type "NA" again (hence the "-1")
    toc_start <- which(section_type == "toc")[1] + 1
    toc_end <- basic_text_idx[basic_text_idx > toc_start][1] - 1
    special_text_idx <- special_text_idx[special_text_idx > toc_end]
    toc_text <- page[toc_start:toc_end] %>%
      html_text2() %>%
      rm_slashr()
  } else {
    toc_text <- c()
  }

  # parse text from page
  main_text_idx <- sort(c(basic_text_idx, special_text_idx))
  main_text <- page[main_text_idx] %>%
    html_text2() %>%
    rm_slashr() %>%
    rm_footnotes()
  fn_text <- page[fn_start:fn_end] %>%
    html_text2() %>%
    rm_slashr()

  # separate footnotes and credits
  credit_idx <- grepl("transcribed|markup", tolower(fn_text))

  # combine text
  full_text[[chapter_name]] <- main_text
  full_toc <- c(full_toc, chapter_name, toc_text)
  full_fn[[chapter_name]]  <- fn_text[!credit_idx]
  full_credits <-  c(full_credits, fn_text[credit_idx])
}

# A little bit of clean-up & restructuring
capital_vol1 <- list(
  toc = prettify_toc(full_toc),
  body = full_text,
  footnotes = full_fn,
  credits = prettify_credits(full_credits)
)

# Add the data files to the package
usethis::use_data(capital_vol1, overwrite = TRUE)

