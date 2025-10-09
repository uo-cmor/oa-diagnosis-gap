make_subgroup_plot <- function(res_subgroup, label) {
  res_subgroup %>%
    mutate(group = fct_rev(group)) %>%
    ggplot(aes(group, p, ymin = p.ll, ymax = p.ul)) +
    geom_pointrange(size = 0.3) +
    scale_x_discrete(label, expand = expansion(add = 1.1)) +
    scale_y_continuous("Proportion, %", limits = c(0, 1), labels = scales::label_percent()) +
    coord_flip() +
    theme_minimal(12, paper = "transparent")
}
