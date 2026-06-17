//xstata-mp //need mp
//takes liek 10min; can also make selection on import; can also try sas
clear all
set maxvar 32000 //100000

run /home/aok/papers/root/do/aok_programs.do


clear
cd /home/aok/data/pisa/18
//import spss using "/home/aok/data/pisa/18/STU/CY07_MSU_STU_QQQ.sav"
//compress
//save pisa18,replace

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
//LATER //arguably wealth affects kid more tnan income
d PA042Q01TA 
//What is your annual household income?


ren  ST004D01T gender

//ren ST007Q01TA faEd
//la var faEd "father's education"
//note faEd: "What is the <highest level of schooling> completed by your father?"
ren MISCED maEd
la var maEd "mother's education"
note maEd: Mother's Education (ISCED) [0-6]


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


la var wealth "family wealth"
note wealth: "The index of family wealth (WEALTH) is based on the students' responses on whether they had the following at home: a room of their own, a link to the Internet, a dishwasher (treated as a country-specific item), a DVD player, and three other country-specific items (some items in ST20); and their responses on the numberof cellular phones, televisions, computers, cars and the rooms with a bath or shower (ST21). "  NCES 2011-025U.S. DEPARTMENT OF EDUCATION  Technical Report and User's Guide for the Program for International Student Assessment (PISA) 2009   https://nces.ed.gov/surveys/pisa/pdf/2011025.pdf  [-7.5,4.7]



d int*

la var intWday "weekday Internet use"
note intWday: "During a typical weekday, for how long do you use the Internet outside of school" [1 (0),7 (>6 hrs a day)]

la var intWend "weekend Internet use"
note intWend: "During a typical weekend day, for how long do you use the Internet outside of school" [1 (0),7 (>6 hrs a day)]

la var intSN "social networks use"
note intSN: "How often do you use digital devices for the following activities outside of school?" "Participating in social networks (e.g.<Facebook>, <MySpace>)." [1 (never/hardly ever),5 (every day)]

la var intFun "use internet for fun"
note intFun: "How often do you use digital devices for the following activities outside of school?" "Browsing the Internet for fun (such as watching videos, e.g.<YouTube>)" [1 (never/hardly ever),5 (every day)]


lookfor edu


keep ls EUDMO ST185Q01HA ST185Q02HA ST185Q03HA wealth gender maEd CNTRYID CNTSCHID CNTSTUID SUBNATIO int* W_FSTUWT PISADIFF
save pisa18sub,replace



//----------------------------SCH----------------------------------

import sas using "/home/aok/data/pisa/18/SCH/cy07_msu_sch_qqq.sas7bdat", clear

keep  SC013Q01TA SC001Q01TA OECD SUBNATIO  STRATUM Region NatCen CNTSCHID CNT  CNTRYID STRATIO SCHLTYPE CLSIZE EDUSHORT STAFFSHORT STUBEHA TEACHBEHA 
ta SC001Q01TA,mi //ok only 6perc missing whew

recode SC001Q01TA (1=1 "lt3k")(2=2 "3-15k")(3=3 "15-100k")(4=4 "100k-1m")(5=5 "gt1m") ,gen(city)
la var city "rural-urban"
note city: "Which of the following definitions best describes the community in which your school is located?" [1 (A village, hamlet or ruralarea (fewer than 3 000 people)), 5 (A large city (with over 1 000 000 people))]


merge 1:m CNTSCHID using pisa18sub //yay all merged

recode gender (1=1)(2=0),gen(fem)
la var fem "female"

save pisa18stu-sch,replace

//---------------------------COG--------------------------------

/* these are like freaking individual questions asked to stduents; dont see overall score neither here nor in student module */
/* RCORE_TEST */
/* RCORE_PERF //the only var that seems to make sense: reading adaptive performance on like low med hi, but where is sci and math? */

/* ! wget https://www.oecd.org/content/dam/oecd/en/data/datasets/pisa/pisa-2018-datasets/ssas-sps-data-files/SAS_STU_COG.zip */
/* ls */
/* ! unzip SAS_STU_COG.zip */
/* import sas using "/home/aok/data/pisa/18/COG/cy07_msu_stu_cog.sas7bdat", clear */
/* ! wget https://www.oecd.org/content/dam/oecd/en/data/datasets/pisa/pisa-2018-datasets/ssas-sps-data-files/SPSS_STU_COG.zip */
//! unzip .zip

/* clear all */
/* set maxvar 32000 //100000 */
/* //CNTRYID */
/* import spss CNTSTUID  using "/home/aok/data/pisa/18/COG/CY07_MSU_STU_COG.sav" */
/* d,s */
/* compress */
/* save pisa18cog,replace */


//-------

use pisa18stu-sch,clear

cd /home/aok/papers/pisa/tex
note fem: female
la var PISADIFF "difficult test"
note PISADIFF: Perception of difficulty of the PISA test (WLE)

aok_var_des , ff(ls EUDMO city fem wealth  maEd  int* PISADIFF) fname(varDes.tex)
! sed -i  's/>/\$>\$/g' varDes.tex
! sed -i  's/</\$<\$/g' varDes.tex

aok_hist2, d(./)f(h1)x(ls EUDMO city fem wealth  maEd  int* PISADIFF) //todo!!!!!



graph bar (mean) ls, over(city, label(nolabel)) saving(ls,replace) ysc(r(6,8)) exclude0 yla(6(.5)8) //by(CNT) //yay hurray!!!

graph bar (mean) EUDMO, over(city) saving(eud,replace) //by(CNT) //yay hurray!!!

gr combine ls.gph eud.gph, row(2)
gr export bar.pdf


graph bar (mean) EUDMO  , over(city) 



