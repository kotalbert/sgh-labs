/*(c) Karol Przanowski*/
/*kprzan@sgh.waw.pl*/

/*przygotowanie danych*/
/*pokazaæ kod abt_behavioral_columns.sas*/

libname wej 'c:\karol\podyplomowe\regresja_logistyczna\dla_studentow\dane\';
libname wyj 'c:\karol\podyplomowe\regresja_logistyczna\dla_studentow\kody\dane\' compress=yes;
libname freki 'c:\karol\podyplomowe\regresja_logistyczna\dla_studentow\kody\freq\' compress=yes;
libname testy 'c:\karol\podyplomowe\regresja_logistyczna\dla_studentow\kody\testy\' compress=yes;

%let tar=default12;
%let zb=wyj.train_im;


%let prop=0.02;
data wyj.train wyj.valid;
set wej.abt_beh;
array tab(*) _numeric_;
do i=1 to dim(tab);
	if missing(tab(i)) then tab(i)=.;
end;
if ranuni(1)<0.6 then output wyj.train; else output wyj.valid;
where &tar in (0,1) and ranuni(1)<&prop;
drop i;
run;
proc stdize data=wyj.train out=wyj.train_im method=median reponly;
run;
proc stdize data=wyj.valid out=wyj.valid_im method=median reponly;
run;

/*na pocz¹tku o predykcji i o opisie*/
/*jak wygl¹da reglesja liniowa i jak logistyczna dla dwóch zmiennych*/

/*analiza jakoœci danych*/


%let zm_num_jakosciowe=
app_char_nom1 app_char_nom2 app_char_nom3 app_char_nom4
;

%let zm_num_ilosciowe=
app_char_int1 app_char_int2 app_char_int3 app_char_int4 
act_days act_paid_installments act_utl act_dueutl 
act_due act_age act_cc act_dueinc act_loaninc app_income 
app_loan_amount app_n_installments act_seniority 
agr3_Mean_Due agr3_Max_Due agr3_Min_Due agr3_Mean_Days 
agr3_Max_Days agr3_Min_Days agr6_Mean_Due agr6_Max_Due 
agr6_Min_Due agr6_Mean_Days agr6_Max_Days agr6_Min_Days 
agr9_Mean_Due agr9_Max_Due agr9_Min_Due agr9_Mean_Days 
agr9_Max_Days agr9_Min_Days agr12_Mean_Due agr12_Max_Due 
agr12_Min_Due agr12_Mean_Days agr12_Max_Days agr12_Min_Days 
act_n_arrears act_n_arrears_days act_n_good_days 
;
%let wybrane_ilosciowe=act_n_arrears agr6_Max_Due act_utl
act_cc act_paid_installments app_income act_age;
%let wybrane_jakosciowe=
app_char_nom1 app_char_nom2 app_char_nom3 app_char_nom4
;

/*przyk³ady z regresji liniowej*/

/*przyklady ogolne dlaczego nie regresja liniowa*/
goptions reset=all;
proc reg data=&zb outest=b1;
   model &tar=&wybrane_ilosciowe;
   plot r.*obs.;
   plot r.*p.;
   plot &tar*p.;
   output out=r p=p r=r;
run;
quit;
data test;
set &zb;
nowa=&tar*100;
keep &tar &wybrane_ilosciowe nowa;
run;
proc reg data=test outest=b100;
   model &tar=&wybrane_ilosciowe;
   output out=r p=p r=r;
run;
quit;
proc univariate data=r;
var r;
histogram / normal;
probplot / normal;
run;

/*uzasadnienie ze wzglêdu na rozk³ady*/
%let wybrane=app_income act_age act_utl;
proc rank data=wyj.train_im out=beh groups=9;
var &wybrane;
run;
proc means data=beh noprint nway;
class &wybrane;
var default12;
output out=stat mean()=;
run;
data stat;
set stat;
logit=log((default12+(sqrt(_freq_)/2))/(_freq_-default12+(sqrt(_freq_)/2)));
run;
proc gchart data=stat;
vbar3d default12 / levels=15 type=percent;
run;
quit;
proc gchart data=stat;
vbar3d logit / levels=15 type=percent;
run;
quit;

data ran;
do i=1 to 10000;
	n=rannor(1);
	p=1/(1+exp(-n+4));
	logit=log(p/(1-p));
	output;
end;
run;
proc gchart data=ran;
vbar3d p / levels=15 type=percent;
run;
quit;
proc gchart data=ran;
vbar3d logit / levels=15 type=percent;
run;
quit;



