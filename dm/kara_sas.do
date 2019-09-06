*//TODO per kara -- may need to add 1 to gen end = beg+add

copy http://ftp.cdc.gov/pub/Health_Statistics/NCHS/Program_Code/NHEFS/vitl.inputs.labels.txt vitl.inputs.labels.txt 
clear all
version 10
insheet using  vitl.inputs.labels.txt
l

cap drop beg
gen beg = regexs(1) if regexm(v1, "\@([0-9]*)")
cap drop add
gen add = regexs(1) if regexm(v1, "CHAR([0-9]*).")
destring beg, replace
destring add, replace
gen end = beg+add
cap drop var
gen var= regexs(1) if regexm(v1, "\@[0-9 ]*([A-Za-z0-9]*)[ ]")

l var beg end


file open w using dict.dct, write replace
file write w "infix dictionary using n92vitl.txt {" _n


count if var !=""
loc val_obs = (r(N)+1)
forval i = 2/`val_obs'{
    file write w "str" _skip(1) (var[`i']) _skip(1) (beg[`i']) _skip(0) "-" _skip(0) (end[`i'])  _n
}

file write w   "}" _n
file close w
type dict.dct

copy http://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NHEFS/n92vitl.txt n92vitl.txt

infix using dict.dct, clear


*//labelling...

insheet using  vitl.inputs.labels.txt, clear
l

cap drop lab
gen lab = regexs(1) if regexm(v1, "(=)")
keep if lab == "="
drop lab
gen var = regexs(1) if regexm(v1, "([A-Za-z0-9 ]*)[=]")
gen lab = regexs(1) if regexm(v1, "[=](.*)")
replace lab = subinstr(lab,`"'"',`"""',.)
*// " 
l var lab
drop in 1

file open w using label.do, write replace
loc obs =  _N
forval i = 1/`obs'{
    file write w "la var" _skip(1) (var[`i']) _skip(1) (lab[`i'])  _n
}

file close w
type label.do


infix using dict.dct, clear
do  label.do






*// you can do in a similar way labels....

