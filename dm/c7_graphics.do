*______________________________________________________________________
*intro to graphics with stata               /*this is a preamble. always have it!*/
*Adam Okulicz-Kozaryn, Summer 09
*Revised: too many times; spring16;f17

* notes: 
clear         

version 11                    /* if you write code is Stata 11, specify version 11, then if you run it in */
                              /* Stata 15 it will run properly (as if in Stata 11)*/



//----------------------------checking----------------------------------------------


//checking variables simple way: variables are often wrong: eg gender chng at TSP!

use https://stats.idre.ucla.edu/stat/stata/notes/hsb2, clear


assert female==0|female==1

replace female = 3 if id == 1

assert female==0|female==1


//checking a variable--complex fancy neat way

sysuse auto,clear
//we gen some var
gen byte goodcar=(rep78>=3 & headroom>3 & trunk>15)
checkvar goodcar rep78 headroom trunk
//oops, correct mistake
replace goodcar=. if rep78==.
checkvar goodcar rep78 headroom trunk
mat l r(checkvar)

//references:
//https://stats.idre.ucla.edu/stata/faq/how-do-i-document-and-search-a-stata-dataset
//http://www.stata.com/meeting/wcsug07/ckvarTalk.beamer.pdf 

//bar charts etc: this is very good!!! https://www.ssc.wisc.edu/sscc/pubs/stata_bar_graphs.htm

/*  //SKIP this maybe complicates too much; just use assert
//can use gui: ckvaredit
//we want on female either 0 or 1
ckvareditsave female, stub(valid) req(0) rulechgflag(1) rule("in {0,1}")
ckvar
*/

//NOTE for checking missimgness can use misstable
sysuse nlsw88.dta, clear
misstable sum   // to locate the missing values in all the variables
count if missing(grade, industry)

//---checking with descriptive statistics

//inspect -- useful for a first glance -- i like ascii and graphs -- nothing better than ascii graph !
sysuse auto,clear
inspect mpg //useful! neg, pos, zero are important! and even has little hist and numb of uniq vals
sysuse census
inspect region
sysuse citytemp
inspect tempjan

ta tempjan, plot //i love this plot neat! see things right away!

//SKIP lv also...

//biplot also looks nice 
//http://www.stata.com/meeting/2german/Kohler.pdf

//table and tabstat
sysuse  nlsw88 , clear
tab married collgrad 
table collgrad union married  //nice!
table collgrad union married, by(smsa)
bys south: table collgrad union married, by(smsa) //very nice!

sysuse auto , clear
tabstat price weight mpg rep78, by(foreign)
tabstat price weight mpg rep78, by(foreign) stat(mean sd min max)
tabstat price weight mpg rep78, by(foreign) stat(mean sd min max) nototal long format
tabstat price weight mpg rep78, by(foreign) stat(mean sd min max) nototal long col(stat)

//for latex there is latabstat, and many more... try also to use graphs for descriptive statistics -- humans get more from graphs than from tables

//----------------------------END checking-----------------------------------------


//cool graph
ssc install radar

clear
input     id   country   y_em       y_par     y_inf        
          1    32        55.2       60.4      40.25       
          2    68        68.3       72.5         70        
          3    76        61.7         67       49.6       
          4    152       53.1       57.3       33.1
          5    170       60.8    68.10001      60.3
          6    188       55.85      60.15      38.65
          7    604       54.5      56.25       51.7 
          8    214       62.4         66       61.7
          9    218       56.7       59.3      56.75
          10   222       63.65      64.95       66.9
          11   332       58.9      61.45       63.3 
          12   340       60      62.65       46.7
          13   484       59.55   65.35001   64.39999
          14   558       59.75       63.3      44.95
          15   591       65.95       69.2      65.85 
          16   600       73.2   75.64999      63.65 
          17   858       59      64.05      40.25
          18   862       58.75   67.89999      49.85 
