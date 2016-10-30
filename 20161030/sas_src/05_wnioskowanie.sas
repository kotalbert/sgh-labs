/*3.1. Test istotnoœci dla œredniej*/
*Axles;
ods graphics on;
proc ttest data=dat.axles h0=24 alpha=0.05 side=2 plots(only)=boxplot ;
	var xi;
run;

		*Wages;

/*3.1. Test istotnoœci dla ró¿nicy œrednich*/
*Klienci;
ods graphics on;
proc ttest data=dat.klienci 
	h0=0 
	alpha=0.05 
	side=l plots(only)=(boxplot histogram);
	var lklientow;
	class dzien;
run;

/*Próby zale¿ne*/
ods graphics on;
proc ttest data=dat.noise h0=0 alpha=0.05 side=2 plots(only)=(boxplot histogram);
	paired noise_l*noise_p;
run;


/*Zadanie 4.2*/
ods graphics on;
proc ttest data=dat.wages
	plots(only)=summary
	alpha=0.05
	h0=9
	side=u
	ci=equal;
	var wage;
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
 from dat.xm13_05;
quit;

/*Przyk³ad 4.7 Test istotnoœci dla wariancji*/
proc means data=dat.axles;
 var xi;
run;

proc sql; 
	select
	count(*)-1 as df
	,calculated df * var(xi) / 0.13**2 as chi2
	,quantile('CHISQ',.95,calculated df) as critcal_value
	,1-probchi(calculated chi2,calculated df) as p_value
	from dat.axles;
quit;

/*Test istotnoœci dla frakcji*/
proc freq data=dat.elektronika;
	tables kanal / binomial(p=0.2 level="Internet") alpha=0.05;
run;

/*
Przyk³ad 4.11 Test istotnoœci dla ró¿nicy dwóch frakcji
Przyk³ad o kosmetykach
*/
data soap;
set dat.xm13_09;
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

