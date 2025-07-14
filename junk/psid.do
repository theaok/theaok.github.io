//wrote from scratch but based on:
//and then taken oct19 2021 from cartsApproach
//note: this was taken from ls_car folder
//exit
//stata-se
// ! stata-se -b do  /home/aok/data/psid/mainFam-09-19/psid.do
clear                                  
capture set maxvar 32700
version 16                             
set more off                           
run ~/papers/root/do/aok_programs.do


cd ~/data/psid/mainFam-09-19/
ls

 
//do J298731.do
//do J298731_formats.do 

//save raw-psid,replace
use  raw-psid, clear

 
**** trying to figure out shit head and wife etc [just keep head like in brown 2 papers!]

//sort ER42002
d ER42009 ER42002
l ER42009 ER42002 in 1/100 

d ER42009  ER46697 ER42016 ER42024 ER42017 ER42019

l ER42009  ER46697 ER42016 ER42024 ER42017 ER42019 in 1/30,nola
count if ER42009==4


sort ER47003 ER42009
l ER47003 ER42009  ER46697 ER42016 ER42024 ER42017 ER42019 in 1/30,

sort  ER42009 ER47003
l ER47003 ER42009  ER46697 ER42016 ER42024 ER42017 ER42019 in 1/100, sepby(ER47003)
d ER47003 ER42009  ER46697 ER42016 ER42024 ER42017 ER42019
//so can be more than head per hh; little overlap between 1968 and hh id


//ok so as per https://psidonline.isr.umich.edu/Guide/FileStructure.pdf
//Records: one record for each family in 2019
//so UA is family lol duh

/*
n the PSID study, we are attempting to learn about our sample members, and the families in which they live. Each of these families is called a family unit (FU). The FU is defined as a group of people living together as a family. They are almost always related by blood, marriage, or adoption. And they must all be living in the same HU (see below).

Occasionally, unrelated persons can be part of an FU. They need to be permanently living with the family and share both income and expenses.

Any person in a study family is a family unit member. The term "other family unit member" (OFUM) is used of members who are not the Reference Person (the term ‘Reference Person’ has replaced ‘Head’ in 2017) or Spouse/Partner.

The household unit (HU) is the physical dwelling where the members of the FU reside. It can be a house, townhouse, apartment, a room in a rooming house, even a tent or a car.

Not everyone living in an HU is automatically part of the FU. There may be other people living in the HU temporarily who do not meet the criteria of relatedness and economic integration. The PSID data is about FU Members only.

*/

//https://psidonline.isr.umich.edu/data/Documentation/UserGuide2019.pdf
/*
e family file contains one record for each family unit interviewed in a given year. It includes
all family level variables collected in that year, as well as extensive information about the Reference
Person (starting with the 2017 wave, the term ‘Reference Person’ has replaced ‘Head’) and the
Spouse/Partner. Therefore, the content of the family file is not restricted to family-level data
*/
 
**** play


count //only 14k
//is it wide or long; looks like neither--separate vars in each yr for same var; but also multiple family id across rows
 
lookfor id
lookfor wave
lookfor year
lookfor interview //usefule

lookfor satis
corr ER42024 ER47324 ER53024 ER60025 ER66025 ER72025
l ER42024 ER47324 ER53024 ER60025 ER66025 ER72025 in 1/100,nola


l ER42002 ER47302 in 1/10

lookfor 1968 //fixed over time
l ER42009 ER47309 ER53009 ER60009 ER66009 ER72009 in 1/100 //yay

lookfor gender //was head and then reference person lol
l ER42018 ER47318 ER53018 ER60018 ER66018 ER72018 in 1/100,nola

lookfor head

d ER42017

lookfor "AGE OF HEAD"

l ER42017 ER47317 ER53017 ER60017 in 1/100

count if ER42017!=ER47317-2 & ER42017!=.
count if ER42017==ER47317-2 & ER42017!=.

//guess this would allow figuring things out
d ER72007 //"FAMILY COMPOSITION CHANGE"
 
//ok so eg ER72025 "A3 LIFE SATISFACTION":
//Inap.: respondent was not Reference Person or Spouse/Partner 
//so only have ref person and spouse partenr asked this q
//so just drop if 0 on swb :)

