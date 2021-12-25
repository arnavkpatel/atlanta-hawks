#' Script to scrape all data from basketball reference
#'
#' @param season A numeric object that defines the ending year of the NBA season
#'
#' @return A tibble of per 100 possession stats from Basketball Reference for NBA players in a given season
#' @export
#'
#' @examples
scrape_bbref <- function(season) {
  url <- paste0("https://www.basketball-reference.com/leagues/NBA_",season,"_per_poss.html")
  player_stats_per100 <- url %>% 
    read_html() %>% 
    html_table() %>% 
    .[[1]]
  
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
  
  stats_100 <- player_stats_per100 %>%
    janitor::remove_empty(.) %>% 
    janitor::clean_names() %>%
    dplyr::select(-rk) %>% 
    dplyr::filter(!player == "Player")
  dplyr::mutate(dplyr::across(dplyr::all_of(num_cols), as.double)) %>% 
    tidyr::drop_na() %>% 
    tibble::as_tibble() %>% 
    dplyr::group_by(player) %>% 
    dplyr::slice(1) %>% 
    dplyr::ungroup() %>% 
    dplyr::rename(paste0(num_cols,"_per100") = num_cols)
}
