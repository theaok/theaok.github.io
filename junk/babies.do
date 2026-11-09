
do /home/aok/papers/root/do/aok_programs.do

use "/home/aok/data/caliBrando/18-22/Panel 2018-2022.dta", clear
cd ~/papers/root/rr/babies/tex

ren P01000801 yr
ta yr //lina: 2021 2.7k obs and 2020 missing???
encode yr,gen(yrN)

//------------------------------baby variables

lookfor hijo

codebook P05000201
ren P05000201 baby
recode baby (0=0 "No")(1=1 "Yes"), gen(_baby) 
drop baby
ren _baby baby
la var baby "parent"
note baby: "Do you have children?"

ta P05000202
recode P05000202 (5/50 = 5), gen(babyNum)
ta P05000202 babyNum

ren P05000203 babyBorn
la var babyBorn "Age at which first child was born"

ren P05000205 babyPlan
la var babyPlan "Planned first child"

ren P05000206 babyFut
la var  babyFut "Planning for future children"

//skip just 45 yes and only 2k nonmissing
//P07000501  Asegura vejez con los hijos Ensures old age with children

//skipta P13001601 no obs

//---------from domains

ren P11000101 family
ren P11000103 relationship
d relationship
la var relationship "relationship satisfaction"
note relationship: "How satisfied are you with the following aspects of your life?" relationship

//--------------from lina commute dofile-------------
codebook P02001201
recode P02001201 (1=1 "white")(2=2 "half blood")(3=3 "indigenous")(4=4 "black")(5=5 "other")(6=6 "none"),gen(etnia)
la var etnia "race"
note etnia: white, half blood, indigenous, black, or other

lookfor educativo
codebook P02001401
recode   P02001401  (1=1 "primary")(2=2 "secondary")(3=3 "technical")(4=4 "professional")(5=5 "postgraduate")(9=0 "none"),gen(niveleducativo)
la var niveleducativo "education"
note niveleducativo:  primary, secondary, technical, professional, postgraduate, or none

lookfor satisfaccion
codebook P03000101, ta(100)
ren P03000101 satisfaccionvida
la var satisfaccionvida "life satisfaction"
note satisfaccionvida: "In general, how satisfied are you with all aspects of your life?"


/* lATER MAYBE
codebook feliz, ta(100)
la var feliz "happy"
corr satisfaccionvida feliz //only .4

codebook preocupado, ta(100)
la var preocupado "worried"
note preocupado: "How worried/concerned?"

codebook deprimido, ta(100)
la var deprimido "depressed"
note deprimido: "How depressed?"
*/

codebook P10000201
recode P10000201 (1=5 "excellent")(2=4 "very good")(3=3 "good")(4=2 "regular")(5=1 "bad"), gen(salud)
ta salud P10000201, mi nola
la var salud "health condition"
#note salud: "Usted diria que, en general, su salud es (CDC 5)"
note salud: "Would you say that, in general, your health is"


lookfor sexo
codebook P02000701
recode P02000701 (1=0 "male")(2=1 "female")(3=.), gen(mujer)
la var mujer "female"
note mujer: female

lookfor estado
codebook P02000301
recode P02000301(1=1 "married")(2=2 "free union")(3=3 "separated/widowed")(4=4 "single")(5=5 "widow"), gen(estadocivil)
la var estadocivil "marital status" 
note estadocivil: "What is your marital status?"

recode estadocivil (1 2 = 1 "married/free union")(3 5 = 2 "separated/widowed")(4=0 "single"),gen(est3)
la var est3 "marital status" 
note est3: "What is your marital status?"
ta est3 estado,mi

codebook P02000801 
ren P02000801 estrato
la var estrato "socio-economic strata"
note estrato: "What is the socio-economic strata of your home?" 
//1-5 (strata 5 and 6 were combined together as there were very few respondents living in strata 6)
//replace estrato=5 if estrato==6

ren P02000601 comuna
la var comuna "neighborhood"
note comuna: "What neighborhood do you live in?"

lookfor hogar
ren P02000201 posicionhogar
codebook posicionhogar
note posicionhogar: "position in the household: head, child, etc"

lookfor personas
ren P05000301 personashogar
codebook personashogar, ta(100)
la var personashogar "household size"
note personashogar: household size

