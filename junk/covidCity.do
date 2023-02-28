stata
cd ~/papers/covidCity

------------------GSS--------------------------

//!stata-se -b do  /home/aok/data/gss/gss.do
use ~/data/gss/gss,clear
ta year

//!!! codebook says that as of release 3 no size, region etc; will be added later

table year city250k, c(mean swb) format(%9.2f) center

table zodiac, c(mean happy) format(%9.2f) center



------------------WVS--------------------------
//!stata-se -b do /home/aok/data/wvs/wvs81-22.do
use ~/data/wvs/wvs ,clear
ta yr

ta s_c if  yr==2021 //weird countries
ta s_c if  yr==2022 //ya just netherlands and uk>2k sample
ta cc if  yr==2022

** playing 

ta yr if cc=="NLD"
ta yr if cc=="GBR"

ta yr if cc=="URY"
ta yr if cc=="CZE"


table yr town, c(mean ls) format(%9.2f) center

table  town yr if cc=="NLD", c(mean ls) format(%9.2f) center //yeah!
//table  X049 yr if cc=="NLD", c(mean ls) format(%9.2f) center 
//table  X049CS yr if cc=="NLD", c(mean ls) format(%9.2f) center 


//nice look like over 10yrs 2012-2022
//everyone less happy but esp city!

table  town yr if cc=="GBR", c(mean ls) format(%9.2f) center //good too
table  X049 yr if cc=="GBR", c(mean ls) format(%9.2f) center 
//table  X049CS yr if cc=="GBR", c(mean ls) format(%9.2f) center 


table  town yr if cc=="URY", c(mean ls) format(%9.2f) center //other way round maybe bc only big city got vaccine
//table  X049 yr if cc=="CZE", c(mean ls) format(%9.2f) center //not eenough data by groups

//table  X049 yr if cc=="SVK", c(mean ls) format(%9.2f) center //not enough data
table  X049 yr if cc=="LBY", c(mean ls) format(%9.2f) center //yes


** actual sample selection

keep if inlist(cc,"GBR","NLD","URY")
compress
save /tmp/covidCity, replace //see ipynb


drop if cc=="GBR" & yr<2005
drop if cc=="NLD" & yr<2012
drop if cc=="URY" & yr<2011


ta s_c if  yr==2021
ta s_c if  yr==2022  
ta cc if  yr==2022

ta X049 yr if cc=="CZE"
ta X049 yr if cc=="GBR" & ls<.
ta X049 yr if cc=="LBY"
ta X049 yr if cc=="NIR"
ta X049 yr if cc=="NLD" & ls<.
ta X049 yr if cc=="SVK"
ta X049 yr if cc=="URY" & ls<.

replace X049=. if  cc=="URY" & X049==7
replace town=. if  cc=="URY" & town==7
ta town yr if cc=="URY" & ls<.


ta X049,gen(d_)
d d_*

gen town1=town
codebook town
replace town1=3 if inlist(town1,1,2)
replace town1=town1-2
ta  X049 town1

gen town2=town
codebook town2
replace town2=4 if inlist(town2,1,2,3)
replace town2=town2-3
ta  X049 town2

gen town3=town
codebook town3
replace town3=5 if inlist(town3,1,2,3,4)
replace town3=town3-4
ta  X049 town3

recode town3 (1=1 "lt50")(2 3=2 "50-500")(4=3 "gt500"), gen(t3)
ta  X049 t3


sum  age age2 male mar div ed inc class health pos_mat imp_god rel_imp aut freedom trust criVic famUns satFin


reg ls d_6-d_8  if (c==826 & yr==2022), robust
reg ls i.town     i.yr i.c, robust
reg ls i.town  age age2 male mar div  inc hea   i.yr i.c, robust

reg ls    age age2 male mar div inc health pos_mat imp_god rel_imp aut freedom trust  famUns satFin if (c==826 & yr==2022), robust





reg ls i.town2##i.yr  if (c==826 & yr>2004), robust
reg ls i.town1##i.yr   ,robust


//yes uk!
reg ls i.t3##i.yr inc   if (c==826), robust
reg ls i.t3##i.yr inc age age2 male mar div health   if (c==826 ), robust


reg ls i.town1   if (c==826)
reg ls i.town1##i.yr   if (c==826)
reg ls i.town1##i.yr inc   if (c==826), robust
reg ls i.town2##i.yr   if (c==826), robust
reg ls i.town2##i.yr inc  if (c==826), robust
reg ls i.town2##i.yr inc age age2 male mar div health aut freedom trust pos_mat imp_god if (c==826 ), robust
reg ls i.town3##i.yr   if (c==826), robust
reg ls i.town3##i.yr inc  if (c==826), robust
reg ls i.town3##i.yr inc age age2 male mar div health   if (c==826 ), robust
reg ls i.town2##i.yr inc age age2 male mar div health   if (c==826 ), robust



