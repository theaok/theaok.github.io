//created sp2024

sysuse auto,clear

//start with interval/ratio dv
d foreign weight length price mpg
sum foreign weight length price mpg
//use des stats first
gr bar weight ,over(foreign) //like 1k diff
//confirm with reg second
reg  weight foreign //same here

//nov dv binary
ta foreign rep78, col //.1 .5 .8
gr bar foreign, over(rep78) //.1 .5 .8
//LPM
reg foreign i.rep78 //.1 .5 .8

sum price weight
scatter price weight
reg  price weight

sum price weight
recode price (0/6000=0)(6001/20000=1),gen(hiPr)
ta price hiPr, mi //always double check

reg hiPr weight //hmmm
replace weight=weight/1000 //in thousands of lbs
reg hiPr weight 
tw(scatter hiPr weight)(lfit hiPr weight) 
//right so if weight goes up by 1k lbs hiPr goes up by .23, BUT the fit is not great; still .23 is kinda average increase in probability for 1 unit increase id iv, still very imprecise; best just stick with sign and stat sig interpretation; and do probabilities for logit

//more info, elaboration
//https://www3.nd.edu/~rwilliam/xsoc73994/Logit01.pdf

logit hiPr weight 
margins, at(weight=(1(1)5)) 
marginsplot



//------more practice; especially marginsplot---------

//quick and easy
//https://stats.oarc.ucla.edu/stata/dae/using-margins-for-predicted-probabilities/

//one person's example
//https://andrewpwheeler.com/2019/07/25/making-nice-margin-plots-in-stata/

//manual, dry, thorough with examples
//https://www.stata.com/manuals/rmarginsplot.pdf






//-------real world example: circle of trust replication-----------


//see paper:
//https://journals.sagepub.com/doi/pdf/10.1007/s13644-020-00437-8

use "https://docs.google.com/uc?id=1aFuG5Mmci8NxGFtJ1zJQZ0NGh7uA-rqa&export=download", clear 

//check out attending v praying:
logit trust attend  pray R3 realinc  prot cath  con lib mar unemp  age age2 educ male born hhwhite swb hea i.year, robust

margins, at(attend=(0(1)8))
marginsplot, xlabel(, angle(forty_five))

margins, at(pray=(1(1)6))
marginsplot, xlabel(, angle(forty_five))

//2 in one graph
logit trust attend  pray R3 realinc  prot cath  con lib mar unemp  age age2 educ male born hhwhite swb hea i.year, robust
margins, at(attend=(0(1)8)) post
est sto f1
logit trust attend  pray R3 realinc  prot cath  con lib mar unemp  age age2 educ male born hhwhite swb hea i.year, robust
margins, at(pray=(1(1)6))  post
est sto f2
//coefplot  http://www.statalist.org/forums/forum/general-stata-discussion/general/1311696-overlaying-two-marginsplot
coefplot f1 f2, at xtitle(" ")  lwidth(*1) connect(l)legend(label(4 "pray") label(2 "attend"))saving(trust.gph,replace)title(trust)  //who knows how to make it dahsed; if accepted just do it in inkscape
