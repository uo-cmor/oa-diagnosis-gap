compile_descriptives_table <- function(dta_descriptives) {
  continuous <- dta_descriptives$continuous %>%
    mutate(
      accuracy = case_match(variable, "interactions" ~ 1, .default = 0.1),
      value = mean_sd(mean, sd, accuracy = accuracy)
    )

  discrete <- dta_descriptives$discrete %>%
    mutate(value = n_percent(n, p, accuracy = 0.1)) %>%
    add_row(
      variable = "n",
      Variable = "N",
      value = as.character(dta_descriptives$discrete$N[[1]]),
      .before = 1
    )

  bind_rows(continuous, discrete) %>%
    mutate(
      variable = factor(
        variable,
        c("n", "hip", "knee", "age", "age.under60", "age.60to64", "age.65to69", "age.70to74",
          "age.75to79", "age.80plus", "female", "maori", "pacific", "asian", "nzdep18", "nzdep18.1",
          "nzdep18.2", "nzdep18.3", "nzdep18.4", "nzdep18.5", "nzdep18.6", "nzdep18.7", "nzdep18.8",
          "nzdep18.9", "nzdep18.10")
      ),
      Variable = fct_reorder(Variable, as.integer(variable)),
      Variable = fct_recode(
        Variable,
        "Age, mean (SD)" = "Age",
        "NZ Deprivation Index, mean (SD)" = "NZDep"
      )
    ) %>%
    arrange(Variable) %>%
    select(Variable, Value = value)
}
