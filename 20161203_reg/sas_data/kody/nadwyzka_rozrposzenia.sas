%let ods=listing;

/*%let ods=html;*/
/*ods html body='E:\moje\kurs\statystyka\STAT2\case proc logistic\dispersion.html';*/

/*dla proc logistic*/

ods &ods select GoodnessOfFit FitStatistics ParameterEstimates;
proc logistic data=sashelp.class;
model sex=age weight height,;
run;

/*ods trace on / listing;*/
/*ods trace off;*/


ods &ods select GoodnessOfFit FitStatistics ParameterEstimates;
proc logistic data=sashelp.class;
model sex=age weight height / scale=none aggregate;
run;

/*ods &ods select GoodnessOfFit FitStatistics ParameterEstimates;*/
/*proc logistic data=sashelp.class;*/
/*model sex=age weight height / scale=WILLIAMS  ;*/
/*run;*/

ods &ods select GoodnessOfFit FitStatistics ParameterEstimates;
proc logistic data=sashelp.class;
model sex=age weight height / scale=D  aggregate;
run;

ods &ods select GoodnessOfFit FitStatistics ParameterEstimates;
proc logistic data=sashelp.class;
model sex=age weight height / scale=P  aggregate;
run;

ods &ods select GoodnessOfFit FitStatistics ParameterEstimates;
proc logistic data=sashelp.class;
model sex=age weight height / scale=0.9  aggregate;
run;


/*dodatkowo*/

/*proc logistic data=sashelp.class;*/
/*model sex=age weight height / scale=none aggregate LACKFIT;*/
/*run;*/


/*dla proc genmod*/
ods &ods select ModelFit ParameterEstimates;
ods output ModelFit(persist=proc)=fit;
proc genmod data=sashelp.class;
model sex=age weight height / link=logit dist=b
aggregate=(age weight height);
run;


ods &ods select ModelFit ParameterEstimates;
proc genmod data=sashelp.class;
model sex=age weight height / link=logit dist=b scale=p
aggregate=(age weight height);
run;

ods &ods select ModelFit ParameterEstimates;
proc genmod data=sashelp.class;
model sex=age weight height / link=logit dist=b scale=d 
aggregate=(age weight height);
run;

ods &ods select ModelFit ParameterEstimates;
proc genmod data=sashelp.class;
model sex=age weight height / link=logit dist=b scale=0.5
aggregate=(age weight height);
run;
ods output close;

data fit;
set fit;
p_value=1-CDF('CHISQUARE',value,df);
format p_value pvalue8.4;
run;
proc print data=fit;
run;

/*ods html close;*/
