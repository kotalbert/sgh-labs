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
model &tar= &zmienne;
title 'Model porz¹dkowy';
output out=p predprobs=i; 
run;


data test;
   set train_im;
   poz1 = (&tar=0);
   poz2 = (&tar=0 or &tar=1);
   poz3 = (&tar=0 or &tar=1 or &tar=2);
run;

%let zm=app_income;
proc rank data=test groups=15 out=group;
   var &zm;
   ranks bin;
run;

proc means data=group noprint nway;
   class bin;
   var poz: &zm;
   output out=bins1 sum(poz:)= mean(&zm)=;
run;
%let ilp=3;
data bins1;
   set bins1;
   array org(&ilp) poz1-poz&ilp;
   array logit(&ilp);
   do i=1 to &ilp;
   logit(i)=log((org(i)+1)/(_freq_-org(i)+1));
   end;
   drop i;
run;

proc gplot data=bins1;
   plot (logit1-logit&ilp)*&zm /overlay legend vaxis=axis1;
   axis1 label=(a=-90 r=90 "logit of cumulative probabilities") ;
   symbol1 i=join v=none line=1 color=black width=1;
   symbol2 i=join v=none line=1 color=red width=1;
   symbol3 i=join v=none line=1 color=blue width=1;
   symbol4 i=join v=none line=1 color=green width=1;
   title "Cumulative Logit Plot of &zm";
run;
quit;
/**/
/*Because there is a common slope for each predictor variable, the odds ratio is*/
/*constant for all the categories. The odds ratios can be interpreted as the effect*/
/*of the predictor variable on the odds of being in a lower rather than in a*/
/*higher category, regardless of what cumulative logit you are examining. If*/
/*you use the DESCENDING option, the odds ratio is the effect of the predictor*/
/*variable on the odds of being in a higher rather than a lower category. The*/
/*proportional odds model assumes that it does not matter how you*/
/*dichotomize the outcome variable (which categories are in the numerator and*/
/*denominator, maintaining the correct order)—the effects of the predictor*/
/*variables are always the same.*/
/*The proportional odds model is also invariant to the choice of the outcome*/
/*categories. There is some loss of efficiency when you collapse the ordinal*/
/*categories, but when the observations are evenly spread among the categories*/
/*the efficiency loss is minor. However, the efficiency loss is large when you*/
/*collapse the ordinal categories to a binary response (Agresti 1996).*/
/*The proportional odds model also makes no assumptions about the distances*/
/*between the categories. Therefore, how you code the ordinal outcome variable*/
/*has no effect on the odds ratios.*/

/*PROC LOGISTIC reports a score test for the proportional odds assumption.*/
/*This tests the null hypothesis that the slope coefficients are equal across the*/
/*cumulative logits for each predictor variable. However, this test may tend to*/
/*reject the null hypothesis more often than is warranted. If there are many*/
/*predictor variables and if the sample size is large, the test usually produces*/
/*p-values below 0.05 (SAS Institute Inc. 1995). Given such a liberal test, it*/
/*may be useful to graph the cumulative logits to visually inspect the*/
/*proportional odds assumption.*/
/*Cumulative logit plots are graphs of cumulative logits for each predictor*/
/*variable. If the proportional odds assumption is true, then the slopes of the*/
/*logits should be parallel. If the plots show strong crossover effects, then you*/
/*should consider a different modeling approach such as modeling generalized*/
/*logits*/