end
l
//kountry country, from(iso3n)to(unc)

#delimit ;
radar  y_em y_par y_inf,
   aspect(1) 
   title(Labor Market in LAC countries, size(*0.6)) 
   lc(red blue green)  
   lw(*1 *2 *4) rlabel(0 20 40 60 80 100) labsize(*0.7) 
   legend(label(1 "Employment") 
          label(2 "Participation")
          label(3 "Informality")
          col(1) size(*.8)) ;
#delimit cr



/*********************************/
/* exporting*/
/*********************************/

sysuse auto, clear
des
sum
scatter mpg price
cd ~
gr export myfig.eps, replace  //pdf, png, etc
  
  
/*****************/   
/* graph options */  
/*****************/
sysuse auto, clear
/*help twoway_options*/ ///
/* help marker_options*/ ///
tw (scatter mpg price, mcolor(blue) msymbol(smcircle_hollow)) /// /*blue small circle*  */
(scatter mpg price if weigh>4000, ///                       /*separate scatter for heavy cars*/
msize(zero) msymbol(point) mlabel(make)) ///     /* make it small and labe with make*/           
/* help lines*/ ///
(lfit mpg price, lcolor(red) lwidth(thick) lpattern(dot)) /// /* red thick dotted line*/
if mpg<45, ///                                 /* have all the graphs only if mpg<45*/  
ytitle(y title)  ylabel(, labsize(small)) ///  /* have small Y title*/
yline(30, lwidth(thick) lpattern(dash) lcolor(gold)) /// /* put horizontal line at 30*/
xtitle(x title) xlabel(, labsize(small)) /// /*also small X title*/
title(title, size(medium)) /// /*medium main title*/
/* help legend_option*/ ///  
legend(order(1 "points" 3 "regression line") /// /* I will  lable only 1st and 3rd graph*/
cols(1) size(small) position(1) ring(0)) /// /*legend in 1 column at 1pm , no distance (within plot)*/
scheme(s2mono) graphregion(margin(tiny)) plotregion(margin(tiny)) /*black and white, compact*/


sysuse uslifeexp, clear
gen diff = le_wm - le_bm 
label var diff "Difference"


//below example with || can either use tw()() or ||
#delimit ;
line le_wm year, yaxis(1 2) xaxis(1 2) 
  || line le_bm year 
  || line diff  year
  || lfit diff  year
  ||, 
  ylabel(0(5)20, axis(2) gmin angle(horizontal))
  ylabel(0 20(10)80,     gmax angle(horizontal))
  ytitle("", axis(2))
  xlabel(1918, axis(2)) xtitle("", axis(2))
  ytitle("Life expectancy at birth (years)")
  title("White and black life expectancy")
  subtitle("USA, 1900-1999")
  note("Source: National Vital Statistics, Vol 50, No. 6" 
       "(1918 dip caused by 1918 Influenza Pandemic)")
  legend(label(1 "White males") label(2 "Black males"))
  legend(col(1) pos(3))
  ;
#delimit cr


  
/*****************/
/* graph combine */
/*****************/

/* Influential obseervations*/
sysuse auto, clear
reg mpg price  weight   

//avplots, saving(g0,replace)    /*note how different avplots are from regular fit graphs*/
twoway (scatter mpg price, sort msymbol(smcircle_hollow) ) (lfit mpg price),  saving(g1,replace) 
twoway (scatter mpg weight, sort msymbol(smcircle_hollow) ) (lfit mpg weight),  saving(g2, replace) 
gr combine  g1.gph g2.gph, c(2) iscale(1) saving(g3, replace)
//gr combine g0.gph g3.gph, col(1) 


