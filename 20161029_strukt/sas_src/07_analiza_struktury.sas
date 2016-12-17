proc contents data=dat.gosp08 out=out.gosp08_meta;
run;
*Analiza liczebnoœci;
proc format lib=work;
value edufmt
1="wy¿sze"
2="policealne"
3="œrednie zawodowe"
4="œrednie ogólnokszta³c¹ce"
5="zasadnicze zawodowe"
6="gimnazjalne"
7="podstawowe ukoñczone"
8="bez podstawowego"
;
run;

data gosp;
set dat.gosp08;
format edu edufmt.;
run;

/*Tabele jednoczynnikowe dla zmiennej EDU*/
ods graphics on;
proc freq data=work.gosp;
	tables edu / plots(only)=freq;
run;

/*Analiza jednoczynnikowa zmiennej DOCHM*/
data gosp_log;
set dat.gosp08;
doch_log = log10(dochm);
run;

proc means data=gosp_log mean std q1 median q3;
	var doch_log;
run;

ods graphics on;
proc univariate data=gosp_log noprint;
	var doch_log;
	histogram;
run;

proc sgplot data=gosp_log;
	vbox doch_log;
run; 
