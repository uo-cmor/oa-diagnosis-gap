# Extract full Compass Health cohort
extract_opc_cohort <- function() {
  # All patients in the primary care cohort:
  tbl(con_adhoc, in_schema("clean_read_OPC", "oa_cohort")) %>% 
    distinct() %>% 
    select(snz_moh_uid, read_code_hip_oa_first_recorded, read_code_knee_oa_first_recorded) %>%
    collect()
}

# Those enrolled in the same PHO continuously for 10 years before the reference (TJA/NZHS) date
extract_pho_cohort <- function(oa_cohort, ref_date, ...) {
  tbl(con, in_schema("moh_clean", "pho_enrolment")) %>%
    select(
      snz_uid:moh_pho_enrolment_date,
      moh_pho_enrol_status_code,
      moh_pho_pho_id,
      moh_pho_practice_id
    ) %>%
    inner_join(oa_cohort, by = c("snz_uid", "snz_moh_uid"), copy = TRUE) %>%
    collect() %>%
    filter(
      moh_pho_pho_id %in% c('<redacted>'),
      parse_date(moh_pho_year_and_quarter_text, "%Y%m%d") >
        ceiling_date({{ ref_date }}, "quarter") - years(10),
      parse_date(moh_pho_year_and_quarter_text, "%Y%m%d") <=
        ceiling_date({{ ref_date }}, "quarter")
    ) %>%
    filter(n() == 40, .by = c(snz_uid, snz_moh_uid, {{ ref_date }}, ...)) %>%
    arrange(desc(moh_pho_year_and_quarter_text)) %>%
    mutate(
      practice_id = first(moh_pho_practice_id),
      .by = c(snz_uid, snz_moh_uid, {{ ref_date }}, ..., oa_diagnosis_date)
    ) %>%
    distinct(
      snz_uid,
      snz_moh_uid,
      practice_id,
      {{ ref_date }},
      ...,
      oa_diagnosis_date
    )
}