/*logit*/
proc logistic data=&zb outest=log desc;
   model &tar=&wybrane_ilosciowe;
   output out=l p=p resdev=r reschi=chi;
run;
proc univariate data=l;
var r chi;
histogram / normal;
probplot / normal;
run;

/*Probit - Logit*/
data w;
do x=0 to 1 by 0.002;
p=probit(x);
l=log(x/(1-x));
output;
end;
run;
title c=green "Logit" c=red "Probit";
title2 ;
proc gplot data=w;
symbol1 v=none c=red i=join;
symbol2 v=none c=green i=join;
plot x*p=1 x*l=2 / overlay;
run;
quit;

/*temat 1*/
/*omówienie outputu*/
/****************************************************/
/****************************************************/
proc logistic data=&zb desc;
class app_char_nom2 (param=ref ref='0');
model &tar = &wybrane_ilosciowe app_char_nom2 / itprint stb;
units act_age=10 app_income=100 act_cc=0.1;
run;
/*inne kodowanie lub contrast mo¿e nam pokazaæ wszystkie oddsy*/
/*omówiæ program interpretacja_bet*/
/*pokazaæ przyk³ad contrastu*/
/*opcje metod optymalizacji itprint inest kryterium zbieznosci*/
/*quasi complete separation*/


/*temat 2*/
/*metody skorowania*/
/****************************************************/
/****************************************************/
data test;
set &zb end=e;
output;
if e then do i=1 to 20; 
	&tar=.;
	output; 
end;
drop i;
run;
proc logistic data=test desc 
outest=betas1;
model &tar = &wybrane_ilosciowe;
output out=score1 p=p upper=up lower=low;
run;
proc score data=score1(drop=&tar)
out=score2 score=betas1
type=parms;
var &wybrane_ilosciowe;
run;
data score2;
set score2;
p2=1/(1+exp(-&tar));
run;

/*nowsza metoda*/
proc logistic data=test desc 
outmodel=model1;
model &tar = &wybrane_ilosciowe;
run;
proc logistic inmodel=model1;
   score data=test out=test_score;
run;

/*temat 4*/
/*oversampling, przepróbkowanie*/
/****************************************************/
/****************************************************/
/*omówiæ wzory na poprawkê prawdopodobieñstwa*/
%let pi1=0.2;
proc means data=&zb noprint;
var &tar;
output out=sum mean=rho1;
run;
data sum;
set sum;
call symput('rho1',rho1);
run;
%put &rho1;
data test;
set &zb;
off=log(((1-&pi1)*&rho1)/(&pi1*(1-&rho1)));
run;
proc logistic data=test desc 
outest=betas2;
model &tar = &wybrane_ilosciowe
/ offset=off;
run;
proc score data=&zb(drop=&tar) out=scored 
score=betas2 type=parms;
var &wybrane_ilosciowe;
run;
data scored;
set scored;
p=1/(1+exp(-&tar));
run;
proc means noprint nway data=scored;
var p;
output out=stat1 mean()=;
run;
/*mo¿na policzyæ œredni¹ powinna byæ zbli¿ona do zadanej pi1*/
/*drugi sposob po policzeniu modelu wstawienie offset*/

proc logistic data=&zb desc outest=betas3;
model &tar = &wybrane_ilosciowe;
run;

proc score data=&zb(drop=&tar) out=scored 
score=betas3 type=parms;
var &wybrane_ilosciowe;
run;

data scored;
set scored;
off=log(((1-&pi1)*&rho1)/(&pi1*(1-&rho1)));
p=1/(1+exp(-(&tar-off)));
run;
proc means noprint nway data=scored;
var p;
output out=stat2 mean()=;
run;

/*przepróbkowanie przez wagi*/
/****************************************************/
/****************************************************/
/*inny sposob perzez wagi*/
data test;
set &zb;
sampwt=((1-&pi1)/(1-&rho1))*(&tar=0) 
+(&pi1/&rho1)*(&tar=1);
run;
proc logistic data=test desc 
outest=betas4;
weight sampwt;
model &tar = &wybrane_ilosciowe;
run;
/*dalej skoruje siê tak samo*/
/*jeœli mamy bardzo nie liniowe zale¿noœci ta metoda da lepsze wyniki*/

/*temat 5*/
/*uzupe³nianie braków danych - opowiedzieæ teoretycznie i pokazaæ przyk³ady kodów*/
/*proc standard replace*/
/*proc stdize reponly*/
/*missing indicator*/
/****************************************************/
/****************************************************/

