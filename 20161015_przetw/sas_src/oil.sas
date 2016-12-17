data lab.gulfoil;
set sashelp.gulfoil;
run;


data lab.gulgoil2;
set sashelp.gulfoil;
where 
	1 = 1
	& regionname = 'Central'
	& year(date)  >= 2000
	& year(date) <= 2005
;

mnth_n = month(date);
qtr_n = qtr(date);

run;
