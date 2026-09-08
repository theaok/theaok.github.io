stata

run /home/aok/papers/root/do/aok_programs.do
cd /home/aok/papers/leonieAgency/tex

//-------------------wid crap dont use it

ssc install wid
help wid

/* do not use it!
cryptic crap: https://wid.world/summary-table/

cryptic crap: wid.world/codes-dictionary

a                    average [i guess per capita]
s                    share
t                    threshold
m                    macroeconomic total
w                    wealth/income ratio

x	                  exchange rate (market or PPP)

ptinc                pre-tax national income
pllin                pre-tax labor income
pkkin                pre-tax capital income
fiinc                fiscal income
hweal                net personal wealth

pop  i=individuals
ages 999=all ages
perc the top 1% share:  p99p100. The top 10% share excluding the top 1% is p90p99
*/

-PPP xlcusp agdpro
wid, indicators(xlcusp) areas(_all)  year(2020) ages(999) pop(i) metadata  clear
perc(p90p100 p99p100)

keep country countryname value unit unitlabel
//different currencies


reshape wide value, i(year) j(percentile) string
label variable valuep90p100 "Top 10% share"
label variable valuep99p100 "Top 1% share"



//------------------wb



//ssc install wbopendata, replace
//net install wbopendata, from("https://raw.githubusercontent.com/jpazvd/wbopendata/main")replace

//double check and get defs
//https://data.worldbank.org/indicator/NY.GDP.PCAP.KD

//avg10yr  bc 1yr lots missig, even 5 lots of missing, !! say in paper
wbopendata, indicator(SI.POV.NAHC;NY.GDP.PCAP.KD;SI.DST.10TH.10;SL.UEM.TOTL.ZS;FP.CPI.TOTL.ZG;SP.URB.TOTL.IN.ZS)clear long 
keep if year>=2015 & year<=2025
keep regionname countrycode countryname incomelevelname year si_pov_nahc ny_gdp_pcap_kd si_dst_10th_10 sl_uem_totl_zs fp_cpi_totl_zg sp_urb_totl_in_zs
collapse si_pov_nahc ny_gdp_pcap_kd si_dst_10th_10  sl_uem_totl_zs fp_cpi_totl_zg sp_urb_totl_in_zs, by(regionname countrycode countryname incomelevelname)
l countrycode si_pov_nahc ny_gdp_pcap_kd si_dst_10th_10  sl_uem_totl_zs fp_cpi_totl_zg sp_urb_totl_in_zs

replace ny_gdp_pcap_kd=ln(ny_gdp_pcap_kd)

la var si_pov_nahc "perc poor, natl poverty line"
la var ny_gdp_pcap_kd "lnGDP per capita (constant 2015 usd)"
la var si_dst_10th_10 "income share held by top 10perc"
la var sl_uem_totl_zs "unemployment, perc of tot labor force"
la var fp_cpi_totl_zg "perc inflation, consumer prices"
la var sp_urb_totl_in_zs "perc urban"

/* TODO
At some point would be useful some welfare measures
and Can get data back in time like on GDP gro and inequality back in time--and see how past/growing up during difficult times affected free and preRed now!
*/


//LATER:
/*
note ny_gdp_pcap_kd: "GDP per capita is gross domestic product divided by midyear population. GDP is the sum of gross value added by all resident producers in the economy plus any product taxes and minus any subsidies not included in the value of the p\
roducts. It is calculated without making deductions for depreciation of fabricated assets or for depletion and degradation of natural resources. Data are in constant U.S. dollars."
d
note si_pov_nahc: ""
*/

l in 1/3
save /tmp/wdi.dta, replace //merge in python TODO also here for MLM/HLM etc



//----------------------wvs
//vars from leonie's slide
//https://docs.google.com/presentation/d/1YpGP1VmirIAtTRtKqrpcI0ef7xSu3s-o/edit?slide=id.p6#slide=id.p6}



use ~/data/wvs/wvs,clear  //first quick exploration on cumulative; then subset to wave7

