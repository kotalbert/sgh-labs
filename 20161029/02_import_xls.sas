proc import datafile="C:\Users\pd94584p\OneDrive - Szko�a G��wna Handlowa w Warszawie\sgh-labs\20161029\sas_data\AXLES.xls"
	out=work.axles
	replace
	;	
	getnames=yes;
run;