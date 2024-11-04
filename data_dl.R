## Download data sets to local machine -------------------------------------------------------

# RACEBASE tables to query
locations <- c(
  ## General Tables of data (racebase)
  "RACEBASE.HAUL",
  "RACEBASE.SPECIMEN",
  "RACEBASE.CRUISE",
  "RACEBASE.CATCH",
  "RACEBASE.SPECIES",
  
  ## Race Data tables
  "RACE_DATA.RACE_SPECIES_CODES",
  # "RACE_DATA.CRUISES",
  "RACE_DATA.V_CRUISES",
  # "GOA.STATIONS_3NM" #hastag out depending on what year your are reporting
  "AI.STATIONS_3NM" #hashtag out depending on what year your are reporting, maybe create IF ELSE statement
)


if (!file.exists("data/oracle")) dir.create("data/oracle", recursive = TRUE)


# downloads tables in "locations"
for (i in 1:length(locations)) {
  print(locations[i])
  filename <- tolower(gsub("\\.", "-", locations[i]))
  a <- RODBC::sqlQuery(channel, paste0("SELECT * FROM ", locations[i]))
  write_csv(
    x = a,
    here::here("data", "oracle", paste0(filename, ".csv"))
  )
  remove(a)
}

## Get RACEBASE data -----------------------------------------------
# This local folder contains csv files of all the  tables. reads downloaded tables into R environment
a <- list.files(
  path = here::here("data", "oracle"),
  pattern = "\\.csv"
)

for (i in 1:length(a)) {
  b <- read_csv(file = here::here("data", "oracle", a[i]))
  b <- janitor::clean_names(b)
  if (names(b)[1] %in% "x1") {
    b$x1 <- NULL
  }
  assign(x = paste0(str_extract(a[i], "[^-]*(?=\\.)"), "0"), value = b)
  rm(b)
}