//not so much nld; if anything dropped everywhere; but nld tiny not really much of remote rural
reg ls i.t3##i.yr if (c==528 & yr>2007), robust
reg ls i.t3##i.yr inc age age2 male mar div health  if (c==528 & yr>2007), robust


reg ls i.town2##i.yr if (c==528 & yr>2007), robust
reg ls i.town2##i.yr inc age age2 male mar div health if (c==528 & yr>2007), robust
reg ls i.town2##i.yr inc age age2 male mar div health aut freedom if (c==528 & yr>2007), robust
reg ls i.town3##i.yr if (c==528 & yr>2007), robust
reg ls i.town3##i.yr inc age age2 male mar div health if (c==528 & yr>2007), robust
reg ls i.town3##i.yr inc age age2 male mar div health aut freedom if (c==528 & yr>2007), robust



//URY yay without controls or inc; and even with soc dem, and hea so yay
reg ls i.t3##i.yr if (c==858 & yr>2007), robust
reg ls i.t3##i.yr inc age age2 male mar div hea if (c==858 & yr>2007), robust


reg ls i.town2##i.yr if (c==858 & yr>2007), robust
reg ls i.town2##i.yr inc if (c==858 & yr>2007), robust
reg ls i.town2##i.yr inc age age2 if (c==858 & yr>2007), robust
reg ls i.town2##i.yr inc age age2 male mar div if (c==858 & yr>2007), robust

reg ls i.town2##i.yr inc age age2 male mar div hea if (c==858 & yr>2007), robust
reg ls i.town3##i.yr inc age age2 male mar div hea if (c==858 & yr>2007), robust

//freedom kils it; makes sense dev country, city bestows freedom perhaps esp in dev c!
reg ls i.town2##i.yr inc age age2 male mar div hea aut if (c==858 & yr>2007), robust
reg ls i.town2##i.yr inc age age2 male mar div hea free if (c==858 & yr>2007), robust


reg ls i.town2##i.yr inc age age2 male mar div health aut freedom if (c==858 & yr>2007), robust

reg ls i.town2##i.yr inc age age2 male mar div health aut freedom if (c==858 & yr>2007), robust

reg ls i.town2##i.yr inc age age2 male mar div health aut freedom if (c==858 & yr>2007), robust


** paper stuff

//yes i think just this to paper
either yr dummy 500k v smaller--we focus on differential from the graph fr last bar; or maybe even cleaner just start with overall
for everywhere--happiness dropped, but then dropped most for biggest cities
//--------------just test big city diff

//ok so ppl got less happy; but kinda background info
reg ls i.yr   if cc=="GBR" & yr>2000, robust
est sto GBR
reg ls i.yr   if cc=="NLD" & yr>2010, robust
est sto NLD
reg ls i.yr   if cc=="URY" & yr>2010, robust //happier here
est sto URY

est drop _all
//guess better <500k v >500k than everything v >500k: overlap and smaller diff
reg ls i.yr   if cc=="GBR" & yr>2000 & X049!=8, robust
est sto GBRrurTow
reg ls i.yr   if cc=="NLD" & yr>2010 & X049!=8, robust
est sto NLDrurTow
reg ls i.yr   if cc=="URY" & yr>2010 & X049!=8, robust //happier here
est sto URYrurTow

//these are really strong! and this is really what this paper is about
reg ls i.yr   if cc=="GBR" & yr>2000 & X049==8, robust
est sto GBRcity
reg ls i.yr   if cc=="NLD" & yr>2010 & X049==8, robust
est sto NLDcity
reg ls i.yr   if cc=="URY" & yr>2010 & X049==8, robust 
est sto URYcity

set linesize 120
esttab *

estout GBR* NLD* URY*  using  /tmp/regA.tex ,  cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label  starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) drop(*2005* *2011* *2012*)


//maybe skip this set and just get to the final full set right away
reg ls i.yr inc age age2 male mar div if cc=="GBR" & yr>2000 & X049!=8, robust
est sto GBRrurTow
reg ls i.yr inc age age2 male mar div if cc=="NLD" & yr>2010 & X049!=8, robust
est sto NLDrurTow
reg ls i.yr inc age age2 male mar div if cc=="URY" & yr>2010 & X049!=8, robust 
est sto URYrurTow

