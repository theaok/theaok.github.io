//old: time /usr/local/stata12/stata-se -b do  /home/aok/papers/root/do/gss.do
//old: time /usr/local/stata13_ru/stata-mp -b do  /home/aok/data/gss/gss.do
//old: time /usr/local/stata15-ru/stata-mp -b do  /home/aok/data/gss/gss.do
// /usr/local/stata16-ru/stata-mp -b do  /home/aok/data/gss/gss.do
//stata -b do  /home/aok/data/gss/gss.do

//LOG:
//may16 2020 downloaded cimulative with 2018 added; did qucik check but later can make more sure its up to snuff

clear
//e
// exit
// /usr/local/stata12/stata-se
//stata-mp
clear all                                  
version 10                              
set more off                            
                                        
/* remp7206iap.dta was downloaded from http://www.norc.org/GSS+Website/Download/STATA+v8.0+Format/ */
/* 1972-2008 Cumulative File */
  
set maxvar 10000    
//use "/nfs/home/A/akozaryn/shared_space/akozyarn/gss/remp7208.dta", clear

cd /home/aok/data/gss/
//unzipfile remp7208.zip
//unzipfile GSS_stata72_12.zip,replace
unzipfile GSS_stata_72_18.zip,replace
//use ~/data/gss/gss7212_r1.dta,clear
//! rm ~/data/gss/gss7212_r1.dta
use GSS7218_R2.DTA, clear
//use GSS7214_R5.DTA, clear
! rm ~/data/gss/GSS7218_R2.DTA

*//############################### data management #############################
 
gen ds_id="gss"
la var ds_id "data set id"
 
/* satisfactions */

lookfor happy                           
tab happy                               
tab happy, nola                         
ren happy swb
revrs swb, replace
la def swb_lbl 1"1.not too happy" 2"2.pretty happy" 3"3.very happy"
la val swb swb_lbl

la var swb "SWB"

note swb:  GENERAL HAPPINESS  "Taken all together, how would you say things are these days--would you say that you are very happy, pretty happy, or not too happy?"
tab swb, gen(SWB)

codebook satcity
replace satcity =8-satcity
la def satcity_lbl 1"none" 2"a little" 3"some" 4"a fair amount" 5"quite a bit" 6"great deal" 7"very great deal"
la val satcity satcity_lbl


revrs hapmar, replace
note hapmar: "Taking things all together, how would you describe your marriage? Would you say that your marriage is very happy, pretty happy, or not too happy?"

revrs satfam, replace
note satfam: "For each area of life I am going to name, tell me the number that shows how much satisfaction you get from that area." 

revrs satlife, replace


/******************/
/* time and space */
/******************/

la var year "year"
note year: gss year for this respondent

la var cohort "cohort"
note cohort: year of birth



tab year, mi                            
gen dec=.                               
replace dec=1 if year<1980& year>1970
replace dec=2 if year<1990& year>1979
replace dec=3 if year<2000& year>1989
replace dec=4 if year<2013& year>1999   

codebook region
gen reg2=.
replace reg2=1 if region==1|region==2
replace reg2=2 if region==3|region==4
replace reg2=3 if region==5|region==6|region==7
replace reg2=4 if region==8|region==9

la def reg2_lbl 1"NewEng,Mid.Atl" 2"N Central" 3"South" 4"Pacific,Mount."
la val reg2 reg2_lbl
tab reg2, gen(R)
la var R3 "South"


* generations/cohorts: see howe92 

loc lost   "1883-1924 Lost/GI" 	
loc silent "1925-1942 Silent" 	
loc boomer "1943-1960 Boomer" 	
loc x      "1961-1981 X"			
loc mil    "1982-2004 Millennial"

//collapsed
loc lostSilent   "1883-1942 Lost/GI, Silent" 	
loc xMil         "1961-2004 X, Millennial"			

recode cohort (1883/1924=1 "`lost'") (1925/1942=2 "`silent'") (1943/1960=3 "`boomer'") (1961/1981=4 "`x'")(1982/2004=5 "`mil'"), gen(coh)
tab cohort coh
tab coh, gen(COH)

la var COH1 "`lost'"  
la var COH2 "`silent'"
la var COH3 "`boomer'"
la var COH4 "`x'"     
la var COH5 "`mil'"   

tab cohort COH1, mi 
tab cohort COH2, mi 
tab cohort COH3, mi 
tab cohort COH4, mi 
tab cohort COH5, mi 

recode cohort (1883/1942=1 "`lostSilent'") (1943/1960=2 "`boomer'") (1961/2004=3 "`xMil'"), gen(cohCol)
tab cohort cohCol,mi
tab cohCol, gen(COHCOL)

la var COHCOL1 "`lostSilent'"
la var COHCOL2 "`boomer'"
la var COHCOL3 "`xMil'"

tab coh COHCOL1, mi 
tab coh COHCOL2, mi 
tab coh COHCOL3, mi 

la var coh "cohort"

/* cities */

codebook xnorcsiz, ta(100)

//BUG!!!! discovered  <2016-08-05 Fri>
/* gen siz=0 */
/* replace siz=1 if xnorcsiz==1 */
/* replace siz=2 if xnorcsiz==2 */
/* replace siz=3 if xnorcsiz==3|xnorcsiz==4|xnorcsiz==7 //bug here 7 is not burb!! */
/* replace siz=4 if xnorcsiz==5|xnorcsiz==6|xnorcsiz>7 */
/* la def siz_lbl 1"cities>250K" 2"cities 50-250K" 3"suburbs" 4"small towns, country" */
/* replace siz=. if xnorcsiz>100 */
/* la var siz "size of community" */
/* la val siz siz_lbl */
/* tab siz,gen(S) */
 
/* la var S1 "city$>$250k"  */
/* la var S2 "city 50k-250k"  */
/* la var S3 "suburbs"  */
/* la var S4 "small towns, country"  */

note size: SIZE "Size of Place in thousands-A 4-digit number which provides actual size of place of interview."

codebook srcb 
recode srcbelt (1=1 "1-12 msa")(2=2 "13-100 msa")(3=3 "1-12 sub")(4=4 "13-100 sub")(5=5 "small urb")(6=6 "small rur"), gen(_srcbelt)
drop srcbelt
ren _srcbelt srcbelt

codebook xnorcsiz, ta(100)
recode xnorcsiz (1=1 "gt 250k")(2=2 "50-250k")(3=3 "lrg sub")(4=4 "med sub")(5=5 "uninc lrg")(6=6 "uninc med")(7=7 "10-50k")(8=8 "2.5-10k")(9=9 "lt 2.5k")(10=10 "country"),gen(_xnorcsiz)
drop  xnorcsiz
ren _xnorcsiz xnorcsiz

revrs srcbelt, replace
revrs xnorcsiz, replace

la var xnorcsiz "xnorcsiz"
la var srcbelt "srcbelt"

recode size (250/1000000=1)(nonm=0), gen(city250k)
recode size (100/1000000=1)(nonm=0), gen(city100k)


xtile sizD=size, nq(10)
xtile sizQ=size, nq(5)

la var sizD "size deciles"
la var sizQ "size quintiles"

note sizD: deciles of SIZE variable "Size of Place in thousands-A 4-digit number which provides actual size of place of interview." (see appendix for details)

note xnorcsiz: EXPANDED N.O.R.C. SIZE CODE (see appendix for details)
note srcbelt: SRC BELTCODE (see appendix for details)

