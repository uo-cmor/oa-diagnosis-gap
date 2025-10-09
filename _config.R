library(tidyverse)

# Define any analysis parameters or parameter grids in here
grid_plots <- tribble(
  ~name,          ~grp,              ~n, ~label,
  "joint",        "Joint",            2, "Joint",
  "age",          "Age group",        6, "Age",
  "sex",          "Sex",              2, "Sex",
  "maori",        "Māori",            2, "Māori",
  "pacific",      "Pacific",          2, "Pacific Islander",
  "asian",        "Asian",            2, "Asian",
  "nzdep",        "NZDep index",     10, "NZ Deprivation Index",
  "interactions", "GP interactions",  4, "Interaction frequency",
  "practice",     "Practice",        20, "GP practice",
  "year",         "Year of surgery",  6, "Year of surgery"
)