reg ls i.yr inc age age2 male mar div if cc=="GBR" & yr>2000 & X049==8, robust
est sto GBRcity
reg ls i.yr inc age age2 male mar div if cc=="NLD" & yr>2010 & X049==8, robust
est sto NLDcity
reg ls i.yr inc age age2 male mar div if cc=="URY" & yr>2010 & X049==8, robust 
est sto URYcity


reg ls i.yr inc age age2 male mar div aut freedom trust pos_mat imp_god if cc=="GBR" & yr>2000 & X049!=8, robust
est sto GBRrurTow
reg ls i.yr inc age age2 male mar div aut freedom trust pos_mat imp_god if cc=="NLD" & yr>2010 & X049!=8, robust
est sto NLDrurTow
reg ls i.yr inc age age2 male mar div aut freedom trust pos_mat imp_god if cc=="URY" & yr>2010 & X049!=8, robust 
est sto URYrurTow

reg ls i.yr inc age age2 male mar div aut freedom trust pos_mat imp_god if cc=="GBR" & yr>2000 & X049==8, robust
est sto GBRcity
reg ls i.yr inc age age2 male mar div aut freedom trust pos_mat imp_god if cc=="NLD" & yr>2010 & X049==8, robust
est sto NLDcity
reg ls i.yr inc age age2 male mar div aut freedom trust pos_mat imp_god if cc=="URY" & yr>2010 & X049==8, robust 
est sto URYcity

estout GBR* NLD* URY*  using  /tmp/regB.tex ,  cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label  starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) drop(*2005* *2011* *2012*)



//as expected hea kills much of it BUT magnitude still 2x of smaller areas contollong for hea
reg ls i.yr hea inc age age2 male mar div aut freedom trust pos_mat imp_god if cc=="GBR" & yr>2000 & X049!=8, robust
est sto GBRrurTow
reg ls i.yr hea inc age age2 male mar div aut freedom trust pos_mat imp_god if cc=="NLD" & yr>2010 & X049!=8, robust
est sto NLDrurTow
reg ls i.yr hea inc age age2 male mar div aut freedom trust pos_mat imp_god if cc=="URY" & yr>2010 & X049!=8, robust 
est sto URYrurTow

reg ls i.yr hea inc age age2 male mar div aut freedom trust pos_mat imp_god if cc=="GBR" & yr>2000 & X049==8, robust
est sto GBRcity
reg ls i.yr hea inc age age2 male mar div aut freedom trust pos_mat imp_god if cc=="NLD" & yr>2010 & X049==8, robust
est sto NLDcity
reg ls i.yr hea inc age age2 male mar div aut freedom trust pos_mat imp_god if cc=="URY" & yr>2010 & X049==8, robust 
est sto URYcity

estout GBR* NLD* URY*  using  /tmp/regC.tex ,  cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label  starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) drop(*2005* *2011* *2012*)


//ya so everywhere else even if sig, half of it!!
reg ls i.yr   if cc=="GBR" & yr>2000 & X049!=8, robust
reg ls i.yr   if cc=="NLD" & yr>2010 & X049!=8, robust
reg ls i.yr   if cc=="URY" & yr>2010 & X049!=8, robust 

//and persist here
reg ls i.yr inc age age2 male mar div if cc=="GBR" & yr>2000 & X049!=8, robust
reg ls i.yr inc age age2 male mar div if cc=="NLD" & yr>2010 & X049!=8, robust
reg ls i.yr inc age age2 male mar div if cc=="URY" & yr>2010 & X049!=8, robust //3x!

//and here!
reg ls i.yr inc age age2 male mar div aut freedom trust pos_mat imp_god if cc=="GBR" & yr>2000 & X049!=8, robust
reg ls i.yr inc age age2 male mar div aut freedom trust pos_mat imp_god if cc=="NLD" & yr>2010 & X049!=8, robust
reg ls i.yr inc age age2 male mar div aut freedom trust pos_mat imp_god if cc=="URY" & yr>2010 & X049!=8, robust 

//and hea kills it here too
reg ls i.yr hea inc age age2 male mar div aut freedom trust pos_mat imp_god if cc=="GBR" & yr>2000 & X049!=8, robust
reg ls i.yr hea inc age age2 male mar div aut freedom trust pos_mat imp_god if cc=="NLD" & yr>2010 & X049!=8, robust
reg ls i.yr hea inc age age2 male mar div aut freedom trust pos_mat imp_god if cc=="URY" & yr>2010 & X049!=8, robust 