_pctile size, nq(10)
la def sizD_lab 1 "-`r(r1)'k" 2 "`r(r1)'-`r(r2)'k" 3 "`r(r2)'-`r(r3)'k" 4 "`r(r3)'-`r(r4)'k" 5 "`r(r4)'-`r(r5)'k" 6 "`r(r5)'-`r(r6)'k" 7 "`r(r6)'-`r(r7)'k" 8 "`r(r7)'-`r(r8)'k" 9 "`r(r8)'-`r(r9)'k" 10 "`r(r9)'k-" 
la val sizD sizD_lab
return list
/*
la def sizD_labc   
1 "-`r(r1)'k"        
2 "`r(r1)'-`r(r2)'k"  
3 "`r(r2)'-`r(r3)'k" 
4 "`r(r3)'-`r(r4)'k" 
5 "`r(r4)'-`r(r5)'k" 
6 "`r(r5)'-`r(r6)'k" 
7 "`r(r6)'-`r(r7)'k" 
8 "`r(r7)'-`r(r8)'k" 
9 "`r(r8)'-`r(r9)'k" 
10 "`r(r9)'k-"  
*/

_pctile size, nq(5)
la def sizQ_lab 1 "-`r(r1)'k" 2 "`r(r1)'-`r(r2)'k" 3 "`r(r2)'-`r(r3)'k" 4 "`r(r3)'-`r(r4)'k" 5 "`r(r4)'k-" 
la val sizQ sizQ_lab
return list
/*
la def sizD_labc   
1 "-`r(r1)'k"        
2 "`r(r1)'-`r(r2)'k"  
3 "`r(r2)'-`r(r3)'k" 
4 "`r(r3)'-`r(r4)'k" 
5 "`r(r4)'-`r(r5)'k" 
6 "`r(r5)'-`r(r6)'k" 
7 "`r(r6)'-`r(r7)'k" 
8 "`r(r7)'-`r(r8)'k" 
9 "`r(r8)'-`r(r9)'k" 
10 "`r(r9)'k-"  
*/


recode res16 (1=1 "nonfarm")(2=2 "farm")(3=3 "-50k")(4=4 "50k-250k")(5=5 "city sub")(6=6 "250k-"),gen(_res16)
ta res16 _res16
drop res16
ren _res16 res16


la var res16 "place when 16 yo"

note res16: "30. Which of the categories on this card comes closest to the type of place you were living in when you were 16 years old?"

note mobile16: "When you were 16 years old, were you living in this same (city/town/county)?"


/* nature */

d garden sciworse resnatur naturpax naturwar naturgod  
sum garden sciworse resnatur naturpax naturwar naturgod  
codebook garden sciworse resnatur naturpax naturwar naturgod  

replace garden=0 if garden==2
revrs sciworse, replace
revrs resnatur, replace
revrs naturpax, replace
revrs naturwar, replace

/* neighborhood */

des commute clsenei livecom1 livecom
sum commute clsenei livecom1 livecom

des  livehome comyear
sum  livehome comyear


tab commute, mi
xtile qcommute = commute if commute<100, nq(5)
la var qcommute "commute time quintiles" 

tab livecom1, mi
xtile qlivecom1 = livecom1 if livecom1<100, nq(5)
la var qlivecom1 "live in community quintiles"
          /*86*/
tab commute 
          /*86*/
tab frineigh 
          /*96*/
tab clsenei 
          /*96*/
tab livecom1   
des livecom1 clsenei commute frineigh

/* moving etc */

d mov*

sum livehome livecom

ta livehome

lookfor length
lookfor stay
lookfor address
lookfor move
lookfor reason



/************/
/* sociodem */
/************/

/* person */

des age

la var age "age"
note age: age of respondent 

drop age2                               
gen age2=age^2                          
la var age2 "age squared"

codebook  born
replace born=0 if born==2
la var born "born in the U.S."
la def born_lbl 0"no" 1"yes"
la val born born_lbl

recode health (1=4 "4.excellent") (2=3 "3.good") (3=2 "2.fair") (4=1 "1.poor"), gen(aok100)
drop health
ren aok100 health
la var health "health"

note health: CONDITION OF HEALTH  "Would you say your own health, in general, is excellent, good, fair, or poor?"

codebook sex
ren sex male
replace male=0 if male==2
la var male "male"
note male: male
note male: RESPONDENT'S SEX
label drop SEX

recode male (1=0 "male")(0=1 "female"), gen(fem)
ta male fem, mi
la var fem "female"
note fem: RESPONDENT'S SEX
//Interviewer coded. so is race etc may add that later

/* family */

ta childs
note childs: "How many children have you ever had? Please count all that were born alive at any time (including any you had from a previous marriage)."


codebook hompop
gen hompop1=(hompop==1)
replace hompop1=. if hompop==.n
la var hompop1 "1 person in houshold"
gen hompop2=(hompop==2)
replace hompop2=. if hompop==.n
la var hompop2 "2 persons in houshold"
gen hompop3=(hompop>2)
replace hompop3=. if hompop==.n
la var hompop3 "more than 3 persons in houshold"
note  hompop: NUMBER OF PERSONS IN HOUSEHOLD "Household Size and Composition"


codebook marital
gen mar=(marital==1)                    
la var mar "married"
replace mar=. if marital>100
note mar:  MARITAL STATUS  "Are you currently--married, widowed, divorced, separated, or have you never been married?" NOTE: variable recoded to 1 if married, 0 otherwise


/* crim*/

codebook fear
recode fear (1=1)(2=0), gen(_fear)
drop fear
ren _fear fear

la var fear "afraid to walk at night in neighborhood"

/* soc capital*/

lookfor leisure
  
lookfor friends
          /*it is only available for these years: 89 98 06 */
tab year timefrnd

codebook trust
recode trust (1=1 "can trust")(2 3 = 0 "depends, cannot trust"),gen(_trust)

recode trust (1=3 "can trust")(3=2 "depends")(2=1 "cannot trust"),gen(trustC)
la var trustC "people can be trusted"

drop trust
ren _trust trust
note trust: "Generally speaking, would you say that most people can be trusted or that you can't be too careful in dealing with people?" 
la var trust "trust"
d cantrust anomia8

codebook class
drop if class==5
recode class (1=1 "lower") (2=2 "working") (3=3 "middle") (4=4 "upper") , gen(cl)
decode cl, gen(class_)
drop cl

tab class, gen(C)

note class: "If you were asked to use one of four names for your social class, which would you say you belong in: the lower class, the working class, the middle class, or the upper class? "

d helpful 
recode helpful (1=3 "helpful")(3=2 "depends")(2=1 "lookout for self"),gen(helpfulC)

la var helpfulC "people are helpful"
note helpfulC:  "Would you say that most of the time people try to be helpful, or that they are mostly just looking out for themselves? (HELPFUL)" 


*cheat, lie 

lookfor wrong //lots of interesting things here
sum taxcheat govcheat anomia3

recode fair (1=1 "take advantage")(2=3 "fair")(3=2 "depends"),gen(fairC)
//ta fair*
la var fairC "people are fair"
note fairC: "Do you think most people would try to take advantage of you if they got a chance, or would' they try to be fair?"


//see smith79 factor misanthropy
alpha helpfulC trustC fairC
sum helpfulC trustC fairC
factor helpfulC trustC fairC, fa(1)
rotate, varimax
predict revMisanthropy
revrs revMisanthropy
corr *Misa*
ren revrevMisanth misanthropy
la var misanthropy "misanthropy" // see marsden12 p88 tab 4.1
note misanthropy: (misanthropy scale)


