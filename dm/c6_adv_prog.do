


/*******************/
/* simple programs */
/*******************/  


//a good idea for ado: have it to load from goog drive; the var is unique string to import

cap program drop hello
program define hello
di "hello world"
end

hello

cap program drop helloStranger
program define helloStranger
di "hello `1'"  //1 referes to fist argument
end

helloStranger adam

//you can use them to document your work, e.g.
cap program drop info
program define info
di "hi adam, it's stata -- you are using:"
di "`c(filename)'"
di "we have:"
di "`c(k)' vars"
di "`c(N)'  obs"
di " have a nice day!"
end

info

sysuse auto

info

//bonus--how can add date and time to above? just google it!
//then note can put it into graphs, file names etc


//--- confirming, very useful--let's talk about it before doing more programs

cap confirm file `"c:\data\mydata.dta"'
di _rc

cap confirm file `"c:\data\mydatasdasa.dta"'
di _rc   

//see for error descriptions http://www.stata.com/manuals13/perror.pdf

confirm numeric variable price trunk rep78


capture noisily regress y x
    /* will either display an error message and store the return code in _rc or */
    /* display the output and store a return code of zero in _rc. */

  
    /* You are writing a command that performs some action on each of the */
    /* variables in the local macro varlist.  The action should be different for */
    /* string and numeric variables.  The confirm command can be used here in */
    /* combination with the capture command to switch between the different */
    /* actions: */

sysuse auto, clear

        foreach v of varlist *{
                capture confirm string variable `v'
                if _rc==0 {
                       di "action for string variables"
                }
                else {
                       di "action for numeric variables"
                }
        }

 
sysuse auto, clear

foreach i of varlist _all {
 capture confirm  numeric variable `i'
  if _rc==0 {
    histogram `i', name("`i'")
  }
}

//ds is useful too

sysuse auto, clear
graph drop _all  

ds , has(type int) 
return list

foreach i of varlist `r(varlist)' {

  histogram `i', name("`i'")
}


//see if a var exists
capture confirm variable weight
if _rc==0 {
                       di in red "weight exists"
               }
               else {
                       di in red "weight does not exist"
               }


**** ok, ready for simple programs

capture program drop mymean
program define mymean
       qui sum `1' \\ `1' is a shrothand for fist argument :)
         local mm: display %5.4f r(mean)
         di "dear user, the mean is `mm'"
end

mymean mpg


//SKIP: egen is ugly here and macro shift little weird/non-intuitive
/* capture program drop mymean  */
/* program define mymean */
/*        egen mean_`1'=mean(`1') */
/*        tab mean_`1' */
/* end */

/* mymean mpg          */
         
/* capture program drop mymean */
/* program define mymean */
/*          cap drop mean_* */
/*          while "`1'"~="" { */
/*               egen mean_`1'=mean(`1') */
/*               tab mean_`1' */
/*               macro shift  //shift to next one */
/*        } */
/* end */

/* mymean mpg price */


//remember this? --can easily make it into a program

copy http://gss.norc.org/documents/stata/1972_stata.zip ./gss72.zip,replace
unzipfile gss72

use  GSS1972.DTA, clear


qui count
loc total = `r(N)'
di `total'

lookfor family
foreach v in `r(varlist)' {
  qui count  if `v'<.
  if (`r(N)'/`total'>.9) {
    di  "`: var lab `v''"
  }
  else {
    di "uh oh, few obs..."
  }
}

capture program drop counting
program define counting

qui count
loc total = `r(N)'

lookfor `1'
foreach v in `r(varlist)' {
  qui count  if `v'<.
  if (`r(N)'/`total'>.9) {
    di  "`: var lab `v''"
  }
  else {
    di "uh oh, few obs..."
  }
}
end

counting family
counting income

//TODO: a useful way to gauge completness of data
//essp if you have data created y yourself or your team;make it into ado!
egen num_missing = rowmiss(*)
gen perc_missing = round(num_missing/c(k)*100, 0.1)
li name perc_missing if perc_missing > 33
order num_missing perc_missing, first 
sort perc_missing

//SKIP not terribly useful for applied quick programming
/* debuggig */

