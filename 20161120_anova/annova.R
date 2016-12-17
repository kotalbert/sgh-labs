# Laboratorium
# 2016-11-19

# Analiza wariancji
source("r_setup.R")

# Zadanie 5.4 
v <- c(55, 54, 59, 56, 56,
      66, 76, 67, 71, 69,
      47, 51, 46, 48, 49,
      76, 81, 76, 79, 78)

x <- matrix(v, ncol=4)

# H0: mu1 = mu2 = mu3 = mu4
# H1: Co najmnieji jedno mu_i <> mu_j

# Statystyki
yh <- mean(x)
nt <- length(x)
yhi <- apply(x, 2, mean)
ni <- apply(x, 2, length)

# SST: total variation

# SBB: model variation
ssb <- sum(ni * (yhi - yh)^2)
# SSE: random variation



# liczba obserwacji
n <- length(x)

# liczba czynników grupujących
k <- ncol(x)

# całkowita średnia
tm <- mean(v)


# Zróżnicowanie międzygrupowe (Model, SSB, total variation)
ssb <- sum((v-tm)^2)

# Zróżnicowanie międzygrupowe (Błąd, SSE, treatment variation)
sse <- apply(x,2,mean) - tm
sse <- 5*sse^2
sse <- sum(sse)

# Zróżnicowanie całkowite (Razem skorygowane, SST, random variation)

# Zadanie 11

# Dane
math <- c(6, 6, 7, 6, 3, 3, 9, 9, 10, 9)
musi <- c(3,4,4,3,1,2,9,10,10,10)

f <- function(v) {
  x <- as.matrix(table(v))            
  v1 <- as.numeric(table(v))
  v2 <- as.numeric(rownames(x))
  v3 <- v1/length(v)
  c <- cbind(v1,v2,v3)
  return(as.matrix(c))
  
}
