data dane;
variable='A';
do i=1 to 50;
	default=(ranuni(1)<0.2);
	output;
end;
variable='B';
do i=1 to 60;
	default=(ranuni(1)<0.3);
	output;
end;
variable='C';
do i=1 to 70;
	default=(ranuni(1)<0.6);
	output;
end;
drop i;
run;

proc freq data=dane ;
table variable*default / out=var_def;
run;

data kodowanie;
set dane;
dummy=(variable='A')*1+(variable='B')*2+(variable='C')*3;
logit=-(variable='A')*1.658-(variable='B')*0.693
+(variable='C')*0.465;

dummy1=0; dummy2=0;
if variable='B' then dummy1=1;
if variable='C' then dummy2=1;

dummy_cum1=0; dummy_cum2=0;
if variable='B' then dummy_cum1=1;
if variable='C' then do; dummy_cum2=1; dummy_cum1=1; end;

run;

proc logistic data=kodowanie desc;
model default=dummy;
run;

proc logistic data=kodowanie desc;
model default=dummy1 dummy2;
run;
proc logistic data=kodowanie desc;
class variable / param=ref ref=first;
model default=variable;
run;

proc logistic data=kodowanie desc;
model default=dummy_cum1 dummy_cum2;
run;
proc logistic data=kodowanie desc;
class variable / param=ordinal ref=first;
model default=variable;
run;


proc logistic data=kodowanie desc;
model default=logit;
run;