//guess later can do unbalanced panel; now only keeping if swb is nonzero :)

corr ER42024 ER47324 ER53024 ER60025 ER66025 ER72025
d ER42024 ER47324 ER53024 ER60025 ER66025 ER72025

foreach v of varlist ER42024 ER47324 ER53024 ER60025 ER66025 ER72025{
ta `v',nola
}

count //14,367
foreach v of varlist ER42024 ER47324 ER53024 ER60025 ER66025 ER72025{
drop if `v'==0|`v'==8|`v'==9
}
count //13,711
corr ER42024 ER47324 ER53024 ER60025 ER66025 ER72025


//ok i guess i got it, so yeah i guess it should be each row same obs, otherwhise doesnt make sense

//ah ok now understand--differnt dates within year interview so makes sense
lookfor "AGE OF HEAD"
l ER42017 ER47317 ER53017 ER60017 in 1/100
count if ER42017!=ER47317-2 & ER42017!=.
count if ER42017==ER47317-2 & ER42017!=.

d ER42017 //2009

lookfor  "AGE OF REFERENCE PERSON"
d ER72017 //2019

gen di=ER72017-ER42017
ta di //yay makes sense!


//-----------------ok so now just prep for reshape!------------------

use  raw-psid, clear


//for merging with wb2016
lookfor "2015 FAMILY INTERVIEW"
d ER60002
//lookfor "SEQUENCE"
//keep if ER60002!=.

d ER48062
lookfor "TOTAL PRICE #1"

ren ER42744   car1Pri2009
ren ER48062	  car1Pri2011
ren ER53758	  car1Pri2013
ren ER60817	  car1Pri2015
ren ER66865	  car1Pri2017
ren ER72869	  car1Pri2019

lookfor "TRANSPORTATION EXPENDITURE"
ren ER46971B7   tra2009
ren ER52395B7 	 tra2011
ren ER58212B7 	 tra2013
ren ER65425   	 tra2015
ren ER71503   	 tra2017
ren ER77539   	 tra2019



d ER77581
lookfor "CLOTHING EXPENDITURE"
ren ER46971E1   clo2009
ren ER52395E1	 clo2011
ren ER58212E1	 clo2013
ren ER65446  	 clo2015
ren ER71525  	 clo2017
ren ER77581  	 clo2019


d ER64809
lookfor "SPANISH DESCENT"
ren ER46542     lat2009
ren ER51903		 lat2011
ren ER57658		 lat2013
ren ER64809		 lat2015
ren ER70881		 lat2017
ren ER76896		 lat2019

foreach v of varlist lat*{
codebook `v', ta(200)
replace `v'=. if `v'>=9
replace `v'=1 if `v'>0 & `v'<9
}



lookfor "RACE"
d ER57659

lookfor "L40 RACE OF HEAD-MENTION 1"
lookfor "L40 RACE OF REFERENCE PERSON-MENTION 1"
ren ER46543  rac2009
ren ER51904	 rac2011
ren ER57659	 rac2013
ren ER64810	 rac2015
ren ER70882	 rac2017
ren ER76897	 rac2019
codebook rac2009, ta(100)
codebook rac2019, ta(100)

foreach v of varlist rac*{
replace `v'=. if `v'==9
codebook `v', ta(200)
}

//LATER messy coding
lookfor "relig"
lookfor "RELIG DENOMINATION"
codebook ER70942, ta(100)
lookfor "RELIGIOUS PREFERENCE" //guess this then
codebook ER46592, ta(100)
codebook ER76960, ta(100)


//LATER politics like rep dem lib con would be nice





lookfor  "AGE OF HEAD"
lookfor  "AGE OF REFERENCE PERSON"
/*
ER42017
ER47317
ER53017
ER60017
ER66017
ER72017
*/
ren ER42017 age2009
ren ER47317 age2011
ren ER53017 age2013
ren ER60017 age2015 
ren ER66017 age2017
ren ER72017 age2019

foreach v of varlist age*{
codebook `v', ta(200)
replace `v'=. if `v'>200
}

lookfor satis
//ok so at least looks like foirst 2 dig is wave
ren    ER42024  swb2009
ren	 ER47324	 swb2011
ren	 ER53024	 swb2013
ren	 ER60025	 swb2015
ren	 ER66025	 swb2017
ren	 ER72025	 swb2019

