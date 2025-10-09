compile_timing_results <- function(dta_monthly, ...) {
  df <- dta_monthly %>% filter(...)

  if (nrow(df)) {
    df %>%
      unnest(data) %>%
      drop_na() %>%
      mutate(month = -month_before, p = n / N, p.ll = p_ci(n, N)[, 1], p.ul = p_ci(n, N)[, 2])
  } else {
    NULL
  }
}
