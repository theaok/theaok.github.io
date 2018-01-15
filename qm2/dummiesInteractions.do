version 14
//use http://people.hmdc.harvard.edu/~akozaryn/myweb/wages, clear
use https://sites.google.com/site/adamokuliczkozaryn/adv_reg/wages, clear

//again very useful to use lookfor esspecially if big dataset!
lookfor female married


** reg on dummy

reg wage fem
reg wage mar

reg wage fem exp

** ordinal

use http://www.ats.ucla.edu/stat/stata/notes/hsb2,clear
d


reg math female
reg math race

ta race
codebook race
ta race,gen(R)
d R*

reg math R1-R3
reg math R1


** interactions

//use http://people.hmdc.harvard.edu/~akozaryn/myweb/wages, clear
use https://sites.google.com/site/adamokuliczkozaryn/adv_reg/wages, clear

xtile q_exp=exp, nq(5)
sort exp
l *exp, sepby(q_exp)
graph bar (mean) wage, over(female) over(q_exp) //remember this from earlier?
graph bar (mean) wage, over(female) over(mar) 

reg wage fem exp

reg wage fem##c.exp 
//marginsplot: very useful!
margins fem, at(exp=(0(10)60)) 
marginsplot 

** replciation of slide about interaction of dummies
table mar fem,c(mean wage) row col f(%7.2f)

reg wage fem##mar

//marginsplot: very useful!
margins fem,by(mar)
marginsplot

margins mar,by(fem)
marginsplot


*** more about marginsplot
http://www.stata.com/features/overview/marginal-analysis/
http://www.stata.com/meeting/uk12/abstracts/materials/uk12_rising.pdf
http://www.stata.com/manuals13/rmarginsplot.pdf