/* log using "debug.log",replace */
/* set more off */
/* set trace on */
/* mymean kg */
/* set trace off */
/* log close */
/* /\* You can also limit the amount of output by using set tracedepth to follow nested commands only to a certain depth. So if *\/ */
/* /\* your program calls another program (which in turn calls another program) you can avoid the output from the second level *\/ */
/* /\* onwards by using *\/ */
/* set tracedepth 1 */
  

//SKIP: complicated and not terribly useful here!
/*  //better yet: using syntax   */
/* capture program drop mymean */
/* program define mymean */
/* syntax varlist(min=1 numeric) [if] [in] [, SUFfix(string)] */

/* cap drop *_mean */
/*       if "`suffix'" == "" local suffix "_mean" */
/*        foreach var in `varlist' { */
/*               confirm new var `var'`suffix' */
/*        } */
/*        foreach var in `varlist' { */
/*               qui egen `var'`suffix' = mean(`var') `if' `in' */
/*               qui sum `var'`suffix' */
/*               display "Mean of `var' = " r(mean) */
/*        } */
/* end */

/* mymean */

/* sysuse auto, clear */

/* mymean make */
/* mymean price mpg */
/* mymean price mpg, suf(_uuu) */
/* d */

//--------------AND see some of my programs....-------------------------------

//FIXME!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! definitely have sth way sinpmer than aok_ts!!! see my ado file!!!


//  this section importantly shows the process of program writing:
// first, you write, dofile, then you realize that you can use macros and loops
// and you realize that you used so manty macros and loops that you have a mess (see below)
// then you realize that you can make this mess easily into a program bu just adding few lines

//---make some time series plots to see politics over time
use "https://docs.google.com/uc?id=1lAJqCHDWRKWeuw-ta8ml-2acvouZHrII&export=download"

macro drop _p _u
drop lab*

local dv happy
local by rid
local gr_name fig5_happy_CML_I

local ylab "happiness"
codebook `by', tab(100)
local first_tab 1
local last_tab 3

local condition "rid>0"
local filter "w(4 1 5)"
local over year
*-----------------------------------------
  
forval a=`first_tab'/`last_tab'{
local p`a' (line `dv'`a'_ma `over' , sort)
local label_`a' : label `by' `a'
gen lab_`dv'`a'="`label_`a''"
local p `p' `p`a''
}

forval a=`first_tab'/`last_tab'{
local u`a' (scatter `dv'`a'_ma `over' if `over'==2008 , sort ml(lab_`dv'`a') mlabsize(large)  msize(zero) mlabpos(3))
local u `u' `u`a''
}
  
preserve
capture keep if `condition'
keep if `by'<.
gen id=_n
reshape wide `dv', i(id) j(`by')
collapse   (first) lab_*  (mean)  `dv'*, by(`over')
tsset `over'
forval a=`first_tab'/`last_tab'{
tssmooth ma `dv'`a'_ma =`dv'`a', `filter'
}
twoway `p'  `u', scheme(s2mono) ti(`ti') legend(off) ylabel(2.0(0.2)2.4, labsize(large)) xlabel(, labsize(large))ytitle(`ylab',size(large))xtitle(,size(large))
graph export `gr_name'.eps, as(eps)  replace mag(54)
restore 
   

//-----------but this is a mess --can make it into a program


/*****************/
/* aok_ts */
/*****************/
capture program drop aok_ts
program define aok_ts
 syntax  [if] [in], gr_name(string) note(string asis)  dv(string) by(string) filter(string asis) over(string)ylab(string asis) 
  preserve
  if "`if'"~="" | "`in'"~="" {
        keep `if'  `in'
  }
*-----------------------------------------
table   `over' `by', c(mean `dv' sd `dv' n `dv' ) format(%9.2f)center
capture macro drop _p _u
capture drop lab*

*//drop if <25 of dv per `by'  over
bys  `over' `by' : egen _count=count(`dv')
drop if _count<25
  
