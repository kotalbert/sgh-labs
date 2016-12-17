proc format lib=work;
	value wymczpfmt
	1="Pe³ny etat"
	0="Inny"
;
run;
data d;
	set dat.diagnoza07;
	wymczp=(htyg>=40);
	format wymczp wymczpfmt.;
run;

proc gchart data=d;
	pie wymczp / 
	slice=arrow /*linia do statystyki*/
	percent=inside
	discrete;
run;
*Wykres s³upkowy;
proc sql;
   create table z1c as 
   select woj format=wojfmt.
          ,mean(dochm) label="mean" format=NLMNLPLN12.2 as mean
      from dat.diagnoza07
      group by woj            
;
quit;

proc gchart data=z1c;
	vbar woj / sumvar=mean frame discrete
	descending
	coutline=black;
	format mean nlmnipln12.2;
run; 

*Wykres mapowy;
*Utwórz zmienn¹ ID zgodn¹ z opisywan¹ jednostk¹ administracyjn¹ - wojewódzwto;
data z1d;
	set z1c;
	wojid+1;
run;

*Sortowanie po zmiennej ID;
proc sort data=z1d;
	by wojid;
run;
proc sort data=maps.poland2 out=poland2;
	by wojid;
run;

*£¹czenie zbioru wejœciowego ze zbiorem z jednostkami administracyjnymi;
data z1e;
	merge z1d (in=a) poland2 (in=b);
	by wojid;
run;
proc gmap   
			data=z1e /*zbiór wejœciowy*/
			map=maps.poland /*zbiór z danymi do wykreœlenia powierzchni - ³¹czony z poland2 po zmiennej id*/
							/*all*/;
	id id;
	choro mean /
		woutline=1
		nolegend
		;
run;
quit;
