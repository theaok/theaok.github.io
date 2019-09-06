*______________________________________________________________________
* class 2 dofile
*Adam Okulicz-Kozaryn, Summer 09
*Revised: spring 10
*Revised: spring 16
*----------------------------
  
* notes :  here could be notes

*----------------------------


//---------------------------data mgmt----------------------------------------------
//---------------------------data mgmt----------------------------------------------
//---------------------------data mgmt----------------------------------------------
  
clear         
set matsize 800  /* if you do not know what is matsize, type 'help matsize' of course*/
version 14
set more off
cap log close  //capture is cool--it supresses error :)
set logtype text



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
cd ???/Desktop/data  //adjust path as necessary!!

log using c2_data_formats.txt, replace


  
pwd                           /*let's see where are we*/                            
ls                            /*list what we got*/
dir
type c2_data_formats.do       /* list file */  
mkdir newdir                  /* make dir */
rmdir newdir                  /* rm dir */
  
/*******************/
/* import/export   */
/*******************/


//first make dir to work in
mkdir ???/Desktop/data

/* make sure we are in project dir  */
/* cd c:\files                   /\* we change dir to where are our files*\/                               */
cd ???/Desktop/data  

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


*** fixed format

/* for fixed format use infix*/
/*if you have string variavbles remember about "str"*/
infix v1 10-11  str v7 70-75 using https://sites.google.com/site/adamokuliczkozaryn/datman-1/gss.dat, clear /*here we just infix two variables*/
edit 

//--------SKIP outfix, outfile, outdat, can play at home

*// outfix  for fixed format data
findit outfix2
findit outfix  //sometoiimes nee moire parsimonious search term

net from  http://fmwww.bc.edu/RePEc/bocode/o
net install outfix2
help outfix2
*//lets run the help file:
sysuse auto, clear
outfix2 price weight mpg using auto.out, cols(1 11 21)
*//and open in text editor

*** outfile, outdat you can do it at home

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


//if we have time let's flip the class 
