/*
Regresja logistyczna - projekt zaliczeniowy.
Pawe³ Daniluk
pd94584p
2016-12-18
*/

/*Deklaracja bibioteki roboczej*/
%let wd=../dane;
libname dane "&wd.";

/*Zbiór z poprawnymi wartoœciami zmiennej objaœniaj¹cej*/
data work.nauka2;
set dane.nauka;
where default12 in (0,1);
run;

/*
Dopasowanie modelu regresji logistycznej.
Modelowanie prawdopodobieñstwa zdarzenia default12=1
*/

%let catvar=
app_char_gender app_char_job_code app_char_marital_status
app_char_city app_char_home_status app_char_cars app_number_of_children
;

%let numvar = 
act_ccss_n_loan act_call_n_loan act_age
;

/*Seleckja zmiennych do modelu*/
proc logistic data=work.nauka2
	outmodel=work.mod;
class &catvar.;
model default12 (event='1') = &catvar. &numvar. / selection=stepwise;
run;

/*Finalny mokdel*/
%let catvar_fin=
app_char_gender
app_char_job_code
app_char_marital_status
app_char_city

;

%let numvar_fin=
app_number_of_children
act_ccss_n_loan 
act_call_n_loan 
act_age
;

ods listing close;
ods html body="&wd./output.html";

proc logistic data=work.nauka2
	outmodel=work.mod;
class &catvar_fin.;
model default12 (event='1') = &catvar_fin. &numvar_fin.;
run;

ods html close;
ods listing;

/*Backtest modelu na zbiorze testowym*/

proc logistic inmodel=work.mod;
	score data=dane.test out=work.predict;
run;

data dane.pawel_daniluk_logit_test;
set work.predict;
pd=p_1;
keep aid pd;
run;
