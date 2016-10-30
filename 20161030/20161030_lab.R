# Laboratorium z przetwarzania danych
# 2016-10-30

# Ustawienie środowiska
# Uwaga - podana ścieżka tylko na komputerze SGH!
d <- "C:\\Users\\pd94584p\\sgh-labs\\20161030\\"
# d <- "C:\\cygwin64\\home\\pd\\studia\\sgh-labs\\20161030\\"
source(paste0(d, "r_setup.R"))

diag <- readsas("diagnoza07")

# Losowanie proste
dplyr::sample_n(diag, 100)

# Rozkłady teoretyczne
# Rozkład normalny
x <- seq(from=-4, to=4, 0.01)
# Gęstość
py <- dnorm(x)
# Dystrybuanta
cy <- pnorm(x)
# Losowe obserwacje
y <- rnorm(1000)

par(mfrow=c(1,3), mar=c(3,4,4,2))
plot(x, py, col="blue",xlab="", ylab="Density"
     , type="l",lwd=2, cex=2, main="PDF of Standard Normal", cex.axis=.8)
plot(x,cy, col="red", xlab="", ylab="Cumulative Probability",
     type="l",lwd=2, cex=2, main="CDF of Standard Normal", cex.axis=.8)
hist(y)

# Testowanie statystyczne 

# Test t na równość średnich
x <- rnorm(1000, mean=1, sd=1)
t.test(x, mu = 1)

y <- rnorm(1000, mean=1, sd=10)
t.test(x,y)

z <- rnorm(1000, mean=0.5, sd=1)
t.test(x, z)

# Zadanie 1.
axles <- readsas("axles")
t.test(axles$xi, mu=24)
