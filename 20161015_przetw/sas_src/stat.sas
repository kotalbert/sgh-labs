data cars_stat;
set sashelp.cars;

length kot1 kot2 $25;

mpg_total = mean(mpg_city, mpg_highway);
zakres = range(invoice, msrp);
kot1 = "kot1";
kot2 = "kot2";
/* catt: trimuje argumenty*/
cat = catt(kot1, kot2);
keep mpg_total zakres cat;
run;
