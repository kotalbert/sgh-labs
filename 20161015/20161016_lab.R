# Laboratorium z przetwarzania danych
# 2016-10-16

# Ustawienie środowiska
# Uwaga - podana ścieżka tylko na komputerze SGH!
d <- "C:\\Users\\pd94584p\\OneDrive - Szkoła Główna Handlowa w Warszawie\\sgh-labs\\20161015\\"
#d <- "C:\\cygwin64\\home\\pd\\studia\\sgh-labs\\20161015\\"
source(paste0(d, "20161015_setup.R"))

# Sortowanie danych
# Z1
prd <- readsas("prdsale")

prd_srt <- tbl_df(prd) %>%
  arrange(COUNTRY, desc(ACTUAL)) %>%
  View()

# Instrukcje warunkowe
recode <- function(sex) {
  if (sex == "M") return("chlopiec")
  return ("dziewczyna")
  
}
cls <- readsas("class")
plec <- sapply(cls$Sex, recode)
cls2 <- cbind(cls, plec)

# Z4
comp <- readsas("company")
premia <- function(job) {
  if (job == "MANAGER") return (1000)
  return (500)
}

premia <- sapply(comp$JOB1, premia)
comp2 <- cbind(comp, premia)

# Grupowanie

# Transpozycja