/*temat 6*/
/*³¹czenie, sklejanie wartoœci*/
/****************************************************/
/****************************************************/
/*metoda oparta na drzewie decyzyjnym*/
%let do_sk=app_char_nom1;
proc logistic data=&zb desc;
class &do_sk;
model &tar=&do_sk;
run;


proc means data=&zb noprint nway;
class &do_sk; 
var &tar;
output out=levels mean=prop;
format prop nlpct12.2;
run;

ods trace on/listing;
proc cluster data=levels 
method=ward outtree=fortree;
freq _freq_;
var prop;
id &do_sk;
run;
ods trace off;

ods listing close;
ods output clusterhistory=cluster;
proc cluster data=levels method=ward;
freq _freq_;
var prop;
id &do_sk;
run;
ods output close;
ods listing;

proc freq data=&zb noprint;
tables &do_sk*&tar / chisq;
output out=chi(keep=_pchi_) chisq;
run;

data cutoff;
if _n_ = 1 then set chi;
set cluster;
chisquare=_pchi_*rsquared;
degfree=numberofclusters-1;
logpvalue=logsdf('CHISQ',chisquare,
degfree);
run;
/*proc gplot data=cutoff;*/
/*plot numberofclusters*chisquare;*/
/*plot numberofclusters*logpvalue; */
/*run;*/
/*quit;*/
proc gplot data=cutoff;
symbol1 i=none v=plus;
plot logpvalue*numberofclusters;
run;
quit;
proc means data=cutoff noprint;
var logpvalue;
output out=small 
minid(logpvalue(numberofclusters))=ncl;
run;
data small;
set small;
call symput('ncl',put(ncl,best12.-L));
run;
%put ***&ncl***;

%macro define(ref,ncl);
%do nr=1 %to &ncl;
proc sql noprint;
/*select quote(trim(&do_sk)) into*/
select put(&do_sk,best12.-L) into
:cluster&nr separated by ','
from clus
where cluster=&nr;
quit;
/*%put &&cluster&nr;*/
%end;
data imputed;
set &zb;
%let nrc=1;
%do nr=1 %to &ncl;
%if &nr ne &ref %then %do;
  &do_sk._&nrc=(&do_sk in (&&cluster&nr));
  %let nrc=%eval(&nrc+1);
  %end;
%end;
run;
%mend define;

%let ncl=2;
/*%let ncl=26;*/


proc tree data=fortree 
nclusters=&ncl out=clus h=rsq;
id &do_sk;
run;
proc sort data=clus;
by clusname;
run;
proc print data=clus;
by clusname;
id clusname;
run;
option mprint;
%define(1,&ncl);
/*%define(&ncl);*/
option nomprint;
%let ncl1=%eval(&ncl-1);
%put ***&ncl1***;
proc logistic desc data=imputed;
model &tar=&do_sk._1-&do_sk._&ncl1;
run;
data widok / view=widok;
set imputed(keep= &do_sk._1-&do_sk._&ncl1 &tar);
array z(&ncl1) &do_sk._1-&do_sk._&ncl1;
cls=0;
do i=1 to &ncl1;
cls=cls+i*z(i);
end;
keep cls &tar;
run;
proc freq data=widok;
tables cls*&tar / chisq;
output out=chi2(keep=_pchi_) chisq;
run;

/*omówiæ inne metody sklejania grup, artyku³ Score-Plus*/
/*kodowanie nested*/

/*temat 7*/
/*wybór zmiennych*/
/*zrobiæ tak¿e przyk³ad jednowymiarowa analiza*/
/*klasteryzacja zmiennych*/
/****************************************************/
/****************************************************/
ods trace on/listing;
proc varclus data=imputed 
proportion=0.8 outtree=fortree 
short;
var &do_sk._1-&do_sk._&ncl1 &zm_num_jakosciowe &zm_num_ilosciowe;
run;
ods trace off;  

ods listing close;
ods output clusterquality=summary
           rsquare(match_all)=clusters2;

proc varclus data=imputed 
maxeigen=.7 outtree=fortree 
short hi;
var &do_sk._1-&do_sk._&ncl1 &zm_num_jakosciowe &zm_num_ilosciowe;
run;
ods output close;
ods listing;

data _null_;
set summary;
call symput('ncl',
trim(left(numberofclusters)));
run;
%put **&ncl**;
proc print data=clusters&ncl;
run;
proc tree data=fortree;
   height _MAXEIG_;
run;
/*wybieramy po reprezentancie który ma minimalny r2ratio*/

