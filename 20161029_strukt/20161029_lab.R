# Laboratorium z przetwarzania danych
# 2016-10-15

# Ustawienie środowiska
# Uwaga - podana ścieżka tylko na komputerze SGH!
d <- "C:\\Users\\pd94584p\\sgh-labs\\20161029\\"
# d <- "C:\\cygwin64\\home\\pd\\studia\\sgh-labs\\20161029\\"
source(paste0(d, "r_setup.R"))

# Import/Eksport plików

# dane na ćwiczenia (diagnoza07.cars)
df <- readsas('diagnoza07')
diagnoza07 <- tbl_df(df)
rm(df)

# dane na ćwiczenia (axles.xls)
axles <- readxls("axles")

# Eksport do pliku
hr <- readsas("hpraca")
write.csv(x=hr, file = ".\\out\\hr.csv")

# Filtrowanie i sortowanie danych
diag_filt  <- diagnoza07 %>%
  filter(woj == 2, DOCHM>0)
