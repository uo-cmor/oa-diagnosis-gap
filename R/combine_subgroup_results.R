combine_subgroup_results <- function(...) {
  vctrs::vec_c(...) %>%
    mutate(
      group = fct_recode(
        group,
        "Under 60" = "<60",
        "80 and over" = "80+",
        "Fewer than 64" = "<64",
        "138 or more" = "138+",
        "Decile 1" = "1",
        "Decile 2" = "2",
        "Decile 3" = "3",
        "Decile 4" = "4",
        "Decile 5" = "5",
        "Decile 6" = "6",
        "Decile 7" = "7",
        "Decile 8" = "8",
        "Decile 9" = "9",
        "Decile 10" = "10",
      )
    ) %>%
    drop_na() %>%
    select(group, value)
}
