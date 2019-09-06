*______________________________________________________________________
* macros loops
*Revised:

* notes : run the whgole chunk, like me, so that locals persist!
//and, related, i ofter repreat local so that it is easier to run just a chunk
//if you ran the whole thing at once, do not need to repeat locals! say in your ps 

clear         
set matsize 800 
version 14
set more off
*--------------------------------------------------------------------
*--------------------------------------------------------------------

/**********/
/* macros */
/**********/
  
local x 1
display `x'

local x 2+2
display `x'
display "`x'"

local x adam
di "`x'"

global x stata
di "$x"

di "`x' likes $x"


loc dir "c:\files" //TODO: adjust to the lab
cap mkdir   `dir'
cd  `dir'
ls `dir'

use http://people.hmdc.harvard.edu/~akozaryn/myweb/gss.dta, clear
d
sum

ta marital,gen(M)
ta region, gen(R)
d
reg happy         educ M2 M3 M4 M5  R2 R3 R4
reg happy     inc educ M2 M3 M4 M5  R2 R3 R4
reg happy age inc educ M2 M3 M4 M5  R2 R3 R4

//you will probably run lots of resressions so you may as well save some typing and clicking
loc c M2 M3 M4 M5  R2 R3 R4

reg happy         educ `c'
reg happy     inc educ `c'
reg happy age inc educ `c'

//you can combine things, too [just an example, not very practical]
loc c M2 M3 M4 M5  R2 R3 R4

reg happy age inc educ `c'
loc c2 age inc educ

reg happy `c' `c2'

loc c3 `c' `c2'

reg happy `c3'


//list macros
macro l

//drop macros
macro drop
macro drop _all


/*********/
/* loops */
/*********/
//we will mostly use foreach there is a bunch of different foreach see "help foreach", essp the exampples at the end
  
foreach color in red blue green {
display "`color'"
}


sysuse auto, clear
foreach yvar in mpg price displacement {
reg `yvar' foreign weight
}


use http://www.ssc.wisc.edu/sscc/pubs/files/stata_prog/months.dta,clear
d
gen hadIncJan=(incJan>0) if incJan<.
ta hadIncJan incJan  //messy
ta  incJan hadIncJan //neat


drop hadIncJan

foreach month in Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec {
gen hadInc`month'=(inc`month'>0) if inc`month'<.
}

d
sum

sysuse auto,clear
d
foreach oldname of varlist * {
local newname=upper("`oldname'")
rename `oldname' `newname'
}
d


forvalues i=1/5 {
display `i'
}

forvalues i=1/5 {
display `i'
di " some more math"
display `i'^`i'
}

use http://people.hmdc.harvard.edu/~akozaryn/myweb/gss.dta, clear
codebook marital
levelsof marital, loc(marital)
di "`marital'"


//a nested loop--nested loops are cool!
forval i=1/3 {
forval j=1/3 {
display "`i',`j'"
}
}


levelsof happy
local happy "`r(levels)'"

levelsof region, loc(region)
levelsof marital, loc(marital)
foreach m in `marital' {
       foreach r in `region' {
              sum inc if marital == `m' & region == "`r'"
       }
}


levelsof region, loc(region)
levelsof marital, loc(marital)
foreach m in `marital' {
       foreach r in `region' {
             di "************************************"
             di "this is marital `m'  and region `r'"  
             sum inc if marital == `m' & region == "`r'"
       }
}
  

levelsof region, loc(region)
levelsof marital, loc(marital)  
foreach lev in `marital'{
reg happy inc if marital==`lev'
}

*//that looked nice but we do not know which regression is which...; we use extended macro, more  about them later
levelsof region, loc(region)
levelsof marital, loc(marital)
foreach lev in `marital'{
di "*************************************"
di "***this is `:label marital `lev''***"
reg happy inc if marital==`lev'
}


use http://www.ssc.wisc.edu/sscc/pubs/files/stata_prog/monthyear.dta
d
forval year=1990/2010 {
foreach month in Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec {
gen hadInc`month'`year'=(inc`month'`year'>0) if inc`month'`year'<.
}
}
d


