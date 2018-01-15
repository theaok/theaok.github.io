clear
set more off
version 10

//----------------------------outlier---------------------------------------------------
//(unrelated to slides; to make a point that des stats is always first and important!)
webuse states, clear
d
reg div mar
reg div mar if div<100
tw(scatter div mar, mlabel(state))
tw(scatter div mar, mlabel(state))(lfit div mar)


//----------------------------basic calculations-----------------------------------------

//these are data we discuss in slides at the beginning
clear
input Y  X   
1 17
3 13
5 8
7 10
9 2
end

****now calc coef by hand

* first items in the table
sum Y //!!this and following chunks run as one; otherwhise stata may forget from line to line
gen y=Y-`r(mean)'
gen y2=y^2
sum X
gen x=X-`r(mean)'
gen x2=x^2
gen xy=x*y
l

* then sums, and get betas
sum xy
loc sum_xy= `r(sum)' //saving result
sum x2 
loc sum_x2= `r(sum)'
di `sum_xy'/`sum_x2' //beta hat2
sum Y
loc mean_Y=`r(mean)'
sum X
loc mean_X=`r(mean)'
di `mean_Y'-(`sum_xy'/`sum_x2')*`mean_X' //beta hat1

* now let stata calculate herself and compare
reg Y X


**** and use stata to calc yhat and resid

predict yhat
predict r, resid
gen r2=r^2
l Y X yhat r r2

tw(scatter Y X)(lfit Y X), title("reg fit") subtitle("Y vs X and prediction: yhat (fitted line)") 



**** se of slope
sum r2
loc sum_r2= `r(sum)'
sum x2
loc sum_x2= `r(sum)'
di (sqrt(`sum_r2'/(5-2))) / sqrt(`sum_x2')

* check with stata

reg Y X //yay!


**** hypothesis test

reg Y X
di _b[X]/_se[X] //conclusion?



**** partitioning variance in Y

* TSS
sum y2
di `r(sum)' 

* RSS
sum r2
di `r(sum)' 

* ESS
di 40-5.4 //we just calculated these numbers above

* Rsq
di (40-5.4)/40 

* check with stata
reg Y X   //there us ESS, RSS, TSS, Rsq at the top

sum Y  
scatter Y X, yline(`r(mean)') ti(TSS) name(graph1, replace)
tw(scatter Y X)(lfit Y X), title("RSS") subtitle("Y vs X and linear prediction: yhat") 

* se of E(Y|X)
tw(scatter Y X)(lfitci Y X, fcolor(none)), title("reliability of predict val") subtitle("Y vs X and linear prediction with CIs: yhat")


//------------- exercise 1


//--------------------------wages--------------------------------------------

use http://people.hmdc.harvard.edu/~akozaryn/myweb/wages, clear
corr wage educ
loc rho `r(rho)'
sum wage
loc wage_sd = r(sd)
sum educ
loc educ_sd = r(sd)
di "slope would be: " `rho'  * (`wage_sd'/`educ_sd')
di .38 * 5.1 / 2.6 //same thing

reg wage educ //and check


//------------------exercise2


//----------------BONUS----------------------
/* some data analysis example using gss data: */
/* http://www.norc.org/GSS+Website/ */
/* http://www.norc.org/GSS+Website/Download/STATA+v8.0+Format/ */

/* for more data see first class slides... */

copy http://gss.norc.org/documents/stata/2010_stata.zip gss10.zip
unzipfile gss10.zip
use GSS2010, clear

/* for criminologists */
lookfor crim

/* for finance people */
lookfor money
lookfor income
lookfor stock
/* for political science... */
lookfor vote
lookfor govern
lookfor sec
lookfor countr
lookfor party
lookfor tax

//----- ok, let's say i want to study welfare and political views...

//---- do some des stats
codebook partyid
replace partyid =. if partyid == 7
lookfor help
codebook grnsol helpblk helpnot helpsick
codebook sex
corr grnsol helpblk helpnot helpsick partyid

// i want to focus on helpnot and partyid
ta   partyid helpnot
ta   partyid helpnot, col
ta   partyid helpnot, row

tw(scatter helpnot partyid, ms(Oh)jitter(5))(lfit helpnot partyid),by(sex)
tw(scatter helpnot partyid, ms(Oh)jitter(5))(lfit helpnot partyid)


//--- and run a regression
reg helpnot partyid

reg helpnot partyid if sex==1
reg helpnot partyid if sex==2


//----------------ENDBONUS----------------------


//----------------------- exercise answers

//---1

*//by hand
di  "t-stat is beta/beta's se: " 2.04/.37
*// note: 1.96 is approximation; from gujarati table for 60 df t=2.00
di "95 % CI lower"  2.04-1.96*.37
di "95 % CI upper"  2.04+1.96*.37

* if weight goes up by 1 unit, price goes up by 2 units (we do not
*know units...)

*it is significant at .05 lev of significance

// check with stata
sysuse auto, clear
reg price weight


//---2


* multiply by c

clear
input Y  X   
1 17
3 13
5 8
7 10
9 2
end
reg Y X
replace X=X*12
//we would expect slope to be
di _b[X]/12
reg Y X

clear
input Y  X   
1 17
3 13
5 8
7 10
9 2
end
reg Y X
replace Y=Y*100
//we would expect slope to be
di _b[X]*100
reg Y X


* standarize 
clear
input Y  X   
1 17
3 13
5 8
7 10
9 2
end
reg Y X

sum Y
replace Y = (Y - `r(mean)')/`r(sd)' 
sum Y

sum X
replace X = (X - `r(mean)')/`r(sd)' 
sum X

// now the beta should be 
corr Y X

reg Y X

