# Laboratorium z przetwarzania danych
# 2016-10-15

# Ustawienie środowiska
# Uwaga - podana ścieżka tylko na komputerze SGH!
d <- "C:\\Users\\pd94584p\\OneDrive - Szkoła Główna Handlowa w Warszawie\\sgh-labs\\20161029\\"
# d <- "C:\\cygwin64\\home\\pd\\studia\\sgh-labs\\20161029\\"
source(paste0(d, "r_setup.R"))

# dane na ćwiczenia (diagnoza07.cars)
diagnoza07 <- readsas('diagnoza07')

library()












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
    ) %>%
  View()

# Daty i ich funkcje
# Ćwiczenia na zbiorze sashelp.gulfoil
oil <- readsas('gulfoil')

# Funkcja do zamiany daty sas na datę R (pakiet lubridate)
s_date <- function(sas_date) {
  return (as_date(sas_date, origin=ymd("1960-01-01")))
}

oil2 <- tbl_df(oil) %>%
  mutate(date_ok = s_date(date)) %>%
  filter(regionname == "Central", year(date_ok) >= 2000, year(date_ok) <= 2005) %>%
  View()

# Liczby losowe

# ustaw seed - losuje inne liczby niż sas
set.seed(12345)

# Za każdym razem inny seed -> do sprawdzenia
cars_rand <- tbl_df(cars) %>%
  mutate(ru = runif(n())) %>%
  filter(ru <= .25) %>%
  View()

# Funckje statystyczne

# Z1
cars_stat <- tbl_df(cars) %>%
  select(MPG_City, MPG_Highway, MSRP, Invoice) %>%
  mutate(mpg_avg = (MPG_City + MPG_Highway)/2, price_rng = abs(MSRP - Invoice))
  head(cars_stat)

# Z2
usd <- readsas("us_data")
pop_ind <- grep("POPU", colnames(usd))
pop_vls <- usd[, pop_ind]
pop_avg <- rowMeans(pop_vls)
us_mean_pop <- data_frame(usd$STATENAME, pop_avg)
colnames(us_mean_pop)[c(1,2)] <- c("statename", "avg_population")
us_pop_stats <- cbind(us_mean_pop, pop_vls)
head(us_pop_stats)


# Funkcje znakowe
# Z1
company <- readsas("company")
colnames(company)
comp2 <- tbl_df(company) %>%
  select(LEVEL5) %>%
  mutate(imie = word(LEVEL5, 1), nazw = word(LEVEL5, -1),
         inic = paste0(substr(imie,1,1),".",substr(nazw,1,1),"."))
  View()

# Z2
nwords <- function(string) {
  return(str_count(string, "\\S+"))
}

shoes <- readsas("shoes") %>% tbl_df %>%
  filter(nwords(Product) > 1) %>%
  mutate(Product = toupper(Product)) %>%
  View()

subset(shoes, nwords(shoes$Product) > 1)