ren P08000101 tipovivienda
codebook tipovivienda
la var tipovivienda "household size"
note tipovivienda: "Type of house" 

lookfor condicionhogar
ren P07000901 condicionhogar
codebook condicionhogar, ta(100)
la var condicionhogar "house condition"
note condicionhogar: "On a scale of one to ten, where 1 is the worst and 10 the best, what's the condition of  your home?"

lookfor ingresos
recode P07000101 (6=0 "no income")(1=1 "lt 1 SMMLV")(2=2 "1-2 SMMLV")(3=3 "2-4 SMMLV")(4=4 "4-8 SMMLV")(5=5 "gt 8 SMMLV"),gen(promedioingresos)
codebook promedioingresos
replace promedioingresos=. if promedioingresos==7
la var promedioingresos "income"
note promedioingresos: "How much on average income?"

codebook P11000106
ren P11000106 incSat

lookfor edad 
ren Edad edad 
gen edad2=edad^2

la var edad "age"
note edad: age 

la var edad2 "age squared"
note edad2: age squared 

codebook P12001102 
ren P12001102 seguro
codebook seguro, ta(100)
la var seguro "safe in city"
note seguro: "You feel your neighborhood is safe?"

ren P12001101 seguroP
la var seguroP "Percepcion de seguridad" 
//victimausted Over the past year, have you or any member of your household been the victim of robbery, murder, kidnapping, physical violence, sexual violence, psychological violence or extortion?
//victimafamiliar Over the past year, have you or any member of your household been the victim of robbery, murder, kidnapping, physical violence, sexual violence, psychological violence or extortion?

ren P02001501 barrio


ren P10001002 deprimido
ren P10000803 estresado
ren P10000901 ansioso
alpha estresado  ansioso  deprimido, gen(men) 

//------------------------new vars TODO add to root/generic dofile-------------

lookfor ahorro
sum P07000201 P07000502 P18000101
ren P18000101 ahorrosBanco
la var ahorrosBanco "have active savings account"
note ahorrosBanco: "Tenencia de cuenta de ahorros activa" "Active savings account holding" 

ren P07000502 ahorrosViejo
la var ahorrosViejo "enough savings for the rest of life"
note ahorrosViejo: "Tenencia de cuenta de ahorros activa" "Ensure old age with savings"

ren P07000201 ahorros3mes
replace ahorros3mes=0 if ahorros3mes==2
la var ahorros3mes "3mo savings"
note ahorros3mes: "Tenencia de ahorros para vivir al menos tres meses" "Savings to live on for at least three months"

d P04000204 P04000205 //own bicycle car
sum P04000204 P04000205

ren P09000401 standard
codebook standard
replace standard=0 if standard==2
la var standard "standard"
note standard: "Are you satisfied with your standard of living? That is, with all the things you can buy and do"
//"Usted esta satisfecho con su estandar de vida? Es decir, con todas las cosas que puede comprar y hacer (GWP)"

ren P09000101 pobre
codebook pobre
replace pobre=0 if pobre==2
la var pobre "poor"
note pobre:  "Could you tell me if you consider yourself financially poor?" 
//"Podria decirme si usted se considera economicamente pobre?"

//--------------calc

ta edad
xtile qEdad = edad ,nq(5)
ta edad qEdad

gen babyAge=edad-babyBorn
ta babyAge baby, mi //weird!!! BUG negative val: people report baby was born at higher age than they have now , ie in the future

recode promedioingresos (0 1 =0 "none or lt min wage")(2 3 4 5=1 "min wage or more"),gen(incGood)
codebook incGood
la var incGood "min wage or more"


ta  babyBorn baby,mi
cap drop qbabyBorn
xtile qbabyBorn = babyBorn, nq(5)
ta  babyBorn qbabyBorn

replace qbabyBorn = 1  if  babyBorn<20
replace qbabyBorn = 2  if  babyBorn>19 & babyBorn<25
replace qbabyBorn = 3  if  babyBorn>24 & babyBorn<30
replace qbabyBorn = 4  if  babyBorn>29 & babyBorn<35
replace qbabyBorn = 5  if  babyBorn>34 & babyBorn<99
ta  babyBorn qbabyBorn

codebook qbabyBorn

xtile qAge = edad, nq(5)
la var qAge "5 quantiles of age"

