## Zmienna losowa - przykłady

# Dane wsadowe
x <- c(0,1,2,3,4)
p <- c(0.1, 0.2, 0.3, 0.3, 0.1)

# Średnia, wariancja, odchylenie standardowe
x_avg <- sum(x*p)
x_var <- sum((x-x_avg)^2*p)
x_std <- sqrt(x_var)
x_wsp_zm <- x_std/x_avg

x_var_simple <- sum(x^2*p) - x_avg^2

# określoć wartości dystrybuanty
x_f <- 1:5

get_xf <- function(i) {
  
  if (i == 1) {
    return (p[i])
  }
  return (x_f[i-1]+p[i])
  
}

x_f[1] <- get_xf(1)
x_f[2] <- get_xf(2)
x_f[3] <- get_xf(3)
x_f[4] <- get_xf(4)
x_f[5] <- get_xf(5)

barplot(x_f, main="Dystrybuanta empiryczna",  names.arg = c("0", "1", "2", "3", "4"),
        border = NA)

# Wyznaczyć prawdopodobieństwo sprzedaży od 2 do 4
p_2_4 <-  x_f[5] - x_f[3]

## Rozkłady zmiennej losowej - przykłady
# Przykład 8

# Rozkład wyjściowy N(20.5, 3.5)

mu <- 20.5
s <- 3.5
zarobki <- rnorm(10000, mu, s)
hist(zarobki)

# Rozkład wystandaryzowany
zarobki_std <- (zarobki - mu) / s
hist(zarobki_std)

# Prawdopodobieństwo, że zarobki [20.5. 24
f_20_5 <- pnorm(20.5, mu, s)
f_24 <- pnorm(24, mu, s)
p_20_5_25 <- f_24 - f_20_5
print(p_20_5_25)

# Rysowanie wykresów
max_u <- 1/(2*3.14)
max_x <- 1/((2*3.14)*3.5)

# Prawdopodobieństwo, że zarobki > 24
p_lt_24 <- 1 - pnorm(24, mu, s)

# Prawdopodobieństwo, że zarobki < 19
p_lt_19 <- pnorm(19, mu, s)
