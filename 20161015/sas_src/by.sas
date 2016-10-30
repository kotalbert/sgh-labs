data cls_by;
set work.class_sort;
	by age;
	f = first.age;
	l = last.age;
run;

/*Z3*/

proc sort data=sashelp.company 
	out=comp_sor;
	where level3 in ("TECHN. SERVICES", "ADMIN");
	by level3;
run;

data comp2;
set comp_sor;
	by level3;
	retain mgr_cnt;

	if first.level3 then mgr_cnt = 0;
	if job1 = "MANAGER" then mgr_cnt = mgr_cnt +1;
	if last.level3 then output;
	keep level3 mgr_cnt;

run;