/*work*/

codebook wantjob1

lookfor work
  
lookfor extra
           /*02 06 */
des mustwork moredays

note moredays:  DAYS PER MONTH R WORK EXTRA HOURS "How many days per month do you work extra hours beyond your usual schedule?"

note mustwork: MANDATORY TO WORK EXTRA HOURS "When you work extra hours on your main job, is it mandatory (required by your employer)?"

codebook  wktopsat satjob
replace wktopsat=5-wktopsat
replace satjob=5-satjob
          /*these variables give sense of accomplishment*/
des jobmeans
           /*02 06 */
des hrsrelax
          /*1989     1998       2006 */
des hrsmoney

codebook wrkstat

la var wrkstat "work status"

note wrkstat:  LABOR FORCE STATUS "Last week were you working full time, part time, going to school, keeping house, or what?"

drop unemp
gen unemp=0
          /* there is also a category temp not working*/
replace unemp=1 if wrkstat==4
replace unemp=. if wrkstat==.n
la var unemp "unemployed"
note unemp: "Last week were you working full time, part time, going to school, keeping house, or what?" "Unemployed, laid off, looking for work"

recode wrkstat (7=1)(nonm=0), gen(housewife)
la var housewife "heeping house"
recode wrkstat (1 2=1)(nonm=0), gen(full_part)
la var full_part "working full or part time"

tostring(isco88),gen(isco2)             
replace isco2=substr(isco2,1,2)
la var isco2 "2 digit occupation"
gen isco1=substr(isco2,1,1)
tab isco1
la var isco1 "1 digit occupation"

note isco1: RESPONDENT'S OCCUPATION, 1988 CENSUS; NOTE: collapsed to 8 major sectors 

la def isco1_lbl 1 "professional" 2 "administrative/managerial" 3"clerical" 4"sales" 5"service" 6"agriculure" 7"production,transport" 8"craft, technical" 9"craft, technical2"
destring isco1, replace
la val isco1 isco1_lbl
replace isco1=8 if isco1==9

tostring isco88, gen(isco3)
replace isco3=substr(isco3,1,3)
destring isco3, replace
la var isco3 "3 digit occupation"

//>>>
codebook indus10, ta(1000)
/* gen isco1=substr(isco2,1,1) */
/* tab isco1 */
/* la var isco1 "1 digit occupation" */

recode indus10 (170/690=1 "agricult,mine,util")(770=2 "construction")(1070/3990=3 "manufacture")(4070/4590=0 "wholesale trade")(4670/5790=4 "retail")(6070/6469=5 "transpo,warehouse")(6470/6780=6 "publish,telecom,info")(6870/7190=7 "bank,real estate")(7270/7680=8 "service professional")(7690/7790=9 "services")(7860/7970=10 "edu services")(7970/8180=11 "health services")(8190/8290=12 "hospitals and care")(8370/8470 9160/9190=13 "social asistance")(8560/8670=14 "arts, recreation,entertainment")(8680/9090=15 "services food personal")(9290=16 "services private household")(9370/9870=17 "publ adm, govt,mil"), gen(ind17)

recode indus10 (170/690=1 "agricult,mine,util")(770=2 "construction")(1070/3990=3 "manufacture")(4070/4590=0 "wholesale trade")(4670/5790=4 "retail")(6070/6469=5 "transpo,warehouse")(6470/6780 6870/7190=6 "publish,telecom,info;bank,real estate")(7270/7680 7690/7790=7 "professional, commercial, waste, landscaping")(7860/7970=8 "edu services")(7970/8180 8190/8290=9 "health services; hospitals and care") (8370/8470 9160/9190 9370/9870=10 "social asistance") (8560/8670 8680/9090 9290=11 "food, personal, leisure, private household") , gen(ind11)



note hrs1:  IF WORKING, FULL OR PART TIME: "How many hours did you work last week, at all jobs?"

gen hrs_c=.    
replace hrs_c = 0 if unemp==1
replace hrs_c =1 if hrs1<17& hrs1>=0
replace hrs_c =2 if hrs1<35& hrs1>16
replace hrs_c =3 if hrs1<40& hrs1>34
replace hrs_c =4 if hrs1==40
replace hrs_c =5 if hrs1<50& hrs1>40
replace hrs_c =6 if hrs1<60& hrs1>49
replace hrs_c =7 if hrs1<150& hrs1>59
la var hrs_c "working hours categories"

la def hrs_c_lbl 0 "unemployed" 1 "0-16" 2 "17-34" 3 "35-39" 4 "40" 5 "41-49" 6 "50-59" 7 "60-90"
la val hrs_c hrs_c_lbl

ta hrs_c , gen(HH) 
d HH*

forval i=1/8{ //so that HH0 denotes unemployed :)
loc i0 = `i' - 1
ren HH`i' HH`i0'
}

sum hrs1 if HH0==1
la var HH0 "hours: unemployed"
note HH0:  LABOR FORCE STATUS  "Last week were you working full time, part time, going to school, keeping house, or what?" NOTE: if answered "Unemployed, laid off, looking for work" variable coded as 1, 0 otherwise


sum hrs1 if HH1==1
la var HH1 "hours: 0-16"
sum hrs1 if HH2==1
la var HH2 "hours: 17-34"
sum hrs1 if HH3==1
la var HH3 "hours: 35-39"
sum hrs1 if HH4==1
la var HH4 "hours: 40"
sum hrs1 if HH5==1
la var HH5 "hours: 41-49"
sum hrs1 if HH6==1
la var HH6 "hours: 50-59"
sum hrs1 if HH7==1
la var HH7 "hours: 60-90"

ta wrkstat HH0, mi

ta wrkstat, gen(WS)
d WS*

la var WS1 "wrk stat: working full time"
la var WS2 "wrk stat: working part time"
la var WS3 "wrk stat: temp not working"
la var WS4 "wrk stat: unempl or laid off"
la var WS5 "wrk stat: retired"
la var WS6 "wrk stat: school"
la var WS7 "wrk stat: keeping house"
la var WS8 "wrk stat: other"

codebook wrkstat
recode wrkstat (1=0)(2=1 "working parttime")(nonm=.),gen(prtTim)
la var prtTim "part time"

note sethours:  WHO SET WORKING HOURS " Which of the following statements best describes how your working hours are decided? (By working hours we mean here the times you start and Finish work, and not the total hours you work per week or month.)"

la var hrsmoney "hours v money"

note hrsmoney:  R PREFERENCE RE: WORK HRS AND MONEY  " Think of the number of hours you work and the money you earn in your main job, including regular overtime. If you had only one of these three choices, which of the following would you prefer?"

ta sethours, gen(SH)
ta hrsmoney, gen(HM)
la var SH1 "sethours: employer decides"
la var SH2 "sethours: i decide w/limts"
la var SH3 "sethours: free to decide"

la var HM1 "hrsmoney: more and more"
la var HM2 "hrsmoney: same and same"
la var HM3 "hrsmoney: fewer and less"

ta isco1,gen(IS) 
la var IS1   "occ: professional"
la var IS2   "occ: administrative and managerial"
la var IS3   "occ: clerical"
la var IS4   "occ: sales"
la var IS5   "occ: service"
la var IS6   "occ: agriculure"
la var IS7   "occ: production and transport"
la var IS8   "occ: craft and technical"


