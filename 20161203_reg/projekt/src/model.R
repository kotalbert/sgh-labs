# Projekt zaliczeniowy: Regresja logistyczna
# Dobór modelu na bazie porównania modeli zagnieżdżonych  

# Modele na zmiennych klasyfikujących
fit0 <- glm(target~1, data=nauka, family=binomial)

fit1 <- update(fit0, target~app_char_gender)
fit2 <- update(fit0, target~app_char_gender+app_char_job_code)
fit3 <- update(fit0,target~app_char_gender+app_char_job_code+app_char_marital_status)
fit4 <- update(fit0,target~app_char_gender+app_char_job_code+app_char_marital_status+
            app_char_city)
fit5 <- update(fit0,target~app_char_gender+app_char_job_code+app_char_marital_status+
            app_char_city+app_char_home_status)
fit6 <- update(fit0,target~app_char_gender+app_char_job_code+app_char_marital_status+
            app_char_city+app_char_home_status+app_char_cars)
fit7 <- update(fit0,target~app_char_gender+app_char_job_code+app_char_marital_status+
            app_char_city+app_char_home_status+app_char_cars+app_number_of_children)

anova(fit0, fit1, fit2, fit3, fit4, fit5, fit6, fit7, test="Chisq")

summary(fit7)

# Modele na zmiennych ciągłych
fit1a <- update(fit0, target~act_ccss_n_loan)
fit2a <- update(fit0, target~act_ccss_n_loan+act_call_n_loan)
fit3a <- update(fit0, target~act_ccss_n_loan+act_call_n_loan+act_age)

anova(fit0, fit1a,fit2a, fit3a, test="Chisq")

fit1b <- update(fit7, target~app_char_gender+app_char_job_code+app_char_marital_status+
            app_char_city+app_char_home_status+app_char_cars+app_number_of_children+
            act_ccss_n_loan+act_call_n_loan+act_age)

anova(fit0, fit7, fit1b, test="Chisq")

summary(fit1b)


