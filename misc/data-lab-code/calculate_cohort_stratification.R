calculate_cohort_stratification <- function(data) {
  # Generates the complete stratification of all variables of interest
  # To calculate particular groups, use e.g.:
  ## full_results %>%
  ##   filter(month_before == 0) %>%
  ##   group_by(<subgroup-variables>) %>% 
  ##   count(oa_diagnosis, wt = n) %>% mutate(N = sum(n), p = n / N) %>% ungroup()
  # Or for cumulative proportion by month relative to surgery:
  ## full_results %>%
  ##   group_by(<subgroup-variables>, month_before) %>% 
  ##   summarise(N = sum(n), n = sum(n * (oa_diagnosis == "Before")), p = n / N, .groups = "drop")
  data %>%
    crossing(month_before = -60:120) %>% 
    mutate(
      tja_year = year(tja_date),
      tja_age = (birth_date %--% tja_date) %/% years(1),
      age_grp = cut(tja_age, c(0, 60, 65, 70, 75, 80, Inf), right = FALSE,
                    labels = c("<60", "60-64", "65-69", "70-74", "75-79", "80+")),
      interactions = cut(interactions, c(0, quantile(interactions, c(0.25, 0.5, 0.75)), Inf),
                         right = FALSE),
      ref_date = tja_date %m-% months(month_before),
      oa_diagnosis = factor(
        case_when(is.na(oa_diagnosis_date) ~ "None",
                  oa_diagnosis_date < ref_date ~ "Before",
                  .default = "After"),
        c("Before", "After", "None")
      )
    ) %>% 
    count(tja, tja_year, month_before, sex, maori, pacific, asian, age_grp,
          nzdep18, practice_id, interactions, oa_diagnosis)
}