//freedom/autonomy
//for the future awesome vars:  missing (or very few maybe) in wave 7
//!!autInd no, about kids how person perceives aut in others
codebook aut* 
codebook myself decMys freOrd freEqu


//michael/erick: patterns by race, yes!

//whites only like .2 more than blacks
tabstat free if cc=="USA",stat(mean n) by(ethGr)

//asian lower by .5
tabstat free if cc=="AUS",stat(mean n) by(ethGr)

//south eur lower by .4
tabstat free if cc=="DEU",stat(mean n) by(ethGr)

//sou afr here big .9 
tabstat  free if c==710,stat(mean n) by(ethGr) 


//see if any patters by inc, guess not
tabstat free if cc=="USA",by(inc) 
tabstat free if cc=="NLD",by(inc) 
tabstat free if cc=="BRA",by(inc)  //wow! yes!
tabstat free if cc=="COL",by(inc) //meh same as west
tabstat free if cc=="ECU",by(inc) //meh same as west

//for now i guess just keep last wave
codebook S002VS 
keep if S002VS==7

gen countrycode=cc
merge m:1 countrycode using /tmp/wdi.dta
ta cc  if _merge==1 //oh we are good
//l if _merge==1
drop if _merge==2

gen ccc=c

lookfor class
ta class, gen (CL)
d CL*

ta free, gen(FF)
d FF*

save /tmp/all, replace

//---------

use /tmp/all, clear

tw(qfitci govRes ny_gdp_pcap_kd)

collapse  govRes free si_pov_nahc ny_gdp_pcap_kd si_dst_10th_10 sl_uem_totl_zs fp_cpi_totl_zg, by(cc)

//no rel
tw(qfitci govRes ny_gdp_pcap_kd)(scatter govRes ny_gdp_pcap_kd,mlab(cc))
tw(qfitci free ny_gdp_pcap_kd)(scatter free ny_gdp_pcap_kd, msymbol(none) mlabel(cc) mlabsize(tiny) mlabposition(0))
tw(qfitci govRes si_dst)(scatter govRes si_dst, msymbol(none) mlabel(cc) mlabsize(tiny) mlabposition(0))

tw(qfitci govRes free)(scatter govRes free, msymbol(none) mlabel(cc) mlabsize(tiny) mlabposition(0))
gr export govRes_free.pdf, replace



tw(qfitci free si_dst)(scatter free si_dst, msymbol(none) mlabel(cc) mlabsize(tiny) mlabposition(0))
gr export free_ine.pdf, replace

tw(qfitci free si_pov)(scatter free si_pov, msymbol(none) mlabel(cc) mlabsize(tiny) mlabposition(0))
gr export free_pov.pdf, replace









//--------------------------------------playing
use  /tmp/all, clear

//welfare/redistribution
sum wrkLaz pooLaz subPoo escPov priPub trust  fair //fair not in wave7
codebook wrkLaz pooLaz subPoo escPov priPub trust,ta(100) //use these later;
//leonies from slides:
sum weaAll incIne govRes comBad worSuc
alpha weaAll incIne govRes comBad worSuc
pwcorr weaAll incIne govRes comBad worSuc //very low!!


reg govRes free, robust 
est sto a1

reg govRes free i.ccc, robust //same
est sto a1cc

reg govRes free  satFin, robust 
est sto a1satFin

reg govRes free inc age age2 male class mar, robust
est sto a2
reg govRes c.free##c.satFin inc age age2 male class mar , robust 
est sto a3

//meh these marginplots not super interesting
//skipping free#inc as only mariginally sig
reg govRes i.free i.satFin inc age age2 male class mar , robust 
reg govRes i.free##c.satFin inc age age2 male class mar , robust 
cap recode free (1 2 3=1)(4 5 6=2)(7 8 9 10=3)  ,gen(free3)
cap recode satFin (1 2 3=1)(4 5 6=2)(7 8 9 10=3),gen(satFin3)
reg govRes i.free3##c.satFin inc age age2 male class mar , robust 
margins free3, at(satFin=(1(1)10)) 
marginsplot, x(satFin)
reg govRes i.satFin3##c.free inc age age2 male class mar , robust 
margins satFin3, at(free=(1(1)10))
marginsplot, x(free)
gr export m-satFin3.pdf,replace

