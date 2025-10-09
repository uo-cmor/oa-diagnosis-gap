read_raw_data <- function(data_file, sheet) {
  read_xlsx(data_file, sheet, na = c("N/A", "S"))
}
