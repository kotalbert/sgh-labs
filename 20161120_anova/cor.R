# Laboratorium 
# 2016-11-20

# Analiza  korelacji


 source("r_setup.R")

# Przykład 4.1
cexp <- readsas('cexp')
cor(cexp)
plot(cexp$HINC, cexp$CLOTEXP)

# Przykład 4.2
xm16_02 <- readsas('xm16_02')

# Przykład 4.3
# xr19_69

# Przykład 4.4
kraje <- readsas('kraje2008')
plot(kraje$PKB, kraje$ENERGIA)
k2 <- data.frame(kraje$PKB, kraje$ENERGIA)
cor(k2, method="kendall", use="pairwise")
