*______________________________________________________________________
* class 2 dofile
*Adam Okulicz-Kozaryn, Summer 09
*Revised: spring 10
*Revised: spring 16
*revised fa18 [merged with c3]
*----------------------------
  
* notes :  here could be notes

*----------------------------


version 15
set more off
cap log close  //capture is cool--it supresses error :)
set logtype text
log using mylog.txt, replace


/*
COVER RIGHT AWAY IMPORTANT TOPIC OF INSTALLING STATA COMMANDS (CODE MUST BE PORTABLE)
just alwasys have soem form of this if you install any user written command!
and always install them straight, not through findit but through net install,
ssc install or other
*/
sysdir  
help sysdir
mkdir ~/Desktop/junk/
adopath + ~/Desktop/junk/
adopath - ~/Desktop/junk/
/* this one is more "invasive", remember to set it back...   */
//sysdir set PLUS ~/Desktop/junk/  
//sysdir set PLUS ~/ado/plus

findit outreg2
net install outreg2,from(http://repec.org/bocode/o/)

*--------------------------------------------------------------------
*--------------------------------------------------------------------
 
 
/************/
/* navigate */
/************/
/* cd c:\files                   /\* we change dir to where are our files*\/                               */
pwd //print working directory
cd ~/Desktop/  //adjust path as necessary!! ~ stands for home folder on linux
mkdir directedStudy //first make dir to work in

cd directedStudy
pwd

log using readAndManipualte.txt, replace

  
pwd                           /*let's see where are we*/                            
ls                            /*list what we got*/
dir
//type readAndManipulate.do       /* list file */  
mkdir newdir                  /* make dir */
rmdir newdir                  /* rm dir */
  
/*******************/
/* import/export   */
/*******************/



/* make sure we are in project dir  */
/* cd c:\files                   /\* we change dir to where are our files*\/                               */
pwd
cd ~/Desktop/directedStudy 
pwd

//note stata can download files
copy https://sites.google.com/site/adamokuliczkozaryn/datman-1/gss.dta ./
  
dir                           /*let's see what files we have*/                            
use gss.dta, clear
save mygss.dta, replace
                              /* for delimited format use insheet/outsheet*/
insheet using gss.csv, clear
outsheet using mydata.csv, replace comma nolabel

//see also gui under data!

/*you can load data from url*/
  
use https://sites.google.com/site/adamokuliczkozaryn/datman-1/gss.dta, clear    
insheet using https://sites.google.com/site/adamokuliczkozaryn/datman-1/gss.csv, clear

//and you can load from excel--use gui to generate code: file-import-excel


//SKIP at our lab (for library only):
/***************************************************/
/* workaround for installing user-written commands */
/***************************************************/ 

sysdir  
help sysdir

mkdir ~/Desktop/junk/
adopath + ~/Desktop/junk/
adopath - ~/Desktop/junk/

/* this one is more "invasive", remember to set it back...   */
//sysdir set PLUS ~/Desktop/junk/  
//sysdir set PLUS ~/ado/plus



/***********/
/* looking */
/***********/

use gss.dta,clear
/* use c:\files\gss.dta, clear  */
count
// a very handy tool to subset your data, use it for ps1 if you data is too big
sample 25
count
edit
browse
edit marital

//note: there is also that new thing spss-like variable manager...

list, sepby(region)

list marital in 1/10

set more off

list, sepby(region)

d
sum

clear all
exit



////////////////////////////////// manipulate /////////////////////////////////



//that's a fancy macro, we'll cover it when we do programing
//run the following as one chunk (local macros die after one run)
local worDir "PUT YOUR WORKING DIR ON DESKTOP DESIRED PATH AND NAME HERE" //eg "~/Desktop/data"
cap mkdir `worDir'
cd  `worDir'

//make things simpler--get a subsample :)
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

