/*sprawdzenie liniowej zale¿noœci dla zmiennej ci¹g³ej iloœciowej*/
%let zm=app_income;


/*%let ilp=10;*/
%let ilp=6;

proc rank data=&zb groups=&ilp out=rangi(keep=&tar &zm rangi);
var &zm;
ranks rangi;
run;
data rangi;
array r(&ilp);
set rangi;
do i=1 to &ilp;
r(i)=(rangi+1=i);
end; 
run;
ods listing close;
ods output parameterestimates=parms;
proc logistic data=rangi desc;
model &tar=r2-r&ilp;
/*tu mo¿e staæ jeszcze wiele innych zmiennych*/
run;
ods output close;
ods listing;

goptions reset=all;
symbol1 v=star i=sm80s;
proc gplot data=parms;
plot estimate*variable;
where variable like 'r%';
run;
quit;

/*mo¿na te¿ sprawdzaæ zmienne nominalne i wtedy podj¹æ decyzjê o kodowaniu na sposób 1,2,3 itp a nie zmienne dummy*/
