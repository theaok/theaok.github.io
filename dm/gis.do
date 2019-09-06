*//see here for more http://www.ats.ucla.edu/stat/stata/faq/regex.htm

//insheet using "/home/ben/SG.2011/DN.2010.csv", clear
insheet using http://aok.us.to/tmp/contr.csv, clear
//checkning  how it looks like
l in 1/10
drop in 1

ren v1 address
ren v2 amount
replace address="" if address=="View Report"

//move rows by one
gen st_add = address[_n-1]
gen cit_st_zip = address
keep cit* st_* amount
drop if amount ==""

//NOTE! there are problems... it is difficult...do not want to spend too much time 

l in 1/10
gen zip = regexs(1) if regexm(cit_st_zip, "[ ][ ][ ]([0-9][0-9][0-9][0-9][0-9])")
l in 1/10
gen state = regexs(1) if regexm(cit_st_zip, "[,][ ]([A-Z][A-Z])")
l in 1/10
gen city = regexs(1) if regexm(cit_st_zip, "([A-Za-z ]*)[,]")
l in 1/10


ta city
ta state
drop cit_st_zip

outsheet using "/home/ben/SG.2011/ex.csv", replace comma