d   fringe6 flextime flexhrs rflexhrs  wrksched chngtme  sethours

codebook fringe6
recode fringe6 (1=1)(2=0), gen(fle_hou) 
la var fringe6 "flexible hours, or flextime scheduling"

codebook flextime
recode flextime (1=1)(2=0), gen(all_fle) 
la var all_fle "allow workers more flexible hours"

codebook flexhrs
revrs flexhrs, replace
ren flexhrs imp_fle
la var imp_fle "importance of flexible hrs"

codebook rflexhrs
revrs rflexhrs, replace
d rflexhrs
ren rflexhrs fle_houV2
la var fle_houV2 "have flexible hours"

codebook wrksched

codebook chngtme 
revrs chngtme, replace 
ren chngtme chn_sch
la var chn_sch "can change schedule"

note chn_sch: HOW OFTEN R ALLOWED CHANGE SCHEDULE " How often are you allowed to change your starting and quitting times on a daily basis?"

ta  chn_sch, gen(CS)

sum wrkhome whywkhme

codebook wrkhome
ren wrkhome wrk_hme
la var  wrk_hme "work from home"

ren whywkhme why_hme

d wrk_hme why_hme

d  jobpromo promteok

la var famwkoff "not hard to take time off"

note famwkoff: HOW HARD TO TAKE TIME OFF " How hard is it to take time off during your work to take care of personal or family matters?"

revrs famwkoff, replace
ta famwkoff, gen(FW)
d FW*

d fle_hou all_fle imp_fle fle_houV2 wrksched chn_sch sethours wrk_hme why_hme famwkoff  jobpromo promteok


codebook madat12 bosswrks bossemps work5   

recode madat12 (1=1)(2=0),gen(bossMad)
la var bossMad "angry at my boss"

recode work5 (1=1)(2=0),gen(bossTrouble)
la var bossTrouble "having trouble with one's boss"

revrs bosswrks, replace
revrs bossemps, replace

la var  bosswrks "management and workers always in conflict"

d sethrs paidhow  usualhrs mosthrs leasthrs advsched wrkshift  timeoff
codebook sethrs paidhow  usualhrs mosthrs leasthrs advsched wrkshift  timeoff,tab(100)


d sethrs
ta sethrs
recode sethrs (5=0 "outside of my/employer control")(1=1 "employer decides with little/no input")(2=2 "employer decides with input")(3=3 "i decide witin limits")(4=4 "i decide without limits"), gen(_sethrs)
ta _sethrs sethrs, mi
drop sethrs
ren _sethrs sethrs
la var sethrs "decide working hours" 


ta sethrs,gen(SHH)
//LATER depending if cat close and missing obs can combine cat
tabstat swb,by(sethrs) stat(mean)format(%9.2f)

note sethrs: "Which of the following statements best describes how your working hours are decided? In this question, working hours refers to the total number of hours you work each week, not the time you start and finish work each day. "


d paidhow
//codebook paidhow //, det  //tabulate(100)
ta paidhow
ta paidhow, nola
recode paidhow (1=0)(2=1)(nonm=.),gen(hr) 
la var hr "paid by the hour"
note hr: "In this section, we ask about your work hours and how you are paid. When referring to jobs, we are referring to jobs for which you work for pay, not volunteer work, unpaid housework, or other unpaid activities. When we refer to work hours, we ask you to include all hours performed for a paid job, including any extra hours, overtime, work you did at home for your paid job, and hours that may not have been directly billable or compensated. Are you salaried, paid by the hour, or paid some other way? If you have more than one job, think of the job in which you spend the most hours working each week.  "

ta advsched
ta advsched, nola
tabstat swb,by(advsched) stat(mean)format(%9.2f)

recode advsched (7=1 "never")(1=2 "-1 day")(2 3=3 "2 days-1 wk")(4 5 6=4 "1 wks-"), gen(advSch)
ta advsch advSch,mi
ta advSch, gen(AS)
d AS*
la var AS2 "-1 day"
la var AS3 "2 days-1 wk"
la var AS4 "1 wk-"

la var advSch "how far in advance do you schedule work"

note advsched: "How far in advance do you usually know what days and hours you will need to work? "
note advSch: "How far in advance do you usually know what days and hours you will need to work? "

note region: "Census region"

note wrkshift: "Which of the following statements best describes your usual working schedule in your main job? "
ta wrkshift, gen(WSS)
d WSS*
la var WSS1 "regular schedule or shift (daytime, evening, or night)"
la var WSS2 "schedule or shift regularly changes"
la var WSS3 "daily working times are decided at short notice"

recode wrkshift (1=1 "regular")(2=2 "regularly changes")(3=3 "decided at short notice"), gen (_w)
drop wrkshift
ren _w wrkshift

ta timeoff, gen(TO)
d TO*
la var TO2 "not too difficult"
la var TO3 "somewhat difficult"
la var TO4 "very difficult"

la var timeoff "difficult to take hour or two off"
note timeoff: "How difficult would it be for you to take an hour or two off during working hours, to take care of personal or family matters?"


lookfor self
sum wrkslf pawrkslf spwrkslf
codebook wrkslf
replace wrkslf=0 if wrkslf==2
codebook wrkslf

ta milwrknw //CURRENTLY WORK FOR MILITARY OR DOD? only 78 obs



gen mostUsual=mosthrs/usualhrs
sum mostUsual
la var mostUsual "most hrs per week past month/usual hours"
note mostUsual: "In the last month, what is the greatest number of hours you worked in a week, at all paid jobs? Please consider all hours, including any extra hours, overtime, work you did at home for your job, and time you spent on work that may not have been directly billable or compensated." / "How many hours a week do you usually work, at all paid jobs? "

gen leastUsual=leasthrs/usualhrs
sum leastUsual
la var leastUsual "fewest hrs per week past month/usual hours"
note  leastUsual: "In the last month, what is the fewest number of hours you worked in a week, at all paid jobs? Please do not include weeks in which you missed some or all hours because of illness, vacation, or other personal obligations. " / "How many hours a week do you usually work, at all paid jobs?"

gen mostLeastUsual=(mosthrs-leasthrs)/usualhrs //new var as per loonnie and it has some fancy name in the literature
la var mostLeastUsual "(mosthrs-leasthrs)/usualhrs"


d waypaid
ta waypaid
codebook waypaid,ta(100)
replace waypaid=3 if inlist(waypaid,4,5,6,7,8,9,10,11,12)

replace secondwk=0 if secondwk==2

d stress
revrs stress, replace

d usedup
revrs usedup, replace

ta slpprblm
revrs slpprblm, replace

ta overwork
revrs overwork, replace

codebook knowschd, ta(100)

/*race*/

codebook race
recode race (1=1)(nonm=0), gen(white) 
la var white "white"
note white: RACE "What race do you consider yourself?" 

codebook race
recode race (2=1)(nonm=0), gen(black) 
la var black "black"
note black: RACE "What race do you consider yourself?" 

codebook hhrace
gen hhwhite=(hhrace==1)
replace hhwhite=. if hhrace>5
la var hhwhite "white household" 

gen hhblack=(hhrace==2)
replace hhblack=. if hhrace>5
la var hhblack "black household"

d  raclive racclos racdis
sum  raclive racclos racdis