/*mo¿na tak¿e wybieraæ po korelacji*/
proc corr data=imputed 
outs=spearman outh=hoeffding
outp=pearson rank;
var &do_sk._1-&do_sk._&ncl1 &zm_num_jakosciowe &zm_num_ilosciowe;
with &tar;
run;
proc transpose data=spearman(where=(_type_='CORR')) out=ts;
var &do_sk._1-&do_sk._&ncl1 &zm_num_jakosciowe &zm_num_ilosciowe;
run;
data ts;
set ts;
abs_corr=abs(&tar);
run;
proc sort data=ts;
by descending abs_corr;
run;

/*temat 8*/
/*metody wyboru modelu krokowe i inne*/
/****************************************************/
/****************************************************/
proc logistic data=imputed desc;
model &tar=&do_sk._1-&do_sk._&ncl1 &zm_num_jakosciowe &zm_num_ilosciowe / 
selection=backward fast 
slstay=.001;
run;
proc logistic data=imputed desc;
model &tar=&do_sk._1-&do_sk._&ncl1 &zm_num_jakosciowe &zm_num_ilosciowe / 
selection=stepwise  
slstay=.001;
run;
proc logistic data=imputed desc;
model &tar=&do_sk._1-&do_sk._&ncl1 &zm_num_jakosciowe &zm_num_ilosciowe / 
selection=score best=5 start=5 stop=10
slstay=.001;
run;


ods listing close;
ods output bestsubsets=score;
proc logistic data=imputed desc;
model &tar=&do_sk._1-&do_sk._&ncl1 &zm_num_jakosciowe &zm_num_ilosciowe / 
selection=score best=5 start=5 stop=10
slstay=.001;
run;
ods output close;
ods listing;

data _null_;
set imputed(obs=1) nobs=nnn;
call symput('obs',put(nnn,best12.-L));
run;
%put &obs;
data subset;
set score;
sbc=-scorechisq+log(&obs)*
(numberofvariables+1);
aic=-scorechisq+2*
(numberofvariables+1); 
run;
%let zmienne=
app_char_nom2 app_char_nom4 app_char_int2 act_utl 
act_age act_loaninc app_income agr3_Max_Due 
agr6_Mean_Due act_n_good_days;


/*temat 9*/
/*walidowanie modeli*/
/*opowiedzieæ o metodach validacji train i valid*/
/*krzywa ROC i CAP wp14*/
/*przyk³adowa sk³adnia*/
proc logistic data=wyj.train_im desc outest=betas noprint;
model &tar=&zmienne;
run;
proc logistic data=wyj.valid_im desc inest=betas;
model &tar=&zmienne / maxiter=0 outroc=roc;
run;

/*do uruchomienia*/
proc logistic data=&zb desc ;
model &tar= &zmienne / outroc=roc;
run;
data roc;
set roc;
cutoff=_PROB_*&pi1*(1-&rho1)/(_PROB_*&pi1*(1-&rho1)+
      (1-_PROB_)*(1-&pi1)*&rho1);
specif=1-_1MSPEC_;
tp=&pi1*_SENSIT_;
fn=&pi1*(1-_SENSIT_);
tn=(1-&pi1)*specif;
fp=(1-&pi1)*_1MSPEC_;
depth=tp+fp;
pospv=tp/depth;
negpv=tn/(1-depth);
acc=tp+tn;
lift=pospv/&pi1;
keep cutoff tn fp fn tp _SENSIT_ _1MSPEC_ specif depth
    pospv negpv acc lift;
run;
proc gplot data=roc;
symbol1 c=red v=none i=join;
title "ROC Curve";
plot _sensit_*_1mspec_;
run;
quit;
proc gplot data=roc;
symbol1 c=red v=none i=join;
symbol2 c=green v=none i=join;
title "GAINS Charts";
plot pospv*depth /  legend=legend1;
plot lift*depth /  legend=legend1;
run;
quit;

/*inna metoda*/
proc logistic data=&zb desc ;
model &tar= &zmienne / 
pprob= .1 to .9 by .1 ctable
pevent=.10 .05 .01
outroc=roc;
run;

/*validacja innymi statystykami np. KS*/
/****************************************************/
/****************************************************/
proc logistic data=&zb desc ;
model &tar= &zmienne;
output out=p p=p;
run;
title 'Target distribution';
proc univariate data=p;
class &tar;
var p;
histogram;
run;
proc npar1way edf wilcoxon data=p;
class &tar;
var p;
run;

/*temat 10*/
/*testowanie, sprawdzanie za³o¿eñ*/

