# Wnioskowanie statystyczne

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
