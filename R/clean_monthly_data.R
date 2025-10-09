clean_monthly_data <- function(raw_monthly) {
  raw_monthly %>%
    mutate(
      grouping = factor(
        grouping,
        c("none", "tja", "tja_year", "sex", "maori", "pacific", "asian",
          "age_grp", "nzdep18"),
        c("None", "Joint", "Year of surgery", "Sex", "Māori", "Pacific",
          "Asian", "Age group", "NZDep index")
      ),
      group = case_match(
        grouping,
        c("Māori", "Pacific", "Asian") ~ paste0(if_else(as.logical(group), "", "non-"), as.character(grouping)),
        .default = as.character(group)
      ),
      group = fct_recode(
        factor(
          group,
          c("all", "tha", "tka", 2013:2018, "Female", "Male", "Māori",
            "non-Māori", "Pacific", "non-Pacific", "Asian", "non-Asian", "<60",
            "60-64", "65-69", "70-74", "75-79", "80+", 1:10, "<64", "64--93",
            "94--137", "138+")
        ),
        All = "all", Hip = "tha", Knee = "tka"
      ),
      across(month_before:N, as.integer)
    ) %>%
    nest_by(grouping) %>%
    mutate(data = list(mutate(data, group = fct_drop(group)))) %>%
    ungroup()
}
