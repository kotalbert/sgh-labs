/*Testy nieparamteryczne*/
*Test zgodnoœci rozk³adów;
proc univariate data=dat.gosp08;
	var wydm;
	histogram  wydm / lognormal ;
run; 

/*Rêczne wyliczenie dystrybuanty empirycznej*/
data a;
	set dat.gosp08;
	*Wyznaczenie logarytm;
	u=log(wydm);
	keep wydm u;
	proc sort; by wydm;
run;

*Standaryzacja;
proc standard data=a out=a2 mean=0 std=1;
	var u;
run;

data a3;
set a2;
n=1500;
*Theoretical distribution;
cdf = probnorm(u);
*Empirical distribution;
edf = _n_/n;
*Kolmogorov-Smirnov;
dif = abs(cdf - edf);
proc sort; by descending dif;
run;

/*Przyk³ad 4.13 Test znaków (istotnoœci mediany)*/
data lody;
set dat.lody;
d=cukiern-cukiers;
run;

proc univariate data=lody mu0=0 loccount;
	var d;
run; 

data critical_value;
bin=2*probbnml(0.5,9,3);
*bin2=probbnml(0.5,9,3)+(1-probbnml(0.5,9,5));
run;


*Binomial distribution;
data s;
	do x=0 to 9;
		y_pdf = pdf('binomial',x,0.5,9);
		y_cdf = cdf('binomial',x,0.5,9);
		output;
	end;
run;

symbol1 interpol=needle v=dot color=blue;
symbol2 interpol=needle v=dot color=red;
axis1 order=(0 to 9 by 1);
axis2 order=(0 to 1 by 0.1) label=("P(X = x)");
proc gplot data=s;
	plot y_pdf * x / haxis=axis1 vaxis=axis2;
	plot2 y_cdf * x /vaxis=axis2;
run;

/*Przyk³ad 4.14 Test niezale¿noœci chi-kwadrat*/

proc freq data = dat.eurobarometr order=internal;
weight liczebnosc; 
tables oznaczenie * konsekwencje / 
nocol nopercent nocum nofreq chisq; 
run;


/* Test niezale¿noœci chi-kwadrat - Wykres*/
proc sql;
 create table a as select
  oznaczenie
  ,konsekwencje
  ,liczebnosc as n
  ,liczebnosc/sum(liczebnosc) as prc
  from dat.eurobarometr
  group by oznaczenie
 order by oznaczenie,konsekwencje;
quit;


proc sgplot data=a;
 series x=konsekwencje y=prc / group=oznaczenie;
run;
