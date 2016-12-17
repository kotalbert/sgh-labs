# Projekt zaliczeniowy: Regresja logistyczna
# Wizualizacja danych na potrzeby doboru zmiennych predykcyjnych 

library(ggplot2)

# Analiza danych kategorycznych w zbiorze
owa <- function(vname) {
    g <- ggplot(nauka, aes_string(x=vname,y="target"))+
        stat_summary(fun.y="mean", geom="bar", color="black", fill="lightblue") + 
        ggtitle(paste("DR", vname)) + 
        ylab("DR")

    # Anova
    d <- dplyr::mutate_(nauka, v=vname)
    a <- aov(target ~ v, data=d)

    print(g)
    summary(a)
}

owa("app_char_gender")
owa("app_char_job_code")
owa("app_char_marital_status")
owa("app_char_city")
owa("app_char_home_status")
owa("app_char_cars")
owa("app_number_of_children")
dev.off()

# Analiza danych ciągłych w zbiorze
owa2 <- function(vname) {
    # Wykres pudełkowy
    g <- ggplot(nauka, aes_string(x="target_fact", y=vname)) + 
        geom_boxplot() +
        ggtitle(paste("Rozkład", vname)) +
        xlab("Flaga default")
    # Test t
    td <- dplyr::mutate_(nauka, v=vname)
    v1 <- td$v[td$target == 1]
    v2 <- td$v[td$target == 0]
    tt <- t.test(v1, v2)

    print(tt)
    print(g)
    
}

owa2("act_age")
owa2("act_cc")
owa2("act_loaninc")
owa2("app_income")
owa2("act_call_cc")
owa2("act_cins_n_loan")
owa2("act_ccss_n_loan")
owa2("act_call_n_loan")
owa2("act_cins_seniority")
owa2("act_cins_min_seniority")
owa2("act_cins_n_loans_hist")
owa2("act_cins_n_statC")	
owa2("act_cins_n_statB")
dev.off()
