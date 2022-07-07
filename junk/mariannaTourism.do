//TODOand have commands in the template like aokhist listtex stepwise etc
 
have most of the stuff outputted to online appendix:)--start with that and then
select stuff to paper--have brief narrative describng patterns in online app too

have one section for data mining that outputs graphs scatterplots lfits forrestplots dotplots and
regressions to res in pdf and one that actually does stuff for the paper !!!

and have commands in the template like aokhist listtex stepwise etc

*E.G. many additional vars commented out that can be used in the future  
* double check everything with "assert" inspect etc

rememebr to run!!
git add *.do *.tex  *.org -n

clear                                  
stata
capture set maxvar 10000
version 14                             
set more off                           
run ~/papers/root/do/aok_programs.do

loc pap mariannaTourism
loc d = "/home/aok/papers/" + "`pap'" + "/"       

capture mkdir "`d'tex"                 
capture mkdir "`d'scr"
capture mkdir "/tmp/`pap'"

loc tmp "/tmp/`pap'/"

//file open tex using `d'out/tex, write text replace
//file write tex `"%<*ginipov>`:di  %9.2f `r(rho)''%</ginipov>"' 

//file open f using `d'notes.txt, write replace
//file write f  "a note...." _n _n


**** dat_man


insheet using ~/data/data_sources.csv, names clear
list  if regexm(tag, "seg")



*** eurostat

//TODO polit put into data folder and add more vars there, essp nights at establisgments as opposed to just arrivals
insheet using ~/data/eurostat/data/tour_occ_arn2.tsv,clear tab
ta v1 in 1/1000
ta v1 in 3000/5000
ta v1 in 8000/10000
gen s1 = regexs(1) if regexm(v1, "([0-9a-zA-Z _-]*),")
gen s2 = regexs(1) if regexm(v1, "[0-9a-zA-Z _-]*,([0-9a-zA-Z _-]*),")
gen s3 = regexs(1) if regexm(v1, "[0-9a-zA-Z _-]*,[0-9a-zA-Z _-]*,([0-9a-zA-Z _-]*),")
gen s4 = regexs(1) if regexm(v1, "[0-9a-zA-Z _-]*,[0-9a-zA-Z _-]*,[0-9a-zA-Z _-]*,([0-9a-zA-Z _-]*)")
ta s1, mi
ta s2, mi //NR must be number and PCH_PRE must be change on the previous period :)
ta s3, mi
ta s4, mi

d
renvars v2-v26 / y2014  y2013  y2012  y2011   y2010  y2009  y2008  y2007  y2006  y2005  y2004  y2003  y2002  y2001  y2000 y1999  y1998  y1997  y1996  y1995  y1994  y1993  y1992  y1991  y1990
l in 1
drop in 1
drop v1

keep if s2=="NR"
drop s2

ta s3 s1 //huh?
ren s4 nuts

gen id=_n
reshape long y, i(id)j(year)

tostring year, replace
gen cY=nuts+ "___" + year

sort nuts year
l in 1/100 //aha! what is this B001 B002??
//aha !
// B001 	Arrivals of residents
//	B002 	Arrivals of non-residents
//	B003 	Arrivals, total
//!!very cool can then see trust by whether locals or not :)
replace s1="res" if s1=="B001"
replace s1="nr" if s1=="B002"
replace s1="tot" if s1=="B003"

replace s3=strtoname(s3)
ta s3
//I551 (hotels and similar accommodation)
//I552 (holiday and other short-stay accommodation);
//I553 (camping grounds, recreational vehicle parks and trailer parks).

//!!LATER can use others :)
keep if s3=="I551_I553"

gen code= s1 + "_" + s3
drop id s1 s3
reshape wide y, i(cY)j(code)string
d
destring year, replace
foreach v of varlist ytot_I551_I553 ynr_I551_I553 yres_I551_I553  { //LATER look at this colser!
replace `v' = regexs(0) if(regexm(`v', "[0-9]*"))
}
destring ytot_I551_I553 ynr_I551_I553 yres_I551_I553, replace ignore(":")

ta year
bys nuts: egen arrNR90_95=mean(ynr_I551_I553) if year >1989 & year<1996
bys nuts: egen arrNR00_05=mean(ynr_I551_I553) if year >1999 & year<2006
bys nuts: egen arrNR=mean(ynr_I551_I553) if year >2009 & year<2014 //these are the years for ess data

bys nuts: egen arr90_95=mean(ytot_I551_I553) if year >1989 & year<1996
bys nuts: egen arr00_05=mean(ytot_I551_I553) if year >1999 & year<2006
bys nuts: egen arr=mean(ytot_I551_I553) if year >2009 & year<2014

bys nuts: egen arrR90_95=mean(yres_I551_I553) if year >1989 & year<1996
bys nuts: egen arrR00_05=mean(yres_I551_I553) if year >1999 & year<2006
bys nuts: egen arrR=mean(yres_I551_I553) if year >2009 & year<2014

collapse arr*, by(nuts)

gen arrNRchn90=(arrNR-arrNR90_95)/arrNR90_95
gen arrRchn90=(arrR-arrR90_95)/arrR90_95
gen arrChn90=(arr-arr90_95)/arr90_95

gen arrNRchn00=(arrNR-arrNR00_05)/arrNR00_05
gen arrRchn00=(arrR-arrR00_05)/arrR00_05
gen arrChn00=(arr-arr00_05)/arr00_05

//TODO:  dbl chk these newely calc vars

keep nuts arr arrNR arrR arr*chn* arrChn*
sum
save /tmp/arr,replace

/* preserve */
/* ta nuts if strlen(nuts)==2 */
/* keep if strlen(nuts)==2 */
/* save /tmp/arrC,replace */
/* restore */

/* keep if year>2000 */
/* collapse ynr_I551_I553 yres_I551_I553 ytot_I551_I553 , by(nuts) */
/* save /tmp/arrColl,replace */


d
ren y arrTouEst

la var Arrivals at tourist accommodation establishments


>>>yeach, just make sure i save everything, has metadata etc, check little more
   and do other vars and do scatterplots


*** extrapolating NUTS data with 2011 for 12,13; crime with 2010 for 11,12,13 //NOTE THAT IN PAPER@@!!
//TODO mention in paper

use /home/aok/data/ess/essNuts,clear
sum if year==2011
sort nuts year
foreach v of varlist pop areaKM2 pcgdpCur pcgdpCurPerEUavg un mig{
replace `v'=`v'[_n-1] if nuts==nuts[_n-1] & year>2011
}
l nuts year pop areaKM2 pcgdpCur pcgdpCurPerEUavg mig in 1/100 

sum if year==2010
sort nuts year
foreach v of varlist vehThe domBur rob hom {
replace `v'=`v'[_n-1] if nuts==nuts[_n-1] & year>2010
}
l nuts year vehThe domBur rob hom in 1/100

replace nuts=NUTS1 if NUTS1=="CY0" 
replace nuts=NUTS1 if NUTS1=="DE1" 
replace nuts=NUTS1 if NUTS1=="DE2" 
replace nuts=NUTS1 if NUTS1=="DE3" 
replace nuts=NUTS1 if NUTS1=="DE4" 
replace nuts=NUTS1 if NUTS1=="DE5" 
replace nuts=NUTS1 if NUTS1=="DE6" 
replace nuts=NUTS1 if NUTS1=="DE7" 
replace nuts=NUTS1 if NUTS1=="DE8" 
replace nuts=NUTS1 if NUTS1=="DE9" 
replace nuts=NUTS1 if NUTS1=="DEA" 
replace nuts=NUTS1 if NUTS1=="DEB" 
replace nuts=NUTS1 if NUTS1=="DEC" 
replace nuts=NUTS1 if NUTS1=="DED" 
replace nuts=NUTS1 if NUTS1=="DEE" 
replace nuts=NUTS1 if NUTS1=="DEF" 
replace nuts=NUTS1 if NUTS1=="DEG" 

replace nuts=NUTS1 if NUTS1=="ES64" 

