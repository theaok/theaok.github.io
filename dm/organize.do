//this is just one dofile for simplicity, but treat each one starting with this as separate file:
//------------------------------begin dofile------------------------------------
//------------------------------begin dofile------------------------------------
//------------------------------begin dofile------------------------------------

/***************************/
/* my usual stata commands */
/***************************/
clear                                  
capture set maxvar 10000
version 10                             
set more off                           


/*********************************/
/* Working Hours in Europe vs US */
/*********************************/

*TODO:
*E.G. many additional vars commented out that can be used in the future  
* double check everything with "assert"

//run the blow as one chunk!
loc d="~/mySuperProject/"        //the root directory, or the parent directory
cap mkdir "`d'"
/**********************************************************/
/* below is a directory structure for a simple project... */
/**********************************************************/
capture mkdir "`d'tex"                 
capture mkdir "`d'out"                 
capture mkdir "`d'out/tmp"
//capture mkdir "`d'res"             
capture mkdir "`d'lit"                 
capture mkdir "`d'dat"
//capture mkdir "`d'dat/base"                
capture mkdir "`d'scr"
//
cd "`d'"
pwd
ls


//------------------------------data_mgmt----------------------------------------

use "`d'dat/gss.dta", clear

//........ commands here to do data_mgmt

save "`d'dat/gss2.dta", clear

  
//------------------------------END data_mgmt------------------------------------



//------------------------------sum_sts----------------------------------------
use gss2.dta

//.......commands here to do des_sts

//------------------------------END sum_sts------------------------------------



//------------------------------regressions----------------------------------------
use gss2.dta

//.......commands here to do regressions
  
//------------------------------END regressions------------------------------------


//------------------------------end of dofile------------------------------------
//------------------------------end of dofile------------------------------------
//------------------------------end of dofile------------------------------------  


//------------------------------begin dofile------------------------------------
//------------------------------begin dofile------------------------------------
//------------------------------begin dofile------------------------------------
  
/*****************************/
/* many dofiles              */
/*****************************/

  
/* this is a masterdofile: the ONE dofile to rule them all */
do `d' data_mgmt.do
do `d' data_anal.do
do `d' produce_res.do

//------------------------------end of dofile------------------------------------
//------------------------------end of dofile------------------------------------
//------------------------------end of dofile------------------------------------  

  
//------------------------------begin dofile------------------------------------
//------------------------------begin dofile------------------------------------
//------------------------------begin dofile------------------------------------

       


/*********************************************************************************************************/
/* this is a complicated project so we have a root directory soemwhere that is common for many projects  */
/*********************************************************************************************************/

loc g="~/root/"  // g is general or generic as opposed to d for project specific dir
cap mkdir "`g'"

capture mkdir "`g'do" //here will be root dofiles
capture mkdir "`g'data" //here will be root data
capture mkdir "`g'data/gss"

cd "`g'"
pwd
ls


/**********************************************************/
/* below is a directory structure for a simple project... */
/**********************************************************/

loc d="~/gss_town_AND_politics/"
cap mkdir "`d'"


capture mkdir "`d'tex"                 
capture mkdir "`d'out"                 
capture mkdir "`d'out/tmp"
//capture mkdir "`d'res"             
capture mkdir "`d'lit"                 
capture mkdir "`d'dat"
//capture mkdir "`d'dat/base"                
capture mkdir "`d'scr"
cd "`d'"


/***************************/
/* my usual stata commands */
/***************************/
clear                                  
set mem 500m                           
capture set maxvar 10000
version 10                             
set more off                           



//------------------------------data_mgmt----------------------------------------
do `g'do/gss_data_mgmt.do //replication principle even though we start with clean data (may comment this out if this take for instance long to run; still have to have this at least as a comment to show how we got to clean data from raw data!!
//------------------------------END data_mgmt------------------------------------
  

//------------------------------sum_sts----------------------------------------
use "`g'data/gss/gss.dta", clear   //grabbing data from root directory, because that data has many children

//........

//------------------------------END sum_sts------------------------------------


//------------------------------regressions----------------------------------------

//........

//------------------------------END regressions------------------------------------


//------------------------------end of dofile------------------------------------
//------------------------------end of dofile------------------------------------
//------------------------------end of dofile------------------------------------  

  
//------------------------------begin dofile------------------------------------
//------------------------------begin dofile------------------------------------
//------------------------------begin dofile------------------------------------



/****************************/
/* /\********************\/ */
/* /\* naming, labeling *\/ */
/* /\********************\/ */
/****************************/   


