clear
set more off
version 10

cap mkdir c:\files
sysdir set PLUS c:\files
findit modeldiag
net   from http://fmwww.bc.edu/RePEc/bocode/m
net install modeldiag


//----------------------------het----------------------------------------

use https://sites.google.com/site/adamokuliczkozaryn/adv_reg/wages, clear


reg wage educ
predict wagehat
graph twoway (scatter wage educ) (line wagehat educ, sort)
graph twoway (scatter wage educ) (lfit wage educ)
reg  wage educ  exp union nonwhite hispanic  female married south
rvfplot, yline(0)
gr export g1.eps, replace

estat hettest
estat imtest
estat szroeter, rhs
//looks like if we regress on exp only there is less heteroskedascity -- let's check
reg wage exp
estat hettest
rvfplot, yline(0)
graph twoway (scatter wage exp) (lfit wage exp)

*// see the distribution -- often if your dv is non-normal, residuals will be non-normal as well

hist wage
gladder wage
ladder wage

reg wage educ
hettest
predict res, resid
hist res

*//robust se
reg wage educ, robust
hettest

*//transform vars
gen lnwage  = ln(wage)
reg  lnwage  educ
predict lnwhat
predict reLn, resid
hist reLn

graph twoway  (scatter lnwage  educ) (line lnwhat  educ), ytitle("ln(wage)")
hettest

rvfplot, yline(0)



//----------------------------ENDhet-------------------------------------




//---------------------------modeldiag-------------------------------------------

help modeldiag

help ovfplot
// a simple plot showing Y against Y hat -- you want obs to be on the dashed line

sysuse auto, clear

regress mpg weight
ovfplot

gen weightsq = weight^2
regress mpg weight weightsq
ovfplot




help regplot
// regression plot -- scatter + lfit with additional stuff
sysuse auto, clear

//continuous variables only:

regress mpg weight
regplot
gen weightsq = weight^2
regress mpg weight weightsq
regplot

//categorical variable also:

regress mpg weight foreign
regplot, by(foreign)
regplot, sep(foreign)
regress mpg weight weightsq foreign
regplot, by(foreign)

regplot, sep(foreign)

gen fw = foreign * weight
regress mpg weight foreign fw
regplot, by(foreign)
regplot, sep(foreign)

//etc..

//also see http://www.stata-journal.com/sjpdf.html?articlenum=gr0009; and especially an example in section 5


//---------------------------ENDmodeldiag----------------------------------------

//----------------------DROPPED!!!----------------------------
//----------------------DROPPED!!!----------------------------
//----------------------DROPPED!!!----------------------------
//----------------------DROPPED!!!----------------------------

//----------------------------autocor------------------------------------------
clear
set more on
sysuse sp500
des
list date

scatter close date, name(fig1, replace)


reg close date
predict yhat
graph twoway (line yhat date) (scatter close date), name(fig2, replace)



predict e, resid
scatter e date, yline(0) name(fig3, replace)


* TESTS
	* identify "time" variable
	tsset date
	gen t = _n
	tsset t

	estat dwatson
	estat bgodfrey
	estat durbinalt
	
	
//--------------BONUS------------------------------------

	* geary runs test
help runtest
//http://www.polsci.wvu.edu/duval/ps602/Notes/STATA/cocran-orcutt.htm
		/* gen str esign = cond(e>0,"+","-") */
		/* list esign in 1/25 */
		/* tab esign */
		/* gen chg_esign = esign!=esign[_n-1] */
		/* list e esign chg_esign in 1/25 */
		/* gen run = sum(chg_esign) */
		/* list e esign chg_esign run, sepby(run) */
		/* disp 2*(151)*(97)/248+1 */
		/* disp 2*(151)*(97)*(2*151*97-248)/(248^2*247) */
		/* disp (20-119)/sqrt(56) */



* FIXES
	* changing functional form 
		reg close t l.close
		estat durbinalt
		estat bgodfrey
		reg change t
		estat durbinalt
		reg change t
		predict e_chg , resid
		scatter e_chg t, yline(0) name(fig4, replace)

	* cochrane orcutt -- manually do one iteration
		* regress residuals on lagged residuals (AR(1))
		reg e l.e
		* transform data
		gen tclose = close - _b[l1.e] * close[_n-1]
		gen tt  = t  - _b[l1.e] * t[_n-1]
		* GLS -- OLS on transformed datA
		reg tclose tt
		* prais with corc option does several iterations
		prais close t, corc

	* prais winsten - fixes first observation
		prais close t

	* newey-west standard errors
		newey close t, lag(1)
		newey close t, lag(5)
		newey close t, lag(10)

	* many more, take times series class

//----------------------------ENDautocor------------------------------------------
