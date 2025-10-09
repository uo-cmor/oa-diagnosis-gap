make_summary_figure <- function(dta_primary, ...) {
  df <- dta_primary %>%
    rename(data = counts) %>%
    filter(...) %>%
    unnest(cols = data) %>%
    arrange(grouping, group, desc(oa_diagnosis)) %>%
    mutate(
      group = fct_rev(group),
      p = n / coalesce(sum(n), N),
      label = prct(p),
      pos = cumsum(p) - p / 2,
      .by = c(grouping, group)
    )

  df %>%
    ggplot(aes(group, p, fill = oa_diagnosis)) +
    geom_col() +
    geom_text(aes(y = pos, label = label), size = 12) +
    scale_x_discrete() +
    scale_fill_manual(values = c("green", "orange", "red", "grey"), guide = "none") +
    coord_flip() +
    theme_void(28) +
    theme(plot.margin = margin(0, 5.5, 0, 5.5), axis.text.y = element_text())
}
