# Laboratorium z przetwarzania danych
# 2016-10-29

# Biblioteki do realizacji poszczególnych zadań
library(sas7bdat)
library(dplyr)
library(lubridate)
library(stringr)
library(xlsx)

# Uwaga - tylko na komputerze z uczelni!
setwd(d);

# Czytanie zbioru sas do 
# Biblioteka sas7bdat
# Funkcja sas7bdat::read.sas7bdat
readsas <- function(filename) {
  
  sasfolder <- "./sas_data/"
  return (sas7bdat::read.sas7bdat(paste0(sasfolder, filename, '.sas7bdat')))
  
}

readxls <- function(filename, shind=1) {
  sasfolder <- "./sas_data/"
  fname_full <- paste0(sasfolder, filename, ".xls")
  df <- read.xlsx(fname_full, shind)
  return(df)
  
}
