//---------------------elements of research design----------

//before after OR treatment v control 

//say Y is blood pressure
clear
input float(id year T Y X) 
1 2000 0  120 5
1 2001 1  80 3
2 2000 0  110 7
2 2001 1  75 4
3 2000 0  90 5
3 2001 1  70  6
4 2000 0 170 2
4 2001 1 110 6
end

l

gr box Y, over(T)

mean Y, over(T)

reg Y T


//an example
//https://www.statalist.org/forums/forum/general-stata-discussion/general/1401656-before-and-after-treament


//medical trial/blood pressure examples

sysuse bplong, clear
graph box bp, over(when) over(sex)
	     ytitle("Systolic blood pressure")
	     title("Response to Treatment, by Sex")
	     subtitle("(120 Preoperative Patients)" " ")
	     note("Source:  Fictional Drug Trial, StataCorp, 2003")

	     
graph box bp, over(when) over(agegrp)
	     
	     
use http://www.stata-press.com/data/r13/bpwide, clear //wide format
graph box bp_before bp_after, over(sex)	     


/*
//btw before after is similar to ttest for 2 group difference, just over time
//say have 2 groups 
clear
input x1 x2 //https://statistics.laerd.com/stata-tutorials/paired-t-test-using-stata.php 
10.6 10.5
10.9 11.1
10.2 10.3
11.6 11.8
11.8 11.9
9.7 9.8
10.8 11
11.8 12 
end
l

ttest x1=x2

gen id=_n
reshape long x, i(id)j(T)
l
recode T (1=0) (2=1),gen(TT)
ta T TT, mi
reg x TT //stat sig different :(

*/

//-----------------------ivreg------------------------------



//stata.com/manuals/rivregress.pdf

use http://www.stata-press.com/data/r13/hsng,clear
d rent hsngval pcturban
reg rent hsngval pcturban
//but there is stuff that easily affects both rent and hsngval, so
//corr(hsngval, u) !=0 //endogeneity!

//so need to instrument hsngval with vars that predict it but are uncorrelated with u (and dont predict directly DV because then they should be in the model right away)

ivregress 2sls rent pcturban (hsngval = faminc i.region)
//exogenous vars in model automatically included as instruments


ivregress liml rent pcturban (hsngval = faminc i.region) //2sls is traditional; but recent papers suggest liml as having less bias





//---testing (ivregress postestimation)


use http://www.stata-press.com/data/r12/hsng,clear
ivregress 2sls rent pcturban (hsngval = faminc i.region)
//we want to test whether the instrumented var can be treated as exogenous
//the null is that the instrumented var can be treated as exogenous
estat endogenous hsngval //Test whether hsngval can be treated as exogenous
//so we must treat it as endogenous

//refit it using robust se (intragroup corr, heteroskedascity)
ivregress 2sls rent pcturban (hsngval = faminc i.region), vce(robust)
estat endogenous
//the 2 test statistics give conflicting answers, better use 2sls (even if instrumented var is exogenous, 2sls is still consistent)


//2 ways to test for overindentification
xi: ivreg rent pcturban (hsngval = faminc i.region)
overid //want to fail to reject this: H0: all IVs are uncorr with error term; all IVs are exogenous 

ivregress 2sls rent pcturban (hsngval = faminc i.region)
estat overid
//it means that either instruments are invalid or structural model is misspecified
//and both tests assume i.i.d. errors


//refitting with robust std err fixes the problem
ivregress 2sls rent pcturban (hsngval = faminc i.region), vce(robust)
estat overid


//---more testing


//HAUSMAN endogeneity/simultaneity: ols vs iv
//basically if ols and 2sls estimates are quite different we need 2sls; if they are similar we can stick with ols

use http://www.stata-press.com/data/r12/hsng, clear
ivreg rent pcturban (hsngval= faminc)
estimates store ivreg 

regress rent pcturban hsngval
estimates store ols
hausman ivreg ols, constant sigmamore
//The Hausman test clearly indicates that OLS is an inconsistent estimator for this equation. 