reg govRes i.satFin3##i.free3 inc age age2 male class mar , robust 
margins satFin3, at(free3=(1(1)3))
marginsplot, x(free3)






reg govRes c.free##c.inc age age2 male class mar , robust 
est sto a4

//sig interaction with class
reg govRes c.free##c.class satFin inc age age2 male mar , robust 
//margins free, at(class=(1(1)5)) 
//marginsplot, x(free)
reg govRes c.free##c.class        inc age age2 male mar , robust 
est sto a5

reg govRes c.free##i.class        inc age age2 male mar , robust 
est sto a5a

estout a*  using regA.tex ,  cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label  starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) drop(*ccc)



reg govRes i.free, robust 
est sto b1
margins free
marginsplot

reg govRes i.free inc age age2 male class mar, robust 
est sto b2
reg govRes i.free inc age age2 male class mar satFin, robust  
est sto b3
margins free
marginsplot
gr export m-b3.pdf


estout b*  using regB.tex ,  cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label  starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) drop(*c)



ta cc
bys cc: reg govRes free, robust //like my citoes paper see code there

//capitalistic
reg govRes free if cc=="USA", robust //im geographer so lets do by geo
reg govRes free if cc=="SGP", robust
reg govRes free if cc=="HKG", robust
reg govRes free if cc=="NLD", robust
reg govRes free if cc=="DEU", robust //not in germany, hippie green
reg govRes free if cc=="AUS", robust //yes in aus!
reg govRes free if cc=="GBR", robust
reg govRes free if cc=="CAN", robust

//humanistic
reg govRes free if cc=="BRA", robust //positive!
reg govRes free if cc=="MEX", robust
reg govRes free if cc=="ECU", robust
reg govRes free if cc=="COL", robust
reg govRes free if cc=="BOL", robust
reg govRes free if cc=="ARG", robust //like capitalistic, javier milleau

//extremes for some reason
reg govRes free if cc=="LBN", robust
reg govRes free if cc=="CZE", robust



//capitalistic
reg govRes free inc age age2 male class mar if cc=="USA", robust 
reg govRes free inc age age2 male class mar if cc=="SGP", robust
reg govRes free inc age age2 male class mar if cc=="HKG", robust
reg govRes free inc age age2 male class mar if cc=="NLD", robust
reg govRes free inc age age2 male class mar if cc=="DEU", robust //still no  
reg govRes free inc age age2 male class mar if cc=="AUS", robust 
reg govRes free inc age age2 male class mar if cc=="GBR", robust //no obs
reg govRes free inc age age2 male class mar if cc=="CAN", robust //less

//humanistic
reg govRes free inc age age2 male class mar  if cc=="BRA", robust //pos and sig!
reg govRes free inc age age2 male class mar  if cc=="MEX", robust
reg govRes free inc age age2 male class mar  if cc=="ECU", robust
reg govRes free inc age age2 male class mar  if cc=="COL", robust
reg govRes free inc age age2 male class mar  if cc=="BOL", robust
reg govRes free inc age age2 male class mar  if cc=="ARG", robust

//extremes for some reason
reg govRes free inc age age2 male class mar  if cc=="LBN", robust //still
reg govRes free inc age age2 male class mar  if cc=="CZE", robust //cut by half




//------------------------paper regressions----------------------


// LATER can try other relig var, there are more
// now did emp dummies but guess could just focus on une sel
// ethGrp maybe later, also like 10k fewr obs than others and different for every cc
// ed: dont have obs
// social connectedness only few already controling in final model
// occupation or industry none
// maybe later sth with these: worSuc wrkLaz freEqu 

//MAYBE/LATER: 
can argue like Bartram as per controls (overcontrol bias etc) as i did in unhappiness unpredictability Lonnie paper; and the SCA curves



use  /tmp/all, clear

pwcorr govRes free age age2 male mar une sel class satFin health kids bel_god rel_imp

aok_hist2,x(govRes free age age2 male mar une sel class satFin health kids bel_god rel_imp)d(./)f(hist)