//Datenanalyse mit Stata Ulrich Kohler; RU: https://ebookcentral-proquest-com.proxy.libraries.rutgers.edu/lib/rutgers-ebooks/reader.action?docID=4768932#
//p166 scatterplot with histogram for x and y at top and on the right: //TODO run it annd make sure everything fine
twoway scatter price mpg, name(xy, replace) xlabel(, grid) ylabel(, grid gmax)
twoway histogram mpg, name(hx, replace) fraction xscale(alt) xlabel(, grid gmax) fysize(25)
twoway histogram price, fraction name(hy, replace) horizontal  yscale(alt) ylabel(0(500)2500, grid gmax) fxsize(25) //TODO: fixrescale label properly
graph combine hx xy hy, imargin(0 0 0 0) hole(2)


*//############## descriptive graphs ##############################

/******************/
/* continous vars */
/******************/
  

/*display labels on scatterplot*/
webuse auto, clear
scatter mpg weight in 1/15, mlabel(make)


/*many scatterplots */
sysuse lifeexp, clear
generate lgnppc = ln(gnppc)
graph matrix popgr lgnp safe lexp, half /*have DV as last; use half option*/

/*time series*/
webuse uslifeexp, clear
line le_wm le_bm year, legend(size(small))
  
/*minimum maximum*/
webuse sp500, clear
twoway rcap high low date in 1/15

/*SKIP growth and decline*/
/* webuse gnp96, clear */
/* twoway area d.gnp96 date  */

webuse sp500, clear
twoway area high close low date in 1/15

tsset  date, daily
graph twoway tsline  high low , tline(01apr2001 01jul2001 01oct2001)
graph twoway tsline  high low if tin(01jan2001, 30jun2001)

/*

/*autocorrealtions/ partial autocorrelations*/
webuse air2
corrgram air, lags(20)
pac DS12.air, lags(20) srv

*/

/****************/
/* distribution */
/****************/

quietly cap net  from http://fmwww.bc.edu/RePEc/bocode/u
quietly cap net install univar
help univar
  
/*histogram*/
webuse sp500, clear
histogram open, frequency normal 
histogram open, percent 

/*SKIP other histograms: byhist, bihist*/
/* ssc install byhist */
/* ssc install bihist */
/* sysuse auto, clear */
/* byhist mpg, by(foreign) */
/* bihist mpg, by(foreign) */

/*fancy*/
webuse pop2000, clear
replace maletotal = -maletotal
twoway area maletotal agegrp, horizontal || area femtotal agegrp, horizontal
twoway bar maletotal agegrp, horizontal || bar femtotal agegrp, horizontal

/*box plots*/  //nice! box plots are really good; used in med; underused in soc sci
webuse bplong, clear
graph box bp, over(agegrp)  

webuse bpwide, clear 
graph box bp_before bp_after
graph box bp_before bp_after, over(agegrp)

/*transformation*/
webuse auto
gladder mpg, fraction


/**********************************************/
/* categorical, continous, summary statistics */
/**********************************************/
/*these are really useful to explore data! use them a lot!!!*/
//guess especially hbars and dot plots  
  
/*sum stats by var*/  
webuse citytemp, clear
graph bar tempjan, over(region)
graph bar tempjan tempjuly, over(region)
graph hbar tempjan tempjuly, over(region) /*hbar makes it horizontal*/

webuse nlsw88
graph dot wage hours ttl_exp, over(occ)
gr dot wage, over(collgrad) over(occ) over(race) by(union) 
gr hbar ttl_exp tenure, over(married) over(race) by(union, missing total)


//this is little overkill--good for exploring on your own
//make a graph like that have a cup of coffee and do some thinking
//but do not put this into paper and especially not into presentation
graph dot wage hours ttl_exp if industry<7, over(occ, gap(20) label(labsize(vsmall))) ///
by(industry, compact cols(2) b1title("title") ///
note("")) ylabel(15(15)60) marker(1,msymbol(+)) marker(2,msymbol(Oh)) ///
legend(label(1 label1) label(2 label2) label(3 label3))


/*var by two categorical, very useful*/
sysuse nlsw88, clear
graph hbar wage, over(ind) over(collgrad)

