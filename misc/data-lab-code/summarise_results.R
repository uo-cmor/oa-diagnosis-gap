summarise_results <- function(full_results, ...) {
  full_results %>%
    filter(month_before == 0) %>%
    group_by(...) %>%
    count(oa_diagnosis, wt = n, .drop = FALSE) %>% mutate(N = sum(n)) %>%
    group_by(oa_diagnosis) %>% 
    mutate(p_value = if (length(cur_group_rows()) > 1) prop.test(n, N)$p.value else NA_real_) %>% 
    ungroup() %>% 
    list()
}

summarise_results_by_month <- function(full_results, ...) {
  full_results %>%
    group_by(..., month_before) %>% 
    summarise(N = sum(n), n = sum(n * (oa_diagnosis == "Before")), .groups = "drop") %>% 
    list()
}
