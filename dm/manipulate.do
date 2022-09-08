*______________________________________________________________________
* Data Management in Stata
*Adam Okulicz-Kozaryn, Summer 09
*Revised: spring2016, F17, S22, f22

* notes : 
clear         
set matsize 800 
version 14
set more off
*--------------------------------------------------------------------
*--------------------------------------------------------------------

//that's a fancy macro, we'll cover it when we do programing; run as one chunk
local worDir "PUT YOUR WORKING DIR ON DESKTOP DESIRED PATH AND NAME HERE"
cap mkdir `worDir'
cd  `worDir'

//make things simpler!
use https://sites.google.com/site/adamokuliczkozaryn/datman-1/gss.dta, clear
set seed 123456789 //setting randomness to a constant
sample 50, count
d
sum
save gss.dta, replace

/**************/
/* Variables  */
/**************/

use gss, clear


/* Basics */

generate age2=age^2

tab marital                   /*check var values*/
tab marital, nola             /*without labels*/
tab marital, mi               /*checking for missings*/
codebook marital, tab(100)    /* codebook will show both: values and value labels; use tab(100) to */
                              /* get all values*/
generate married=.            /*gen empty var*/
replace married=1 if marital==1
replace married=0 if marital>1 & marital<10 /*remember that Stata understands missing as a very big value*/
                              /* we will talk about missings at the end of this section*/

use gss.dta, clear            /*here the same thing using recode*/
recode marital (1 =1) (2/5=0), gen(married)
use gss.dta, clear
recode marital (1 =1) (nonm=0), gen(married) /*'nonm': everything else except missing; beware of 'else'*/ 

//and again, remember that you can put in val labels in there
cap drop married
recode marital (1 =1 "yes") (nonm=0 "no"), gen(married)

ta marital married, mi  //always double check essp if you are a rookie

gen youMar=.
la var "young and married"
replace youMar=1 if (marital==1 & age < 40)
replace youMar=0 if marital!=1 | (age > 39 & age <.)

ta youMar marital, mi
ta youMar age, mi

/* Egen */

use gss, clear
egen avg_inc=mean(inc)
sum avg_inc
sum inc
gen dev_inc=inc-avg_inc
l inc avg_inc dev_inc in 1/10, nola

bys marital: egen avgm_inc=mean(inc)


l  *inc* *mar*  if marital==4 | marital==2

sort marital
l  *inc* *mar* , nola sepby(marital) //note that avg_inc is constant, but avggm_inc varies by marital
//and note that . is dropped when calculating egen stats as in marital==4
//there are 3obs: 15, .i, 9, and mean is 12

//http://www.stata.com/support/faqs/data-management/create-variable-recording/
clear
input    family     person       sex 
         1          1          1  
         1          2          1  
         1          3          1  
         2          1          0  
         2          2          0  
         2          3          0  
         3          1          0  
         3          2          0  
         3          3          0  
         3          4          1  
         3          5          1  
         3          6          1  
end
l, sepby(family)

egen anyfem = max(sex), by(family)  //creates a constant (within varlist) containing the maximum value of exp.
egen allfem = min(sex), by(family)  //creates a constant (within varlist) containing the minimum value of exp.

l, sepby(family)


//http://www.psychstatistics.com/2011/05/30/things-i-love-about-stata-egen-mean/
webuse pig, clear
list in 1/15, clean
egen grandweight=mean(weight)
bys id: egen groupweight=mean(weight)
list in 1/15, clean



/* Tostring / Destring */

use gss, clear

d
tostring marital, gen(m_s)
destring m_s, gen(m_n)
d

edit marital m_s m_n
l marital m_s m_n
l  marital m_s m_n, nola




/* Encode / Decode */

encode region, gen(regN) /*string into numeric*/
l region regN in 1/5
l region regN in 1/5, nola

tab region regN
tab region regN, nola

edit reg*



ta marital
ta marital, nola
codebook marital
decode marital, gen(marS)

l marital marS
l marital marS, nola

edit marital marS

sum mar*  //cannot do math with strings!



/* Missing Values */

tab inc                       /*we get income value labels*/
tab inc, nola                 /*let's get income values*/
tab inc, nola mi              /*and see if we have any missings*/
codebook inc, tab(100)        /*better yet use "codebook"; tab(100) to show all values*/  

          /*this is WRONG!*/   
gen hi_inc=0                  /*let's generate a dummy variable: 1 if high income(>15), 0 otherwise */
replace hi_inc=1 if inc>15   /*it would be 1 for >15 and for missing ! WRONG!*/
                              /*remember: Stata treats missing as a very big value*/
