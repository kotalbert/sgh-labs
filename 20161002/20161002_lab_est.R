# Wnioskowanie statystyczne

# Przykład 16

a <- 0.05
x_dash <- 4.2
sigma <- 0.0649
n <- 175

u_alpha <- qnorm(a/2)
lcl <- x_dash - abs(u_alpha)*(sigma/sqrt(n))
ucl <- x_dash + abs(u_alpha)*(sigma/sqrt(n))

d <-(ucl - lcl)


point_est <- x_dash + sigma/sqrt(n)
avg_err <- sigma/sqrt(n)
max_err <- 2 * avg_err
wzg_err <- d/x_dash
rozp <- 2 * max_err

# Przykład 13
# Policzyć, jakie przyjęto prawdopodobieństwo przy wyznaczeniu przedziałów ufności
n <-1200
w_i <- 960/n
d <- (0.822 - 0.777)/2
abs_u_alpha <- d/sqrt(w_i*(1-w_i)/n)
alpha <- dnorm(abs_u_alpha)

# Minimalna liczebność próby przy założeniu błędu 3%
n_min <- (abs_u_alpha^2*w_i*(1-w_i))/(0.03^2)

## Testowanie hipotez statystycznych
# Przykład 12

alpha = 0.05
n=800 
m_i <- 320
w_i <- m_i/n
p_0 <- 0.35

# Sformułowanie hipotez
# H_0: p == p_0 == 0.35
# H_1: p > p_0 różnice są statystycznie istotne

# Wyznacznie wartości statystyki
u <- (w_i - p_0)/sqrt((p_0*(1-p_0))/n)

# Przykład 16 cd.

alpha <- 0.05
m_0 <- 4.2
sigma <- 0.0649
n <- 175


# H_0: m == m_0 == 4
# H_1: m != m_0

m <- 4
u  <- ((m_0 - m)/sigma)*sqrt(n)

u_2a <- qnorm(1-2*alpha)
u_a <- qnorm(1-alpha)
