/*
Regresja logistyczna
Ćwiczeniania 2016-12-04
Score
*/

%let d=C:\Users\pd94584p\.babun\cygwin\home\pd94584p\sgh-labs\20161203\sas_data;

libname wej "&d.";
libname wyj "&d.\kody\dane\";
libname freki "&d.\kody\freq\" ;
libname testy "&d.\kody\testy\" ;

/*Definicja zmiennej celu*/
%let tar=default12;
%let zb=wyj.train_im;

/*Podział próby na zbiór treningowy i walidacyjny*/
%let prop=0.02;
data wyj.train wyj.valid;
set wej.abt_beh;
array tab(*) _numeric_;
do i=1 to dim(tab);
	if missing(tab(i)) then tab(i)=.;
end;
if ranuni(1)<0.6 then output wyj.train; else output wyj.valid;
where &tar in (0,1) and ranuni(1)<&prop;
drop i;
run;

%let zm_num_jakosciowe=
app_char_nom1 app_char_nom2 app_char_nom3 app_char_nom4
;

/*Definicja zmiennych analitycznych*/
%let zm_num_ilosciowe=
app_char_int1 app_char_int2 app_char_int3 app_char_int4 
act_days act_paid_installments act_utl act_dueutl 
act_due act_age act_cc act_dueinc act_loaninc app_income 
app_loan_amount app_n_installments act_seniority 
agr3_Mean_Due agr3_Max_Due agr3_Min_Due agr3_Mean_Days 
agr3_Max_Days agr3_Min_Days agr6_Mean_Due agr6_Max_Due 
agr6_Min_Due agr6_Mean_Days agr6_Max_Days agr6_Min_Days 
agr9_Mean_Due agr9_Max_Due agr9_Min_Due agr9_Mean_Days 
agr9_Max_Days agr9_Min_Days agr12_Mean_Due agr12_Max_Due 
agr12_Min_Due agr12_Mean_Days agr12_Max_Days agr12_Min_Days 
act_n_arrears act_n_arrears_days act_n_good_days 
;
%let wybrane_ilosciowe=act_n_arrears agr6_Max_Due act_utl
act_cc act_paid_installments app_income act_age;
%let wybrane_jakosciowe=
app_char_nom1 app_char_nom2 app_char_nom3 app_char_nom4
;


/*
Dopasowanie modelu i walidacja.
Przy braku zmiennej objaśnianej, 
procedura dopasuje model do danych
*/
data test;
set &zb end=e;
output;
if e then do i=1 to 20; 
	&tar=.;
	output; 
end;
drop i;
run;
proc logistic data=test desc 
outest=betas1;
model &tar = &wybrane_ilosciowe;
output out=score1 p=p upper=up lower=low;
run;
proc score data=score1(drop=&tar)
out=score2 score=betas1
type=parms;
var &wybrane_ilosciowe;
run;
data score2;
set score2;
p2=1/(1+exp(-&tar));
run;

/*
Dopasowanie modelu i walidacja
Dopasowany model na zbiorze uczącym i zapisanie modelu
Zastosowanie zapisanego modelu na zbiorze walidacyjnym
*/

proc logistic data=test desc 
outmodel=model1;
model &tar = &wybrane_ilosciowe;
run;
proc logistic inmodel=model1;
   score data=test out=test_score;
run;

/*
Przykład score
Zapis dzięki ods
*/
ods listing close;
ods html path="&d"
body="output_log.html";

	proc logistic data=sashelp.class
		outmodel=bety;
		model sex=age height / stb;
	run;

ods html close;
ods listing;

proc logistic inmodel=bety;
	score data=sashelp.class out=class_score;
run;

/*
Oversampling i przepróbkowanie
*/

/*Poprawki na prawdopodobieństwo*/
%let pi1=0.2;
proc means data=&zb noprint;
var &tar;
output out=sum mean=rho1;
run;

data sum;
set sum;
call symput('rho1',rho1);
run;
%put &rho1;

data test;
set &zb;
off=log(((1-&pi1)*&rho1)/(&pi1*(1-&rho1)));
run;

proc logistic data=test desc 
outest=betas2;
model &tar = &wybrane_ilosciowe
/ offset=off;
run;
proc score data=&zb(drop=&tar) out=scored 
score=betas2 type=parms;
var &wybrane_ilosciowe;
run;
data scored;
set scored;
p=1/(1+exp(-&tar));
run;
proc means noprint nway data=scored;
var p;
output out=stat1 mean()=;
run;
/*mo�na policzy� �redni� powinna by� zbli�ona do zadanej pi1*/
/*drugi sposob po policzeniu modelu wstawienie offset*/

proc logistic data=&zb desc outest=betas3;
model &tar = &wybrane_ilosciowe;
run;

proc score data=&zb(drop=&tar) out=scored 
score=betas3 type=parms;
var &wybrane_ilosciowe;
run;

data scored;
set scored;
off=log(((1-&pi1)*&rho1)/(&pi1*(1-&rho1)));
p=1/(1+exp(-(&tar-off)));
run;
proc means noprint nway data=scored;
var p;
output out=stat2 mean()=;
run;

/*przepr�bkowanie przez wagi*/
/****************************************************/
/****************************************************/
/*inny sposob perzez wagi*/
data test;
set &zb;
sampwt=((1-&pi1)/(1-&rho1))*(&tar=0) 
+(&pi1/&rho1)*(&tar=1);
run;
proc logistic data=test desc 
outest=betas4;
weight sampwt;
model &tar = &wybrane_ilosciowe;
run;

/*Metoda oparta o drzewo decyzyjne*/

%let do_sk=app_char_nom1;
proc logistic data=&zb desc;
class &do_sk;
model &tar=&do_sk;
run;
