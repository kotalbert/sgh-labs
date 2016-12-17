proc sort data=sashelp.class out=class_sort;
	by  Age descending Height; run;

proc sort data=sashelp.prdsale out=prdsales_sort;
	by Country descending Actual;
run;