use http://people.hmdc.harvard.edu/~akozaryn/myweb/gss.dta, clear
codebook marital
levelsof marital, loc(m)
di "`m'"
ls
foreach lev in `m'{
  preserve
  keep if marital==`lev'
save mar`lev',  replace
  restore
}
ls mar*


//a useful trick to grab the contents of directory...
local datafiles1: dir . files "*.dta"
local datafiles2: dir . files "mar*.dta"
di `"`datafiles1'"'
di `"`datafiles2'"'

clear all
foreach file of local datafiles2 {
count
append  using `file'
}

d
sum
count

//note that above we use compound double quotes because  file names are already in quotes (to allow blanks)
display "Hamlet said "To be, or not to be.""

/* The solution is what Stata calls compound double quotes. When Stata sees `" (left single quote followed by a double quote) it treats what follows as a string until it sees "' (double quote followed by a right single quote). Thus: */

display `" Hamlet said "To be, or not to be." "'


//can also fromat macro...
sysuse auto,clear
reg mpg weight   //run a reg
local r2: display %5.4f e(r2)  //pull out useful info and format it
twoway (lfitci mpg weight) (scatter mpg weight), note(R-squared=`r2')  //stick it into a graph


// a very useful command ds
sysuse auto,clear
ds, not(type string) 
sum `r(varlist)'
         
/*************/
/* branching */
/*************/
/*
         if year==1960 {
           code for handling observations from 1960
         }
         else {
           code for handling observations from other years
         }
         
*/
use http://people.hmdc.harvard.edu/~akozaryn/myweb/gss.dta, clear
d         
sum

confirm numeric variable happy
confirm numeric variable region
help confirm  //like assert, useful...

         foreach var of varlist *{
           capture confirm numeric variable `var'
           if _rc==0 {
             sum `var', meanonly
             replace `var'=`var'-r(mean)
           } 
           else display as error "`var' is not a numeric variable and cannot be demeaned."
         }
sum

/**************************/
/* more examples          */
/**************************/

use http://people.hmdc.harvard.edu/~akozaryn/myweb/gss.dta, clear
       
forvalues m = 1/5 {
       qui sum inc if  marital == `m' &  sex== 1
       di "mean male income for marital status `m' is: " r(mean)
}

forvalues m = 1/5 {
       qui sum inc if  marital == `m' &  sex== 1
       di "mean male income for `:label marital `m'' is: " r(mean)
}
         
        
local i 1
while `i'<=5 {
display `i++'
}

local i=1
while `i'<=5 {
       display "loop number " `i'
       local i=`i'+1
}

//local ++i /* same result as local i=`i'+1 */         
         
forval i=1/5 {
display `i'
}

//use or not use equal sign with macros; usualy don't you can have then 67k of characters in macro,
if you use only 80 , but you need to have equal sign if you do an operations

loc i 10
loc j 10 +`i'
di "`j'"

loc i 10
loc j = 10 +`i'
di "`j'"

// can also have scalars... and matrices -- more later         
scalar root2=sqrt(2)
display root2

//using results of stata commands
http://www.stata.com/support/faqs/stat/mi_combine.html
http://www.ats.ucla.edu/stat/stata/faq/returned_results.htm         

ta mar happy
help tabulate twoway

ta mar happy
return list         

reg happy inc
ereturn list

reg happy age inc
mat l e(b)        
loc age=_b[age]
di `age'        


/this is a way to be productive with code
//easy to adjust for a project
d p* mp* h* d*
foreach v of varlist p* mp* h* d*{
hist `v', percent saving (`v'.gph,replace) by(foreign)
}

local df: dir . files "*.gph"
graph combine `df'


import excel "https://docs.google.com/uc?id=1QfvuTHE1kzyF4ju39jq0oxlO6NFhVB-V&export=download", clear 
d
ta B

//say you just need name for merging
foreach c in "Atlantic" "Bergen" "Burlington" "Camden" "Cape May" "Cumberland" "Essex" "Gloucester" "Hudson" "Hunterdon" "Mercer" "Middlesex" "Monmouth" "Morris" "Ocean" "Passaic" "Salem" "Somerset" "Sussex" "Union" "Warren" {
replace B = "`c'"  if B == "`c' County, NJ"
} 

ta B