gen babyAgeB=edad-babyBorn
corr babyAgeB babyAge
drop babyAgeB

//like 10obs with neg turned to 0
replace babyAge=0 if babyAge<0

xtile qBabyAge = babyAge, nq(5)
ta *abyAge





//-----------------------des sta

//dont see:
//actual dollar income
d promedioingresos
//whats tetriary: technical + professional + postgraduate
d niveleducativo 
//formal job: mostly missing
d   P06000801  P06000802 P06000803
sum P06000801  P06000802 P06000803
//ahorros/savings missing for at least 50perc


//d satisfaccionvida promedioingresos niveleducativo estrato ahorros3mes standard pobre edad mujer salud personashogar seguro estado IMC
//aok_var_des, ff(satisfaccionvida promedioingresos niveleducativo estrato ahorros3mes standard pobre edad mujer salud personashogar seguro est3 IMC)fname(varDes.tex)

d satisfaccionvida baby mujer edad salud estrato personashogar  standard niveleducativo est3 seguro promedioingresos relationship
aok_var_des , ff(satisfaccionvida baby mujer edad salud estrato personashogar  standard niveleducativo est3 promedioingresos pobre relationship)fname(/home/aok/papers/babies/tex/varDes.tex)

tabstat standard pobre, by(baby) format(%9.2f) //columns(variables)

//graph hbar standard pobre qEdad, over(baby)
dtable satisfaccionvida i.promedioingresos i.niveleducativo i.estrato pobre standard  edad mujer salud personashogar i.est3 , by(baby, nototals) continuous(, statistics(mean)) nformat(%9.2f mean) export("/tmp/a", as(html) replace) //IMC ahorros3mes
! firefox-bin /tmp/a.html


graph bar satisfaccionvida, over(baby)over(mujer)
graph bar men, over(baby)over(mujer) //with baby less mental problems; fem more than male in general

pwcorr estresado  ansioso  deprimido mujer baby, star(0.05)


pwcorr satisfaccionvida baby  relationship  mujer  edad niveleducativo  salud estrato personashogar seguro  , star(0.05)
matrix list r(C), format(%4.2f)


//-----------------------playing


reg satisfaccionvida baby i.yrN, robust

reg satisfaccionvida baby i.yrN if mujer==0 , robust //aha males happier with babies

reg satisfaccionvida baby mujer i.yrN,robust

reg satisfaccionvida baby##mujer i.yrN,robust
margins baby,by(mujer)
//margins mujer,by(baby)
marginsplot
gr export mp1.pdf, replace

//ok promedioingresos kills interaction
reg satisfaccionvida baby##mujer edad edad2  i.promedioingresos  i.yrN,robust

reg satisfaccionvida baby mujer edad edad2 salud   i.yrN,robust

reg satisfaccionvida baby##mujer edad edad2 salud i.estrato  i.yrN,robust


reg satisfaccionvida baby mujer edad edad2 i.estrato i.personashogar i.yrN,robust


reg satisfaccionvida baby##mujer edad edad2 salud i.estrato i.personashogar seguro i.yrN,robust

reg satisfaccionvida baby##mujer edad edad2 salud i.estrato i.personashogar seguro i.promedioingresos i.yrN,robust

estout a* using regA.tex, cells(b(star fmt(%9.2f))) replace style(tex) collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) drop(*yrN) 

reg satisfaccionvida baby##mujer edad edad2 salud i.estrato i.personashogar seguro i.yrN if promedioingresos<2,robust
reg satisfaccionvida baby##mujer edad edad2 salud i.estrato i.personashogar seguro i.yrN if promedioingresos>1,robust

reg satisfaccionvida baby##mujer edad edad2 salud i.estrato i.personashogar seguro i.yrN if promedioingresos>1,robust


//ok so more income more baby happiness
reg satisfaccionvida baby##promedioingresos i.mujer edad edad2 salud i.estrato i.personashogar seguro   i.yrN,robust
reg satisfaccionvida baby##incGood i.mujer edad edad2 salud i.estrato i.personashogar seguro   i.yrN,robust //yes!!!
est sto b1
margins baby,by(incGood)
marginsplot
gr export mp2.pdf, replace


reg satisfaccionvida baby##c.incSat i.mujer edad edad2 salud i.estrato i.personashogar seguro   i.yrN,robust


