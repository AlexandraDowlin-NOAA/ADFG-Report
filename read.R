

# UPDATE below depending on srvy and yr -----------------------------------------
# SRVY calls region and cruise1 calls cruise. Write the code like this means not having to touch the code at all.

# SRVY <- "GOA"
#cruise1 <- 202301

 SRVY <- "AI"
 cruise1 <- "202401"

# in the works
# if (SRVY == "GOA") {
# stations_3nm0 <- RODBC::sqlQuery(channel, paste0("SELECT * FROM GOA.STATIONS_3NM"))
# } else if (SRVY == "AI") {
# stations_3nm0 <- RODBC::sqlQuery(channel, paste0("SELECT * FROM AI.STATIONS_3NM"))
# }


# data tables needed for report  ------------------------------------------------

# catch summary 3 nm -----------------------------------------------------------

catch_summary_3nm <- catch0 %>%
  dplyr::select(number_fish, weight, hauljoin, cruisejoin, cruise, region, species_code) %>%
  dplyr::left_join(haul0 %>% dplyr::select(hauljoin, cruisejoin, stationid, stratum, abundance_haul)) %>%
  # dplyr::filter(abundance_haul == "Y") %>%
  dplyr::inner_join(stations_3nm0 %>%
    dplyr::select(stationid, stratum) %>%
    dplyr::distinct()) %>%
  dplyr::filter(region == SRVY &
    cruise == cruise1) %>%
  dplyr::group_by(species_code) %>%
  dplyr::summarise(
    total_count = sum(number_fish, na.rm = TRUE),
    total_weight_kg = sum(weight, na.rm = TRUE)
  ) %>%
  ungroup() %>%
  dplyr::left_join(species0) %>%
  dplyr::select(species_code, common_name, species_name, total_weight_kg, total_count)


# catch summary ----------------------------------------------------------------

catch_summary <- catch0 %>%
  dplyr::filter(region == SRVY &
    cruise == cruise1) %>%
  dplyr::left_join(haul0 %>% dplyr::select(hauljoin, abundance_haul)) %>%
  # dplyr::filter(abundance_haul == "Y") %>%
  dplyr::group_by(species_code) %>%
  dplyr::summarise(
    total_count = sum(number_fish, na.rm = TRUE),
    total_weight_kg = sum(weight, na.rm = TRUE)
  ) %>%
  ungroup() %>%
  dplyr::left_join(species0) %>%
  dplyr::select(species_code, common_name, species_name, total_weight_kg, total_count)



# voucher summary 3 nm ---------------------------------------------------------
# counts of age samples
age_count_3nm <- specimen0 %>%
  dplyr::left_join(haul0 %>% dplyr::select(hauljoin, stationid, stratum, abundance_haul)) %>%
  # dplyr::filter(abundance_haul == "Y") %>%
  dplyr::inner_join(stations_3nm0 %>%
    dplyr::select(stationid, stratum) %>%
    dplyr::distinct()) %>%
  dplyr::filter(region == SRVY &
    stationid %in% stations_3nm0$stationid &
    cruise == cruise1 &
    specimen_sample_type == 1) %>%
  dplyr::group_by(species_code) %>%
  dplyr::summarise(count = n()) %>%
  dplyr::mutate(comment = "Age Sample")

# counts of vouchers
voucher_count_3nm <- catch0 %>%
  dplyr::left_join(haul0 %>% dplyr::select(hauljoin, stationid, stratum, abundance_haul)) %>%
  # dplyr::filter(abundance_haul == "Y") %>%
  dplyr::inner_join(stations_3nm0 %>%
    dplyr::select(stationid, stratum) %>%
    dplyr::distinct()) %>%
  dplyr::filter(region == SRVY &
    stationid %in% stations_3nm0$stationid &
    cruise == cruise1 &
    !is.na(voucher)) %>%
  dplyr::group_by(species_code) %>%
  dplyr::summarise(count = n()) %>%
  dplyr::mutate(comment = "Voucher")

# combine and stack vouchers and age samples
voucher_3nm <- dplyr::bind_rows(voucher_count_3nm, age_count_3nm) %>%
  dplyr::left_join(species0) %>%
  dplyr::select(common_name, species_name, count, comment)

#counts of fish taxa vouchers vs invert taxa vouchers
voucher_count_3nm  %>% dplyr::mutate(taxon = dplyr::case_when(       
    species_code <= 31550 ~ "fish",       
  
    species_code >= 40001 ~ "invert"     
  )) %>% dplyr::filter(taxon == "fish") %>% nrow()

# voucher summary  -------------------------------------------------------------
# counts of age samples
age_count <- specimen0 %>%
  dplyr::left_join(haul0 %>% dplyr::select(hauljoin, abundance_haul)) %>%
  # dplyr::filter(abundance_haul == "Y") %>%
  dplyr::filter(region == SRVY &
    cruise == cruise1 &
    specimen_sample_type == 1) %>%
  dplyr::group_by(species_code) %>%
  dplyr::summarise(count = n()) %>%
  dplyr::mutate(comment = "Age Sample")

# counts of vouchers
voucher_count <- catch0 %>%
  dplyr::left_join(haul0 %>% dplyr::select(hauljoin, abundance_haul)) %>%
  # dplyr::filter(abundance_haul == "Y") %>%
  dplyr::filter(region == SRVY &
    cruise == cruise1 &
    !is.na(voucher)) %>%
  dplyr::group_by(species_code) %>%
  dplyr::summarise(count = n()) %>%
  dplyr::mutate(comment = "Voucher")

# or

# voucher_count <- catch0 %>%
#   dplyr::filter(region == SRVY &
#                   cruise == cruise1 &
#                   !is.na(voucher)) %>%
#   dplyr::group_by(species_code) %>%
#   dplyr::summarise(count = sum(number_fish, na.rm=T)) %>%
#   dplyr::mutate(comment  = "Voucher")

# combine and stack vouchers and age samples
voucher_all <- dplyr::bind_rows(voucher_count, age_count) %>%
  dplyr::left_join(species0) %>%
  dplyr::select(common_name, species_name, count, comment)