sort hi_inc inc
li hi_inc inc, sepby(hi_inc)
         
	 
	 /* It should be: */
drop hi_inc                   /*We already generated (wrong) hi_inc, we need to drop it before */
                              /*generating a correct one*/
gen hi_inc=.
replace hi_inc=1 if inc>15 & inc<26 /* <26 because 26 means "refused" */
replace hi_inc=0 if inc>0 & inc<16


li hi_inc inc, sepby(hi_inc)

//AND pay attention to patterns with missigness, ie missigness is rarely at random,
//ie vars relate to missingness in other vars,eg:
// summarize age if !missing(income,emp3)
// summarize income if !mi(edu,emp)

//EXERCISE 1

  
/****************/
/* Observations */
/****************/

/*Keep / Drop */

use gss.dta, clear
keep in 1/10
count

use gss.dta, clear
keep if marital==1
ta marital

use gss.dta, clear
drop if marital>1   & marital <.
ta marital

d
drop marital
d

keep age educ
d


/*Sort, Order*/

use gss.dta, clear

l, sepby(marital)
sort marital                  /*sort on marital's values*/
l, sepby(marital)

sort marital inc              /*sort on marital's and income's values*/
l, sepby(marital)

d
edit
order happy                /*happy will be 1st var*/
d
edit

aorder                        /*vars in alphabetic order*/
d
edit


/*_n, _N */  
use gss.dta, clear
gen id= _n
gen total= _N
l

gen previous_id=id[_n-1]
bys marital: gen count_marital_group= _N

l id total previous  count_marital_group marital, sepby(marital)


/*collapse*/

use gss.dta, clear
gen id= _n

bys marital: gen count_marital_group=_n
bys marital: egen count_id=count(id)

l id marital count*, sepby(marital)


bys marital: egen maMeIn=mean(inc)
la var maMeIn "marital mean income"

bys marital: egen maMeEd=mean(edu)
la var maMeEd "marital mean educatoin"
//bys marital: l maMe* 
ta maMeIn marital
ta maMeEd marital

collapse inc educ, by(marital)  /*mean is default*/
l


//and now do counts for marital
use gss.dta, clear

bys marital: egen marCou=count(marital)
l mar* , sepby(marital)

gen id= _n
collapse (count) id, by(marital)
l

//https://stats.idre.ucla.edu/stata/modules/collapsing-data-across-observations/
use https://stats.idre.ucla.edu/stat/stata/modules/kids, clear 
l
collapse age, by(famid) 
l

use https://stats.idre.ucla.edu/stat/stata/modules/kids, clear 
collapse (mean) avgAge=age, by(famid)  //be verbose about calc mean and give it a proper name
l

use https://stats.idre.ucla.edu/stat/stata/modules/kids, clear 
l, sepby(famid)
drop if kidname=="Beth" | age>6
l, sepby(famid)
collapse (count) numkids=birth, by(famid)  
l


//http://campus.lakeforest.edu/lemke/econ330/stata/lab3/index.html
use http://campus.lakeforest.edu/lemke/econ330/stata/lab3/wisconsin98data.dta,clear
desc
sum
bysort msa: sum bamin96 bamin97 bamin98
bysort msa: sum bamax96 bamax98 bamax98

 
collapse (mean) bamin96 bamin97 bamin98, by(msa)
desc
l

use http://campus.lakeforest.edu/lemke/econ330/stata/lab3/wisconsin98data.dta,clear
collapse (min) m98min=mamin98 (max) m98max=mamin98, by(msa)
l



//EXERCISE 2

  
*__________________________________________________________________
/*exercises--solutions*/

/*1*/
//use gss.dta, clear
use http://people.hmdc.harvard.edu/~akozaryn/myweb/gss.dta, clear
gen age2=age^2
tab marital
tab marital, nola
gen divsep=.
replace divsep=1 if marital==3|marital==4
replace divsep=0 if marital<3 |marital==5
use gss.dta, clear
recode marital (1 2 5=0) (3 4=1), gen(divsep)
egen avg_inc=mean(inc)
gen dev_inc=inc-avg_inc
bys region: egen mean_income=mean(inc)
tostring inc, gen(inc_str)
destring inc_str, gen(inc_num)
encode region, gen(region_numeric)

/*2*/
use gss.dta, clear

recode marital (1=1) (2 3 4 5 =0), gen(married)

recode sex (1=0) (2=1), gen(female)

collapse age educ inc happy (sum) married (sum) female, by(region)