codebook raclive
replace raclive=0 if raclive==2
la def raclive_lbl 0"no" 1"yes"
la val raclive raclive_lbl
la var raclive "opposite race in the neighbourhood"
note raclive: "Are there any (Negroes/Blacks/African-Americans)['Blacks' and 'Whites' for 'White' and 'Black' respondents since 1978] living in this neighborhood now?" gss name: 'raclive'

la var racdis "distance to opposite race"
note racdis: "How many blocks (or miles) away do they (the [Negro/Black/African-American] ['Blacks' and 'Whites' for 'White' and 'Black' respondents since 1978]  families who live closest to you) live?" gss name: racdis

replace racclos=0 if racclos==2
la def racclos_lbl 0"no" 1"yes"
la val racclos racclos_lbl
la var racclos "opposite race living in the neighbourhood"
note racclos: "Are there any (Negro/Black/African-American)['Blacks' and 'Whites' for 'White' and 'Black' respondents since 1978] families living close to you?" gss name: 'racclos'


note livewhts:  "Now I'm going to ask you about different types of contact with various groups of people. In each situation would you please tell me whether you would be very much in favor of it happening, somewhat in favor, neither in favor nor opposed to it happening, somewhat opposed, or very much opposed to it happening?"  "Living in a neighborhood where half of your neighbors were whites?"

note liveblks: "Now I'm going to ask you about different types of contact with various groups of people. In each situation would you please tell me whether you would be very much in favor of it happening, somewhat in favor, neither in favor nor opposed to it happening, somewhat opposed, or very much opposed to it happening?"  " Living in a neighborhood where half of your neighbors were blacks?"

revrs liveblks, replace

//TODO 
d racopen affrmact wrkwayup helpblk closeblk
sum racopen affrmact wrkwayup helpblk closeblk

note closeblk ``In general, how close do you feel to Blacks ?''

/*religion*/

d actchurh lapsed memchurh churchtx grpchurh grprelig
sum actchurh lapsed memchurh churchtx grpchurh grprelig

recode memchurh (1=1) (2=0), gen(memChu)
la var memChu "member in church group"

d attend attweek grace relig16 volrelig hrsrelig relactiv attrelig numdays othrel 
sum attend attweek grace relig16 volrelig hrsrelig relactiv attrelig numdays othrel 

codebook attend

codebook relig, tab(100)
gen prot=(relig==1)
replace prot=. if relig>13
la var prot "protestant"

gen cath=(relig==2)
replace cath=. if relig>13
la var prot "catholic"

la var prot "protestant"
la var cath "catholic"

la var god "believe in God"
note god: "Please look at this card and tell me which statement comes closest to expressing what you believe about God."

la var neargod "close to God"
revrs neargod, replace
note neargod: "How close do you feel to God most of the time? Would you say extremely close, somewhat close, not very close, or not close at all?"

//http://www.slideshare.net/rjone07/measurement-presentation-final
lookfor spirit
d sprtprsn

codebook feelrel
la var feelrel "religious"
revrs feelrel, replace
note feelrel: "Would you describe yourself as extreme relgious, very religious, somwhat relgious, not rel or non, somewhat non-rel, very non-rel, extreme non-rel"

d pray
revrs pray, replace

/*income*/ 

d income*
ta income year
sum income
ta income98
d income*

codebook income72, tab(100)
xtile i72= income72 if income72<13, nq(5)

codebook income77   , tab(100)
xtile i77= income77 if income77<17, nq(5)

codebook income82   , tab(100)
xtile i82=  income82 if income82<18, nq(5)

codebook income86   , tab(100)
xtile i86= income86 if  income86<21, nq(5)

codebook income91 , tab(100)   
xtile i91= income91 if income91<22, nq(5)

codebook income98   , tab(100)
xtile i98= income98 if income98<24, nq(5)

codebook income06   , tab(100)
xtile i06= income06 if income06<26, nq(5)

ren income _inc 

gen income=.
la var income "income quantiles"
note income: TOTAL FAMILY INCOME "In which of these groups did your total family income, from all sources, fall last year – XXXX – before taxes, that is. Just tell me the letter." Descriptive Text: Hand Card A20 reads: Total income includes interest or dividends, rent, Social Security, other pension, alimony or child support, unemployment compensation, public aid (welfare), armed forces or veterans allotment. NOTE: Variable was recoded into quantiles for each year and then pooled together.

replace income=i72 if income==.
ta  year income,mi
replace income=i77 if income==.
ta  year income,mi
replace income=i82 if income==.
ta  year income,mi
replace income=i86 if income==.
ta  year income,mi
replace income=i91 if income==.
ta  year income,mi
replace income=i98 if income==.
ta  year income,mi
replace income=i06 if income==.
ta  year income,mi

levelsof year, local(lev)
//LATER realrinc conrinc  missing obs need to do capture or sth...
foreach v of varlist realinc  coninc  {  
foreach l of local lev{
di `l'
xtile `v'`l'= `v' if `v' < . & year==`l'   , nq(5)
}
}

foreach v of varlist realinc  coninc {  
gen `v'5 = .
foreach l of local lev{
di `l'
replace  `v'5 = `v'`l' if  year==`l' 
drop `v'`l'
}
}

corr income realinc5 coninc5
//whew; thank good my original income correlates well with realinc :)
//and quintiles for realinc and coninc are exactly same so just use realinc


levelsof year, local(lev)
//LATER realrinc conrinc  missing obs need to do capture or sth...
foreach v of varlist realinc  coninc  {  
foreach l of local lev{
di `l'
xtile `v'`l'= `v' if `v' < . & year==`l'   , nq(10)
}
}

foreach v of varlist realinc  coninc {  
gen `v'10 = .
foreach l of local lev{
di `l'
replace  `v'10 = `v'`l' if  year==`l' 
drop `v'`l'
}
}
corr income realinc10 coninc10
//whew; thank good my original income correlates well with realinc :)
//and quintiles for realinc and coninc are exactly same so just use realinc

replace realinc=realinc/1000000
la var realinc "family income in \\\$1986, millions"

la var realinc5 "quintiles of family income, \\\$1986"
la var realinc10 "deciles of family income, \\\$1986"


note realinc: Income variables ( INCOME72 , INCOME , INCOME77 , INCOME82 , INCOME86 , INCOME91 , INCOME98 , INCOME06 ) are recoded in six-digit numbers and converted to 1986 dollars. The collapsed numbers above are for convenience of display only. Since this variable is based on categorical data, income is not continuous, but based on categorical mid-points and imputations. For details see GSS Methodological Report No. 64.

//same note...
note realinc5: Income variables ( INCOME72 , INCOME , INCOME77 , INCOME82 , INCOME86 , INCOME91 , INCOME98 , INCOME06 ) are recoded in six-digit numbers and converted to 1986 dollars. The collapsed numbers above are for convenience of display only. Since this variable is based on categorical data, income is not continuous, but based on categorical mid-points and imputations. For details see GSS Methodological Report No. 64.

//same note...
note realinc10: Income variables ( INCOME72 , INCOME , INCOME77 , INCOME82 , INCOME86 , INCOME91 , INCOME98 , INCOME06 ) are recoded in six-digit numbers and converted to 1986 dollars. The collapsed numbers above are for convenience of display only. Since this variable is based on categorical data, income is not continuous, but based on categorical mid-points and imputations. For details see GSS Methodological Report No. 64.


/* note coninc: Income variables ( INCOME72, INCOME, INCOME77, INCOME82, INCOME86, INCOME91 ) are recoded in six-digit numbers and converted to 2000 dollars. The collapsed numbers above are for convenience of display only. Since this variable is based on categorical data, income is not continuous, but based on categorical mid-points and imputations. For details see GSS Methodological Report No. 101. */


