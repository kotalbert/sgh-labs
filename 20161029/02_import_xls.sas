proc import datafile="C:\Users\pd94584p\OneDrive - Szko³a G³ówna Handlowa w Warszawie\sgh-labs\20161029\sas_data\AXLES.xls"
	out=work.axles
	replace
	;	
	getnames=yes;
run;