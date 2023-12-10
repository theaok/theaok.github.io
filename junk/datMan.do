//xstata-mp //need mp
//takes liek 10min; can also make selection on import; can also try sas
cd /home/aok/data/pisa/18
import spss using "/home/aok/data/pisa/18/STU/CY07_MSU_STU_QQQ.sav"
compress
save pisa18,replace

use pisa18, clear
lookfor satis //there is a bunch and see WellBeing codebook

lookfor meaning //a bunch!!! PIL!

d ST185Q01HA ST185Q02HA ST185Q03HA EUDMO
pwcorr ST185Q01HA ST185Q02HA ST185Q03HA EUDMO
alpha ST185Q01HA ST185Q02HA ST185Q03HA

factor ST185Q01HA ST185Q02HA ST185Q03HA, fa(1)
rotate
predict eud
corr EUDMO eud //.99 ok thats it

d EUDMO //i think its a scale

//btw bunch of vars about beauty, tall, weight etc

ren ST016Q01NA ls
d ls

ta AGE //from 15 to 16.3 so can ignore it

//ren PA042Q01TA inc //useless mostly missing


lookfor health //dont see a good one


ren WEALTH wealth

ren  ST004D01T gender

ren ST007Q01TA faEd

keep ls EUDMO ST185Q01HA ST185Q02HA ST185Q03HA wealth gender faEd CNTRYID CNTSCHID CNTSTUID SUBNATIO 
save pisa18sub,replace


//----------------------------SCH----------------------------------
clear all
set maxvar 32000 //100000

import sas using "/home/aok/data/pisa/18/SCH/cy07_msu_sch_qqq.sas7bdat", clear

keep  SC013Q01TA SC001Q01TA OECD SUBNATIO  STRATUM Region NatCen CNTSCHID CNT  CNTRYID
ta SC001Q01TA,mi //ok only 6perc missing whew

recode SC001Q01TA (1=1 "lt3k")(2=2 "3-15k")(3=3 "15-100k")(4=4 "100k-1m")(5=5 "gt1m") ,gen(city)
ta city

merge 1:m CNTSCHID using pisa18sub //yay all merged

recode gender (1=1)(2=0),gen(fem)
la var fem "female"



cd /home/aok/papers/pisa/tex

graph bar (mean) ls, over(city, label(nolabel)) saving(ls,replace) ysc(r(6,8)) exclude0 yla(6(.5)8) //by(CNT) //yay hurray!!!

graph bar (mean) EUDMO, over(city) saving(eud,replace) //by(CNT) //yay hurray!!!

gr combine ls.gph eud.gph, row(2)
gr export bar.pdf



graph bar (mean) EUDMO  , over(city) 



reg ls i.city, robust  //it is huuuge yay!
est sto a1

reg ls i.city wealth, robust //even little bigger
est sto a2

reg ls i.city wealth fem faEd, robust
est sto a3

reg ls i.city wealth fem faEd i.Region, robust //ok smaller but still solid
est sto a4

reg ls i.city wealth fem faEd i.Region, robust beta 
//estadd beta
di 0.64/0.97 //effect size 65perc of fam wealth!!!

reg ls i.city wealth fem faEd i.Region if gender==1, robust
est sto a4f

reg ls i.city wealth fem faEd i.Region if gender==2, robust
est sto a4m //interestingly city penaly higher for female; arguably because fem more affected by urban crime

estout a*  using /home/aok/papers/pisa/out/regA.tex ,  cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label  starlevels(* 0.05 ** 0.01 *** 0.001)drop(*Region*)
! sed -i '/^constant/a\country dummies &no&no&no&yes&yes&yes\\\\' `tmp'`siz'.tex


reg ls i.city wealth i.gender faEd i.Region, robust cluster(CNTSCHID) //of course doesnt do anything happiness is person level

//reg ls i.city wealth i.gender faEd i.Region i.CNTSCHID, robust //takes forever

ta CNT //142 countries
di `r(r)'
ta Region
di `r(r)'

ta STRATUM
di `r(r)'

//---------------------by country------------------

gen cc=CNT

cap program drop rrr
program define rrr
syntax, m(string asis)f(string asis)
cap est drop *
levelsof cc,loc(__cc)
foreach _cc in `__cc'{
di "tis is `_cc':"
cap noisily `m' if cc=="`_cc'", robust
	if _rc != 0 {
	continue
        }
	if _rc == 0 {
	est sto `_cc'
	}	
}
estout *  using /tmp/`f'.tab , keep(*city*) cells(b(star fmt(%9.1f))) replace style(tab)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label  starlevels(+ 0.10 * 0.05) 
//! oocalc /tmp/a.tab
//! sed -i '1s/^/country/' /tmp/a.txt
//! cat /tmp/a.tab | datamash transpose | sed 's/\t/ \& /g' 
! cat /tmp/`f'.tab | /home/aok/Downloads/datamash-1.8/datamash transpose | sed 's/\t/ \& /g' | sed  's/\$/\\\\/' >/home/aok/papers/pisa/out/`f'.tex
end



rrr, m(reg ls i.city)f(a1)
rrr, m(reg ls i.city wealth i.gender faEd i.Region)f(a4cou)




//----------------------------------------eud---------------------------------



reg EUDMO i.city, robust  
est sto b1

reg EUDMO i.city wealth, robust 
est sto b2

reg EUDMO i.city wealth fem faEd, robust
est sto b3

reg EUDMO i.city wealth fem faEd i.Region, robust 
est sto b4

reg EUDMO i.city wealth fem faEd i.Region, robust beta 
//estadd beta
di 0.48/0.71 //again just like ls about  65perc of fam wealth!!!

reg EUDMO i.city wealth fem faEd i.Region if gender==1, robust
est sto b4f

reg EUDMO i.city wealth fem faEd i.Region if gender==2, robust
est sto b4m //interestingly city penaly higher for female; arguably because fem more affected by urban crime

estout b*  using /home/aok/papers/pisa/out/regB.tex ,  cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label  starlevels(* 0.05 ** 0.01 *** 0.001)drop(*Region*)
! sed -i '/^constant/a\country dummies &no&no&no&yes&yes&yes\\\\' `tmp'`siz'.tex

rrr, m(reg EUDMO i.city wealth i.gender faEd i.Region)f(b4cou)