/* ethnic orgin */

codebook ethnic, tab(100)
gen brit=.
replace brit=0 if ethnic<100
replace brit=1 if ethnic==8|ethnic==24|ethnic==14

gen  scan=.
replace scan=0 if ethnic<100
replace scan=1 if ethnic==7|ethnic==9|ethnic==19|ethnic==26

gen  n_e=.
replace n_e=0 if ethnic<100
replace n_e=1 if ethnic==2|ethnic==36|ethnic==11|ethnic==18|ethnic==27

gen  med=.
replace med=0 if ethnic<100
replace med=1 if ethnic==10|ethnic==12|ethnic==15|ethnic==25|ethnic==32

gen  e_e=.
replace e_e=0 if ethnic<100
replace e_e=1 if ethnic==6|ethnic==13|ethnic==33|ethnic==21|ethnic==23|ethnic==35

gen  mex=.
replace mex=0 if ethnic<100
replace mex=1 if ethnic==17

gen  africa=.
replace africa=0 if ethnic<100
replace africa=1 if ethnic==1

gen eth=.
replace eth=1 if brit==1|scan==1|n_e==1
replace eth=2 if med==1
replace eth=3 if africa==1
replace eth=4 if  eth==. & ethnic<100

la def eth_lbl 1"NW Europe" 2"Mediterranean" 3"Africa" 4"other"

la val eth eth_lbl

tab eth, gen(E)

la var E1 "NW Europe"
la var E2 "Mediterranean"
la var E3 "Africa"
la var E4 "Other"


/************/
/* politics */
/************/

codebook partyid
gen rep=(partyid>3&partyid<7)
gen dem=(partyid>-1&partyid<3)

replace rep=. if partyid>7
replace dem=. if partyid>7

drop partyid2
gen partyid2=.
replace partyid2=1 if rep==1
replace partyid2=2 if dem==1
replace partyid2=3 if partyid==3| partyid==7
la def partyid2_lbl 1"R" 2"D" 3"Independent/Other" 
la val partyid2 partyid2_lbl 

recode partyid2 (1=1 "R") (3=2 "I") (2=3 "D")  ,gen(rid)
decode rid, gen(rid_)

la var dem "democrat"
la var rep "republican"

note dem: "Generally speaking, do you usually think of yourself as a Republican, Democrat, Independent, or what?"    "STRONG DEMOCRAT" or "NOT STR DEMOCRAT" or "IND,NEAR DEM" 

note rep: "Generally speaking, do you usually think of yourself as a Republican, Democrat, Independent, or what?"    "STRONG REPUBLICAN" or "NOT STR REPUBLICAN" or "IND,NEAR REP" 

codebook polviews
gen polviews2=.
replace polviews2=1 if polviews<4
replace polviews2=2 if polviews>4 &  polviews<.
replace polviews2=3 if polviews==4
la def polviews2_lbl 1"liberal" 2"conservative" 3"moderate" 
la val polviews2 polviews2_lbl 

recode polviews2 (2=1 "C") (3=2 "M") (1=3 "L") , gen(cml)
decode cml, gen(cml_)

gen rid_cml =rid_ + "_" + cml_

gen lib=.
replace lib=1 if polviews2==1
replace lib=0 if polviews2==2| polviews2==3

gen con=.
replace con=1 if polviews2==2
replace con=0 if polviews2==1| polviews2==3

la var lib "liberal"
note lib: "We hear a lot of talk these days about liberals and conservatives. I'm going to show you a seven-point scale on which the political views that people might hold are arranged from extremely liberal--point 1--to extremely conservative-- point 7. Where would you place yourself on this scale?" "SLGHTLY LIBERAL" or "LIBERAL" or "EXTRMLY LIBERAL"
la var con "conservative"
note con: "We hear a lot of talk these days about liberals and conservatives. I'm going to show you a seven-point scale on which the political views that people might hold are arranged from extremely liberal--point 1--to extremely conservative-- point 7. Where would you place yourself on this scale?" "SLGHTLY CONSERVATIVE" or "CONSERVATIVE" or "EXTRMLY CONSERVATIVE"


/**************/
/* femaleness */
/**************/
// see marsden12 p88 tab 4.1

/* gender-congenial */
revrs eqwlth, replace
revrs helppoor, replace
revrs helpnot, replace

la var helpnot "should govt do more"

** women issues

//these are vars from \citet[][ch. 4]{marsden12}
loc va fepres fepol fehome fework fehelp fefam fechld fepresch
d `va'
sum `va'
foreach v of varlist `va'{
d `v'
ta year if `v'<.
}

alpha fepres fepol  fework  fefam fechld fepresch
foreach v of varlist fepres fepol  fework  fefam fechld fepresch{
d `v'
ta year if `v'<.
}

alpha fepres fepol  fefam fechld fepresch
alpha        fepol  fefam fechld fepresch

foreach v of varlist  fepres fepol  fefam fechld fepresch{
d `v'
ta year if `v'<.
}


foreach v of varlist  fepol  fefam fechld fepresch{
d `v'
ta year if `v'<.
}

codebook  fepres fepol fefam fechld fepresch

recode fepres (2=1)(1=0)(nonm=.), gen(_fepres) 
drop fepres
ren _fepres fepres
la var fepres "won't vote for female president"
note fepres: "If your party nominated a woman for President, would you vote for her if she were qualified for the job?" 

recode fepol (1=1)(2=0)(nonm=.), gen(_fepol) 
drop fepol
ren _fepol fepol
la var fepol "women not suited for politics"
note fepol: "Tell me if you agree or disagree with this statement: Most men are better suited emotionally for politics than are most women."

revrs fefam , replace 
la var fefam "man career, female housewife"
note fefam: "It is much better for everyone involved if the man is the achiever outside the home and the woman takes care of the home and family." 

la var fechld "mother working ok for kids"
note fechld: "A working mother can establish just as warm and secure a relationship with her children as a mother who does not work."

revrs fepresch, replace
la var fepresch "kids suffer if mother works"
note fepresch: "A preschool child is likely to suffer if his or her mother works."

recode fework (2=1)(1=0), gen(_fework)
drop fework
ren _fework fework
la var fework "married women stay home"
note fework: "Do you approve or disapprove of a married woman earning money in business or industry if she has a husband capable of supporting her?"


sum fepres fepol fework fechld fepresch
corr fepres fepol fework fechld fepresch
alpha fepres fepol fework fechld fepresch
foreach v of varlist fepres fepol fework fechld fepresch{
ta year if `v'<.
}

recode abany (2=0), gen(abortion)
la var abortion "support abortion"

//later
d fehome 


alpha fepol  fefam fechld fepresch
factor fepol  fefam fechld fepresch
rotate, varimax
predict femTra
la var femTra "traditionalism score" // see marsden12 p88 tab 4.1
note femTra: (higher means more traditional)


