proc format lib=work;
	value wymczpfmt
	1="Pe�ny etat"
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
*Wykres s�upkowy;
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
*Utw�rz zmienn� ID zgodn� z opisywan� jednostk� administracyjn� - wojew�dzwto;
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

*��czenie zbioru wej�ciowego ze zbiorem z jednostkami administracyjnymi;
data z1e;
	merge z1d (in=a) poland2 (in=b);
	by wojid;
run;
proc gmap   
			data=z1e /*zbi�r wej�ciowy*/
			map=maps.poland /*zbi�r z danymi do wykre�lenia powierzchni - ��czony z poland2 po zmiennej id*/
							/*all*/;
	id id;
	choro mean /
		woutline=1
		nolegend
		;
run;
quit;
