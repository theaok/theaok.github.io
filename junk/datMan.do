//xstata-mp //need mp
//takes liek 10min; can also make selection on import; can also try sas

run /home/aok/papers/root/do/aok_programs.do


clear
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


//as per arthur
lookfor internet
d IC006Q01TA IC007Q01TA IC008Q08TA  IC008Q05TA 

ren IC006Q01TA intWday
ren IC007Q01TA intWend
ren IC008Q08TA intFun
ren IC008Q05TA intSN

la var ls "life satisfaction"
note ls: "Overall, how satisfied are you with your life as a whole these days?" [0,10]

la var EUDMO "eudamonia" 
note EUDMO: "Eudaemonia: meaning in life (WLE)"  "PISA 2018 asked students (ST185) to report the extent to which they agree ( "strongly agree", "agree", "disagree", "strongly disagree") with the following statements: "My life has clear meaning or purpose"; "I have discovered a satisfactory meaning in life"; and "I have a clear sense of what gives meaning to my life". These statements were combined to form the index of meaning in life (EUDMO). Positive values in the index indicate greater meaning in life than the average student across OECD countries." https://www.oecd-ilibrary.org/sites/0a428b07-en/index.html?itemId=/content/component/0a428b07-en   [-2.1,1.7] 


la var wealth "Family wealth (WLE)"
note wealth: "The index of family wealth (WEALTH) is based on the students' responses on whether they had the following at home: a room of their own, a link to the Internet, a dishwasher (treated as a country-specific item), a DVD player, and three other country-specific items (some items in ST20); and their responses on the numberof cellular phones, televisions, computers, cars and the rooms with a bath or shower (ST21). "  NCES 2011-025U.S. DEPARTMENT OF EDUCATION Technical Report and User's Guide for the Program for International Student Assessment (PISA) 2009   https://nces.ed.gov/surveys/pisa/pdf/2011025.pdf  [-7.5,4.7]

la var faEd "father's education"
note faEd: "What is the <highest level of schooling> completed by your father?"

d int*

la var intWday "weekday Internet use"
note intWday: "During a typical weekday, for how long do you use the Internet outside of school" [1 (0),7 (>6 hrs a day)]

la var intWend "weekend Internet use"
note intWend: "During a typical weekend day, for how long do you use the Internet outside of school" [1 (0),7 (>6 hrs a day)]

la var intSN "social networks use"
note intSN: "How often do you use digital devices for the following activities outside of school?" "Participating in social networks (e.g.<Facebook>, <MySpace>)." [1 (never/hardly ever),5 (every day)]

la var intFun "use internet for fun"
note intFun: "How often do you use digital devices for the following activities outside of school?" "Browsing the Internet for fun (such as watching videos, e.g.<YouTube>)" [1 (never/hardly ever),5 (every day)]


keep ls EUDMO ST185Q01HA ST185Q02HA ST185Q03HA wealth gender faEd CNTRYID CNTSCHID CNTSTUID SUBNATIO int*
save pisa18sub,replace


//----------------------------SCH----------------------------------
clear all
set maxvar 32000 //100000

import sas using "/home/aok/data/pisa/18/SCH/cy07_msu_sch_qqq.sas7bdat", clear

keep  SC013Q01TA SC001Q01TA OECD SUBNATIO  STRATUM Region NatCen CNTSCHID CNT  CNTRYID STRATIO SCHLTYPE CLSIZE EDUSHORT STAFFSHORT STUBEHA TEACHBEHA 
ta SC001Q01TA,mi //ok only 6perc missing whew

recode SC001Q01TA (1=1 "lt3k")(2=2 "3-15k")(3=3 "15-100k")(4=4 "100k-1m")(5=5 "gt1m") ,gen(city)
la var city "rural-urban"
note city: "Which of the following definitions best describes the community in which your school is located?" [1 (A village, hamlet or ruralarea (fewer than 3 000 people)), 5 (A large city (with over 1 000 000 people))]


merge 1:m CNTSCHID using pisa18sub //yay all merged

recode gender (1=1)(2=0),gen(fem)
la var fem "female"



cd /home/aok/papers/pisa/tex

aok_var_des , ff(ls EUDMO city wealth  faEd  int*) fname(varDes.tex)
! sed -i  's/>/\$>\$/g' varDes.tex
! sed -i  's/</\$<\$/g' varDes.tex

aok_hist2, d(./)f(h1)x(ls EUDMO city wealth  faEd  int*) //todo!!!!!



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

reg ls i.city wealth fem faEd i.Region int*, robust 
est sto a5

estout a*  using /home/aok/papers/pisa/out/regA.tex ,  cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label  starlevels(* 0.05 ** 0.01 *** 0.001)drop(*Region* int*)
! sed -i '/^constant/a\country dummies &no&no&no&yes&yes&yes&yes\\\\' /home/aok/papers/pisa/out/regA.tex
! sed -i '/^constant/a\4 internet use vars &no&no&no&no&no&no&yes\\\\' /home/aok/papers/pisa/out/regA.tex
! sed -i '/lt3k.*/d' /home/aok/papers/pisa/out/regA.tex


reg ls i.city wealth i.gender faEd i.Region, robust cluster(CNTSCHID) //of course doesnt do anything happiness is person level but school isnt duh-yes it does cut significance but stil <.0001

//reg ls i.city wealth i.gender faEd i.Region i.CNTSCHID, robust //takes forever

d STRATIO SCHLTYPE CLSIZE EDUSHORT STAFFSHORT STUBEHA TEACHBEHA 
reg ls i.city wealth i.gender faEd i.Region STRATIO SCHLTYPE CLSIZE EDUSHORT STAFFSHORT STUBEHA TEACHBEHA , robust cluster(CNTSCHID)

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
estout *  using /tmp/`f'.tab , keep(*city*) cells(b(star fmt(%9.1f))) replace style(tab)  collabels(, none) stats(N, labels("N")fmt(%9.0fc))varlabels(_cons constant) label  starlevels(+ 0.10 * 0.05) 
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

reg EUDMO i.city wealth fem faEd i.Region int*, robust 
est sto b5

estout b*  using /home/aok/papers/pisa/out/regB.tex ,  cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0fc))varlabels(_cons constant) label  starlevels(* 0.05 ** 0.01 *** 0.001)drop(*Region* int*)
! sed -i '/^constant/a\country dummies &no&no&no&yes&yes&yes&yes\\\\' /home/aok/papers/pisa/out/regB.tex
! sed -i '/^constant/a\4 internet use vars &no&no&no&no&no&no&yes\\\\' /home/aok/papers/pisa/out/regB.tex
! sed -i '/lt3k.*/d' /home/aok/papers/pisa/out/regB.tex


rrr, m(reg EUDMO i.city wealth i.gender faEd i.Region)f(b4cou)
