compile_subgroup_results <- function(dta_primary, ...) {
  dta_primary %>%
    filter(...) %>%
    select(-tests) %>%
    unnest(counts) %>%
    filter(oa_diagnosis == "Before") %>%
    drop_na() %>%
    mutate(
      p = n / N,
      p.ll = p_ci(n, N)[, 1],
      p.ul = p_ci(n, N)[, 2],
      value = est_ci(
        p,
        p.ll,
        p.ul,
        suffix = "%",
        scale = 100,
        accuracy = 0.1,
        format_paren = FALSE
      ),
    )
}
