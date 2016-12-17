/*2. Rozk³ad normalny*/
*Dla zmiennej skokowej
 f(x) = P(X=x)
 F(x) = P(X<=x);
data normal;
	do x=-4 to 4 by 0.01;
	   py = pdf('normal',x,0,1);
	   cy = cdf('normal',x,0,1);
	   output;
	end;
run;

proc sgplot data=normal;
scatter x=x y=py;
scatter x=x y=cy;
run;

data crit;
	c=quantile('normal',0.975);
	*p=probnorm(1.96);
	call symput('crit',c);
run;
*2.1. Gplot;
goptions reset=all i=join hsize=6 vsize=5;
 axis1 label=("u");
 axis2 label=(f=greek "f" f=simplex "(u)") order=(0 to 1 by 0.05);
 axis3 label=(f=greek "F" f=simplex "(u)") order=(0 to 1 by 0.05);
proc gplot data=normal;
	plot py * x   / haxis=axis1 vaxis=axis2 href= -1.96 1.96 vref=0.5;
	plot2 cy * x / vaxis=axis3;
run;

*2.2. Sgplot;
data normal2;
	set normal;
	c=quantile('normal',0.975);
	if x < -c then al=py;
	else al=.;
	if x > c then ar=py;
	else ar=.;
run;

*ods graphics / reset height=15cm width=20cm;
proc sgplot data=normal2;
	series x=x y=py / markerattrs=(symbol=circlefilled size=2 color=red) name="y" legendlabel="Funkcja gêstoœci";
	band x=x lower=0 upper=al / transparency=.5;
	band x=x lower=0 upper=ar / transparency=.5;
	*refline 1.96 / axis=x;
	keylegend "y" / noborder;
run;

*Rozk³ad t-studenta;
%let df=10;
data student;
do t=-4 to 4 by 0.01;
	ct = cdf('t', t, &df.);
	pt = pdf('t', t, &df.);
	/*Wartoœæ do wyrysowania obszarów krytycznych*/
	c=quantile('t',0.975, &df.);
	if t < -c then al=pt;
	else al=.;
	if t > c then ar=pt;
	else ar=.;
	output;
end;
run;

proc sgplot data=student;
series x=t y=ct;
run;

proc sgplot data=student;
series x=t y=pt;
band x=t lower=0 upper=al / transparency=.5;
band x=t lower=0 upper=ar / transparency=.5;

run;

*Rozk³ad normalny i rozk³ad t-studenta dla v=10 i v=500;
data nt;
	set normal;
	y_t = pdf('t',x,50);
run;
proc sgplot data=nt;
	scatter x=x y=y / markerattrs=(symbol=circlefilled size=3 color=red) name="normal" legendlabel="Normal";
	scatter x=x y=y_t / markerattrs=(symbol=circlefilled size=3 color=green) name="t" legendlabel="t-Student";
	keylegend "normal" "t" / noborder;
run;

*Rozk³ad chi-kwadrat;
data chi;
	do x=0 to 40 by 0.01;
	   y = pdf('chisq',x,10);
	   cy = cdf('chisq',x,10);
	   output;
	end;
run;
data crit;
	cl=quantile('chisq',0.025,10);
	cr=quantile('chisq',0.975,10);
	call symput('critl',cl);
	call symput('critr',cr);
run;
%put &critl &critr;
data chi2;
	set chi;
	if x < &critl then al=y;
	else al=.;
	if x > &critr then ar=y;
	else ar=.;
run;
proc sgplot data=chi2;
	scatter x=x y=y / markerattrs=(symbol=circlefilled size=2 color=red) name="y" legendlabel="Funkcja gêstoœci";
	band x=x upper=al lower=0 / transparency=.5;
	band x=x upper=ar lower=0 / transparency=.5;
	keylegend "y" / noborder;
run;

*Rozk³ad F-Snedecora;

*Test istotnoœci dla œredniej;
data t;
	do x=-4 to 4 by 0.01;
	   y = pdf('t',x,14);
	   cy = cdf('t',x,14);
	   output;
	end;
run;

proc sql noprint;
	select 
	mean(xi),std(xi),count(*) into :mean,:std,:n
	from dat.axles;
quit;
%put &mean &std &n;
data crit;
	c=quantile('t',0.975,14);
	t=(&mean-24)/&std*sqrt(&n);
	call symput('crit',c);
	call symput('t',t);
run;
*Test jednostronny: P=P(U>=u_obl);
*Test dwustronny: P=P(|U|>=|u_obl|) <=> P(U<=-|u_obl|) i P(U>=|u_obl|);
data t2;
	set t;
	*Crit;
	if x < -&crit  then al=y;
	else al=.;
	if x > &crit then ar=y;
	else ar=.;
	*Pval;
	if x < -&t then atl=y;
	else atl=.;
	if x > &t then atr=y;
	else atr=.;
run;
proc sgplot data=t2 noautolegend;
	scatter x=x y=y / markerattrs=(symbol=circlefilled size=2 color=red) name="y" legendlabel="Funkcja gêstoœci";
	band x=x upper=al lower=0 / transparency=.5;
	band x=x upper=ar lower=0 / transparency=.5;

	band x=x upper=atl lower=0 / fillattrs=(color=beige) transparency=.5;
	band x=x upper=atr lower=0 / fillattrs=(color=beige) transparency=.5;
	refline &t / axis=x;
run;
