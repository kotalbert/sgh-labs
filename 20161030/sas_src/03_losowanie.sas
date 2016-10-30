data normal;
	do x=1 to 1e4 by 1;
	wzrost=int(rannorm(12345)*22+177);
	output;
	end;
run;

proc sgplot data=normal;
	histogram wzrost;
	xaxis min=100 max= 250;
run;

proc means data=normal;
	var wzrost;
run;
/*Próba prosta*/
proc surveyselect 
data=normal 
out=samples reps=100 n=10 method=srs noprint;
run;
/*Wyznaczenie œredniej*/
proc means data=samples n mean maxdec=0 nway;
 var wzrost;
 class replicate;
 output out=mean mean=mean1;
run;

/*Losowanie proste bez zwracania*/
proc surveyselect data=dat.diagnoza07 
	out=diag_sample
	method=SRS
	n=100
	seed=12345;
run;

/*Losowanie warstwowe*/
proc surveyselect data=dat.diagnoza07
	out=diag_strata
	method=srs
	seed=12345
	n=100;
	strata woj / alloc=proportional;
run;

proc gchart data=dat.diagnoza07;
	vbar woj / type=freq outside=pct discrete;
run;
proc gchart data=diag_strata;
	vbar woj / type=freq outside=pct discrete;
run;
