# Exploring the most misunderstood NBA players ----

## Project Overview ----

"Series breaking down film and analytically exploring the “most misunderstood” NBA players. 
This will help to increase visibility of analytical concepts and break down misconceptions of many former and current players. 
First, I will establish what these players are thought of in the zeitgeist or NBA fan community. 
Then, I will explore if/how analytics, film, and the facts confirm or reject that. I will more than likely need to use text mining to get perceptions of the public." 

### Individual Player Analysis ----

### Config ----
`%!in%` <- Negate(`%in%`)
source("~/Desktop/Analytics Projects/Sports Analytics/atlanta-hawks/R/scrape_bbref.R")
season <- 2022
nba_stats <- tibble::tibble()
for (i in 2003:2022) {
  x <- scrape_bbref(i)
  nba_stats <- dplyr::bind_rows(nba_stats, x)
}
nba_stats <- nba_stats %>% 
  dplyr::mutate(
    rank_ts = rank(.data$ts, ties.method = "min")
  ) %>% dplyr::mutate(
    
  )
#### Dwight Howard ----

dwight <- nba_stats %>% 
  dplyr::filter(player == "Dwight Howard") %>% 
  dplyr::select(-c(pos, g, gs, pf, o_rtg, d_rtg)) 

 
