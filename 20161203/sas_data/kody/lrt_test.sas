ods listing close;
ods output fitstatistics(match_all persist=proc)=fit;
proc logistic data=sashelp.class;
model sex=age weight; 
run;
proc logistic data=sashelp.class;
model sex=age weight height; 
run;
ods output close;
ods listing;


data likelihood (keep=like1 like2 test1 pvalue1);
  merge fit (rename=(interceptandcovariates=like1))
        fit1(rename=(interceptandcovariates=like2))
  ;
  if criterion='-2 Log L';
  test1=like1-like2;
  pvalue1=1-probchi(test1,1);
  format pvalue: PVALUE6.4;
run;
