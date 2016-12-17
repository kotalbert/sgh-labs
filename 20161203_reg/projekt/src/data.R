# Projekt zaliczeniowy: Regresja logistyczna
# Import danych do środowiska roboczego


fileimp <- function(fname) {
    # Wczytanie danych do przestrzeni roboczej
    fp <- paste0("../dane/", fname, ".dsv")
    o <- read.delim(fp, sep="|", dec=".")
    return (o)
}

nauka <- fileimp("nauka")
test <- fileimp("test")

library(dplyr)

dataconvert <- function(dset) {
# Przetworzenie danych - usunięcie braków
    o <- dset %>% dplyr::mutate(target=default12) %>%
        dplyr::filter(target != "I") %>%
        dplyr::mutate(target_fact = factor(target), target = as.numeric(target) - 1)
    return(o)
}

nauka <- dataconvert(nauka)
