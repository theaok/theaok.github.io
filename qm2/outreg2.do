//---------------------outreg2-------------------------

net install outreg2, from(http://fmwww.bc.edu/RePEc/bocode/o) 

sysuse auto, clear


/* *run some regression */
reg mpg weight
/* *and then export to excel, note eform option that will exponentiate betas; ct will give it column title A1 */
outreg2 using reg1.xls, onecol bdec(2) st(coef) excel replace ct(A1) lab
/* *then i run some otjer specification */
reg mpg weight length
/* *and outreg2 again but i append instead of replace */
outreg2 using reg1.xls, onecol bdec(2) st(coef) excel append ct(A2) lab  
reg mpg weight length foreign
/* *and outreg2 again but i append instead of replace */
outreg2 using reg1.xls, onecol bdec(2) st(coef) excel append ct(A3) lab  


//SKIP FOR NOW THE FOLLWING


//-----------------logout------------------------------------------------

net from http://fmwww.bc.edu/RePEc/bocode/l
net install logout
sysuse auto, clear

//excell
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

latex:  
http://www.ats.ucla.edu/stat/stata/latex/default.htm


more about estout
http://repec.org/bocode/e/estout/
  

//-----------------------------------------scrap--------------------------------
/*********/
/* todo: */
/*********/
  svymatrix
  latab
  etc etc

//---------------------ENDexp---------------------------
//---------------------ENDexp---------------------------
//---------------------ENDexp---------------------------
