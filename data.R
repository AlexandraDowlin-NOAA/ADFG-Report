# Code for ADFG_REPORT markdown  ------------------------------------------

# update manually every year ----------------------------------------------

maxyr <- "2024"

region <- "Aleutian Islands" #"Gulf of Alaska" 

regionw_abbr <- "Aleutian Islands (AI)" #"Gulf of Alaska (GOA)" 

region_abbr <-  "AI" #"GOA"

dates_conducted <- "5 June and 3 August" #check dates for vessels

survnumber <- "fourteenth" #17 for GOA in 2023 (1993 to present) #14 for AI in 2024 (1991 to present) ##differs by survey

time_series <- "30+ year time series" #Ask about this data point, X amount of years from survey standardization 

series_begun <- "1991" #AI is 1991 #GOA is 1993

vessel1 <- "FV Ocean Explorer"

vessel2 <- "FV Alaska Provider"

data_finalized <- "11 September, 2024"  #update this every year

#Total planned stations 
t_stations <- "320" # Confirmed this for each survey year

ai_methods <- "70 days each, sampling the standard survey area (~64,000 km2) and trawling 400-420 planned survey stations. In 2024, due to budgetary considerations, the two survey charters were reduced ~15% to 60 days per vessel and the total station allocation was reduced to 320 stations distributed across the survey area. The AI survey uses a stratified-random design to allocate stations to trawlable areas in the archipelago in depths to 500 m based on four depth strata (1-100 m, 101-200 m, 201-300 m, and 301-500 m) and previously established survey districts and subdistricts. The AI survey area is within the NPFMC BSAI (Bering Sea and Aleutian Islands) management area and consists of four survey districts corresponding to the Western, Central, and Eastern Aleutian National Marine Fisheries Service (NMFS) subdivisions with the addition of a southern Bering Sea (SBS) sampling district defined as the region between 170°W and 165°W and north of the archipelago"

# goa_methods <- "75 days each, sampling the standard survey area (~320,000 km^2^) and trawling 520-550 survey stations. The `r region_abbr` survey uses a stratified-random design to allocate stations across the region in depths up to 700 m.  Survey strata are based on five depth intervals (1-100 m, 101-200 m, 201-300 m, 301-500 m and 501-700 m) and established survey districts and subdistricts. In `r maxyr`, the `r region_abbr` survey area is stratified into five International North Pacific Fisheries Commission (INPFC) statistical districts: Shumagins, Chirikof, Kodiak, Yakutat, and southeast Alaska"


#successful biomass tows 526sql
s_stations <- haul0 %>% 
  filter(abundance_haul == "Y") %>%
  filter(cruise == cruise1) %>%
  filter(region == SRVY) %>%
  distinct(stationid, stratum) %>% nrow()


#total of attempted hauls 555sql, 550 r
a_hauls <- haul0 %>% filter(region == SRVY) %>% filter(cruise == cruise1) %>% filter(haul_type == "3") %>% nrow()
# MCS note: if you modify the SQL code to be haul_type = 3 (as in the R code) you'll get the same answer as R. I had 550 tows attempted in my data report!

#total of unsuccessful hauls 29sql, 24 r
u_hauls <- haul0 %>% filter(region == SRVY) %>% filter(cruise == cruise1) %>% filter(abundance_haul == "N") %>% filter(haul_type == "3") %>% nrow() 
# MCS note: this one is the same. If you filter the sql script to be haul_type = 3 you'll get the same number as in R. I'm not sure which is better, but 24 is the number I have in my report, so I'd say we should stick to that one.

#stations within 3nm #123
stations_3nm <- haul0 %>% 
  filter(abundance_haul == "Y") %>%
  filter(cruise == cruise1) %>%
  filter(region == SRVY) %>%
  distinct(stationid, stratum) %>%
  inner_join(stations_3nm0) %>% nrow()



##good up to here
#total count of fish taxa encounter within 3nm
fish_3nm <- catch_summary_3nm %>% dplyr::mutate(taxon = dplyr::case_when(       
  species_code <= 31550 ~ "fish",       
  
  species_code >= 40001 ~ "invert"     
)) %>%
  filter(taxon =="fish") %>% nrow() 


#total weight of fish taxa encountered within 3nm
fish_3nm_wt <- catch_summary_3nm %>% dplyr::mutate(taxon = dplyr::case_when(
  species_code <= 31550 ~ "fish",
  
  species_code >= 40001 ~ "invert"
)) %>%
  filter(taxon =="fish") %>% mutate(total_weight_kg = as.numeric(total_weight_kg)) %>% summarize(total= sum(total_weight_kg)) %>% as.numeric()


#total count of fish taxa encountered in all survey
fish_all <- catch_summary %>% dplyr::mutate(taxon = dplyr::case_when(       
  species_code <= 31550 ~ "fish",       
  
  species_code >= 40001 ~ "invert"     
)) %>%
  filter(taxon =="fish") %>% nrow() 


#total weight of fish taxa encountered in all survey
fish_all_wt <- catch_summary %>% dplyr::mutate(taxon = dplyr::case_when(       
  species_code <= 31550 ~ "fish",       
  
  species_code >= 40001 ~ "invert"     
)) %>%
  filter(taxon =="fish") %>% mutate(total_weight_kg = as.numeric(total_weight_kg)) %>% summarize(total= sum(total_weight_kg)) %>% as.numeric() 


