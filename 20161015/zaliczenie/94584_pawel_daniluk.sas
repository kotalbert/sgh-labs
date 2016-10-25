/*
Przetwarzanie danych SAS
Pawe� Daniluk
2016-10-24
*/

/*Zadanie 1*/
libname out 'H:\UsersData\pd14184\rozwojowo\sgh-labs\20161015\zaliczenie';

/*Zadanie 2*/
data 
    /*Na wyj�ciu tworzone s� dwa zbiory, wg. zadanych kreteri�w*/
    out.samochochodydo2l (where=(EngineSize<=2))
    out.samochodyponad2l (where=(EngineSize>2))
    ;
set sashelp.cars (keep=
    Make Model Origin DriveTrain Invoice MSRP EngineSize 
    Origin Horsepower MPG_City MPG_Highway
    );
where Origin in ('Europe', 'Asia') & DriveTrain = 'Rear';

/*Deklaraca zm. binarnych*/
lenght asia usa europe 3.;

if EngineSize<=2 then
    akcyza = .031 * invoice;
else if EngineSize>2 then 
    akcyza = .186 * invoice;
/*Obs�uga brak�w danych*/
else
    akcyza = .A;

/*Zak�adam stawk� vat 23%*/
cena_msrp_vat =  .23 * msrp;

if origin  = 'Asia' then asia = 1;
else asia = 0;

if origin = 'Europe' then europe = 1;
else europe = 0;

/*instrukcja where wyklucza ze zbioru obserwacje, gdzie origin = 'USA'*/
if origin = 'USA' then usa = 1;
else usa = 0;

run;

/*Zadanie 3*/
proc sort data=out.samochodyponad2l out=out.samochody_sorted;
where MSRP > 4e4;
by Origin descending make mpg_city;
run;

/*Zadanie 4*/
/*
Posortowa�, ze wzgl�du na przetwarzanie w grupach wg. "make" 
oraz malej�co po invoice, w celu wyr�nienie najdro�szych
*/
proc sort data=sashelp.cars out=out.samochody;
by make descending MSRP;
run;

data out.najdrozsze;
set out.samochody;
by make;
/*
Poniewa� zbi�r jest posortowany, najdro�szy b�dzie pierwszy samoch�d
danej marki w grupie wg. "make".
Jednocze�nie wykonuje przeliczenie na pln wg. zmiennej MSRP.
*/
if first.make = 1 then do 
    MSRP_pln = 3.69 * MSRP;
    output;
end;

format MSRP_pln NLMNLPLN.;

run;

/*Zadanie 5*/
proc format;
    value cena
        0 - < 25e3 = 'Tani'
        25e3 - < 50e3 = '�rednio drogi'
        50e3 - high = 'Bardzo drogi'
        low - < 0 = 'B��dna warto��'
        . = 'Brak warto�ci'
        ;
run;

/*Zadanie 6*/
data out.samochody_cena;
set sashelp.cars;

cena = invoice;
format cena cena.;

run;

/*Zadanie 7*/
proc sort data=sashelp.stocks out=work.stocks_sort;
by date;
run;

proc transpose data=work.stocks_sort 
out=out.stocks_trans (drop=_NAME_);
by date;
var close;
id stock;
run;

/*Zadanie 9*/
libname out clear;