foreach v of varlist swb*{
codebook `v'
replace `v'=. if `v'==0| `v'>5
revrs `v', replace
}


* k6 clingingsmith16

lookfor k-6

ren ER46375    k2009
ren ER51736 	k2011
ren ER57482 	k2013
ren ER64604 	k2015
ren ER70680 	k2017
ren ER76688	   k2019

foreach v of varlist k*{
codebook `v',ta(10000)
replace `v'=. if `v'>24
}

lookfor restless
 
ren ER46371       rle2009
ren ER51732 		rle2011
ren ER57478 		rle2013
ren ER64600 		rle2015
ren ER70676 		rle2017
ren ER76684 	   rle2019

foreach v of varlist rle*{
//codebook `v',ta(10000)
replace `v'=. if `v'>5 | `v'==0
revrs `v', replace
}



d ER46935
lookfor "TOTAL FAMILY INCOME" //

ren       ER46935  inc2009
ren	 	 ER52343	 inc2011
ren		 ER58152	 inc2013
ren		 ER65349	 inc2015
ren		 ER71426	 inc2017
ren		 ER77448	 inc2019

foreach v of varlist inc*{
//codebook `v',ta(10000)
replace `v'=. if `v'<0
}


lookfor "food"
d ER77588 //only last wave

lookfor "EMPLOYMENT STATUS"
codebook ER42140, ta(100)
lookfor  "BC1 EMPLOYMENT STATUS-1ST MENTION"
ren       ER42140     emp2009
ren	 	 ER47448 	 emp2011
ren		 ER53148	    emp2013
ren		 ER60163	    emp2015
ren		 ER66164	    emp2017
ren		 ER72164	    emp2019



lookfor "BC21 MAIN IND FOR JOB 1"
ren       ER42168  ind2009
ren	 	 ER47480  ind2011
ren		 ER53180	 ind2013
ren		 ER60195	 ind2015
ren		 ER66196	 ind2017
ren		 ER72196	 ind2019

//TODO should double chack similarity of coding for other waves too!
ta ind2009
ta ind2015
ta ind2017 //these 2 are differnt
ta ind2019 //and this one
//LATER meh like 20perc missing and brown17 and brown19 dont using them either
replace ind2017=ind2017/10
replace ind2019=ind2019/10

lookfor "L51 WTR ATTENDED COLLEGE"
ren  ER46563     col2009
ren  ER51924 	  col2011
ren  ER57680 	  col2013
ren  ER64832 	  col2015
ren  ER70904 	  col2017
ren  ER76919 	  col2019

foreach v of varlist col*{
codebook `v', ta(100)
replace `v'=. if  `v'==0 | `v'==9
replace `v'=0 if  `v'==5
}


d ER42020
lookfor "CHILDREN IN FU"
ren  ER42020    kid2009
ren  ER47320 	 kid2011
ren  ER53020 	 kid2013
ren  ER60021 	 kid2015
ren  ER66021 	 kid2017
ren  ER72021 	 kid2019

foreach v of varlist kid*{
codebook `v',ta(10000)
//replace `v'=. if `v'<0
}


d ER44175
lookfor "HEALTH STATUS"

lookfor "H1 HEALTH STATUS-HEAD" "H1 HEALTH STATUS-RP"
ren  ER44175  hea2009
ren  ER49494  hea2011
ren  ER55244  hea2013
ren  ER62366  hea2015
ren  ER68420  hea2017
ren  ER74428  hea2019

foreach v of varlist hea*{
codebook `v',ta(10000)
replace `v'=. if `v'>5
revrs `v', replace
}



d ER47318
lookfor "SEX OF HEAD" "SEX OF REFERENCE PERSON"
ren  ER42018  male2009
ren  ER47318  male2011
ren  ER53018  male2013
ren  ER60018  male2015
ren  ER66018  male2017
ren  ER72018  male2019

foreach v of varlist male*{
codebook `v',ta(10000)
replace `v'=0 if `v'==2
//revrs `v', replace
}


