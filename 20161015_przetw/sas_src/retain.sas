
/*Jawne wywołanie retain*/
data cls;
set sashelp.class;
	retain cnt 0;
	cnt = cnt + 1;
run;

/*Niejawne wywołanie retain*/
data cls2;
set sashelp.class;
	/*Wartość domyślna 0*/
	cnt + 1;
run;

/*Suma krocząca*/
data cls3;
set sashelp.class;
	wght_sum + weight;
run;