//another way to test for endogeneity: (also see Gujarati p 704 ex  19.5)
// (../materials/IV_Estimator.doc)

/*reduced form*/
regress hsngval faminc pcturban
predict house_res, residual
regress rent pcturban hsngval  house_res
// If the coefficient on residual from reduced form  is statistically different from zero, we conclude that instrument is endogenous

test house_res
//we go with 2sls -- the iv is a consistent estimator for this  model



//---another example
//https://www.youtube.com/watch?v=lbnswRJ1qV0
webuse educwages, clear
d

ivregress 2sls wages union (educ = med fed)

estat endog //reject null: ols aint good; need iv 

estat firststage //find weak instruments: rsq reflect corr of instruments with endog; partial: after partialing out union; F-stat much larger than crit val in table below: reject null that instruments are weak

estat overid //null is IV valid and model correctly specified


//---more iv examples



//https://www.youtube.com/watch?v=PYx_KOUUpEA



//another example: http://www.principlesofeconometrics.com/poe4/poe4do_files/chap10.do
use http://www.stata.com/data/jwooldridge/eacsap/mroz
d

//ols
reg wage educ exper
est sto ols

//2SLS is essentially derived by replacing xi in the structural equation with its fitted values from the 1st stage, then performing OLS (taking into account that xi hat is a statistic when estimating variance)


//iv in 2 steps
//1st stage
reg educ exper  motheduc
predict educhat
//2nd stage
reg wage educhat exper

//iv in 1 step
ivregress 2sls wage (educ=motheduc) exper 
ivregress 2sls wage (educ=motheduc) exper, small
ivregress 2sls wage (educ=motheduc) exper, vce(robust) small // iv est with robust se



//from Wolldridge http://fmwww.bc.edu/gstat/examples/wooldridge/wooldridge15.html

//Example 15.1: Estimating the Return to Education for Married Women

//use http://fmwww.bc.edu/ec-p/data/wooldridge/MROZ,clear
reg lwage educ
est sto ols

//and we want to instrument educ with fathereduc--remember that we
//need to check that cov(educ,fathereduc)!=0 and cov(fathereduc,u)=0
reg educ fatheduc

ivregress 2sls lwage  (educ = fatheduc)
est sto iv

est tab ols iv
//hence, the ols overestimated effect of educ: it's what we expect:
//lovb: ability; cov(ability,educ)= +;cov(ability,lwage)= +; 
//hence, ols est on educ is biased upwards, more positive than it should be 




/*
//Example 15.2: Estimating the Return to Education for Men

use http://fmwww.bc.edu/ec-p/data/wooldridge/WAGE2, clear
reg lwage educ

reg educ sibs // every sibling would poduce .23 of a year less educ

ivregress 2sls lwage (educ = sibs)



//Example 15.3: Estimating the Effect of Smoking on Birth Weight

use http://fmwww.bc.edu/ec-p/data/wooldridge/BWGHT, clear
reg lbwght packs
//but packs can be correlated with other health factors influencing birth weight...
//so we instrument packs with cigprice; BUT cannot do that beacuse cigprice is not corr with packs (and the sign is wrong...)
ivreg lbwght (packs = cigprice ), first



//Example 15.4: Using College Proximity as an IV for Education

use http://fmwww.bc.edu/ec-p/data/wooldridge/CARD, clear
 ///

*/

use http://www.stata.com/data/jwooldridge/eacsap/mroz,clear


//Example 15.5: Return to Education for Working Women

//use http://fmwww.bc.edu/ec-p/data/wooldridge/MROZ, clear
reg lwage educ exper expersq
//reduced form:
reg educ exper expersq motheduc fatheduc //instruments often sth in the past
//test identification that at least one instr is not zero; can just see individual sig
test motheduc fatheduc 
ivreg lwage (educ = motheduc fatheduc) exper expersq


//Example 15.7: Return to Education for Working Women

