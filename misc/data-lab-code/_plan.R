targets <- rlang::list2(
  ## Extract the cohort
  tar_target(
    opc_cohort,
    extract_opc_cohort(),
    packages = c("tidyverse", "dbplyr")
  ),
  tar_target(
    tja_cohort,
    extract_tja_cohort(opc_cohort),
    packages = c("tidyverse", "dbplyr")
  ),
  ## Add additional sociodemographic data
  tar_target(
    data,
    extract_sociodemographic_data(tja_cohort, tja_date),
    packages = c("tidyverse", "dbplyr")
  ),
  ## Sample descriptive statistics
  tar_target(descriptive_statistics, calculate_descriptive_statistics(data)),
  ## Cohort count by timing of OA diagnosis and all subgroups
  tar_target(full_results, calculate_cohort_stratification(data)),
  ## Specific subgroup-level results
  tar_target(results_pooled, summarise_results(full_results)[[1]]),
  results = tar_map(
    list(
      subgroups = rlang::syms(c(
        "tja",
        "tja_year",
        "practice_id",
        "sex",
        "maori",
        "pacific",
        "asian",
        "age_grp",
        "nzdep18",
        "interactions"
      ))
    ),
    tar_target(results, summarise_results(full_results, subgroups))
  ),
  tar_combine(results_combined, results),
  tar_target(results_by_month, summarise_results_by_month(full_results)[[1]]),
  results_by_month = tar_map(
    list(
      subgroups = rlang::syms(c(
        "tja",
        "tja_year",
        "sex",
        "maori",
        "pacific",
        "asian",
        "age_grp",
        "nzdep18"
      ))
    ),
    tar_target(
      results_by_month_and,
      summarise_results_by_month(full_results, subgroups)
    )
  ),
)

targets <- rlang::list2(
  !!!targets,
  tar_combine(results_by_month_and_subgroup, targets$results_by_month)
)
