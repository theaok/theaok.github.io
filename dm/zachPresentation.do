*- Data Management 
*- Extra Stata commands (syntax)
*- Feb 26, 2022

*----------
* -1- summarize
*----------

sysuse nlsw88, clear /*nlsw 88 is a dataset used in the Stata Documentation seleted to 
demonstrate the use of Stata */

sum south smsa wage race 

*- another way to do it? 

sum s* //the initial letter of south & smsa
sum *e // all the variables ended with the letter e
sum ?a?e //the common letters of wage & name
*or 
sum ?a??
sum ???e

*----------
* -2- how to convert noninteger values into integers values
*----------

sysuse nlsw88, clear 

generate floor_wage = floor(wage) //cannot be written as floor (wage) cuz there is no space between
help floor /* returns the largest integer i such that i ≤ R */ 
generate ceil_wage = ceil(wage)
help ceil /* returns the smallest integer i such that i ≥ R */ 
generate trunc_wage = trunc(wage)
help trunc /* returns the integer part of R. */
generate round_wage = round(wage)
help round /* returns the integer closest to R */

/* for exmaple, floor(6.48)=6; ceil (6.48)=7; floor(1300.001)=1300; ceil(1300.001)=1301 */

*----------
* -3- move spaces in Stata
*----------

* _col(#)
/* The _col(#) option places text in a specific column. In the example below, 
each display command moves "hello" 5 columns to the right of the previous command */ 

* for example 
display _col(5) "hello"
display _col(10) "hello"
display _col(15) "hello"
display _col(20) "hello"

* we can use multiple _col(#) options in the same commands

di "Variable" _col(15) "Mean" _col(25) "SD" _col(36) "Label"

*** there is more
*_s(#)  //skip # spaces to display 
*_n(#)  // places text in a specific row
* for example 
display _s (5) "hello"
display _n(5) "hello"

*----------
* -4- missing data
*----------
*.....how to find the missing data
* method No.1
sysuse nlsw88.dta, clear
misstable sum   // to locate the missing values in all the variables
misstable sum age-union  // to locate the missing values for the selected variables

* No.2
misstable pattern // to display the pattern
misstable pattern, bypat // bypat = by pattern
* 1 == without missing values; 0 == with missing values

* No.3
misstable tree // a tree view of missing-value patterns
misstable tree union tenure in 1/1000, freq  // display frequencies

* No.4
misstable nested // nesting pattern for missing values

*..... how to delete the missing values
* Method No.1
sysuse nlsw88.dta, clear
egen miss = rmiss(wage industry occupation)  // r=row
list wage industry occupation miss if mis!=0 /* display 0 if there is no missing value; display 1 if there is one variable with missing values; display 2 if there are two variables with missing values */
drop if miss!=0 // there is at least one variable if o is not displayed, so delete them

* No.2
sysuse nlsw88.dta, clear
summarize
drop if missing(grade, industry, occupation, union, hours, tenure)
sum


