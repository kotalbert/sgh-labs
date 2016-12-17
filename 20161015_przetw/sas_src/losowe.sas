data losowe;
	nor = rannor(12345);
run;

data lab.cars_rand;
set sashelp.cars;

if ranuni(12345) <= 0.25 then output;

run;
