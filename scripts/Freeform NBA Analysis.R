# Analyze 2021-2022 season data ----

### Config ----

here::i_am("scripts/Freeform NBA Analysis.R")
devtools::load_all(here::here())
`%!in%` <- Negate(`%in%`)
library(magrittr)

## Script Init ----

## Config ----
season <- 2022
nba_stats <- tibble::tibble()
for (i in 2003:2022) {
  x <- scrape_bbref(i)
  nba_stats <- dplyr::bind_rows(nba_stats, x)
}

## Data Analysis ----

### Exploring Offensive Efficiency ----
bbref_stats <- nba_stats |>
  dplyr::filter(.data$season == 2022)

play_makers <- bbref_stats |>
  dplyr::filter(mp >= 500) |>
  dplyr::slice_max(.data$off_load, n = 25) |>
  dplyr::arrange(desc(.data$r_ts))

player_names <- play_makers$player

## Data Analysis ----

### Exploring Offensive Efficiency ----
bbref_stats <- nba_stats %>%
  dplyr::filter(season == 2022)

play_makers <- bbref_stats %>%
  dplyr::filter(mp >= 500) %>%
  dplyr::slice_max(.data$off_load, n = 25) %>%
  dplyr::arrange(desc(.data$r_ts))

player_names <- play_makers$player

play_makers %>%
  ggplot2::ggplot(ggplot2::aes(r_ts, c_tov)) +
  ggplot2::geom_point(alpha = 2, size = 5, ggplot2::aes(colour = x3pt_prof)) +
  ggplot2::labs(x = "r_ts%", y = "c_tov", title = "Relative True Shooting % vs. Adjusted Turnover %", subtitle = "Top 25 Offensive Loads, >= 500mp", caption = "Data Source: basketball-reference") +
  ggplot2::geom_text(label = player_names, size = 3)



