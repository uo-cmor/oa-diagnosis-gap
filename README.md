
<!-- README.md is generated from README.Rmd. Please edit that file -->

# OA diagnosis gaps

This repository contains the data and code for our project estimating
the rate of missing OA diagnoses in primary care in NZ.

The data files provided here are aggregated data obtained from the Stats
NZ Integrated Data Infrastructure (IDI). The underlying individual
patient data are not publicly available due to confidentiality
provisions of the IDI. Access to the IDI may be made available by Stats
NZ to approved New Zealand-based reseachers; see
<https://stats.govt.nz/idi> for more information.

## How to use

The project uses [`{renv}`](https://rstudio.github.io/renv/index.html)
for package version/dependency management, and
[`{targets}`](https://books.ropensci.org/targets/) to specify the data
analytic workflow. When opening the project for the first time, `{renv}`
should prompt you to download and install the required package versions;
if it does not, use `renv::restore()` to do this manually.

The project pipeline can then be built using `targets::tar_make()` to
recreate all of the tables and figures presented in the manuscript.

This will create targets `res_descriptives`, the results for the cohort
descriptive statistics table; `plt_trend` and `res_trend`, the figure
(and underlying data) of the proportion of the cohort with a prior OA
diagnosis over time; `plt_subgroups` and `res_subgroups`, the figure
(and underlying data) comparing the proportion of the cohort with a
prior OA diagnosis among different subgroups; and `plt_timing_joint` and
`res_timing_joint`, the figure (and underlying data) of the timing of
first OA diagnosis relative to date of surgery, by OA joint. After
successfully running `targets::tar_make()`, any of these can be loaded
into the R session using `targets::tar_load(<target-name>)`.

## How to cite

This repository contains work-in-progress. Please do not cite.

<!-- Update and uncomment this section once the work is citable
&#10;Please cite this work as:
&#10;> Author list goes here, (Year of publication). _Title of your paper goes here_. Name of journal/publication; Volume/Issue/Page numbers. <https://doi.org/Citation DOI>
&#10;-->

## How to download

You can download this repository as a zip from:
<https://github.com/uo-cmor/oa-diagnosis-gap/archive/master.zip>
