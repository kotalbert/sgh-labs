# Laboratorium z przetwarzania danych
# 2016-10-29

# Ustawienie środowiska
# Uwaga - podana ścieżka tylko na komputerze SGH!
d <- "C:\\Users\\pd94584p\\sgh-labs\\20161029\\"
# d <- "C:\\cygwin64\\home\\pd\\studia\\sgh-labs\\20161029\\"
source(paste0(d, "r_setup.R"))

# dane na ćwiczenia (diagnoza07.cars)
df <- readsas('diagnoza07')
diag <- tbl_df(df)
rm(df)

# import z xls (axles.xls)
axles <- readxls("axles")

# Filtrowanie i sortowanie danych
diag_02 <- diag %>% filter(WOJ==02 & DOCHM > 0) %>%
  arrange(DOCHM)

# Dochód z przedziału 1k-3k, posortowany malejąco
diag_1_3k <- diag %>% filter(DOCHM >= 1000 & DOCHM <=3000) %>%
  arrange(desc(DOCHM))

# Wyliczenie wieku w latach i sortowanie po wieku
diag_wiek <- diag %>% filter(DOCHM >= 1000 & DOCHM <= 3000) %>%
  mutate(wiek=year(Sys.Date()) - (1900+ROK)) %>%
  arrange(desc(wiek))

# Agregacja dochodów na poziomie województw
diag_woj <- diag %>% 
  group_by(WOJ) %>%
  summarise(doch_sum = sum(DOCHM), doch_mean = mean(DOCHM), doch_median=median(DOCHM))

# Łączenie zbiorów
bezr <- readsas("bezrobocie")
# Base
# diag_bezr <- merge(x=diag_woj, y=bezr, by.x = "WOJ", by.y = "WOJID")

# dplyr
diag_bezr <- inner_join(x=diag_woj, y=bezr, by=c("WOJ" = "WOJID"))

# Analiza struktury zmiennych ciągłych i dyskretnych

# Zmienna dyskretna
gosp <- readsas("gosp08")
gosp_freq <- gosp %>% group_by(EDU) %>%
  summarise(n = n()) %>%
  mutate(freq = n/sum(n))

barplot(gosp_freq$freq, names.arg = gosp_freq$EDU)

# Zmienna ciągła
log_doch <- log10(gosp$DOCHM)

## Add an alpha value to a colour
add.alpha <- function(col, alpha=1){
  if(missing(col))
    stop("Please provide a vector of colours.")
  apply(sapply(col, col2rgb)/255, 2, 
        function(x) 
          rgb(x[1], x[2], x[3], alpha=alpha))  
}

summary(gosp$DOCHM)
summary(log_doch)

c <- add.alpha("blue", 0.7)

t <-"log[10](doch)"
hist(log_doch, col=c, ylab=expression(log[10]))
boxplot(log_doch, col=c, ylab=t)





