/*wspó³liniowoœæ*/
%let zmienne=
app_char_nom2 app_char_nom4 app_char_int2 act_utl 
act_age act_loaninc app_income agr3_Max_Due 
agr6_Mean_Due act_n_good_days;

proc logistic data=&zb desc ;
model &tar= &zmienne;
title 'Model podstawowy';
run;

proc reg data=&zb;
model &tar= &zmienne 
/ vif collin;
run;
quit;

proc corr data=&zb pearson spearman 
outp=pearson outs=spearman rank;
var &zmienne;
run;


proc princomp data=&zb out=prin;
var &zmienne;
run;

%let n=8;
proc princomp data=&zb out=prin n=&n;
var &zmienne;
run;
proc reg data=prin;
model &tar= prin1-prin&n
/ vif collin;
run;
quit;

proc logistic desc data=prin;
model &tar= prin1-prin&n;
run;
