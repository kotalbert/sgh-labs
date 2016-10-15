# Zadania do wykładu z analizy struktury.


# Zadanie 1
library(dplyr)
x <- c(1.5, 3.5, 2, 2, 1.5, 4.5, 3, 3, 1, 8)
x_sum <- sum(x)
x_n <- length(x)
x_avg <-x_sum/x_n 

x_var <- sum((x - x_avg)^2)/(x_n - 1)
x_std <- sqrt(x_var)

# Współczynnik asymetrii
x_A <- sum((x - x_avg)^3)/(length(x)*x_std^3)

# miara spłaszczenia: kurtoza 
x_k <- sum((x - x_avg)^4)/(length(x)*x_std^4)

sumry <- data.frame(x_avg, x_var, x_std, x_A, x_k)
print (sumry)
rm(list=ls())

# zadanie 2
x <- c(0,1,2,3,4)
n <- c(168, 181, 83, 17, 5)
n_sum <- sum(n)
w <- n/n_sum

# rozkłaz miennej X
barplot(n, names.arg = c("0", "1", "2", "3", "4"), main="Rozkład zmiennej X")

# dystrybuanta zmiennej X
x_cdf <- rep(1, length(x))
x_cdf
get_cdf <- function(i) {
  if (i == 1) {return (w[i])}
  return (w[i] + x_cdf[i-1])
}
x_cdf[1] = get_cdf(1)
x_cdf[2] = get_cdf(2)
x_cdf[3] = get_cdf(3)
x_cdf[4] = get_cdf(4)
x_cdf[5] = get_cdf(5)
print(x_cdf)
plot(x_cdf)

# miary położenia
x_avg <- sum(x*w)
sumry <- data.frame(x_avg)
print(sumry)
