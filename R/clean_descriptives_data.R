clean_descriptives_data <- function(raw_descriptives) {
  continuous <- raw_descriptives$continuous %>%
    transmute(
      variable,
      Variable = factor(variable, c("age", "nzdep18"), c("Age", "NZDep")),
      pick(mean:uq)
    ) %>%
    drop_na()

  discrete <- raw_descriptives$discrete %>%
    transmute(
      variable,
      Variable = factor(
        variable,
        c("hip", "knee", "age.under60", "age.60to64", "age.65to69", "age.70to74", "age.75to79",
          "age.80plus", "female", "maori", "pacific", "asian", "nzdep18.1", "nzdep18.2",
          "nzdep18.3", "nzdep18.4", "nzdep18.5", "nzdep18.6", "nzdep18.7", "nzdep18.8", "nzdep18.9",
          "nzdep18.10"),
        c("Hip", "Knee", "Under 60", "60 to 64", "65 to 69", "70 to 74", "75 to 79",
          "80 and over", "Female", "Māori", "Pacific Islander", "Asian", "Decile 1", "Decile 2",
          "Decile 3", "Decile 4", "Decile 5", "Decile 6", "Decile 7", "Decile 8", "Decile 9",
          "Decile 10")
      ),
      n = as.numeric(n),
      N,
      p = n / N
    ) %>%
    drop_na()

  list(continuous = continuous, discrete = discrete)
}