d ER53023
lookfor "HEAD MARITAL STATUS" "REFERENCE PERSON MARITAL STATUS"
ren  ER42023  mar2009
ren  ER47323  mar2011
ren  ER53023  mar2013
ren  ER60024  mar2015
ren  ER66024  mar2017
ren  ER72024  mar2019

foreach v of varlist mar*{
codebook `v',ta(10000)
replace `v'=. if `v'==9
replace `v'=0 if `v'>1 &`v'<6
}


ren ER46975A urb2009
ren ER52399A urb2011
ren ER58216  urb2013

foreach v of varlist urb*{
ta `v'
replace `v'=. if `v'==99
}

ren ER65452 met2015
ren ER71531 met2017
ren ER77592 met2019

/*
ER77592 "METRO/NONMETRO INDICATOR" NUM(1.0)
Metropolitan/Non-metropolitan Indicator

This indicator is derived from the 2013 Beale-Ross Rural-Urban Continuum Codes published
by USDA based on matches to the FIPS state and county codes.

1 Metropolitan area (Beale-Ross Code ER775923= 1-3)
2 Non-metropolitan area (Beale-Ross Code ER775923= 4-9)
*/

codebook urb2013 , ta(100)
codebook met2015 

recode  urb2009 (0=0)(1/3=1)(4/9=2), gen(met2009)
recode  urb2011 (0=0)(1/3=1)(4/9=2), gen(met2011)
recode  urb2013 (0=0)(1/3=1)(4/9=2), gen(met2013)

foreach v of varlist met*{
replace `v'=. if `v'==0
replace `v'=0 if `v'==2
}

lookfor "1968 FAMILY IDENTIFIER"
ren  ER42009  fid1968_2009
ren  ER47309  fid1968_2011
ren  ER53009  fid1968_2013
ren  ER60009  fid1968_2015
ren  ER66009  fid1968_2017
ren  ER72009  fid1968_2019

l fid* in 1/100
ta fid1968_2019

d ER46697
lookfor "WHO WAS RESPONDENT"
ren  ER46697 res2009
ren  ER52097 res2011
ren  ER57901 res2013
ren  ER65081 res2015
ren  ER71164 res2017
ren  ER77186 res2019

lookfor "FAMILY INTERVIEW"
l ER42002 in 1/100

lookfor "# IN FU"
ren ER42016  nFU2009
ren ER47316	 nFU2011
ren ER53016	 nFU2013
ren ER60016	 nFU2015
ren ER66016	 nFU2017
ren ER72016	 nFU2019


lookfor "CURRENT STATE"

ren ER42004 sFIPS2009
ren ER47304 sFIPS2011
ren ER53004 sFIPS2013
ren ER60004 sFIPS2015
ren ER66004 sFIPS2017
ren ER72004 sFIPS2019
  
//!!!!right so this is only for head so far!!!! if want wife/spouse/partner (also on swb), then i guess need to replace a bunch of vars with value for wife/spouse/partner guess depending on who is respondent (res variable)
//and remember that res may be in each wave different lol so keep after reshape
l res* in 1/100,nola

gen WB16YRID=ER60002 
save raw-psid2,replace

use  raw-psid2, clear
keep WB16YRID car1Pri* tra* clo* lat* rac* age* swb* k* rle* inc* emp* ind* kid* col* hea* male* mar* urb* met* fid* res* nFU* sFIPS* 

gen id=_n
reshape long  car1Pri tra clo lat rac age swb k rle inc emp ind kid col hea male mar urb met fid1968_ nFU res sFIPS,i(id)j(yr)


la var car1Pri "total price of 1st car"



la var tra "FU total transportation expenditure"

note tra: Total Family Transportation Expenditure, including vehicle loan payment, vehicle down payment, vehicle lease payment, insurance, other vehicle expenditures, repairs and maintenance, gasoline, parking and carpool, bus and train fares, taxicabs, and other transportation costs. Missing values are imputed. Imputation may result in negative values due to linear regression model. These negative values are kept in order to preserve population mean consistent with the estimation.

la var clo "FU clothing expenditure in previous year"
note clo: "How much did you (and your family living there) spend altogether in 2018 on clothing and apparel, including footwear, outerwear, and products such as watches or jewelry?" Missing values are imputed. Imputation may result in negative values due to linear regression model. These negative values are kept in order to preserve population mean consistent with the estimation.


