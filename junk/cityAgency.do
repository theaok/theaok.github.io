run /home/aok/papers/root/do/aok_programs.do
cd /home/aok/papers/cityAgency/tex
//------------------wb



//ssc install wbopendata, replace

//net install wbopendata, from("https://raw.githubusercontent.com/jpazvd/wbopendata/main")replace
//double check and get defs
//https://data.worldbank.org/indicator/NY.GDP.PCAP.KD

//avg10yr  bc 1yr lots missig, even 5 lots of missing, !! say in paper
wbopendata, indicator(SI.POV.NAHC;NY.GDP.PCAP.KD;SI.DST.10TH.10;SL.UEM.TOTL.ZS;FP.CPI.TOTL.ZG;SP.URB.TOTL.IN.ZS)clear long  //;WB.WDI.EN.URB.MCTY.TL.ZS
keep if year>=2015 & year<=2025
keep regionname countrycode countryname incomelevelname year si_pov_nahc ny_gdp_pcap_kd si_dst_10th_10 sl_uem_totl_zs fp_cpi_totl_zg sp_urb_totl_in_zs //wb_wdi_en_urb_mcty_tl_zs
collapse si_pov_nahc ny_gdp_pcap_kd si_dst_10th_10  sl_uem_totl_zs fp_cpi_totl_zg sp_urb_totl_in_zs , by(regionname countrycode countryname incomelevelname) //wb_wdi_en_urb_mcty_tl_zs
l countrycode si_pov_nahc ny_gdp_pcap_kd si_dst_10th_10  sl_uem_totl_zs fp_cpi_totl_zg sp_urb_totl_in_zs //wb_wdi_en_urb_mcty_tl_zs


la var si_pov_nahc "perc poor, natl poverty line"
la var ny_gdp_pcap_kd "GDP per capita (constant 2015 usd)"
la var si_dst_10th_10 "income share held by top 10perc"
la var sl_uem_totl_zs "unemployment, perc of tot labor force"
la var fp_cpi_totl_zg "perc inflation, consumer prices"
la var sp_urb_totl_in_zs "perc urban"
//la var wb_wdi_en_urb_mcty_tl_zs "pop of urb aggl gt 1m, perc of tot"



//LATER:
/*
note ny_gdp_pcap_kd: "GDP per capita is gross domestic product divided by midyear population. GDP is the sum of gross value added by all resident producers in the economy plus any product taxes and minus any subsidies not included in the value of the p\
roducts. It is calculated without making deductions for depreciation of fabricated assets or for depletion and degradation of natural resources. Data are in constant U.S. dollars."
d
note si_pov_nahc: ""
*/

l in 1/3
replace regionname = "East Asia/Pacific" if regionname=="East Asia and Pacific"
replace regionname = "Europe/Central Asia" if regionname=="Europe and Central Asia"
replace regionname = "Latin America/Caribbean" if regionname=="Latin America and Caribbean"
replace regionname = "Middle East/North Africa" if regionname=="Middle East and North Africa"
save /tmp/wdiC.dta, replace //merge in python TODO also here for MLM/HLM etc



//----------------------wvs
//vars from leonie's slide
//https://docs.google.com/presentation/d/1YpGP1VmirIAtTRtKqrpcI0ef7xSu3s-o/edit?slide=id.p6#slide=id.p6}






use ~/data/wvs/wvs,clear  //first quick exploration on cumulative; then subset to wave7

//freedom/autonomy
//for the future awesome vars:  missing (or very few maybe) in wave 7
//!!autInd no, about kids how person perceives aut in others
codebook aut* 
//codebook myself decMys freOrd freEqu //guess mostly missing in new wvs 4.1

//for now i guess just keep last wave
codebook S002VS
keep if S002VS==7

gen countrycode=cc
merge m:1 countrycode using /tmp/wdiC.dta
ta cc  if _merge==1 //oh we are good
//l if _merge==1
drop if _merge==2

gen ccc=c
ta town, gen(TT)
replace class=4 if class==5
label define revclass 4 "Upp mid/upper",modify

cap encode region, gen(rr)
encode incomelevelname, gen(_iii)
recode _iii  (1=3)(2 3=1)(4=2),gen(iii)

recode town (1 2 3 4=1 "lt20k")(5 6 7=2 "20-500k")(8=3 "gt500k"),gen(t3)
recode town (1 2 3=1 "lt10k")(4 5 6 =2 "10-100k")(7=3 "100-500k")(8=4 "gt500k"),gen(t4)
ta town t4, mi
recode satFin (1 2 3 4=1)(5 6 7 =2)(8 9 10=3),gen(sf3)
recode inc (1 2 3 4=1)(5 6 7 =2)(8 9 10=3),gen(in3)
recode inc (1 2=1)(3 4=2)(5 6=3)(7 8=4)(9 10=5),gen(in5)

//findit twostep
//st0745 from http://www.stata-journal.com/software/sj24-2
//https://journals.sagepub.com/doi/pdf/10.1177/1536867X241257801
//https://www.stata.com/meeting/switzerland25/slides/Switzerland25_Kohler.pdf
//https://de.scribd.com/document/935199619/Germany21-Giesecke
//net install st0745
ssc install twostep, replace 
ta t3, gen(TTT)

save /tmp/allCC, replace




use ~/data/wvs/wvs4_1,clear  //first quick exploration on cumulative; then subset to wave7


