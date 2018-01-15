clear
set more off
version 10

//------------------cps---------------------------

*//On average, men earn higher than women.  Why?
use http://people.hmdc.harvard.edu/~akozaryn/myweb/wages.dta, clear


graph bar (mean) wage, over(female)

*// The relationship between wage and gender varies by level of experience
xtile q_exp=exp, nq(5)
sort exp
l *exp, sepby(q_exp)

graph bar (mean) wage, over(female) over(q_exp)


*//Wages and Marriage
*//Married persons have higher wages. But...

graph bar (mean) wage, over(married) 
graph bar (mean) wage, over(married) over(female)

table female married, c(mean wage) row col f(%7.2f)

//------------------ENDcps---------------------------


//------------------trivariate-----------------------
use http://people.hmdc.harvard.edu/~akozaryn/myweb/wages.dta, clear

sum wage educ exp
corr wage educ exp

reg wage educ
reg wage educ exp


/* These coefficients have two different meanings.  The former is the  */
/* effect of education of a 1 year change in education on the expected  */
/* wage.  The latter is the effect on wage of a 1 year change in  */
/* education holding experience constant. Which is "better"? */

*//CI
di .93+1.96*0.081
di .93-1.96*0.081
//------------------ENDtrivariate--------------------


//------------------truth----------------------------

reg wage exp
predict wage_res, resid
sum wage_res

/* res are uncorr with X (a property of ols from eq B) */
corr wage wage_res exp

/* Now let's also purge the education variable of all correlation with  */
/* experience.  (Purely mechanical, no causal theory implied.) */

reg educ exp
predict educ_res, resid
corr educ educ_res exp

/* These residuals represent the variation in education that is  */
/* totally independent of the variation in experience.  In  */
/* mathematical terms, it is the orthogonal component of  */
/* education relative to experience. */


/* Now let's regress the wage_res on educ_res.  In other words,  */
/* regress wage|exp on educ|exp. */


reg wage_res educ_res, nocons
reg wage exp educ

/* So, a coefficient in multiple regression uses the variation in X that  */
/* is separate and distinct from the variation in the other Xs.  The  */
/* common variation is useless, because the effect on Y may be due  */
/* to one or the other and there is no way to tell which. */

//------------------ENDtruth-------------------------

//------------------other----------------------------
sum wage educ exp
reg wage educ exp, beta



//------------------ENDother----------------------------


clear
set more off
version 10

cap mkdir c:\files
sysdir set PLUS c:\files
findit probtabl
net  from http://www.ats.ucla.edu/stat/stata/ado/teach
net install probtabl

/* again if you do help regress or any other command you will see at the */
/* end of the help file that */
/* stata saves results as macros */
help regress


//----the following is bonus;F-tests are not necessary anymore!-----------------
//----the following is bonus;F-tests are not necessary anymore!-----------------
//----the following is bonus;F-tests are not necessary anymore!-----------------
//----the following is bonus;F-tests are not necessary anymore!-----------------


//----------------------------F-----------------------------------------
use http://people.hmdc.harvard.edu/~akozaryn/myweb/wages.dta, clear

reg wage educ exp

*// testing all coefficients
di "F (by hand)= [(ESS/(k-1))]/[RSS/(n-k)]=" [e(mss)/e(df_m)]/[e(rss)/e(df_r)]
di "F (by hand)= [(R^2/(k-1))]/[1-R^2/(n-k)]=" [e(r2)/e(df_m)]/[(1-e(r2))/e(df_r)]
di "F (by stata)=" e(F)



*// F test vs t-test in bivariate case are the same and they test the same Null
reg wage educ
ftable
ttable
/* so critical t_(532) is 1.96, and critical F_(1,532) is 3.86 */
reg wage educ
/* so we reject null in both cases... */
/* note that both calculated and critical both t and F are the same if */
/* you square them*/
di "square of t: " 1.96^2  " same as F: 3.86" 
di "square of t: " (_b[educ]/_se[educ])^2 " same as F: "  e(F) 



*// R vs UR
g exp_sq=exp^2

/* R */
reg wage educ union
loc ESS_R = e(mss)
loc RSS_R = e(rss)
loc Rsq_R = e(r2)
/* UR */
reg wage educ union exp exp_sq
/* note what happens to ESS, RSS, DOF, Rsq */

loc ESS_U = e(mss)
loc RSS_U = e(rss)
loc Rsq_U = e(r2)

di "[(ESS_U-ESS_R)/m]/[RSS_U/(n-k)] " [(`ESS_U'-`ESS_R')/2]/[`RSS_U'/(534-5)]

di "[(RSS_R-RSS_U)/m]/[RSS_U/(n-k)] " [(`RSS_R'-`RSS_U')/2]/[`RSS_U'/(534-5)]

di "[(Rsq_U-Rsq_R)/m]/[(1-Rsq_U)/(n-k)] " [(`Rsq_U'-`Rsq_R')/2]/[(1-`Rsq_U')/(534-5)]

/* stata check */
 test exp exp_sq

/* Reject the Null: There is sufficient  */
/* evidence to conclude that experience  */
/* (represented here by two variables)  */
/* affects the wage. */

//----------------------------ENDF-----------------------------------------

//----------------------------chow-----------------------------------------
*//chow test 

reg  wage educ  union
loc RSS_R = e(rss)
loc k = e(df_m) + 1
loc N = e(N)

reg  wage educ  union if female==0
loc RSS_1 = e(rss)

reg  wage educ  union if female==1
loc RSS_2 = e(rss)

loc RSS_U = `RSS_1' + `RSS_2'

di [(`RSS_R'-`RSS_U')/`k']/[`RSS_U'/(`N'-2*`k')]

//http://www.stata.com/support/faqs/statistics/computing-chow-statistic/
//http://www.stata.com/support/faqs/statistics/chow-tests/
/* but you can do chow test using F test on interactions ! */
gen fem_educ  = female*educ
gen fem_union  = female*union
reg  wage educ  union female fem_educ  fem_union
test female fem_educ fem_union

//----------------------------ENDchow-----------------------------------------

//----------------------------vce-----------------------------------------

reg  wage educ  exp
di "var(beta_educ) " _se[educ]^2
vce

*// example: Is the effect of educ the same as exp?
di "t= " (_b[educ] - _b[exp])/[sqrt(_se[educ]^2+_se[exp]^2-2*(.00049368))]
/* critical t is just 1.96 */
test educ = exp
/* it was the same thing as t test squared */
di 1.96^2
di 10.65527^2

//----------------------------ENDvce-----------------------------------------


//-----------------bonus: wages-----------------------------------
use http://people.hmdc.harvard.edu/~akozaryn/myweb/wages.dta, clear



reg wage educ
reg wage fem
reg wage educ fem
gen educXfem= educ * fem
l wage educ* fem in 1/25
reg wage educ* fem

tw(scatter wage educ) (lfit wage educ if fem==1, lcol(gold))(lfit wage educ if fem==0)
gr export g1.eps, replace
! okular g1.eps

*// or  can use postgr3

*//TODO add some exercises.... possibly with dummies


*//TODO !! !! have here a LOT of margins and marginsplot examples; also see

/*
http://www.stata.com/manuals13/rmarginsplot.pdf
http://www.timberlake.co.uk/common/pdf/stata-uk-12-ugm/uk12_rising.pdf

*/