recode rac (2/8=0)(9=.),gen(whi)
la var whi "white"
note whi: "What is (your/his/her) race? (Are you/Is [he/she]) white, black, American Indian, Alaska Native, Asian, Native Hawaiian or other Pacific Islander?--FIRST MENTION" 1='white', 0 otherwhise

recode rac (1=1 "white")(2=2 "black")(4=4 "asian")(5=5 "latino")(7 5 =3 "other"),gen(_rac)
replace _rac=5 if lat==1
drop rac
ren _rac rac

codebook rac 
ta rac,gen(R)
d R*
la var R2 "black"
la var R3 "other"
la var R4 "asian"
la var R5 "latino"


la var swb "swb"
note swb: "Please think about your life as a whole. How satisfied are you with it? Are you completely satisfied, very satisfied, somewhat satisfied, not very satisfied, or not at all satisfied?" 1 (lo) - 5 (hi)

la def _met 0 "nonmetro" 1 "metro"
la val met _met
la var met "metro"
note met: "Metropolitan/Non-metropolitan Indicator. This indicator is derived from the 2013 Beale-Ross Rural-Urban Continuum Codes published by USDA based on matches to the FIPS state and county codes." 1 Metropolitan area (Beale-Ross Code ER775923= 1-3) 0 Non-metropolitan area (Beale-Ross Code ER775923= 4-9) 

//ta urb,gen(U)
codebook emp
recode emp (1=1 "working")(2=2 "temp not working")(3=3 "unemployed")(4=4 "retired")(5=5 "disabled")(6=6 "housekeeping")(7=7 "student")(8=8 "other"), gen(_emp)
drop emp
ren _emp emp
ta emp, gen(E)
d E*
la var E2 "temp not working"
la var E3 "unemployed"
la var E4 "retired"
la var E5 "disabled"
la var E6 "housekeeping"
la var E7 "student"
la var E8 "other"

codebook emp, ta(100)
recode emp (3=1)(1 2 4 5 6 7 8=0)(99=.), gen(une)
la var une "unemployed"
note une:  EMPLOYMENT STATUS-1ST MENTION; We would like to know about what you do -- are you working now, looking for work, retired, keeping house, a student, or what?--FIRST MENTION; 1="Looking for work, unemployed", 0 otherwhise


gen age2=age^2

la var age "age"
note age: age

la var age2 "age sq"
note age2: age squared
la var mar "married"
note mar: "Are you married, widowed, divorced, separated, or have you never been married?"  1='married'; 0 otherwhise

la var k "distress"
note k: The K-6 Non-Specific Psychological Distress Scale

la var rle "restless"
note rle:  "(In the past 30 days, about how often did you feel...) Restless or fidgety? (Would you say all of the time, most of the time, some of the time, a little of the time, or none of the time?)" 1 (lo) - 5 (hi)

la var inc "last year total family income"
note inc: last year total family income

la var ind "industry"
note ind: What kind of business or industry (is/was) that in?--CURRENT OR MOST RECENT MAIN JOB
//ta ind,gen(I) //TODO make sure they make sense and drop missing

la var kid kids
note kid: "Number of Persons Now in the FU Under 18 Years of Age"

la var col "college"
note col: "Did (you/he/she) attend college?" 1='yes', 0='no'
la def _col 0 "no" 1 "yes"
la val col _col

la var hea "health"
note hea:  "Now I have a few questions about your health. Would you say your health in general is excellent, very good, good, fair, or poor?" 1 (poor) to 5 (excellent)

la var male "male"
note male: gender

la var nFU "family unit size"
note nFU: Number of Persons in FU at the Time of the  Interview

la var rac "race"
note rac: "What is (your/his/her) race? (Are/Is) (you/he/she) white, black, American Indian, Alaska Native, Asian, Native Hawaiian or other Pacific Islander?--FIRST MENTION" NOTE: "latino" category derived from ER64809: " In order to get an idea of the different races and ethnic groups that participate in the study, I would like to ask you about (your/your spouse's/[HEAD]'s) background. (Are/Is) (you/he/she) Spanish, Hispanic, or Latino? That is, Mexican, Mexican American, Chicano, Puerto Rican, Cuban, or other Spanish?"

