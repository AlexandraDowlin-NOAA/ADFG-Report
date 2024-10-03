
# Support scripts --------------------------------------------------------------

source('./functions.R')
source('./connect_to_oracle.R')
source('./read.R')           #after initial download of data, hash tag this line out.
# source('./code/data_dl.R')
source('./data.R')

# Create output folder if you don't already have one
dir.create(path = "./output")

# Create the day's output folder
dir_out <- paste0("./output/", Sys.Date())
dir.create(path = dir_out)
rmarkdown::render(paste0("./ADFG_REPORT.Rmd"),
                  output_dir = dir_out,
                  output_file = paste0(maxyr,"_ADFG_REPORT.docx"))

