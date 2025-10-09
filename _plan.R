# This file defines the targets in the project analysis plan

targets <- rlang::list2(
  # Raw data -------------------------------------------------------------------
  tar_file(file_data, "raw_data/results_20250205.xlsx"),
  tar_map(
    list(name = c("primary", "monthly"), sheet = c("Main results", "Results by month")),
    names = name,
    tar_target(raw, read_raw_data(file_data, sheet), packages = "readxl")
  ),
  tar_file(file_descriptives, "raw_data/descriptive-statistics_20250318.xlsx"),
  tar_target(raw_descriptives, read_raw_descriptives(file_descriptives), packages = "readxl"),
  # Data cleaning --------------------------------------------------------------
  tar_target(dta_primary, clean_primary_data(raw_primary)),
  tar_target(dta_monthly, clean_monthly_data(raw_monthly)),
  tar_target(dta_descriptives, clean_descriptives_data(raw_descriptives)),
  # Cohort descriptive table ---------------------------------------------------
  tar_target(
    res_descriptives,
    compile_descriptives_table(dta_descriptives),
    packages = c("tidyverse", "formattr")
  ),
  # Prior OA diagnoses, by year of surgery -------------------------------------
  tar_target(res_trend, compile_trend_results(dta_primary)),
  tar_target(plt_trend, make_trend_plot(res_trend)),
  # Subgroup results -----------------------------------------------------------
  by_subgroup = tar_map(
    grid_plots,
    names = name,
    ## Summary plots, as presented at LnL --------------------------------------
    tar_target(
      plt_summary,
      make_summary_figure(dta_primary, grouping == grp),
      packages = c("tidyverse", "formattr")
    ),
    ## Prior OA diagnoses ------------------------------------------------------
    tar_target(
      res_subgroup,
      compile_subgroup_results(dta_primary, grouping == grp),
      packages = c("tidyverse", "formattr")
    ),
    tar_target(plt_subgroup, make_subgroup_plot(res_subgroup, label)),
    ## Timing of diagnosis relative to surgery ---------------------------------
    tar_target(res_timing, compile_timing_results(dta_monthly, grouping == grp)),
    tar_target(plt_timing, make_timing_plot(res_timing))
  ),
  ## END targets list ----------------------------------------------------------
)

targets <- rlang::list2(
  !!!targets,
  # Combine subgroup results ---------------------------------------------------
  tar_combine(
    res_subgroups,
    targets$by_subgroup$res_subgroup,
    command = combine_subgroup_results(!!!.x)
  ),
  tar_combine(
    plt_subgroups,
    targets$by_subgroup$plt_subgroup,
    command = combine_subgroup_plots(!!!.x, dta_primary = dta_primary, n = grid_plots$n),
    packages = c("tidyverse", "patchwork")
  ),
  ## END targets list ----------------------------------------------------------
)