/* THIS WAS STUFF I PLAYED WITH SUMMER2016; COMMENTED OUT BC EITHER FEW YEARS 
 AVAILABLE IF MANY VARS; OR TOO LOW ALPHA FOR MANY YEARS; USING TEHSE IN swBFem


alpha fepres fepol fehome fework fehelp fefam fechld fepresch

factor fepres fepol fehome fework fehelp fefam fechld fepresch, fa(1)
rotate, varimax
predict femScaFull
la var femScaFull "nontraditional score; higher means less traditional" // see marsden12 p88 tab 4.1

sum fepres fepol fehome fework  fefam fechld fepresch
alpha fepres fepol fehome fework  fefam fechld fepresch


sum fepres fepol  fefam fechld fepresch
alpha fepres fepol  fefam fechld fepresch
alpha    fefam fechld fepresch //could just use these 3



loc sho fepres fepol fehome   fechld fepresch

codebook `sho'
factor `sho', fa(1)
rotate, varimax
predict femScaSho
la var femScaSho "traditionalism score" // see marsden12 p88 tab 4.1
note femScaSho: (higher means more traditional)

*/




/***********/
/* welfare */ /* collectivism-individualism */
/***********/

/* PreQuestion Text */
/* 67. We are faced with many problems in this country, none of which can be solved easily or inexpensively. I'm going to name some of these problems, and for each one I'd like you to tell me whether you think we're spending too much money on it, too little money, or about the right amount. */
/* First (READ ITEM A) . . . are we spending too much, too little, or about the right amount on (ITEM)? */

/* Literal Question */
/* K. Welfare */
recode natfare (1=3 "too little")(2=2 "about right") (3=1 "too much"), gen(welfare)
la var welfare "do not spend enough on welfare"

/* PreQuestion Text */
/* 67. We are faced with many problems in this country, none of which can be solved easily or inexpensively. I'm going to name some of these problems, and for each one I'd like you to tell me whether you think we're spending too much money on it, too little money, or about the right amount. */
/* First (READ ITEM A) . . . are we spending too much, too little, or about the right amount on (ITEM)? */

/* Literal Question */
/* M. Social Security */
recode natsoc (1=3 "too little")(2=2 "about right") (3=1 "too much"), gen(soc_sec)
la var soc_sec "social security spending"

/* PreQuestion Text */
/* 1188. On the whole, do you think it should or should not be the government's responsibility to . . . */
/* Literal Question */
/* G. Reduce income differences between the rich and poor. */
codebook equalize
recode equalize (1=4 "definietly yes")(2=3)(3=2)(4=1 "definietly no"), gen(red_dif)
la var red_dif "reduce income differences"

/* PreQuestion Text */
/* 1188. On the whole, do you think it should or should not be the government's responsibility to... */
/* Literal Question */
/* A. Provide a job for everyone who wants one. */
codebook jobsall
recode jobsall (1=4 "definietly yes")(2=3)(3=2)(4=1 "definietly no"), gen(job_all)
la var job_all "jobs for all"

codebook cntrlife
la var cntrlife "people can control their lives"

codebook fatalism
la var fatalism "people can change their life-course"   

codebook litcntrl
la var litcntrl "people can control the bad things"

codebook jobmeans
la var jobmeans "work and accomplishment are unimportant"   

codebook getahead
replace getahead=. if getahead==4

la var getahead "people get ahead through luck, not hard work"

codebook taxrich
la var taxrich "taxes on the rich  too low"   

codebook taxmid
la var taxmid "taxes on the middle class  too low"   

codebook taxpoor
la var taxpoor "taxes on the poor too low"   


**mental health


sum nocheer nervous fidgety hopeless effort   mhtrtslf mntlhlth sathealt


**com_rel


sum parsol kidssol wrkwell wrkmuch dwelngh dwelcity dwelown

recode dwelown (1=1)(2=0)(3=.), gen(own)


** consumption-car

d satcar carprivt cardealr newused typdealr buyauto carsgen carsfam carsten finan2

ren income72 _inc72
ren income77 _inc77
ren income82 _inc82
ren income86 _inc86
ren income91 _inc91
ren income06 _inc06
ren income98 _inc98


** cynthia-sex

codebook sexfreq nummen numwomen partnrs5 sexsex5 evpaidsx evstray relatsex sexornt partners premarsx,ta(20)


ren sexfreq  sexFreYr
ren partners sexParYr
la var sexParYr "number of sex partners las year"
replace sexParYr=. if sexParYr==9

codebook  premarsx, ta(100)
ren premarsx sexPreMarOk
la var sexPreMarOk "premarital sex ok"


** purpose

ren nihilism purpose
la var purpose "purpose"
note purpose: "In my opinion, life does not serve any purpose." 1="strongly agree" to 5="strongly disagree"

d egomeans


** veterans 

d vetfam vetfamnw vetaid memvet solvet actvet typvet numvet yrvet1 yrvet2 yrvet3 yrvet4 yrvet5 mtvet1 mtvet2 mtvet3 mtvet4 mtvet5 movetown vetyears vetkind    
sum vetfam vetfamnw vetaid memvet solvet actvet typvet numvet yrvet1 yrvet2 yrvet3 yrvet4 yrvet5 mtvet1 mtvet2 mtvet3 mtvet4 mtvet5 movetown vetyears vetkind    

codebook vetfam vetfamnw vetaid memvet solvet actvet typvet numvet yrvet1 yrvet2 yrvet3 yrvet4 yrvet5 mtvet1 mtvet2 mtvet3 mtvet4 mtvet5 movetown vetyears vetkind    

foreach v of varlist vetfam vetfamnw vetaid memvet solvet actvet typvet mtvet1 mtvet2 mtvet3 mtvet4 mtvet5{
replace `v'=0 if `v'==2
}

revrs movetown, replace


** migration, immigration, citizenship

d  givinfusa amcit amcitizn citizen parcit citworld kidshere kidsaway crimlose uscitzn  undocwrk undoccol undockid wlthundc wlthimm  workimm workundc excldimm immrghts letin immunemp immecon  immfare immpush immwrkup immcrmup immstats immameco immjobs immideas immimp immcosts immcult  immassim letinhsp letinasn letineur 
codebook givinfusa amcit amcitizn citizen parcit citworld kidshere kidsaway crimlose uscitzn  undocwrk undoccol undockid wlthundc wlthimm  workimm workundc excldimm immrghts letin immunemp immecon  immfare immpush immwrkup immcrmup immstats immameco immjobs immideas immimp immcosts immcult  immassim letinhsp letinasn letineur 

revrs givinfusa, replace
revrs amcit, replace
revrs amcitizn, replace
revrs parcit , replace
revrs citworld, replace
revrs kidshere, replace
revrs kidsaway, replace
revrs uscitzn, replace
revrs workim, replace
revrs workundc, replace
revrs excldimm, replace
revrs immrghts, replace
revrs letin, replace
revrs immunemp, replace
revrs immecon, replace
revrs immpush, replace
revrs immwrkup, replace
revrs immcrmup, replace
revrs immameco, replace
revrs immjobs, replace
revrs immideas, replace
revrs immimp, replace
revrs immcosts, replace
revrs immcult, replace
revrs letinhsp, replace
revrs letinasn, replace
revrs letineur, replace



replace citizen=0 if citizen==2
replace undocwrk=0 if undocwrk==2
replace undoccol=0 if undoccol==2
replace undockid=0 if undockid==2
replace immfare=0 if immfare==2


** local government
 
d loctrust locinflu locprob loccare
 


** labelling untouched vars

note educ: HIGHEST YEAR OF SCHOOL COMPLETED  A. "What is the highest grade in elementary school or high school that (you/your father/ your mother/your [husband/wife]) finished and got credit for? " CODE EXACT GRADE.; B. IF FINISHED 9th-12th GRADE OR DK*: "Did (you/he/she) ever get a high school diploma or a GED certificate?" [SEE D BELOW.]; C. "Did (you/he/she) complete one or more years of college for credit--not including schooling such as business college, technical or vocational school?" IF YES: "How many years did (you/he/she) complete?"

