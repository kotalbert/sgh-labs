data cls;
set sashelp.class;
length plec $15;

if Sex = 'M' then plec = 'Chłopiec';
else if Sex = 'F' then plec = 'Dziewczyna';
else plec = plec = 'Nieznane';

run;

data company;
set sashelp.company;
	length premia 8;
	if job1 = "MANAGER" then premia = 1000;
	else premia = 500;
	keep level5 job1 premia;
run;