codebook `by', tab(100)
sum `by'
local first_tab `r(min)'
local last_tab `r(max)' 
local dv_lab : var lab `dv'

forval a=`first_tab'/`last_tab'{
local p`a' (line `dv'`a'_ma `over' , sort)
local label_`a' : label `by' `a'
gen lab_`dv'`a'="`label_`a''"
local p `p' `p`a''
}

keep if `by'<.
gen id=_n
reshape wide `dv', i(id) j(`by')
collapse   (first) lab_*  (mean)  `dv'* , by(`over')
tsset `over'
forval a=`first_tab'/`last_tab'{
tssmooth ma `dv'`a'_ma =`dv'`a', `filter'
}

forval a=`first_tab'/`last_tab'{
sum `over' if `dv'`a'_ma!=.
local last_yr `r(max)' 
local u`a' (scatter `dv'`a'_ma `over' if `over'==`last_yr' , sort ml(lab_`dv'`a') mlabsize(large)  msize(zero) mlabpos(3))
local u `u' `u`a''
}

twoway `p'  `u', scheme(s2mono) ti(`ti') legend(off) ylabel(`ylab', labsize(large)) xlabel(, labsize(large))ytitle(`dv_lab',size(large))xtitle(,size(large))note(`note',size(large))saving(`gr_name',replace)
graph export `gr_name'.pdf,   replace mag(54)
*//sh(epstopdf `d'out/base/`gr_name'.eps)
*//sh(xpdf `d'out/base/`gr_name'.pdf &)

di "!!!!!!!!!! adam check if the values essp at BOTH extremes correspond to the above table, essp with long smoothing like 10 yrs"
restore
end

aok_ts  ,  filter(w(4 1 5)) gr_name(weq) note(3. Lines for % of R D or I women who vote.10-yrMA) dv(happy) by(rid) over(year)ylab( ) 

aok_ts  ,  filter(w(4 1 5)) gr_name(weq) note(3. Lines for % of R D or I women who vote.10-yrMA) dv(happy) by(cml) over(year)ylab( ) 




*//------- forest plots -----------------------------------   SKIP: a mess; better use PY
*//------- forest plots -----------------------------------   SKIP: a mess; better use PY
*//------- forest plots -----------------------------------   SKIP: a mess; better use PY


/* use http://people.hmdc.harvard.edu/~akozaryn/myweb/aok_gss.dta,clear */
/* sample 25 */


/* *\//calculate sd as in here */
/* *\//http://www.ats.ucla.edu/stat/stata/faq/barcap.htm */

/* *\//specify vars    */
/* /\* local all happy satfin satfrnd satfam jobmeans hrs1 health *\/ */
/* /\*local all trust prestige prestg80 hompop income   age  mar  unemp   born *\/ */
/* /\*local all cath prot  hhblack male S1 S2 S3 S4 E1 E2 E3 E4 *\/ */
/* /\*local all fair getahead helpnot helpblk fatalism taxpoor taxmid taxrich polint    *\/ */
/* /\*local all litcntrl cntrlife   *\/ */

/* la var age "average age of group" */
/* la var prestg80 "occupational prestige" */
/* la var income "income" */
/* la var born "US born" */
/* la var prot "protestant" */
/* la var  trust "people can be trusted" */
/* la var cntrlife "people can control their lives" */
/* la var fatalism "people can change their life-course"    */

/* la var litcntrl "people can control the bad things" */
/* la var hrs1 "hours worked" */
/* la var health "health condition" */
/* la var jobmeans "work and accomplishment are unimportant"    */
/* la var taxrich "taxes on the rich  too low"    */
/* la var taxmid "taxes on the middle class  too low"    */
/* la var taxpoor "taxes on the poor too low"    */
/* la var helpnot "government does too much" */
/* la var helpblk "government should give no special treatment to blacks" */
/* la var S1 "live in city>250k" */
/* la var S2 "live in city 50k-250k" */
/* la var S3 "live in suburbs" */
/* la var S4 "live in small towns, country" */
/* la var fair "people are fair" */
/* la var class "social class" */
/* gen goodlife2=6-goodlife */
/* la var goodlife2 "standard of living will  improve" */

   
/* local gr_name   fig6_IDR    */
/* local all age  prestg80 income class born prot  happy  vv satfrnd  satfin satfam  trust cntrlife   fatalism  goodlife2      */

/* local gr_name   fig7_DIR    */
/* local all hhnblack hrs1 health jobmeans   litcntrl goodlife taxrich taxmid taxpoor helpnot helpblk  S1 S2 S3 S4  */

/* local gr_name   fig8_MLC    */
/* local all   */