la var emp "employment status"
note emp: "We would like to know about what (you/HEAD) (do/does) -- (are/is) (you/HEAD) working now, looking for work, retired, keeping house, a student, or what?--FIRST MENTION"

//TODO yeah should not use it untill fix it
//drop ind //see above for explanatoins


keep if res==1
save psid,replace //long proper format

keep if yr==2015
save psid15,replace


//LATER: rt, so if doent want just res=1 head, and retain wife, have to reintegrate stuff from below where var is head or wife depending on who responds lol

/*
 
ren ER42017  ageH2009
ren ER47317  ageH2011
ren ER53017  ageH2013
d ageH*
sum ageH*
foreach v of varlist ageH*{
codebook `v', ta(130)
replace `v'=. if `v'==999
}

ren ER42019  ageW2009
ren ER47319  ageW2011
ren ER53019  ageW2013
foreach v of varlist ageW*{
codebook `v', ta(130)
replace `v'=. if `v'==999  
}

ta ageW2013 if fuSiz2013==1 //good, no wife if fu is 1
ta ageW2013 if res2013>1 //goo,d if wife then this cannot be 0!

foreach v of varlist ageW*{
codebook `v', ta(130)
replace `v'=. if `v'==0
}

foreach i in 2009 2011 2013{
gen age`i'=.
replace age`i'=ageH`i' if res`i'==1
replace age`i'=ageW`i' if (res`i'==2|res`i'==3)
la var age`i' "age"
gen age2_`i'=age`i'^2
la var age2_`i' "age sq"
}
drop ageH* ageW*


* hea

ren ER44175  heaH2009
ren ER49494  heaH2011
ren ER55244  heaH2013
d heaH*
sum heaH*
foreach v of varlist heaH*{
codebook `v',ta(100)
replace `v'=. if `v'==9
revrs `v', replace
}
l heaH* in 1/100


ren ER45272  heaW2009
ren ER50612  heaW2011
ren ER56360  heaW2013
d heaW*
sum heaW*
foreach v of varlist heaW*{
codebook `v',ta(100)
replace `v'=. if `v'==9 
}

l res* heaH* in 1/100, nola
l res* heaW* in 1/100, nola
l f68ID* heaW* in 1/4, nola

l res2013 fuSiz2013 heaH2013 heaW2013 in 1/100, nola
l res2013 fuSiz2013 heaH2013 heaW2013 in 1/1000 if heaW2013!=., nola //fuSiz must be >1 if heaW is nonmissing

l res* hea* in 1/4, nola

ta  heaH2013 if res2013==1
ta  heaH2013 if res2013==2

ta  heaH2013 if (res2013==2 & fuSiz2013==1) //so wife talks about head


ta  heaW2013 if res2013==1 //ok, wife means the other person, not head
ta  heaW2013 if res2013==2


foreach v of varlist heaW*{
replace `v'=. if `v'==0  //0 is if not wife
revrs `v', replace
}

foreach v of varlist res*{
codebook `v',ta(100)
}

foreach i in 2009 2011 2013{
gen hea`i' = .
replace hea`i' = heaH`i' if res`i'==1
replace hea`i' = heaW`i' if res`i'==2 | res`i'==3
la var hea`i' "health"
note hea`i': "Now I have a few questions about your health. Would you say your health in general is excellent, very good, good, fair, or poor?"
}

l res2013 hea*2013 in 1/100, nola

drop heaH* heaW*


*** wellbeing

*swb

ren ER42024  swb2009
ren ER47324  swb2011
ren ER53024  swb2013
d swb*
sum swb*
foreach v of varlist swb*{
codebook `v', ta(100)
}
foreach v of varlist swb*{
replace `v' =. if inlist(`v',0, 8, 9)
revrs `v', replace
la var `v' "happiness"
note `v': "Please think about your life as a whole. How satisfied are you with it? Are you completely satisfied, very satisfied, somewhat satisfied, not very satisfied, or not at all satisfied?"
}
l swb* in 1/100 //ok makes sense too


*** size of a place

* siz

//get years from n.org
ren  ER16431C  siz1999
ren  ER20377C 	siz2001
ren  ER24144A 	siz2003
ren  ER28043A 	siz2005
ren  ER41033A 	siz2007
ren  ER46975A 	siz2009
ren  ER52399A 	siz2011
ren  ER58216  	siz2013

d siz* //first make sure they all have same name
l siz*   in 1/3 //so good!!

//checking if comparable over time; in general may need to do that; but if have just few yrs, then i guess fine
sum siz*

foreach v of varlist siz*{
codebook `v', ta(100)
}

foreach v of varlist siz*{
replace `v'= . if `v'==99 | `v'==0
revrs `v', replace
}


* grSi

//ok mostly checks out :) guess can take avg or sth 
l ER46537 ER51898 ER57653 in 1/100

ren ER46537  grSiH2009
ren ER51898  grSiH2011
ren ER57653  grSiH2013
d grSiH*
sum grSiH*
foreach v of varlist grSiH*{
codebook `v', ta(100)
replace `v'= . if `v'==4 | `v'==9 //many ppl said other=4
}


ren ER46443  grSiW2009
ren ER51804  grSiW2011
ren ER57543  grSiW2013
d grSiW*
sum grSiW*

//cross check, makes sense
ta grSiW2013 if res2013==1
ta grSiW2013 if res2013==3

foreach v of varlist grSiW*{
codebook `v', ta(100)
replace `v'= . if `v'==4 | `v'==9 |`v'==0 //many ppl said other=4
}

label define lala 1 "rural" 2 "small town, suburb" 3 "city" 
foreach i in 2009 2011 2013{
gen grSi`i'=.
replace grSi`i'=grSiH`i' if res`i'==1
replace grSi`i'=grSiW`i' if (res`i'==2|res`i'==3)
la val grSi`i' lala
}
drop grSiH* grSiW*


*** sociodemographics


* famInc
//LATER may need to adj for inflation; especially if more years!

ren ER46935  famInc2009
ren ER52343  famInc2011
ren ER58152  famInc2013
d famInc*
sum famInc*  //neg is fine
//no tabulate/codebbok--too many vals
l famInc* in 1/100 //makes sense, so much inequality!
foreach v of varlist famInc*{
la var `v' "family income"
note `v': "The income reported here was collected in [this year] about tax year [previous]. Please note that this variable can contain negative values. Negative values indicate a net loss, which in waves prior to 1994 were bottom-coded at USD 1, as were zero amounts. These losses occur as a result of business or farm losses."
}
/* note: it has many cool components This variable is the sum of these seven variables FAM2011ER*/
/* ER52259 Head and Wife/"Wife" Taxable Income-2010 */
/* ER52308 Head and Wife/"Wife" Transfer Income-2010 */
/* ER52315 Taxable Income of Other FU Members-2010 */
/* ER52336 Transfer Income of OFUMS-2010 */
/* ER52337 Head Social Security Income-2010 */
/* ER52339 Wife/"Wife" Social Security Income-2010 */
/* ER52341 OFUM Social Security Income-2010 */


