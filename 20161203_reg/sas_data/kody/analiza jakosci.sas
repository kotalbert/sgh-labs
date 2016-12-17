/*analiza jakoœci zmiennych*/
libname wyj 'c:\karol\podyplomowe\regresja_logistyczna\dla_studentow\kody\dane\' compress=yes;
libname testy 'c:\karol\podyplomowe\regresja_logistyczna\dla_studentow\kody\testy\' compress=yes;
libname freki 'c:\karol\podyplomowe\regresja_logistyczna\dla_studentow\kody\freq\' compress=yes;

%let tar=default12;
%let zb=wyj.train;

/*%let zm_char_jakosciowe=;*/

%let zm_num_jakosciowe=
app_char_nom1 app_char_nom2 app_char_nom3 app_char_nom4
;

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

/**/
/*proc datasets lib=testy kill;*/
/*quit;*/

/*testy dla num ilosciowych*/
proc means data=&zb noprint;
var &zm_num_ilosciowe;
output out=stat_ilosciowe 
min()= max()= mean()= p1()= p99()= p5()= p95()= nmiss()=/ autoname;
run;
proc transpose data=stat_ilosciowe out=ts_ilosciowe;
var _numeric_;
run;
data stat;
length stat $ 10 nazwa $ 32;
set ts_ilosciowe(firstobs=3);
stat=scan(_name_,-1,'_');
nazwa=substr(_name_,1,length(_name_)-length(stat)-1);
run;
proc sort data=stat;
by nazwa;
run;
proc transpose data=stat out=testy.stat_zm_ilosciowe(drop=_name_);
id stat;
by nazwa;
var col1;
run;
data _null_;
set stat_ilosciowe;
call symput('il_obs',put(_freq_,best12.-L));
run;
data testy.stat_zm_ilosciowe;
set testy.stat_zm_ilosciowe;
Percent_Miss=nmiss/&il_obs;
format Percent_Miss percent12.2;
run;

/*dodatkowe dla ilosciowych liczenie mody i liczby unikalnych wartosci*/
/*moda i procenty i ilosci bez brakow danych*/
data mody;
length nazwa $ 32 Moda Pr_moda Il_moda Il_Uni 8;
format Pr_moda percent12.2;
delete;
run;

%macro licz_mody(zm);
%let n=1;
%let z=z;
%do %until(&z eq);
%let z=%scan(&zm,&n,%str( ));
%if &z ne %then %do;
proc freq data=&zb(keep=&z) noprint;
table &z / out=f missing;
run;
proc sort data=f;
by descending percent;
where &z is not missing;
run;
%let pr_moda=0;
%let il_moda=0;
%let moda=.P;
%let n_uni=0;
proc sql noprint;
select PERCENT/100,COUNT,&z format=best12. into :pr_moda,:il_moda,:moda
from f(obs=1);
quit;
%put &pr_moda &il_moda &moda;
data _null_;
set f(obs=1) nobs=il;
call symput("n_uni",put(il,best12.-L));
run;
%put &n_uni;
proc sql noprint;
insert into mody values("&z",&moda,&pr_moda,&il_moda,&n_uni);
quit;
%let n=%eval(&n+1);
%end;
%end;
%mend;
%licz_mody(&zm_num_ilosciowe);

proc sort data=testy.Stat_zm_ilosciowe;
by nazwa;
run;
proc sort data=mody;
by nazwa;
run;
data testy.Stat_zm_ilosciowe;
merge testy.Stat_zm_ilosciowe mody;
by nazwa;
run;


/*testy dla jakosciowych*/

%macro zrob_freki(zm,zb);
%let n=1;
%let z=z;
%do %until(&z eq);
%let z=%scan(&zm,&n,%str( ));
%if &z ne %then %do;
proc freq data=&zb(keep=&z) noprint;
table &z / missing out=freki.&z;
run;
proc sort data=freki.&z;
by descending COUNT;
run;
%let n=%eval(&n+1);
%end;
%end;
%mend;
%zrob_freki(&zm_num_jakosciowe, &zb);
/*%zrob_freki(&zm_char_jakosciowe, &zb);*/

