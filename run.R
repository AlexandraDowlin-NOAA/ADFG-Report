
# Support scripts --------------------------------------------------------------

source('./functions.R')
source('./read.R')
# source('./code/data_dl.R')
source('./data.R')

dir_out <- paste0("./output/", Sys.Date())
dir.create(path = dir_out)
rmarkdown::render(paste0("./2023_ADFG_REPORT.Rmd"),
                  output_dir = dir_out,
                  output_file = paste0("2023_ADFG_REPORT.docx"))

