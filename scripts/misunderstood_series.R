# Exploring the most misunderstood NBA players ----

## Project Overview ----

"Series breaking down film and analytically exploring the “most misunderstood” NBA players.
This will help to increase visibility of analytical concepts and break down misconceptions of many former and current players.
First, I will establish what these players are thought of in the zeitgeist or NBA fan community.
Then, I will explore if/how analytics, film, and the facts confirm or reject that."
### Individual Player Analysis ----

### Config ----
here::i_am("scripts/misunderstood_series.R")
devtools::load_all(here::here())
`%!in%` <- Negate(`%in%`)

### Script Initialization ----

# source("~/Desktop/Analytics Projects/Sports Analytics/atlanta-hawks/R/scrape_bbref.R")
min_season <- 2003
max_season <- 2023
nba_stats <- tibble::tibble()
for (i in min_season:max_season) {
  x <- scrape_bbref(i)
  nba_stats <- dplyr::bind_rows(nba_stats, x)
}

#### Dwight Howard ----

dwight <- nba_stats |>
  dplyr::mutate(mpg = mp/g) |>
  dplyr::relocate("season", .before = "age") |>
  dplyr::relocate("mpg", .after = "mp") |>
  dplyr::select(-c(pos, gs, pf, o_rtg, d_rtg)) |>
  dplyr::filter(player == "Dwight Howard",
                mpg >= 25.00,
                g >= 20)