/* local gr_name   fig9_LMC    */
/* local all age  mar  hhblack prot E1 happy   cntrlife taxrich taxmid taxpoor helpnot helpblk  S1 S2 S3 S4  hrs1 prestg80 income health jobmeans  fair trust  fatalism litcntrl        */

/* /\* sep10 *\/ */
/* *\//keep if rid==2 &(cml==1|cml==3) */

/* /\* local gr_name   independents1   *\/ */
/* /\* local all age mar prot S4 S1  satfin  helpblk  *\/ */
   
/* *\//specify cat */
/* local c  rid */
/* /\* rid    *\/ */

/* *\//title */
/* local t ""    */
   
/* capture drop _s* */
/* capture drop _lo_s*  */
/* capture drop _hi_s* */

   
/* foreach v in `all'{    */
/* local varlab_`v' : var lab `v' */
/* capture drop _s`v'  */
/* capture drop _lo_s`v'  */
/* capture drop _hi_s`v' */

/* egen _s`v'=std(`v') */
/* bys `c':egen _sd_s`v'=sd(_s`v') */

/* bys `c':egen _n`v'=count(_s`v') */
/* bys `c':egen _m`v'=mean(_s`v') */
 
/* bys `c':gen _lo_s`v'=_m`v'-invttail(_n`v'-1,0.025)*_sd_s`v'/sqrt(_n`v') */
/* bys `c':gen _hi_s`v'=_m`v'+invttail(_n`v'-1,0.025)*_sd_s`v'/sqrt(_n`v') */

/* drop _m* */
/* drop _n* */
/* drop _sd* */
/* *\//double check if looks same as from ci command */
/* *\//bys `c': tab _lo_s`v' */
/* *\//bys `c': ci(_s`v')    */
/* } */

/* *\// double check if the same as in ciplot    */
/* /\* ciplot male cath2  , by(`c') hor saving(g2, replace) *\/ */
/* /\* graph export `d'out/base/test.eps, as(eps)  replace  *\/ */
/* /\* sh(epstopdf `d'out/base/test.eps) *\/ */
/* /\* sh(xpdf `d'out/base/test.pdf &) *\/ */



/* /\*   ciplot `all'  , by(`c') hor saving(g2, replace)   legend(size(tiny)) *\/ */
   
/* preserve    */
/* drop if `c'==. */
/* collapse _s*  _lo_s* _hi_s* , by(`c') */
/* des _* */
/* reshape long _s _lo_s _hi_s, i(`c') j(_var) string */

/*  *\//try to put them in order   */
/* tab  _var */
/* tab _var, nola  mi */
/* local i=1 */
/* gen ord=.    */
/* foreach v in `all'{ */
/*   replace ord=`i' if _var=="`v'" */
/* local i=`i'+1 */
/* } */

/*  *\// possibly try to do it here at once  ord instead of _var */
/* local i=1 */

/* foreach v in `all'{    */
/* replace _var="`varlab_`v''" if _var=="`v'" */

/* label define aok1 `i' "`varlab_`v''" , add */
/* local i=`i'+1 */
/* } */
/* la val ord aok1 */
   
/* encode _var, gen(_n_var) */

/* tab ord */
/* tab _n_var    */

/* *\//this is wrong--doesn't work:( as seen with list    */
/* *replace _n_var=_n_var+1000*ord */
/* *l */
/* *l, nola */
/* *label variable  ord : _n_var */

   
/* *\//http://www.stata.com/help.cgi?graph_display     */
/* twoway (scatter   ord _s, mcolor(white) msize(zero) msymbol(point) mlabel(`c') mlabcolor(black) mlabposition(12)) (rcap _lo_s _hi_s  ord, hor lcolor(gs7))  , xlabel(-.6(.2).4)ylabel(1(1)25,valuelabels angle(horizontal) labs(medsmall)) legend(off) saving(g1, replace) ytitle("") aspectratio(, placement(east)) yscale(reverse) ti(`t')ytitle(,size(medsmall))xtitle(,size(medsmall))xlabel(, labsize(medsmall))scheme(s2mono)graphregion(margin(l=2 r=2 t=2 b=2))ysize(4)xtitle("standarized value")plotregion(margin(l=2 r=2 t=2 b=2))scale(.75) */
/* graph export `gr_name'.eps, as(eps)  replace mag(100) */


