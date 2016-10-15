# Laboratorium z przetwarzania danych
# 2016-10-15

# Ustawienie środowiska
# Uwaga - podana ścieżka tylko na komputerze SGH!
# d <- "C:\\Users\\pd94584p\\OneDrive - Szkoła Główna Handlowa w Warszawie\\sgh-labs\\20161015\\"
d <- "C:\\cygwin64\\home\\pd\\studia\\sgh-labs\\20161015\\"
source(paste0(d, "20161015_setup.R"))

# Zadanie z samochodami (sashelp.cars)
cars <- readsas('cars')

samochody <- dplyr::tbl_df(cars) %>%
  filter(Origin == "Asia" || Origin == "Europe") %>%
  select(Make:Origin, MSRP, EngineSize) %>%
  rename(
    make_pl = Make
    , model_pl = Model
    , origin_pl = Origin
    , type_pl = Type
    , msrp_pl = MSRP
    , engine_size = EngineSize
    )
  
View(samochody)

# Daty i ich funkcje
# Ćwiczenia na zbiorze sashelp.gulfoil
oil <- readsas('gulfoil')

# Funkcja do zamiany daty sas na datę R (pakiet lubridate)
s_date <- function(sas_date) {
  return (as_date(sas_date, origin=ymd("1960-01-01")))
}


oil2 <- tbl_df(oil) %>%
  mutate(date_ok = s_date(date)) %>%
  filter(regionname == "Central", year(date_ok) >= 2000, year(date_ok) <= 2005)

View(oil2)



# Liczby losowe

# ustaw seed - losuje inne liczby niż sas
set.seed(12345)

cars_rand <- tbl_df(cars) %>%
  mutate(ru = runif(n())) %>%
  filter(ru <= .25)

# Funkcje znakowe
company <- readsas("company")
colnames(company)
comp2 <- tbl_df(company) %>%
  select(LEVEL5) %>%
  mutate(imie = word(LEVEL5, 1), nazw = word(LEVEL5, -1),
         inic = paste0(substr(imie,1,1),".",substr(nazw,1,1),"."))
