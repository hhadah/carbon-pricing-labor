#######################################################################
# Master script
#######################################################################

## Clear out existing environment
rm(list = ls()) 
gc()

mdir <- here::here("GiT/carbon-pricing-labor")
workdir  <- "/Users/hhadah/Documents/GiT/carbon-pricing-labor" # working files and end data
rawdatadir  <- paste0(workdir,"/data/raw")
datasets  <- paste0(workdir,"/data/datasets")
thesis_tabs <- paste0(workdir,"/my_paper/tables")
thesis_plots <- paste0(workdir,"/my_paper/figures")
tables_wd <- paste0(workdir,"/output/tables")
figures_wd <- paste0(workdir,"/output/figures")
programs <- paste0(workdir,"/programs")

cps_data  <- "/Users/hhadah/Documents/GiT/jmp-decomposition-replication/data/raw"
### run do files and scripts

source(file.path(programs,"01_packages_wds.R"))                     # set up packages
source(file.path(programs,"02-data-cleaning.R"))                    # data cleaning
source(file.path(programs,"03-figure-one.R"))                       # figure 1

# Sound

beep("mario")