note fair:   "Do you think most people would try to take advantage of you if they got a chance, or would they try to be fair?"
note  prot: "What is your religious preference? Is it Protestant, Catholic, Jewish, some other religion, or no religion?"   
note  cath: "What is your religious preference? Is it Protestant, Catholic, Jewish, some other religion, or no religion?"   
note marital: "What is your religious preference? Is it Protestant, Catholic, Jewish, some other religion, or no religion?"
note  born: "Were you born in this country?"   
note  hhwhite: "Race of household" 
note  fear: "Is there any area right around here--that is, within a mile--where you would be afraid to walk alone at night?"   




* some research ides

* final recoding lol

codebook anomia1 anomia3

foreach v of varlist anomi*{
replace `v'=0 if `v'==2
}

la var anomia3 "no right and wrong ways to make money"


revrs wrkearn, replace 


d anomi*
alpha anomi*,gen(anoSca) c
sum anoSca
la var anoSca "anomie scale"

 
keep live1 income unemp prestg80 year swb  satlife  unhappy satfin satfrnd   workhr hrsmoney age age2 mar timefrnd mustwork moredays wktopsat satjob jobmeans hrsrelax hrsmoney hrs_c ds_id commute hompop* childs  hhrace hhwhite hhblack memChu attend relig16 relig cath prot xnorcsiz srcbelt livecom1  livehome comyear clsenei commute frineigh hrs2 hrs1 hrs_c isco* relgrade impchurh reltruth feelrel pray region dec  born ethnic raclive racdis racclos white black  partyid polviews trust cantrust anomia8 vote* pres* class satcity dwelling dwelown marital fear  S* eth E* e_e mex africa rep dem partyid rid rid_ polviews cml cml_ lib con qcommute qlivecom1 rid_cml class_ C* H*  R* reg2  health size sizD sizQ city100k city250k male fem satfam fair getahead helpnot helpblk fatalism taxpoor taxmid taxrich polint litcntrl cntrlife goodlife racseg livewhts racinteg racschol closeblk racsups helpblk    liveblks symptblk admirblk contblk knwblk movenei clsetown movetown cohort coh COH* cohCol COHCOL* educ parborn housewife full_part eqwlth helppoor welfare soc_sec red_dif job_all god neargod sprtprsn nocheer nervous fidgety hopeless effort   mhtrtslf mntlhlth sathealt parsol kidssol wrkwell wrkmuch dwelngh dwelcity own taxcheat govcheat anomia3 realinc realinc5 realinc10 satcar carprivt cardealr newused typdealr buyauto carsgen carsfam carsten finan2 fle_hou all_fle imp_fle fle_houV2  wrksched  stress usedup slpprblm  overwork chn_sch wrk_hme why_hme sethours wrkstat prtTim wantjob1 union  famwkoff _inc* occ10 jobpromo promteok realrinc  SH1-SH3 HM1-HM3 IS1-IS8 WS1-WS8 FW1-FW4  res16 mobile16 sexFreYr sexParYr  sexPreMarOk hapmar  vpsu wtssall vstrat  bosswrks bossemps bossTrouble bossMad  fepres fepol fefam fehome fechld fepresch fework femTra orgsize smallbig helpfulC trustC fairC misanthropy purpose sethrs paidhow  usualhrs mosthrs leasthrs mostUsual leastUsual mostLeastUsual advsched wrkshift  timeoff  AS* SHH* WSS* wrkslf waypaid  secondwk    hr advSch TO* vetfam vetfamnw vetaid memvet solvet actvet typvet numvet yrvet1 yrvet2 yrvet3 yrvet4 yrvet5 mtvet1 mtvet2 mtvet3 mtvet4 mtvet5 movetown vetyears vetkind garden sciworse resnatur naturpax naturwar naturgod   givinfusa amcit amcitizn citizen parcit citworld kidshere kidsaway crimlose uscitzn  undocwrk undoccol undockid wlthundc wlthimm  workimm workundc excldimm immrghts letin immunemp immecon  immfare immpush immwrkup immcrmup immstats immameco immjobs immideas immimp immcosts immcult  immassim letinhsp letinasn letineur  loctrust locinflu locprob loccare ind11 ind17 knowschd wrkearn ilikejob anomia1 anomia2 honest permoral rotapple wkfreedm anomi*  anoSca
saveold ~/data/gss/gss.dta,replace
//clear
//exit

//save ~/Desktop/aok_gss, replace
//scp  akozaryn@rce.hmdc.harvard.edu:~/Desktop/aok_gss.dta ~/papers/root/adam_data/gss/
/* ! scp  ~/Desktop/aok_gss.dta aok@aok.us.to:~/desk/papers/root/adam_data/gss/ */


*//-------------------------- yang06l -----------------------------------------------

/* gen _year =cohort+age */
/* count if year!=_year                                                            */
/* drop if  year!=_year */
/* keep if year== 1974|year== 1976|year== 1978|year==1984 |year==1987 |year==1988 |year==1989 |year==1990 |year== 1991|year==1993 |year==1994 |year==1996 |year==1998 |year==2000 */


/* lookfor wordsum */

/* egen _mage=mean(age) */
/* gen mage=age-_mage */

/* reg wordsum mage */


/* xi: reg happy mar  unemp  income hhblack  cath prot i.age i.year i.cohort, robust */
/* apc_ie happy mar  unemp  income hhblack  cath prot , age(age) period(year) cohort(cohort) */



*//-------------------------------2010-----------------------------------

/* cd ~/data/gss/ */
/* ! wget http://publicdata.norc.org/GSS/DOCUMENTS/OTHR/GSS_stata.zip */
/* unzipfile GSS_stata.zip */
/* use year partyid eqwlth helppoor helpnot using gss7210_r2.dta, clear */
/* rm gss7210_r2.dta */

/* replace eqwlth=8-eqwlth */
/* replace helppoor=6-helppoor */
/* replace helpnot=6-helpnot */

/* codebook partyid */
/* gen rep=(partyid>3&partyid<7) */
/* gen dem=(partyid>-1&partyid<3) */

/* replace rep=. if partyid>7 */
/* replace dem=. if partyid>7 */

/* drop partyid2 */
/* gen partyid2=. */
/* replace partyid2=1 if rep==1 */
/* replace partyid2=2 if dem==1 */
/* replace partyid2=3 if partyid==3| partyid==7 */
/* la def partyid2_lbl 1"R" 2"D" 3"Independent/Other"  */
/* la val partyid2 partyid2_lbl  */
/* recode partyid2 (1=1 "R") (3=2 "I") (2=3 "D")  ,gen(rid) */





*//-------------------------- SCRAP -----------------------------------------------

*//-------------------------- old -----------------------------------------------


/* clear                                    */
/* set mem 1200m                                */
/* version 10                               */
/* set more off                             */
/* set maxvar 10000     */
/* use "/nfs/home/A/akozaryn/shared_space/akozyarn/gss/remp7206iap.dta", clear */


/*   keep h* m* age* w* i* r* sex f* h* year soc* */

/*   save ~/Desktop/buu, replace */
/* sh(scp  ~/Desktop/buu.dta aok@theaok.info:~/desk/papers/old/2009/ditella/REPLICATION/dat/base/gss/remp7206iap.dta) */


