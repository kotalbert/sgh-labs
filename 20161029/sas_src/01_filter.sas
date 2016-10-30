/*Wy�wierlenie matadanych zbioru*/
proc contents data=dat.diagnoza07 out=out.diagnoza_metadane;
run;

/*Filtrowanie za pomoc� data step*/
proc sort data=dat.diagnoza07 
	(where=(woj=02 & dochm>0))
	out=work.diagnoza;
	by dochm;
run;
/*
Wyznaczenie wieku
Filtr doch�d[1k,3k]
*/

data diag_filtr;
set dat.diagnoza07;
where dochm between 1000 and 3000;
if ^missing(rok) and rok>0 then	
	wiek = year(today())-(1900+rok);
else
	wiek = .;
run;

/*
Posortowa� malej�co po nowej zmiennej wiek
*/

proc sort data=diag_filtr
	out=diag_sort;
	by descending wiek ;
run;

