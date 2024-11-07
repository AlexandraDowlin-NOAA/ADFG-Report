
# Support scripts --------------------------------------------------------------

source('./functions.R')

#skip connect and data_dl if data has already be recently downloaded
source('./connect_to_oracle.R')
source('./data_dl.R')

# if data already downloaded then:
catch0 <- read.csv("./data/oracle/racebase-catch.csv") %>% janitor::clean_names()
haul0 <- read.csv("./data/oracle/racebase-haul.csv") %>% janitor::clean_names()
specimen0 <- read.csv("./data/oracle/racebase-specimen.csv") %>% janitor::clean_names()
species0 <- read.csv("./data/oracle/racebase-species.csv") %>% janitor::clean_names()
stations_3nm0 <- read.csv("./data/oracle/ai-stations_3nm.csv") %>% janitor::clean_names()
# stations_3nm0 <- read.csv("./data/oracle/goa-stations_3nm.csv") %>% janitor::clean_names() odd years only
taxonomy0 <- read.csv("./data/oracle/gap_products-taxonomic_classification.csv") %>% janitor::clean_names()

# --------------------------
# Update based on survey and year 

# SRVY <- "GOA"
#cruise1 <- 202301

SRVY <- "AI"
cruise1 <- "202401"

# -------------------
source('./read.R') #creates tables needed for document
source('./data.R') #anaylsis of data for document


# -----------------------------
#Create document

# Create output folder if you don't already have one
dir.create(path = "./output")

# Create the day's output folder
dir_out <- paste0("./output/", Sys.Date())
dir.create(path = dir_out)
rmarkdown::render(paste0("./ADFG_REPORT.Rmd"),
                  output_dir = dir_out,
                  output_file = paste0(maxyr,"_ADFG_REPORT.docx"))

