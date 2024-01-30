*//class c2 
//revised sp24
set more off
version 10


//------------------guessing------------------------------

clear 
input  y x
2  1  
5  2  
6  3  
end
d
l

reg y x

//graphs from the slides:

gen first_guess=x+2
tw(scatter y x)(line first_guess x)
gen second_guess=0 +2*x
tw(scatter y x)(line second_guess x)
gen ols=0.33 +2*x
tw(scatter y x)(line ols x)


-----------------SKIP THIS CHUNK TO SECOND CLASS BELOW-------------------------------
//kind of doing it by hand in stata:

*//let's look at the residuals
g r_first_guess=(y-first_guess)^2
g r_second_guess=(y-second_guess)^2
g r_ols=(y-ols)^2
sum r*
egen s_r_first_guess=sum(r_first_guess)
egen s_r_second_guess=sum(r_second_guess)
egen s_r_ols=sum(r_ols)
l s_* in 3



*//LATER/MAYBE and so on... calsulate resid... and calculate reg by hand in stata... e.g. slide 34 solving the problem can be done in stata by hand

--------------------SECOND CLASS STARTS HERE----------------------

clear
set more off
version 10

//----------------------------outlier-----------------------------------------
webuse states, clear
d
reg div mar
reg div mar if div<100
tw(scatter div mar, mlabel(state))
tw(scatter div mar, mlabel(state))(lfit div mar)




//----------------------------exercise 0-----------------------------------------
clear
input Y  X   
1 17
3 13
5 8
7 10
9 2
end


reg Y X

di invttail(3,.025) //invttail(df,p) = t
di ttail(3,3.18) // ttail(df,t) = p


predict yhat
predict r, resid
l


sum Y
scatter Y X, yline(`r(mean)') ti(TSS) name(graph1, replace)

tw(scatter Y X)(lfit Y X), title("Lecture's Graph") subtitle("Y vs X and linear prediction: yhat") name(graph2, replace)
tw(scatter Y X)(lfitci Y X), title("Lecture's Graph") subtitle("Y vs X and linear prediction with CIs: yhat") name(graph3, replace)


//------------- exercise 1


//--------------------------wages--------------------------------------------
use "https://docs.google.com/uc?id=1aEo3U7f79NkK9oBWFuMhCQAaNGf1mJbk&export=download", clear 

corr wage educ
loc rho `r(rho)'
sum wage
loc wage_sd = r(sd)
sum educ
loc educ_sd = r(sd)

di "slope would be: " `rho'  * (`wage_sd'/`educ_sd')

reg wage educ

//--------------------------ENDwages--------------------------------------------

//------------------exercise2



//--------------------------measurment------------------------------------------

use "https://docs.google.com/uc?id=1aEo3U7f79NkK9oBWFuMhCQAaNGf1mJbk&export=download", clear 


*// lin-lin
regress wage educ

*//log-lin
gen lnwage = ln(wage)
reg lnwage educ

*// lin-log
gen lneduc = ln(educ)
regress wage lneduc


*// log-log
reg lnwage lneduc

*//reciprocal
reg wage exp if exp>0
gen recipexp = 1/exp
reg wage recipexp

reg wage exp

*quadratic

/* This regression says that the “marginal effect” of an additional  */
/* year of experience on the expected wage is 4 cents, regardless of  */
/* how much experience you already have.  But what if there are   */
/* declining marginal returns to education?  What if the effect of  */
/* experience can actually turn negative beyond some threshold? */


gen exp2 = exp^2
reg wage exp exp2

*// delta y/delta = .3+2*(-0.006)X
*// at .30/.012 of exp its effect becomes negative



//----------------BONUS----------------------
/* some data analysis example using gss data: */
/* http://www.norc.org/GSS+Website/ */
/* http://www.norc.org/GSS+Website/Download/STATA+v8.0+Format/ */

/* for more data see first class slides... */

copy http://publicdata.norc.org:41000/gss/documents//OTHR/2010_stata.zip gss10.zip
unzipfile gss10.zip
use 2010, clear

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

*// check with stata
sysuse auto, clear
reg price weight


//---2
clear
input Y  X   
1 17
3 13
5 8
7 10
9 2
end

reg Y X
replace X = X + 3
l
*//we would expect intercept to be:
di _b[_cons] - _b[X] * 3
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
replace Y = Y - 3
l

*//we would expect intercept to be:
di _b[_cons] -  3
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

sum Y
replace Y = (Y - `r(mean)')/`r(sd)' 
sum Y

sum X
replace X = (X - `r(mean)')/`r(sd)' 
sum X

*// now the beta should be 
corr Y X

reg Y X