/*same graph with useful options*/
sysuse nlsw88, clear
#delimit ;
graph hbar wage,                        /*we plot horizontaly wage*/
  over(ind, sort(1) label(labsize(small)) ) /*over industry; and sort on industry; and have small label*/
  over(collgrad, label(labsize(small) angle(vertical)) ) /*and everything again over collgrad; small */
  bar(1, fcolor(black))                 /*label vertically, and have black bars*/
  ysize(5)                              /*this will set aspect ratio*/
  title("Average hourly wage, 1988, women aged 34-46", span) /*span; otherwise it won't be aligned*/
  subtitle(" ")
  note("Source:  1988 data from NLS, U.S. Dept. of Labor, Bureau of Labor Statistics", span)
;                                       /*don't forget about ;*/
#delimit cr

sysuse nlsw88, clear
#delimit ;
graph hbar wage, over( occ, axis(off) sort(1) )
  bar(1, fcolor(black)) 
  blabel( group, pos(base) color(bg) )
  ytitle( "" )
  by( union, 
  title("Average Hourly Wage, 1988, Women Aged 34-46")
  note("Source:  1988 data from NLS, U.S. Dept. of Labor, Bureau of Labor Statistics") ) ;
#delimit cr
 

/*combine continous vars by categorical*/
webuse sp500, clear
twoway bar high low date in 1/15 

webuse citytemp, clear
graph bar tempjan tempjuly, over(region) stack

/* more here */
/* https://stats.idre.ucla.edu/stata/faq/how-can-i-make-a-bar-graph-with-error-bars/ */

//------------------------------SKIP----------------------------------------------
//------------------------------SKIP----------------------------------------------
//------------------------------SKIP----------------------------------------------
  
/***************************************/
/* EXTRA: advanced descriptive graphs */
/**************************************/

/*plot means and sd*/
findit meansdplot
use http://www.ats.ucla.edu/stat/stata/notes/hsb2, clear
meansdplot write prog, outer(2) xlabel(1 "General" 2 "Academic" 3 "Vocational") ytitle(Writing Score)

/*profiles*/
findit profileplot
profileplot read write math science , by(prog)
profileplot read write math science if schtyp==2, by(id) msymbol(i) legend(off)

/*binsm -- bin smoothing and summary on scatter plots*/ 
findit binsm
binsm write read, width(5) scatter(jitter(2)) su(mean iqr) /*jitter adds random noise so that points */
                                                          /*do no overlap*/
/*freq, fractions and percents*/
findit catplot
sysuse auto, clear
catplot  rep78 foreign
catplot  rep78, by(foreign) percent(foreign)
gen himpg = mpg > 25
catplot  himpg rep78 foreign
catplot  rep78 foreign, percent(foreign) bar(1, bcolor(blue)) blabel(bar, position(outside) format(%3.1f)) ylabel(none) yscale(r(0,60))
catplot  rep78, sort
catplot  rep78, sort desc


/*graphical freq table*/
findit  tabplot
sysuse auto, clear
    tabplot for rep78
    tabplot for rep78, showval
    tabplot for rep78, percent(foreign) showval(offset(0.05) format(%2.1f))
    tabplot rep78 mpg, xasis barw(1) bstyle(histogram)
    egen mean = mean(mpg), by(rep78)
    gen rep78_2 = 6 - rep78 - 0.05
    bysort rep78 : gen byte tag = _n == 1
    tabplot rep78 mpg, xasis barw(1) bstyle(histogram) plot(scatter rep78_2 mean if tag)

/*graphical chi-square*/
findit spineplot
sysuse auto, clear
spineplot foreign rep78
spineplot foreign rep78, xti(frequency, axis(1)) xla(0(10)60, axis(1)) xmti(1/69, axis(1))
spineplot rep78 foreign

