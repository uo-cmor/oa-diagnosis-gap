extract_sociodemographic_data <- function(cohort, ref_date) {
  # Meshblock meta-data for calculation of NZDep
  meshblock_concordance <- tbl(con_metadata, in_schema("data", "meshblock_concordance"))
  nzdep_meta <- tbl(con_metadata, in_schema("data", "dep_index18_mb18"))
  meshblock_data <- meshblock_concordance %>% select(meshblock_code, MB2018_code) %>% 
    left_join(nzdep_meta %>% transmute(MB2018_code, nzdep18 = as.integer(NZDep2018)),
              by = "MB2018_code") %>% 
    select(meshblock_code, nzdep18)
  
  interactions <- tbl(con_adhoc, in_schema("clean_read_OPC", "oa_interactions")) %>% 
    select(snz_moh_uid, interaction_date = date) %>% 
    right_join(cohort %>% select(snz_moh_uid, tja, tja_date), by = "snz_moh_uid", copy = TRUE) %>% 
    collect() %>% 
    filter((tja_date %m-% years(10)) <= interaction_date, interaction_date < tja_date) %>% 
    count(snz_moh_uid, tja, name = "interactions")
    
  # Add personal details (sex/age/ethnicity)
  personal_details <- tbl(con, in_schema("data", "personal_detail")) %>% 
    select(snz_uid, sex = snz_sex_gender_code, birth_date = snz_birth_date_proxy,
           maori = snz_ethnicity_grp2_nbr, pacific = snz_ethnicity_grp3_nbr,
           asian = snz_ethnicity_grp4_nbr) %>% 
    right_join(cohort, by = "snz_uid", copy = TRUE) %>% 
    distinct() %>% collect() %>% 
    mutate(sex = factor(sex, 1:2, c("Male", "Female")))
  
  # Add NZDep
  tbl(con, in_schema("data", "address_notification")) %>% 
    select(snz_uid, ant_notification_date, ant_replacement_date,
           meshblock_code = ant_meshblock_code) %>% 
    right_join(personal_details, by = "snz_uid", copy = TRUE) %>% 
    filter(ant_notification_date <= {{ref_date}}, {{ref_date}} < ant_replacement_date) %>% 
    left_join(meshblock_data, by = "meshblock_code", copy = TRUE) %>% 
    select(!(ant_notification_date:meshblock_code)) %>% 
    distinct() %>%
    left_join(interactions, by = c("snz_moh_uid", "tja"), copy = TRUE) %>%
    collect()
}