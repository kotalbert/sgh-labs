%let prop=0.012;
data train;
set wej.abt_beh;
if default12=1 then default12=2;
if default12=.i then default12=1;
where ranuni(1)<&prop;
run;
proc stdize data=train out=train_im method=median reponly;
run;

%let zmienne=
app_char_nom2 app_char_nom4 app_char_int2 act_utl 
act_age act_loaninc app_income agr3_Max_Due 
agr6_Mean_Due act_n_good_days;

proc logistic data=train_im;
model &tar(ref=first)= &zmienne / link=glogit;
title 'Model nominalny';
output out=p predprobs=i; 
run;