reg satisfaccionvida baby##mujer##incGood edad edad2 salud i.estrato i.personashogar seguro i.yrN ,robust //yes!!!
est sto b2
margins baby#mujer#incGood
marginsplot
gr export mp3.pdf, replace

cap est drop b4
estout b* using regB.tex, cells(b(star fmt(%9.2f))) replace style(tex) collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) //drop(*cc *yr *rel_den) 

i.etnia i.estadocivil i.niveleducativo 
`v' barriocrimen barriobaldio barriopolicia  barrioseguro seguro satisfaccionsalud i.comuna i.estrato, robust



//--------------babyBorn




reg satisfaccionvida i.qbabyBorn i.yrN, robust //yeah makes sense
est sto c1

reg satisfaccionvida i.qbabyBorn mujer i.yrN,robust
est sto c2

reg satisfaccionvida i.qbabyBorn mujer edad edad2 salud   i.yrN,robust
est sto c3

reg satisfaccionvida i.qbabyBorn mujer edad edad2 salud i.promedioingresos  i.yrN,robust //killed sig
est sto c4

reg satisfaccionvida i.qbabyBorn mujer  edad edad2 personashogar promedioingresos  pobre standard niveleducativo salud estrato i.yrN, robust
est sto c4
reg satisfaccionvida i.qbabyBorn mujer  edad edad2 personashogar promedioingresos  pobre standard niveleducativo salud estrato i.est3 i.yrN, robust
est sto c5

estout c* using regC.tex, cells(b(star fmt(%9.2f))) replace style(tex) collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) drop(*yrN) 

reg satisfaccionvida i.qbabyBorn##i.incGood mujer edad edad2 salud i.yrN,robust //good income matters for ppl in early 30s
est sto a5
margins incGood, at(qbabyBorn=(1(1)5))
marginsplot
gr export mp4.pdf, replace


reg satisfaccionvida i.qbabyBorn##i.incGood mujer  edad edad2 personashogar  niveleducativo salud  i.yrN, robust
margins incGood, at(qbabyBorn=(1(1)5))
marginsplot


//estrato
reg satisfaccionvida i.qbabyBorn edad edad2 salud i.estrato  i.yrN,robust //killed sig
recode estrato (1 2 =0)(3 4 5 6=1),gen(estGood)
reg satisfaccionvida i.estGood##i.qbabyBorn edad edad2 salud  i.yrN,robust //nothing here



//------------paper regressions
est drop a*
reg satisfaccionvida baby i.yrN, robust
est sto a1
reg satisfaccionvida baby mujer  edad edad2 personashogar i.yrN, robust
est sto a2
reg satisfaccionvida baby mujer  edad edad2 personashogar promedioingresos  pobre standard estrato i.yrN, robust
est sto a3
reg satisfaccionvida baby mujer  edad edad2 personashogar promedioingresos  pobre standard niveleducativo salud estrato i.yrN, robust
est sto a4
reg satisfaccionvida baby mujer  edad edad2 personashogar promedioingresos  pobre standard niveleducativo salud estrato i.est3 i.yrN, robust
est sto a5
reg satisfaccionvida baby mujer  edad edad2  standard niveleducativo  salud estrato personashogar promedioingresos  pobre i.yrN if e(sample)==1, robust //ok so indeed most of it is the est3 control, not only sample explains it (to lesser degree), so indeed much of baby positive effect is due to partner
est sto a5a
//but then if measuring marital status/partenr as satisfaction with relationship, baby is significant 
reg satisfaccionvida baby mujer  edad edad2 standard  niveleducativo salud estrato  personashogar promedioingresos  pobre relationship i.yrN, robust //effect size decent
est sto a6

reg satisfaccionvida i.baby##i.est3 mujer  edad edad2 promedioingresos  pobre standard niveleducativo personashogar salud estrato  i.yrN, robust
margins baby#est3
marginsplot
gr export mAA.pdf, replace

ta est3 baby //very small cell size separated/widowed and no baby: 13, cant use this!!
ta est3 baby, col //yes
table baby est3, nformat(%5.2f) stat(mean satisfaccionvida)   stat(freq) nformat(%9.0g)
table ( baby ) ( est3 ) (), statistic(mean satisfaccionvida) statistic(frequency) statistic(percent) nformat(%9.1f mean) nformat(%9.0g frequency) nformat(%9.0f percent)

estout a* using regAA.tex, cells(b(star fmt(%9.2f))) replace style(tex) collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) drop(*yrN)
!sed -i '/^single/i\\\hspace{-.1in}{\\bf marital status:} \& \& \&\& \& \& \& \\\\' regAA.tex
!sed -i  '/^single/d' regAA.tex 
 
 
//and with income and gender inteactions 
reg satisfaccionvida baby mujer  edad edad2 personashogar promedioingresos  pobre standard niveleducativo salud estrato i.yrN, robust
est sto a4
//seguro
reg satisfaccionvida i.baby##i.incGood mujer  edad edad2  niveleducativo salud estrato personashogar i.yrN, robust //
est sto b1
margins baby#incGood
marginsplot,title("Predicted happiness with 95% CI")text(8 .9 "<min wage")text(8.55 .9 ">=min wage")legend(off)
//nil benefit from baby (blue line) unless decent income, abouve 1smmlv (red)
gr export mB1.pdf, replace

 

reg satisfaccionvida i.baby##i.mujer edad edad2 niveleducativo salud estrato  personashogar i.yrN, robust
est sto b2
margins baby#mujer
marginsplot,title("Predicted happiness with 95% CI")text(8.1 .1 "male")text(8.25 .1 "female")legend(off)
gr export mB2.pdf, replace


reg satisfaccionvida i.baby##i.mujer#i.incGood edad edad2 niveleducativo salud estrato  personashogar i.yrN, robust
est sto b3
margins baby#mujer#incGood
marginsplot,title("Predicted happiness with 95% CI")text(7.84 .83 "male <min wage")text(8.56 .83 "male >=min wage")text(8.35 .83 "female >=min wage")text(8.15 .83 "female <min wage")legend(off)
gr export mB3.pdf, replace


estout a4 b1 b2 b3 using regBB.tex, cells(b(star fmt(%9.3f))) replace style(tex) collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) drop(*yrN)
//edited by hand dropped lines that are base cases 
//too much editing just put in appendix
/*
!sed -i  '/^No   /d' regBB.tex
!sed -i '/^socio-economic strata/a\\\hspace{-.1in}{\\bf baby} \& \& \& \& \\\\' regBB.tex
!sed -i  '/^none or lt min wage/d' regBB.tex
!sed -i '/^Yes   /a\\\hspace{-.1in}{\\bf income} \& \& \& \& \\\\' regBB.tex
!sed -i  '/^No \$\\times\$ none or lt/d' regBB.tex
!sed -i '/^gt min wage/a\\\hspace{-.1in}{\\bf income} \& \& \& \& \\\\' regBB.tex
*/


//could play more with relationship and family
reg satisfaccionvida i.baby##i.incGood mujer  edad edad2   i.niveleducativo i.salud i.estrato  i.personashogar seguro   relationship family i.yrN, robust
//it doesnt change the effect size on interatcion! so its smaller sample size
reg satisfaccionvida i.baby##i.incGood mujer  edad edad2   i.niveleducativo i. salud i.estrato  i.personashogar seguro  i.est3 relationship family i.yrN, robust
//margins baby#incGood
//marginsplot
reg satisfaccionvida i.baby##i.incGood mujer  edad edad2   i.niveleducativo i. salud i.estrato  i.personashogar seguro   relationship family i.yrN if e(sample)==1, robust //yay!! its about smaller sample not control for marital status




//meh nada
reg satisfaccionvida i.baby##c.incSat mujer  edad edad2   i.niveleducativo i. salud i.estrato  i.personashogar seguro   i.yrN, robust




//apr2025 adding interaction with age as per vicky/lina: young fem should be less happy with babies
xtile q_age=edad, nq(4)
ta  edad q_age
gen young=.
replace young=1 if edad<25
replace young=0 if edad>=25 & edad<1000


reg satisfaccionvida mujer##baby##young promedioingresos salud i.estrato i.personashogar seguro i.yrN ,robust //
est sto bb
//margins q_age#baby#mujer
margins baby#mujer#young
marginsplot

est drop c*
reg satisfaccionvida i.qbabyBorn i.yrN, robust
est sto c1
reg satisfaccionvida i.qbabyBorn mujer  edad edad2 personashogar i.yrN, robust
est sto c2
reg satisfaccionvida i.qbabyBorn mujer  edad edad2 personashogar promedioingresos i.yrN, robust
est sto c3
reg satisfaccionvida i.qbabyBorn mujer  edad edad2 personashogar   pobre   i.yrN, robust
est sto c3a
reg satisfaccionvida i.qbabyBorn mujer  edad edad2 personashogar   standard   i.yrN, robust
est sto c3b
reg satisfaccionvida i.qbabyBorn mujer  edad edad2 personashogar   estrato   i.yrN, robust
est sto c3c
  
reg satisfaccionvida i.qbabyBorn mujer  edad edad2 personashogar promedioingresos  pobre standard estrato  i.yrN, robust
est sto c4
reg satisfaccionvida i.qbabyBorn mujer  edad edad2 personashogar promedioingresos  pobre standard niveleducativo salud estrato i.est3 i.yrN, robust
est sto c5
/*
reg satisfaccionvida baby mujer  edad edad2  standard niveleducativo  salud estrato personashogar promedioingresos  pobre i.yrN if e(sample)==1, robust //
est sto c5a
*/ 


reg satisfaccionvida i.qbabyBorn##i.incGood mujer  edad edad2 personashogar    niveleducativo salud   i.yrN, robust
margins incGood, at(qbabyBorn=(1(1)5))
marginsplot,title("Predicted happiness with 95% CI")text(8 3.5 "<min wage")text(8.75 3.5 ">=min wage")xtitle("5 quantiles of age when first baby born")legend(off)
gr export mC5.pdf, replace



estout c* using regCC.tex, cells(b(star fmt(%9.2f))) replace style(tex) collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) drop(*yrN)
!sed -i '/5 quantiles of babyBorn=1/i\\\hspace{-.1in}{\\bf baby born:} \& \& \& \&\& \& \& \& \\\\' regCC.tex
!sed -i 's/5 quantiles of babyBorn=1/11-19/g' regCC.tex
!sed -i 's/5 quantiles of babyBorn=2/20-24/g' regCC.tex
!sed -i 's/5 quantiles of babyBorn=3/25-29/g' regCC.tex
!sed -i 's/5 quantiles of babyBorn=4/30-34/g' regCC.tex
!sed -i 's/5 quantiles of babyBorn=5/35-54/g' regCC.tex
!sed -i '/^single/i\\\hspace{-.1in}{\\bf marital status:} \& \& \& \&\& \& \& \& \\\\' regCC.tex
!sed -i  '/^single/d' regCC.tex




est drop d*
reg satisfaccionvida i.babyNum i.yrN, robust
est sto d1
reg satisfaccionvida i.babyNum mujer  edad edad2 personashogar i.yrN, robust
est sto d2
reg satisfaccionvida i.babyNum mujer  edad edad2 personashogar promedioingresos  pobre standard estrato i.yrN, robust
est sto d3
reg satisfaccionvida i.babyNum mujer  edad edad2 personashogar promedioingresos  pobre standard niveleducativo salud estrato i.yrN, robust
est sto d4
reg satisfaccionvida i.babyNum mujer  edad edad2 personashogar promedioingresos  pobre standard niveleducativo salud estrato i.est3 i.yrN, robust
est sto d5
reg satisfaccionvida i.babyNum mujer  edad edad2  standard niveleducativo  salud estrato personashogar promedioingresos  pobre i.yrN if e(sample)==1, robust //ok so indeed most of it is the est3 control, not only sample explains it (to lesser degree), so indeed much of baby positive effect is due to partner
est sto d5a
//but then if measuring marital status/partenr as satisfaction with relationship, baby is significant 
reg satisfaccionvida i.babyNum mujer  edad edad2 standard  niveleducativo salud estrato  personashogar promedioingresos  pobre relationship i.yrN, robust //effect size decent
est sto d6


estout d* using regDD.tex, cells(b(star fmt(%9.2f))) replace style(tex) collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) drop(*yrN)
!sed -i '/^single/i\\\hspace{-.1in}{\\bf marital status:} \& \& \&\& \& \& \& \\\\' regDD.tex
!sed -i  '/^single/d' regDD.tex 







//------------------nov2026 revisions based on larr---------------------------
hist edad,by(baby)
gr export histA.pdf, replace
bys baby: sum edad, det

ta edad qAge
table baby qAge, stat(n satisfac) //nformat(%9.2f)
table baby qAge, stat(mean satisfac) nformat(%9.2f) //to paper
//good news is that its for all age grps same pattern

//guess more important babyAge below
hist edad,by(qbabyBorn)
table qAge qbabyBorn , stat(n satisfac) nformat(%9.2f)
table qAge qbabyBorn , stat(mean satisfac) nformat(%9.2f)

hist babyAge
table qAge qBabyAge , stat(n satisfac) nformat(%9.2f)
table qBabyAge , stat(mean satisfac) nformat(%9.2f)
table qAge baby, stat(mean satisfac) nformat(%9.2f) //to paper (same as the above just diff order!)

//meh nothing here
reg satisfaccionvida i.baby##i.qAge promedioingresos mujer niveleducativo salud estrato personashogar i.yrN, robust //
margins qAge#baby
//margins baby,at(qAge=(1(1)5))
marginsplot //,title("Predicted happiness with 95% CI")text(8 .9 "<min wage")text(8.55 .9 ">=min wage")legend(off)	

//yes!
reg satisfaccionvida i.qBabyAge##i.qAge promedioingresos mujer niveleducativo salud estrato personashogar i.yrN, robust //
margins qBabyAge#qAge
marginsplot //,title("Predicted happiness with 95% CI")text(8 .9 "<min wage")text(8.55 .9 
gr export mAgeAge.pdf

//maybe do sth with this or redo or sth
dtable satisfaccionvida i.promedioingresos i.niveleducativo i.estrato pobre standard  edad mujer salud personashogar i.est3 , by(baby, nototals) continuous(, statistics(mean)) nformat(%9.2f mean) export("/tmp/a", as(html) replace) //IMC ahorros3mes
! firefox-bin /tmp/a.html


//checking for stability pre covid

drop if yrN>2 //droppinh 2021 anmd 2022
cap est drop a*
reg satisfaccionvida baby i.yrN, robust
est sto a1
reg satisfaccionvida baby mujer  edad edad2 personashogar i.yrN, robust
est sto a2
reg satisfaccionvida baby mujer  edad edad2 personashogar promedioingresos  pobre standard estrato i.yrN, robust
est sto a3
reg satisfaccionvida baby mujer  edad edad2 personashogar promedioingresos  pobre standard niveleducativo salud estrato i.yrN, robust
est sto a4
reg satisfaccionvida baby mujer  edad edad2 personashogar promedioingresos  pobre standard niveleducativo salud estrato i.est3 i.yrN, robust
est sto a5
reg satisfaccionvida baby mujer  edad edad2  standard niveleducativo  salud estrato personashogar promedioingresos  pobre i.yrN if e(sample)==1, robust //ok so indeed most of it is the est3 control, not only sample explains it (to lesser degree), so indeed much of baby positive effect is due to partner
est sto a5a
//but then if measuring marital status/partenr as satisfaction with relationship, baby is significant 
reg satisfaccionvida baby mujer  edad edad2 standard  niveleducativo salud estrato  personashogar promedioingresos  pobre relationship i.yrN, robust //effect size decent
est sto a6

reg satisfaccionvida i.baby##i.est3 mujer  edad edad2 promedioingresos  pobre standard niveleducativo personashogar salud estrato  i.yrN, robust
margins baby#est3
marginsplot
gr export mAAcovid.pdf, replace

ta est3 baby //very small cell size separated/widowed and no baby: 13, cant use this!!
ta est3 baby, col //yes
table baby est3, nformat(%5.2f) stat(mean satisfaccionvida)   stat(freq) nformat(%9.0g)
table ( baby ) ( est3 ) (), statistic(mean satisfaccionvida) statistic(frequency) statistic(percent) nformat(%9.1f mean) nformat(%9.0g frequency) nformat(%9.0f percent)

estout a* using regAAcovid.tex, cells(b(star fmt(%9.2f))) replace style(tex) collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) drop(*yrN)
!sed -i '/^single/i\\\hspace{-.1in}{\\bf marital status:} \& \& \&\& \& \& \& \\\\' regAAcovid.tex
!sed -i  '/^single/d' regAAcovid.tex 
