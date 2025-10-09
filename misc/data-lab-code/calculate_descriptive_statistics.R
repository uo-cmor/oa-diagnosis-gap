calculate_descriptive_statistics <- function(data) {
  df <- data %>% 
    mutate(
      age = (birth_date %--% tja_date) %/% years(1),
      female = sex == "Female",
      oa_diagnosis = factor(
        case_when(is.na(oa_diagnosis_date) ~ "None",
                  oa_diagnosis_date < tja_date ~ "Before",
                  .default = "After"),
        c("Before", "After", "None")
      )
    )
  
  continuous <- df %>% 
    summarise(
      N = n(),
      across(
        c(nzdep18, interactions, age),
        list(mean = mean, sd = sd, median = median, lq = ~quantile(., 0.25),
             uq = ~quantile(., 0.75), total = sum)
      ),
      .by = oa_diagnosis
    ) %>% 
    pivot_longer(cols = -c(oa_diagnosis, N), names_to = c("variable", ".value"), names_sep = "_") %>% 
    select(-N, N)
  
  discrete <- df %>% 
    summarise(
      N = n(),
      across(c(female, maori, pacific, asian), sum),
      .by = oa_diagnosis
    ) %>% 
    pivot_longer(cols = -c(oa_diagnosis, N), names_to = "variable", values_to = "n") %>% 
    select(-N, N)
  
  list(continuous = continuous, discrete = discrete)
}