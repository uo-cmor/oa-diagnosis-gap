make_oarnet_summary_plot <- function(data) {
  df <- data %>%
    filter(grouping %in% c("None", "Joint")) %>%
    unnest(counts) %>%
    mutate(
      group = fct_recode(group,
                         "Total joint replacement (any)" = "All",
                         "Total knee replacement" = "Knee",
                         "Total hip replacement" = "Hip")
    ) %>%
    arrange(group, oa_diagnosis) %>%
    mutate(group = fct_rev(group),
           oa_diagnosis = fct_rev(oa_diagnosis),
           p = n / coalesce(sum(n), N),
           label = prct(p),
           pos = cumsum(p) - p/2,
           .by = group)

  df %>%
    ggplot(aes(group, p, fill = oa_diagnosis)) +
    geom_col() +
    geom_text(aes(y = pos, label = label), size = 12) +
    scale_x_discrete() +
    scale_fill_manual(values = c("red", "orange", "green", "grey"), guide = "none") +
    coord_flip() +
    theme_void(28) +
    theme(plot.margin = margin(0, 5.5, 0, 5.5),
          axis.text.y = element_text(hjust = 1))
}