/* //---------------------------------- */
/* capture program drop aok_forest */
/* program define aok_forest */
/*  syntax  [if] [in], gr_name(string)  d(string asis) all(string) by(string) t(string asis)  */
/*   preserve */
/*   if "`if'"~="" | "`in'"~="" { */
/*         keep `if'  `in' */
/*   } */
/* *----------------------------------------- */
/* loc c `by' */

/* local var_count : word count `all' */

/* capture drop _s* */
/* capture drop _lo_s*  */
/* capture drop _hi_s* */

   
/* foreach v in `all'{    */
/* local varlab_`v' : var lab `v' */
/* capture drop _s`v'  */
/* capture drop _lo_s`v'  */
/* capture drop _hi_s`v' */

/* egen _s`v'=std(`v') */
/* bys `c':egen _sd_s`v'=sd(_s`v') */

/* bys `c':egen _n`v'=count(_s`v') */
/* bys `c':egen _m`v'=mean(_s`v') */
 
/* bys `c':gen _lo_s`v'=_m`v'-invttail(_n`v'-1,0.025)*_sd_s`v'/sqrt(_n`v') */
/* bys `c':gen _hi_s`v'=_m`v'+invttail(_n`v'-1,0.025)*_sd_s`v'/sqrt(_n`v') */

/* drop _m* */
/* drop _n* */
/* drop _sd* */
/* *\//double check if looks same as from ci command */
/* *\//bys `c': tab _lo_s`v' */
/* *\//bys `c': ci(_s`v')    */
/* } */

/* *\// double check if the same as in ciplot    */
/* *\/\* ciplot male cath2  , by(`c') hor saving(g2, replace) *\/ */
/* *\/\* graph export `d'out/base/test.eps, as(eps)  replace  *\/ */
/* *\/\* sh(epstopdf `d'out/base/test.eps) *\/ */
/* *\/\* sh(xpdf `d'out/base/test.pdf &) *\/ */

/* *\/\*   ciplot `all'  , by(`c') hor saving(g2, replace)   legend(size(tiny)) *\/ */
   
/* drop if `c'==. */
/* collapse _s*  _lo_s* _hi_s* , by(`c') */
/* des _* */
/* reshape long _s _lo_s _hi_s, i(`c') j(_var) string */

/*  *\//try to put them in order   */
/* tab  _var */
/* tab _var, nola  mi */
/* local i=1 */
/* gen ord=.    */
/* foreach v in `all'{ */
/*   replace ord=`i' if _var=="`v'" */
/* local i=`i'+1 */
/* } */

/*  *\// possibly try to do it here at once  ord instead of _var */
/* local i=1 */

/* foreach v in `all'{    */
/* replace _var="`varlab_`v''" if _var=="`v'" */

/* label define aok1 `i' "`varlab_`v''" , add */
/* local i=`i'+1 */
/* } */
/* la val ord aok1 */
   
/* encode _var, gen(_n_var) */

/* tab ord */
/* tab _n_var    */

/* *\//this is wrong--doesn't work:( as seen with list    */
/* *replace _n_var=_n_var+1000*ord */
/* *l */
/* *l, nola */
/* *label variable  ord : _n_var */

   
/* *\//http://www.stata.com/help.cgi?graph_display     */
/* twoway (scatter   ord _s, mcolor(white) msize(zero) msymbol(point) mlabel(`c') mlabcolor(black) mlabposition(12)) (rcap _lo_s _hi_s  ord, hor lcolor(gs7))  , xlabel(-.6(.2).4)ylabel(1(1)`var_count',valuelabels angle(horizontal) labs(medsmall)) legend(off) saving(g1, replace) ytitle("") aspectratio(, placement(east)) yscale(reverse) ti(`t')ytitle(,size(medsmall))xtitle(,size(medsmall))xlabel(, labsize(medsmall))scheme(s2mono)graphregion(margin(l=2 r=2 t=2 b=2))ysize(4)xtitle("standarized value")plotregion(margin(l=2 r=2 t=2 b=2))scale(.75) */
/* graph export `d'out/base/`gr_name'.eps, as(eps)  replace mag(100) */


/* restore */

/* end */

/* use http://people.hmdc.harvard.edu/~akozaryn/myweb/aok_gss.dta,clear */

