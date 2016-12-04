/*
Regresja logistyczna
Ćwiczeniania 2016-12-03
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

/*Analiza rozkładu reszt*/
goptions reset=all;
proc reg data=&zb outest=b1;
   model &tar=&wybrane_ilosciowe;
   plot r.*obs.;
   plot r.*p.;
   plot &tar*p.;
   output out=r p=p r=r;
run;
quit;

data test;
set &zb;
nowa=&tar*100;
keep &tar &wybrane_ilosciowe nowa;
run;
proc reg data=test outest=b100;
   model &tar=&wybrane_ilosciowe;
   output out=r p=p r=r;
run;
quit;
proc univariate data=r;
var r;
histogram / normal;
probplot / normal;
run;

%let wybrane=app_income act_age act_utl;
proc rank data=wyj.train_im out=beh groups=9;
var &wybrane;
run;
proc means data=beh noprint nway;
class &wybrane;
var default12;
output out=stat mean()=;
run;
data stat;
set stat;
logit=log((default12+(sqrt(_freq_)/2))/(_freq_-default12+(sqrt(_freq_)/2)));
run;
proc gchart data=stat;
vbar3d default12 / levels=15 type=percent;
run;
quit;
proc gchart data=stat;
vbar3d logit / levels=15 type=percent;
run;
quit;

data ran;
do i=1 to 10000;
	n=rannor(1);
	p=1/(1+exp(-n+4));
	logit=log(p/(1-p));
	output;
end;
run;
proc gchart data=ran;
vbar3d p / levels=15 type=percent;
run;
quit;
proc gchart data=ran;
vbar3d logit / levels=15 type=percent;
run;
quit;

/*Uruchomienie regresji logistycznej*/
proc logistic data=&zb outest=log desc;
   model &tar=&wybrane_ilosciowe;
   output out=l p=p resdev=r reschi=chi;
run;
proc univariate data=l;
var r chi;
histogram / normal;
probplot / normal;
run;
