/*Exporting regression results*/

/*
Output from stata (regressions, etc) are data, too. And we need to manage it, too.
We will explore ways to save Stata output in excel (excel is pretty good for
looking at tables). Stata can export to latex, but we will
skip it. We will export estimation results and descriptive statistics.
*/

//---first: crime and mionrity-------------------------

import excel using "https://docs.google.com/uc?id=1r4I3ff33QlSvHX7hniLQ4sD8NItymXq8&export=download", clear firstr

gr matrix Crime Foreign Unempl College  Growth SNAP , half
tw(scatter Crime Foreign)(lowess Crime Foreign)

pwcorr   Crime Foreign Unempl College  Growth SNAP

reg Crime Foreign //more foreigners more crime
est sto a1
reg Crime Foreign Unempl
est sto a2
reg Crime Foreign Unempl College, robust
est sto a3
reg Crime Foreign Unempl College Growth, robust
est sto a4
reg Crime Foreign Unempl College Growth SNAP, robust //not anymore!!
est sto a5

est tab a*, star   b(%9.3f) 
hilo Crim Forei Muni
hilo  Forei Crim Muni

sum For if Crime>362
sum For if Crime<362

sum For if Crime>200
sum For if Crime<200


sum For if Crime>20
sum For if Crime<20



//---------------------outreg2-------------------------
  
findit outreg2

sysuse auto, clear
	

/* *run some regression */
xi: ologit rep78  mpg      , robust
/* *and then export to excel, note eform option that will exponentiate betas; ct will give it column title A1 */
outreg2 using reg1.xls, onecol bdec(2) st(coef) excel replace ct(A1) eform lab
/* *then i run some otjer specification */
xi: ologit rep78  mpg price    , robust
/* *and outreg2 again but i append instead of replace */
outreg2 using reg1.xls, onecol bdec(2) st(coef) excel append ct(A2) eform lab  


sysuse auto, clear
reg mpg price
outreg2 using reg1.xls,  bdec(2) st(coef) excel replace ct(A1)  lab
reg mpg price weight 
outreg2 using reg1.xls,  bdec(2) st(coef) excel append ct(A2)  lab


sysuse auto, clear
oprobit rep78 mpg
outreg2 using excel.xls, replace e(all) long
/* or maybe just: e(ll N) for instance */



//-----------------estout------------------------------------------------
est clear
  
sysuse auto, clear
oprobit rep78 mpg
 est title: bla bla
 est sto a1

oprobit rep78 mpg weight length
 est title: ga ga 
 est sto a2
  
estout a*  using blup.xls, replace style(tab) eform cells(b(star fmt(%9.2f))) stats(N, labels( "Number of obs" ) fmt(%9.0f))  varlabels(_cons Constant) label legend 





//----------------------------SKIP--------------------------------------
//----------------------------SKIP--------------------------------------
//----------------------------SKIP--------------------------------------





//-----------------logout------------------------------------------------

net from http://fmwww.bc.edu/RePEc/bocode/l
net install logout
sysuse auto, clear

//excel
logout, save(" ~/Desktop/junk/blup.xls")  excel replace: tab rep78 
logout, save(" ~/Desktop/junk/blup.xls")  excel replace: tab rep78 foreign
logout, save(" ~/Desktop/junk/blup.xls")  excel replace: tabstat mpg weight,by(foreign) stat(mean sd min max)

//now latex
logout, save(" ~/Desktop/junk/blup.xls")  tex replace: tab rep78 
logout, save(" ~/Desktop/junk/blup.xls")  tex replace: tab rep78 foreign
logout, save(" ~/Desktop/junk/blup.xls")  tex replace: tabstat mpg weight,by(foreign) stat(mean sd min max)



//-----------------collapse------------------------------------------------

sysuse auto, clear
collapse (mean)mean_mpg= mpg (sd)sd_mpg= mpg (median) weight (count) foreign, by(rep78) 
l
outsheet using ~/Desktop/junk/ex.csv, replace csv
/**************/
/* references */
/**************/

more about estout
http://repec.org/bocode/e/estout/
  

//-----------------exporting results ; data mining? using post... -------------------------

sysuse auto,clear
regress mpg price
display _b[price]
display _se[price]
test price


* step 1 - create the empty file xyresults1.dta
postfile anything b se p using xyresults1, replace
* step 2a - run the regression and save the results
regress mpg price
local b = _b[price]
local se = _b[price]
test price
local p = r(p)
* step 2b - post the results
post anything (`b') (`se') (`p')
* step 3 - close the postfile
postclose anything
* step 4 - Show the results
use xyresults1, clear
list

//---
sysuse auto,clear

postfile abc str10 xvar b se p using xyresults2, replace
foreach x of varlist price weight length {
   quietly regress mpg `x' 
   local b = _b[`x']
   local se = _se[`x']
   quietly test `x'
   local p = r(p)
   post abc ("`x'") (`b') (`se') (`p')
}

postclose abc
use xyresults2, clear
list
l if p<.05


//---
sysuse auto,clear
mlogit rep78 price, base(1)
display [2]_b[price]
display [3]_b[price]
display [2]_se[price]
display [3]_se[price]

//get RRR
display "RRR equation 2 is " exp([2]_b[price])
display "RRR equation 3 is " exp([3]_b[price])
display "se of RRR equation 2 is " exp([2]_b[price])*[2]_se[price]
display "se of RRR equation 3 is " exp([3]_b[price])*[3]_se[price]
mlogit , rrr

test [2]price
display r(p)

test [3]price
display r(p)

postfile xymlogit str10 xvar rrr2 rrr3 se2 se3 p2 p3 using xymlogit, replace

foreach x of varlist price weight length {
   quietly mlogit rep78 `x', base(1) 
   local rrr2 = exp([2]_b[`x'])
   local rrr3 = exp([3]_b[`x'])
   local se2 = exp([2]_b[`x'])*[2]_se[`x']
   local se3 = exp([3]_b[`x'])*[3]_se[`x']
   quietly test [2]`x'
   local p2 = r(p)
   quietly test [3]`x'
   local p3 = r(p)
   post xymlogit ("`x'") (`rrr2') (`rrr3') (`se2') (`se3') (`p2') (`p3')
 }
postclose xymlogit
use xymlogit, clear
l

//---more about exporting results and references:

use file open file write
help file and:

http://www.ats.ucla.edu/stat/stata/faq/fileread.htm

http://www.ats.ucla.edu/stat/stata/faq/append_many_files.htm

http://www.ats.ucla.edu/stat/stata/faq/filewrite.htm

//-----------------END exporting results  -------------------------




//-----------------------------------------scrap--------------------------------
/*********/
/* todo: */
/*********/
  svymatrix
  latab
  etc etc
