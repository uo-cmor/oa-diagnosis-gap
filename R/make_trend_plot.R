make_trend_plot <- function(res_trend) {
  res_trend %>%
    ggplot(aes(year, p, ymin = p.ll, ymax = p.ul)) +
    geom_line() +
    geom_pointrange() +
    scale_x_continuous("Year of surgery") +
    scale_y_continuous(
      "Proportion, %",
      limits = c(0, 1),
      breaks = scales::breaks_pretty(),
      labels = scales::label_percent()
    ) +
    theme_minimal(16) +
    theme_sub_panel(grid.minor.x = element_blank())
}
