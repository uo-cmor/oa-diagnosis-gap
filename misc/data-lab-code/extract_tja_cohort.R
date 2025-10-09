extract_tja_cohort <- function(opc_cohort) {
  # Patients in the primary care cohort with TJA b/w 2013 and 2018:
  tja <- tbl(con, in_schema("moh_clean", "pub_fund_hosp_discharges_event")) %>% 
    inner_join(opc_cohort, by = "snz_moh_uid", copy = TRUE) %>% 
    filter(as.Date("2013-01-01") <= moh_evt_evst_date, moh_evt_evst_date < as.Date("2019-01-01"),
           moh_evt_drg_current_text %in% c("I03A", "I03B", "I04A", "I04B")) %>% 
    mutate(
      tja = if_else(moh_evt_drg_current_text %in% c("I03A", "I03B"), "tha", "tka"),
      tja_date = moh_evt_evst_date
    ) %>% 
    distinct(snz_uid, snz_moh_uid, moh_evt_event_id_nbr, tja, tja_date,
             read_code_hip_oa_first_recorded, read_code_knee_oa_first_recorded)
  
  # Those where the primary diagnosis is OA
  tja_oa <- tbl(con, in_schema("moh_clean", "pub_fund_hosp_discharges_diag")) %>% 
    inner_join(tja, by = c(moh_dia_event_id_nbr = "moh_evt_event_id_nbr")) %>% 
    filter(
      moh_dia_submitted_system_code == moh_dia_clinical_sys_code,   # only original submitted diagnosis codes (not mapping to ICD-9)
      substr(moh_dia_clinical_code, 1, 1) %in% LETTERS,
      moh_dia_diagnosis_type_code == "A",                           # only primary diagnosis
      substr(moh_dia_clinical_code, 1, 3) == "M16" & tja == "tha" | # THA + hip OA, or
        substr(moh_dia_clinical_code, 1, 3) == "M17" & tja == "tka" # TKA + knee OA
    ) %>% 
    distinct(snz_uid, snz_moh_uid, moh_evt_event_id_nbr = moh_dia_event_id_nbr, tja_date,
             tja, read_code_hip_oa_first_recorded, read_code_knee_oa_first_recorded) %>% 
    mutate(
      oa_diagnosis_date = as.Date(if_else(tja == "tha", read_code_hip_oa_first_recorded,
                                          read_code_knee_oa_first_recorded)),
      read_code_hip_oa_first_recorded = NULL,
      read_code_knee_oa_first_recorded = NULL,
    ) %>% 
    collect()
  
  tja_oa %>% 
    arrange(snz_uid, snz_moh_uid, tja, tja_date) %>% 
    distinct(snz_uid, snz_moh_uid, tja, .keep_all = TRUE) %>% 
    extract_pho_cohort(tja_date, tja)
}
