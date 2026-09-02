stata

cd /home/aok/papers/leonieAgency/tex

//----------------------------------wid crap dont use it

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
wbopendata, indicator(SI.POV.NAHC;NY.GDP.PCAP.KD;SI.DST.10TH.10)clear long 
keep if year>=2015 & year<=2025
keep regionname countrycode countryname incomelevelname year si_pov_nahc ny_gdp_pcap_kd si_dst_10th_10
collapse si_pov_nahc ny_gdp_pcap_kd si_dst_10th_10, by(regionname countrycode countryname incomelevelname)
l countrycode si_pov_nahc ny_gdp_pcap_kd si_dst_10th_10

la var si_pov_nahc "perc poor, natl poverty line"
la var ny_gdp_pcap_kd "GDP per capita (constant 2015 usd)"
la var si_dst_10th_10 "income share held by top 10perc"


//LATER:
/*
note ny_gdp_pcap_kd: "GDP per capita is gross domestic product divided by midyear population. GDP is the sum of gross value added by all resident producers in the economy plus any product taxes and minus any subsidies not included in the value of the p\
roducts. It is calculated without making deductions for depreciation of fabricated assets or for depletion and degradation of natural resources. Data are in constant U.S. dollars."
d
note si_pov_nahc: ""
*/

save /tmp/wdi.dta, replace //merge in python TODO also here for MLM/HLM etc



//----------------------wvs
//vars from leonie's slide
//https://docs.google.com/presentation/d/1YpGP1VmirIAtTRtKqrpcI0ef7xSu3s-o/edit?slide=id.p6#slide=id.p6}



use ~/data/wvs/wvs,clear  //first quick exploration on cumulative; then subset to wave7
ren freedom free

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



//---------



//welfare/redistribution
sum wrkLaz pooLaz subPoo escPov priPub trust  fair //fair not in wave7
codebook wrkLaz pooLaz subPoo escPov priPub trust,ta(100) //use these later;
//leonies from slides:
sum weaAll incIne govRes comBad worSuc
alpha weaAll incIne govRes comBad worSuc
pwcorr weaAll incIne govRes comBad worSuc //very low!!







reg govRes free, robust 
est sto a1

reg govRes free i.c, robust //same
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
recode free (1 2 3=1)(4 5 6=2)(7 8 9 10=3)  ,gen(free3)
recode satFin (1 2 3=1)(4 5 6=2)(7 8 9 10=3),gen(satFin3)
reg govRes i.free3##c.satFin inc age age2 male class mar , robust 
margins free3, at(satFin=(1(1)10)) 
reg govRes i.satFin3##c.free inc age age2 male class mar , robust 
margins satFin3, at(free=(1(1)10))
marginsplot, x(free)

reg govRes i.satFin3##i.free3 inc age age2 male class mar , robust 
margins satFin3, at(free3=(1(1)3))
marginsplot, x(free3)


reg govRes c.free##c.satFin inc age age2 male class mar , robust 
est sto a3

reg govRes c.free##c.inc age age2 male class mar , robust 
est sto a4

reg govRes c.free##c.male inc age age2  class mar , robust 
est sto a5


estout a*  using regA.tex ,  cells(b(star fmt(%9.2f))) replace style(tex)  collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label  starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) //drop(*c)



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

Control now in dofile health kids religiosity social connectedness
self-employed married social class occupation or industry ; argue like in
Bartram as per controls as i did in unhappiness unpredictability Lonnie paper



from leonies slides:
H2: This impact is stronger in more affluent, more unequal and less trusting societies.
found oposite in unequal lat am impact lower

get coefs by ctry like in cities paper see dofile there
