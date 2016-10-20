data p1;
input id wizyta data date9. wynik;
format data date9.;
cards;
1 1 11oct2015 5
1 2 12oct2015 6
1 3 13oct2015 4
1 4 14oct2015 3
1 5 15oct2015 1
1 99 17oct2015 1
;
run;
data p2;
input id wizyta data date9. wynik;
format data date9.;
cards;
1 1 11oct2015 4
1 2 12oct2015 5
1 3 13oct2015 3
1 . 14oct2015 2
1 5 15oct2015 3
;
run;