/*plot 3 proportions*/
ssc install triplot
clear
input a1 a2 a3 str10 name
20 20 80 John
80 10 10 Fred
25 25 50 Jane
90 5 5 Helen
0 0 100 Ed
50 25 25 Kate
20 60 20 Michael
25 25 50 Darren
5 90 5 Samar
end
list

triplot a1 a2 a3 , mlab(name) mlabcolor(black) mcolor(blue) ///
mlabsize(*0.9) max(100) title("Opinion a1 a2 a3")


*//########################## postestimation graphs #############################

*______________________!!!!!QM2__ONLY!!!!_____________________________________


/****************/
/* graphs 1  */
/****************/
  
/*model fit with regplot*/
findit modeldiag
help modeldiag /*much more stuff*/
sysuse auto, clear
gen weightsq = weight^2

des mpg weight foreign
sum mpg weight foreign

regress mpg weight foreign

regplot, by(foreign)
regplot, sep(foreign)
	 
/* same thing by hand*/
regress mpg weight  foreign
predict yhat, xb	

separate yhat, by(foreign)
edit foreign mpg yhat*

gen mpg0=mpg if foreign==0
gen mpg1=mpg if foreign==1

tw (line yhat0 yhat1 weight, sort) (scatter mpg0 mpg1 weight)
 
/* other model fit examples with regplot*/	 
     regress mpg weight weightsq foreign
     regplot, by(foreign)
     regplot, sep(foreign)

     gen fw = foreign * weight
     regress mpg weight foreign fw
     regplot, by(foreign)
     regplot, sep(foreign)

     logit foreign weight
     regplot


/*eclplot Plot estimates with confidence limits*/
net from http://www.stata-journal.com/software/sj3-3
net install  st0043 

sysuse auto,clear
parmby "xi:regress mpg i.foreign i.rep78",label norestore
sencode label,gene(parmlab)
eclplot estimate min95 max95 parmlab,hori


/************/
/* graphs 2 */ //---------SKIP OUTDATED: postgr3 uninstalable-----------//
/************/
findit spostado
findit xi3
findit postgr3  
use http://www.ats.ucla.edu/stat/stata/notes/hsb2, clear
gen goodread = read > 60
  
xi3: logit goodread i.female*socst science
postgr3 socst, by(female) x(science==20)

xi3: logit goodread i.ses*i.female socst science
postgr3 ses, by(female) table2

/* more here */
/* http://www.ats.ucla.edu/stat/Stata/ado/analysis/postgr3.htm */
/* http://www.ats.ucla.edu/stat/stata/faq/logit2by211.htm */


/*by hand*/
xi3: logit goodread i.female*socst science
postgr3 socst, by(female) 

gen femaleXsocst=female*socst
logit goodread female socst femaleXsocst science

sort female socst

adjust  science  , se gen(xb se)
gen pr = invlogit(xb)
gen lb = invlogit(xb - invnormal(.975)*se)
gen ub = invlogit(xb + invnormal(.975)*se)

twoway rarea lb ub socst if female == 0, fcolor(gs12) lcolor(black)|| ///
rarea lb ub socst if female == 1 , fcolor(gs12) lcolor(black)|| ///
line pr socst if female == 0 , lcolor(black) lpattern(dash)    || ///
line pr socst if female == 1,  lcolor(black) lwidth(thick) lpattern(solid) ///
legend(order(3 "male" 4 "female" )) scheme(s2mono) title(my title)


//TODO: marginsplot!! see manual: help marginsplot and click top left command name in blue

*//##############  bonus ############################

  
/**********/
/* ca pca */
/**********/

use http://www.stata-press.com/data/r11/ca_smoking, clear
tabulate rank smoking

ca rank smoking, norowpoint nocolpoint plot

use http://www.ats.ucla.edu/stat/stata/output/m255, clear
factor item13-item24, ipf factor(2)
des item13-item24
      loadingplot
rotate, varimax horst blanks(.3) 
loadingplot


