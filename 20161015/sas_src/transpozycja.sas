proc sort data=sashelp.cars out=cars_sort nodupkey;
by Model; 

proc transpose data=cars_sort out=cars_t;
id  Model; 
var Make Origin MSRP Horsepower;
run;

proc sort data=sashelp.stocks out=stocks_sort;
by Date;
run;

proc transpose data=stocks_sort out=stocks_t (drop=_NAME_);
by Date;
var close;
id Stock;
run;

proc sort data=sashelp.class out=cls_sort;
by Name;
run;

proc transpose data=cls_sort out=cls_t;
id Name;
var Age Height Weight;
run;
