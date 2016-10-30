data lab.class;
set sashelp.class;
put _all_;
weight2 = 100;
put _all_;

run;

data lab.cars;
set sashelp.cars;
run;

data lab.samochody;
set sashelp.cars (
	keep=make model type origin msrp enginesize
	rename=(
		make=make_pl
		model=model_pl
		type=type_pl
		origin=origin_pl
		msrp=msrp_pl
		enginesize=enginesize_pl
	)
	where=(origin_pl = 'Asia' | origin_pl = 'Europe')
	);

run;
