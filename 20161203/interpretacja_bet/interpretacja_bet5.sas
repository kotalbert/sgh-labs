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
variable='D';
do i=1 to 50;
	default=(ranuni(1)<0.1);
	output;
end;
variable='E';
do i=1 to 110;
	default=(ranuni(1)<0.05);
	output;
end;
drop i;
run;

proc freq data=dane;
table variable*default / out=var_def;
run;

data kodowanie;
set dane;
dummy=(variable='A')*1+(variable='B')*2+(variable='C')*3
+(variable='D')*4+(variable='E')*5;
run;

proc logistic data=kodowanie desc;
model default=dummy;
run;

proc logistic data=kodowanie desc;
class variable / param=ref ref=first;
model default=variable;
run;

proc logistic data=kodowanie desc;
class variable / param=ordinal ref=first;
model default=variable / clodds=both;
ODDSRATIO variable / diff=all;
run;


