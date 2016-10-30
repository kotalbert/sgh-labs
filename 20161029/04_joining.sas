proc contents data=dat.bezrobocie 
	out=out.bezrobocie_metadane 
	noprint;
run;

/*
£¹czenie wyliczonych statystyk z diagnoza07 ze zbiorem bezrobocie
*/
proc sql;

create table diag_bezr as 
select a.*
	, b.bezr
from work.diag_woj a inner join dat.bezrobocie b
	on a.woj = b.wojid
	;
quit;