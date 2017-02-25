## Metoda Helwiga - przyk³ad

setwd('c:/Users/pd94584p/Desktop/SP_WAS')
woj <- read.csv2('dane_rynek_pracy.csv')
x <- woj[, -1]

## Wyznaczenie macierzy korelacji
cr <- cor(x)
diag(c) <- 0
m <- apply(x, 1, mean)
std <- apply(x, 1, sd)
wz <- m/std

## Wyznaczenie pierwszej zmiennej centralnej i satelitów

# Pierwsza iteracja
i.cent <- which.max(wz) # indeks 1 zmiennej centralnej
c.c1 <- c[i.cent, -i.cent] # korelacje zmiennej centralnej i pozosta³ych
s1 <- which(c.c1 > 0.6) # indeksy satelity zmiennej centralnej

## Usuniêcie pierwszej zm. centralnej i jej satelitów z macierzy korelacji
c1 <- cr[-c(i.cent, s1), -c(i.cent, s1)]



