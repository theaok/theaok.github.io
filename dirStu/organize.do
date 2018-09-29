/*********************************/
/* Working Hours in Europe vs US */
/*********************************/

*TODO:
*E.G. many additional vars commented out that can be used in the future  
* double check everything with "assert"


/**********************************************************/
/* below is a directory structure for a simple project... */
/**********************************************************/
loc d="~/desk/papers/gss_town_AND_politics/"        //the root directory, or the parent directory
capture mkdir "`d'tex"                 
capture mkdir "`d'out"                 
capture mkdir "`d'out/tmp"
//capture mkdir "`d'res"             
capture mkdir "`d'lit"                 
capture mkdir "`d'dat"
//capture mkdir "`d'dat/base"                
capture mkdir "`d'scr"

cd "`d'"



//------------------------------data_mgmt----------------------------------------

use "dat/gss.dta", clear

........

save "dat/gss2.dta", clear

  
//------------------------------END data_mgmt------------------------------------



//------------------------------sum_sts----------------------------------------
  
//------------------------------END sum_sts------------------------------------



//------------------------------regressions----------------------------------------
  
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

  
/* this is a masterdofile */
do  data_mgmt.do
do  data_anal.do
do  produce_res.do

//------------------------------end of dofile------------------------------------
//------------------------------end of dofile------------------------------------
//------------------------------end of dofile------------------------------------  

  
  
/****************************/
/* /\********************\/ */
/* /\* naming, labeling *\/ */
/* /\********************\/ */
/****************************/   



/**********************************************************/
/* below is a directory structure for a simple project... */
/**********************************************************/
loc d="~/desk/papers/gss_town_AND_politics/"        
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

  

/********************************************/
/* variable names,  labels, and value labels */
/********************************************/
insheet using https://sites.google.com/site/adamokuliczkozaryn/datman-1/gss.csv
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

la def gender 1"male"  2 "female"

la val gender gender



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
la def female 1 "female" 0 "male"
la val female female
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
