#################################################################
//LOL and now may16 2020 started new one here with gss2018 with rubia and lonnie
//and added in here from gssLonnie.do

//OLD://this is NOT the paper file, from old paper; use the other one!!!!!!!!!!!!!!!
##################################################################

//stata
clear                                  
capture set maxvar 10000
version 14                             
set more off                           
run ~/papers/root/do/aok_programs.do

loc pap gssLonnie
loc d = "/home/aok/papers/root/rr/" + "`pap'" + "/"       

//capture mkdir "`d'tex"                 
//capture mkdir "`d'scr"
capture mkdir "/tmp/`pap'"

loc tmp "/tmp/`pap'/"

//file open tex using `d'out/tex, write text replace
//file write tex `"%<*ginipov>`:di  %9.2f `r(rho)''%</ginipov>"' 


**** gss

//TODO think about it
//reviewer wanted that
//keep if wrkslf==0 //later can look a missing codes maybe eep them

/* meh these codes are messed up :( better just use occ10 :)
ta isco1
ta isco3
drop if isco3==110|isco3==210|isco3==310
*/
ta occ10
ta occ10, nola
//codebook occ10, ta(500)
//TODO think about this one too lol
//drop if inlist(occ10, 9800, 9810, 9820, 9830)


//TODO think about it too
//keep if wrkstat==1|wrkstat==2


//everybody works here so do not care about unempl! also using WS as possed to hrs1 bc  mnore obs here


//$gss
use /home/aok/data/gss/gss.dta,clear

xtile realincD=realinc, nq(10)
ta realincD,gen(INC)


cap log close
log using /tmp/incD.txt, replace
ta realinc realincD
log close

! cp /tmp/incD.txt /home/aok/misc/html/theaok.github.io/junk/


d WS*
gen WSother=.
replace WSother=0 if WS1==1|WS2==1
replace WSother=1 if WS3==1|WS4==1|WS5==1|WS6==1|WS7==1|WS8==1
ta WSother WS1,mi
ta WSother WS2,mi
//TODO think about it again lol

loc socDem age age2  mar  ed  male hompop white
loc extCon i.isco1 i.region


**** des stats
/*
preserve
drop if hrs_c==0
aok_barcap , dv(swb) by(hrs_c)s(/tmp/lonnie_issp_work/barHrsSiz1)
restore
dy


** LATER
sum realinc
preserve
drop if hrs_c==0 |realinc<31000
aok_barcap , dv(swb) by(hrs_c)s(/tmp/lonnie_issp_work/barHrsSiz1)
restore
dy
sum realinc
preserve
drop if hrs_c==0 |realinc>31000
aok_barcap , dv(swb) by(hrs_c)s(/tmp/lonnie_issp_work/barHrsSiz1)
restore
dy
*/




//for tex
d swb hrs1 hrs2 hr mustwork  moredays sethrs sethours hrsmoney hrsrelax chn_sch paidhow  famwkoff usualhrs mosthrs leasthrs  mostUsual leastUsual advsched wrkshift timeoff union age age2 mar realinc  ed  male hompop white  wrkstat waypaid secondwk wrksched wrkshift health mntlhlth stress usedup overwork

sum swb hrs1 hrs2 hr mustwork  moredays sethrs sethours hrsmoney hrsrelax chn_sch paidhow  famwkoff usualhrs mosthrs leasthrs  mostUsual leastUsual advsched wrkshift timeoff union age age2 mar realinc  ed  male hompop white  wrkstat waypaid secondwk wrksched wrkshift health mntlhlth stress usedup overwork

ta union sethrs   ,mi 
ta union  advsched,mi
ta union  wrkshift,mi

//TODO add more work related etc
corr mosthrs leasthrs usualhrs mostUsual leastUsual


//TODO add here too
aok_hist2,x(swb sethours hrsmoney chn_sch famwkoff realinc  age  mar  ed  male hompop white hrs1 hea)d(`tmp')f(hist)

//SH* HM* CS* FW*
aok_var_des , ff(swb sethours  chn_sch famwkoff realinc  `socDem' hrs1 hea)fname(`tmp'var_des)

! sed -i '/^  who set working hours/i\{\\bf flextime}:&\\\\' `tmp'var_des
! sed -i '/^  family income/i\{\\bf controls}:&\\\\' `tmp'var_des


//--------------------regressions----------------------
est drop _all

//-----------may21


