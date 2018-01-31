TODO: add way more! important and confusing topic!

//--------------------------measurment------------------------------------------
use "https://sites.google.com/site/adamokuliczkozaryn/adv_reg/wages.dta", clear


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



reg wage exp

*quadratic

/* This regression says that the “marginal effect” of an additional  */
/* year of experience on the expected wage is 4 cents, regardless of  */
/* how much experience you already have.  But what if there are   */
/* declining marginal returns to education?  What if the effect of  */
/* experience can actually turn negative beyond some threshold? */


gen exp2 = exp^2
reg wage exp exp2

// .3 (2*(-0.006))
//.30/.012
// at 25 of exp its effect becomes negative

tw(qfit wage exp) //visualize

//why do you think it would flip?

//-----------------BONUS------------------
*//reciprocal
reg wage exp if exp>0
gen recipexp = 1/exp
reg wage recipexp
