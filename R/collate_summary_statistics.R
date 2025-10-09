collate_summary_statistics <- function(dta_primary, dta_monthly, dta_descriptives) {
  # Cohort characteristics
  continuous_mean <- dta_descriptives$continuous %>%
    select(variable, mean) %>%
    deframe()
  continuous_sd <- dta_descriptives$continuous %>%
    select(variable, sd) %>%
    deframe()
  discrete_N <- dta_descriptives$discrete %>%
    select(variable, n) %>%
    deframe()
  discrete_p <- dta_descriptives$discrete %>%
    select(variable, p) %>%
    deframe()

  # Counts by subgroup
  counts <- dta_primary %>%
    select(-tests) %>%
    unnest(counts) %>%
    filter(oa_diagnosis == "Before")

  N <- counts %>% select(group, N) %>% deframe()
  p <- counts %>% transmute(group, p = n / N) %>% deframe()

  # Counts by time relative to diagnosis
  by_time <- dta_monthly %>%
    unnest(data) %>%
    mutate(years_before = month_before / 12)
  years_before <- by_time %>%
    filter(years_before %in% 0:10) %>%
    mutate(p = 1 - n / first(n), .by = c(grouping, group))
  month_after <- by_time %>%
    filter(month_before %in% -1:0) %>%
    summarise(p = (first(n) - last(n)) / first(N), .by = c(grouping, group))

  p_by_time <- list(
    two_years = years_before %>% filter(years_before == 2) %>% select(group, p) %>% deframe(),
    one_year = years_before %>% filter(years_before == 1) %>% select(group, p) %>% deframe(),
    one_month = month_after %>% select(group, p) %>% deframe()
  )

  list(
    characteristics = list(
      mean = as.list(nmbr(continuous_mean, accuracy = 0.1)),
      sd = as.list(nmbr(continuous_sd, accuracy = 0.1)),
      N = as.list(nmbr(discrete_N)),
      p = as.list(prct(discrete_p, accuracy = 0.1))
    ),
    N = as.list(nmbr(N)),
    p = as.list(prct(p, accuracy = 0.1)),
    by_period = map(p_by_time, ~ as.list(prct(., accuracy = 0.1)))
  )
}