loc d="~/mySuperProjectLabel/"        
/**********************************************************/
/* below is a directory structure for a simple project... */
/**********************************************************/
capture mkdir "`d'tex"                 
capture mkdir "`d'out"                 
capture mkdir "`d'out/tmp"
//capture mkdir "`d'res"             
capture mkdir "`d'lit"                 
capture mkdir "`d'dat"
//capture mkdir "`d'dat/base"                
capture mkdir "`d'scr"

cd "`d'"


/***************************/
/* my usual stata commands */
/***************************/
clear                                  
capture set maxvar 10000
version 10                             
set more off                           
cd "`d'"


/***************************************************/
/* workaround for installing user-written commands */
/***************************************************/ 

sysdir  
help sysdir

cap mkdir ~/junk/
adopath + ~/junk/
adopath - ~/junk/

/* this one is more "invasive", remember to set it back...   */
//sysdir set PLUS ~/Desktop/junk/  
//sysdir set PLUS ~/ado/plus

  



/********************************************/
/* variable names,  labels, and value labels */
/********************************************/
insheet using https://sites.google.com/site/adamokuliczkozaryn/datman-1/gss.csv,clear
d

/* there are many ways to label things... */
help label

/* let's focus on variable v4 */
d v4
sum v4
codebook v4, tab(100)
ta v4, mi
ta v4, nola mi


/* first we can rename it */
ren v4 gender

/* then let's put variable label on it */

la var gender "respondent's gender"
d

/* and now we can pu value labels [in 2 steps]*/
/* first, define value label */

la def genderL 1"male"  2 "female"

la val gender genderL

ta gender
ta gener, nola
codebook gender, ta(100)

//----
  
/* but wait, remember simplicity rule ? what a variable gender means? we want to have a meaningful */
/* variable, say female that would equal 1 for females and 0 for males  */

/* we will use a very handy command recode */

help recode
  
recode gender (1=0) (2=1), gen(female)

/* remember about accuracy! -- double check everything */

ta female gender, mi

/* we do not have to do this because variable female is self explanatory, but just for exercise */
la var female "female"
la def femaleL 1 "female" 0 "male"
la val female femaleL
codebook female, ta(100)

/* we can actually put value lables in just one step with recode */

drop female  
recode gender (1=0 "male") (2=1 "female"), gen(female)

/*********************/
/* more about labels */
/*********************/

/* we already have nicely labeled data, let's see what else we can do */   

use https://sites.google.com/site/adamokuliczkozaryn/datman-1/gss.dta, clear
 
d
sum
codebook, tab(100)

/* looks much better, right? */

/* but i do not like codebook command, much easier/faster is tab, but it does not show values-- i need */
/* to do it twice */ 

ta happy
ta happy, nola mi 
  
/* numlabel automatically adds numeric values to value labels , useful ! */
  
numlabel happy, add

ta happy

/* this looks great ! */

  
/*You can search labels, useful !*/  
lookfor income                
sum `r(varlist)'


//-----------------------------------SKIP------------------------------

/*********************/
/* labelling  using 'note' */
/*********************/
insheet using https://sites.google.com/site/adamokuliczkozaryn/datman-1/gss.csv,clear 
d
sum

help note
note: this is a subset of gss that  is unlabeled
note: get codebook from adam !
notes
note v2: this looks like age 
note v2: email gss and ask about teenagers 
notes

label data "gss subset for data mgmt class"
d


//------------------------------end of dofile------------------------------------
//------------------------------end of dofile------------------------------------
//------------------------------end of dofile------------------------------------  



//------------------exercises---------------------- 


//--1--
/* get csv data
insheet using https://sites.google.com/site/adamokuliczkozaryn/datman-1/gss.csv,clear  
and generate a new variable "happy" that will be based on var
v6 which is coded as
1. very happy
2. pretty happy
3. not too happy
the new var 'happy' should be coded 1 if person is either 'very' or 
'pretty' happy and 0 otherwhise


//--2--

get 1972 gss data
http://gss.norc.org/documents/stata/1972_stata.zip
and find all status variables and save them as csv

*/






















//------------------exercise solutions---------------------- 


/*****/
/* 1 */
/*****/
insheet using https://sites.google.com/site/adamokuliczkozaryn/datman-1/gss.csv,clear 
recode v6 (1/2=1 "very/pretty happy") (3=0 "miserable"), gen(happy)
la var happy "general happiness"

/* double check */
ta happy v6, mi


/*****/
/* 2 */
/*****/

copy http://gss.norc.org/documents/stata/1972_stata.zip 1972_stata.zip
unzipfile  1972_stata.zip
use GSS1972.DTA,clear


/* get the status variables */
lookfor status
lookfor prestige
lookfor wealth
lookfor income
lookfor education

/* summarize them to see how many missing obs */
sum ....

/* keep the ones you need */
keep ...

outsheet using mygss.csv, comma replace
