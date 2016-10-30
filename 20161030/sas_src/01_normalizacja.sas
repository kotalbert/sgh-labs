/*Standaryzacja zmiennych*/
proc standard data=dat.gosp08
	OUT=gosp_norm
	mean=0
	std=1
	;
	VAR DOCHM;

run;


/*Analiza rozk³adu*/
proc univariate data = gosp_norm
		cibasic(type=twosided alpha=0.05)
		mu0=0
		nextrval=5
	trimmed=	0.25(	TYPE=TWOSIDED 	ALPHA=0.05)
	winsorized=	0.1(	TYPE=TWOSIDED 	ALPHA=0.05)
	;
	var dochm;
	histogram;
run;