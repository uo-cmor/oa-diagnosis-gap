compile_trend_results <- function(dta_primary) {
  dta_primary %>%
    filter(grouping == "Year of surgery") %>%
    select(-tests) %>%
    unnest(counts) %>%
    filter(oa_diagnosis == "Before") %>%
    mutate(
      p = n / N,
      p.ll = p_ci(n, N)[, 1],
      p.ul = p_ci(n, N)[, 2],
      year = as.integer(as.character(group))
    )
}

p_ci <- function(x, n, conf.level = 0.95) {
  z <- qnorm((1 + conf.level) / 2)
  z22n <- z^2 / (2 * n)

  p.c <- (x + 0.5) / n
  p.u <- (p.c + z22n + z * sqrt(p.c * (1 - p.c) / n + z22n / (2 * n))) / (1 + 2 * z22n)

  p.c <- (x - 0.5) / n
  p.l <- (p.c + z22n - z * sqrt(p.c * (1 - p.c) / n + z22n / (2 * n))) / (1 + 2 * z22n)

  cbind(pmax(p.l, 0), pmin(p.u, 1))
}