//use http://fmwww.bc.edu/ec-p/data/wooldridge/MROZ,clear
//there may be endogeneity in:
reg lwage educ exper expersq
//test for that as follows:
//est reduced form
reg educ exper expersq motheduc fatheduc if lwage<. 
//get residuals
predict  uhat1, res
//and include them in the original equation
reg lwage educ exper expersq uhat1
//given uhat1 estimate, there is evidence of moderate positive corr between residual from the original equation and from the reduced form; and iv est is only almost half of the iv estimate 
//so may repotr both ols and iv
//also note that the last estimate(with resid) is the same as iv:
ivreg lwage (educ = motheduc fatheduc) exper expersq


//testing overidentyfying restriction
//ssc install overid, replace
overid
//want to fail to reject this: H0: all IVs are uncorr with error term; all IVs are exogenous 


/*
//----------------------------------------------------------------------------

//inflation and  earnings (../materials/endogeneity.pdf)

//generate some fake earnings data
use http://dss.princeton.edu/training/tsdata.dta, clear
gen date1=substr(date,1,7)
gen datevar=quarterly(date1,"yq")
format datevar %tq
tsset datevar
sort datevar
gen cpi_ch=(cpi-cpi[_n-1])/cpi[_n-1]*100
drop cpi
tssmooth ma cpi=cpi_ch, window(2 1 2)
la var cpi "annual percent change in retail prices"
gen avea0 = cpi + invnorm(uniform()) 
tssmooth ma avea=avea0, window(2 1 2)
la var avea "avg earnings"

tw(line cpi datevar)(line avea datevar)

// so prices and wages move together...

// it is reasonable to argue that wages would affect inflation...
reg cpi avea

//but inflation would also affect wages...
reg  avea cpi

//the problem is that the two variables are interdependent adn so they are endogenous

//so need to find an instrument, correlated with RHS endogenous var, but uncorrelated with error term

//as usual, finding a good instrument is a  problem--many things are interrelated

//a possible solution wit ts data is to use lags of the endogenous variables

//using 1 year lag as instrument
ivreg cpi (avea=L4.avea)
// 2 year lag as instrument
ivreg cpi (avea=L8.avea)

//so which one to use? if big sample, use them all (more efficient est(smaller se))

ivregress 2sls cpi (avea= L4.avea L8.avea)

//same thing by hand:
qui reg avea L4.avea L8.avea
predict avea_hat
reg cpi avea_hat

*/


//more examples:
//https://stats.oarc.ucla.edu/stata/examples/methods-matter/chapter10/


//---------------------------------------------------------
//system of equations (from stata manual)

/*
webuse klein
d consump wagepriv wagegovt govt capital1
reg consump wagepriv wagegovt
reg wagepriv consump govt capital1
//hence  consump and wagepriv will be endogenous variables

reg3 (consump wagepriv wagegovt) (wagepriv consump govt capital1)
reg3  (consump wagepriv wagegovt) (wagepriv consump govt capital1), 2sls



use http://www.stata-press.com/data/r12/supDem
regress quantity price pcompete income
regress quantity price praw
ivregress 2sls quantity (price = praw) pcompete income
ivregress 2sls quantity (price = pcompete income) praw
global demand "(qDemand: quantity price pcompete income)"
global supply "(qSupply: quantity price praw)"
reg3 $demand $supply, endog(price)
reg3 $demand $supply, endog(price) 2sls

/*
Let's summarize the results. With OLS, we got obviously biased estimates of the parameters. No
amount of data would have improved the OLS estimates--they are inconsistent in the face of the
violated OLS assumptions. With 2SLS, we obtained consistent estimates of the parameters, and these
would have improved with more data. With 3SLS, we obtained consistent estimates of the parameters
that are more efficient than those obtained by 2SLS.
*/

*/


//---------------------------DID------------------------

//https://www.stata.com/stata17/difference-in-differences-DID-DDD/

//https://libguides.princeton.edu/stata-did //nice TODO!! below step by step
//https://www.princeton.edu/~otorres/Panel101.pdf same here
//https://www.stata.com/meeting/germany22/slides/Germany22_Luedicke.pdf see too

and little bit on panel too here
