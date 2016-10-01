# Zadania do laboratorium 2016-10-01

## Zadanie 1
br_x <- c(1.5, 3.5, 2, 2, 1.5, 4.5, 3, 3, 1, 8)
br_n <- length(br_x)

# Średnia (miara przeciętnego poziomu)
br_sum <- sum(br_x)
br_mean <-br_sum/br_n
print(br_mean)

# Wariancja (miara zróżnicowania)
br_var <- sum((br_x - br_mean)^2)/(br_n-1) 
print(br_var)

br_std <- sqrt(br_var)
print(br_std)

#  Kurtoza (miara spłaszczenia, spiczastości, skupienia)
br_kurt <- sum((br_x - br_mean)^4)/((br_n - 1)*br_std^4)
print(br_kurt)

# Miara asymetrii
br_a <- sum((br_x - br_mean)^3)/((br_n - 1)*br_std^3)
print(br_a)

## Zadanie 2
k_x <- c(0,1,2,3,4)
k_n <- c(168, 181, 83, 17, 5)
print(k_n)

# Przedstawić graficznie podany rozkład
barplot(k_n, names.arg=c("0", "1", "2", "3", "4"), main="Rozkłąd liczby dzieci", 
        xlab="Liczba dzieci", ylab="Częstość")

# Wyznaczyć częstości względne
k_total <- sum(k_n)
k_w <- k_n/k_total
print(k_w)

# Wyznaczyć wartość dystrybuanty empirycznej
k_dx <- 1:length(k_x)
kdx <- function(i) {
  # Pomocnicza funkcja automatyzująca liczenie dystrybuanty empirycznej
  if (i == 1) {
    return (k_w[i])
  }
  return (k_dx[i-1]+k_w[i])

}

k_dx[1] <- kdx(1)
k_dx[2] <- kdx(2)
k_dx[3] <- kdx(3)
k_dx[4] <- kdx(4)
k_dx[5] <- kdx(5)

print(k_dx)

# Narysować wykres dystrubuanty empirycznej
plot(k_dx)

# Średnia arytmetycznia
k_mean <- sum(k_x * k_w) 
print(k_mean)

# Mediana
print(k_dx)

# Kwantyl I i III
# 
## zadanie 3

# Dane: średnia w przedziale i liczebność względna
# Dane pogrupowane, cecha ciągła

x <- c(15+25, 25+35, 35+45, 45+55, 55+65, 70+70)
x <- x/2
print(x)

w <- c(16.5, 23.5, 21, 19.5, 17, 2.5)
w <- w/100
print(w)

# Średnia
n <- length(x)
x_w_mean <- 1/sum(w/x)
print(x_w_mean)

# Wariancja
x_w_var <- sum((x - x_w_mean)^2* w) 
print(x_w_var)

# Odchylenie std.
x_w_std <- sqrt(x_w_var)

# Współczynnik zmienności
x_kurt <- sum((x - x_w_mean)^4*w)/x_w_var^2
print(x_kurt)

# Typowy obszar zmienności
x_typ_l <- x_w_mean - sqrt(x_w_var)
x_typ_p <- x_w_mean + sqrt(x_w_var)

out <- data.frame(x_w_mean, x_w_var, x_w_std, x_kurt, 
x_typ_l, x_typ_p)
print(out)