//freedom/autonomy
//for the future awesome vars:  missing (or very few maybe) in wave 7
//!!autInd no, about kids how person perceives aut in others
codebook aut* 
//codebook myself decMys freOrd freEqu //guess mostly missing in new wvs 4.1

//for now i guess just keep last wave
codebook S002VS
keep if S002VS==7

gen countrycode=cc
merge m:1 countrycode using /tmp/wdiC.dta
ta cc  if _merge==1 //oh we are good
//l if _merge==1
drop if _merge==2

gen ccc=c
ta town, gen(TT)
replace class=4 if class==5
label define revclass 4 "Upp mid/upper",modify

cap encode region, gen(rr)
encode incomelevelname, gen(_iii)
recode _iii  (1=3)(2 3=1)(4=2),gen(iii)

recode town (1 2 3 4=1 "lt20k")(5 6 7=2 "20-500k")(8=3 "gt500k"),gen(t3)
recode town (1 2 3=1 "lt10k")(4 5 6 =2 "10-100k")(7=3 "100-500k")(8=4 "gt500k"),gen(t4)
ta town t4, mi
recode satFin (1 2 3 4=1)(5 6 7 =2)(8 9 10=3),gen(sf3)
recode inc (1 2 3 4=1)(5 6 7 =2)(8 9 10=3),gen(in3)
recode inc (1 2=1)(3 4=2)(5 6=3)(7 8=4)(9 10=5),gen(in5)

//findit twostep
//st0745 from http://www.stata-journal.com/software/sj24-2
//https://journals.sagepub.com/doi/pdf/10.1177/1536867X241257801
//https://www.stata.com/meeting/switzerland25/slides/Switzerland25_Kohler.pdf
//https://de.scribd.com/document/935199619/Germany21-Giesecke
//net install st0745
ssc install twostep, replace 
ta t3, gen(TTT)

save /tmp/allC, replace
//---------



use  /tmp/allC, clear
//unrelated to pcgdp
collapse ls free si_pov_nahc ny_gdp_pcap_kd si_dst_10th_10 sl_uem_totl_zs fp_cpi_totl_zg sp_urb_totl_in_zs, by(cc regionname)
encode regionname,gen(rr)
twoway (scatter free si_dst_10th_10, colorvar(rr) colordiscrete)
tw(qfitci free ny_gdp_pcap_kd)(scatter free ny_gdp_pcap_kd, msymbol(none) mlabel(cc) mlabsize(tiny) mlabposition(0))
tw(qfitci ls sp_urb_totl_in_zs)(scatter ls sp_urb_totl_in_zs, msymbol(none) mlabel(cc) mlabsize(tiny) mlabposition(0))
//but quite strong rel with ineq: 
tw(qfitci free si_dst)(scatter free si_dst, msymbol(none) mlabel(cc) mlabsize(tiny) mlabposition(0))
tw(qfitci free sp_urb_totl_i)(scatter free sp_urb_totl_i, msymbol(none) mlabel(cc) mlabsize(tiny) mlabposition(0))

//--------------playing
use  /tmp/allC, clear

//-------actually yes!; not as strong as swb, but yes someting there !!
//start with global, nothing there, then by region yes! and finally by ctry!!
tabstat free, by(town) stat(mean) format(%9.2f)
//tabstat govRes, by(town) stat(mean) format(%9.2f)

reg free i.town trust inc age age2 male class mar i.c, robust
bys cc: reg free TT1-TT7 trust inc age age2 male class mar , robust  
bys regionname: reg free TT1-TT7 trust inc age age2 male class mar , robust //yes!!! 
bys regionname: reg free TT1-TT7 trust age age2 male mar i.emp class inc satFin health kids rel_imp A066 A074 A098, robust
//east asia huuge effect sizes!!
bys regionname: reg ls TT1-TT7  inc age age2 male class mar , robust 


//------------------ initial paper regressions
use  /tmp/allC, clear
cap est drop *



aok_var_des, ff(free town age male mar emp satFin class inc health kids rel_imp)fname(varDes.tex)
pwcorr free town age male mar une sel ful satFin class inc health kids rel_imp
aok_hist2,x(free town age male mar emp satFin class inc health kids rel_imp)d(./)f(hist)


