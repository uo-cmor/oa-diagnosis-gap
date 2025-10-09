clean_preliminary_data <- function(raw_data_preliminary) {
  raw_data_preliminary %>%
    transmute(
      grouping = factor(if_else(joint == "tjr", "None", "Joint"), c("None", "Joint")),
      group = factor(joint, c("tjr", "thr", "tkr"), c("All", "Hip", "Knee")),
      oa_diagnosis = factor(diagnosis, c("Before TJR", "After TJR", "None"),
                            c("Before", "After", "None")),
      n = as.integer(n)
    ) %>%
    mutate(N = sum(n), .by = c(grouping, group)) %>%
    arrange(grouping, group, oa_diagnosis) %>%
    nest_by(grouping) %>%
    mutate(data = list(mutate(data, group = fct_drop(group))))
}
