/*3.1. Test istotnoœci dla œredniej*/
*Axles;
ods graphics on;
proc ttest data=bib1.axles h0=24 alpha=0.05 side=2 plots(only)=boxplot ;
	var xi;
run;

		*Wages;

/*3.1. Test istotnoœci dla ró¿nicy œrednich*/
*Klienci;
proc ttest data=bib1.klienci h0=0 alpha=0.05 side=l plots(only)=(boxplot histogram);
	var lklientow;
	class dzien;
run;
		*Wages;

/*Próby zale¿ne*/
ods graphics on;
proc ttest data=bib3.noise h0=0 alpha=0.05 side=2 plots(only)=(boxplot histogram);
	paired noise_l*noise_p;
run;

*Przyk³ad II;

proc sql;
 select
   mean(finance-marketing) as mean
  ,std(finance-marketing) as std
  ,count(*) as n
  ,calculated mean/ calculated std * sqrt(calculated n) as t
  ,quantile('t',0.95,calculated n-1) as t_crit
  ,1-probt(calculated t,calculated n - 1) as p_value
 from bib3.xm13_05;
quit;

/*Przyk³ad 4.7 Test istotnoœci dla wariancji*/
proc means data=bib1.axles;
 var xi;
run;

proc sql; 
	select
	count(*)-1 as df
	,calculated df * var(xi) / 0.13**2 as chi2
	,quantile('CHISQ',.95,calculated df) as critcal_value
	,1-probchi(calculated chi2,calculated df) as p_value
	from bib1.axles;
quit;

/*Test istotnoœci dla frakcji*/
proc freq data=bib1.elektronika;
	tables kanal / binomial(p=0.2 level="Internet") alpha=0.05;
run;

/*Przyk³ad 4.11 Test istotnoœci dla ró¿nicy dwóch frakcji*/
data soap;
set bib3.xm13_09;
x1=(Supermarket1=9077);
x2=(Supermarket2=9077);
run;

proc sql;
	select
	sum(x1) as x1
	,sum(x2) as x2
	,count(supermarket1) as n1
	,count(supermarket2) as n2
	,sum(x1)/count(supermarket1) as p1
	,sum(x2)/count(supermarket2) as p2
	,(calculated x1 +calculated x2)/(calculated n1 + calculated n2) as p
	,(calculated p1 - calculated p2)/
		sqrt(calculated p *(1 - calculated p)*(1/calculated n1 + 1/calculated n2))
		 as u
	,1-probnorm(calculated u) as p_value
	from soap;
quit;

/*Testy nieparamteryczne*/
*Test zgodnoœci rozk³adów;
proc univariate data=bib1.gosp08;
	var wydm;
	histogram  wydm / lognormal ;
run; 
data a;
	set bib1.gosp08;
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
set bib1.lody;
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
/*data s;*/
/*	set s;*/
/*	cumulative + y_pdf;*/
/*run;*/

symbol1 interpol=needle v=dot color=blue;
symbol2 interpol=needle v=dot color=red;
axis1 order=(0 to 9 by 1);
axis2 order=(0 to 1 by 0.1) label=("P(X = x)");
proc gplot data=s;
	plot y_pdf * x / haxis=axis1 vaxis=axis2;
	plot2 y_cdf * x /vaxis=axis2;
run;

/*Przyk³ad 4.14 Test niezale¿noœci chi-kwadrat*/

proc freq data = bib1.eurobarometr order=internal;
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
  from bib1.eurobarometr
  group by oznaczenie
 order by oznaczenie,konsekwencje;
quit;


proc sgplot data=a;
 series x=konsekwencje y=prc / group=oznaczenie;
run;
