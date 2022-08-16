// see what happened with codeing of otehr candidates at the beginning 
stata
*gss_pol                              
*//####################################
loc d="/home/aok/papers/root/old/2011/gss_town_AND_politics/"        
*loc d="/nfs/projects/a/akozyarn/gss/"
loc g="/home/aok/papers/root/"  
*//####################################
capture mkdir "`d'tex"                 
capture mkdir "`d'out"                 
capture mkdir "`d'out/base"
capture mkdir "`d'to_give"             
capture mkdir "`d'lit"                 
capture mkdir "`d'base"                
capture mkdir "`d'scrap"
capture log close                      
log using "`d'gss_pol.log", replace   
clear                                  
set mem 100m                           
version 10                             
set more off                           
run /home/aok/papers/root/do/aok_programs.do
  
/***********************************/
/* do ~/desk/papers/root/do/gss.do */
/***********************************/

/*********************/
/* /\*************\/ */
/* /\* data mgmt *\/ */
/* /\*************\/ */
/*********************/
                                                    
//use `g'adam_data/gss/aok_gss, clear
//use ~/Desktop/aok_gss, clear
use /mnt/f0/backup/20110608/aok/desk/papers/root/adam_data/gss/aok_gss.dta,clear

gen per=.
replace per = 1 if year ==1972  
replace per = 2 if year ==1973
replace per = 3 if year ==1974
replace per = 4 if year ==1975
replace per = 5 if year ==1976
replace per = 6 if year ==1977
replace per = 7 if year ==1978
replace per = 8 if year ==1980
replace per = 9 if year ==1982
replace per = 10 if year ==1983
replace per = 11 if year ==1984
replace per = 12 if year ==1985
replace per = 13 if year ==1986
replace per = 14 if year ==1987
replace per = 15 if year ==1988
replace per = 16 if year ==1989
replace per = 17 if year ==1990
replace per = 18 if year ==1991
replace per = 19 if year ==1993
replace per = 20 if year ==1994
replace per = 21 if year ==1996
replace per = 22 if year ==1998
replace per = 23 if year ==2000
replace per = 24 if year ==2002
replace per = 25 if year ==2004
replace per = 26 if year ==2006
replace per = 27 if year ==2008
 

recode rid (1=1 "R")(2=.)(3=2 "D"), gen(rd)
recode cml (1=1 "C")(2=.)(3=2 "L"), gen(cl)


//---
/* foreach i in "68" "72" "76" "80" "84" "88" "92" "96" "00" "04"{ */
/* codebook pres`i' */
/* } */
replace pres68=. if pres68==5
replace pres72=. if pres72==4|pres72==5
replace pres76=. if pres76==4|pres76==5
replace pres80=. if pres80==5|pres80==6
replace pres84=. if pres84==4|pres84==5
replace pres88=. if pres88==4|pres88==5
replace pres92=. if pres92==6
replace pres96=. if pres96==6
replace pres00=. if pres00==6
replace pres04=. if pres04==6
//---


capture drop vr
gen vr=.
la var vr"voted republican"
gen year5=year-5

