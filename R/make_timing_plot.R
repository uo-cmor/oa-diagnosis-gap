make_timing_plot <- function(res_timing) {
  if (is.null(res_timing)) {
    return(ggplot())
  }

  res_timing %>%
    ggplot(aes(month, p, group = group, colour = group, linetype = group)) +
    geom_line(linewidth = 1.5) +
    geom_vline(xintercept = 0, colour = "black", linewidth = 1) +
    scale_x_continuous(
      "Years before/after surgery",
      breaks = (-10:5) * 12,
      minor_breaks = NULL,
      labels = scales::label_number(scale = 1 / 12)
    ) +
    scale_y_continuous(
      "Probability of having\nrecorded OA diagnosis",
      limits = 0:1,
      breaks = scales::breaks_pretty(),
      label = scales::label_percent(),
      expand = expansion()
    ) +
    scale_colour_brewer(NULL, type = "qual", palette = "Dark2") +
    scale_linetype_discrete(NULL) +
    theme_minimal(16) +
    theme(
      legend.position = "inside",
      legend.position.inside = c(1, 0.05),
      legend.justification = c(1, 0),
      legend.key.width = unit(3, "lines"),
      legend.key.height = unit(1.5, "lines")
    )
}
