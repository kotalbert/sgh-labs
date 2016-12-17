/*jednowymiarowa analiza zmiennych*/
libname wyj 'c:\karol\podyplomowe\regresja_logistyczna\dla_studentow\kody\dane\' compress=yes;
libname testy 'c:\karol\podyplomowe\regresja_logistyczna\dla_studentow\kody\testy\' compress=yes;
%let tar=default12;
%let zb=wyj.train_im;

%let zm_char=;

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

data testy.moc_zmiennych;
length zmienna $32 c 8;
format c percent12.2;
delete;
run;


%macro licz_c_nom(zm,zb);
%let n=1;
%let z=z;
%do %until(&z eq);
%let z=%scan(&zm,&n,%str( ));
%if &z ne %then %do;
%if %sysfunc(exist(a)) %then %do;
proc delete data=a;
run;
%end;
ods listing close;
ods output Association=a;
	proc logistic data=&zb(keep=&tar &z) desc;
	class &z;
	model &tar=&z;
	run;
ods output close;
ods listing;
%let c=.;
data _null_;
set a;
where label2='c';
if _n_=1 then call symput("c",put(nValue2,best12.-L));
run;
proc sql noprint;
insert into testy.moc_zmiennych values ("&z",&c);
quit;
%let n=%eval(&n+1);
%end;
%end;
%mend;
%licz_c_nom(&zm_num_jakosciowe,&zb);


%macro licz_c_int(zm,zb);
%let n=1;
%let z=z;
%do %until(&z eq);
%let z=%scan(&zm,&n,%str( ));
%if &z ne %then %do;
%if %sysfunc(exist(a)) %then %do;
proc delete data=a;
run;
%end;
ods listing close;
ods output Association=a;
	proc logistic data=&zb(keep=&tar &z) desc;
	model &tar=&z;
	run;
ods output close;
ods listing;
%let c=.;
data _null_;
set a;
where label2='c';
if _n_=1 then call symput("c",put(nValue2,best12.-L));
run;
proc sql noprint;
insert into testy.moc_zmiennych values ("&z",&c);
quit;
%let n=%eval(&n+1);
%end;
%end;
%mend;
%licz_c_int(&zm_num_ilosciowe,&zb);

data testy.moc_zmiennych;
set testy.moc_zmiennych;
ar=abs(2*c-1);
format ar percent12.2;
run;
proc sort data=testy.moc_zmiennych;
by descending ar;
run;




