/*
Uwaga - zadzia³a tylko jeœli na komputerze jest zainstalowany Excel
*/
proc import datafile="&p.\sas_data\AXLES.xls"
	out=work.axles
	replace
	;	
	getnames=yes;
run;

/*
Eksport do pliku
*/
proc export data=dat.hpraca 
	outfile="&p.\out\hpraca.dlm" 
	dbms=dlm 
	replace;
	delimiter="|";
run;

proc contents data=dat.amsterdam_stock details
; 

run;