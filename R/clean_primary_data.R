clean_primary_data <- function(raw_primary) {
  raw_primary %>%
    mutate(
      grouping = factor(
        grouping,
        c("none", "tja", "tja_year", "sex", "maori", "pacific", "asian",
          "age_grp", "nzdep18", "interactions", "practice_id"),
        c("None", "Joint", "Year of surgery", "Sex", "Māori", "Pacific",
          "Asian", "Age group", "NZDep index", "GP interactions", "Practice")
      ),
      group = case_match(
        grouping,
        c("Māori", "Pacific", "Asian") ~ paste0(if_else(as.logical(group), "", "non-"), grouping),
        "GP interactions" ~
          case_match(
            group,
            "[0,64)" ~ "<64",
            "[64,94)" ~ "64--93",
            "[94,138)" ~ "94--137",
            "[138,Inf)" ~ "138+"
          ),
        .default = group
      ),
      group = fct_recode(
        factor(
          group,
          c("all", "tha", "tka", 2013:2018, "Female", "Male", "Māori", "non-Māori", "Pacific",
            "non-Pacific", "Asian", "non-Asian", "<60", "60-64", "65-69", "70-74", "75-79", "80+",
            1:10, "<64", "64--93", "94--137", "138+", "100", "102", "114", "116", "117", "118",
            "119", "120", "126", "127", "129", "130", "131", "132", "251", "256", "257", "269",
            "45", "49", "52", "53", "54", "55", "56", "69", "70", "71", "72", "77", "78", "81",
            "82", "84", "85", "89", "92", "93", "95", "99")
        ),
        All = "all",
        Hip = "tha",
        Knee = "tka"
      ),
      oa_diagnosis = factor(oa_diagnosis, c("Before", "After", "None", "Suppressed")),
      across(n:N, as.integer),
      p_value = as.numeric(p_value)
    ) %>%
    arrange(grouping, group, oa_diagnosis) %>%
    nest_by(grouping) %>%
    transmute(
      counts = list(data %>% mutate(group = fct_drop(group), p_value = NULL)),
      tests = list(
        data %>%
          drop_na(p_value) %>%
          mutate(group = fct_drop(group)) %>%
          distinct(oa_diagnosis, p_value)
      )
    ) %>%
    ungroup()
}