*kids

ren ER42020  kids2009
ren ER47320  kids2011
ren ER53020  kids2013
d kids*
sum kids*
foreach v of varlist kids*{
codebook `v',ta(100)
la var `v' "number of children in household"
note `v': "This variable represents the actual number of persons currently in the FU who are neither Head nor Wife, from newborns through those 17 years of age, whether or not they are actually children of the Head or Wife."
}
l kids* in 1/100, nola


* emp

ren ER42140  empH2009
ren ER47448  empH2011
ren ER53148  empH2013
d empH*
sum empH*
foreach v of varlist empH*{
codebook `v', ta(100)
replace `v'=. if `v'==99
}

ren ER42392  empW2009
ren ER47705  empW2011
ren ER53411  empW2013
d empW*
sum empW*
foreach v of varlist empW*{
codebook `v', ta(100)
replace `v'=. if `v'==99 | `v'==0
}
//way more wifes keep house than heads--makes sense!!


foreach i in 2009 2011 2013{
gen emp`i'=.
replace emp`i'=empH`i' if res`i'==1
replace emp`i'=empW`i' if (res`i'==2|res`i'==3)
recode emp`i' (3=1)(1 2 4 5 6 7 8=0),gen(empUne`i')
la var empUne`i' "unemployed"
}
drop empH* empW*

//TODO after few weeks need to look at it again with fresh eye and look at codebooks AND questionairess--questionaires have that questions order taht may be important 

* rac

ren ER46543 racH2009 
ren ER51904 racH2011 
ren ER57659 racH2013 
d racH*
sum racH*
foreach v of varlist racH*{
codebook `v', ta(100)
replace `v'=. if `v'==9 
}

				 	  
ren ER46449 racW2009 
ren ER51810 racW2011 
ren ER57549 racW2013 
d racW*
sum racW*
foreach v of varlist racW*{
codebook `v', ta(100)
replace `v'=. if `v'==9 | `v'==0
}

foreach i in 2009 2011 2013{
gen rac`i'=.
replace rac`i'=racH`i' if res`i'==1
replace rac`i'=racW`i' if (res`i'==2|res`i'==3)
recode rac`i' (1=1)(2 3 4 5 7=0),gen(whi`i')
la var whi`i' "white"
}
drop racH* racW*

ta  rac2009 whi2013, mi
ta  rac2013 whi2013, mi



* col, college (education) 

ren ER46563 colH2009
ren ER51924 colH2011
ren ER57680 colH2013
d colH*
sum colH*

foreach v of varlist colH*{
codebook `v', ta(100)
replace `v'=. if  `v'==0 | `v'==9
replace `v'=0 if  `v'==5
}

