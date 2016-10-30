data stocks;
set sashelp.stocks;
	array tab{*} open -- close;
	array x{*} x1-x100;
	array y{100};
	array c{10} $;

	array xy{10,10} x1-x100;
	c[1] = "Kolumna";
	xy[1,10] = 12345;

run;

data stocks2;
set sashelp.stocks;

	array tab{*} open -- close;
	do i=1 to 4;
		tab[i] = tab[i]*1.23;
	end;

run;

data stocks3;
set sashelp.stocks;
	array x{10};
	i = 1;
	do while (i<=10);
	x[i] = i;
	i+1;
	end;

	array y{10};
	j = 1;
	do until (j>10);
		y[j] = j;
		j+1;
	end;
run;
