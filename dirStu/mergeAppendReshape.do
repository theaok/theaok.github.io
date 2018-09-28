*______________________________________________________________________
* Data Management in Stata
*Adam Okulicz-Kozaryn, Summer 09
*Revised: spring2016

* notes : 
clear         
set matsize 800 
version 14
set more off
*--------------------------------------------------------------------
*--------------------------------------------------------------------
local worDir "PUT YOUR WORKING DIR ON DESKTOP DESIRED PATH AND NAME HERE" //again, run as one chunk, locals die after one run
cap mkdir `worDir'
cd  `worDir'



/****************/
/* Combine Data */
/****************/


***Merge


*match dads and moms; from www.ats.ucla.edu/stat/stata/modules/combine.htm
clear
input famid str10 dadName dadInc
2 "Jeb"  22000
1 "Marco"  30000
3 "Donald" 25000
4 "Ted"  100000
end
save dads, replace
list 

clear
input famid str10 momName momInc
1 "Angela"  15000
3 "Megyn"  50000
2 "Carly"  18000
5 "Hilary"  200000
end
save moms, replace
list 


use dads, clear //master
list 

merge 1:1 famid using moms //moms is using
l


*our favorite gss data (from slide)
use https://sites.google.com/site/adamokuliczkozaryn/datman-1/gss.dta, clear    
gen id= _n
keep id region
save gss1.dta, replace /* (using)*/
use https://sites.google.com/site/adamokuliczkozaryn/datman-1/gss.dta, clear    
gen id= _n
keep id inc /* (master)*/
merge 1:1 id using gss1.dta /* combine with (using)*/
tab _merge /*always think about the merging results*/

//and more examples below (from merge helpfile; all helpfiles have examples at the bottom)


*cars merging
webuse autosize, clear
list
webuse autoexpense,clear
list
//1:1 merge
webuse autosize
merge 1:1 make using http://www.stata-press.com/data/r14/autoexpense
list

//1:1 merge, requiring there to be only matches
// (The merge command intentionally causes an error message.)
webuse autosize, clear
merge 1:1 make using http://www.stata-press.com/data/r14/autoexpense, assert(match)
tab _merge
list

//1:1 merge, keeping only matches and squelching the _merge variable
//don't do it--we don't know what really happened
webuse autosize, clear
merge 1:1 make using http://www.stata-press.com/data/r14/autoexpense, keep(match) nogen
list


* m:1

webuse dollars, clear
list
webuse sforce,clear
list

//m:1 match merge with sforce in memory
merge m:1 region using http://www.stata-press.com/data/r14/dollars
list //note that sales and cost repeat themselves (are not unique) within regions
// and the are unique across regions; names are unique both ways
//it is important to be clear about this!

clear
input id age edu str2 state  //persons
1 23 12 TX
2 43 16 TX
3 82 10 CA
4 24 16 CA
5 34 18 CA
6 38 15 NY
end
l
save ppl, replace

clear
input str2 state pop criRat urbPct  //states
TX 26 508.2 75.4
CA 38 503.8 89.7
NY 19 401.8 82.7
AL 10 900   3.3
end
l

merge 1:m state using ppl
l


/*Append*/  
use https://sites.google.com/site/adamokuliczkozaryn/datman-1/gss.dta, clear    
keep in 1/5
save gss1.dta, replace/* (using)*/
use https://sites.google.com/site/adamokuliczkozaryn/datman-1/gss.dta, clear    
keep in 6/10
append using gss1.dta


//--------------------------

/*Reshape*/
use gss.dta, clear
keep inc
ren inc inc1
gen inc2=2*inc1
gen id= _n
l id inc*, nola
reshape long inc, i(id) j(period)
l


//http://campus.lakeforest.edu/lemke/econ330/stata/lab3/index.html
use http://campus.lakeforest.edu/lemke/econ330/stata/lab3/wisconsin98data.dta,clear
keep in 1/10
keep name  name bamin* bamax* 
list name bamin* bamax* 
reshape long bamin bamax, i(name) j(year)
l

reshape wide bamin bamax, i(name) j(year)
l

//sometimes need to reshape twice
use http://www.ssc.wisc.edu/sscc/pubs/files/stata_prog/monthyear.dta, clear
d
reshape long incJan incFeb incMar incApr incMay incJun incJul incAug incSep incOct incNov incDec, i(id)j(yr)
gen id2=_n
reshape long inc, i(id2)j(mo)string
d

//-----------------SKIP THE FOLLOWING------------------



TODO: redo this exercise with something more real world--where 2 disctinct
datasets are merged not one that is fake--guess just input data like with dads
and moms above!!

//---------EXERCISE 1--------------


 load fresh gss.dta
for each of the following
 create id, a unique identifier for each observation; 
 save two datasets: one with id and region only, another with id and
 income only;  merge these two datasets
  create another two datasets: one with first 50
 observations, another  contains the rest observation;  append them
  create new variable: income\_in\_previous\_year which
 is 10\% smaller than respective income for this year;  reshape
 dataset to long format on income' hint: remember to have similar
 prefix on both, eg. `inc' and different suffix, eg. `1' and `2'


























  
*__________________________________________________________________
/*exercises--solutions*/




/*1*/

use gss.dta, clear
gen id= _n
keep id region
save gss1.dta, replace
use gss.dta, clear
gen id= _n
keep id inc
merge id using gss1.dta, sort
tab _merge

use gss.dta, clear
keep in 1/50
save gss1.dta, replace
use gss.dta, clear
keep in 51/l
append using gss1.dta
edit

use gss.dta, clear
gen inc1=inc
gen inc2=.9*inc
drop inc /*need to drop this one because we want to have only two inc
variables*/
gen id= _n
reshape long inc, i(id) j(period)

edit

