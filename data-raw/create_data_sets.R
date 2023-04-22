source("data-raw/download_and_prep_functions.R")

# Scrape and format each volume
capital1_url <- "https://www.marxists.org/archive/marx/works/1867-c1/"
capital1_chapters <- lpad(1:33)
capital1_partbreaks <- list(1:3, 4:6, 7:11, 12:15, 16:18, 19:22, 23:25, 26:33)

capital2_url <- "https://www.marxists.org/archive/marx/works/1885-c2/"
capital2_chapters <- c(
  lpad(1:19),
  "20_01", "20_02", "20_03", "20_04", "21_01", "21_02"
)
capital2_partbreaks <- list(1:6, 7:17, 18:21)

capital3_url <- "https://www.marxists.org/archive/marx/works/1894-c3/"
capital3_chapters <- lpad(1:52)
capital3_partbreaks <- list(1:7, 8:12, 13:15, 16:20, 21:36, 37:47, 48:52)

capital_vol1 <- scrape_and_reformat(capital1_url, capital1_chapters)
capital_vol2 <- scrape_and_reformat(capital2_url, capital2_chapters)
capital_vol3 <- scrape_and_reformat(capital3_url, capital3_chapters)


# Additional post-processing:
capital_vol1 <- add_chapter_parts(capital_vol1, capital1_partbreaks)
capital_vol2 <- add_chapter_parts(capital_vol2, capital2_partbreaks)
capital_vol3 <- add_chapter_parts(capital_vol3, capital3_partbreaks)

# Add the data files to the package
usethis::use_data(capital_vol1, overwrite = TRUE)
usethis::use_data(capital_vol2, overwrite = TRUE)
usethis::use_data(capital_vol3, overwrite = TRUE)
