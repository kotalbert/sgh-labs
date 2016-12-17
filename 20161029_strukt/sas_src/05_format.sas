proc format lib=work;
value wojfmt
2= 'DOLNO�L�SKIE'
4= 'KUJAWSKO-POMORSKIE'
6= 'LUBELSKIE'
8= 'LUBUSKIE'
10= '��DZKIE'
12= 'MA�OPOLSKIE'
14= 'MAZOWIECKIE'
16= 'OPOLSKIE'
18= 'PODKARPACKIE'
20= 'PODLASKIE'
22= 'POMORSKIE'
24= '�L�SKIE'
26= '�WI�TOKRZYSKIE'
28= 'WARMI�SKO-MAZURSKIE'
30= 'WIELKOPOLSKIE'
32= 'ZACHODNIOPOMORSKIE'
;
value dochfmt
	LOW - 2000 = orange
	2000 <- HIGH = green;
	;

run;

proc sql;
	create table zls as 
	select woj  label = "Wojew�dztwo" format=wojfmt.
	, mean(dochm) as dochm_avg label = "�redni doch�d" format= nlmnlpln10.2
	, sum(dochm) as dochm_sum label = "Suma dochod�w" format= nlmnlpln10.2
	, median(dochm) as dochm_median label="Mediana dochod�w" format= nlmnlpln10.2
	from dat.diagnoza07
	group by woj
	;
	run;
quit;

/*
Kolorowanie output
*/
proc print data=zls noobs;
	var woj / style (data) = [just=left];
	var dochm_avg /style (data) = [background=dochfmt.];
run;