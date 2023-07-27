#' Script to scrape per 100 possession data from basketball reference
#'
#' @param season A numeric object that defines the ending year of the NBA season
#'
#' @return A tibble of per 100 possession stats from Basketball Reference for NBA players in the given season
#' @export
#'
scrape_bbref <- function(season) {
  library(magrittr)
  url <- paste0("https://www.basketball-reference.com/leagues/NBA_",season,"_per_poss.html")
  player_stats_per100 <- url |>
    xml2::read_html() |>
    rvest::html_table() |>
    .[[1]]

  ts_hist <- c(
    51.9,
    51.6,
    52.9,
    53.6,
    54.1,
    54.0,
    54.4,
    54.3,
    54.1,
    52.7,
    53.5,
    54.1,
    53.4,
    54.1,
    55.2,
    55.6,
    56.0,
    56.5,
    57.2,
    55.6,
    56.1
  )

  league_ts <- tibble::tibble(
    Season = 2003:2023, League_TS = ts_hist
  )

  ts_val <- league_ts |>
    dplyr::filter(Season == season) |>
    dplyr::pull(League_TS)

  num_cols <- c(
    'age',
    'g',
    'gs',
    'mp',
    'fg',
    'fga',
    'fg_percent',
    'x3p',
    'x3pa',
    'x3p_percent',
    'x2p',
    'x2pa',
    'x2p_percent',
    'ft',
    'fta',
    'ft_percent',
    'orb',
    'drb',
    'trb',
    'ast',
    'stl',
    'blk',
    'tov',
    'pf',
    'pts',
    'o_rtg',
    'd_rtg'
  )

  stats_100 <- player_stats_per100 |>
    janitor::remove_empty(which = c("rows","cols")) |>
    janitor::clean_names() |>
    dplyr::select(-rk) |>
    dplyr::filter(!player == "Player") |>
    dplyr::mutate(dplyr::across(dplyr::all_of(num_cols), as.double)) |>
    tibble::as_tibble() |>
    dplyr::group_by(player) |>
    dplyr::slice(1) |>
    dplyr::ungroup() |>
    dplyr::mutate(season = season,
                  x3pt_prof = (2/(1+exp(-x3pa))-1)*x3p_percent,
                  box_creation = ast*.1843+(pts+tov)*.0969-2.3021*(x3pt_prof)+.0582*(ast*(pts+tov)*x3pt_prof)-1.1942,
                  off_load = ((ast-(.38*box_creation))*.75)+fga+fta*.44+box_creation+tov,
                  c_tov = tov/off_load,
                  ts = 100*pts/(2*(fga+.44*fta)),
                  league_ts = ts_val,
                  r_ts = ts-league_ts)
}