ren ER46469 colW2009 
ren ER51830 colW2011 
ren ER57570 colW2013 
d colW*
sum colW*

foreach v of varlist colW*{
codebook `v', ta(100)
replace `v'=. if  `v'==0 | `v'==9
replace `v'=0 if  `v'==5
}

foreach i in 2009 2011 2013{
gen col`i'=.
replace col`i'=colH`i' if res`i'==1
replace col`i'=colW`i' if (res`i'==2|res`i'==3)
}
drop colH* colW*

ta  col2009 col2013, mi //funny how unstable it is; and remmeber that there are missing cases for fixed vars--can fill in nissings based on other years--if a person had college at n, she must have ut at n+1; not necessarily the other way round


*** OTHER

cd /home/aok/data/psid/cartsApproach/


* simplify

keep *9 *1 *3 *5 *7 
drop hhID* stFIPS*

save psidWide, replace

gen id=_n
reshape long f68ID fuSiz kids  emp empUne res famInc siz mar marMar age age2_ hea swb grSi rac whi col, i(id)j(year)

ta year
save psid, replace


*******************************************************************************

********************************************************************************
*** //LATER MAYBE from FAM2011ER


recode ER47318 (1=1)(2=0), gen(male)  //BUG  what if a reponednt is not head! //BUG  a problem--way more males--well bc they are heads of hh, so need to make sure all other vars are for head, incl happines!
la var male "male"

note  male: "sex of head"

lookfor educ //bummer looks like no educ; guess in some supplelemt--must bne somewhere! but it aint critical anyway


** house, energy

ren ER47417 ele_exp //LATER hmm lots of zeros here
replace ele_exp=. if ele_exp==8800 | ele_exp==9998 | ele_exp==9999
replace ele_exp=ele_exp/1000
la var ele_exp "electricity expense, \\\$1,000"


lookfor value //there is also accuracy of house value... LATER
ren ER47330 hou_val
replace hou_val = . if hou_val==9000000 | hou_val==9999998 | hou_val == 9999999

ren ER47329 own_ren_oth //1 own 5 rent 8 other
recode own_ren_oth (1=1)(nonm=0), gen(own)
recode own_ren_oth (5=1)(nonm=0), gen(rent)
recode own_ren_oth (8=1)(nonm=0), gen(other)
la var own "own a dwelling"
la var rent "rent a dwelling"
la var other "other than own/rent a dwelling"

la var own_ren_oth "own a dwelling OR rent a dwelling OR other than own/rent a
 dwelling"
note own_ren_oth: "Do (you (or anyone else in your family living there) / they (or anyone else in the family living there)) own the (apartment/mobile home/home), pay rent, or what?"


ren ER47328 rooms
replace rooms =. if rooms==98 | rooms==99

/* LATER then scale it by price in that county or state etc.. */
/* can also calc sq ft based on other vars--there were some papers doing */
/* it just goog psid and sq ft */


*/
