read_raw_descriptives <- function(file_descriptives) {
  continuous <- read_xlsx(file_descriptives, "Continuous")
  discrete <- read_xlsx(file_descriptives, "Discrete")

  list(continuous = continuous, discrete = discrete)
}
