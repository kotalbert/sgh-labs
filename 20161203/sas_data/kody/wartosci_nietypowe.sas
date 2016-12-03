%let zmienne=
app_char_nom2 app_char_nom4 app_char_int2 act_utl 
act_age act_loaninc app_income agr3_Max_Due 
agr6_Mean_Due act_n_good_days;

proc logistic data=&zb desc ;
model &tar= &zmienne;
title 'Model podstawowy';
output out=predict p=pred difdev=difdev
difchisq=difchisq h=h c=c dfbetas=_all_;
run;
/**/
/*The DIFDEV and DIFCHISQ are diagnostics for detecting which*/
/*observations contribute heavily to the disagreement between the data and*/
/*the predicted values of the fitted model. The range of DIFCHISQ is much*/
/*greater then DIFDEV.*/
/*DFBETAS are diagnostics that can be used to assess the effect of an*/
/*individual observation on each estimated parameter of the fitted model.*/
/*These statistics are useful in detecting observations that are causing*/
/*instability in the selected parameter estimates. Instead of re-estimating the*/
/*parameter each time an observation is deleted, PROC LOGISTIC uses the*/
/*one-step estimate.*/
/*C and CBAR are confidence interval displacement diagnostics. These*/
/*statistics are based on the same idea as the Cook distance in linear*/
/*regression. PROC LOGISTIC also computes these using the one-step*/
/*estimate.*/
/*H is the hat matrix diagonal. The diagonal elements of the hat matrix are*/
/*useful in detecting extreme points in the design space. However, if the*/
/*estimated probability is extreme (less than 0.1 and greater than 0.9), then*/
/*the hat diagonal may be greatly reduced in value. Consequently, when an*/
/*observation has a very large or very small estimated probability, its hat*/
/*diagonal value is not a good indicator of the observation’s distance from the*/
/*design space (Hosmer and Lemeshow 1989).*/
/*The deviance residuals (contribution of each observation to the deviance chisquare)*/
/*and Pearson residuals (contribution of each observation to the*/
/*Pearson chi-square) can also be used to determine which observations are*/
/*poorly fit by the model.*/
/**/

/* influence iplots;*/
proc gplot data=predict;
   plot difdev*pred / vref=4 vaxis=axis1;
   symbol i=none v=star;
   axis1 label=(a=-90 r=90);
   title 'Difference in Deviance by Predicted Probabilities';
run;
quit;

/**/
/*Hosmer and Lemeshow (1989) recommend plotting the influence statistics*/
/*such as the change in the Pearson chi-square against the predicted values.*/
/*Graphing these influence statistics may enable you to identify those covariate*/
/*patterns (subjects) that are poorly fit by the model. Examination of these*/
/*patterns may indicate that important variables are missing from the model*/
/*or that some of the variables in the model have not been entered in the*/
/*correct scale. These patterns may also identify erroneous data values.*/
/*The plot above is a plot of the change in the Pearson chi-square statistic by*/
/*the predicted probabilities. The points on the curve going from the upper-left*/
/*to the lower-right corner correspond to the covariate patterns with a response*/
/*value of 1. The points on the curve going from the upper-right to the*/
/*lower-left corners correspond to the covariate patterns with a response value*/
/*of 0. Covariate patterns that are poorly fit by the model will lie in the upperright*/
/*and left corners of the plot. The value of 4 is used as a suggested cut-off*/
/*because 4 is a crude approximation of the 95th percentile of the chi-square*/
/*distribution with 1 degree of freedom (Hosmer and Lemeshow 1989).*/
/**/
proc gplot data=predict;
   bubble difchisq*pred=c / bsize=7.5 vaxis=axis1;
   axis1 label=(a=-90 r=90 'Difference in Chi-Square');
   title1 h=1.5 'Difference in Pearson Chi-Square Statistic by Predicted Probabilities';
   title2 h=1.0 'With the Plotting Symbol Proportional to the C Diagnostic Statistic';
run;
quit;

/*Hosmer and Lemeshow (1989) also recommend plotting the diagnostic*/
/*statistics by the predicted probabilities where the size of the plotting symbol*/
/*is proportional to the effect of each covariate pattern on the value of the*/
/*estimated parameters. The GPLOT procedure can accomplish this with the*/
/*use of a bubble plot.*/
/*In the bubble plot above, the size of the bubbles is proportional to the c*/
/*diagnostic statistic. In general, the largest values of the c diagnostic statistic*/
/*are likely to occur when the change in the Pearson chi-square is large or*/
/*when the leverage is large (the diagonal of the hat matrix). The position of*/
/*the bubbles in the graph can give a general idea which statistic contributed to*/
/*the high c diagnostic statistic. For example, if the large bubbles occur in the*/
/*upper-right or left corner, then the change in the Pearson chi-square*/
/*contributed the most to the high c diagnostic statistic because leverage values*/
/*tend to be low when the estimated probabilities are below .10 or above .90.*/
/*However, if the bubbles fall in the bottom of the cup defined by the two*/
/*quadratic curves, then the leverage values contributed the most to the high c*/
/*diagnostic statistic. The points in the plot that are of greatest concern are*/
/*those with large circles falling within the cup. These correspond to covariate*/
/*patterns that are not fit very well and have high leverage values (Hosmer*/
/*and Lemeshow 1989).*/

/*Besides the observations with the large change in the Pearson chi-square*/
/*statistic, the observations with large circles near the bottom of the cup*/
/*defined by the quadratic curves should also be examined. These are*/
/*observations that influenced the parameter estimates to a relatively large*/
/*extent but are not poorly fitted observations (Hosmer and Lemeshow 1989).*/

/*proc univariate data=predict noprint;*/
/*   var difdev difchisq h c DFBETA:;*/
/*   output out=percentile pctlpts=95 pctlpre=p95 ;*/
/*run;*/
proc means data=predict noprint nway;
   var difdev difchisq h c DFBETA:;
   output out=percentile p95()= / autoname;
run;


data influence;
   if _n_ = 1 then set percentile;
   set predict;
   cutdifdev=(difdev ge difdev_p95);
   cutdifchisq=(difchisq ge difchisq_p95);
   cuthmatrix=(h ge h_p95);
   cutcdiag=(c ge c_p95);
   sum=cutdifdev+cutdifchisq+cuthmatrix+cutcdiag;
if sum gt 0;
run;

data predict;
set predict;
n=_n_;
run;
title 'DFBetas';
proc gplot data=predict;
plot (DFBETA:)*n;
run;
quit;


