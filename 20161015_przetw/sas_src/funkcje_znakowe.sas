data lab.company;
set sashelp.company;
run;

data sascomp;
set sashelp.company;

imie = scan(level5,1);
nazw = scan(level5,2);



/*Obsługa występowania inicjałów*/
if length(nazw) < 3 then nazw = scan(level5, 3);

/*
Alternatywnie:
nazw = scan(level5, -1);
nazw = coalescec(scan(level5, 3), scan(level5, 2));
*/

inic = cat(substr(imie,1,1), ".", substr(nazw, 1,1), ".");
keep level5 imie nazw inic;

run;