foreach dv of varlist swb satjob satlife unhappy{
reg `dv' HH1-HH3 HH5-HH7 HH0 i.year, robust
est sto `dv'A1
reg `dv' HH1-HH3 HH5-HH7 HH0 WS2 WSother i.year, robust
est sto `dv'A2
reg `dv' HH1-HH3 HH5-HH7 HH0 WS2 WSother INC1-INC4 INC6-INC10 i.year, robust
est sto `dv'A3
reg `dv' HH1-HH3 HH5-HH7 HH0 WS2 WSother INC1-INC4 INC6-INC10 age age2 fem  mar  ed  hompop white i.year, robust
est sto `dv'A4
reg `dv' HH1-HH3 HH5-HH7 HH0 WS2 WSother INC1-INC4 INC6-INC10 age age2 fem  mar ed  hompop white  IS1 IS2 IS4-IS8 i.ind11  i.year, robust
est sto `dv'A5
reg `dv'  WS2 WSother hrs1 i.WS2#c.hrs1 i.WSother#c.hrs1 INC1-INC4 INC6-INC10 age age2 fem  mar  ed  hompop white  IS1 IS2 IS4-IS8 i.ind11 i.year, robust
est sto `dv'A6
 reg `dv' i.fem##c.hrs1 WS2 WSother INC1-INC4 INC6-INC10 age age2   mar  ed hompop white  IS1 IS2 IS4-IS8 i.ind11 i.year, robust
est sto `dv'A7
 reg `dv'  fem hrs1 WS2 WSother INC1-INC4 INC6-INC10 age age2   mar  ed  hompop white  IS1 IS2 IS4-IS8 i.ind11 i.year, robust
est sto `dv'A8
estout `dv'*  using `tmp'`dv'.tex ,  cells(b(star fmt(%9.3f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label  starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) drop(*year*)
}

//se(par fmt(%9.3f))





//-----------may17_3

ta waypaid,gen(WP)

reg swb  WP2-WP3 secondwk  health mntlhlth stress usedup overwork hrs1 inc i.year, robust 
est sto z1

estout z1*  using `tmp'z1.tex ,  cells(b(star fmt(%9.3f))se(par fmt(%9.3f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label  starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) drop(*year*)


//-----------may17_2
reg swb hrs1 i.year, robust
est sto t1m1

reg swb   HH1-HH3 HH5-HH7 HH0 i.year, robust
est sto t1m3

reg swb  HH1-HH3 HH5-HH7 HH0  inc i.year, robust
est sto t1m4

reg swb  HH1-HH3 HH5-HH7 HH0  inc IS1 IS2 IS4-IS8 i.year, robust
est sto t1m5

reg swb  HH1-HH3 HH5-HH7 HH0  inc IS1 IS2 IS4-IS8  i.year age age2 male  mar  ed  hompop  hea , robust
est sto t1m6

estout t1*  using `tmp't1.tex ,  cells(b(star fmt(%9.3f))se(par fmt(%9.3f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant)drop(*year*) label  starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)
//order(HH0 HH1 HH2 HH3 HH5 HH6 HH7 inc IS2 IS3 IS4 IS5 IS6 IS7 IS8  age age2  mar  ed  hompop  hea male )






est drop _all
fvset base 2000 year

reg swb  moredays mustwork  i.year, robust
est sto t2m1

reg swb   HH1-HH3 HH5-HH7 HH0 moredays mustwork  i.year, robust
est sto t2m2

reg swb  HH1-HH3 HH5-HH7 HH0   c.moredays##c.inc mustwork inc i.year, robust
est sto t2m3

reg swb  HH1-HH3 HH5-HH7 HH0    c.moredays##c.inc mustwork inc i.year IS1 IS2 IS4-IS8 i.year, robust
est sto t2m4

reg swb  HH1-HH3 HH5-HH7 HH0  mustwork inc i.year   c.moredays##c.inc  IS1 IS2 IS4-IS8  i.year age age2 male  mar  ed  hompop  hea , robust
est sto t2m5

reg swb  WS2-WS8  i.year, robust
est sto t2m6

reg swb  WS2-WS8 inc i.year, robust
est sto t2m7

reg swb  WS2-WS8 inc i.year IS1 IS2 IS4-IS8  i.year age age2 male  mar  ed  hompop  hea ,  robust
est sto t2m8


estout t2*  using `tmp't2.tex ,  cells(b(star fmt(%9.3f))se(par fmt(%9.3f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant)drop(*year* IS*) label  starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)
//order(HH0 HH1 HH2 HH3 HH5 HH6 HH7 inc IS2 IS3 IS4 IS5 IS6 IS7 IS8  age age2  mar  ed  hompop  hea male )

/* ! sed -i '/^constant/i\year dummies&yes&yes&yes&yes&yes&yes&yes&yes\\\\' `tmp't2.tex */
/* ! sed -i '/^year/i\occupation dummies&no&no&no&yes&yes&no&no&yes\\\\' `tmp't2.tex */


/* ! sed -i '/^hours: 0/i\number of hours worked last week&&&&&&&&\\\\' `tmp't2.tex */
/* ! sed -i "s|hours: |\\\hspace{.2in}|g" `tmp't2.tex */

/* ! sed -i '/^wrk stat: working par/i\labor force status&&&&&&&&\\\\' `tmp't2.tex */
/* ! sed -i "s|wrk stat: |\\\hspace{.2in}|g" `tmp't2.tex */






forval i=1/8{
reg swb  HH1-HH3 HH5-HH7 HH0 inc  i.year age age2 male  mar  ed  hompop  hea if  isco1==`i', robust
loc nam `:var lab IS`i''
est title: `nam'
est sto occ`i'
}

estout occ*  using `tmp't3.tex ,  cells(b(star fmt(%9.3f))se(par fmt(%9.3f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant)drop(*year* ) label  starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)
//order(HH0 HH1 HH2 HH3 HH5 HH6 HH7 inc IS2 IS3 IS4 IS5 IS6 IS7 IS8  age age2  mar  ed  hompop  hea male )

/* ! sed -i '/^constant/i\year dummies&yes&yes&yes&yes&yes&yes&yes&yes\\\\' `tmp't3.tex */
/* ! sed -i "s|occ:||g" `tmp't3.tex */
/* ! sed -i '/^hours: 0/i\number of hours worked last week&&&&&&&&\\\\' `tmp't3.tex */
/* ! sed -i "s|hours: |\\\hspace{.2in}|g" `tmp't3.tex */




est drop _all

reg swb   HM1 HM3   i.year, robust
est sto t5m1

reg swb  SH1 SH3 HM1 HM3   i.year, robust
est sto t5m2

reg swb  SH1 SH3 HM1 HM3   HH1-HH3 HH5-HH7 HH0   i.year, robust
est sto t5m3

reg swb SH1 SH3 HM1 HM3  HH1-HH3 HH5-HH7 HH0  inc i.year, robust
est sto t5m4

reg swb SH1 SH3 HM1 HM3   HH1-HH3 HH5-HH7 HH0  inc i.year IS1 IS2 IS4-IS8 i.year, robust
est sto t5m5

reg swb SH1 SH3 HM1 HM3   HH1-HH3 HH5-HH7 HH0  inc i.year  IS1 IS2 IS4-IS8  i.year age age2 male  mar  ed  hompop  hea , robust
est sto t5m6


estout t5*  using `tmp't5.tex ,  cells(b(star fmt(%9.3f))se(par fmt(%9.3f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant)drop(*year* IS*) label  starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)
/* ! sed -i '/^constant/i\year dummies&yes&yes&yes&yes&yes&yes\\\\' `tmp't5.tex */
/* ! sed -i '/^year/i\occupation dummies&no&no&no&no&yes&yes\\\\' `tmp't5.tex */

/* ! sed -i "s|hrsmoney: ||g" `tmp't5.tex */
/* ! sed -i "s|sethours: ||g" `tmp't5.tex */


/* ! sed -i '/^more hrs/i\preference re: work hrs and money&&&&&&\\\\' `tmp't5.tex */
/* ! sed -i "s|more hrs|\\\hspace{.2in}more hrs|g" `tmp't5.tex */
/* ! sed -i "s|fewer and less|\\\hspace{.2in}fewer and less|g" `tmp't5.tex */

/* ! sed -i '/^employer decides/i\who set working hours&&&&&&\\\\' `tmp't5.tex */
/* ! sed -i "s|employer decides|\\\hspace{.2in}employer decides|g" `tmp't5.tex */
/* ! sed -i "s|free to decide|\\\hspace{.2in}free to decide|g" `tmp't5.tex */

/* ! sed -i '/^hours: 0/i\number of hours worked last week&&&&&\\\\' `tmp't5.tex */
/* ! sed -i "s|hours: |\\\hspace{.2in}|g" `tmp't5.tex */







est drop _all

reg swb hrs1 inc age age2  mar un ed hompop hea rep dem con lib i.isco1 i.year, robust
est title: all
est sto male11
reg swb hrs1 inc age age2  mar un ed  hompop hea rep dem con lib i.isco1 i.year if male==1 , robust
est title: male
est sto male12
reg swb hrs1 inc age age2  mar un ed hompop hea rep dem con lib i.isco1 i.year if male==0, robust
est title: female
est sto male13

reg swb HH1-HH3 HH5-HH7 inc age age2  mar un ed hompop hea rep dem con lib i.isco1 i.year , robust
est title: all
est sto male21
reg swb HH1-HH3 HH5-HH7 inc age age2  mar un ed hompop hea rep dem con lib i.isco1 i.year if male==1, robust
est title: male
est sto male22
reg swb HH1-HH3 HH5-HH7 inc age age2  mar un ed hompop hea rep dem con lib i.isco1 i.year if male==0, robust
est title: female
est sto male23

reg swb WS2-WS8 inc age age2  mar  ed hompop hea rep dem con lib i.isco1 i.year , robust
est title: all
est sto male31
reg swb WS2-WS8 inc age age2  mar  ed hompop hea rep dem con lib i.isco1 i.year if male==1, robust
est title: male
est sto male32
reg swb WS2-WS8 inc age age2  mar  ed hompop hea rep dem con lib i.isco1 i.year if male==0, robust
est title: female
est sto male33


estout male*  using `tmp'regMale.tex ,  cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant)drop(*year*) label  starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)


loc dv swb
loc iv hrs1
loc c male

mlogit `dv' c.`iv'##i.`c' inc age age2 inc mar un ed hompop rep dem con lib hea i.isco1 i.year, robust 


margins `c',  at(`iv'=(0(10)100))  vce(uncond)  predict(outcome(1))
marginsplot, x(`iv') name(g1,replace) plot1opts(lpattern(dot))title(" ")legend(off)
margins `c',  at(`iv'=(0(10)100))  vce(uncond)  predict(outcome(2))
marginsplot, x(`iv') name(g2,replace) plot1opts(lpattern(dot))title(" ")legend(off)
margins `c',  at(`iv'=(0(10)100))  vce(uncond)  predict(outcome(3))
marginsplot, x(`iv') name(g3,replace) plot1opts(lpattern(dot))title(" ")legend(off)

graph combine g1 g2 g3,   //ycommon--may be useful...
gr export `tmp'mMale.eps,replace
! epstopdf `tmp'mMale.eps
! acroread  `tmp'mMale.pdf



*** SIZ



reg swb c.hrs1##i.sizQ age age2 inc mar un ed hea hompop male i.year, robust 

reg swb c.hrs1##i.sizQ age age2 inc mar un ed hea hompop rep dem con lib male i.isco1 i.year, robust 

codebook xnorcsiz, ta(100)
reg swb c.hrs1##i.xnorcsiz age age2 inc mar un ed hea hompop male i.year, robust 

codebook srcbelt, ta(100)
reg swb c.hrs1##i.srcbelt age age2 inc mar un ed hea hompop male i.year, robust 

reg swb c.hrs1##i.srcbelt age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year, robust 


bys siz: reg swb  hrs1 age age2 inc mar un ed hea hompop, robust
bys siz: reg swb  i.hrs_c age age2 inc mar un ed hea hompop, robust
//aha ! only in biggest cities people are swb to work a lot--workaholiics
//aha! if anything in smaller places people less swb to work more

codebook wrks
bys siz: reg swb i.wrks age age2 inc mar un ed hea hompop male rep dem con lib i.year, robust


codebook xnorcsiz, ta(100) //same here
bys xnorcsiz: reg swb  hrs1 age age2 inc mar un ed hea hompop, robust

//this may have to do with types of occup in largest vs smallest areas

reg swb c.hrs1##c.size age age2 inc mar un ed hea hompop male i.year, robust



/* codebook siz, ta(100) */

/* preserve */
/* keep if siz==1 */
/* aok_barcap, dv(swb) by(hrs_c)s(/tmp/lonnie_issp_work/barHrsSiz1) */
/* restore */
/* preserve */
/* keep if siz==2 */
/* aok_barcap, dv(swb) by(hrs_c)s(/tmp/lonnie_issp_work/barHrsSiz1) */
/* restore */
/* preserve */
/* keep if siz==3 */
/* aok_barcap, dv(swb) by(hrs_c)s(/tmp/lonnie_issp_work/barHrsSiz1) */
/* restore */
/* preserve */
/* keep if siz==4 */
/* aok_barcap, dv(swb) by(hrs_c)s(/tmp/lonnie_issp_work/barHrsSiz1) */
/* restore */


/* gr hbar swb, over(hrs_c)over(siz) */
/* gr export `tmp'g1.eps, replace */
/* ! epstopdf `tmp'g1.eps */
/* ! acroread `tmp'g1.pdf */
//patterns are thener but not v significant in regressions



est drop _all


reg swb HH1-HH3 HH5-HH7 age age2 inc mar unemp ed hea hompop male rep dem con lib i.isco1 i.year  if sizQ==1, robust
est sto regSizQ1
reg swb HH1-HH3 HH5-HH7 age age2 inc mar unemp ed hea hompop male rep dem con lib i.isco1 i.year  if sizQ==2, robust
est sto regSizQ2
reg swb HH1-HH3 HH5-HH7 age age2 inc mar unemp ed hea hompop male rep dem con lib i.isco1 i.year  if sizQ==3, robust
est sto regSizQ3
reg swb HH1-HH3 HH5-HH7 age age2 inc mar unemp ed hea hompop male rep dem con lib i.isco1 i.year  if sizQ==4, robust
est sto regSizQ4
reg swb HH1-HH3 HH5-HH7 age age2 inc mar unemp ed hea hompop male rep dem con lib i.isco1 i.year  if sizQ==5, robust
est sto regSizQ5


reg swb WS2-WS8 age age2 inc mar unemp ed hea hompop male rep dem con lib i.isco1 i.year  if sizQ==1, robust
est sto regSizQ21
reg swb WS2-WS8 age age2 inc mar unemp ed hea hompop male rep dem con lib i.isco1 i.year  if sizQ==2, robust
est sto regSizQ22
reg swb WS2-WS8 age age2 inc mar unemp ed hea hompop male rep dem con lib i.isco1 i.year  if sizQ==3, robust
est sto regSizQ23
reg swb WS2-WS8 age age2 inc mar unemp ed hea hompop male rep dem con lib i.isco1 i.year  if sizQ==4, robust
est sto regSizQ24
reg swb WS2-WS8 age age2 inc mar unemp ed hea hompop male rep dem con lib i.isco1 i.year  if sizQ==5, robust
est sto regSizQ25

estout regSiz*  using `tmp'regSiz.tex ,  cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant)drop(*year*) label  starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)


/* loc dv swb */
/* loc iv hrs1 */
/* loc c siz */

/* mlogit `dv' c.`iv'##i.`c' inc age age2 mar un ed hompop hea male rep dem con lib i.year, robust  */


/* margins `c',  at(`iv'=(0(10)100))  vce(uncond)  predict(outcome(1)) */
/* marginsplot, x(`iv') name(g1,replace) title(" ") */
/* gr export `tmp'mSizNH.eps,replace */
/* ! epstopdf `tmp'mSizNH.eps */
/* ! acroread  `tmp'mSizNH.pdf */

/* margins `c',  at(`iv'=(0(10)100))  vce(uncond)  predict(outcome(2)) */
/* marginsplot, x(`iv') name(g2,replace) title(" ") */
/* gr export `tmp'mSizPH.eps,replace */
/* ! epstopdf `tmp'mSizPH.eps */
/* ! acroread  `tmp'mSizPH.pdf */

/* margins `c',  at(`iv'=(0(10)100))  vce(uncond)  predict(outcome(3)) */
/* marginsplot, x(`iv') name(g3,replace) title(" ") */
/* gr export `tmp'mSizVH.eps,replace */
/* ! epstopdf `tmp'mSizVH.eps */
/* ! acroread  `tmp'mSizVH.pdf */


/* //graph combine g1 g2 g3,   // ycommon--may be useful... */


  

/* ** REG by censis region */
/* bys region: reg swb  hrs1 age age2 inc mar un ed hea hompop male i.year, robust */
/* //aha in midde atlantic people are swb to work more; in south atlantic, like to work less; though not very signiifcant */
/* //LATER may also see if they value anywhere flexy hours more... */

/* codebook region */

/* reg swb c.hrs1##i.region age age2 inc mar un ed hea hompop male i.year, robust  */


/* //TODO may want to combine similar places for final paper and have this in the online appendix */

/* est drop _all */

/* reg swb c.hrs1 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==1, robust  */
/* est title: ne */
/* est sto regReg1  */

/* reg swb c.hrs1 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==2, robust  */
/* est title: me */
/* est sto regReg2  */

/* reg swb c.hrs1 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==3, robust  */
/* est title: enc */
/* est sto regReg3  */

/* reg swb c.hrs1 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==4, robust  */
/* est title: wnc */
/* est sto regReg4  */

/* reg swb c.hrs1 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==5, robust  */
/* est title: sa */
/* est sto regReg5  */

/* reg swb c.hrs1 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==6, robust  */
/* est title: esc */
/* est sto regReg6 */

/* reg swb c.hrs1 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==7, robust  */
/* est title: wsc */
/* est sto regReg7  */

/* reg swb c.hrs1 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==8, robust  */
/* est title: m */
/* est sto regReg8  */

/* reg swb c.hrs1 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==9, robust  */
/* est title: p */
/* est sto regReg9  */


/* estout regReg*  using `tmp'regReg.tex ,  cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant)drop(*year*) label  starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) */


/* est drop _all */


/* reg swb WS2-WS8 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==1, robust  */
/* est title: ne */
/* est sto regReg21  */

/* reg swb WS2-WS8 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==2, robust  */
/* est title: me */
/* est sto regReg22  */

/* reg swb WS2-WS8 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==3, robust  */
/* est title: enc */
/* est sto regReg23  */

/* reg swb WS2-WS8 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==4, robust  */
/* est title: wnc */
/* est sto regReg24  */

/* reg swb WS2-WS8 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==5, robust  */
/* est title: sa */
/* est sto regReg25  */

/* reg swb WS2-WS8 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==6, robust  */
/* est title: esc */
/* est sto regReg26 */

/* reg swb WS2-WS8 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==7, robust  */
/* est title: wsc */
/* est sto regReg27  */

/* reg swb WS2-WS8 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==8, robust  */
/* est title: m */
/* est sto regReg28  */

/* reg swb WS2-WS8 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==9, robust  */
/* est title: p */
/* est sto regReg29  */


/* estout regReg2*  using `tmp'regReg2.tex ,  cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant)drop(*year*) label  starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) */





//------------may17


est drop _all
reg swb  leastUsual mostUsual, robust
est sto a1
reg swb  leastUsual mostUsual realinc, robust beta
est sto a2
reg swb  leastUsual mostUsual realinc  `socDem'   `extCon', robust
est sto a3
reg swb  leastUsual mostUsual realinc  `socDem'   `extCon' hrs1 hea, robust
est sto a4

reg swb  leastUsual mostUsual realinc  `socDem'   `extCon' hrs1 hea, beta

reg swb  leastUsual mostUsual sethrs hr realinc  `socDem'   `extCon' hrs1 hea , robust
est sto a5
//reg swb  c.leastUsual##c.sethrs c.mostUsual##c.sethrs hr realinc  `socDem'   `extCon' hrs1 hea , robust
//est sto a6


estout a*  using `tmp'lm1.tex ,  cells(b(star fmt(%9.2f))) replace style(tex) collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)drop(*region *isco1)
//style: smcl tab fixed tex html   
//by hand
//! sed -i '/^constant/i\occupation and region dummies&no&no&yes&yes&yes&yes\\\\' `tmp'lm.tex
//! scp /tmp/gssLonnie/lm.xlsx akozaryn@rce.hmdc.harvard.edu:~/ 

est drop _all
reg swb  mostLeastUsual, robust
est sto b1
reg swb  mostLeastUsual realinc, robust beta
est sto b2
reg swb  mostLeastUsual realinc  `socDem'   `extCon', robust
est sto b3
reg swb  mostLeastUsual realinc  `socDem'   `extCon' hrs1 hea, robust
est sto b4

reg swb  mostLeastUsual realinc  `socDem'   `extCon' hrs1 hea, beta

reg swb  mostLeastUsual sethrs hr realinc  `socDem'   `extCon' hrs1 hea , robust
est sto b5
//reg swb  c.mostLeastUsual##c.sethrs hr realinc  `socDem'   `extCon' hrs1 hea , robust
//est sto b6

estout b*  using `tmp'mlu1.tex ,  cells(b(star fmt(%9.2f))) replace style(tex) collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)drop(*region *isco1)
//style: smcl tab fixed tex html   
//by hand
! sed -i '/^constant/i\occupation and region dummies&no&no&yes&yes&yes\\\\' `tmp'mlu1.tex
//! scp /tmp/gssLonnie/mlu.xlsx akozaryn@rce.hmdc.harvard.edu:~/ 


est drop _all
reg swb AS2 AS3 AS4, robust
est sto c1
reg swb AS2 AS3 AS4 realinc, robust beta
est sto c2
reg swb AS2 AS3 AS4 realinc  `socDem'   `extCon', robust
est sto c3
reg swb AS2 AS3 AS4 realinc  `socDem'   `extCon' hrs1 hea, robust
est sto c4

reg swb AS2 AS3 AS4 realinc  `socDem'   `extCon' hrs1 hea, beta

reg swb  AS2 AS3 AS4 sethrs hr realinc  `socDem'   `extCon' hrs1 hea , robust
est sto c5
//reg swb  c.advSch##c.sethrs hr realinc  `socDem'   `extCon' hrs1 hea , robust
//est sto a6


//ta swb if SH4==1 & e(sample)==1

estout c*  using `tmp'as1.tex ,  cells(b(star fmt(%9.2f))) replace style(tex) collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)drop(*region *isco1)
! sed -i '/^constant/i\occupation and region dummies&no&no&yes&yes&yes\\\\' `tmp'as1.tex
//! scp /tmp/gssLonnie/as.xlsx akozaryn@rce.hmdc.harvard.edu:~/ 



est drop _all
reg swb WS2 WS3, robust
est sto d1
ta swb if WS3==1 & e(sample)==1

reg swb WS2 WS3 realinc, robust beta
est sto d2
reg swb WS2 WS3 realinc  `socDem'   `extCon', robust
est sto d3
reg swb WS2 WS3 realinc  `socDem'   `extCon' hrs1 hea, robust
est sto d4

reg swb WS2 WS3 realinc  `socDem'   `extCon' hrs1 hea, beta

ta swb if WS3==1 & e(sample)==1


reg swb  WS2 WS3 sethrs hr realinc  `socDem'   `extCon' hrs1 hea , robust
est sto d5
//reg swb  c.wrkshift##c.sethrs hr realinc  `socDem'   `extCon' hrs1 hea , robust
//est sto d6



estout d*  using `tmp'd1.tex ,  cells(b(star fmt(%9.2f))) replace style(tex) collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)drop(*region *isco1)
! sed -i '/^constant/i\occupation and region dummies&no&no&yes&yes&yes\\\\' `tmp'd1.tex



//------------may16

est drop _all
reg swb leasthrs mosthrs, robust
est sto a1
reg swb leasthrs mosthrs realinc, robust beta
est sto a2
reg swb leasthrs mosthrs realinc  `socDem'   `extCon', robust
est sto a3
reg swb leasthrs mosthrs realinc  `socDem'   `extCon' hrs1 hea, robust
est sto a4

estout a*  using `tmp'lm.tex ,  cells(b(star fmt(%9.2f))) replace style(tex) collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)drop(*region *isco1)

! sed -i '/^constant/i\occupation and region dummies&no&no&yes&yes\\\\' `tmp'lm.tex
/* ! sed -i "s|occ:||g" `tmp'sh.tex */
//! sed -i '/^sethours: employer decides/i\who set working hours (base: i decide w/limts):&&&&\\\\' `tmp'sh.tex
//! sed -i "s|sethours: |\\\hspace{.2in}|g" `tmp'sh.tex 

//guess missing this
//most hrs per wk last mo- least hrs per wk last mo) /usual hrs

est drop _all
reg swb WSS2 WSS3, robust
est sto a1
reg swb WSS2 WSS3 realinc, robust beta
est sto a2
reg swb WSS2 WSS3 realinc  `socDem'   `extCon', robust
est sto a3
reg swb WSS2 WSS3 realinc  `socDem'   `extCon' hrs1 hea, robust
est sto a4

estout a*  using `tmp'wss.tex ,  cells(b(star fmt(%9.2f))) replace style(tex) collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)drop(*region *isco1)

! sed -i '/^constant/i\occupation and region dummies&no&no&yes&yes\\\\' `tmp'sh.tex
/* ! sed -i "s|occ:||g" `tmp'sh.tex */
//! sed -i '/^sethours: employer decides/i\who set working hours (base: i decide w/limts):&&&&\\\\' `tmp'sh.tex
//! sed -i "s|sethours: |\\\hspace{.2in}|g" `tmp'sh.tex 





est drop _all
reg swb WSS2 WSS3, robust
est sto a1
reg swb WSS2 WSS3 realinc, robust beta
est sto a2
reg swb WSS2 WSS3 realinc  `socDem'   `extCon', robust
est sto a3
reg swb WSS2 WSS3 realinc  `socDem'   `extCon' hrs1 hea, robust
est sto a4


ta year if e(sample)==1 
ta unemp if e(sample)==1 
ta wrkstat if e(sample)==1 


estout a*  using `tmp'wss.tex ,  cells(b(star fmt(%9.2f))) replace style(tex) collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)drop(*region *isco1)

! sed -i '/^constant/i\occupation and region dummies&no&no&yes&yes\\\\' `tmp'wss.tex
/* ! sed -i "s|occ:||g" `tmp'sh.tex */
//! sed -i '/^sethours: employer decides/i\who set working hours (base: i decide w/limts):&&&&\\\\' `tmp'sh.tex
//! sed -i "s|sethours: |\\\hspace{.2in}|g" `tmp'sh.tex 


! cp /home/aok/papers/root/rr/gssLonnie/tex/gssLonnie.pdf /home/aok/misc/html/theaok.github.io/junk/
! cp /home/aok/papers/root/rr/gssLonnie/aokLead.do /home/aok/misc/html/theaok.github.io/junk/
! cp  /home/aok/data/gss/gss.dta /home/aok/misc/html/theaok.github.io/junk/

! chmod 755 /home/aok/misc/html/theaok.github.io/junk/gssLonnie.pdf


//-------------------------------old
//-------------------------------old
//-------------------------------old


**** regressions
preserve
keep if year<2017
//restore

est drop _all
reg swb SH1 SH3, robust
est sto a1
reg swb SH1 SH3 realinc, robust beta
est sto a2
reg swb SH1 SH3 realinc  `socDem'   `extCon', robust
est sto a3
reg swb SH1 SH3 realinc  `socDem'   `extCon' hrs1 hea, robust
est sto a4


ta year if e(sample)==1 
ta unemp if e(sample)==1 
ta wrkstat if e(sample)==1 


estout a*  using `tmp'sh.tex ,  cells(b(star fmt(%9.2f))) replace style(tex) collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)drop(*region *isco1)

! sed -i '/^constant/i\occupation and region dummies&no&no&yes&yes\\\\' `tmp'sh.tex
/* ! sed -i "s|occ:||g" `tmp'sh.tex */
! sed -i '/^sethours: employer decides/i\who set working hours (base: i decide w/limts):&&&&\\\\' `tmp'sh.tex
! sed -i "s|sethours: |\\\hspace{.2in}|g" `tmp'sh.tex 


** THIS AINT FIT HERE
/*
est drop _all
reg swb HM1 HM3, robust
est sto b1
reg swb HM1 HM3 realinc, robust beta
est sto b2
reg swb HM1 HM3 realinc  `socDem'   `extCon', robust
est sto b3
reg swb HM1 HM3 realinc  `socDem'   `extCon' hrs1 hea, robust
est sto b4

ta year if e(sample)==1 

estout b*  using `tmp'hm.tex ,  cells(b(star fmt(%9.2f))) replace style(tex) collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)drop(*region *isco1)
! sed -i '/^constant/i\occupation and region dummies&no&no&yes&yes\\\\' `tmp'hm.tex
! sed -i '/^hrsmoney: more hrs and money/i\hours v money (base: same and same):&&&&\\\\' `tmp'hm.tex
! sed -i "s|hrsmoney: |\\\hspace{.2in}|g" `tmp'hm.tex 
*/

est drop _all
reg swb CS2 CS3 CS4, robust
est sto c1
reg swb CS2 CS3 CS4 realinc, robust beta
est sto c2
reg swb CS2 CS3 CS4 realinc  `socDem'   `extCon', robust
est sto c3
reg swb CS2 CS3 CS4 realinc  `socDem'   `extCon' hrs1 hea, robust
est sto c4

ta year if e(sample)==1 

estout c*  using `tmp'cs.tex ,  cells(b(star fmt(%9.2f))) replace style(tex) collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)drop(*region *isco1)
! sed -i '/^constant/i\occupation and region dummies&no&no&yes&yes\\\\' `tmp'cs.tex
/* ! sed -i "s|occ:||g" `tmp'ip2.tex */
! sed -i '/^chn_sch==rarely/i\can change schedule (base: never):&&&&\\\\' `tmp'cs.tex
! sed -i "s|chn_sch==|\\\hspace{.2in}|g" `tmp'cs.tex 


est drop _all
reg swb FW2 FW3 FW4, robust
est sto d1
reg swb FW2 FW3 FW4 realinc, robust beta
est sto d2
reg swb FW2 FW3 FW4 realinc `socDem' `extCon', robust
est sto d3
reg swb FW2 FW3 FW4 realinc `socDem' `extCon' hrs1 hea, robust
est sto d4

ta year if e(sample)==1 

estout d*  using `tmp'fw.tex ,  cells(b(star fmt(%9.2f))) replace style(tex) collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)drop(*region *isco1)
! sed -i '/^constant/i\occupation and region dummies&no&no&yes&yes\\\\' `tmp'fw.tex
/* ! sed -i "s|occ:||g" `tmp'ip2.tex */
! sed -i '/^famwkoff==somewhat hard/i\not hard to take time off (base: very hard):&&&&\\\\' `tmp'fw.tex
! sed -i "s|famwkoff==|\\\hspace{.2in}|g" `tmp'fw.tex 

est drop _all
reg swb SH1 SH3 realinc  `socDem'   `extCon', robust
estadd beta
est sto a3beta
reg swb SH1 SH3 realinc  `socDem'   `extCon' hrs1 hea, robust
estadd beta
est sto a4beta
reg swb CS2 CS3 CS4 realinc  `socDem'   `extCon', robust
estadd beta
est sto c3beta
reg swb CS2 CS3 CS4 realinc  `socDem'   `extCon' hrs1 hea, robust
estadd beta
est sto c4beta
reg swb FW2 FW3 FW4 realinc `socDem' `extCon', robust
estadd beta
est sto d3beta
reg swb FW2 FW3 FW4 realinc `socDem' `extCon' hrs1 hea, robust
estadd beta
est sto d4beta

ta year if e(sample)==1 

estout *beta  using `tmp'beta.tex ,  cells(beta(star fmt(%9.2f))) replace style(tex) collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)drop(*region *isco1)order(SH*  CS* FW*)


! sed -i '/^constant/i\occupation and region dummies&yes&yes&yes&yes&yes&yes\\\\' `tmp'beta.tex

! sed -i '/^sethours: employer decides/i\who set working hours (base: i decide w/limts):&&&&\\\\' `tmp'beta.tex
! sed -i "s|sethours: |\\\hspace{.2in}|g" `tmp'beta.tex 

! sed -i '/^hrsmoney: more hrs and money/i\hours v money (base: same and same):&&&&\\\\' `tmp'beta.tex
! sed -i "s|hrsmoney: |\\\hspace{.2in}|g" `tmp'beta.tex 

! sed -i '/^chn_sch==rarely/i\can change schedule (base: never):&&&&\\\\' `tmp'beta.tex
! sed -i "s|chn_sch==|\\\hspace{.2in}|g" `tmp'beta.tex 

! sed -i '/^famwkoff==somewhat hard/i\not hard to take time off (base: very hard):&&&&\\\\' `tmp'beta.tex
! sed -i "s|famwkoff==|\\\hspace{.2in}|g" `tmp'beta.tex 


est drop _all
reg swb sethours realinc  `socDem'   `extCon', robust
estadd beta
est sto a3beta
reg swb sethours realinc  `socDem'   `extCon' hrs1 hea, robust
estadd beta
est sto a4beta
reg swb chn_sch realinc  `socDem'   `extCon', robust
estadd beta
est sto c3beta
reg swb chn_sch realinc  `socDem'   `extCon' hrs1 hea, robust
estadd beta
est sto c4beta
reg swb famwkoff realinc `socDem' `extCon', robust
estadd beta
est sto d3beta
reg swb famwkoff realinc `socDem' `extCon' hrs1 hea, robust
estadd beta
est sto d4beta

ta year if e(sample)==1 

estout *beta  using `tmp'beta2.tex ,  cells(beta(star fmt(%9.2f))) replace style(tex) collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)drop(*region *isco1)order(sethours chn_sch famwkoff)


! sed -i '/^constant/i\occupation and region dummies&yes&yes&yes&yes&yes&yes\\\\' `tmp'beta2.tex

! sed -i '/^sethours: employer decides/i\who set working hours (base: i decide w/limts):&&&&\\\\' `tmp'beta2.tex
! sed -i "s|sethours: |\\\hspace{.2in}|g" `tmp'beta2.tex 

! sed -i '/^hrsmoney: more hrs and money/i\hours v money (base: same and same):&&&&\\\\' `tmp'beta2.tex
! sed -i "s|hrsmoney: |\\\hspace{.2in}|g" `tmp'beta2.tex 

! sed -i '/^chn_sch==rarely/i\can change schedule (base: never):&&&&\\\\' `tmp'beta2.tex
! sed -i "s|chn_sch==|\\\hspace{.2in}|g" `tmp'beta2.tex 

! sed -i '/^famwkoff==somewhat hard/i\not hard to take time off (base: very hard):&&&&\\\\' `tmp'beta2.tex
! sed -i "s|famwkoff==|\\\hspace{.2in}|g" `tmp'beta2.tex 



///////
! cp /home/aok/papers/root/rr/gssLonnie/tex/gssLonnie.pdf /home/aok/misc/html/theaok.github.io/junk/
! cp /home/aok/papers/root/rr/gssLonnie/aokLead.do /home/aok/misc/html/theaok.github.io/junk/
! cp  /home/aok/data/gss/gss.dta /home/aok/misc/html/theaok.github.io/junk/

! chmod 755 /home/aok/misc/html/theaok.github.io/junk/gssLonnie.pdf

###############################################################################

**** OLD

//LATER add more vars from n.org etc
caplog using `tmp'des.txt, replace: d  hrs1 hrs2 commute satjob jobmeans getahead fepresch moredays mustwork wktopsat hrsmoney workhr C2 hrs_c full_part   wrkwell wrkmuch presfrst prespop job_all hrsrelax hrs_c  fle_hou all_fle imp_fle fle_houV2 shift chn_sch wrk_hme why_hme wrkstat

caplog using `tmp'des.txt, append:sum hrs1 hrs2 commute satjob jobmeans getahead fepresch moredays mustwork wktopsat hrsmoney workhr C2 hrs_c full_part   wrkwell wrkmuch presfrst prespop job_all hrsrelax hrs_c  fle_hou all_fle imp_fle fle_houV2 shift chn_sch wrk_hme why_hme wrkstat

caplog using `tmp'des.txt, append:codebook hrs1 hrs2 commute satjob jobmeans getahead fepresch moredays mustwork wktopsat hrsmoney workhr C2 hrs_c full_part   wrkwell wrkmuch presfrst prespop job_all hrsrelax hrs_c  fle_hou all_fle imp_fle fle_houV2 shift chn_sch wrk_hme why_hme wrkstat , ta(100)


****lonnie_issp_work.tex [mostly stuff that i am interested in]



**  unemployment-antifrigile 

guess unhealthy and old and unemployed may be really miserable etc

   unemp; underemp--whose happiness they kill most; start with
   baseline model and then add vars; interactions; subsample

see  lonnie_ideas.tex per taleb antifrigile: professional occupations, hi prestge
and income--are most affected by unemployment



*** MALE flips by gender :) and fem swb 40hrs; males a lot hrs!

//TODO females: not much about females but about females with a kid in a house!!



interesting!!!
preserve
keep if male==0
aok_barcap, dv(swb) by(hrs_c)s(/tmp/g1)
restore
preserve
keep if male==1
aok_barcap, dv(swb) by(hrs_c)s(/tmp/g1)
restore

! convert /tmp/g1.eps /tmp/g1.png 
! scp /tmp/g1.png akozaryn@rce.hmdc.harvard.edu:~/public_html/


fvset base 1972 year

est drop _all

reg swb hrs1 inc age age2  mar un ed hompop hea rep dem con lib i.isco1 i.year, robust
est title: all
est sto male11
reg swb hrs1 inc age age2  mar un ed  hompop hea rep dem con lib i.isco1 i.year if male==1 , robust
est title: male
est sto male12
reg swb hrs1 inc age age2  mar un ed hompop hea rep dem con lib i.isco1 i.year if male==0, robust
est title: female
est sto male13

reg swb HH1-HH3 HH5-HH7 inc age age2  mar un ed hompop hea rep dem con lib i.isco1 i.year , robust
est title: all
est sto male21
reg swb HH1-HH3 HH5-HH7 inc age age2  mar un ed hompop hea rep dem con lib i.isco1 i.year if male==1, robust
est title: male
est sto male22
reg swb HH1-HH3 HH5-HH7 inc age age2  mar un ed hompop hea rep dem con lib i.isco1 i.year if male==0, robust
est title: female
est sto male23

reg swb WS2-WS8 inc age age2  mar  ed hompop hea rep dem con lib i.isco1 i.year , robust
est title: all
est sto male31
reg swb WS2-WS8 inc age age2  mar  ed hompop hea rep dem con lib i.isco1 i.year if male==1, robust
est title: male
est sto male32
reg swb WS2-WS8 inc age age2  mar  ed hompop hea rep dem con lib i.isco1 i.year if male==0, robust
est title: female
est sto male33


estout male*  using `tmp'regMale.tex ,  cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant)drop(*year*) label  starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)


loc dv swb
loc iv hrs1
loc c male

mlogit `dv' c.`iv'##i.`c' inc age age2 inc mar un ed hompop rep dem con lib hea i.isco1 i.year, robust 


margins `c',  at(`iv'=(0(10)100))  vce(uncond)  predict(outcome(1))
marginsplot, x(`iv') name(g1,replace) plot1opts(lpattern(dot))title(" ")legend(off)
margins `c',  at(`iv'=(0(10)100))  vce(uncond)  predict(outcome(2))
marginsplot, x(`iv') name(g2,replace) plot1opts(lpattern(dot))title(" ")legend(off)
margins `c',  at(`iv'=(0(10)100))  vce(uncond)  predict(outcome(3))
marginsplot, x(`iv') name(g3,replace) plot1opts(lpattern(dot))title(" ")legend(off)

graph combine g1 g2 g3,   //ycommon--may be useful...
gr export `tmp'mMale.eps,replace
! epstopdf `tmp'mMale.eps
! acroread  `tmp'mMale.pdf



*** SIZ



reg swb c.hrs1##i.siz age age2 inc mar un ed hea hompop male i.year, robust 

reg swb c.hrs1##i.siz age age2 inc mar un ed hea hompop rep dem con lib male i.isco1 i.year, robust 

codebook xnorcsiz, ta(100)
reg swb c.hrs1##i.xnorcsiz age age2 inc mar un ed hea hompop male i.year, robust 

codebook srcbelt, ta(100)
reg swb c.hrs1##i.srcbelt age age2 inc mar un ed hea hompop male i.year, robust 

reg swb c.hrs1##i.srcbelt age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year, robust 


bys siz: reg swb  hrs1 age age2 inc mar un ed hea hompop, robust
bys siz: reg swb  i.hrs_c age age2 inc mar un ed hea hompop, robust
//aha ! only in biggest cities people are swb to work a lot--workaholiics
//aha! if anything in smaller places people less swb to work more

codebook wrks
bys siz: reg swb i.wrks age age2 inc mar un ed hea hompop male rep dem con lib i.year, robust


codebook xnorcsiz, ta(100) //same here
bys xnorcsiz: reg swb  hrs1 age age2 inc mar un ed hea hompop, robust

//this may have to do with types of occup in largest vs smallest areas

reg swb c.hrs1##c.size age age2 inc mar un ed hea hompop male i.year, robust



/* codebook siz, ta(100) */

/* preserve */
/* keep if siz==1 */
/* aok_barcap, dv(swb) by(hrs_c)s(/tmp/lonnie_issp_work/barHrsSiz1) */
/* restore */
/* preserve */
/* keep if siz==2 */
/* aok_barcap, dv(swb) by(hrs_c)s(/tmp/lonnie_issp_work/barHrsSiz1) */
/* restore */
/* preserve */
/* keep if siz==3 */
/* aok_barcap, dv(swb) by(hrs_c)s(/tmp/lonnie_issp_work/barHrsSiz1) */
/* restore */
/* preserve */
/* keep if siz==4 */
/* aok_barcap, dv(swb) by(hrs_c)s(/tmp/lonnie_issp_work/barHrsSiz1) */
/* restore */


/* gr hbar swb, over(hrs_c)over(siz) */
/* gr export `tmp'g1.eps, replace */
/* ! epstopdf `tmp'g1.eps */
/* ! acroread `tmp'g1.pdf */
//patterns are thener but not v significant in regressions



est drop _all


reg swb HH1-HH3 HH5-HH7 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if siz==1, robust
est title: large
est sto regSiz1
reg swb HH1-HH3 HH5-HH7 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if siz==2, robust
est title: med
est sto regSiz2
reg swb HH1-HH3 HH5-HH7 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if siz==3, robust
est title: sub
est sto regSiz3
reg swb HH1-HH3 HH5-HH7 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if siz==4, robust
est title: rur
est sto regSiz4

reg swb WS2-WS8 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if siz==1, robust
est title: large
est sto regSiz21
reg swb WS2-WS8 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if siz==2, robust
est title: med
est sto regSiz22
reg swb WS2-WS8 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if siz==3, robust
est title: sub
est sto regSiz23
reg swb WS2-WS8 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if siz==4, robust
est title: rur
est sto regSiz24

estout regSiz*  using `tmp'regSiz.tex ,  cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant)drop(*year*) label  starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)


loc dv swb
loc iv hrs1
loc c siz

mlogit `dv' c.`iv'##i.`c' inc age age2 mar un ed hompop hea male rep dem con lib i.year, robust 


margins `c',  at(`iv'=(0(10)100))  vce(uncond)  predict(outcome(1))
marginsplot, x(`iv') name(g1,replace) title(" ")
gr export `tmp'mSizNH.eps,replace
! epstopdf `tmp'mSizNH.eps
! acroread  `tmp'mSizNH.pdf

margins `c',  at(`iv'=(0(10)100))  vce(uncond)  predict(outcome(2))
marginsplot, x(`iv') name(g2,replace) title(" ")
gr export `tmp'mSizPH.eps,replace
! epstopdf `tmp'mSizPH.eps
! acroread  `tmp'mSizPH.pdf

margins `c',  at(`iv'=(0(10)100))  vce(uncond)  predict(outcome(3))
marginsplot, x(`iv') name(g3,replace) title(" ")
gr export `tmp'mSizVH.eps,replace
! epstopdf `tmp'mSizVH.eps
! acroread  `tmp'mSizVH.pdf


//graph combine g1 g2 g3,   // ycommon--may be useful...


  

** REG by censis region
bys region: reg swb  hrs1 age age2 inc mar un ed hea hompop male i.year, robust
//aha in midde atlantic people are swb to work more; in south atlantic, like to work less; though not very signiifcant
//LATER may also see if they value anywhere flexy hours more...

codebook region

reg swb c.hrs1##i.region age age2 inc mar un ed hea hompop male i.year, robust 


//TODO may want to combine similar places for final paper and have this in the online appendix

est drop _all

reg swb c.hrs1 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==1, robust 
est title: ne
est sto regReg1 

reg swb c.hrs1 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==2, robust 
est title: me
est sto regReg2 

reg swb c.hrs1 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==3, robust 
est title: enc
est sto regReg3 

reg swb c.hrs1 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==4, robust 
est title: wnc
est sto regReg4 

reg swb c.hrs1 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==5, robust 
est title: sa
est sto regReg5 

reg swb c.hrs1 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==6, robust 
est title: esc
est sto regReg6

reg swb c.hrs1 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==7, robust 
est title: wsc
est sto regReg7 

reg swb c.hrs1 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==8, robust 
est title: m
est sto regReg8 

reg swb c.hrs1 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==9, robust 
est title: p
est sto regReg9 


estout regReg*  using `tmp'regReg.tex ,  cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant)drop(*year*) label  starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)


est drop _all


reg swb WS2-WS8 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==1, robust 
est title: ne
est sto regReg21 

reg swb WS2-WS8 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==2, robust 
est title: me
est sto regReg22 

reg swb WS2-WS8 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==3, robust 
est title: enc
est sto regReg23 

reg swb WS2-WS8 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==4, robust 
est title: wnc
est sto regReg24 

reg swb WS2-WS8 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==5, robust 
est title: sa
est sto regReg25 

reg swb WS2-WS8 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==6, robust 
est title: esc
est sto regReg26

reg swb WS2-WS8 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==7, robust 
est title: wsc
est sto regReg27 

reg swb WS2-WS8 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==8, robust 
est title: m
est sto regReg28 

reg swb WS2-WS8 age age2 inc mar un ed hea hompop male rep dem con lib i.isco1 i.year  if region==9, robust 
est title: p
est sto regReg29 


estout regReg2*  using `tmp'regReg2.tex ,  cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant)drop(*year*) label  starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)





*************************************************************************



*** other experimentation




** rel: not that much

codebook relig, ta(100)

reg swb hrs1 age age2 inc mar un ed hea hompop if relig==1
reg swb hrs1 age age2 inc mar un ed hea hompop if relig==2
reg swb hrs1 age age2 inc mar un ed hea hompop if relig==3
reg swb hrs1 age age2 inc mar un ed hea hompop if relig==4



** rep dem: nah

codebook partyid
codebook polviews

//nah
reg swb hrs1 age age2 inc mar un ed hea hompop if partyid==1
reg swb hrs1 age age2 inc mar un ed hea hompop if partyid==6

reg swb hrs1 age age2 inc mar un ed hea hompop if polviews==1
reg swb hrs1 age age2 inc mar un ed hea hompop if polviews==7

bys polviews: reg swb hrs1 age age2 inc mar un ed hea hompop


** otehr


//interesting--working a lot a middle class value...
bys class_: reg swb hrs1 age age2 inc mar un ed hea hompop 

//interetinginly--administrative like to work
bys isco1: reg swb hrs1 age age2 inc mar un ed hea hompop 

bys jobmeans: reg swb hrs1 age age2 inc mar un ed hea hompop 


** different forms of hours

reg swb  hrs1 age age2 inc mar un ed hea hompop, robust
ta  hrs1 hrs_c
reg swb  i.hrs_c age age2 inc mar un ed hea hompop, robust


ta hrs1



************************************************************************
************************************************************************


*******************addH


**** dat_man


//LATER more addH cool public use data at icpsr--contetual vars etc...possibly already dwnloaded--just merge them !



**wave4 ds0023

/* sec11 really cool vars!; also sec25: minutes commute :) */
/* can just do a bunch of des stats... with mental health and work schedule */

/* use /home/aok/data/addH_National_Longitudinal_Study_of_Adolescent_Health/ICPSR_21600/DS0023/21600-0023-Data.dta,clear */

/* count //ony 5k obs */

/* d H4LM* */
/* lookfor happ */

/* d H4MH* //a lot mental health annswers here.... */

/* H4LM26 job satis */


**wave3 ds0012 //the only wave with ls; but cn hack other waves as per deneve12

use ~/data/addH_National_Longitudinal_Study_of_Adolescent_Health/ICPSR_21600/DS0012/21600-0012-Data.dta,clear

//cleaning missing
run ~/data/addH_National_Longitudinal_Study_of_Adolescent_Health/ICPSR_21600/DS0012/21600-0012-Supplemental_syntax.do

save `tmp'a1,replace


**weighting //TODO recheck this; talk to people--e.g. dan hart, bob atkins...


//see:
//21600-0022-Documentation.pdf
//21600-0022-Documentation-correct-design-effects.pdf (!!!had to dwnld separtely from ICPSR)
//21600-0022-Codebook.pdf

//and wt_guidelines.pdf in top dir; also about hlm here

//from googleing:
//svyset [pweight=gswgt1], strata(region) psu(psuscid)
//svyset psuscid [pweight=gswgt1], strata(region)

use ~/data/addH_National_Longitudinal_Study_of_Adolescent_Health/ICPSR_21600/DS0022/21600-0022-Data.dta,clear
d

merge 1:1 AID using `tmp'a1
drop _merge

//if panel then use GSWGT3; guess no strata...not sure about cluster...
svyset [pweight=GSWGT3_2]



**recoding etc


ren H3LM28 ls_job


ren  H3SP3 ls
revrs ls, replace
la var ls "happiness"
note ls: "How satisfied are you with your life as a whole?"
//LATER also similar vars in H3SP* cried, laughed etc

//LATER i bet there was an ls q with a ladder when i was looking at it earlier--may search or gog around;or guess just this one about social standing H4EC19


ren H3GH1 hea
la var hea "general health"
note hea: "In general, how is your health?"
revrs hea, replace

ren H3DA18 chi6
la var chi6 "children$<$6"
//H3DA18 is ofr children 6-12


** time use [many more see sect33]

ren H3GH11H wak_up
la var wak_up "hour usually wake up"

ren H3GH12H got_sl
la var got_sl "hour usually go to sleep"

//may calculate from wak_up and got_sl hrs of sleep; better yet search such v



** work


ren H3LM1 had_job
la var had_job "ever had a job"
note had_job: "Have you ever had a job? Don't count being in the military and don't count jobs such as babysitting or lawn mowing unless you were working for a business."

ren H3LM7 cur_wor
la var cur_wor "work for pay $>10hrs/wk$"
note cur_wor: "Are you currently working for pay for at least 10 hours a week?"

ren H3LM9 fir_job_age
la var fir_job_age "age at first job"
note fir_job_age: "How old were you when you began your FIRST paying job that lasted for nine weeks or more and where you worked at least 10 hours a week?" 

ren H3LM14 job_num
la var job_num "how many jobs"
note job_num: "At how many jobs are you now working for pay?"

ren H3LM16 wor_hou_job
la var wor_hou_job "work hours/wk at this job"
note wor_hou_job: "How many hours a week do you usually work at this job?"

ren H3DA31 wor_hou
la var wor_hou "work hrs/wk"
note wor_hou: "How many hours a week do you usually spend at work?"

ren H3DA32 har_phy
la var har_phy "hard physical work hrs/wk"
note har_phy: "On the average, how many hours a week at work do you spend standing, doing hard physical work (for example, doing construction work )?"

ren H3DA33 med_phy
la var med_phy "med physical work hrs/wk"
note med_phy: "On the average, how many hours a week at work do you spend standing, doing moderate physical work (for example, nursing or being a mechanic)?"

ren H3LM27 shift 
la var shift "shift type"
note shift: "Which of these categories best describes the hours you work at this job?"  Day, evening, night, rotating shift, etc


//H3LM...also monthly, weekly, hourly etc wages
//H3LM28 job satis
codebook H3LM10, ta(100) //work type

** commute

ren H3DA30 miles
la var miles "miles commute"
note miles: "How many miles must you travel each work day from where you live to where you work?"


/* How do you get to and from your school or program? Indicate as many kinds of */
/* transportation as you use. */
/* ta H3DA38A, B, C etc car, bus etc */


** soc/dem

ren H3EC2 inc
la var inc "income in 2000/01"
note  inc: "Including all the income sources you reported above, what was your total personal income before taxes in 2000/2001?"


** gen additional vars

_pctile inc, nq(10)
return list
xtile inc10 =  wor_hou, nq(10)


//xtile wor_hou5 =  wor_hou, nq(5) //BUG doesn't work...
_pctile wor_hou, nq(5)
return list  //aha ! bs everyone has 40 hrs..
_pctile wor_hou, nq(10)
return list  //aha ! bs everyone has 40 hrs..
//so may do it by hand as in ditella paper...

gen wor_hou2=wor_hou^2

recode wor_hou (0/19=1)(nonm=0) ,gen(wh0_19)
recode wor_hou (20/39=1)(nonm=0) ,gen(wh20_39)
recode wor_hou (40=1)(nonm=0) ,gen(wh40)
recode wor_hou (41/55=1)(nonm=0) ,gen(wh41_55)
recode wor_hou (56/120=1)(nonm=0) ,gen(wh56_120)

ta  wor_hou wh0_19, mi
ta  wor_hou wh20_39, mi
ta  wor_hou wh40, mi
ta  wor_hou wh41_55, mi
ta  wor_hou wh56_120, mi


_pctile miles, nq(5)
return list
xtile miles5 =  miles, nq(5)



** cleaning missings--don't need this used icpsr generic code at the beginning  

/* loc x ls ls_job  wak_up got_sl had_job cur_wor fir_job_age job_num wor_hou_job wor_hou har_phy med_phy shift inc */

/* foreach v of varlist  `x' { */
/* codebook `x', ta(100) */
/* } */

/* //LATER may wanna have differnet tyoes of mis dependeing on why missing */
/* //remember missingness is also information */
/* foreach v of   */
/* replace `v'=. if `v '== 96 |`v '== 97 |`v '== 98 | `v '== 99 */
/* } */


/* foreach v of wor_hou_job wor_hou har_phy med_phy { */
/* replace  `v'=. if `v '== 996 |`v '== 997 |`v '== 998 | `v '== 999 */
/* } */



**** sum_sts


//TODO need to weight it!!

aok_var_des , ff(cre00 boh00 art90 chu_per50 mem_per50 totrt adj) fname(`tmp'var_des)
aok_histograms for the appendix
TODO add more aok_cool programs ! :))



**** ana
  

run reg see if they make sense

reg ls inc10 miles wor_hou wor_hou2 , robust
//ologit ls inc miles wor_hou wor_hou2, robust
svy:reg ls inc10 miles wor_hou wor_hou2

//hmm weird
reg ls inc10 miles wh0_19 wh20_39 wh41_55 wh56_120 chi6, robust
svy:reg ls inc10 miles wh0_19 wh20_39 wh41_55 wh56_120 chi6

reg ls inc10 miles wor_hou, robust
reg ls inc10 miles wor_hou_job, robust //ha weird


//350000  Food preparation/serving related
//410000  Sales and related occupation
reg ls inc10 wor_hou, robust
reg ls inc10 wor_hou if H3LM10==350000, robust
reg ls inc10 wor_hou if H3LM10==410000, robust

bys H3LM10: reg ls inc10 wor_hou, robust


//evening shift is not good
svy: reg ls inc10 miles wor_hou har_phy i.shift
reg ls inc10 miles wor_hou har_phy i.shift hea, robust
reg ls inc10 i.shift, robust

reg ls inc10 i.shift wak_up got_sl hea, robust

svy: reg ls inc10 miles wor_hou har_phy i.job_num
reg ls inc10 miles wor_hou har_phy i.job_num, robust

//nice to wake up early; todo break it into dummies--thse who wake up late may be depressed; but also if wake up suprer early
reg ls inc10 miles wor_hou har_phy wak_up, robust

//going to sleep late is good; again break up into dummies--to late no good
reg ls inc10 miles wor_hou har_phy wak_up got_sl, robust

bys wak_up: reg ls inc10 wor_hou, robust
bys got_sl: reg ls inc10 wor_hou, robust

reg ls inc10 i.miles5 wor_hou har_phy wak_up got_sl, robust
svy:reg ls inc10 i.miles5 


//guess evening shoft stronget predictor so far
//health kills everything except evening shift...


//TODO need to control for more usual predictors--marital, educ, etc etc



//file close tex