/*1*/
/*Sprawdzanie za³o¿eñ dopasowania*/
/*dobroæ dopasowania - jakoœæ dopasowania*/
proc logistic data=&zb desc ;
model &tar= &zmienne /
aggregate scale=none lackfit rsq;;
title 'Model podstawowy';
run;

/*2*/
/*sprawdzanie liniowej zale¿noœci pomiedzy targetem a zmiennymi niezale¿nymi*/
/*kod sprawdzenie liniowej zale¿noœci*/

/*3*/
/*wartoœci nietypowe - odstaj¹ce, wp³ywaj¹ce*/
/*kod wartosci nietypowe*/

/*4*/
/*wspó³liniowoœæ*/
/*kod wspolliniowosc*/
/****************************************************/
/****************************************************/
/*5*/
/*empiryczne logity*/
/*inna metoda sprawdzania liniowej zale¿noœci i dopasowania oraz wp³ywu zmiennej*/

%macro elogit(var);
proc rank data=&zb groups=10 out=out;
var &var;
ranks bin;
run;
proc means data=out noprint nway;
class bin;
var &tar &var;
output out=bins sum(&tar)=&tar mean(&var)=&var;
/*output out=bins sum(&tar)=&tar p50(&var)=&var;*/
run;
data bins;
set bins;
elogit=log((&tar+(sqrt(_freq_)/2))/
(_freq_-&tar+(sqrt(_freq_)/2)));
run;
title 'Elogit';
proc gplot data=bins;
plot elogit*&var;
run;
quit;
%mend;

goptions reset=all;
%elogit(act_age);
%elogit(act_n_arrears);
%elogit(agr6_Max_Due);
%elogit(act_utl);
%elogit(act_n_good_days);
%elogit(app_char_nom4);
%elogit(app_char_int2);
%elogit(app_income);
%elogit(act_loaninc);
%elogit(agr6_Mean_Due);
%elogit(app_char_nom2);


/*pojawia siê mo¿liwoœæ oceny które zmienne wzi¹æ do modelu ze swoimi potêgami*/
/*mo¿na te¿ mówiæ o cz¹stkowym empirycznym logicie!!! po wyrugowaniu wp³ywu innych zmiennych*/


/*temat 11*/
/*Interakcje, cz³ony wielomianowe, test lrt do oceny na ile ju¿ blisko*/
/****************************************************/
/****************************************************/

%let zmienne=
app_char_nom2 app_char_nom4 app_char_int2 act_utl 
act_age act_loaninc app_income agr3_Max_Due 
agr6_Mean_Due act_n_good_days;

%let zmienne_bar=
app_char_nom2 | app_char_nom4 | app_char_int2 | act_utl 
act_age | act_loaninc | app_income | agr3_Max_Due 
agr6_Mean_Due | act_n_good_days;

ods trace on / listing;
proc logistic data=&zb desc ;
model &tar= &zmienne;
title 'Model podstawowy';
run;
ods trace off;

ods listing close;
ods output fitstatistics(match_all persist=proc)=fit
/*parameterestimates=par*/
;
proc logistic data=&zb desc ;
model &tar= &zmienne_bar @2;
title 'Model z interakcjami';
run;
proc logistic data=&zb desc ;
model &tar= &zmienne app_income*app_income app_char_nom2*app_char_nom2;
title 'Model wielomianowy';
run;
proc logistic data=&zb desc ;
model &tar= &zmienne;
title 'Model podstawowy';
run;
ods output close;
ods listing;


data likelihood (keep=like1 like2 like3 test1 pvalue1 test2 pvalue2);
  merge fit (rename=(interceptandcovariates=like1))
        fit1(rename=(interceptandcovariates=like2))
        fit2(rename=(interceptandcovariates=like3));
  if criterion='-2 Log L';
  test1=like3-like1;
  pvalue1=1-probchi(test1,1);
  test2=like3-like2;
  pvalue2=1-probchi(test2,1);
  format pvalue: PVALUE6.4;
run;

proc print data=likelihood split='*';
var test1 pvalue1 test2 pvalue2;
label test1= 'likelihood ratio*test statistic*comparing*model1 and model3'
      pvalue1= 'p-value'
      test2= 'likelihood ratio*test statistic*comparing*model2 and model3'
      pvalue2= 'p-value';
run;

/*opcje include znaki | i @*/


/*temat 12*/
/*nie binarne regresje*/
/*porz¹dkowa*/
/*kod regresja porz¹dkowa*/

/*nominalna - wielomianowa*/
/*kod regresja nominalna*/
/*ewentualnie mo¿na tak¿e u¿yæ proc catmod*/