/* count */
/* sample 25 */
/* count */

/* aok_forest, gr_name(gr)  d(somewhere) all(age mar E1 S1 S2 S3 S4  class) by(rid) t(title)  */

/* aok_forest, gr_name(gr)  d(somewhere) all(age mar E1 S1 S2 S3 S4  class) by(cml) t(title)  */










//MEH< STAY AWAY FROM R
/*
*------------------------------------------------------------------------------------------------------------------------------
//---if you like to stay in stata you can run r from stata....
cap mkdir c:\files
sysdir set PLUS c:\files

ssc install rsource
global Rterm_options `"--vanilla --quiet"'
global Rterm_path `"/usr/bin/R"'
//global Rterm_path `"C:\Program Files\R\R-2.12.1\bin\R.exe"'
//global Rterm_path `"C:\Program Files\R\R-2.12.1\bin\i386\Rcmd.exe"' 
//write R script save somewhere, and... ~/Desktop/junk/blup/r.r
file open rscript using c:\files\r.r, write replace
file write rscript "library(rpart);data(kyphosis);summary(kyphosis);fix(kyphosis);names(kyphosis)" _n
file close rscript
type c:\files\r.r
rsource using c:\files\r.r

//well, make it into a program!

//rr stands for run r...
cap program drop rr
program define rr
//this is good just for one graph...
//can output interesting stuff with say  write.csv
version 10
syntax anything

file open rscript using c:\files\run_r_from_stata.r, write replace
//here i am adding some useful stuff that i may want to modify...
save c:\files\dta_for_r.dta, replace
file write rscript `"library(foreign)"' _n
file write rscript `"dta<-read.dta("c:\\files\\dta_for_r.dta")"' _n
file write rscript `"attach(dta)"' _n
//to save a graph
file write rscript `"pdf(file="c:\\files\\run_r_from_stata.pdf")"' _n
// whatever i want to pass on...
file write rscript `"`anything'"' _n

//nah, don't need that
//file write rscript `"dev.off()"' _n

file close rscript
//type /tmp/run_r_from_stata.r
rsource using c:\files\run_r_from_stata.r

//this would be to open a graph..., just skip it..
//! xpdf /tmp/run_r_from_stata.pdf &
! "C:\Program Files\Adobe\Reader 9.0\Reader\AcroRd32.exe" c:\files\run_r_from_stata.pdf
end

//let's test it...
sysuse auto
sum mpg
reg mpg price
//and from R
rr summary(mpg);  lm(mpg ~ price) ; hist(mpg)
*/


//-----------------------------------------exercises--------------------------------------------------------

//---exercise 1---

use https://sites.google.com/site/adamokuliczkozaryn/datman-1/gss.dta, clear

loc val_labels ""
levelsof inc, loc(_inc)
foreach val in  `_inc'{
loc val_lab : label rincom06 `val'
loc val_labels  `val_labels' `val_lab'
}

di "`val_labels'"  

//---------- exercise 2------------

use https://sites.google.com/site/adamokuliczkozaryn/datman-1/gss.dta, clear

loc all_results ""         
levelsof marital, loc(mar)

*//levels of marital are not string but numeric  
di "`mar'"

foreach r in `mar'{
reg happy age if marital==`r'
loc result=   _b[age]
loc name  "`r'"
loc all_results `all_results' `name' `result'
}  
di "`all_results'"         


//---exercise 2 fancy way:

use https://sites.google.com/site/adamokuliczkozaryn/datman-1/gss.dta, clear

loc all_results ""         
levelsof marital, loc(mar)

*//levels of marital are not string but numeric  
di "`mar'"

foreach r in `mar'{
reg happy age if marital==`r'
*//we can format display , rmember about colon
loc result: display %5.4f  _b[age]
*// we can use extended macros to pull out variable label
loc name  "`: label marital `r''"
loc all_results `all_results' `name' `result'
}  
di "`all_results'"         


//---exercise 3---- 

qui count
loc total = `r(N)'

lookfor family
foreach v in `r(varlist)' {
  qui count  if `v'<.
  if (`r(N)'/`total'>.9) {
    di  "`: var lab `v''"
  }
  else {
    di "uh oh, few obs..."
  }
}
