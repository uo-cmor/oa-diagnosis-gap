export_subgroup_table <- function(res_subgroups) {
  tbl_col1 <- ttab(
    res_subgroups[1:26, ],
    caption = paste(
      "Proportion with prior osteoarthritis diagnosis in primary care among patients with primary",
      "hip or knee replacement surgery, by subgroups"
    ),
    colnames = c("Group", "Proportion (95% CI)")
  ) %>%
    pack_rows(1, 2, "Joint") %>%
    pack_rows(3, 6, "Age") %>%
    pack_rows(9, 2, "Sex") %>%
    pack_rows(11, 2, "Māori") %>%
    pack_rows(13, 2, "Pacific Islander") %>%
    pack_rows(15, 2, "Asian") %>%
    pack_rows(17, 10, "NZ Deprivation index") %>%
    as_typst()

  tbl_col2 <- ttab(
    res_subgroups[27:56, ],
    caption = paste(
      "Proportion with prior osteoarthritis diagnosis in primary care among patients with primary",
      "hip or knee replacement surgery, by subgroups"
    ),
    colnames = c("Group", "Proportion (95% CI)")
  ) %>%
    pack_rows(1, 4, "GP interactions") %>%
    pack_rows(5, 20, "Practice#super[#sym.star.filled]") %>%
    pack_rows(25, 6, "Year of surgery") %>%
    as_typst()

  footnotes <- glue(
    paste(
      "#super[#sym.star.filled] Practice labels are anonymized practice IDs; only practices with",
      "at least 6 cases are reported due to IDI confidentiality provisions"
    ),
    "Abbreviations: CI=Confidence interval; NZ=New Zealand.",
    .sep = "\n\n"
  )
  save_table(
    glue::glue("#columns(2)[{tbl_col1}\n#colbreak()\n{tbl_col2}]\n{footnotes}"),
    "comparisons"
  )
}
