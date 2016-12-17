/*
Deklaracja bibiotek, eksport danych do plików tekstowych
*/

%macro dml_exp(fname);
	%let wd=../dane;
	libname dane "&wd.";

	proc export data=dane.&fname
	outfile="&wd./&fname..dsv"
	dbms=dlm
	replace;
	DELIMITER="|";
	run;
%mend;

%dml_exp(nauka);
%dml_exp(test);
