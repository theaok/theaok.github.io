* class 1 dofile
*Adam Okulicz-Kozaryn, Summer 09
*Revised: summer 11
* revised spring 15,17; 24!


//!!!! start with putting data online: let's see the link to howto and explain step by step
  

* everything that follows star as a first char in line is a comment
  
clear //first clear memory; everything that follows // is a comment too;  // can follow a command        
version 10
* set more off 


*--------------------------------------------------------------------
*-------------------- PART 1------------------------------------------
*--------------------------------------------------------------------


/************/
/* navigate */
/************/
//always first thing: move stata to your project folder so that you can easily
//and directly access files

mkdir c:\files
cd c:\files                   /* we change dir to where are our files*/                               
pwd                           /*let's see where are we*/                            
ls                            /*list what we got*/
  
/*******************/
/* import/export   */
/*******************/

//use and save are for stata data .dta
// insheet using and outsheet using are for spreadsheet csv data

/* use c:\files\gss.dta, clear  */
/* cd c:\files                   /\* we change dir to where are our files*\/                               */


//using the regular wont work:
//use "https://drive.google.com/file/d/1COEnsNjYUxJHbvny70xuEXikYm-23ulV/view?usp=drive_link",clear
//need this:
use "https://docs.google.com/uc?id=1COEnsNjYUxJHbvny70xuEXikYm-23ulV&export=download", clear 

//IMPORTANT!! typically have to destring data!! they appear as red in spreadsheet once you say edit:
destring *, replace
//note: if destring didnt work, get rid of speciach chars like  %$# in excel

save states.dta, replace
outsheet using states.csv, replace comma nolabel
  
dir                           /*let's see what files we have*/                  ls          
use states.dta, clear
save mystates.dta, replace
                              /* for delimited format use insheet/outsheet*/
insheet using states.csv, clear
outsheet using mydata.csv, replace comma nolabel


/***********/
/* quick des sta */
/***********/

use states.dta,clear
/* use c:\files\states.dta, clear  */

*//describe and summarize are very useful commands to get basic info for your data, if you are not familar with a dataset use them at the beginning
d
sum


edit
browse


list college

list college region in 1/10
sort region college
list college region in 1/10

list college, sepby(region)





*--------------------------------------------------------------------
*-------------------- PART 2------------------------------------------
*--------------------------------------------------------------------


/***********************/
/* /\* Description *\/ */
/***********************/

use "https://docs.google.com/uc?id=1COEnsNjYUxJHbvny70xuEXikYm-23ulV&export=download", clear 


/*Basic Description*/  
cd c:\files                   /*first, always get to the dir with data*/
dir                           /* you may check what files you have in the current directory*/
                            	 /*it saves time typing paths*/

ls
des csat expense              /*"des" is usually the first thing you want to do to see what var you have*/
sum csat expense              /*the second thing is usually summarize to see how var are measured*/
edit csat expense             /*if you want to see actual data use "edit"*/
l csat expense in 1/10        /* a faster way to see data is to use "l", if many obs use "in" option*/

sort csat                     /*we can list states with highest SAT; first sort*/
l csat in -5/l                /* then we list 5 states from the end and corresponding states*/

****exercise 1
/*
what is the level of measurement of ``Mean composite SAT score''
what is the range of ``\% adults college degree''
what are the values of " \% adults HS diploma " across regions ?
*/

/*Tabs and cross-tabs*/
tab state                     /* Use "tab" often*/
tab state region              /* "tab" with two variables produces cross-tabulation*/
tab state region, col row     /*",col" and ",row" give column and row percentages*/
tab area, mi                  /* you should ALWAYS use tab with ",mi" option*/ 
tab region                    /*if variable has labels, you will see...labels*/
tab region, nola              /*to get actual values use ",nola" option*/


****exercise 2
/*
lets explore relationships in auto data using tabs...
load data with sysuse auto, clear
what kind of ``Car type'' do we have and how it is coded ?
what is the relationship between ``Car type'' and ``Repair Record 1978''
*/

  

graph matrix expense percent income csat, half /*have DV at the end so that it goes to y-axis*/
                              /*",half" option makes graph look cleaner*/
*** exercise 3
/*
lets explore relationships in car data using graphs
what are the relationships between price, mpg, and weight ?
focus on  the relationship between ``Mileage (mpg)'' and ``Price''
how the relationship differs for foreign and domestic cars
*/


/* Histogram */  
histogram csat, percent       /*",percent" option gives ... percentages*/
histogram expense, percent by(region)
                             /*",by" is an useful option for histogram*/

*** exercise 4
/*
what is the distribution of prices ?
how it looks for foreign and domestic cars ?
*/

  
/* Bar Chart */

graph bar (mean) csat, over(region) /* basic bar chart with over option*/
graph hbar (mean) csat if region==1, over(state, sort(csat) label(labsize(vsmall)))
                              /*a fancy bar chart easily produced with GUI*/
*** exercise 5
/*
let's graph descriptive statistics using bar chart
how the mean price varies by repair record ?
how the sd of  price varies by repair record ?
how the median weight  varies by repair record and  foreign/domestic variable?
*/
  


*//TODO --next class
/* Twoway */  
/* twoway (scatter csat expense, sort msymbol(smcircle_hollow)) */
/* twoway (scatter csat expense, sort msymbol(smcircle_hollow) mlabel(state)) */
/* twoway (scatter csat expense, sort msymbol(smcircle_hollow)) (lfit csat expense) */


/*********/
/* Extra */
/*********/

/* Saving descriptive statistics */
capture log close             /* before starting a new log always make sure you close the old one*/
                              /* "capture"  executes the following command and skips error if any */
set logtype text              /* you probably want the log file to be in text format*/
log using mylog.txt, replace  /*it will start log in the current directory*/

sort metro                    /*let's find state with highest/lowest metropolitan pop.;sort on metro first*/ 
l metro state region in 1     /*then we can list the first one on the sorted list (the lowest)*/
l metro state region in l     /* and the last one (the highest)*/

sum waste                     /* Let's see what is the mean per capita waste*/
codebook region               /* And how are the regions coded*/
                              /* Then we can list Southern states that have waste per capita higher than the mean*/
l waste state if waste>.98 & region==3

log close                     /* Now we close the log; and we can open mylog.txt with MS Word*/
                              /* use GUI: let's produce bar chart of iqr of csat by regions excluding N. East*/
graph bar (iqr) csat if region!=2, over(region)

                              /* Then we can right click, save as chart1.emf; open MS Word and    insert picture*/





*_________________________________________________________________________
/*exercises*/

/*1*/
use "https://docs.google.com/uc?id=1COEnsNjYUxJHbvny70xuEXikYm-23ulV&export=download", clear 

d
sum
sum csat
sum college
l high  region
sort region high
l region high, sepby(region)

/*2*/
sysuse auto, clear
ta foreign
ta foreign, nola
codebook foreign
ta foreign rep78
ta  rep78 foreign, col
ta  rep78 foreign, row

/*3*/
sysuse auto, clear
*// all vars are contious so i will use scatter plots
gr matrix price mpg weight, half
scatter mpg price
scatter mpg price, by(foreign)


/*4*/
sysuse auto, clear
hist  price
hist  price, by(foreign)

/*5*/
sysuse auto, clear
gr bar (mean) price, over(rep78)
gr bar (sd) price, over(rep78)
gr bar (median) price, over(rep78) over(foreign)
gr hbar (median) price,  over(foreign) over(rep78)
