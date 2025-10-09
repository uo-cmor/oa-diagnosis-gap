export_descriptives_table <- function(res_descriptives) {
  tbl <- ttab(
    res_descriptives,
    caption = "Demographic characteristics of the cohort"
  ) %>%
    format_cells(
      cells(
        Variable,
        !Variable %in% c("N", "Age, mean (SD)", "Female", "NZ Deprivation Index, mean (SD)")
      ),
      italic = TRUE
    ) %>%
    pack_rows(2, 2, "Joint", italic = FALSE) %>%
    pack_rows(5, 6) %>%
    pack_rows(12, 3, "Ethnicity", italic = FALSE) %>%
    pack_rows(16, 10) %>%
    add_footnote(paste(
      "Values are count (%) unless otherwise specified. All variables measured at the time of",
      "surgery."
    )) %>%
    add_footnote("Abbreviations: NZ=New Zealand; SD=Standard deviation.") %>%
    as_typst()

  save_table(tbl, "descriptives")
}