replace nuts=NUTS1 if NUTS1=="FI13" 
replace nuts=NUTS1 if NUTS1=="FI18" 
replace nuts=NUTS1 if NUTS1=="FI1A" 

replace nuts=NUTS1 if NUTS1=="GR11" 
replace nuts=NUTS1 if NUTS1=="GR12" 
replace nuts=NUTS1 if NUTS1=="GR13" 
replace nuts=NUTS1 if NUTS1=="GR14" 
replace nuts=NUTS1 if NUTS1=="GR21" 
replace nuts=NUTS1 if NUTS1=="GR22" 
replace nuts=NUTS1 if NUTS1=="GR23" 
replace nuts=NUTS1 if NUTS1=="GR24" 
replace nuts=NUTS1 if NUTS1=="GR25" 
replace nuts=NUTS1 if NUTS1=="GR30" 
replace nuts=NUTS1 if NUTS1=="GR41" 
replace nuts=NUTS1 if NUTS1=="GR42" 
replace nuts=NUTS1 if NUTS1=="GR43" 

replace nuts=NUTS1 if NUTS1=="HR01" 
replace nuts=NUTS1 if NUTS1=="HR02" 

replace nuts=NUTS1 if NUTS1=="UKC" 
replace nuts=NUTS1 if NUTS1=="UKD" 
replace nuts=NUTS1 if NUTS1=="UKE" 
replace nuts=NUTS1 if NUTS1=="UKF" 
replace nuts=NUTS1 if NUTS1=="UKG" 
replace nuts=NUTS1 if NUTS1=="UKH" 
replace nuts=NUTS1 if NUTS1=="UKI" 
replace nuts=NUTS1 if NUTS1=="UKJ" 
replace nuts=NUTS1 if NUTS1=="UKK" 
replace nuts=NUTS1 if NUTS1=="UKL" 
replace nuts=NUTS1 if NUTS1=="UKM" 
replace nuts=NUTS1 if NUTS1=="UKN" 

sort nuts year
count if nuts==nuts[_n-1] & year==year[_n-1]

drop pcgdpCurPerEU  //do not need this anyway, and i do not want to bother to calc  it for collapsed regions

sum un pcgdpCur

//adjusting for the fact that i have some nuts1 regions
foreach v of varlist un pcgdpCur vehThe domBur rob hom{
replace `v'=`v'*pop
}

foreach v of var * {
local l`v' : variable label `v'
      if `"`l`v''"' == "" {
	local l`v' "`v'"
	}
}


note pcgdpCur mig

//TODO note that mig have been calculated this way whicj is imprecise! bc regiosn differ!
collapse  (sum) pop (sum) areaKM2 (sum) pcgdpCur  (sum) un (sum) vehThe (sum) domBur (sum) rob (sum) hom (mean) mig,by(nuts year)

foreach v of var * {
label var `v' "`l`v''"
}

foreach v of varlist un pcgdpCur vehThe domBur rob hom{
replace `v'=`v'/pop
}
sum un pcgdpCur

alpha vehThe domBur rob
factor vehThe domBur rob, fa(1)
rotate, varimax
predict crim
la var crim "crime scale"
note crim: "crime scale from factor analysis with varimax rotation using vehicle thefts, domestic burglaries and roberries"

note mig: "crude rate of net migration including statistical adjustment: The ratio of the net migration including statistical adjustment during the year to the average population in that year. The value is expressed per 1000 inhabitants. The crude rate of net migration is equal to the difference between the crude rate of population change and the crude rate of natural change (that is, net migration is considered as the part of population change not attributable to births and deaths). It is calculated in this way because immigration or emigration flows are either not available or the figures are not reliable."

la var pcgdpCur "pcgdp"
note pcgdpCur: GDP at current market prices-Euro per inhabitant


save /tmp/essNuts, replace


*** labels

insheet using ~/data/gis/eurostat/nuts/NUTS_2010_60M_SH/Data/NUTS_AT_2010.csv,clear names
ren nuts_idc7 nuts
ren cntr_codec3 countryCode
ren name_ascic150 nutsNameAscii
keep nuts countryCode nutsNameAscii
la var nutsNameAscii "province name"
save `tmp'names, replace

*** ess and merge


use ~/data/ess/ess.dta, clear
//hmm maybe need to wight it darn! just goog ess stata weight :(

ta nutsREG //meh nit sure which one to keep!
ta nuts, mi

ta essYear
count if  nuts!=" " & essYear==2008
count if  nuts!=" " & essYear==2010
count if  nuts!=" " & essYear==2012

keep if essYear>2008
//keep if nuts!=" "

ta year

ta nuts if nutsREG==1
ta nuts if nutsREG==2
ta nuts if nutsREG==3
//collapsing nuts3 to nuts2 //LATER: guess this should be finer! could retain one more digit!
replace nuts=substr(nuts,1,4) if nutsREG==3
ta nuts if  nutsREG==3
count
//drop if nutsREG==1
drop nutsREG

lookfor trust //ok cool a bunch of trust vars!


ta nuts if essround==5

ta year, mi

//TODO just need to get fresh data from eurostat so that EVRYTHING matches if i decide to incl regressios in paper
merge m:1 nuts year using /tmp/essNuts //hmmmm
ta nuts if _merge==1
drop if _merge==2
drop _merge


ta nuts if substr(nuts, 1,2)=="GR"
replace nuts="EL11"  if nuts=="GR11"
replace nuts="EL12" 	if nuts=="GR12"
replace nuts="EL13" 	if nuts=="GR13"
replace nuts="EL14" 	if nuts=="GR14"
replace nuts="EL21" 	if nuts=="GR21"
replace nuts="EL22" 	if nuts=="GR22"
replace nuts="EL23" 	if nuts=="GR23"
replace nuts="EL24" 	if nuts=="GR24"
replace nuts="EL25" 	if nuts=="GR25"
replace nuts="EL30" 	if nuts=="GR30"
replace nuts="EL41" 	if nuts=="GR41"
replace nuts="EL42" 	if nuts=="GR42"
replace nuts="EL43" 	if nuts=="GR43"
						  
replace nuts="HR0"  	if nuts=="HR01"
replace nuts="HR0"  	if nuts=="HR02"


merge m:1 nuts  using /tmp/arr 
ta nuts if _merge==1
ta nuts if _merge==2
ta _merge
keep if _merge==3
drop _merge

merge m:1 nuts using `tmp'names
keep if _merge==3
drop _merge

//ok does not have RU (russia) and UA (ukraine i guess); IL (israel)
// no CH04 but other CH0* merged

//ess per codebook
/* AT Austria */
/* BE Belgium */
/* BG Bulgaria */
/* CH Switzerland */
/* CY Cyprus */
/* CZ Czech Republic */
/* DE Germany */
/* DK Denmark */
/* EE Estonia */
/* ES Spain */
/* FI Finland */
/* FR France */
/* GB United Kingdom */
/* GR Greece */
/* HR Croatia */
/* HU Hungary */
/* IE Ireland */
/* IL Israel */
/* IS Iceland */
/* IT Italy */
/* LT Lithuania */
/* LU Luxembourg */
/* NL Netherlands */
/* NO Norway */
/* PL Poland */
/* PT Portugal */
/* RU Russia */
/* SE Sweden */
/* SI Slovenia */
/* SK Slovakia */
/* TR Turkey */
/* UA Ukraine */