//A066 A074 A098
//ta regionname, gen(REG)
levelsof regionname, loc(l)
loc cc = 2
foreach ll of local l {
	di "`cc' `ll'"
reg free TT1-TT7 i.rr, robust 
	estimates title: All (with region dummies)
	est sto a1
reg free TT1-TT7 if regionname=="`ll'", robust 
	estimates title: `ll'
	est sto a`cc'
reg free TT1-TT7  age age2 male mar i.emp  satFin health kids rel_imp  i.rr, robust 
	estimates title: All (with region dummies)
	est sto b1	
reg free TT1-TT7  age age2 male mar i.emp satFin health kids rel_imp   if regionname=="`ll'", robust 
	estimates title: `ll'
	est sto b`cc'	
	
	loc cc = `cc' + 1
}

estout a*  using regA.tex ,  cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label  starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)  drop(*rr)
estout b*  using regB.tex ,  cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label  starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)  drop(*rr)





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
estout *  using /tmp/`f'.tab , keep(*t3*) cells(b(star fmt(%9.2f))) replace style(tab)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label  starlevels(+ 0.10 * 0.05) 
//! oocalc /tmp/a.tab
//! sed -i '1s/^/country/' /tmp/a.txt
//! cat /tmp/a.tab | datamash transpose | sed 's/\t/ \& /g' 
! cat /tmp/`f'.tab | /home/aok/Downloads/datamash-1.9/datamash transpose | sed 's/\t/ \& /g' | sed  's/\$/\\\\/' >/home/aok/papers/cityAgency/tex/`f'.tex
end

//famUns criVic trust
rrr, m(reg free ib3.t3 age age2 male mar i.emp satFin health kids rel_imp)f(regCC1)
//rrr, m(reg govRes FF1-FF4 FF6-FF10 age age2 male mar i.emp CL1 CL2 CL4 CL5  satFin)f(regCC2)



twostep cc: reg free TTT1 TTT2 age age2 male mar i.emp satFin health kids rel_imp || edv _b_TTT1  
twostep cc: reg free TTT1 TTT2 age age2 male mar i.emp satFin health kids rel_imp || dot _b_TTT1  ,ylab(,labsize(tiny))  xline(0)  xlab(-1(0.5)1) xlabel(, labsize(small)) scopts(mcolor(black) ms(d)) ciopts(lcol(black)) xtitle("b-coefficients and 95%-CI of life autonomy per country on dummy for lt20k v gt500k (base case)", size(small))
gr export fig-regCC1mod.pdf, replace
//maybe add some options like ysize(12) ylabel(, labsize(small))  
//TODO put this into paper and table into app!!!

//-----------------mlm
//also can pool smaller urb cats
reg free ib8.town trust age age2 male mar i.emp class inc satFin health kids rel_imp A066 A074 A098 i.ccc if ny_gdp_pcap_kd>10000,beta
reg free TT1-TT7 trust age age2 male mar i.emp class inc satFin health kids rel_imp A066 A074 A098 i.ccc if ny_gdp_pcap_kd<10000,beta

//oh ok cool so sth there: la,eur/central asia less free in smaller; east asia and pacific more! also can pool smaller urb cats
bys region: mixed free ib8.town trust age age2 male mar i.emp class inc satFin health kids rel_imp A066 A074 A098 || cc: ,mle

//hmmm not sure
bys incomelevelname: mixed free ib8.town trust age age2 male mar i.emp class inc satFin health kids rel_imp A066 A074 A098 || cc: ,mle

//yes!
mixed free ib8.town trust age age2 male mar i.emp class inc satFin health kids rel_imp A066 A074 A098 || region: ,mle
//yes!
mixed free ib8.town trust age age2 male mar i.emp class inc satFin health kids rel_imp A066 A074 A098 || incomelevelname: ,mle
//nothing
mixed free ib8.town trust age age2 male mar i.emp class inc satFin health kids rel_imp A066 A074 A098  si_pov_nahc ny_gdp_pcap_kd si_dst_10th_10 sl_uem_totl_zs fp_cpi_totl_zg sp_urb_totl_in_zs|| cc: ,mle

//kinda interesting: if already urbanized then city more freedom; even without trust famUns criVic
mixed free c.t4##c.sp_urb_totl_in_zs age age2 male mar i.emp satFin health kids rel_imp  ny_gdp_pcap_kd || cc: c.t4##c.sp_urb_totl_in_zs,mle 
//margins , at(t4=(1 2 3 4)  sp_urb_totl_in_zs=(32 75 90) )
margins , at(sp_urb_totl_in_zs=(32 75 90)  t4=(1 2 3 4))
marginsplot
gr export t-urb.pdf,replace

//again city is better for the rich: meh actually not that much here
mixed free i.t4##c.ny_gdp_pcap_kd    age age2 male mar i.emp satFin health kids rel_imp  || cc: t4,mle
margins , at(  ny_gdp_pcap_kd=(2000 10000 50000) t4=(1 2 3 4))
marginsplot

//meh nothing here
mixed free i.t4##i.iii age age2 male mar i.emp satFin health kids rel_imp  || cc: t4,mle
margins , at(  iii=(1 2 3 4) t4=(1 2 3 4))
marginsplot 
//gr export t-iii.pdf

//nothing here
mixed free c.t4##c.si_dst_10th_10    age age2 male mar i.emp satFin health kids rel_imp  || cc: t4,mle
margins , at(t4=(1 2 3 4)  si_dst_10th_10=(24 27 35) )
marginsplot

mixed free c.t4##i.rr age age2 male mar i.emp satFin health kids rel_imp  || cc: t4,mle
margins , at(t4=(1 2 3 4)  rr=(1 2 3 4 5 6 7))
marginsplot 
gr export t-rr7.pdf
margins , at(t4=(1 2 3 4)  rr=(1 3 6))
marginsplot 
gr export t-rr3.pdf




//just key vars
//super interesting!!!   yes!!!! have a paper!!!!
mixed free ib8.town##c.satFin  trust famUns criVic  age age2 male mar i.emp health kids rel_imp  || cc:   ,mle
mixed free c.town##c.satFin  trust famUns criVic  age age2 male mar i.emp health kids rel_imp  || cc:   ,mle
margins , at(town=(1 3 5 8)  satFin=(1(1)10)) 
marginsplot, x(satFin)  //yes makes sense have a paper!!! fin sat key to enjoying city!!!
gr export ini1.pdf, replace
margins , at(town=(1 8)  satFin=(1(1)10)) 
marginsplot, x(town)
 
reg free ib8.town##c.satFin  trust famUns criVic  age age2 male mar i.emp health kids rel_imp i.ccc,robust

mixed free i.t4##c.satFin  trust famUns criVic  age age2 male mar i.emp health kids rel_imp  || cc:   ,mle
margins t4, at(satFin=(1(1)10))
marginsplot
//marginsplot, xdimension(t4) recast(line) 


mixed free i.t4##i.sf3  trust famUns criVic  age age2 male mar i.emp health kids rel_imp  || cc:   ,mle
margins t4, at(sf=(1(1)3))
marginsplot, xdimension(t4) recast(line) 
gr export ini2.pdf, replace

margins,  at(t4=(1 4)  sf=(1 3))
marginsplot, xdimension(t4) xsize(2) ysize(2)



//little bit
mixed free c.town##c.inc  trust famUns criVic  age age2 male mar i.emp health kids rel_imp  || cc:   ,mle
margins , at(town=(1 3 5 8)  inc=(1(1)10)) 
marginsplot, x(inc)
gr export ini3.pdf, replace

//yes!!!!
mixed free c.town##c.class  trust famUns criVic  age age2 male mar i.emp health kids rel_imp  || cc:   ,mle
margins , at(town=(1 8)  class=(1(1)4)) 
marginsplot, x(town) //to paper!!!!
gr export ini4.pdf, replace
marginsplot, x(class)
gr export ini5.pdf

mixed free c.town##i.class  trust famUns criVic  age age2 male mar i.emp health kids rel_imp  || cc:   ,mle
margins , at(town=(1 3 5 8)  class=(1(1)4)) 
marginsplot, x(class)
gr export ini6.pdf


//little weird with inc
mixed free i.t4##i.inc  trust famUns criVic  age age2 male mar i.emp health kids rel_imp  || cc:   ,mle
margins,  at(t4=(1 4)  inc=(1 2 3 4 5 6 7 8 9 10))
marginsplot, xdimension(t4) xsize(2) ysize(2)
mixed free i.t4##i.in3  trust famUns criVic  age age2 male mar i.emp health kids rel_imp  || cc:   ,mle
margins,  at(t4=(1 4)  in3=(1 2 3))
marginsplot, xdimension(t4) xsize(2) ysize(2)

//paper; with random slope the results are weaker! same without trust and famUns criVic
//MAYBE need couple specs with and without random slope and with and without 1) trust and 2)  famUns criVic!! and think them through!!!
mixed free ib4.t4##i.sf3    age age2 male mar i.emp health kids rel_imp  || cc:   ,mle
est sto a                
margins,  at(t4=(1 4)  sf=(1 2 3))
marginsplot, xdimension(t4) xsize(2) ysize(2) saving(aa1,replace) text(8.25 4 "{bf:a}", size(large))legend(off)text(7.9 2 "top 3 cat")text(7 2 "middle 3 cat")text(6.3 2 "bottom 4 cat")title("financial satisfaction")ytitle("autonomy")xtitle("rural-urban")scheme(s2mono)
mixed free ib4.t4##i.class    age age2 male mar i.emp health kids rel_imp  || cc:  ,mle
est sto b
margins,  at(t4=(1 4)  class=(1 2 3 4))
marginsplot, xdimension(t4) xsize(2) ysize(2) saving(aa2,replace) text(8.25 4 "{bf:b}", size(large))legend(off)text(7.5 2 "upper middle/upper")text(7.25 2 "lower middle")text(7.14 2 "working")text(6.82 2 "lower")title("class")ytitle("")xtitle("rural-urban")scheme(s2mono)
mixed free ib4.t4##i.in5    age age2 male mar i.emp health kids rel_imp  || cc:  ,mle
est sto c
margins,  at(t4=(1 4)  in5=(1 2 3 4 5))
marginsplot, xdimension(t4) xsize(2) ysize(2) saving(aa3,replace) text(8.1 4.4 "{bf:c}", size(large))


gr combine aa1.gph aa2.gph , row(1) ycommon
gr export m-body.pdf,replace

gr combine aa1.gph aa2.gph aa3.gph, row(1) ycommon
gr export m-app.pdf,replace
estout a b c  using regABC.tex ,  cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label  starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)  //drop(*ccc *rr *iii)

