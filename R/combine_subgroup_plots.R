combine_subgroup_plots <- function(..., dta_primary, n) {
  total <- dta_primary %>%
    filter(grouping == "None") %>%
    unnest(counts) %>%
    filter(oa_diagnosis == "Before") %>%
    with(n / N)

  plots <- list(...)
  plots <- plots[names(plots) != "plt_subgroup_year"]

  wrap_plots(plots, axes = "collect", heights = n + 1) &
    geom_hline(yintercept = total, colour = "red") &
    theme_minimal(16, paper = "transparent") &
    theme_sub_axis_y(
      text = element_blank(),
      ticks = element_blank(),
      title = element_text(angle = 0, vjust = 0.5, hjust = 1, size = rel(0.8))
    ) &
    theme_sub_panel(grid.major = element_line(colour = "#ebebebff"))
}