foreach v of varlist arr arrNR arrR{
replace `v'=`v'/(pop*1000000)  
}
la var arr "per capita tourist arrivals"
la var arrNR "per capita tourist  arrivals, foreign"
la var arrR "per capita tourist arrivals, domestic"
note arr: "An arrival is defined as a person (tourist) who arrives at a tourist accommodation establishment and checks in or arrives at non-rented accommodation. But in the scope of the Regulation concerning European statistics on tourism, this variable is not collected for the latter type of accommodation. Statistically there is not much difference if, instead of arrivals, departures are counted. No age limit is applied: children are counted as well as adults, even in the case when the overnight stays of children might be free of charge. Arrivals are registered by country of residence of the guest and by month. The arrivals of same-day visitors spending only a few hours during the day (no overnight stay, the date of arrival and departure are the same) at the establishment are excluded from accommodation statistics. A person is considered to be a resident in a country (place) if the person: - has lived for most of the past year or 12 months in that country (place), or - has lived in that country (place) for a shorter period and intends to return within 12 months to live in that country (place). International tourists should be classified according to their country of residence, not according to their citizenship. From a tourism standpoint any person who moves to another country (place) and intends to stay there for more than one year is immediately assimilated with other residents of that country (place). Citizens residing abroad who return to their country of citizenship on a temporary visit are included with non-resident visitors. Citizenship is indicated in the person's passport (or other identification document), while country of residence has to be determined by means of question or inferred e.g. from the person's address." For more information see \url{http://ec.europa.eu/eurostat/cache/metadata/en/tour_occ_esms.htm} To match ESS data, and to discount random year-to-year variations, arrivals are calculated as average for period 2010-2013 ;All arrivals are used on per-capita basis

note arrR:  domestic arrivals (residents)
note arrNR: foreign arrivals (non-residents)


//xtile poorRich = pcgdpCurPerEU if pcgdpCurPerEU<., nq(4)
xtile arrQ = arr if arr<., nq(4)
xtile arrQNR = arrNR if arrNR<., nq(4)
xtile arrQR = arrR if arrR<., nq(4)

gen popDen=pop/areaKM2 //meh need data with fewer missings!
la var popDen "population density"
note popDen: population divided by square kilometers 

bys nuts: egen count=count(year)

save `tmp'all,replace
d

** gis 

use `tmp'all,clear

format arr tsc %9.2f
format pcgdpCur %9.0fc

//for fusion table
//outsheet using `tmp'forFusion.csv, replace comma

foreach v of var * {
local l`v' : variable label `v'
      if `"`l`v''"' == "" {
	local l`v' "`v'"
	}
}
collapse  ppltrst pplfair pplhlp health rlgdgr rlgatnd pray age edulvla domicil income tsc ctz pop areaKM2 pcgdpCur  un vehThe domBur rob hom  arr* count, by(nuts nutsNameAscii)
foreach v of var * {
label var `v' "`l`v''"
}

keep if count>50

//replace nuts=substr(nuts,1,3) if nutsREG==3

//the follwoing is for mapping on ~/data/gis/eurostat/nuts_aok_modified/nuts2010-3lev/nuts2.shp
//but adjusting based on nuts3.shp in that folder!
//instead of finer nuts are collapsed to wider  i use nuts3 to dissolve to this weird ess nuts that are between nuts2 and 3!
//so just added a new field in nuts3 that woulkd correcpond to those here and
saved in d
ata/gis in this foldr

//TODO dissolve that new shjapefile on nuts filed and save as NEW!!

outsheet using `tmp'gis.csv, comma replace


**** sum_sts

use `tmp'all,clear

la var arrChn90    "change in arrivals since early 90s"
la var arrRchn90   "change in domestic arrivals since early 90s"
la var arrNRchn90  "change in foreign arrivals since early 90s"
la var arrChn00    "change in arrivals since early 2000s"
la var arrRchn00   "change in domestic arrivals since early 2000s"
la var arrNRchn00  "change in foreign arrivals since early 2000s"

note  arrNRchn90:(foreign arrivals now-foreign arrivals in 1990-1995)/foreign arrivals in 1990-1995
note  arrRchn90:(domestic arrivals now-domestic arrivals in 1990-1995)/domestic arrivals in 1990-1995
note  arrChn90:(arrivals now-arrivals in 1990-1995)/arrivals in 1990-1995

note  arrNRchn00:(foreign arrivals now-foreign arrivals in 2000-2005)/foreign arrivals in 2000-2005
note  arrRchn00:(domestic arrivals now-domestic arrivals in 2000-2005)/domestic arrivals in 2000-2005
note  arrChn00:(arrivals now-arrivals in 2000-2005)/arrivals in 2000-2005

d tsc pplfair pplhlp ppltrst arr arrR arrNR arrChn90  arrRchn90 arrNRchn90 arrChn00  arrRchn00 arrNRchn00   inc edul hea age rlgdgr male born mar kids un  pcgdpCur

aok_var_des ,  ff(tsc pplfair pplhlp ppltrst arr arrR arrNR arrChn90  arrRchn90 arrNRchn90 arrChn00  arrRchn00 arrNRchn00   inc edul hea age rlgdgr male born mar kids un  pcgdpCur)fname(`tmp'varDesFINAL)

sum arr*
lookfor trust
d ytot_I551_I553 ynr_I551_I553 yres_I551_I553
corr ppltrst ytot_I551_I553 ynr_I551_I553 yres_I551_I553

corr ppltrst arr 
corr ppltrst arrR 
corr ppltrst arrNR //yay very cool!

corr ppltrst arr if arr<5
corr ppltrst arrR if arrR<5 
corr ppltrst arrNR if arrNR<5 //yay very cool!

preserve
collapse tsc arr* ppltrst pcgdpCur count, by(nuts)

** playing

corr pplt arr*
corr pplt arr* if arr<5
tw(scatter ppltrst arr,mlab(nuts) msiz(tiny)mlabsiz(tiny))(lfit ppltrst arr)
dy
tw(scatter ppltrst arr,mlab(nuts) msiz(tiny)mlabsiz(tiny))(lfit ppltrst arr) if arr<5
gr export /tmp/scPpltrstArr.pdf
tw(scatter ppltrst arrR,mlab(nuts) msiz(tiny)mlabsiz(tiny))(lfit ppltrst arrR) if arrR<5
gr export /tmp/scPpltrstArrR.pdf
dy

tw(scatter tsc arr,mlab(nuts) msiz(tiny)mlabsiz(tiny))(lfit tsc arr)
gr export `tmp'scTscArr2.pdf,replace
dy

tw(scatter tsc arr if count>50,mlab(nuts) msiz(tiny)mlabsiz(tiny))(lfit tsc arr if count>50)
gr export `tmp'scTscArr50.pdf,replace
dy

tw(scatter tsc arrChn00 if count>200,mlab(nuts) msiz(tiny)mlabsiz(tiny))(lfit tsc arrChn00 if count>200)
gr export `tmp'scTscArrChn00_200_2.pdf,replace
dy

tw(scatter tsc arrChn00 if count>200,mlab(nuts) msiz(tiny)mlabsiz(tiny))(lfit tsc arrChn00 if count>200)
dy

tw(scatter tsc arrChn90 if count>200,mlab(nuts) msiz(tiny)mlabsiz(tiny))(lfit tsc arrChn90 if count>200)
dy

tw(scatter tsc arrRchn00 if count>200,mlab(nuts) msiz(tiny)mlabsiz(tiny))(lfit tsc arrRchn00 if count>200)
gr export `tmp'scTscArrRchn00_200.pdf,replace
dy

tw(scatter tsc arrNRchn00 if count>200,mlab(nuts) msiz(tiny)mlabsiz(tiny))(lfit tsc arrNRchn00 if count>200)
gr export `tmp'scTscArrNRchn00_200.pdf,replace
dy


//LATER/MAYBE maybe against gdp on x by quartile of arr or do arr on x and then by quartile of gdp--whichever looks better ! and guess marks quartiles in scatter differently
_pctile pcgdpCur, nq(10)
return list

tw(scatter tsc arr if count>200,mlab(nuts) msiz(tiny)mlabsiz(tiny))(lfit tsc arr if count>200)
gr export `tmp'scTscArr200_2.pdf,replace
dy


tw(scatter tsc arr if count>200 & pcg<30000,mlab(nuts) msiz(tiny)mlabsiz(tiny))(lfit tsc arr if count>200 & pcg<30000)
gr export `tmp'scTscArr200_lt30k.pdf,replace
dy


** paper graphs

tw(scatter tsc arr if count>200,mlab(nuts) mlabsiz(tiny)  mcolor(white) msize(zero) msymbol(point)  mlabposition(0))(lfit tsc arr if count>200), legend(off) xtitle("tourist arrivals") ytitle("trust") //(qfit tsc arr if count>200)
gr export `tmp'scTscArr200_2.pdf,replace
dy

/* tw(scatter tsc arr if count>200 & pcg>30000,mlab(nuts)mlabsiz(tiny)mcolor(white) msize(zero) msymbol(point)  mlabposition(0))(lfit tsc arr if count>200 & pcg>30000),legend(off) xtitle("tourist arrivals") ytitle("trust") */
/* gr export `tmp'scTscArr200_gt30k.pdf,replace */

//interesting!!
tw(scatter tsc arr if count>200 & pcg<30000,mlab(nuts) mlabsiz(tiny) mcolor(white) msize(zero) msymbol(point)  mlabposition(0))(scatter tsc arr if count>200 & pcg>30000,mlabangle(ninety)mlab(nuts) mlabsiz(tiny) mcolor(white) msize(zero) msymbol(point)  mlabposition(0))(lfit tsc arr if count>200 & pcg<30000)(lfit tsc arr if count>200 & pcg>30000, lpattern(dash)), legend(off) xtitle("tourist arrivals") ytitle("trust") //(qfit tsc arr if count>200)
dy

tw(scatter tsc arrR if count>200,mlab(nuts)mlabsiz(tiny)mcolor(white) msize(zero) msymbol(point)  mlabposition(0))(lfit tsc arrR if count>200),legend(off) xtitle("domestic tourist arrivals") ytitle("trust")saving(g1.gph,replace)

tw(scatter tsc arrNR if count>200,mlab(nuts)mlabsiz(tiny)mcolor(white) msize(zero) msymbol(point)  mlabposition(0))(lfit tsc arrNR if count>200),legend(off)xtitle("foreign tourist arrivals") ytitle("")saving(g2.gph,replace)

gr combine g1.gph g2.gph, ycommon rows(1)
dy


tw(scatter tsc arrNR if count>200 &arrNR<1,mlab(nuts)mlabsiz(tiny)mcolor(white) msize(zero) msymbol(point)  mlabposition(0))(lfit tsc arrNR if count>200  &arrNR<1),legend(off)xtitle("foreign tourist arrivals") ytitle("")
dy
tw(scatter tsc arrNR if count>200 &arrNR<2,mlab(nuts)mlabsiz(tiny)mcolor(white) msize(zero) msymbol(point)  mlabposition(0))(lfit tsc arrNR if count>200  &arrNR<2),legend(off)xtitle("foreign tourist arrivals") ytitle("")
dy


* now doing quadratics

tw(scatter tsc arr if count>200,mlab(nuts) mlabsiz(tiny)  mcolor(white) msize(zero) msymbol(point)  mlabposition(0))(qfit tsc arr if count>200), legend(off) xtitle("tourist arrivals") ytitle("trust") //(qfit tsc arr if count>200)
dy

tw(scatter tsc arr if count>200 ,mlab(nuts) mlabsiz(tiny) mcolor(white) msize(zero) msymbol(point)  mlabposition(0))(lfit tsc arr if count>200 & arr<2)(lfit tsc arr if count>200 & arr>2), legend(off) xtitle("tourist arrivals") ytitle("trust") //(qfit tsc arr if count>200)
dy





restore

ta nuts if ppltrst!=.



use `tmp'all,clear
foreach v of var * {
local l`v' : variable label `v'
      if `"`l`v''"' == "" {
	local l`v' "`v'"
	}
}
collapse tsc arr* ppltrst pcgdpCur count, by(nuts nutsNameAscii)
foreach v of var * {
label var `v' "`l`v''"
}

format arr tsc %9.2f
format pcgdpCur %9.0fc
sort arr

aok_listtex nuts nutsNameAscii arr tsc pcgdpCur,path(`tmp'aokL1full.tex) cap(sorted on arrivals)

keep if arr<.

count
di 189-10
sort arr
drop in 11/179
count

l nuts nutsNameAscii arr tsc pcgdpCur
aok_listtex nuts nutsNameAscii arr tsc pcgdpCur,path(`tmp'aokL1.tex) cap(top 10 and bottom 10 on arrivals)

! sed -i  '/^NL34/i\ \\hline' `tmp'aokL1.tex


//BUG !! fix island how come gdp is zero shit




**** reg 

use `tmp'all,clear

** messy play

gen age2=age^2

reg ppltrst pcgdpCurPerEU, robust cluster(nuts)
reg ppltrst arr, robust cluster(nuts)
reg ppltrst arr pcgdpCurPerEU un if arr<5, robust cluster(nuts)
reg ppltrst arrR pcgdpCurPerEU un if arrR<5, robust cluster(nuts)

reg ppltrst ytot_I551_I553 if ytot_I551_I553<, robust cluster(nuts)

reg ppltrst rlgdgr health age age2 edulvla income i.year, robust cluster(nuts)

reg ppltrst arr rlgdgr health age age2 edulvla income i.year, robust cluster(nuts)
reg ppltrst arrR rlgdgr health age age2 edulvla income i.year, robust cluster(nuts)

reg ppltrst arr pcgdpCurPerEU un rlgdgr health age age2 edulvla income i.year, robust cluster(nuts)
reg ppltrst arrR pcgdpCurPerEU un rlgdgr health age age2 edulvla income i.year, robust cluster(nuts)

reg ppltrst arr pcgdpCurPerEU un rlgdgr health age age2 edulvla income i.year if arr<5, robust cluster(nuts)
reg ppltrst arrR pcgdpCurPerEU un rlgdgr health age age2 edulvla income i.year if arrR<5, robust cluster(nuts)

reg tsc arrN pcgdpCurPerEU un rlgdgr health age age2 edulvla income i.year if arrN<1.5, robust cluster(nuts)
reg tsc arrR pcgdpCurPerEU un rlgdgr health age age2 edulvla income i.year if arrR<1.5, robust cluster(nuts)

reg tsc arrN vehThe domBur rob hom pcgdpCurPerEU un rlgdgr health age age2 edulvla income i.year if arrN<3, robust cluster(nuts)
reg tsc arrR  vehThe domBur rob hom  pcgdpCurPerEU un rlgdgr health age age2 edulvla income i.year if arrR<3, robust cluster(nuts)

reg tsc arrN    rlgdgr health age age2 edulvla income i.year if arrN<3 & year>2004 &  year<2012, robust cluster(nuts)
reg tsc arrR    rlgdgr health age age2 edulvla income i.year if arrR<3 & year>2004 &  year<2012, robust cluster(nuts)

reg tsc arrN  pcgdpCurPerEU un rlgdgr health age age2 edulvla income i.year if arrN<3 & year>2004 &  year<2012, robust cluster(nuts)
reg tsc arrR   pcgdpCurPerEU un rlgdgr health age age2 edulvla income i.year if arrR<3 & year>2004 &  year<2012, robust cluster(nuts)

reg tsc arrN vehThe domBur rob hom pcgdpCurPerEU un rlgdgr health age age2 edulvla income i.year if arrN<3 & year>2004 &  year<2012, robust cluster(nuts)
reg tsc arrR  vehThe domBur rob hom  pcgdpCurPerEU un rlgdgr health age age2 edulvla income i.year if arrR<3 & year>2004 &  year<2012, robust cluster(nuts)

reg tsc arrN vehThe domBur rob hom pcgdpCurPerEU un rlgdgr health age age2 edulvla income i.year if arrN<1.5 & year>2004 &  year<2012, robust cluster(nuts)
reg tsc arrR  vehThe domBur rob hom  pcgdpCurPerEU un rlgdgr health age age2 edulvla income i.year if arrR<1.5 & year>2004 &  year<2012, robust cluster(nuts)

reg ppltrst arrN vehThe domBur rob hom pcgdpCurPerEU un rlgdgr health age age2 edulvla income i.year if arrN<5 & year>2004 &  year<2012, robust cluster(nuts)
reg ppltrst arr  vehThe domBur rob hom  pcgdpCurPerEU un rlgdgr health age age2 edulvla income i.year if arrR<5 & year>2004 &  year<2012, robust cluster(nuts)

reg tsc arrN vehThe domBur rob hom pcgdpCurPerEU un rlgdgr health age age2 edulvla income i.year if year>2004 &  year<2012, robust cluster(nuts)
reg tsc arrR  vehThe domBur rob hom  pcgdpCurPerEU un rlgdgr health age age2 edulvla income i.year if  year>2004 &  year<2012, robust cluster(nuts)

reg tsc arrN vehThe domBur rob hom pcgdpCurPerEU un rlgdgr health age age2 edulvla income i.year , robust cluster(nuts)
reg tsc arrR arrN  vehThe domBur rob hom  pcgdpCurPerEU un rlgdgr health age age2 edulvla income i.year , robust cluster(nuts)


//may try controlling for density


** ok slow down


bys nuts year: egen eduN=mean(edulvla)

reg ppltrst arr   , robust cluster(nuts)
reg ppltrst arrR  , robust cluster(nuts)

reg ppltrst arr inc edul  , robust cluster(nuts)
reg ppltrst arrR inc edul , robust cluster(nuts)

reg ppltrst arr inc edul hea age* , robust cluster(nuts)
reg ppltrst arrR inc edul hea age*, robust cluster(nuts)

reg ppltrst arr inc edul hea age* rlgdgr, robust cluster(nuts)
reg ppltrst arrR inc edul hea age* rlgdgr, robust cluster(nuts)

reg ppltrst arr inc edul hea age* rlgdgr i.year, robust cluster(nuts)
reg ppltrst arrR inc edul hea age* rlgdgr i.year, robust cluster(nuts)

reg ppltrst arr un inc edul hea age* rlgdgr i.year, robust cluster(nuts)
reg ppltrst arrR un inc edul hea age* rlgdgr i.year, robust cluster(nuts)

//!!so single gdp kills the effect--perhaps the only eff from tourism is $!

reg ppltrst arr pcgdpCur inc edul hea age* rlgdgr i.year, robust cluster(nuts)
reg ppltrst arrR pcgdpCur inc edul hea age* rlgdgr i.year, robust cluster(nuts)

reg ppltrst arr  inc edul hea age* rlgdgr i.year i.poorRich, robust cluster(nuts)
reg ppltrst arrR  inc edul hea age* rlgdgr i.year i.poorRich, robust cluster(nuts)

//!!so single gdp kills the effect--perhaps the only eff from tourism is $!
//and only important in poor areas!--the poorer the area the more impiortyant!!
reg ppltrst arr  inc edul hea age* rlgdgr i.year if pcgdpCurPerEU<113, robust cluster(nuts)
reg ppltrst arrR  inc edul hea age* rlgdgr i.year if pcgdpCurPerEU<113, robust cluster(nuts)

reg ppltrst arr  inc edul hea age* rlgdgr i.year if pcgdpCurPerEU<80, robust cluster(nuts)
reg ppltrst arrR  inc edul hea age* rlgdgr i.year if pcgdpCurPerEU<80, robust cluster(nuts)

reg ppltrst arr  inc edul hea age* rlgdgr i.year if pcgdpCurPerEU>113, robust cluster(nuts)
reg ppltrst arrR  inc edul hea age* rlgdgr i.year if pcgdpCurPerEU>113, robust cluster(nuts)

* smart interactxion!

reg ppltrst c.arr##c.pcgdpCurPerEU  inc edul hea age* rlgdgr i.year, robust cluster(nuts)
reg ppltrst c.arrR##c.pcgdpCurPerEU  inc edul hea age* rlgdgr i.year, robust cluster(nuts)

reg tsc c.arr##c.pcgdpCurPerEU  inc edul hea age* rlgdgr i.year, robust cluster(nuts)
reg tsc c.arrR##c.pcgdpCurPerEU  inc edul hea age* rlgdgr i.year, robust cluster(nuts)

//very neat makes sense! if poor like tourists, but richer it gets the less they like em!! especially ofriegners--can take em if poor, but oif rich no no
reg ppltrst c.arrNR##c.pcgdpCurPerEU  inc edul hea age* rlgdgr i.year, robust cluster(nuts)

reg ppltrst c.arr##c.pcgdpCurPerEU  inc edul hea age* rlgdgr i.year, robust cluster(nuts)
reg ppltrst c.arr##c.pcgdpCurPerEU  inc edul hea age* rlgdgr i.year if arr<5, robust cluster(nuts)


gen gdp=pcgdpCurPerEU

//aha perhaps need some thershold to kick in!! very cool!!
reg ppltrst c.gdp##i.arrQ  inc edul hea age* rlgdgr i.year, robust cluster(nuts)
margins arrQ, at(gdp=(0(100)400))
marginsplot ,  x(gdp) 
dy
gr export /tmp/gdparrQ.pdf

reg ppltrst c.gdp##i.arrQNR  inc edul hea age* rlgdgr i.year, robust cluster(nuts)
margins arrQNR, at(gdp=(0(100)400))
marginsplot ,  x(gdp) 
dy
gr export /tmp/gdparrQNR.pdf


gen arr2=arr^2

//very cool! again need some thershold
reg ppltrst  arr arr2 pcgdpCurPerEU  inc edul hea age* rlgdgr i.year, robust cluster(nuts)

reg ppltrst c.arr##c.arr pcgdpCurPerEU  inc edul hea age* rlgdgr i.year, robust cluster(nuts)
margins, at(arr=(0(2)15))
marginsplot
dy

>>>

reg tsc c.arr##c.arr pcgdpCurPerEU  inc edul hea age* rlgdgr i.year, robust cluster(nuts)
margins, at(arr=(0(2)15))
marginsplot
dy


//what if exlude outliers
reg ppltrst c.arr##c.arr pcgdpCurPerEU  inc edul hea age* rlgdgr i.year if arr<5, robust cluster(nuts)
margins, at(arr=(0(2)15))
marginsplot
dy


//yay another neat!!!! very neat!!
reg ppltrst c.arr##i.poorRich  inc edul hea age* rlgdgr i.year if arr<4, robust cluster(nuts)
margins poorRich, at(arr=(0(1)4))
marginsplot ,  x(arr) 
gr export /tmp/arrPoorRich.pdf
dy

reg ppltrst c.arrNR##i.poorRich  inc edul hea age* rlgdgr i.year if arr<4, robust cluster(nuts)
margins poorRich, at(arrNR=(0(1)4))
marginsplot ,  x(arrNR) 
gr export /tmp/arrPoorRichNR.pdf
dy


** now doing only for ovber 200

//reg tsc arr   if count>50, robust cluster(nuts)

reg tsc i.arrQ   if count>200, robust cluster(nuts)
reg tsc i.arrQ inc edul hea age* rlgdgr i.year  if count>200, robust cluster(nuts)
reg tsc i.arrQ pcgdpCur  inc edul hea age* rlgdgr i.year if count>200, robust cluster(nuts)
reg tsc i.arrQ##c.pcgdpCur  inc edul hea age* rlgdgr i.year if count>200, robust cluster(nuts)


reg tsc i.arrQNR   if count>200, robust cluster(nuts)
reg tsc i.arrQNR inc edul hea age* rlgdgr i.year  if count>200, robust cluster(nuts)
reg tsc i.arrQNR pcgdpCur  inc edul hea age* rlgdgr i.year if count>200, robust cluster(nuts)
reg tsc i.arrQNR##c.pcgdpCur  inc edul hea age* rlgdgr i.year if count>200, robust cluster(nuts)

reg tsc arrChn00   if count>200, robust cluster(nuts)
reg tsc arrChn00 inc edul hea age* rlgdgr i.year  if count>200, robust cluster(nuts)
reg tsc arrChn00 pcgdpCur  inc edul hea age* rlgdgr i.year if count>200, robust cluster(nuts)
reg tsc c.arrChn00##c.pcgdpCur  inc edul hea age* rlgdgr i.year if count>200, robust cluster(nuts)


//yay!! again--more tourists more trust in poor countries but not in rich countries
reg tsc arrChn00  inc edul hea age* rlgdgr i.year if count>200 & pcgdpCur>30000 & pcgdpCur<., robust cluster(nuts)
reg tsc arrChn00  inc edul hea age* rlgdgr i.year if count>200 & pcgdpCur<12000, robust cluster(nuts)
//TODO may do scatters by income level!!


reg tsc arrChn00  inc edul hea age* rlgdgr i.year if count>200 & pcgdpCur>20000 & pcgdpCur<., robust cluster(nuts)



reg tsc arrNRchn00 pcgdpCur  inc edul hea age* rlgdgr i.year if count>200, robust cluster(nuts)


** paper regressions

reg tsc arr  i.year if count>200, robust cluster(nuts)
est sto a1

reg tsc arrR  i.year if count>200, robust cluster(nuts)
est sto a2

reg tsc arrNR  i.year if count>200, robust cluster(nuts)
est sto a3

//tried adding mar and similar but excluding due to missing obs!
reg tsc arr inc edul hea age* rlgdgr male born  kids un i.year if count>200, robust cluster(nuts)
est sto a4

reg tsc arrR inc edul hea age* rlgdgr male born  kids un i.year if count>200, robust cluster(nuts)
est sto a5

reg tsc arrNR inc edul hea age* rlgdgr male born  kids un  i.year if count>200, robust cluster(nuts)
est sto a6



estout a1 a2 a3 a4 a5 a6   using `tmp'regAnuts.tex , cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N" )fmt(%9.0f) )varlabels(_cons constant) label starlevels(* 0.10 ** 0.05 *** 0.01) //drop(*year*)
! sed -i 's|#|\\#|g' `tmp'regAnuts.tex



//very neat makes sense! if poor like tourists, but richer it gets the less they like em!! especially ofriegners--can take em if poor, but oif rich no no
/* reg ppltrst c.arr##c.pcgdpCur  inc edul hea age* rlgdgr male born kids un i.year if count>200, robust cluster(nuts) */
/* est sto b1 */

/* reg ppltrst c.arrR##c.pcgdpCur  inc edul hea age* rlgdgr  male born kids un  i.year if count>200, robust cluster(nuts) */
/* est sto b2 */

/* reg ppltrst c.arrNR##c.pcgdpCur  inc edul hea age* rlgdgr  male born kids un i.year if count>200, robust cluster(nuts) */
/* est sto b3 */


/* reg tsc arrChn00  inc edul hea age* rlgdgr i.year if count>200 , robust cluster(nuts) */
/* reg tsc arrRchn90  inc edul hea age* rlgdgr i.year if count>200 , robust cluster(nuts) */
/* reg tsc arrNRchn90  inc edul hea age* rlgdgr i.year if count>200 , robust cluster(nuts) */

/* //yay!! again--more tourists more trust in poor countries but not in rich countries */
/* reg tsc arrChn00  inc edul hea age* rlgdgr i.year if count>200 & pcgdpCur>12000 & pcgdpCur<., robust cluster(nuts) */
/* reg tsc arrChn00  inc edul hea age* rlgdgr  male born kids un i.year if count>200 & pcgdpCur<12000 & pcgdpCur>0, robust cluster(nuts) */
/* est sto b4 */

/* reg tsc arrRchn00  inc edul hea age* rlgdgr  male born kids un i.year if count>200 & pcgdpCur<12000 & pcgdpCur>0, robust cluster(nuts) */
/* est sto b5 */

/* reg tsc arrNRchn00  inc edul hea age* rlgdgr male born kids un i.year if count>200 & pcgdpCur<12000 & pcgdpCur>0, robust cluster(nuts) */
/* est sto b6 */

est drop _all

reg tsc arr inc edul hea age* rlgdgr male born  kids un i.year if count>200  & pcgdpCur<30000, robust cluster(nuts)
est sto b1P

reg tsc arr inc edul hea age* rlgdgr male born  kids un i.year if count>200  & pcgdpCur>30000  & pcgdpCur<., robust cluster(nuts)
est sto b1R


reg tsc arrR inc edul hea age* rlgdgr male born  kids un i.year if count>200  & pcgdpCur<30000, robust cluster(nuts)
est sto b2P

reg tsc arrR inc edul hea age* rlgdgr male born  kids un i.year if count>200  & pcgdpCur>30000  & pcgdpCur<., robust cluster(nuts)
est sto b2R


reg tsc arrNR inc edul hea age* rlgdgr male born  kids un i.year if count>200  & pcgdpCur<30000, robust cluster(nuts)
est sto b3P

reg tsc arrNR inc edul hea age* rlgdgr male born  kids un i.year if count>200  & pcgdpCur>30000  & pcgdpCur<., robust cluster(nuts)
est sto b3R

estout b1* b2* b3*    using `tmp'regBnuts.tex , cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N" )fmt(%9.0f) )varlabels(_cons constant) label starlevels(* 0.10 ** 0.05 *** 0.01) //drop(*year*)
! sed -i 's|#|\\#|g' `tmp'regBnuts.tex



reg ppltrst arrR  inc edul hea age* rlgdgr i.year i.poorRich, robust cluster(nuts)
i.arrQ##c.pcgdpCur  inc edul hea age* rlgdgr

//LATER: can also tru 10 and 20k (1,2 quarties) as cutoff points! 


* appendix tables using change variables just repeating setupo from foirst model

est drop _all

reg tsc arrChn90  i.year if count>200, robust cluster(nuts)
est sto c1

reg tsc arrRchn90  i.year if count>200, robust cluster(nuts)
est sto c2

reg tsc arrNRchn90  i.year if count>200, robust cluster(nuts)
est sto c3

//tried adding mar and similar but excluding due to missing obs!
reg tsc arrChn90 inc edul hea age* rlgdgr male born  kids un i.year if count>200, robust cluster(nuts)
est sto c4

reg tsc arrRchn90 inc edul hea age* rlgdgr male born  kids un i.year if count>200, robust cluster(nuts)
est sto c5

reg tsc arrNRchn90 inc edul hea age* rlgdgr male born  kids un  i.year if count>200, robust cluster(nuts)
est sto c6


estout c1 c2 c3 c4 c5 c6   using `tmp'regCnutsAPP.tex , cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N" )fmt(%9.0f) )varlabels(_cons constant) label starlevels(* 0.10 ** 0.05 *** 0.01) //drop(*year*)


est drop _all

reg tsc arrChn00  i.year if count>200, robust cluster(nuts)
est sto d1

reg tsc arrRchn00  i.year if count>200, robust cluster(nuts)
est sto d2

reg tsc arrNRchn00  i.year if count>200, robust cluster(nuts)
est sto d3

//tried adding mar and similar but excluding due to missing obs!
reg tsc arrChn00 inc edul hea age* rlgdgr male born  kids un i.year if count>200, robust cluster(nuts)
est sto d4

reg tsc arrRchn00 inc edul hea age* rlgdgr male born  kids un i.year if count>200, robust cluster(nuts)
est sto d5

reg tsc arrNRchn00 inc edul hea age* rlgdgr male born  kids un  i.year if count>200, robust cluster(nuts)
est sto d6


estout d1 d2 d3 d4 d5 d6   using `tmp'regDnutsAPP.tex , cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N" )fmt(%9.0f) )varlabels(_cons constant) label starlevels(* 0.10 ** 0.05 *** 0.01) //drop(*year*)




//yay!! again--more tourists more trust in poor countries but not in rich countries
reg tsc arrChn00  inc edul hea age* rlgdgr i.year if count>200 & pcgdpCur>12000 & pcgdpCur<., robust cluster(nuts)
reg tsc arrChn00  inc edul hea age* rlgdgr  male born kids un i.year if count>200 & pcgdpCur<10000 & pcgdpCur>0, robust cluster(nuts)
reg tsc arrChn00  inc edul hea age* rlgdgr  male born kids un i.year if count>200 & pcgdpCur<12000 & pcgdpCur>0, robust cluster(nuts)
est sto e1 //weird! change by 2k and effect flips!!!

reg tsc arrRchn00  inc edul hea age* rlgdgr  male born kids un i.year if count>200 & pcgdpCur<20000 & pcgdpCur>0, robust cluster(nuts)
reg tsc arrRchn00  inc edul hea age* rlgdgr  male born kids un i.year if count>200 & pcgdpCur<12000 & pcgdpCur>0, robust cluster(nuts)
est sto e2

reg tsc arrNRchn00  inc edul hea age* rlgdgr male born kids un i.year if count>200 & pcgdpCur<20000 & pcgdpCur>0, robust cluster(nuts)
reg tsc arrNRchn00  inc edul hea age* rlgdgr male born kids un i.year if count>200 & pcgdpCur<12000 & pcgdpCur>0, robust cluster(nuts)
est sto e3


estout e1 e2 e3   using `tmp'regDnutsAPP.tex , cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N" )fmt(%9.0f) )varlabels(_cons constant) label starlevels(* 0.10 ** 0.05 *** 0.01) //drop(*year*)


** now doing quadratics




------------------
jsut some examples

reg ppltrst c.pcgdpCurPerEU##c.arr  inc edul hea age* rlgdgr i.year, robust cluster(nuts)
margins, dydx(arr) at(pcgdpCurPerEU=(0(50)400)) vsquish
margins, at(arr=(.1 10) pcgdpCurPerEU=(0(50)400)) 
marginsplot
dy

reg tsc c.pcgdpCurPerEU##i.arrQ  inc edul hea age* rlgdgr i.year, robust cluster(nuts)
margins arrQ, at(pcgdpCurPerEU=(0(100)400))
marginsplot, x(pcgdpCurPerEU) 
dy


reg happy i.realinc5##c.year , robust
margins realinc5, at(year=(1972(10)2012))
marginsplot, x(year)yscale(range(1.9(.1)2.4)) legend(off) text(2 2012.6 "1")text(2.1 2012.6 "2")text(2.2 2012.6 "3")text(2.25 2012.6 "4")text(2.35 2012.6 "5")scheme(s2mono)title("")



------------------------


aok_var_des , ff(cre00 boh00 art90 chu_per50 mem_per50 totrt adj) fname(`tmp'var_des)
aok_histograms for the appendix
TODO add more aok_cool programs ! :))

logout, tex save(`tmp'aha) replace: sum happy realinc5  age health  unemp ed  male hompop rep dem lib con, format
cat `tmp'aha.tex
! sed -i '1,4d' `tmp'aha.tex 
! head -n -2 `tmp'aha.tex > `tmp'aha2.tex
cat `tmp'aha2.tex

foreach i of varlist `x'{
di "`:var lab `i''"
! sed -i "s|`i'|`:var lab `i''|g" `tmp'aha2.tex
}
cat `tmp'aha2.tex

//if need sig can try net install mkcorr (newer version 2 i guess)
//set linesize 120
corrtex happy realinc5  age health  unemp ed  male hompop rep dem lib con, file(`tmp'ahb) replace   dig(2) //sig
//meh don't reallyneed sig--if it's big it is sig
cat `tmp'ahb.tex
//set linesize 78
! sed -i '1,2d' `tmp'ahb.tex 
! head -n -3 `tmp'ahb.tex > `tmp'ahb2.tex
cat `tmp'ahb2.tex
//foreach i of varlist `x'{
//di "`:var lab `i''"
//! sed -i "s|`i'|`:var lab `i''|g" `tmp'ahb2.tex
//}
//cat `tmp'ahb2.tex
//! perl -pe 's/[-+]?\d*(?:\.?\d|\d\.)\d*(?:[eE][-+]?\d+)?/sprintf("%.2f",$&)/ge' `tmp'ahb2.tex > `tmp'ahb3.tex
//cat `tmp'ahb3.tex
! sed -i "s|\\\multicolumn{1}{c}||g" `tmp'ahb2.tex

//replace in lines 3,4
! sed -i '1 s|\&|\\end{sideways}\&\\begin{sideways}|g' `tmp'ahb2.tex
! sed -i '1 s|{Variables} \\end{sideways}|{Variables}|g' `tmp'ahb2.tex
! sed -i '1 s|\\\\ \\hline|\\end{sideways}\\\\ \\hline|g' `tmp'ahb2.tex

//! sed -i 's|\\label{corrtable}}|\\label{corrtable}}\\tiny|g' `tmp'corr.tex



**** ana

trust would depend on educ so need to control for educ, possibly at macro
  lev--maybe just agg ess value

  
** paper numbers

est restore wvsA2 //this is the main specification
count if e(sample)==1
emd, s(%9.0f `r(N)' )t(wvsN)ra(append)

ta yr if e(sample)==1
sum yr  if e(sample)==1
loc mm  " `r(min)'-`r(max)' "
di "`mm'"
emd, s( "`mm'" )t(wvsYr)ra(append) //sometimes need dble quotes

ta c if e(sample)==1
emd, s( `r(r)' )t(wvsK)ra(append)


** paper regressions


* 1 descripton of what's up here in this table

* 2 another table etc

* aloways have table wuith some robistness checks--fixed effects etc etc, perhaps in the appendix 


file close f
! cat `d'notes.txt


****SWB

//guess should contrl for migrants, density, race,  etc

reg ls i.arrQ  c.gdp  inc edul hea age* rlgdgr i.year, robust cluster(nuts)
reg ls i.arrQNR  c.gdp  inc edul hea age* rlgdgr i.year, robust cluster(nuts)
reg ls i.arrQR  c.gdp  inc edul hea age* rlgdgr i.year, robust cluster(nuts)


reg ls c.gdp##i.arrQ  inc edul hea age* rlgdgr i.year, robust cluster(nuts)
margins arrQ, at(gdp=(0(100)400))
marginsplot ,  x(gdp) 
dy
gr export /tmp/gdparrQ.pdf






//----------------------from crcle of trust paper-----------------------------------
//could reuse for somethin!


preserve
collapse tsc pray, by(cntry inwyr)
corr tsc pray //so there is area-lev effect--areas that pary more trust less!
restore


aok_var_des, ff(`x')fname(/tmp/varEss.tex)
aok_hist2, d(/tmp/)f(ess_h0)x(tsc ppltrst pplfair pplhlp rlgatnd  rlgdgr pray cat pro ort jew mus)
aok_hist2, d(/tmp/)f(ess_h1)x(health age edulvla male mar sepDivWid town income cit)


** reg


/* reg tsc rsc health age* i.c, robust //ha! like wvs, c dummy flips it!so must be sth about ctry--duh ctry religiosity is what matters fro trust! */
/* reg tsc rsc health age* edulvla male mar sepDivWid town income i.inwyr i.rlgdnm i.c, robust cluster(c) //hmm cluster kills it.. */

/* reg tsc rlgblg  rlgdgr pray rlgatnd health age* edulvla male mar sepDivWid town income i.inwyr i.rlgdnm i.c, robust cluster(c) */

/* reg ppltrst rsc health age* edulvla male mar sepDivWid town income i.inwyr i.rlgdnm i.c, robust cluster(c)  */
/* reg pplhlp rsc health age* edulvla male mar sepDivWid town income i.inwyr i.rlgdnm i.c, robust cluster(c)  */
/* reg pplfair rsc health age* edulvla male mar sepDivWid town income i.inwyr i.rlgdnm i.c, robust cluster(c)  */


/* reg tsc rsc [pweight=dweight], robust */


** by country

/* kountry cntry, from(iso2c)  */

/* preserve */
/* collapse (first) cntry, by(NAMES_STD) */
/* l */
/* restore */

/* loc sca "DK,FI,NO,SE" */
/* di "`sca'" */

/* //town income cit i.inwyr i.rlgdnm */
/* reg tsc pray  health age* edulvla male mar sepDivWid   if inlist(cntry,"DK", "FI","NO","SE"), robust  */


/* reg tsc rsc health age* edulvla male mar sepDivWid town income cit i.inwyr i.rlgdnm  if inlist(cntry,"DK", "FI","NO","SE"), robust  */


/* reg tsc rsc health age* edulvla male mar sepDivWid town income cit i.inwyr i.rlgdnm  if inlist(cntry,"DK", "FI","NO","SE"), robust cluster(c) //hmm cluster kills it.. */


/* bys NAMES_STD: reg tsc rsc,robust */

/* bys NAMES_STD: reg tsc rsc health age* edulvla male mar sepDivWid town income cit  i.rlgdnm  , robust */

** by ctry-lev of relig

/* bys c: egen crsc=mean(rsc)  */
/* bys c: egen ctsc=mean(tsc)  */

/* tabstat rsc, by(NAMES_STD) stat(mean N) format(%9.2f) */


/* reg tsc c.rsc  health age* edulvla male, robust cluster(c) */
/* reg tsc c.rsc crsc health age* edulvla male, robust cluster(c) //yup--area-lev religiosity is what meatters */
/* reg tsc c.rsc crsc health age* edulvla male i.c i.inwyr, robust cluster(c)  */


/* reg tsc c.rsc##c.crsc health age* edulvla male i.inwyr i.c, robust cluster(c) */
/* reg tsc c.rsc##c.crsc health age* edulvla male i.inwyr i.c, robust cluster(c) */
/* reg tsc c.rsc##c.crsc health age* edulvla male mar sepDivWid town income cit i.inwyr i.rlgdnm  , robust cluster(c) //hmm cluster kills it.. */

/* corr ctsc crsc //ha! same as in wvs; may also chk inn gss by region; so religious areas are definetly less trusting! */

/* gen bcrsc=0 */
/* replace bcrsc=1 if crsc > .3 */
/* replace bcrsc = . if crsc==. */
/* reg tsc c.rsc#i.bcrsc health age* edulvla male i.inwyr i.c, robust cluster(c) */


** by denomination

/* reg tsc rsc health age* edulvla male  i.rlgdnm , robust //denomination kills it */
/* // cat pro ort jew mus */
/* reg tsc c.rsc##i.pro cat pro ort jew mus health age* edulvla male i.inwyr i.c, robust cluster(c) */

/* reg tsc c.rsc##i.rlgdnm health age* edulvla male i.inwyr i.c, robust cluster(c) */

/* bys rlgdnm: reg tsc rsc health age* edulvla male i.inwyr i.c, robust cluster(c) */


** by ctry-lev denom

/* bys c: egen ccat=mean(cat)  */
/* bys c: egen cpro=mean(pro)  */

/* reg tsc c.ccat##i.cat cat pro ort jew mus health age* edulvla male i.inwyr i.c, robust cluster(c) */

/* reg tsc c.ccat##i.cat cat pro ort jew mus rsc health age* edulvla male mar sepDivWid town income cit i.inwyr i.rlgdnm , robust cluster(c)  */

/* reg tsc c.cpro##i.pro cat pro ort jew mus health age* edulvla male i.inwyr i.c, robust cluster(c) */

/* reg tsc c.cpro##i.pro cat pro ort jew mus rsc health age* edulvla male mar sepDivWid town income cit i.inwyr i.rlgdnm , robust cluster(c)  */


** paper results: pray actuually comes up negatibe!--cool

bys c: egen cpra=mean(pray) 

reg tsc rlgatnd rlgblg  rlgdgr pray   i.inwyr i.c, robust cluster(c)
est sto essG0

reg tsc rlgatnd rlgblg  rlgdgr pray  inc health age* edulvla male i.inwyr i.c, robust beta //LATER: export that neatly:) 
reg tsc rlgatnd rlgblg  rlgdgr pray inc health age* edulvla male i.inwyr i.c, robust cluster(c)
est sto essG1

margins , at(health=(1(1)5)) //to comapre to show that health ain't that big eithr
margins , at(pray=(1(1)7)) 

//no need for marginsplot--just one coeff

mat b = r(table)
mat l b
loc essG1x1  "[" %9.2f b[5,1] ","  %9.2f b[6,1] "]" 
di "`essG1x1'"
emd, s("`essG1x1'")t(essG1x1)ra(append)
loc essG1x7  "[" %9.2f b[5,7] ","  %9.2f b[6,7] "]"
di "`essG1x7'"
emd, s("`essG1x7'")t(essG1x7)ra(append)

reg tsc rlgatnd rlgblg  rlgdgr pray  inc health age* edulvla male i.inwyr i.c [pw=pweight],  robust cluster(c)
 reg tsc rlgatnd rlgblg  rlgdgr pray  inc health age* edulvla male i.inwyr i.c [pw=dweight],  robust cluster(c)

reg tsc rlgatnd rlgblg  rlgdgr c.pray##c.cpra rlgatnd health age* edulvla male i.inwyr i.c, robust cluster(c) //oh well

reg tsc rlgatnd  rlgdgr pray cat pro ort jew mus  health age* edulvla male mar sepDivWid town income cit i.inwyr i.c , robust cluster(c) 
est sto essG2 //rlgblg--for sme reason it is collinear with something

reg tsc rlgblg  rlgdgr i.pray cat pro ort jew mus  health age* edulvla male mar sepDivWid town income cit i.inwyr i.c , robust cluster(c) 

reg tsc rlgblg  rlgdgr c.pray##c.cpra cat pro ort jew mus  health age* edulvla male mar sepDivWid town income cit i.inwyr i.c , robust cluster(c) //oh again, area level religiosity more detrimential than person-lev 

reg tsc  c.pray cat pro ort jew mus  health age* edulvla male mar sepDivWid town income cit i.inwyr i.c , robust cluster(c)

estout essG0 essG1 essG2   using /tmp/essG.tex ,eform cells(b(star fmt(%9.3f))) replace style(tex)  collabels(, none) stats(N, labels("N" )fmt(%9.0f) )varlabels(_cons constant) label starlevels(* 0.10 ** 0.05 *** 0.01) //drop(*year*)
! sed -i '/.*Country.*/d' /tmp/essG.tex
/* ! sed -i '/.*Legal.*\/d' /tmp/essG.tex */
/* ! sed -i '/.*Establishment.*\/d' /tmp/essG.tex */
/* ! sed -i '/.*Household.*\/d' /tmp/essG.tex */
! sed -i '/.*Year.*/d' /tmp/essG.tex 
//! sed -i 's|1\.South|South|g'   /tmp/wvsG.tex
//! sed -i 's|1.hiRe| high religiosity|g'   /tmp/wvsG.tex
//! sed -i '/.*==.*/d' /tmp/wvsG.tex
//! sed -i '/.*00.*/d' /tmp/wvsG.tex
//! sed -i '/.*99.*/d' /tmp/wvsG.tex


reg tsc rlgblg  rlgdgr pray health age* edulvla male i.inwyr i.c, robust cluster(c)

reg ppltrst  rlgblg  rlgdgr pray health age* edulvla male mar sepDivWid town income i.inwyr i.rlgdnm i.c, robust cluster(c) 
reg pplhlp  rlgblg  rlgdgr pray health age* edulvla male mar sepDivWid town income i.inwyr i.rlgdnm i.c, robust cluster(c) 
reg pplfair rlgblg  rlgdgr c.pray##c.crsc  health age* edulvla male mar sepDivWid town income i.inwyr i.rlgdnm i.c, robust cluster(c) //bummer


** paper numbers

est restore essG1
count if e(sample)==1
emd, s(%9.0f `r(N)' )t(essN)ra(append)

/* ta yr if e(sample)==1 */
/* sum yr  if e(sample)==1 */
/* loc mm  " `r(min)'-`r(max)' " */
/* di "`mm'" */
/* emd, s( "`mm'" )t(wvsYr)ra(append) //sometimes need dble quotes */

ta c if e(sample)==1
emd, s( `r(r)' )t(essK)ra(append)



** religipus pepl care about environment!

/* revrs impenv, replace */
/* reg impenv rlgblg  rlgdgr pray health age* edulvla male mar sepDivWid i.domicil i.hinctnt i.inwyr i.rlgdnm i.c, robust cluster(c) */
/* reg impenv rsc health age* edulvla male mar sepDivWid i.domicil i.hinctnt i.inwyr i.rlgdnm i.c, robust cluster(c) */