//by region and inc group 
reg free ib3.t3##i.sf3  age age2 male mar i.emp health kids rel_imp i.ccc ,robust
margins,  at(t3=(1 3)  sf=(1 2 3))
marginsplot, xdimension(t3) xsize(2) ysize(2) saving(z1,replace) 
levelsof regionname, loc(l)
loc cc = 2
foreach ll of local l {
	di "`cc' `ll'"
reg free ib3.t3##i.sf3  age age2 male mar i.emp health kids rel_imp i.ccc if regionname=="`ll'",robust
margins,  at(t3=(1 3)  sf=(1 2 3))
marginsplot, xdimension(t3) xsize(2) ysize(2) saving(z`cc',replace) title("`ll'")
	loc cc = `cc' + 1
}
gr combine z1.gph z2.gph z3.gph z4.gph z5.gph z6.gph z7.gph z8.gph, row(2) ycommon
gr export zzz.pdf, replace
reg free ib3.t3##i.sf3  age age2 male mar i.emp health kids rel_imp i.ccc ,robust
margins,  at(t3=(1 3)  sf=(1 2 3))
marginsplot, xdimension(t3) xsize(2) ysize(2) saving(x1,replace) 
levelsof incomelevelname, loc(l)
loc cc = 2
foreach ll of local l {
	di "`cc' `ll'"
reg free ib3.t3##i.sf3  age age2 male mar i.emp health kids rel_imp i.ccc if incomelevelname=="`ll'",robust
margins,  at(t3=(1 3)  sf=(1 2 3))
marginsplot, xdimension(t3) xsize(2) ysize(2) saving(x`cc',replace) title("`ll'")
	loc cc = `cc' + 1
}
gr combine x1.gph x2.gph x3.gph x4.gph x5.gph, row(2) ycommon
gr export xxx.pdf, replace


//xdimension(t4) xsize(2) ysize(2) saving(aa1,replace) text(8.1 4.3 "{bf:a}", size(large))legend(off)text(7.9 2 "top 3 cat")text(7 2 "middle 3 cat")text(6.3 2 "bottom 4 cat")title("financial satisfaction")ytitle("autonomy")xtitle("rural-urban")



//ha freedom lower in smaller places in this setup!
mixed free ib8.town trust famUns criVic satFin age age2 male mar i.emp health kids rel_imp  || cc: ,mle
mixed free ib8.town  satFin age age2 male mar i.emp health kids rel_imp  || cc: ,mle //but not here withouit trust famUns criVic!!! so overcontrol bias!!!


//these 2 super cool! but again should have cc dummies and clustered std err
reg free ib8.town c.inc  trust   age age2 male mar i.emp health kids rel_imp i.iii ,robust
reg free ib8.town c.inc          age age2 male mar i.emp health kids rel_imp i.iii ,robust 
reg free ib8.town c.inc  trust   age age2 male mar i.emp health kids rel_imp i.iii i.rr,robust
reg free ib8.town c.inc          age age2 male mar i.emp health kids rel_imp i.iii i.rr,robust



//A066 A074 A098 
cap est drop *
reg free TT1-TT7, 
est sto a1
reg free TT1-TT7 i.rr , robust //i.yr
est sto a1a  
reg free TT1-TT7 i.iii , robust //i.yr
est sto a1b  
reg free TT1-TT7 i.ccc , robust //i.yr
est sto a1c 
reg free TT1-TT7 i.ccc , robust cluster(cc) //i.yr
est sto a1c2 
reg free TT1-TT7  age age2 male mar i.emp  satFin health kids rel_imp , robust
est sto a2
reg free TT1-TT7  age age2 male mar i.emp  satFin health kids rel_imp  i.rr , robust //i.yr
est sto a2a
reg free TT1-TT7  age age2 male mar i.emp  satFin health kids rel_imp  i.iii , robust //i.yr
est sto a2b
reg free TT1-TT7  age age2 male mar i.emp  satFin health kids rel_imp  i.ccc , robust //i.yr
est sto a2c
reg free TT1-TT7  age age2 male mar i.emp  satFin health kids rel_imp  i.ccc , robust cluster(cc) //i.yr
est sto a2c2

estout a*  using regAA.tex ,  cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label  starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)  drop(*ccc *rr *iii)
! sed -i '/^constant/i\region  dummies&no&yes&no&no&no&no&yes&no&no&no\\\\' regAA.tex
! sed -i '/^constant/i\country dummies     &no&no&no&yes&yes&no&no&no&yes&yes\\\\' regAA.tex
! sed -i '/^constant/i\income level dummies&no&no&yes&no&no&no&no&yes&no&no\\\\' regAA.tex
! sed -i '/^constant/i\clustered std err   &no&no&no&no &yes&no&no&yes&no&yes\\\\' regAA.tex



//-------paper regressions--dropping missing ctries; stata bug runs reg with 0 obs in base case
use  /tmp/allC, clear
cap est drop *


//drop if >500k all missing or <50 obs for appendix only
ta cc t3 //whoa!!!
di r(r)
ta t3 if cc=="AND"
levelsof cc,loc(__cc)
foreach _cc in `__cc'{
count if t3 == 3 & cc == "`_cc'"
drop if `r(N)'<50 & cc == "`_cc'"
di "`_cc'"  `r(N)'

} 


ta cc t3
di r(r)


//just for comparison with tertiles having 1st as a base case
twostep cc: reg free TTT2 TTT3 age age2 male mar i.emp satFin health kids rel_imp || edv _b_TTT2  
twostep cc: reg free TTT2 TTT3 age age2 male mar i.emp satFin health kids rel_imp || dot _b_TTT2  ,ylab(,labsize(tiny))  xline(0)  xlab(-1(0.5)1) xlabel(, labsize(small)) scopts(mcolor(black) ms(d)) ciopts(lcol(black)) xtitle("b-coefficients and 95%-CI of life autonomy per country on dummy for 100-500k v lt20k (base case); dropped c if cat gt500k missing", size(small))
gr export fff2.pdf, replace
//just for comparison with tertiles having 1st as a base case
twostep cc: reg free TTT2 TTT3 age age2 male mar i.emp satFin health kids rel_imp || edv _b_TTT3  
twostep cc: reg free TTT2 TTT3 age age2 male mar i.emp satFin health kids rel_imp || dot _b_TTT3  ,ylab(,labsize(tiny))  xline(0)  xlab(-1(0.5)1) xlabel(, labsize(small)) scopts(mcolor(black) ms(d)) ciopts(lcol(black)) xtitle("b-coefficients and 95%-CI of life autonomy per country on dummy for 500k v lt20k (base case); dropped c if cat gt500k missing", size(small))
gr export fff3.pdf, replace

twostep cc: reg free TTT1 TTT2 age age2 male mar i.emp satFin health kids rel_imp || edv _b_TTT1  
twostep cc: reg free TTT1 TTT2 age age2 male mar i.emp satFin health kids rel_imp || dot _b_TTT1  ,ylab(,labsize(tiny))  xline(0)  xlab(-1(0.5)1) xlabel(, labsize(small)) scopts(mcolor(black) ms(d)) ciopts(lcol(black)) xtitle("b-coefficients and 95%-CI of life autonomy per country on dummy for lt20k v gt500k (base case)", size(small))
gr export fig-regCC1mod2.pdf, replace

twostep cc: reg free TTT1 TTT2  mar i.emp satFin health kids rel_imp || edv _b_TTT1  
twostep cc: reg free TTT1 TTT2  mar i.emp satFin health kids rel_imp || dot _b_TTT1  ,ylab(,labsize(tiny))  xline(0)  xlab(-1(0.5)1) xlabel(, labsize(small)) scopts(mcolor(black) ms(d)) ciopts(lcol(black)) xtitle("b-coefficients and 95%-CI of life autonomy per country on dummy for lt20k v gt500k (base case)", size(small))
gr export fig-regCC1mod2w.pdf, replace

//adding ed
twostep cc: reg free TTT1 TTT2  i.X025R mar i.emp satFin health kids rel_imp || edv _b_TTT1  
twostep cc: reg free TTT1 TTT2  i.X025R mar i.emp satFin health kids rel_imp || dot _b_TTT1  ,ylab(,labsize(tiny))  xline(0)  xlab(-1(0.5)1) xlabel(, labsize(small)) scopts(mcolor(black) ms(d)) ciopts(lcol(black)) xtitle("b-coefficients and 95%-CI of life autonomy per country on dummy for lt20k v gt500k (base case)", size(small))
gr export fig-regCC1mod2ww.pdf, replace

twostep cc: reg free TTT1 TTT2  i.X025R mar i.emp satFin health kids rel_imp if yr<2020 || edv _b_TTT1  
twostep cc: reg free TTT1 TTT2  i.X025R mar i.emp satFin health kids rel_imp if yr<2020 || dot _b_TTT1  ,ylab(,labsize(tiny))  xline(0)  xlab(-1(0.5)1) xlabel(, labsize(small)) scopts(mcolor(black) ms(d)) ciopts(lcol(black)) xtitle("b-coefficients and 95%-CI of life autonomy per country on dummy for lt20k v gt500k (base case)", size(small))
gr export fig-regCC1mod2ww20.pdf, replace

mixed free ib4.t4##i.sf3    age age2 male mar i.emp health kids rel_imp  || cc:   ,mle
est sto a                
margins,  at(t4=(1 4)  sf=(1 2 3))
marginsplot, xdimension(t4) xsize(2) ysize(2) saving(aa1,replace) text(8.25 4 "{bf:a}", size(large))legend(off)text(7.9 2 "top 3 cat")text(7 2 "middle 3 cat")text(6.3 2 "bottom 4 cat")title("financial satisfaction")ytitle("autonomy")xtitle("rural-urban")scheme(s2mono)
mixed free ib4.t4##i.class    age age2 male mar i.emp health kids rel_imp  || cc:  ,mle
est sto b
margins,  at(t4=(1 4)  class=(1 2 3 4))
marginsplot, xdimension(t4) xsize(2) ysize(2) saving(aa2,replace) text(8.25 4 "{bf:b}", size(large))legend(off)text(7.5 2 "upper middle/upper")text(7.25 2 "lower middle")text(7.14 2 "working")text(6.82 2 "lower")title("class")ytitle("")xtitle("rural-urban")scheme(s2mono)

gr combine aa1.gph aa2.gph , row(1) ycommon
gr export m-body2.pdf,replace


mixed free ib4.t4##i.sf3     mar i.emp health kids rel_imp  || cc:   ,mle
est sto a                
margins,  at(t4=(1 4)  sf=(1 2 3))
marginsplot, xdimension(t4) xsize(2) ysize(2) saving(aa1,replace) text(8.25 4 "{bf:a}", size(large))legend(off)text(7.9 2 "top 3 cat")text(7 2 "middle 3 cat")text(6.3 2 "bottom 4 cat")title("financial satisfaction")ytitle("autonomy")xtitle("rural-urban")scheme(s2mono)
mixed free ib4.t4##i.class     mar i.emp health kids rel_imp  || cc:  ,mle
est sto b
margins,  at(t4=(1 4)  class=(1 2 3 4))
marginsplot, xdimension(t4) xsize(2) ysize(2) saving(aa2,replace) text(8.25 4 "{bf:b}", size(large))legend(off)text(7.5 2 "upper middle/upper")text(7.25 2 "lower middle")text(7.14 2 "working")text(6.82 2 "lower")title("class")ytitle("")xtitle("rural-urban")scheme(s2mono)

gr combine aa1.gph aa2.gph , row(1) ycommon
gr export m-body2q.pdf,replace

mixed free ib4.t4##i.sf3   i.X025R    mar i.emp health kids rel_imp  || cc:   ,mle
est sto a                
margins,  at(t4=(1 4)  sf=(1 2 3))
marginsplot, xdimension(t4) xsize(2) ysize(2) saving(aa1,replace) text(8.25 4 "{bf:a}", size(large))legend(off)text(7.9 2 "top 3 cat")text(7 2 "middle 3 cat")text(6.3 2 "bottom 4 cat")title("financial satisfaction")ytitle("autonomy")xtitle("rural-urban")scheme(s2mono)
mixed free ib4.t4##i.class   i.X025R    mar i.emp health kids rel_imp  || cc:  ,mle
est sto b
margins,  at(t4=(1 4)  class=(1 2 3 4))
marginsplot, xdimension(t4) xsize(2) ysize(2) saving(aa2,replace) text(8.25 4 "{bf:b}", size(large))legend(off)text(7.5 2 "upper middle/upper")text(7.25 2 "lower middle")text(7.14 2 "working")text(6.82 2 "lower")title("class")ytitle("")xtitle("rural-urban")scheme(s2mono)

gr combine aa1.gph aa2.gph , row(1) ycommon
gr export m-body2qv.pdf,replace

mixed free ib4.t4##i.sf3   i.X025R    mar i.emp health kids rel_imp if yr<2020 || cc:   ,mle
est sto a                
margins,  at(t4=(1 4)  sf=(1 2 3))
marginsplot, xdimension(t4) xsize(2) ysize(2) saving(aa1,replace) text(8.25 4 "{bf:a}", size(large))legend(off)text(7.9 2 "top 3 cat")text(7 2 "middle 3 cat")text(6.3 2 "bottom 4 cat")title("financial satisfaction")ytitle("autonomy")xtitle("rural-urban")scheme(s2mono)
mixed free ib4.t4##i.class   i.X025R    mar i.emp health kids rel_imp if yr<2020  || cc:  ,mle
est sto b
margins,  at(t4=(1 4)  class=(1 2 3 4))
marginsplot, xdimension(t4) xsize(2) ysize(2) saving(aa2,replace) text(8.25 4 "{bf:b}", size(large))legend(off)text(7.5 2 "upper middle/upper")text(7.25 2 "lower middle")text(7.14 2 "working")text(6.82 2 "lower")title("class")ytitle("")xtitle("rural-urban")scheme(s2mono)

gr combine aa1.gph aa2.gph , row(1) ycommon
gr export m-body2qv20.pdf,replace



//----tertiles
use  /tmp/allC, clear
cap est drop *

gen tertile=.

ta cc t3 
di r(r)
ta t3 if cc=="AND"
levelsof cc,loc(__cc)
foreach _cc in `__cc'{
xtile tertile`_cc'=town if cc == "`_cc'", nq(3)
replace tertile = tertile`_cc' if cc == "`_cc'"
} 

ta cc tertile
ta tertile, gen(LL) 

twostep cc: reg free LL2 LL3  || edv _b_LL2 
twostep cc: reg free LL2 LL3  || dot _b_LL2  ,ylab(,labsize(tiny))  xline(0)  xlab(-1(0.5)1) xlabel(, labsize(small)) scopts(mcolor(black) ms(d)) ciopts(lcol(black)) xtitle("2nd tertile", size(small))
gr export l2a.pdf,replace
twostep cc: reg free LL2 LL3   || edv _b_LL3 
twostep cc: reg free LL2 LL3   || dot _b_LL3  ,ylab(,labsize(tiny))  xline(0)  xlab(-1(0.5)1) xlabel(, labsize(small)) scopts(mcolor(black) ms(d)) ciopts(lcol(black)) xtitle("3rd tertile", size(small))
gr export l3a.pdf,replace


twostep cc: reg free LL2 LL3  age age2 male mar i.emp satFin health kids rel_imp || edv _b_LL2 
twostep cc: reg free LL2 LL3 age age2 male mar i.emp satFin health kids rel_imp  || dot _b_LL2  ,ylab(,labsize(tiny))  xline(0)  xlab(-1(0.5)1) xlabel(, labsize(small)) scopts(mcolor(black) ms(d)) ciopts(lcol(black)) xtitle("2nd tertile", size(small))
gr export l2b.pdf,replace
twostep cc: reg free LL2 LL3  age age2 male mar i.emp satFin health kids rel_imp || edv _b_LL3 
twostep cc: reg free LL2 LL3 age age2 male mar i.emp satFin health kids rel_imp  || dot _b_LL3  ,ylab(,labsize(tiny))  xline(0)  xlab(-1(0.5)1) xlabel(, labsize(small)) scopts(mcolor(black) ms(d)) ciopts(lcol(black)) xtitle("3rd tertile", size(small))
gr export l3b.pdf,replace






//------------------------------political freedom, influence over polititcs





//yeah they should be in wave7 file only i already created dofile for that one
d A168 fair fair10 E032 freOrd autInd aut E069_07 E069_11 E069_12  sts_dem
sum A168 fair fair10 E032 freOrd autInd aut E069_07 E069_11 E069_12  sts_dem
sum freEqu freOrd  E032

//but for now just going with political say
//use ~/data/wvs/wvs,clear
//keep if S002VS==7
use /tmp/allCC.dta


tabstat free, by(t3) stat(mean) format(%9.2f)
tabstat polSay, by(t3) stat(mean) format(%9.2f) //hmm weird
graph hbar (mean) polSay, over(t3) over(iii)  //yea
gr export psBar.pdf,replace


tabstat polSay if cc=="USA", by(town) stat(mean) format(%9.2f)


and central place capital etc var!

reg free TTT2 TTT3  mar i.emp satFin health kids rel_imp i.ccc, robust
//ha now sig just tiny effect siz

reg polSay TTT2 TTT3  mar i.emp satFin health kids rel_imp i.ccc, robust

reg polSay TTT2 TTT3  mar i.emp satFin health kids rel_imp i.ccc if iii==1, robust
reg polSay TTT2 TTT3  mar i.emp satFin health kids rel_imp i.ccc if iii==3, robust
//yes!!!

reg polSay i.t3##i.iii  mar i.emp satFin health kids rel_imp  i.ccc, robust
//margins t3,  at(iii=(1  3))
margins,  at(t3=(1 2 3)  iii=(1 2 3))
marginsplot,  //for some reason doesnt work

reg polSay i.t3##i.iii  mar i.emp satFin health kids rel_imp  , robust //cluster(ccc)
reg polSay i.t3##i.iii  mar i.emp satFin health kids rel_imp  , robust cluster(ccc)
//margins t3,  at(iii=(1  3))
margins,  at(t3=(1 2 3)  iii=(1 2 3))
marginsplot, 

mixed polSay i.t3##i.iii  mar i.emp satFin health kids rel_imp  || cc: i.t3  ,mle
margins,  at(t3=(1 2 3)  iii=(1 2 3))
marginsplot,saving(a1,replace)ytitle("political say")scheme(s2mono)xsc(off)title("") text(2.98 1.4 "low and lower middle") //legend(off)
gr export m-ps1.pdf,  replace


reg free i.t3##i.iii  mar i.emp satFin health kids rel_imp  , robust cluster(cc) 
//margins t3,  at(iii=(1  3))
margins,  at(t3=(1 2 3)  iii=(1 2 3))
marginsplot, 

//ok cool so opposite to polSay: free little higher in poorer places; but not in the richest ones
//makes sense in backwards cc cities may be oasis of freedom; BUT insig!
mixed free i.t3##i.iii  mar i.emp satFin health kids rel_imp  || cc:  i.t3 ,mle
margins,  at(t3=(1 2 3)  iii=(1 2 3))
marginsplot,saving(a2,replace)ytitle("individual freedom")scheme(s2mono)
gr export m-f1.pdf,      replace

graph combine a1.gph a2.gph, cols(1)  xsize(2) ysize(4) scale(1)
gr export m-fps.pdf,replace


//ok i guess sth here too, similar to free; but not with random slope: i.t4##i.sf3
mixed polSay i.t4##i.sf3    age age2 male mar i.emp health kids rel_imp  || cc:    ,mle
est sto a                
margins,  at(t4=(1 4)  sf=(1 2 3))
marginsplot
, xdimension(t4) xsize(2) ysize(2) saving(aa1,replace) text(8.25 4 "{bf:a}", size(large))legend(off)text(7.9 2 "top 3 cat")text(7 2 "middle 3 cat")text(6.3 2 "bottom 4 cat")title("financial satisfaction")ytitle("autonomy")xtitle("rural-urban")scheme(s2mono)
mixed polSay ib4.t4##i.class    age age2 male mar i.emp health kids rel_imp  || cc:  ,mle
est sto b
margins,  at(t4=(1 4)  class=(1 2 3 4))
marginsplot
, xdimension(t4) xsize(2) ysize(2) saving(aa2,replace) text(8.25 4 "{bf:b}", size(large))legend(off)text(7.5 2 "upper middle/upper")text(7.25 2 "lower middle")text(7.14 2 "working")text(6.82 2 "lower")title("class")ytitle("")xtitle("rural-urban")scheme(s2mono)
mixed polSay ib4.t4##i.in5    age age2 male mar i.emp health kids rel_imp  || cc:  ,mle
est sto c
margins,  at(t4=(1 4)  in5=(1 2 3 4 5))
marginsplot
, xdimension(t4) xsize(2) ysize(2) saving(aa3,replace) text(8.1 4.4 "{bf:c}", size(large))

gr combine aa1.gph aa2.gph , row(1) ycommon
gr export m-polSay.pdf,replace




ta cc t3 //whoa!!!
di r(r)
ta t3 if cc=="AND"
levelsof cc,loc(__cc)
foreach _cc in `__cc'{
count if t3 == 3 & cc == "`_cc'"
drop if `r(N)'<50 & cc == "`_cc'"
di "`_cc'"  `r(N)'

} 
ta cc t3
di r(r)
twostep cc: reg free TTT2 TTT3 age age2 male mar i.emp satFin health kids rel_imp || edv _b_TTT3
twostep cc: reg free TTT2 TTT3 age age2 male mar i.emp satFin health kids rel_imp || dot _b_TTT3  ,ylab(,labsize(tiny))  xline(0)  xlab(-1(0.5)1) xlabel(, labsize(small)) scopts(mcolor(black) ms(d)) ciopts(lcol(black)) xtitle("b-coefficients and 95%-CI of life autonomy per country on dummy for  gt500k v lt20k  (base case)", size(small))
gr export ts-polSay.pdf, replace
use /tmp/allCC.dta,clear
