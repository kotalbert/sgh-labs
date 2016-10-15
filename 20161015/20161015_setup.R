# Laboratorium z przetwarzania danych
# 2016-10-15

# Biblioteki robocze
library(sas7bdat)
library(dplyr)
library(lubridate)

# Uwaga - tylko na komputerze z uczelni!
setwd(d);

# Czytanie zbioru sas do R
# Biblioteka sas7bdat
# Funkcja sas7bdat::read.sas7bdat
readsas <- function(filename) {
  
  sasfolder <- './sas_data/'
  return (sas7bdat::read.sas7bdat(paste0(sasfolder, filename, '.sas7bdat')))
  
}