/******************/
/* chernoff faces */
/******************/
findit chernoff

sysuse auto, clear
drop if rep78==.

keep in 41/55

chernoff, isize(rep78) hdark(mpg) hslant(mpg) fline(weight) ///
order(foreign price) saving(c:/face1) inote(make)


  
/*********/
/* other */
/*********/

/*batplot*/  
ssc install batplot

sysuse auto, clear
batplot mpg turn, title(Agreement between mpg and turn) ///
info valabel(make) notrend xlab(26(4)38) moptions(mlabp(9))


/*graphing logit results*/
use http://www.ats.ucla.edu/stat/data/logit2-2, clear

logit y f##h cv1

xi3: logit y i.f*i.h cv1

postgr3 cv1, by(f) x(_Ih_1==0)
postgr3 cv1, by(h) x(_If_1==1)


/*by hand*/
use http://www.ats.ucla.edu/stat/stata/notes/hsb2, clear
gen goodread = read > 60
xi3: logit goodread i.female*socst science
postgr3 socst, by(female) 

gen femaleXsocst=female*socst
logit goodread female socst femaleXsocst science

sort female socst

adjust  science  , se gen(xb se)
gen pr = invlogit(xb)
gen lb = invlogit(xb - invnormal(.975)*se)
gen ub = invlogit(xb + invnormal(.975)*se)

twoway rarea lb ub socst if female == 0, fcolor(gs12) lcolor(black)|| ///
rarea lb ub socst if female == 1 , fcolor(gs12) lcolor(black)|| ///
line pr socst if female == 0 , lcolor(black) lpattern(dash)    || ///
line pr socst if female == 1,  lcolor(black) lwidth(thick) lpattern(solid) ///
legend(order(3 "male" 4 "female" )) scheme(s2mono) title(my title)


/* label observations in graph*/
sysuse auto, clear
  twoway qfitci mpg weight, stdf || scatter mpg weight
quietly regress mpg weight
predict hat
predict s, stdf
generate upper = hat + 1.96*s
list make mpg weight if mpg>upper
 twoway qfitci  mpg weight, stdf || ///
                 scatter mpg weight, ms(O) ///
                        text(41 2040 "VW Diesel", place(e)) ///
                        text(28 3260 "Plymouth Arrow", place(e)) ///
                        text(35 2050 "Datsun 210 and Subaru", place(e)) 



*//#####################

/**************************/
/* nice dot plots with ci */
/**************************/

      webuse citytemp, clear

     ciplot heatdd cooldd

     ciplot heatdd, by(division)

     ciplot heatdd cooldd, by(division) xla(, ang(45))

     ciplot heatdd, hor

     ciplot heatdd cooldd, hor

     ciplot heatdd, by(division) hor

     ciplot heatdd cooldd tempjan, by(division) hor
                      
http://images.google.com/imgres?imgurl=http://www.gllamm.org/books/gumf.png&imgrefurl=http://www.gllamm.org/books/gum.html&usg=__Db7uFiZp1DOPpI5ECz2V7RJXSXI=&h=558&w=436&sz=31&hl=en&start=7&sig2=nh5nmHu_99Y1NUeGhYzstw&um=1&tbnid=UH0OjyFo3hagjM:&tbnh=133&tbnw=104&prev=/images%3Fq%3Dstata%2Bscatter%2Brcap%26hl%3Den%26client%3Dopera%26rls%3Den%26sa%3DN%26um%3D1&ei=UhsfS-2fN5vvlQf_peGhCw


encode studynam, gen(s)
twoway (rcap lower upper s, horizontal blpattern(dash)) (scatter s eff),   /*
  */ ylabel(1(1)27,valuelabels angle(horizontal) labs(small)) legend(off)  /*
  */ xscale(range(-.5 1.5)) ysize(7) xlab(-.5(.5)1.5) xline(0) saving(gumf) 
