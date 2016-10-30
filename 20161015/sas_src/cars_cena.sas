data lab.cars_lt30k;
set sashelp.cars;
where round(MSRP, 1000) < 30000;

run;