reg ls i.city, robust  //it is huuuge yay!
est sto a1

reg ls i.city [pw=W_FSTUWT], robust //even bigger

reg ls i.city wealth, robust //even little bigger
est sto a2

reg ls i.city wealth fem maEd, robust
est sto a3

reg ls i.city wealth fem maEd i.Region, robust //ok smaller but still solid
est sto a4

reg ls i.city wealth fem maEd i.Region PISADIFF, robust
est sto a4a

reg ls i.city wealth fem maEd i.Region, robust beta 
//estadd beta
di 0.64/0.97 //effect size 65perc of fam wealth!!!

reg ls i.city wealth fem maEd i.Region [pw=W_FSTUWT], robust

reg ls i.city wealth  maEd i.Region if gender==1, robust
est sto a4f

reg ls i.city wealth  maEd i.Region if gender==2, robust
est sto a4m //interestingly city penaly higher for female; arguably because fem more affected by urban crime

reg ls i.city wealth fem maEd i.Region int*, robust 
est sto a5

/* reg ls i.city##c.wealth fem maEd, robust  */
/* est sto a6 */

reg ls i.city##c.wealth fem maEd i.Region , robust 
est sto a6



estout a*  using /home/aok/papers/pisa/out/regA.tex ,  cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label  starlevels(* 0.05 ** 0.01 *** 0.001)drop(*Region* int*)
! sed -i '/^constant/a\country dummies &no&no&no&yes&yes&yes&yes&yes&yes\\\\' /home/aok/papers/pisa/out/regA.tex
! sed -i '/^constant/a\4 internet use vars &no&no&no&no&no&no&no&yes&no\\\\' /home/aok/papers/pisa/out/regA.tex
! sed -i '/lt3k.*/d' /home/aok/papers/pisa/out/regA.tex


reg ls i.city wealth i.gender maEd i.Region, robust cluster(CNTSCHID) //of course doesnt do anything happiness is person level but school isnt duh-yes it does cut significance but stil <.0001

//reg ls i.city wealth i.gender faEd i.Region i.CNTSCHID, robust //takes forever

d STRATIO SCHLTYPE CLSIZE EDUSHORT STAFFSHORT STUBEHA TEACHBEHA 
reg ls i.city wealth i.gender maEd i.Region STRATIO SCHLTYPE CLSIZE EDUSHORT STAFFSHORT STUBEHA TEACHBEHA , robust cluster(CNTSCHID)

ta CNT //142 countries
di `r(r)'
ta Region
di `r(r)'

ta STRATUM
di `r(r)'


//int with wealth---interacting wealth with urbanicity--indeed significant--wealth pays off more in city: SOM, maybe marginsplot; also for eudamo ia

reg ls i.city##c.wealth, robust
margins city, at(wealth=(-7(2)4))
marginsplot
//right so in smaller place money doesnt really matter, kids are happy anyway
//but in large places happiness is heavility dependent on wealth

reg ls i.city##c.wealth fem maEd i.Region , robust 
margins city, at(wealth=(-7(2)4))
marginsplot

xtile wq = wealth, nq(4)



//wow so actually less happy wealthy in small areas!
reg ls i.city##i.wq, robust
margins city, at(wq=(1(1)4))
marginsplot

reg ls i.city##i.wq fem maEd i.Region , robust
margins city, at(wq=(1(1)4))
marginsplot

reg ls i.city##i.wq, robust
margins wq, at(city=(1(1)5))
marginsplot

reg ls i.city##i.wq fem maEd i.Region, robust
margins wq, at(city=(1(1)5))
marginsplot


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
rrr, m(reg ls i.city wealth i.gender maEd i.Region)f(a4cou)




//----------------------------------------eud---------------------------------



reg EUDMO i.city, robust  
est sto b1

reg EUDMO i.city [pw=W_FSTUWT], robust  


reg EUDMO i.city wealth, robust 
est sto b2

reg EUDMO i.city wealth fem maEd, robust
est sto b3

reg EUDMO i.city wealth fem maEd i.Region, robust 
est sto b4

reg EUDMO i.city wealth fem maEd i.Region PISADIFF, robust 
est sto b4a

reg EUDMO i.city wealth fem maEd i.Region, robust beta 
//estadd beta
di 0.48/0.71 //again just like ls about  65perc of fam wealth!!!

reg EUDMO i.city wealth fem maEd i.Region [pw=W_FSTUWT], robust

reg EUDMO i.city wealth  maEd i.Region if gender==1, robust
est sto b4f

reg EUDMO i.city wealth  maEd i.Region if gender==2, robust
est sto b4m //interestingly city penaly higher for female; arguably because fem more affected by urban crime

reg EUDMO i.city wealth fem maEd i.Region int*, robust 
est sto b5

/* reg EUDMO i.city##c.wealth fem maEd , robust  */
/* est sto b6 */

reg EUDMO i.city##c.wealth fem maEd i.Region, robust 
est sto b6

estout b*  using /home/aok/papers/pisa/out/regB.tex ,  cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0fc))varlabels(_cons constant) label  starlevels(* 0.05 ** 0.01 *** 0.001)drop(*Region* int*)
! sed -i '/^constant/a\country dummies &no&no&no&yes&yes&yes&yes&yes&yes\\\\' /home/aok/papers/pisa/out/regB.tex
! sed -i '/^constant/a\4 internet use vars &no&no&no&no&no&no&no&yes&no\\\\' /home/aok/papers/pisa/out/regB.tex
! sed -i '/lt3k.*/d' /home/aok/papers/pisa/out/regB.tex


rrr, m(reg EUDMO i.city wealth i.gender maEd i.Region)f(b4cou)