foreach i in "68" "72" "76" "80" "84" "88" "92" "96" "00" "04"{

if ("`i'"=="68")  local ii= "1968"
if ("`i'"=="72")  local ii= "1972"
if ("`i'"=="76")  local ii= "1976"
if ("`i'"=="80")  local ii= "1980"
if ("`i'"=="84")  local ii= "1984"
if ("`i'"=="88")  local ii= "1988"
if ("`i'"=="92")  local ii= "1992"
if ("`i'"=="96")  local ii= "1996"
if ("`i'"=="00")  local ii= "2000"
if ("`i'"=="04")  local ii= "2004"
replace vr=0 if ((pres`i' ==1 |pres`i' ==3|pres`i' ==4 )  & missing(vr))  & `ii'< year &  `ii'> year5
replace vr=1 if  (pres`i' ==2  & missing(vr))  & `ii'< year &  `ii'> year5
}
codebook vr 


capture drop vd
gen vd=.
la var vd"voted democrat"

foreach i in "68" "72" "76" "80" "84" "88" "92" "96" "00" "04"{

if ("`i'"=="68")  local ii= "1968"
if ("`i'"=="72")  local ii= "1972"
if ("`i'"=="76")  local ii= "1976"
if ("`i'"=="80")  local ii= "1980"
if ("`i'"=="84")  local ii= "1984"
if ("`i'"=="88")  local ii= "1988"
if ("`i'"=="92")  local ii= "1992"
if ("`i'"=="96")  local ii= "1996"
if ("`i'"=="00")  local ii= "2000"
if ("`i'"=="04")  local ii= "2004"
replace vd=0 if ((pres`i' ==2 |pres`i' ==3|pres`i' ==4  )  & missing(vd))  & `ii'< year &  `ii'> year5
replace vd=1 if  (pres`i' ==1  & missing(vd))  & `ii'< year &  `ii'> year5
}

  
capture drop vo
gen vo=.
la var vo"voted other"

foreach i in "68" "72" "76" "80" "84" "88" "92" "96" "00" "04"{

if ("`i'"=="68")  local ii= "1968"
if ("`i'"=="72")  local ii= "1972"
if ("`i'"=="76")  local ii= "1976"
if ("`i'"=="80")  local ii= "1980"
if ("`i'"=="84")  local ii= "1984"
if ("`i'"=="88")  local ii= "1988"
if ("`i'"=="92")  local ii= "1992"
if ("`i'"=="96")  local ii= "1996"
if ("`i'"=="00")  local ii= "2000"
if ("`i'"=="04")  local ii= "2004"
replace vo=0 if ((pres`i' ==1 |pres`i' ==2)  & missing(vo))  & `ii'< year &  `ii'> year5
replace vo=1 if  (pres`i' ==3|pres`i' ==4  & missing(vo))  & `ii'< year &  `ii'> year5
}


//--now drop all other candidates
gen vdd=.
la var vdd "Democrat (vs R only)"
gen vrr=.
la var vrr "Republican (vs D only)"

foreach i in "68" "72" "76" "80" "84" "88" "92" "96" "00" "04"{
replace pres`i'=. if pres`i'>2
}

foreach i in "68" "72" "76" "80" "84" "88" "92" "96" "00" "04"{


if ("`i'"=="68")  local ii= "1968"
if ("`i'"=="72")  local ii= "1972"
if ("`i'"=="76")  local ii= "1976"
if ("`i'"=="80")  local ii= "1980"
if ("`i'"=="84")  local ii= "1984"
if ("`i'"=="88")  local ii= "1988"
if ("`i'"=="92")  local ii= "1992"
if ("`i'"=="96")  local ii= "1996"
if ("`i'"=="00")  local ii= "2000"
if ("`i'"=="04")  local ii= "2004"

  
replace vdd=0 if ((pres`i' ==2)  & missing(vdd))  & `ii'< year &  `ii'> year5
replace vdd=1 if  (pres`i' ==1  & missing(vdd))  & `ii'< year &  `ii'> year5

replace vrr=0 if ((pres`i' ==1)  & missing(vrr))  & `ii'< year &  `ii'> year5
replace vrr=1 if  (pres`i' ==2  & missing(vrr))  & `ii'< year &  `ii'> year5
}

ta  pres72 vr if year==1977, mi
ta  pres76 vr if year==1977, mi

save  `d'base/cycles1.dta, replace
//----------------------------------------------------------------------------------
//----------------------------------------------------------------------------------
//----------------------------------------------------------------------------------

  
//-----------------------------------------trying different filters---------------------------------------
use `d'base/cycles1.dta, clear

ta rid cml
ta  cml rid,cell
table cml rid,c(mean happy) format(%9.2f)
table cml rid,c(sd happy) format(%9.2f)


//we really do not need independents!
  
/* aok_ts  ,d(`d')filter(w(4 1 5)) gr_name(ls_rid10) note(10ma) dv(happy) by(rid) over(year)ylab( )  */
/* aok_ts  ,d(`d')filter(w(2 1 2)) gr_name(ls_rid5) note(5ma) dv(happy) by(rid) over(year)ylab( )  */
/* aok_ts  ,d(`d')filter(w(1 1 1)) gr_name(ls_rid3) note(3ma) dv(happy) by(rid) over(year)ylab( )  */

/* aok_ts  ,d(`d')filter(w(4 1 5)) gr_name(ls_cml10) note(10ma) dv(happy) by(cml) over(year)ylab( )  */
/* aok_ts  ,d(`d')filter(w(2 1 2)) gr_name(ls_cml5) note(5ma) dv(happy) by(cml) over(year)ylab( )  */
/* aok_ts  ,d(`d')filter(w(1 1 1)) gr_name(ls_cml3) note(3ma) dv(happy) by(cml) over(year)ylab( )  */

/* preserve */
/* keep if rid==2 */
/* aok_ts  ,d(`d')filter(w(4 1 5)) gr_name(ind_ls_cml10) note(only independents 10ma) dv(happy) by(cml) over(year)ylab( )  */
/* aok_ts  ,d(`d')filter(w(2 1 2)) gr_name(ind_ls_cml5) note(only independents 5ma) dv(happy) by(cml) over(year)ylab( )  */
/* aok_ts  ,d(`d')filter(w(1 1 1)) gr_name(ind_ls_cml3) note(only independents 3ma) dv(happy) by(cml) over(year)ylab( )  */
/* restore */

//dropping middle independents

/* aok_ts  ,d(`d')filter(w(4 1 5)) gr_name(ls2_rd10) note(10ma) dv(happy) by(rd) over(year)ylab( )  */
/* aok_ts  ,d(`d')filter(w(2 1 2)) gr_name(ls2_rd5) note(5ma) dv(happy) by(rd) over(year)ylab( )  */
/* aok_ts  ,d(`d')filter(w(1 1 1)) gr_name(ls2_rd3) note(3ma) dv(happy) by(rd) over(year)ylab( )  */

/* aok_ts  ,d(`d')filter(w(4 1 5)) gr_name(ls2_cl10) note(10ma) dv(happy) by(cl) over(year)ylab( )  */
/* aok_ts  ,d(`d')filter(w(2 1 2)) gr_name(ls2_cl5) note(5ma) dv(happy) by(cl) over(year)ylab( )  */
/* aok_ts  ,d(`d')filter(w(1 1 1)) gr_name(ls2_cl3) note(3ma) dv(happy) by(cl) over(year)ylab( )  */


/* preserve */
/* keep if rid==2 */
/* aok_ts  ,d(`d')filter(w(4 1 5)) gr_name(ind_ls2_cl10) note(only independents 10ma) dv(happy) by(cl) over(year)ylab( )  */
/* aok_ts  ,d(`d')filter(w(2 1 2)) gr_name(ind_ls2_cl5) note(only independents 5ma) dv(happy) by(cl) over(year)ylab( )  */
/* aok_ts  ,d(`d')filter(w(1 1 1)) gr_name(ind_ls2_cl3) note(only independents 3ma) dv(happy) by(cl) over(year)ylab( )  */
/* restore */

//trying backward filtrs  back

/* aok_ts  ,d(`d')filter(w(4 1 0)) gr_name(ls3_rd10) note(4back) dv(happy) by(rd) over(year)ylab( )  */
/* aok_ts  ,d(`d')filter(w(2 1 0)) gr_name(ls3_rd5) note(2back) dv(happy) by(rd) over(year)ylab( )  */

/* aok_ts  ,d(`d')filter(w(4 1 0)) gr_name(ls3_cl10) note(4back) dv(happy) by(cl) over(year)ylab( )  */
/* aok_ts  ,d(`d')filter(w(2 1 0)) gr_name(ls3_cl5) note(2back) dv(happy) by(cl) over(year)ylab( )  */

/* preserve */
/* keep if rid==2 */
/* aok_ts  ,d(`d')filter(w(4 1 0)) gr_name(ind_ls3_cl10) note(only independents 4back) dv(happy) by(cl) over(year)ylab( )  */
/* aok_ts  ,d(`d')filter(w(2 1 0)) gr_name(ind_ls3_cl5) note(only independents 2back) dv(happy) by(cl) over(year)ylab( )  */
/* restore */

//-----------------------------------------END trying different filters---------------------------------------

//------final graphs------

aok_ts1  ,d(`d')filter(w(2 1 2)) gr_name(ls_rd5) note(w(2 1 2)) dv(happy) by(rd) over(year) ylab( )filter_type(ma)drop25(1)
aok_ts1 if rid==2 ,d(`d')filter(w(2 1 2)) gr_name(ind_ls_cl5) note(w(2 1 2)) dv(happy) by(cl) over(year)ylab( )filter_type(ma)drop25(1)

//per
aok_ts1  ,d(`d')filter(w(2 1 2)) gr_name(ls_rd5per) note(w(2 1 2)) dv(happy) by(rd) over(per)ylab( )filter_type(ma)drop25(1)
aok_ts1  if rid==2,d(`d')filter(w(2 1 2)) gr_name(ls_cl5per) note(w(2 1 2)) dv(happy) by(cl) over(per)ylab( )filter_type(ma)drop25(1)

//nl --those nl do not work with data with gaps and give results that suck
/* aok_ts1  ,d(`d')filter(smoother(5)) gr_name(ls_rd5pernl) note(nl(2 1 2)) dv(happy) by(rd) over(per)ylab( )filter_type(nl)drop25(1) */
/* aok_ts1  if rid==2,d(`d')filter(smoother(5)) gr_name(ls_cl5pernl) note(nl(2 1 2)) dv(happy) by(cl) over(per)ylab( )filter_type(nl)drop25(0) */


//-----voting rep
  
aok_ts1  ,d(`d')filter(w(2 1 2)) gr_name(vr_rd5) note(w(2 1 2)) dv(vr) by(rd) over(year) ylab( )filter_type(ma)drop25(1)
aok_ts1 if rid==2 ,d(`d')filter(w(2 1 2)) gr_name(ind_vr_cl5) note(w(2 1 2)) dv(vr) by(cl) over(year)ylab( )filter_type(ma)drop25(1)

aok_ts1  ,d(`d')filter(w(2 1 2)) gr_name(vr_cml5) note(w(2 1 2)) dv(vr) by(rid) over(year) ylab( )filter_type(ma)drop25(1)

aok_ts1  ,d(`d')filter(w(2 1 2)) gr_name(vr_rid5) note(w(2 1 2)) dv(vr) by(cml) over(year) ylab( )filter_type(ma)drop25(1)


//---------------------  stimson
preserve
/home/aok/papers/root/old/2011/gss_town_AND_politics/dat/stimson/stimson.csv,clear
la var dim1 "stimson dimension 1"
drop if year<1970
gen _bu=1
la def _bu 1" "
la val _bu _bu

aok_ts1 ,d(`d')filter(w(2 1 2)) gr_name(dim) note(w(2 1 2)) dv(dim1) by(_bu) over(year) ylab( )filter_type(ma)drop25(0)

line dim1 year
gr export `d'out/base/g1.eps, replace
! okular `d'out/base/g1.eps
cd `d'out/base/
! epstopdf g1.eps 

//do not need stimson second dimension -- it does not go well with or data

/* twoway line dim2 year, scheme(s1mono) ti() legend(off) ylabel(, labsize(large)) xlabel(, labsize(large))ytitle(stimson second dimenstion,size(large))xtitle(,size(large))note(,size(large))saving(dim2,replace) */
/* graph export `d'out/base/dim2.eps, as(eps)  replace mag(54) */
/* sh(epstopdf `d'out/base/dim2.eps) */
/* sh(xpdf `d'out/base/dim2.pdf &) */

gr combine  dim1.gph  ls_rd5.gph ind_ls_cl5.gph , col(1)  iscale(.7)  imargin(l=0 r=10 t=0 b=0) graphregion(margin(l=0 r=0 t=0 b=0))xsize(2.5)xcommon 

graph export `d'out/pp.eps, as(eps)  replace 
sh(epstopdf `d'out/pp.eps)
sh(xpdf `d'out/pp.pdf &)


//! inkscape `d'out/pp.pdf &
restore
//---------------------  phase----------------------
/home/aok/papers/root/old/2011/gss_town_AND_politics/dat/stimson/stimson.csv,clear
aok_phase if year>1970, time_var(year) dv(dim1) range(50(2.5)65) filter_type(ma) filter(w(0 1 0)) d(`d') gr_name(phase)ti("phase")

cd `d'/out/base
! epstopdf phase.eps 
! okular phase.eps

use `d'base/cycles1.dta, clear
aok_phase if rid==1, time_var(year) dv(happy) range(2(.5)2.3) filter_type(ma) filter(w(2 1 2)) d(`d') gr_name(phase_rep_5_yr_ma)ti(R)

aok_phase if rid==3, time_var(year) dv(happy) range(2(.5)2.3) filter_type(ma) filter(w(2 1 2)) d(`d') gr_name(phase_dem_5_yr_ma)ti(D)

aok_phase if rid==2 & cml==1, time_var(year) dv(happy) range(2(.5)2.4) filter_type(ma) filter(w(2 1 2)) d(`d') gr_name(phase_C_5_yr_ma)ti(" ")

aok_phase if rid==2 & cml==2, time_var(year) dv(happy) range(2(.5)2.3) filter_type(ma) filter(w(2 1 2)) d(`d') gr_name(phase_M_5_yr_ma)ti(" ")

aok_phase if rid==2 & cml==3, time_var(year) dv(happy) range(2(.5)2.3) filter_type(ma) filter(w(2 1 2)) d(`d') gr_name(phase_L_5_yr_ma)ti(" ")

//-----------rep and dem together
use `d'base/cycles1.dta, clear

recode rid (1=1 "R")(2=.)(3=2 "D"), gen(rd)
recode cml (1=1 "C")(2=.)(3=2 "L"), gen(cl)

keep if rd!=.

//conRep and libDem
keep if (rid==1 & cml==1)|(rid==3 & cml==3)

keep happy  year rd

collapse happy, by(year rd)
gen id=_n
reshape wide  happy, i(id) j(rd)
bys year: replace happy1=happy1[_n+1] if happy1==.

collapse happy1 happy2, by(year)
collapse happy, by(year)

sort year
tsset year

tostring year, gen(yy)
gen yr=substr(yy,3,2)

tssmooth ma happyR =happy1, w(2 1 2)
tssmooth ma happyD =happy2, w(2 1 2)

gen happyR_lag1=happyR[_n-1]
gen happyD_lag1=happyD[_n-1]

l year yy yr happy*

gen l=2.0 in 1
replace l =2.4 in l
twoway (connected happyR happyR_lag1, lwidth(vvthin)msize(zero)lpatter(solid) msymbol(point) mlabel(yr) mlabposition(2) mlabgap(tiny))(connected happyD happyD_lag1, lpattern(solid)lwidth(vvthin)msize(zero) msymbol(point) mlabel(yr) mlabposition(2) mlabgap(tiny))(line l l,lcolor(gs12)), ytitle("happiness at time t",size(large)) xtitle("happiness at time t-1",size(large))scheme(s1mono)ysize(5.5)scale(.58)xscale(range(2.0(.05)2.4))yscale(range(2.0(.05)2.4))xlabel(2.0(.05)2.4)ylabel(2.0(.05)2.4)legend(off)
graph export `d'out/base/phase_rd_5_yr_ma.eps, as(eps)  replace
sh(epstopdf  `d'out/base/phase_rd_5_yr_ma.eps)
      ! xpdf `d'out/base/phase_rd_5_yr_ma.pdf



//-----------conInd
use `d'base/cycles1.dta, clear

recode rid (1=1 "R")(2=.)(3=2 "D"), gen(rd)
recode cml (1=1 "C")(2=.)(3=2 "L"), gen(cl)


//conInd
keep if (rid==2 & cml==1)

keep happy  year rd

collapse happy, by(year)
/* gen id=_n */
/* reshape wide  happy, i(id) j(rd) */
bys year: replace happy=happy[_n+1] if happy==.

*//collapse happy1 happy2, by(year)
collapse happy, by(year)

sort year
tsset year

tostring year, gen(yy)
gen yr=substr(yy,3,2)

tssmooth ma happyR =happy, w(2 1 2)
*//tssmooth ma happyD =happy2, w(2 1 2)

gen happyR_lag1=happyR[_n-1]
*//gen happyD_lag1=happyD[_n-1]

l year yy yr happy*

gen l=2.0 in 1
replace l =2.4 in l
twoway (connected happyR happyR_lag1, lwidth(vvthin)msize(zero)lpatter(solid) msymbol(point) mlabel(yr) mlabposition(2) mlabgap(tiny))(line l l,lcolor(gs12)), ytitle("happiness at time t",size(large)) xtitle("happiness at time t-1",size(large))scheme(s1mono)ysize(5.5)scale(.58)xscale(range(2.0(.05)2.4))yscale(range(2.0(.05)2.4))xlabel(2.0(.05)2.4)ylabel(2.0(.05)2.4)legend(off) graphregion(margin(zero))
graph export `d'out/base/phase_C_5_yr_ma.eps, as(eps)  replace
sh(epstopdf  `d'out/base/phase_C_5_yr_ma.eps)
      ! xpdf `d'out/base/phase_C_5_yr_ma.pdf






//-----------modInd
use `d'base/cycles1.dta, clear

recode rid (1=1 "R")(2=.)(3=2 "D"), gen(rd)
recode cml (1=1 "C")(2=.)(3=2 "L"), gen(cl)


//modInd
keep if (rid==2 & cml==2)

keep happy  year rd

collapse happy, by(year)
/* gen id=_n */
/* reshape wide  happy, i(id) j(rd) */
bys year: replace happy=happy[_n+1] if happy==.

*//collapse happy1 happy2, by(year)
collapse happy, by(year)

sort year
tsset year

tostring year, gen(yy)
gen yr=substr(yy,3,2)

tssmooth ma happyR =happy, w(2 1 2)
*//tssmooth ma happyD =happy2, w(2 1 2)

gen happyR_lag1=happyR[_n-1]
*//gen happyD_lag1=happyD[_n-1]

l year yy yr happy*

gen l=2.0 in 1
replace l =2.4 in l
twoway (connected happyR happyR_lag1, lwidth(vvthin)msize(zero)lpatter(solid) msymbol(point) mlabel(yr) mlabposition(2) mlabgap(tiny))(line l l,lcolor(gs12)), ytitle("happiness at time t",size(large)) xtitle("happiness at time t-1",size(large))scheme(s1mono)ysize(5.5)scale(.58)xscale(range(2.0(.05)2.4))yscale(range(2.0(.05)2.4))xlabel(2.0(.05)2.4)ylabel(2.0(.05)2.4)legend(off)graphregion(margin(zero))
graph export `d'out/base/phase_M_5_yr_ma.eps, as(eps)  replace
sh(epstopdf  `d'out/base/phase_M_5_yr_ma.eps)
      ! xpdf `d'out/base/phase_M_5_yr_ma.pdf

//-----------libInd
use `d'base/cycles1.dta, clear

recode rid (1=1 "R")(2=.)(3=2 "D"), gen(rd)
recode cml (1=1 "C")(2=.)(3=2 "L"), gen(cl)


//libInd
keep if (rid==2 & cml==3)

keep happy  year rd

collapse happy, by(year)
/* gen id=_n */
/* reshape wide  happy, i(id) j(rd) */
bys year: replace happy=happy[_n+1] if happy==.

*//collapse happy1 happy2, by(year)
collapse happy, by(year)

sort year
tsset year

tostring year, gen(yy)
gen yr=substr(yy,3,2)

tssmooth ma happyR =happy, w(2 1 2)
*//tssmooth ma happyD =happy2, w(2 1 2)

gen happyR_lag1=happyR[_n-1]
*//gen happyD_lag1=happyD[_n-1]

l year yy yr happy*

gen l=2.0 in 1
replace l =2.4 in l
twoway (connected happyR happyR_lag1, lwidth(vvthin)msize(zero)lpatter(solid) msymbol(point) mlabel(yr) mlabposition(2) mlabgap(tiny))(line l l,lcolor(gs12)), ytitle("happiness at time t",size(large)) xtitle("happiness at time t-1",size(large))scheme(s1mono)ysize(5.5)scale(.58)xscale(range(2.0(.05)2.4))yscale(range(2.0(.05)2.4))xlabel(2.0(.05)2.4)ylabel(2.0(.05)2.4)legend(off)graphregion(margin(zero))
graph export `d'out/base/phase_L_5_yr_ma.eps, as(eps)  replace
sh(epstopdf  `d'out/base/phase_L_5_yr_ma.eps)
      ! xpdf `d'out/base/phase_L_5_yr_ma.pdf





//-----------RID together by VR
use `d'base/cycles1.dta, clear
drop if rid==.
keep if (rid=2 & cml==1)|(rid=1 & cml==1)
keep vr  year rid

collapse vr, by(year rid)
gen id=_n
reshape wide  vr, i(id) j(rid)

collapse vr1 vr2 vr3, by(year)

sort year
tsset year

tostring year, gen(yy)
gen yr=substr(yy,3,2)

tssmooth ma vrR =vr1, w(2 1 2)
tssmooth ma vrI =vr2, w(2 1 2)
*//tssmooth ma vrD =vr3, w(2 1 2)

gen vrR_lag1=vrR[_n-1]
gen vrI_lag1=vrI[_n-1]
*//gen vrD_lag1=vrD[_n-1]

l year yy yr vr*

gen l=0.3 in 1
replace l =1 in l
twoway (connected vrR vrR_lag1, lwidth(vvthin)msize(zero)lpatter(solid) msymbol(point)mlabel(yr) mlabposition(2) mlabgap(tiny))(connected vrI vrI_lag1, lwidth(medium)msize(zero)lpatter(solid) msymbol(point)mlabel(yr) mlabposition(2) mlabgap(tiny))(line l l,lcolor(gs12)), ytitle(" proportion at time t") xtitle("proportion at time t-1")scheme(s1mono)ysize(5.5)scale(.58)xscale(range(0.3(.2)1))yscale(range(0.3(.2)1))xlabel(0.3(.2)1)ylabel(0.3(.2)1)legend(off)
graph export `d'out/base/phase_vr_ri_5_yr_ma.eps, as(eps)  replace
sh(epstopdf  `d'out/base/phase_vr_ri_5_yr_ma.eps)
      ! xpdf `d'out/base/phase_vr_ri_5_yr_ma.pdf



//-----------RID together by VD
use `d'base/cycles1.dta, clear
drop if rid==.
keep if (rid==3 & cml==3)|(rid==2 & cml==3)
keep vd  year rid

collapse vd, by(year rid)
gen id=_n
reshape wide  vd, i(id) j(rid)

collapse  vd2 vd3, by(year)

sort year
tsset year

tostring year, gen(yy)
gen yr=substr(yy,3,2)

*//tssmooth ma vdR =vd1, w(2 1 2)
tssmooth ma vdI =vd2, w(2 1 2)
tssmooth ma vdD =vd3, w(2 1 2)

*//gen vdR_lag1=vdR[_n-1]
gen vdI_lag1=vdI[_n-1]
gen vdD_lag1=vdD[_n-1]

l year yy yr vd*

gen l=0.3 in 1
replace l =1 in l
twoway (connected vdI vdI_lag1, lwidth(medium)msize(zero)lpatter(solid) msymbol(point)mlabel(yr) mlabposition(2) mlabgap(tiny))(connected vdD vdD_lag1, lpattern(solid)lwidth(vvthin)msize(zero) msymbol(point)mlabel(yr) mlabposition(2) mlabgap(tiny))(line l l,lcolor(gs12)), ytitle("proportion at time t") xtitle("proportion at time t-1")scheme(s1mono)ysize(5.5)scale(.58)xscale(range(0.3(.2)1))yscale(range(0.3(.2)1))xlabel(0.3(.2)1)ylabel(0.3(.2)1)legend(off)
graph export `d'out/base/phase_vd_id_5_yr_ma.eps, as(eps)  replace
sh(epstopdf  `d'out/base/phase_vd_id_5_yr_ma.eps)
      ! xpdf `d'out/base/phase_vd_id_5_yr_ma.pdf


//-----------RID together by VO
use `d'base/cycles1.dta, clear
drop if rid==.
keep vo  year rid

collapse vo, by(year rid)
gen id=_n
reshape wide  vo, i(id) j(rid)

collapse vo1 vo2 vo3, by(year)

sort year
tsset year

tostring year, gen(yy)
gen yr=substr(yy,3,2)

tssmooth ma voR =vo1, w(2 1 2)
tssmooth ma voI =vo2, w(2 1 2)
tssmooth ma voD =vo3, w(2 1 2)

gen voR_lag1=voR[_n-1]
gen voI_lag1=voI[_n-1]
gen voD_lag1=voD[_n-1]

l year yy yr vo*

gen l=0 in 1
replace l =1 in 27  
twoway (connected voR voR_lag1, lwidth(vvthin)msize(zero)lpatter(solid) msymbol(point) mlabel(yr) mlabposition(2) mlabgap(tiny))(connected voI voI_lag1, lwidth(medium)msize(zero)lpatter(solid) msymbol(point) mlabel(yr) mlabposition(2) mlabgap(tiny))(connected voD voD_lag1, lpattern(solid)lwidth(vvthin)msize(zero) msymbol(point) mlabel(yr) mlabposition(2) mlabgap(tiny))(line l l,lcolor(gs12)), ytitle("democrats, independents and republicans 5-yr MA voted other at time t") xtitle("democrats, independents and republicans 5-yr MA voted other  at time t-1")scheme(s1mono)ysize(5.5)scale(.58)xscale(range(0(.2)1))yscale(range(0(.2)1))xlabel(0(.2)1)ylabel(0(.2)1)legend(off)
graph export `d'out/base/phase_vo_rid_5_yr_ma.eps, as(eps)  replace
sh(epstopdf  `d'out/base/phase_vo_rid_5_yr_ma.eps)
      ! xpdf `d'out/base/phase_vo_rid_5_yr_ma.pdf





//-----------RID together by VDD
use `d'base/cycles1.dta, clear
drop if rid==.
keep vdd  year rid

collapse vdd, by(year rid)
gen id=_n
reshape wide  vdd, i(id) j(rid)

collapse vdd1 vdd2 vdd3, by(year)

sort year
tsset year

tostring year, gen(yy)
gen yr=substr(yy,3,2)

tssmooth ma vddR =vdd1, w(2 1 2)
tssmooth ma vddI =vdd2, w(2 1 2)
tssmooth ma vddD =vdd3, w(2 1 2)

gen vddR_lag1=vddR[_n-1]
gen vddI_lag1=vddI[_n-1]
gen vddD_lag1=vddD[_n-1]

l  yr vdd*

gen l=0 in 1
replace l =1 in 27  
twoway (connected vddR vddR_lag1, lwidth(vvthin)msize(zero)lpatter(solid) msymbol(point)mlabel(yr) mlabposition(2) mlabgap(tiny))(connected vddI vddI_lag1, lwidth(medium)msize(zero)lpatter(solid) msymbol(point)mlabel(yr) mlabposition(2) mlabgap(tiny))(connected vddD vddD_lag1, lpattern(solid)lwidth(vvthin)msize(zero) msymbol(point)mlabel(yr) mlabposition(2) mlabgap(tiny))(line l l,lcolor(gs12)), ytitle("democrats, independents and republicans 5-yr MA voted Dem vs Rep only t") xtitle("democrats, independents and republicans 5-yr MA voted Dem vs Rep only t-1")scheme(s1mono)ysize(5.5)scale(.58)xscale(range(0(.2)1))yscale(range(0(.2)1))xlabel(0(.2)1)ylabel(0(.2)1)legend(off)
graph export `d'out/base/phase_vdd_rid_5_yr_ma.eps, as(eps)  replace
sh(epstopdf  `d'out/base/phase_vdd_rid_5_yr_ma.eps)
      ! xpdf `d'out/base/phase_vdd_rid_5_yr_ma.pdf




//-----------RID together by VRR
use `d'base/cycles1.dta, clear
drop if rid==.
keep vrr  year rid

collapse vrr, by(year rid)
gen id=_n
reshape wide  vrr, i(id) j(rid)

collapse vrr1 vrr2 vrr3, by(year)

sort year
tsset year

tostring year, gen(yy)
gen yr=substr(yy,3,2)

tssmooth ma vrrR =vrr1, w(2 1 2)
tssmooth ma vrrI =vrr2, w(2 1 2)
tssmooth ma vrrD =vrr3, w(2 1 2)

gen vrrR_lag1=vrrR[_n-1]
gen vrrI_lag1=vrrI[_n-1]
gen vrrD_lag1=vrrD[_n-1]

l year yy yr vrr*

gen l=0 in 1
replace l =1 in 27  
twoway (connected vrrR vrrR_lag1, lwidth(vvthin)msize(zero)lpatter(solid) msymbol(point)mlabel(yr) mlabposition(2) mlabgap(tiny))(connected vrrI vrrI_lag1, lwidth(medium)msize(zero)lpatter(solid) msymbol(point)mlabel(yr) mlabposition(2) mlabgap(tiny))(connected vrrD vrrD_lag1, lpattern(solid)lwidth(vvthin)msize(zero) msymbol(point)mlabel(yr) mlabposition(2) mlabgap(tiny))(line l l,lcolor(gs12)), ytitle("democrats, independents and republicans 5-yr MA voted Rep vs Dem only t") xtitle("democrats, independents and republicans 5-yr MA voted Rep vs Dem only t-1")scheme(s1mono)ysize(5.5)scale(.58)xscale(range(0(.2)1))yscale(range(0(.2)1))xlabel(0(.2)1)ylabel(0(.2)1)legend(off)
graph export `d'out/base/phase_vrr_rid_5_yr_ma.eps, as(eps)  replace
sh(epstopdf  `d'out/base/phase_vrr_rid_5_yr_ma.eps)
      ! xpdf `d'out/base/phase_vrr_rid_5_yr_ma.pdf


//----------------------no MA

//-----------RID together by VDD
use `d'base/cycles1.dta, clear
drop if rid==.
keep vdd  year rid

collapse vdd, by(year rid)
gen id=_n
reshape wide  vdd, i(id) j(rid)

collapse vdd1 vdd2 vdd3, by(year)

sort year
tsset year

tostring year, gen(yy)
gen yr=substr(yy,3,2)

tssmooth ma vddR =vdd1, w(0 1 0)
tssmooth ma vddI =vdd2, w(0 1 0)
tssmooth ma vddD =vdd3, w(0 1 0)

gen vddR_lag1=vddR[_n-1]
gen vddI_lag1=vddI[_n-1]
gen vddD_lag1=vddD[_n-1]

l  yr vdd*

gen l=0 in 1
replace l =1 in 27  
twoway (connected vddR vddR_lag1, lwidth(vvthin)msize(zero)lpatter(solid) msymbol(point)mlabel(yr) mlabposition(2) mlabgap(tiny))(connected vddI vddI_lag1, lwidth(medium)msize(zero)lpatter(solid) msymbol(point)mlabel(yr) mlabposition(2) mlabgap(tiny))(connected vddD vddD_lag1, lpattern(solid)lwidth(vvthin)msize(zero) msymbol(point)mlabel(yr) mlabposition(2) mlabgap(tiny))(line l l,lcolor(gs12)), ytitle("democrats, independents and republicans 5-yr MA voted Dem vs Rep only t") xtitle("democrats, independents and republicans 5-yr MA voted Dem vs Rep only t-1")scheme(s1mono)ysize(5.5)scale(.58)xscale(range(0(.2)1))yscale(range(0(.2)1))xlabel(0(.2)1)ylabel(0(.2)1)legend(off)
graph export `d'out/base/phase_vdd_rid_5_yr_ma.eps, as(eps)  replace
sh(epstopdf  `d'out/base/phase_vdd_rid_5_yr_ma.eps)
      ! xpdf `d'out/base/phase_vdd_rid_5_yr_ma.pdf




//-----------RID together by VRR
use `d'base/cycles1.dta, clear
drop if rid==.
keep vrr  year rid

collapse vrr, by(year rid)
gen id=_n
reshape wide  vrr, i(id) j(rid)

collapse vrr1 vrr2 vrr3, by(year)

sort year
tsset year

tostring year, gen(yy)
gen yr=substr(yy,3,2)

tssmooth ma vrrR =vrr1, w(0 1 0)
tssmooth ma vrrI =vrr2, w(0 1 0)
tssmooth ma vrrD =vrr3, w(0 1 0)

gen vrrR_lag1=vrrR[_n-1]
gen vrrI_lag1=vrrI[_n-1]
gen vrrD_lag1=vrrD[_n-1]

l year yy yr vrr*

gen l=0 in 1
replace l =1 in 27  
twoway (connected vrrR vrrR_lag1, lwidth(vvthin)msize(zero)lpatter(solid) msymbol(point)mlabel(yr) mlabposition(2) mlabgap(tiny))(connected vrrI vrrI_lag1, lwidth(medium)msize(zero)lpatter(solid) msymbol(point)mlabel(yr) mlabposition(2) mlabgap(tiny))(connected vrrD vrrD_lag1, lpattern(solid)lwidth(vvthin)msize(zero) msymbol(point)mlabel(yr) mlabposition(2) mlabgap(tiny))(line l l,lcolor(gs12)), ytitle("democrats, independents and republicans 5-yr MA voted Rep vs Dem only t") xtitle("democrats, independents and republicans 5-yr MA voted Rep vs Dem only t-1")scheme(s1mono)ysize(5.5)scale(.58)xscale(range(0(.2)1))yscale(range(0(.2)1))xlabel(0(.2)1)ylabel(0(.2)1)legend(off)
graph export `d'out/base/phase_vrr_rid_5_yr_ma.eps, as(eps)  replace
sh(epstopdf  `d'out/base/phase_vrr_rid_5_yr_ma.eps)
      ! xpdf `d'out/base/phase_vrr_rid_5_yr_ma.pdf


*//-----------even more here...
use `d'base/cycles1.dta, clear

forval rid=1/3 {
forval cml=1/3{
aok_phase if rid==`rid' & cml==`cml' , time_var(year) dv(vr) range(0(.1)1) filter_type(ma) filter(w(2 1 2)) d(`d') gr_name(vr_rid`rid'_cml`cml')ti(rid:`rid';cml:`cml')
aok_phase if rid==`rid' & cml==`cml' , time_var(year) dv(vd) range(0(.1)1) filter_type(ma) filter(w(2 1 2)) d(`d') gr_name(vd_rid`rid'_cml`cml')ti(rid:`rid';cml:`cml')
}
}

forval rid=1/3 {
forval cml=1/3{
di "-----------------this is rid:`rid'; cml: `cml'-------------------"
aok_phase if rid==`rid' & cml==`cml' , time_var(year) dv(happy) range(2.05(.05)2.35) filter_type(ma) filter(w(2 1 2)) d(`d') gr_name(happy_rid`rid'_cml`cml')ti(rid:`rid';cml:`cml')
di "-----------------this is rid:`rid'; cml: `cml'-------------------"
}
}
cap log close
log using `d'out/log.txt, text replace
table rid cml, c(mean happy sd happy)  format(%9.2f) by(year) 
table year rid cml , c(mean happy sd happy)  format(%9.2f)  

table rid cml, c(mean happy sd happy)  format(%9.2f)
table rid cml, c(mean vr sd vr)  format(%9.2f)
table rid cml, c(mean vd sd vd)  format(%9.2f)

*//much less variation by year
preserve
collapse happy vd vr, by(rid cml year)
table rid cml, c(mean happy sd happy)  format(%9.2f)
table rid cml, c(mean vr sd vr)  format(%9.2f)
table rid cml, c(mean vd sd vd)  format(%9.2f)
restore

table rid cml, c(mean happy sd happy n happy)  format(%9.2f) by(year) 
table rid cml, c(mean vr sd vr n vr)  format(%9.2f) by(year) 
table rid cml, c(mean vd sd vd n vd)  format(%9.2f) by(year) 

preserve
collapse happy vd vr, by(rid cml year)
table rid cml if year<1980, c(mean vr sd vr)  format(%9.2f)
table rid cml if year<1980, c(mean vd sd vd)  format(%9.2f)

table rid cml if year>2000, c(mean vr sd vr)  format(%9.2f)
table rid cml if year>2000, c(mean vd sd vd)  format(%9.2f)

table rid cml if year>1980 & year<2000, c(mean vr sd vr)  format(%9.2f)
table rid cml if year>1980 & year<2000, c(mean vd sd vd)  format(%9.2f)

restore
log close
*//tsset year
*//tssmooth ma happy_ma =happy, window(2 1 2)

//--------------------------------------------------------------------------------------------------------
//  Forest plots...
//----------------------------------------------------------------------------------------------------------


use /home/aok/desk/papers/gss_town_AND_politics/base/cycles1.dta, clear

loc v age unemp prestige income class born  prot happy polint satfrnd satfin trust  cntrlife fatalism goodlife

aok_forest, gr_name(forest_all)  d(`d') all(`v') by(cml) t("all") 

preserve
keep if rid==2
aok_forest, gr_name(forest_I)  d(`d') all(`v') by(cml) t("Independents") 
restore


//---------------------------
//stimspn merged
//-----------------------------
insheet using /home/aok/papers/root/old/2011/gss_town_AND_politics/dat/stimson/stimson.csv,clear comma
sort year
save `d'base/stimson.dta, replace

use `d'base/cycles1.dta, clear
gen happyCR=happy if rid==1 & cml==1
gen happyLD=happy if rid==3 & cml==3

gen happyLI=happy if rid==2 & cml==3
gen happyMI=happy if rid==2 & cml==2
gen happyCI=happy if rid==2 & cml==1

gen happyR=happy if rid==1
gen happyI=happy if rid==2
gen happyD=happy if rid==3

gen vd_LI=vd if  rid==2 & cml==3
gen vd_MI=vd if  rid==2 & cml==2
gen vd_CI=vd if  rid==2 & cml==1


gen vr_LI=vr if  rid==2 & cml==3
gen vr_MI=vr if  rid==2 & cml==2
gen vr_CI=vr if  rid==2 & cml==1

gen vr_CR=vr if  rid==1 & cml==1
gen vd_LD=vd if  rid==3 & cml==3



gen vr_LD=vr if  rid==3 & cml==3
gen vr_MD=vr if  rid==3 & cml==2
gen vr_CD=vr if  rid==3 & cml==1

gen vr_LR=vr if  rid==1 & cml==3
gen vr_MR=vr if  rid==1 & cml==2
*//gen vr_CR=vr if  rid==1 & cml==1



collapse happy happyCR happyLD happyLI happyMI happyCI happyR happyI happyD vd_* vr_*, by(year)
sort year
merge year using `d'base/stimson.dta
ta _merge
*//l
keep if _merge ==3


tsset year
/* tssmooth ma  happyCR5= happyCR, w(2 1 2) */
/* tssmooth ma  happyLD5= happyLD, w(2 1 2) */
/* tssmooth ma  dim1_5  = dim1, w(2 1 2) */
/* tssmooth ma  dim2_5  = dim2, w(2 1 2) */
gen dim1_l1=L1.dim1

tostring year, gen(yy)
gen yr=substr(yy,3,2)

/* tw (scatter dim1 happyCR, ml(yr))(lfit dim1 happyCR), saving(cr,replace) */
/* tw (scatter dim1 happyLD, ml(yr))(lfit dim1 happyLD), saving(ld,replace) */
/* gr combine cr.gph ld.gph */
/* gr export g1.eps, replace */
/* ! epstopdf g1.eps  */


/* tw (scatter dim1_5 happyCR5, ml(yr))(lfit dim1_5 happyCR5), saving(cr,replace) */
/* tw (scatter dim1_5 happyLD5, ml(yr))(lfit dim1_5 happyLD5), saving(ld,replace) */
/* gr combine cr.gph ld.gph */
/* gr export g2.eps, replace */
/* ! epstopdf g2.eps  */


/* tw (scatter dim2_5 happyCR5, ml(yr))(lfit dim2_5 happyCR5), saving(cr,replace) */
/* tw (scatter dim2_5 happyLD5, ml(yr))(lfit dim2_5 happyLD5), saving(ld,replace) */
/* gr combine cr.gph ld.gph */
/* gr export g3.eps, replace */
/* ! epstopdf g3.eps  */

/* tw (scatter  happyLI dim1, ml(yr))(lfit happyLI dim1), saving(li,replace) */
/* tw (scatter  happyMI dim1, ml(yr))(lfit happyMI dim1), saving(mi,replace) */
/* tw (scatter  happyCI dim1, ml(yr))(lfit happyCI dim1), saving(ci,replace) */
/* gr combine li.gph mi.gph  ci.gph */
/* gr export g1.eps, replace */
/* ! okular g1.eps & */

/* tw (scatter  happyLI dim1_l1, ml(yr))(lfit happyLI dim1_l1), saving(li,replace) */
/* tw (scatter  happyMI dim1_l1, ml(yr))(lfit happyMI dim1_l1), saving(mi,replace) */
/* tw (scatter  happyCI dim1_l1, ml(yr))(lfit happyCI dim1_l1), saving(ci,replace) */
/* gr combine li.gph mi.gph  ci.gph */
/* gr export g2.eps, replace */
/* ! okular g2.eps & */


tw (lfit happyR dim1, lcolor(black) lpattern(solid))(lfit happyI dim1, lcolor(black) lpattern(dash))(lfit happyD dim1, lcolor(black) lpattern(dot)), legend(order(1 "R" 2 "I" 3 "D") rows(1))
dy
gr export `d'out/base/rid_s.eps, replace

reg happyR dim1, robust
est sto a1
reg happyI dim1, robust
est sto a2
reg happyD dim1, robust
est sto a3


tw (lfit happyLI dim1, lcolor(black) lpattern(solid))(lfit happyMI dim1, lcolor(black) lpattern(dash))(lfit happyCI dim1, lcolor(black) lpattern(dot)), legend(order(1 "LI" 2 "MI" 3 "CI") rows(1))
dy
gr export `d'out/base/i_s.eps, replace

reg happyLI dim1, robust
est sto b1
reg happyMI dim1, robust
est sto b2
reg happyCI dim1, robust
est sto b3

esttab b*, nostar 

//CI
tw (lfitci happyLI dim1, ciplot(rcap) n(4) blcolor(gs12) lcolor(black) lpattern(solid))(lfitci happyMI dim1,ciplot(rcap) n(4) blcolor(gs12) lcolor(black) lpattern(dash))(lfitci happyCI dim1,ciplot(rcap) n(4) blcolor(gs12) lcolor(black) lpattern(dot)), legend(order(1 "LI" 2 "MI" 3 "CI") rows(1))
dy

tw (lfitci happyLI dim1,  blcolor(gs12) lcolor(black) lpattern(solid))(lfitci happyMI dim1,blcolor(gs12) lcolor(black) lpattern(dash))(lfitci happyCI dim1, blcolor(gs12) lcolor(black) lpattern(dot)), legend(order(1 "LI" 2 "MI" 3 "CI") rows(1))
dy



/* tw (lfit happyLI dim2)(lfit happyMI dim2)(lfit happyCI dim2) */
/* gr export g1.eps, replace */
/* ! okular g1.eps & */


corr happyCR happyLD  happyR happyI happyD   happyCI happyMI happyLI  dim1 


tw (lfit vd_LI dim1, lcolor(black) lpattern(solid))(lfit vd_MI dim1, lcolor(black) lpattern(dash))(lfit vd_CI dim1, lcolor(black) lpattern(dot)), legend(order(1 "LI" 2 "MI" 3 "CI") rows(1))
gr export `d'out/base/s1.eps, replace
! okular `d'out/base/s1.eps &

tw (lfit vr_LI dim1, lcolor(black) lpattern(solid))(lfit vr_MI dim1, lcolor(black) lpattern(dash))(lfit vr_CI dim1, lcolor(black) lpattern(dot)), legend(order(1 "LI" 2 "MI" 3 "CI") rows(1))
gr export `d'out/base/s2.eps, replace
! okular `d'out/base/s2.eps &



tw (lfit vr_CR dim1, lcolor(black) lpattern(solid))(lfit vr_CI dim1, lcolor(black) lpattern(dot)), legend(order(1 "CR" 2 "CI" ) rows(1))
gr export `d'out/base/s3.eps, replace
! okular `d'out/base/s3.eps &


tw (lfit vd_LI dim1, lcolor(black) lpattern(solid))(lfit vd_LD dim1, lcolor(black) lpattern(dot)), legend(order(1 "LI" 2 "LD" ) rows(1))
gr export `d'out/base/s4.eps, replace
! okular `d'out/base/s4.eps &



tw (lfit vr_LI happy, lcolor(black) lpattern(solid))(lfit vr_MI happy, lcolor(black) lpattern(dash))(lfit vr_CI happy, lcolor(black) lpattern(dot)), legend(order(1 "LI" 2 "MI" 3 "CI") rows(1))
gr export `d'out/base/s2_1.eps, replace
! okular `d'out/base/s2_1.eps &

tw (lfit vd_LI happy, lcolor(black) lpattern(solid))(lfit vd_MI happy, lcolor(black) lpattern(dash))(lfit vd_CI happy, lcolor(black) lpattern(dot)), legend(order(1 "LI" 2 "MI" 3 "CI") rows(1))
gr export `d'out/base/s2_2.eps, replace
! okular `d'out/base/s2_2.eps &



tw (lfit vr_LD dim1, lcolor(black) lpattern(solid))(lfit vr_MD dim1, lcolor(black) lpattern(dash))(lfit vr_CD dim1, lcolor(black) lpattern(dot)), legend(order(1 "LD" 2 "MD" 3 "CD") rows(1))
gr export `d'out/base/s5.eps, replace
! okular `d'out/base/s5.eps &

tw (lfit vr_LR dim1, lcolor(black) lpattern(solid))(lfit vr_MR dim1, lcolor(black) lpattern(dash))(lfit vr_CR dim1, lcolor(black) lpattern(dot)), legend(order(1 "LR" 2 "MR" 3 "CR") rows(1))
gr export `d'out/base/s6.eps, replace
! okular `d'out/base/s6.eps &


//-----------------------------------------------------------------------------
//new 2016 aug

//use `d'base/cycles1.dta, clear
$gss

//aok_phase if rid==1, time_var(year) dv(happy) range(2(.5)2.3) filter_type(ma) filter(w(2 1 2)) d(`d') gr_name(phase_rep_5_yr_ma)ti(R)


aok_phase if rid==1, time_var(year) dv(swb) range(2(.5)2.4) filter_type(ma) filter(w(2 1 2)) d(/tmp/) gr_name(phase_rep_5_yr_ma)ti("happiness,Rep, 5yrMA")

aok_phase if rid==3, time_var(year) dv(swb) range(2(.5)2.4) filter_type(ma) filter(w(2 1 2)) d(/tmp/) gr_name(phase_dem_5_yr_ma)ti("happiness,Democrats, 5yrMA")

aok_phase if rid==2 & cml==1, time_var(year) dv(swb) range(2(.5)2.4) filter_type(ma) filter(w(2 1 2)) d(/tmp/) gr_name(phase_C_5_yr_ma)ti("happiness, cons indep, 5yrMA ")


aok_phase if rid==2 & cml==2, time_var(year) dv(swb) range(2(.5)2.4) filter_type(ma) filter(w(2 1 2)) d(/tmp/) gr_name(phase_M_5_yr_ma)ti("")  //happiness, mod indep, 5yrMA
! epstopdf /tmp/out/base/phase_M_5_yr_ma.eps
! inkscape /tmp/out/base/phase_M_5_yr_ma.pdf

aok_phase if rid==2 & cml==3, time_var(year) dv(swb) range(2(.5)2.4) filter_type(ma) filter(w(2 1 2)) d(/tmp/) gr_name(phase_L_5_yr_ma)ti("") //happiness, lib indep, 5yrMA
! epstopdf /tmp/out/base/phase_L_5_yr_ma.eps
! inkscape /tmp/out/base/phase_L_5_yr_ma.pdf


---
aok_phase if rid==1 & cml==1, time_var(year) dv(swb) range(2(.5)2.4) filter_type(ma) filter(w(2 1 2)) d(/tmp/) gr_name(phase_con-rep_5_yr_ma)ti("happiness,ConRep, 5yrMA")

aok_phase if rid==3 & cml==3, time_var(year) dv(swb) range(2(.5)2.4) filter_type(ma) filter(w(2 1 2)) d(/tmp/) gr_name(phase_lib-dem_5_yr_ma)ti("happiness,LibDemocrats, 5yrMA")


---------------------------

capture drop vr
gen vr=.
la var vr"voted republican"
gen year5=year-5

foreach i in "68" "72" "76" "80" "84" "88" "92" "96" "00" "04" "08" "12"{

if ("`i'"=="68")  local ii= "1968"
if ("`i'"=="72")  local ii= "1972"
if ("`i'"=="76")  local ii= "1976"
if ("`i'"=="80")  local ii= "1980"
if ("`i'"=="84")  local ii= "1984"
if ("`i'"=="88")  local ii= "1988"
if ("`i'"=="92")  local ii= "1992"
if ("`i'"=="96")  local ii= "1996"
if ("`i'"=="00")  local ii= "2000"
if ("`i'"=="04")  local ii= "2004"
if ("`i'"=="08")  local ii= "2008"
if ("`i'"=="12")  local ii= "2012"
replace vr=0 if ((pres`i' ==1 |pres`i' ==3|pres`i' ==4 )  & missing(vr))  & `ii'< year &  `ii'> year5
replace vr=1 if  (pres`i' ==2  & missing(vr))  & `ii'< year &  `ii'> year5
}
codebook vr 


capture drop vd
gen vd=.
la var vd"voted democrat"

foreach i in "68" "72" "76" "80" "84" "88" "92" "96" "00" "04" "08" "12"{

if ("`i'"=="68")  local ii= "1968"
if ("`i'"=="72")  local ii= "1972"
if ("`i'"=="76")  local ii= "1976"
if ("`i'"=="80")  local ii= "1980"
if ("`i'"=="84")  local ii= "1984"
if ("`i'"=="88")  local ii= "1988"
if ("`i'"=="92")  local ii= "1992"
if ("`i'"=="96")  local ii= "1996"
if ("`i'"=="00")  local ii= "2000"
if ("`i'"=="04")  local ii= "2004"
if ("`i'"=="08")  local ii= "2008"
if ("`i'"=="12")  local ii= "2012"
replace vd=0 if ((pres`i' ==2 |pres`i' ==3|pres`i' ==4  )  & missing(vd))  & `ii'< year &  `ii'> year5
replace vd=1 if  (pres`i' ==1  & missing(vd))  & `ii'< year &  `ii'> year5
}



forval rid=1/3 {
aok_phase if rid==`rid' , time_var(year) dv(vr) range(0(.1)1) filter_type(ma) filter(w(2 1 2)) d(/tmp/) gr_name(vr_rid`rid')ti(rid:`rid';vote rep)
aok_phase if rid==`rid'  , time_var(year) dv(vd) range(0(.1)1) filter_type(ma) filter(w(2 1 2)) d(/tmp/) gr_name(vd_rid`rid')ti(rid:`rid';vote dem)
}