//combine everything together but a mess meh
reg ls i.yr##d_8 inc age age2 male mar div aut freedom trust pos_mat imp_god if cc=="GBR" & yr>2000, robust
reg ls i.yr##d_8 inc age age2 male mar div aut freedom trust pos_mat imp_god if cc=="NLD" & yr>2010, robust
reg ls i.yr##d_8 inc age age2 male mar div aut freedom trust pos_mat imp_god if cc=="URY" & yr>2010, robust 



//meh
reg ls d_8 inc age age2 male mar div  if cc=="GBR" & yr==2022, robust
reg ls d_8 inc age age2 male mar div  if cc=="NLD" & yr==2022, robust
reg ls d_8 inc age age2 male mar div  if cc=="URY" & yr==2022, robust 


//!!!!!and pool everything together yes! do it! very cool, have more power, and yes it shows city got less happy after covid

reg ls i.yr##d_8 i.c, robust
reg ls i.yr##d_8 i.c inc age age2 male mar div aut freedom trust pos_mat imp_god , robust

//normalize yr to pre-post
gen prePos=.
replace prePos=1 if yr==2022
replace prePos=0 if yr<2022 & yr>1995
ta prePos yr

reg ls i.prePos##d_8 i.c i.yr, robust
est sto a1
reg ls i.prePos##d_8 i.c i.yr inc age age2 male mar div , robust
est sto a2
reg ls i.prePos##d_8 i.c i.yr inc age age2 male mar div imp_god trust pos_mat aut , robust
est sto a3
reg ls i.prePos##d_8 i.c i.yr inc age age2 male mar div aut  trust pos_mat imp_god hea, robust
est sto a4
reg ls i.prePos##d_8 i.c i.yr inc age age2 male mar div aut freedom trust pos_mat imp_god , robust
est sto a5
//reg ls i.prePos##d_8 i.c i.yr inc age age2 male mar div aut freedom trust pos_mat imp_god hea, robust

estout a*  using  /tmp/regD.tex ,  cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label  starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) //drop()

! sed -i '/prePos=0.*/d' /tmp/regD.tex 
! sed -i '/X049==500000 and more=0.*/d' /tmp/regD.tex 
! sed -i '/prePos=1 $\times$ X049==500000 and more=0.*/d' /tmp/regD.tex 
! sed -i '/Netherlands.*/d' /tmp/regD.tex 
! sed -i '/2005.*/d' /tmp/regD.tex 
! sed -i '/2022.*/d' /tmp/regD.tex 

! sed -i "s|prePos=1|post pandemic|g"  /tmp/regD.tex
! sed -i "s|X049==500000 and more=1|city lg500k|g"  /tmp/regD.tex
! sed -i "s|prePos=1 $\times$ X049==500000 and more=1|post pandemic x city lg500k|g"  /tmp/regD.tex




! sed -i "s|GBRrurTow|$<.5m$|g"  /tmp/regA.tex /tmp/regB.tex /tmp/regC.tex
! sed -i "s|NLDrurTow|$<.5m$|g"  /tmp/regA.tex /tmp/regB.tex /tmp/regC.tex
! sed -i "s|URYrurTow|$<.5m$|g"  /tmp/regA.tex /tmp/regB.tex /tmp/regC.tex

! sed -i "s|GBRcity|$>.5m$|g"  /tmp/regA.tex /tmp/regB.tex /tmp/regC.tex
! sed -i "s|NLDcity|$>.5m$|g"  /tmp/regA.tex /tmp/regB.tex /tmp/regC.tex
! sed -i "s|URYcity|$>.5m$|g"  /tmp/regA.tex /tmp/regB.tex /tmp/regC.tex



reg ls i.yr##i.town2 i.c inc age age2 male mar div aut freedom trust pos_mat imp_god , robust


//-------------scrap


codebook X049
recode X049 (1 2 3 4=1 'lt20')(5 6 7=2 '20-500')(8=3),gen(ru3)
ta X049  ru3

reg ls i.yr##ru3 inc age age2 male mar div  if cc=="GBR" & yr>2000, robust
reg ls i.yr##ru3 inc age age2 male mar div  if cc=="NLD" & yr>2010, robust
reg ls i.yr##ru3 inc age age2 male mar div  if cc=="URY" & yr>2010, robust 






//----------
use "https://github.com/theaok/theaok.github.io/blob/master/junk/a.dta?raw=true",clear
d ru*

ta rurUrb2 if cc=="GBR"

ta rurUrb2,gen(x_)
d x_*
ta yr

encode(rurUrb2),gen(ah)

reg ls i.yr##i.ah if cc=="GBR" 
reg ls x_1-x_5 yr yr#x_1 yr#x_2 yr#x_3 yr#x_4 yr#x_5 if cc=="GBR" 

ta rurUrb2 if cc=="GBR",mi
