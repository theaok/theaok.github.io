//TODO: add way more! important and confusing topic!
version 10

//--------------------------measurment------------------------------------------
use https://github.com/theaok/data/raw/main/wages.dta, clear


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


// btw most general is dummies; esp if sth like yrs of educ:
//   neither log or quadratic, but dummy out (next week) esp level completion at  12,16 etc
ta educ

//----gladder
use https://github.com/theaok/data/raw/main/wages.dta, clear
gladder wage //useful command to visualize how variable would be distributed if transformed to log etc

//-----------------BONUS------------------
*//reciprocal
reg wage exp if exp>0
gen recipexp = 1/exp
reg wage recipexp
