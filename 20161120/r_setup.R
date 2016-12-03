# Laboratorium z przetwarzania danych
# 2016-10-15

# Biblioteki do realizacji poszczególnych zadań
library(sas7bdat)
library(dplyr)
library(lubridate)
library(stringr)

# Czytanie zbioru sas do 
# Biblioteka sas7bdat
# Funkcja sas7bdat::read.sas7bdat
readsas <- function(filename) {
  
  sasfolder <- './sas_data/'
  return (sas7bdat::read.sas7bdat(paste0(sasfolder, filename, '.sas7bdat')))
  
}

# Instalacja pod Linux 
# install.packages("assertthat")
# install.packages("magrittr")
# install.packages("lazyeval")
# install.packages("BH")
# install.packages("R6")
# install.packages("DBI")
# install.packages("http://cran.r-project.org/src/contrib/Archive/dplyr/dplyr_0.4.1.tar.gz", repos=NULL)
# install.packages("tidyr")
