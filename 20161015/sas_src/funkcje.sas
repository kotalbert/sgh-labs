data lab.daty;
	dzis = today();
	m1 = month(dzis);
	dzien = day(dzis);
	koniec_mca = intnx("month", dzis, 0, "e");
	format dzis koniec_mca yymmdd10.;
run;
