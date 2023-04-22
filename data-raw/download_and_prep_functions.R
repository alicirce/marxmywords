lpad <- function(x, n = 2) paste0(strrep(0,n - nchar(x)), x)
rm_slashr <- function(s) gsub("\\r", "", s)
rm_footnotes <- function(v) v[!grepl("^( )*footnotes", v, ignore.case = TRUE)]

tidy_whitespace <- function(v) {
  v <- unlist(strsplit(v, "\\n"))
  v <- v[!grepl("^ *$", v)]
  unique(gsub("^ *", "", v))
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

chapters_and_parts <- function(lbreaks) {
  names(lbreaks) <- seq_along(lbreaks)
  stack(lbreaks) %>%
    setNames(c("chapter", "part")) %>%
    mutate(part = as.integer(part))
}

add_chapter_parts <- function(book, breaks) {
  book %>%
    left_join(chapters_and_parts(breaks), by = "chapter") %>%
    select(section, part, chapter, text)
}

scrape_and_reformat <- function(base_url, chapter_substrings) {

  # define how to interpret html markup
  text_tags <- c("indentb", "fst", "fs", "quoteb", "quotec")
  fn_tags <- c("information", "transcriber") # ch17 and 25 use transcriber class

  # initialize objects for looping
  full_text <- data.frame(chapter = integer(0), text = character(0))
  full_toc <- c()
  full_fn <- data.frame(chapter = integer(0), text = character(0))
  full_credits <- c()

  for (chapter in chapter_substrings) {
    numeric_chapter <- as.integer(gsub("_.*", "", chapter))
    pretty_chapter_name <- paste("Chapter", numeric_chapter)
    # read page & get attributes
    link <- paste0(base_url, "ch", chapter, ".htm")
    page <- read_html(link) %>%
      html_elements("p,h3,h4,h5,h6")
    section_type <- tolower(html_attr(page, name = "class"))

    # sort page into text types
    basic_text_idx <- which(is.na(section_type)) # excludes blockquotes etc
    special_text_idx <- which(section_type %in% text_tags)
    information_idx <- which(section_type %in% fn_tags)
    has_footnotes <- length(information_idx) > 0

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
    if (has_footnotes) {
      fn_text <- page[information_idx[1]:tail(information_idx, 1)] %>%
        html_text2() %>%
        rm_slashr()
    } else {
      fn_text <- c()
    }


    # separate footnotes and credits
    credit_idx <- grepl("transcribed|markup", fn_text, ignore.case = TRUE)

    # combine text
    full_toc <- c(full_toc, pretty_chapter_name, toc_text)
    full_text <- rbind(
      full_text,
      data.frame(chapter = numeric_chapter, text = main_text)
    )
    if (has_footnotes) {
      # separate out credits and footnotes
      if (length(fn_text) > length(fn_text[credit_idx])) {
        full_fn <- rbind(
          full_fn,
          data.frame(chapter = numeric_chapter, text = fn_text[!credit_idx])
        )
      }
      full_credits <-  c(full_credits, fn_text[credit_idx])
    }
  }

  body_df <- full_text %>%
    mutate(section = "body") %>%
    select(section, chapter, text)

  footnote_df <- full_fn %>%
    mutate(section = "footnotes") %>%
    select(section, chapter, text)

  capital <- bind_rows(
    list(
      data.frame(
        section = "toc",
        chapter = 1L,
        text = tidy_whitespace(full_toc)
      ),
      body_df,
      footnote_df
    )
  )
  if (length(full_credits) > 0) {
    pretty_credits <- data.frame(
      section = "credits",
      chapter = 1L,
      text = prettify_credits(full_credits)
    )
    capital <- bind_rows(capital, pretty_credits)
  }
  capital
}
