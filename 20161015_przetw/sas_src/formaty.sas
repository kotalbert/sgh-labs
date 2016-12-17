data fmts;
	d = today();
	format d yymmdd10.;
run;

proc format;
	value silniki
	0 - 4 = "standardowy"
	4 - 8 	= "duży"
	8 - high = "b. duży"
	other = "niestandardowy"
	. = "brak danych"
	; 
run;

/*Obejrzenie wartości formatu*/
proc format fmtlib;
run;

data cars_fmt;
set sashelp.cars;
	silnik = cylinders;
	format silnik silniki.;
	keep silnik Cylinders;
run;

proc format;
	value $ plec
	'M' = 'Mężczyzna'
	'F' = 'Kobieta'
	;
run;

data cls_pln;
set sashelp.class;
format Sex $plec.;
run;

/*Format z wykorzystaniem formatu*/

proc format;
	value cmx
	low-high = [commax10.]
	. = "Brak danych"
	;
run;