#total count of invert taxa within 3nm
inverts_3nm <- catch_summary_3nm %>% dplyr::mutate(taxon = dplyr::case_when(       
  species_code <= 31550 ~ "fish",       
  
  species_code >= 40001 ~ "invert"     
)) %>%
  filter(taxon =="invert") %>% nrow()


#total weight of invert taxa within 3nm
inverts_3nm_wt <- catch_summary_3nm %>% dplyr::mutate(taxon = dplyr::case_when(       
  species_code <= 31550 ~ "fish",       
  
  species_code >= 40001 ~ "invert"     
)) %>%
  filter(taxon =="invert") %>% mutate(total_weight_kg = as.numeric(total_weight_kg)) %>% summarize(total= sum(total_weight_kg)) %>% as.numeric()


#total count of invert taxa in all survey
inverts_all <- catch_summary %>% dplyr::mutate(taxon = dplyr::case_when(       
  species_code <= 31550 ~ "fish",       
  
  species_code >= 40001 ~ "invert"     
)) %>%
  filter(taxon =="invert") %>% nrow()


#total weight of invert taxa in all survey
inverts_all_wt <- catch_summary %>% dplyr::mutate(taxon = dplyr::case_when(       
  species_code <= 31550 ~ "fish",       
  
  species_code >= 40001 ~ "invert"     
)) %>%
  filter(taxon =="invert") %>% mutate(total_weight_kg = as.numeric(total_weight_kg)) %>% summarize(total= sum(total_weight_kg)) %>% as.numeric()




#good past here #count rows??
#count of vouchers collected within 3nm
voucher_3nm_count <- voucher_3nm %>% filter(comment=="Voucher") %>% summarize(total = sum(count)) %>% as.numeric()

#count of vouchers collected in all survey #theres a zero
voucher_all_count <- voucher_all %>% filter(comment=="Voucher") %>% summarize(total = sum(count)) %>% as.numeric()

#total count of taxa otolith were collected from in all survey
oto_taxa <- voucher_all %>% filter(comment=="Age Sample") %>% nrow()

#total count of all survey otoliths collected
oto_all <- voucher_all %>% filter(comment=="Age Sample") %>% mutate(count = as.numeric(count)) %>% summarize(total = sum(count)) %>% as.numeric() 

#total count of otoliths collected from within 3nm
oto_3nm <- voucher_3nm %>% filter(comment=="Age Sample") %>% mutate(count = as.numeric(count)) %>% summarize(total = sum(count)) %>% as.numeric() 

#total count of taxa otoliths were collected from within 3nm
oto_3nm_taxa <- voucher_3nm %>% filter(comment=="Age Sample") %>% nrow()



# trying to figure out how to do 80% of the total wt and total wt within 3nm
total_wt_all_catch <- catch_summary %>% dplyr::mutate(total_weight_kg = as.numeric(total_weight_kg)) %>% summarize(total= sum(total_weight_kg)) %>% as.numeric()
total_wt_all_80 <- total_wt_all_catch*0.8   



total_wt_3nm_catch <- catch_summary_3nm %>% dplyr::mutate(total_weight_kg = as.numeric(total_weight_kg)) %>% summarize(total= sum(total_weight_kg)) %>% as.numeric()
total_wt_3nm_80 <- total_wt_3nm_catch*0.8 




#3nm counts of fish taxa vouchers vs invert taxa vouchers
fish_taxa_count_3nm <- voucher_count_3nm  %>% dplyr::mutate(taxon = dplyr::case_when(       
  species_code <= 31550 ~ "fish",       
  
  species_code >= 40001 ~ "invert"     
)) %>% dplyr::filter(taxon == "fish") %>% nrow()

invert_taxa_count_3nm <- voucher_count_3nm  %>% dplyr::mutate(taxon = dplyr::case_when(       
  species_code <= 31550 ~ "fish",       
  
  species_code >= 40001 ~ "invert"     
)) %>% dplyr::filter(taxon == "invert") %>% nrow()


#total survey area counts of fish taxa vouchers vs invert taxa vouchers
fish_taxa_all_count <- voucher_count %>%  dplyr::mutate(taxon = dplyr::case_when(       
  species_code <= 31550 ~ "fish",       
  
  species_code >= 40001 ~ "invert"     
)) %>% dplyr::filter(taxon == "fish") %>% nrow()

invert_taxa_all_count <- voucher_count %>%  dplyr::mutate(taxon = dplyr::case_when(       
  species_code <= 31550 ~ "fish",       
  
  species_code >= 40001 ~ "invert"     
)) %>% dplyr::filter(taxon == "invert") %>% nrow()

# Lookup table for species that won't get counts in catch summary tables -------
dashes_lookup <- taxonomy0 |>
  dplyr::filter(survey_species == 1) |>
  mutate(no_counts = case_when(
    phylum_taxon %in% c("Porifera", "Bryozoa") ~ 1,
    class_taxon == "Ascidiacea" ~ 1,
    subphylum_taxon == "Anthozoa" &
      order_taxon != "Actiniaria" &
      order_taxon != "Pennatulacea" ~ 1,
    TRUE ~ 0
  )) |>
  dplyr::filter(no_counts == 1)