est drop *

reg govRes free, robust 
est sto a1

reg govRes free i.ccc, robust //same
est sto a2
//i.yr no need they drop out bc of collinearity

reg govRes free satFin i.ccc, robust //inc class 
reg govRes free age age2 male mar i.emp i.ccc, robust
est sto a3

reg govRes free age age2 male mar CL1 CL2 CL4 CL5 i.ccc, robust
reg govRes free age age2 male mar i.emp CL1 CL2 CL4 CL5  i.ccc, robust
est sto a4

reg govRes free age age2 male mar i.emp CL1 CL2 CL4 CL5  satFin i.ccc, robust
est sto a5

reg govRes c.free##c.class age age2 male mar i.emp  satFin i.ccc, robust
reg govRes c.free##i.class age age2 male mar i.emp  satFin i.ccc, robust
est sto a6
margins, at(free=(1 2 3 4 5 6 7 8 9 10) class=(1 3 5)) 
marginsplot //yeah not much despite reg coef sig
gr export m-a6.pdf, replace


reg govRes free age age2 male mar i.emp CL1 CL2 CL4 CL5  satFin health kids bel_god rel_imp  i.ccc, robust
est sto a7
 

estout a*  using regA2.tex ,  cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label  starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) drop(*ccc)
! sed -i '/^constant/i\country dummies&no&yes&yes&yes&yes&yes&yes\\\\' regA2.tex
! sed -i '/^Lower class    /i\class dummies (base: lower):&&&&&&&\\\\' regA2.tex
! sed -i '/Lower class/d' regA2.tex



reg govRes FF1-FF4 FF6-FF10, robust 
est sto b1

reg govRes FF1-FF4 FF6-FF10 i.ccc, robust //little diff
est sto b2

reg govRes FF1-FF4 FF6-FF10 satFin i.ccc, robust //inc class 
reg govRes FF1-FF4 FF6-FF10 age age2 male mar i.emp i.ccc, robust
est sto b3

reg govRes FF1-FF4 FF6-FF10 age age2 male mar i.emp CL1 CL2 CL4 CL5 i.ccc, robust
reg govRes FF1-FF4 FF6-FF10 age age2 male mar i.emp CL1 CL2 CL4 CL5  i.ccc, robust
est sto b4

reg govRes FF1-FF4 FF6-FF10 age age2 male mar i.emp CL1 CL2 CL4 CL5  satFin i.ccc, robust
est sto b5
//margins free
//marginsplot
//gr export m-b5.pdf,replace

reg govRes FF1-FF4 FF6-FF10 age age2 male mar i.emp CL1 CL2 CL4 CL5  satFin health kids bel_god rel_imp  i.ccc, robust
est sto b6

estout b*  using regB2.tex ,  cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label  starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) drop(*ccc)
! sed -i '/^constant/i\country dummies&no&yes&yes&yes&yes&yes\\\\' regB2.tex
! sed -i '/^None at all/i\freedom/autonomy dummies (base: 1 None at all):&&&&&&&\\\\' regB2.tex
! sed -i '/None at all   /d' regB2.tex


bys region: reg govRes FF1-FF4 FF6-FF10 age age2 male mar i.empCL1 CL2 CL4 CL5  satFin health kids bel_god rel_imp , robust

//and then by country like cities paper urb unhappiness is common: swbCityWorld.do
//a see above under playing many interesting results!
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
estout *  using /tmp/`f'.tab , keep(*FF*) cells(b(star fmt(%9.2f))) replace style(tab)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label  starlevels(+ 0.10 * 0.05) 
//! oocalc /tmp/a.tab
//! sed -i '1s/^/country/' /tmp/a.txt
//! cat /tmp/a.tab | datamash transpose | sed 's/\t/ \& /g' 
! cat /tmp/`f'.tab | /tmp/datamash-1.9/datamash transpose | sed 's/\t/ \& /g' | sed  's/\$/\\\\/' >/home/aok/papers/leonieAgency/tex/`f'.tex
end

