/*
Województwa, œredni dochód, suma dochodów
*/
proc means data=dat.diagnoza07 noprint;
	by woj;
	output out=diag_woj (drop=_TYPE_ _FREQ_)
	sum(dochm)=doch_suma
	mean(dochm)=doch_mean
	median(dochm)=doch_median
	;
run;

proc sort data=diag_woj;
by woj;
run;

/*To samo za pomoc¹ SQL*/
proc sql;

create table diag_woj_sql as 
select 
	woj
	, sum(dochm) as doch_suma label = "Suma dochodu"
	, avg(dochm) as doch_avg label = "Œrednia dochodu"
	, median(dochm) as doch_median label = "Mediana dochodu"
from dat.diagnoza07
group by woj;

quit;