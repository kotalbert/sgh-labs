# Laboratorium 
# 2016-11-20

# Analiza  regresji

 source("r_setup.R")

cexp  <- readsas('cexp')
m <- lm(CLOTEXP ~ HINC, data=cexp)
summary(m)
plot(cexp$CLOTEXP, cexp$HINC)
abline(lm(cexp$CLOTEXP ~ cexp$HINC))

plot(m)
