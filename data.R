# Code for 2023_ADFG_REPORT markdown  ------------------------------------------

maxyr <- "2023"

region <-  "Gulf of Alaska" #"Aleutian Islands"  

regionw_abbr <-  "Gulf of Alaska (GOA)" # "Aleutian Islands (AI)"

region_abbr <- "GOA" # "AI"

dates_conducted <- "18 May and 6 August" #check dates for vessels

survnumber <- "seventeenth" #17 for GOA in 2023 (1993 to present) #14 for AI in 2024 (1991 to present) ##differs by survey

time_series <- "30 year time series" #Ask about this data point, X amount of years from survey standardization 

series_begun <- "1993" #AI is 1991 #GOA is 1993

vessel1 <- "FV Ocean Explorer"

vessel2 <- "FV Alaska Provider"


#successful biomass tows 526sql
s_stations <- haul0 %>% 
  filter(abundance_haul == "Y") %>%
  filter(cruise =="202301") %>%
  filter(region == "GOA") %>%
  distinct(stationid, stratum) %>% nrow()


#Total planned stations 
t_stations <- "520" # Confirmed this is the allocation for GOA 2023


#total of attempted hauls 555sql, 550 r
a_hauls <- haul0 %>% filter(region == "GOA") %>% filter(cruise == "202301") %>% filter(haul_type == "3") %>% nrow()
# MCS note: if you modify the SQL code to be haul_type = 3 (as in the R code) you'll get the same answer as R. I had 550 tows attempted in my data report!

#total of unsuccessful hauls 29sql, 24 r
u_hauls <- haul0 %>% filter(region == "GOA") %>% filter(cruise == "202301") %>% filter(abundance_haul == "N") %>% filter(haul_type == "3") %>% nrow() 
# MCS note: this one is the same. If you filter the sql script to be haul_type = 3 you'll get the same number as in R. I'm not sure which is better, but 24 is the number I have in my report, so I'd say we should stick to that one.

#stations within 3nm #123
stations_3nm <- haul0 %>% 
  filter(abundance_haul == "Y") %>%
  filter(cruise =="202301") %>%
  filter(region == "GOA") %>%
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


data_finalized <- "13 September, 2023"


# how to calculate 
total_wt_all_catch <- catch_summary %>% dplyr::mutate(total_weight_kg = as.numeric(total_weight_kg)) %>% summarize(total= sum(total_weight_kg)) %>% as.numeric()
total_wt_all_80 <- total_wt_all_catch*0.8   



total_wt_3nm_catch <- catch_summary_3nm %>% dplyr::mutate(total_weight_kg = as.numeric(total_weight_kg)) %>% summarize(total= sum(total_weight_kg)) %>% as.numeric()
total_wt_3nm_80 <- total_wt_3nm_catch*0.8 
