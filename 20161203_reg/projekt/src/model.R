# Projekt zaliczeniowy: Regresja logistyczna
# Dobór modelu na bazie porównania modeli zagnieżdżonych  

fit0 <- glm(target~1, data=nauka, family=binomial)
fit1 <- glm(target~app_char_gender)
fit2 <- glm(target~app_char_gender+app_char_job_code)
fit3 <- glm(target~app_char_gender+app_char_job_code+app_char_marital_status)
fit4 <- glm(target~app_char_gender+app_char_job_code+app_char_marital_status+
            app_char_city)
fit5 <- glm(target~app_char_gender+app_char_job_code+app_char_marital_status+
            app_char_city+app_char_home_status)
fit6 <- glm(target~app_char_gender+app_char_job_code+app_char_marital_status+
            app_char_city+app_char_home_status+app_char_cars)
anova(fit0, fit1, fit2, fit3, fit4, fit5, fit6)

summary(fit6)
