# compare tables
# Catch table - all survey
# Catch table - 3 nmi
#
# Vouchers - all survey
# Vouchers - 3 nmi
#
# Age samples- all survey
# Age samples - 3 nmi


# Catch 3nm --------------------------------------------------------------------
# From read.r
catch_summary_3nm <- catch0 %>% # catch table from racebase
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


# From SQL query in AI-ADFG-rpt_code.sql (modified for GOA 2023) (starts on line 68)
compare_line68 <- read.csv("sql query outputs/catch_3nm_goa2023_line68.csv") |>
  janitor::clean_names() |>
  arrange(species_code)

big_table2 <- catch_summary_3nm |>
  left_join(compare_line68, by = "species_code") |>
  mutate(
    wt_diff = total_weight_kg.x - total_weight_kg.y,
    count_diff = total_count.x - total_count.y
  ) # This SQL script consistently produces lower counts and lower weights than catch_summary_3nm



# From SQL query in AI-ADFG-rpt_code.sql (modified for GOA 2023) (starts on line 126)
compare_new <- read.csv("sql query outputs/catch_3nm_goa2023.csv") |>
  janitor::clean_names() |>
  arrange(species_code)

big_table <- catch_summary_3nm |>
  left_join(compare_new, by = "species_code") |>
  mutate(
    wt_diff = total_weight_kg.x - total_weight_kg.y,
    count_diff = total_count.x - total_count.y
  )
# This comparison looks good!


# Voucher 3nm ------------------------------------------------------------------
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


# my version
s3nm <- stations_3nm0 %>%
  dplyr::select(stationid, stratum) %>%
  dplyr::distinct()


v <- catch0 |>
  dplyr::filter(cruise == cruise1 & region == "GOA" & !is.na(voucher)) |>
  left_join(haul0 |> dplyr::select(hauljoin, stationid, stratum, abundance_haul)) |>
  right_join(s3nm) |>
  filter(!is.na(hauljoin))

# This is the same output as the table above and the SQL query in AI-ADFG-rpt_code.sql (modified for GOA 2023) (line 5)


# Age 3nm -----------------------------------------------------------------
# From read.r
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

age_count_3nm_oldsql <- read.csv("sql query outputs/age_3nm_goa2023_line7.csv") |>
  left_join(species0,by=c('COMMON_NAME'='common_name'))

# My version
a <- specimen0 |> 
  dplyr::filter(cruise == cruise1 & region == "GOA" & specimen_sample_type == 1) |>
  left_join(haul0 |> dplyr::select(hauljoin, stationid, stratum, abundance_haul)) |>
  inner_join(s3nm) |>
  group_by(species_code) |>
  dplyr::summarize(n = n()) |>
  ungroup() |>
  select(species_code, n) 
# 

bigtable <- age_count_3nm_oldsql |>
  left_join(a, by = 'species_code') |>
  mutate(diff = Count - n)
# My table from scratch is the same as age_count_3nm and the "new" SQL script output, and I think those are correct. There are differences between the new and old sql outputs; the numbers in the "old" SQL table are consistently higher.


  