rrr, m(reg govRes free age age2 male mar i.emp CL1 CL2 CL4 CL5  satFin)f(regTT1)
rrr, m(reg govRes FF1-FF4 FF6-FF10 age age2 male mar i.emp CL1 CL2 CL4 CL5  satFin)f(regTT2)


//mlm
//from leonies slides:
//H2: This impact is stronger in more affluent, more unequal and less trusting societies.
//found oposite in unequal lat am impact lower
mixed govRes free ||cc:

mixed govRes c.free##c.ny_gdp_pcap_kd ||cc: free, mle
est sto c1
margins, at(free=(1(1)10) ny_gdp_pcap_kd=(2500 10000 50000)) 
marginsplot, xdimension(free) recast(line) 

mixed govRes c.free##c.ny_gdp_pcap_kd age age2 male mar i.emp CL1 CL2 CL4 CL5  satFin ||cc: free, mle
est sto c2
margins, at(free=(1(1)10) ny_gdp_pcap_kd=(7.5 9.2 10.8)) 
marginsplot, xdimension(free) recast(line) 
gr export m-c2.pdf



mixed govRes c.free##c.si_dst_10th_10 ||cc: free, mle
est sto c3
margins, at(free=(1(1)10) si_dst_10th_10=(23 27 35))
marginsplot, xdimension(free) recast(line) 

mixed govRes c.free##c.si_dst_10th_10 age age2 male mar i.emp CL1 CL2 CL4 CL5  satFin ||cc: free, mle
est sto c4
margins, at(free=(1(1)10) si_dst_10th_10=(23 27 35)) 
marginsplot, xdimension(free) recast(line) 
gr export m-c4.pdf


//cap bys cc: egen trustC=mean(trust)
mixed govRes c.free##c.si_pov_nahc ||cc: free, mle
est sto c5
//margins, at(free=(1(1)10) trustC=(.1 .2 .5))
//marginsplot, xdimension(free) recast(line) 

mixed govRes c.free##c.si_pov_nahc age age2 male mar i.emp CL1 CL2 CL4 CL5  satFin ||cc: free, mle
est sto c6
//margins, at(free=(1(1)10) trustC=(.1 .2 .5))
//marginsplot, xdimension(free) recast(line) 


mixed govRes c.free##c.sl_uem_totl_zs ||cc: free, mle
est sto c7
margins, at(free=(1(1)10) sl_uem_totl_zs=(3 5 10))
marginsplot, xdimension(free) recast(line) 

mixed govRes c.free##c.sl_uem_totl_zs age age2 male mar i.emp CL1 CL2 CL4 CL5  satFin ||cc: free, mle
est sto c8
margins, at(free=(1(1)10) sl_uem_totl_zs=(3 5 10))
marginsplot, xdimension(free) recast(line) 
gr export m-c8.pdf

mixed govRes c.free##c.fp_cpi_totl_zg ||cc: free, mle
est sto c9
margins, at(free=(1(1)10) fp_cpi_totl_zg=(2 4 7))
marginsplot, xdimension(free) recast(line) 

mixed govRes c.free##c.fp_cpi_totl_zg age age2 male mar i.emp CL1 CL2 CL4 CL5  satFin ||cc: free, mle
est sto c10
margins, at(free=(1(1)10) fp_cpi_totl_zg=(2 4 7))
marginsplot, xdimension(free) recast(line) 


estout c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 using regC2.tex ,  cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label  starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) order(free* *ny_gdp_pcap_kd *si_dst_10th_10 *si_pov_nahc *sl_uem_totl_zs *fp_cpi_totl_zg) //drop(*ccc)
! sed -i 's/_/\\_/g' regC2.tex
//! sed -i '/^constant/i\country dummies&yes&yes&yes&yes&yes&yes\\\\' regC1.tex
//! sed -i '/^None at all/i\freedom/autonomy dummies (base: 1 None at all):&&&&&&&\\\\' regB1.tex
//! sed -i '/None at all   /d' regB1.tex

//MAYBE/LATER maybe another paper for now have a ton results already!
finally growing up during financial crisis real quick
and cp paste into leonies word doc!
