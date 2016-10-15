# Laboratorium z przetwarzania danych
# 2016-10-15

# Ustawienie środowiska
# Uwaga - podana ścieżka tylko na komputerze SGH!
d <- "C:\\Users\\pd94584p\\OneDrive - Szkoła Główna Handlowa w Warszawie\\sgh-labs\\20161015\\"
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

oil2 <- tbl_df(oil)
  # TODO: konwersja zmiennej date na poprawną datę.
  #filter(regionname == "Central", year(date) >= 2000, year(date) <= 2005)

View(oil2)

# Liczby losowe

# ustaw seed - losuje inne liczby niż sas
set.seed(12345)
nor <- rnorm(mean = 0, sd = 1, n = 1)


# Funkcje numeryczne

# Funkcje znakowe

  




