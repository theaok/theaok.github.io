//exit
//stata-se
// ! stata-se -b do  /home/aok/data/psid/mainFam-09-19/psid.do
clear                                  
capture set maxvar 32700
version 16                             
set more off                           
run ~/papers/root/do/aok_programs.do



/* //duh wb codebook says need to merge first with the 68-15 file not directly */
/* cd ../wb2016 */
/* do WB2016.do */
/* keep if WB16SN==1 */
/* save wb2016,replace */



//-------------first idea to merge---------------------

/* cd ~/data/psid/mainFam-09-19/ */
/* ls */

/* cd ../mainFam-09-19 */
/* use  raw-psid2, clear */
/* keep if ER60002!=. */
/* ren ER60002 WB16YRID */
/* //gen WB16SN=res2015 */
/* keep if res2015==1 */

/* //LATER should have more success here! */
/* merge 1:1 WB16YRID  using ../wb2016/wb2016.dta //WB16SN */
/* replace WB16A1=. if WB16A1==9 */
/* corr swb2015 WB16A1  */
/* ta WB16SEX male2015 //ok good enough! */

/* foreach v in car1Pri tra clo lat rac age swb k rle inc emp ind kid col hea male mar  met fid1968_ nFU res sFIPS{ */
/* ren `v'2015 `v' */
/* } */

/* cap drop ER* //no room to add more vars layer */

//--------------------end first idea to merge---------------

use /home/aok/data/psid/wb2016/wb2016,clear
merge 1:1 WB16YRID  using  /home/aok/data/psid/mainFam-09-19/psid15.dta


//LATER could guess merge with 2013 or 2011 and do on multistep beale code

replace WB16A2=. if WB16A2>10
replace WB16A5B=. if WB16A5B==6

foreach v of varlist WB16A4B WB16A5B WB16A1 WB16A3A WB16A3B WB16A3C WB16A3D WB16A3E WB16A6A WB16A6B WB16A6C WB16A6D WB16A6E  WB16A6F  WB16A6G  WB16A6H WB16B1A WB16B1A WB16B1B WB16B1C WB16B1D WB16B1E WB16B1F WB16B2A WB16B2B WB16B2C WB16B2D WB16B2E WB16B2F{
replace `v'=. if `v'==9
revrs `v', replace
}

gen lninc=log(inc)

la var WB16A1 "satisfied with life as a whole"
la var WB16A2 "life satisfaction ladder"


//swls scale: tex: ed diener http://labs.psychology.illinois.edu/~ediener/SWLS.html
la var WB16A3A "life is close to ideal"
la var WB16A3B "conditions of life excellent"
la var WB16A3C "satisfied with life"
la var WB16A3D "gotten the important things"
la var WB16A3E "would change almost nothing"

note WB16A1: "How satisfied are you with your life as a whole these days?"
note WB16A2: "Suppose that the top of the ladder below represents the best possible life for you and the bottom of the ladder represents the worst possible life for you. On which step of the ladder do you feel you personally stand at the present time?"




note WB16A3A: "How much do you agree or disagree with each of the following statements: In most ways, my life is close to my ideal." 
note WB16A3B: "(How much do you agree or disagree with each of the following statements:) The conditions of my life are excellent."
note WB16A3C: "(How much do you agree or disagree with each of the following statements:) I am satisfied with my life."
note WB16A3D: "(How much do you agree or disagree with each of the following statements:) So far, I have gotten the important things I want in life."
note WB16A3E: "(How much do you agree or disagree with each of the following statements:) If I could live my life over, I would change almost nothing."


note WB16A6C: "(How much do you agree or disagree with each of the following statements:) I am engaged and interested in my daily activities."
//WB16B1A skip 
note WB16B1D: " (During the past 30 days, how much of the time did you feel each of the following:) Calm and peaceful."
note WB16B1F: " (During the past 30 days, how much of the time did you feel each of the following:) Full of life."
note WB16B2B: "(During the past 30 days, how much of the time did you feel each of the following:) Nervous."
note WB16B2C: " (During the past 30 days, how much of the time did you feel each of the following:) Restless or fidgety."
//and tehres couple more till p17

la var WB16A4B "important to live in a city/place that one likes"
note WB16A4B: "(Below is a list of things that may or may not be important to you. How important are each of the following to you: ) Living in a city or place that I like."

//swls scale .88 nice!
alpha WB16A3A WB16A3B WB16A3C WB16A3D WB16A3E,gen(swls)
la var swls "swls"
note swls: Satisfaction With Life Scale (SWLS)

//positive affect .93
alpha WB16B1A WB16B1B WB16B1C WB16B1D WB16B1E WB16B1F,gen(pos)

//neg affect
alpha WB16B2A WB16B2B WB16B2C WB16B2D WB16B2E WB16B2F,gen(neg)

//flourishing .88
alpha WB16A6A WB16A6B WB16A6C WB16A6D WB16A6E  WB16A6F  WB16A6G  WB16A6H,gen(flo)



//LATER MAYBE email psid on merging issue--how i did it and how few merged; emailing psid re coding, meh later; roughly checks out with alt dwnload as in wbAndFam_oneDownload/


cd /home/aok/papers/root/rr/swbScalesUrbRurPsid/tex/ 
aok_var_des, ff(WB16A1 WB16A2 swls WB16A3A WB16A3B WB16A3C WB16A3D WB16A3E met age age2  inc emp rac  kid col hea male mar nFU   WB16A4B)fname(varDes.tex)
! sed -i '/^  satisfied with life as a whole/i\{\\hspace{-.2in}\\bf global swb measures}  &\\\\' varDes.tex
! sed -i '/^  life is close to ideal/i\{\\hspace{-.2in}\\bf swls items}  &\\\\' varDes.tex
! sed -i '/^  metro/i\{\\hspace{-.2in}\\bf explanatory variables}  &\\\\' varDes.tex




cap mkdir /tmp/trustCity/
aok_hist2, d(/tmp/trustCity/)f(hh)x(swls WB16A3A WB16A3B WB16A3C WB16A3D WB16A3E)

aok_hist2, d(/tmp/trustCity/)f(h0)x(WB16A1 WB16A2 swls WB16A3A WB16A3B WB16A3C WB16A3D WB16A3E)
aok_hist2, d(/tmp/trustCity/)f(h1)x(met age age2  inc emp rac  kid col hea male mar nFU   WB16A4B  rac)

set linesiz 255
pwcorr met age age2  inc emp rac  kid col hea male mar nFU   WB16A4B  rac

cd /home/aok/papers/root/rr/swbScalesUrbRurPsid/tex/ 

set linesiz  180
//tabstat WB16A1  WB16A2 swls WB16A3A WB16A3B WB16A3C WB16A3D WB16A3E , by(met) stat(mean) format(%9.2f) //meh sd pretty much same
cd /home/aok/papers/swbScalesUrbRurPsid/tex/
logout, save(tabstat)  replace tex:  tabstat WB16A1  WB16A2 swls WB16A3A WB16A3B WB16A3C WB16A3D WB16A3E , by(met) stat(mean) format(%9.2f)
! sed -i '1,6d' tabstat.tex
! sed -i '\$d' tabstat.tex
! sed -i "s/ Total.*/\\\hline/g" tabstat.tex
! sed -i 's/0 / /g'  tabstat.tex //rm last 0 in each one, for some reason it was there, and should have not been as compared to regular tabstat

! sed -i '1 i\\\begin{tabular}{p{.55in}p{.85in}p{.45in}p{.75in}|p{.55in}p{.75in}p{.85in}p{.85in}p{.85in}} \\hline' tabstat.tex

! sed -i 's/met / /g'  tabstat.tex

! sed -i 's/WB16A1/ `:var label WB16A1'/g' tabstat.tex
! sed -i 's/WB16A2/ `:var label WB16A2'/g' tabstat.tex
! sed -i 's/swls/ `:var label swls'/g' tabstat.tex

! sed -i 's/WB16A3A/ `:var label WB16A3A'/g' tabstat.tex
! sed -i 's/WB16A3B/ `:var label WB16A3B'/g' tabstat.tex
! sed -i 's/WB16A3C/ `:var label WB16A3C'/g' tabstat.tex
! sed -i 's/WB16A3D/ `:var label WB16A3D'/g' tabstat.tex
! sed -i 's/WB16A3E/ `:var label WB16A3E'/g' tabstat.tex


//paper: do note that except first one from main questionaire, other ones are a year earlier :)

//start with usual life sts and then different dimensions
reg swb age inc i.emp  kid col hea male mar met, robust
reg WB16A1 age inc i.emp i.rac kid col hea male mar i.sFIPS met, robust
reg WB16A2 age inc i.emp i.rac kid col hea male mar  i.sFIPS met, robust //still neg and .1 (tho 1-10 not 1-5 sc) but insig; so city unhappy but not necessarily lo on ladder; speculate that city fetish pride etc;;do note race makes a huge diffrence!

//swls
reg WB16A3A age inc i.emp i.rac kid col hea male mar  i.sFIPS met, robust //aha similar to ladder, aslo makes sense
reg WB16A3B age inc i.emp  i.rac kid col hea male mar  i.sFIPS met, robust //life conditions weird, shiould be stronger
reg WB16A3C age inc i.emp  i.rac kid col hea male mar  i.sFIPS met, robust //nothin
reg WB16A3D age inc i.emp  i.rac kid col hea male mar  i.sFIPS met, robust //gotten important things--nope not really!
reg WB16A3E age inc i.emp  i.rac kid col hea male mar  i.sFIPS met, robust //change almost nothing

//flo urishing nothin!
reg WB16A6A age inc i.emp  i.rac kid col hea male mar  i.sFIPS met, robust //purposeful life,no
reg WB16A6B age inc i.emp  i.rac kid col hea male mar  i.sFIPS met, robust
reg WB16A6C age inc i.emp  i.rac kid col hea male mar  i.sFIPS met, robust //engaged in daily activities,no
reg WB16A6D age inc i.emp  i.rac kid col hea male mar  i.sFIPS met, robust
reg WB16A6E age inc i.emp  i.rac kid col hea male mar  i.sFIPS met, robust
reg WB16A6F age inc i.emp  i.rac kid col hea male mar  i.sFIPS met, robust
reg WB16A6G age inc i.emp  i.rac kid col hea male mar  i.sFIPS met, robust
reg WB16A6H age inc i.emp  i.rac kid col hea male mar  i.sFIPS met, robust
//reg WB16B1A age inc i.emp  i.rac kid col hea male mar  i.sFIPS met, robust //felt cheerful ,no guess dont include at all
//reg WB16B1D age inc i.emp  i.rac kid col hea male mar  i.sFIPS met, robust //nope; weird nothing on calm and peaceful
//reg WB16B1F age inc i.emp  i.rac kid col hea male mar  i.sFIPS met, robust //yes, not full of life 
//reg WB16B2B age inc i.emp  i.rac kid col hea male mar  i.sFIPS met, robust //a bit more nrevous, 
//reg WB16B2C age inc i.emp  i.rac kid col hea male mar  i.sFIPS met, robust //not restless

//swls
reg swls met, robust //oops, but yeah importance of regression!
reg WB16A1 met, robust 

reg swls met age age2 inc i.emp kid col hea male mar nFU i.sFIPS, robust //whew
reg swls met age age2 inc i.emp kid col hea male mar nFU i.rac i.sFIPS, robust //nice!
reg swls met age age2 lninc i.emp kid col hea male mar nFU i.rac i.sFIPS i.WB16A4B, robust //nice

reg WB16A1 met age age2 inc i.emp kid col hea male mar nFU i.rac i.sFIPS i.WB16A4B, robust //so similar ro one item
reg WB16A1 met age age2 inc i.emp kid col hea male mar nFU i.rac i.sFIPS, robust //meh WB16A4J rel

//components
reg WB16A3A  age age2 inc i.emp kid col hea male mar nFU i.rac i.sFIPS i.WB16A4B met, robust
reg WB16A3B  age age2 inc i.emp kid col hea male mar nFU i.rac i.sFIPS i.WB16A4B met, robust
reg WB16A3C  age age2 inc i.emp kid col hea male mar nFU i.rac i.sFIPS i.WB16A4B met, robust
reg WB16A3D  age age2 inc i.emp kid col hea male mar nFU i.rac i.sFIPS i.WB16A4B met, robust
reg WB16A3E  age age2 inc i.emp kid col hea male mar nFU i.rac i.sFIPS i.WB16A4B met, robust


//meh later
/* //pos-neg: so rather lower positive affect than higher neg affect */
/* reg pos met age age2 inc i.emp kid col hea male mar nFU i.rac i.sFIPS i.WB16A4B, robust //yay */
/* reg neg met age age2 inc i.emp kid col hea male mar nFU i.rac i.sFIPS i.WB16A4B, robust //yay */

/* corr k neg //neg same as k6 */

/* //flo */
/* reg flo met age age2 inc i.emp kid col hea male mar nFU i.rac i.sFIPS i.WB16A4B i.ind, robust //yay */




****  paper regressions



** regA swb, swls, ladder
// basic controls;
reg WB16A1 met age age2 inc E2-E7 kid col hea male mar nFU i.sFIPS ,robust
est sto a1a
reg WB16A2 met age age2 inc E2-E7 kid col hea male mar nFU i.sFIPS,robust
est sto a1b
reg swls met age age2 inc E2-E7 kid col hea male mar nFU i.sFIPS,robust
est sto a1c
// race;
reg WB16A1 met age age2 inc E2-E7  kid col hea male mar nFU i.sFIPS R2-R5,robust
est sto a2a
reg WB16A2 met age age2 inc E2-E7  kid col hea male mar nFU i.sFIPS R2-R5,robust
est sto a2b
reg swls met age age2 inc E2-E7  kid col hea male mar nFU i.sFIPS R2-R5,robust
est sto a2c

// question on city importance
reg WB16A1 met age age2 inc E2-E7  kid col hea male mar nFU i.sFIPS  R2-R5 WB16A4B, robust //guess footnote do say in paper that addition of WB16A5B sat w city doesnt change results! for all these 3;and tried WB16A4J rel importance of rel faith, doesnt change results much eitehr
est sto a3a
reg WB16A2 met age age2 inc E2-E7  kid col hea male mar nFU i.sFIPS  R2-R5 WB16A4B ,robust
est sto a3b
reg swls met age age2 inc E2-E7  kid col hea male mar nFU i.sFIPS  R2-R5 WB16A4B,robust
est sto a3c 

cd /home/aok/papers/swbScalesUrbRurPsid/tex/
estout a* using regA.tex, cells(b(star fmt(%9.2f))) replace style(tex) collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)drop( *sFIPS*) //order(`v1' `v2')
! sed -i '/^constant/a\ state  dummies &yes&yes&yes&yes&yes&yes&yes&yes&yes\\\\'  regA.tex
! sed -i 's/a1a/a1a\\hspace{.4in} `:var label WB16A1'/g' regA.tex
! sed -i 's/a1b/a1b\\hspace{.4in} `:var label WB16A2'/g' regA.tex
! sed -i 's/a1c/a1c\\hspace{.4in} `:var label swls'/g' regA.tex
! sed -i 's/a2a/a2a\\hspace{.4in} `:var label WB16A1'/g' regA.tex
! sed -i 's/a2b/a2b\\hspace{.4in} `:var label WB16A2'/g' regA.tex
! sed -i 's/a2c/a2c\\hspace{.4in} `:var label swls'/g' regA.tex
! sed -i 's/a3a/a3a\\hspace{.4in} `:var label WB16A1'/g' regA.tex
! sed -i 's/a3b/a3b\\hspace{.4in} `:var label WB16A2'/g' regA.tex
! sed -i 's/a3c/a3c\\hspace{.4in} `:var label swls'/g' regA.tex
 
//coefplot (a1a,label(satisfied with life as a whole)) a1b a1c a2a a2b a2c a3a a3b a3c, keep(met)
 
 
** regB,  just using swls subquestions interesting differences there--useful to dig deeper into components of swls 
// race;

reg WB16A3A met age age2  inc E2-E7  kid col hea male mar nFU i.sFIPS R2-R5, robust
est sto b2a    
reg WB16A3B met age age2  inc E2-E7  kid col hea male mar nFU i.sFIPS R2-R5, robust
est sto b2b    
reg WB16A3C met age age2  inc E2-E7  kid col hea male mar nFU i.sFIPS R2-R5, robust
est sto b2c    
reg WB16A3D met age age2  inc E2-E7  kid col hea male mar nFU i.sFIPS R2-R5, robust
est sto b2d    
reg WB16A3E met age age2  inc E2-E7  kid col hea male mar nFU i.sFIPS R2-R5, robust
est sto b2e

// question on city importance WB16A4B
//MAYBE LATER check!!!guess footnote do say in paper that addition of WB16A5B sat w city doesnt change results! for all these 3;and tried WB16A4J rel importance of rel faith, doesnt change results much eitehr

reg WB16A3A met age age2  inc E2-E7  kid col hea male mar nFU i.sFIPS R2-R5 WB16A4B , robust
est sto b3a	   
reg WB16A3B met age age2  inc E2-E7  kid col hea male mar nFU i.sFIPS R2-R5 WB16A4B , robust
est sto b3b	   
reg WB16A3C met age age2  inc E2-E7  kid col hea male mar nFU i.sFIPS R2-R5 WB16A4B , robust
est sto b3c	   
reg WB16A3D met age age2  inc E2-E7  kid col hea male mar nFU i.sFIPS R2-R5 WB16A4B , robust
est sto b3d	   
reg WB16A3E met age age2  inc E2-E7  kid col hea male mar nFU i.sFIPS R2-R5 WB16A4B , robust
est sto b3e


estout b* using regB.tex, cells(b(star fmt(%9.2f))) replace style(tex) collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)drop( *sFIPS*) //order(`v1' `v2')
! sed -i '/^constant/a\ state  dummies &yes&yes&yes&yes&yes&yes&yes&yes&yes&yes\\\\'  regB.tex
! sed -i 's/b2a/b2a\\hspace{.35in} `:var label WB16A3A'/g' regB.tex
! sed -i 's/b2b/b2b\\hspace{.35in} `:var label WB16A3B'/g' regB.tex
! sed -i 's/b2c/b2c\\hspace{.35in} `:var label WB16A3C'/g' regB.tex
! sed -i 's/b2d/b2d\\hspace{.35in} `:var label WB16A3D'/g' regB.tex
! sed -i 's/b2e/b2e\\hspace{.35in} `:var label WB16A3E'/g' regB.tex
! sed -i 's/b3a/b3a\\hspace{.35in} `:var label WB16A3A'/g' regB.tex
! sed -i 's/b3b/b3b\\hspace{.35in} `:var label WB16A3B'/g' regB.tex
! sed -i 's/b3c/b3c\\hspace{.35in} `:var label WB16A3C'/g' regB.tex
! sed -i 's/b3d/b3d\\hspace{.35in} `:var label WB16A3D'/g' regB.tex
! sed -i 's/b3e/b3e\\hspace{.35in} `:var label WB16A3E'/g' regB.tex


coefplot (b3a,label(life is close to ideal)) (b3b,label(conditions of life excellent))(b3c,label(satisfied with life))(b3d,label(gotten the important things))(b3e,label(would change almost nothing)), keep(met)
gr export cp.pdf,replace

//regCD  repeating a3a a3b a3c, but with rel, city sat and ind dummies; and same on b3a-b3e; conclusion: results substantively very similar 

reg WB16A1 met age age2 inc E2-E7  kid col hea male mar nFU i.sFIPS  R2-R5 WB16A4B WB16A4J WB16A5B i.ind, robust //guess footnote do say in paper that addition of WB16A5B sat w city doesnt change results! for all these 3;and tried WB16A4J rel importance of rel faith, doesnt change results much eitehr; 
est sto c3a
reg WB16A2 met age age2 inc E2-E7  kid col hea male mar nFU i.sFIPS  R2-R5 WB16A4B WB16A4J WB16A5B i.ind,robust
est sto c3b
reg swls met age age2 inc E2-E7  kid col hea male mar nFU i.sFIPS  R2-R5 WB16A4B WB16A4J WB16A5B i.ind,robust
est sto c3c

reg WB16A3A met age age2  inc E2-E7  kid col hea male mar nFU i.sFIPS R2-R5 WB16A4B WB16A4J WB16A5B i.ind, robust
est sto d3a	   
reg WB16A3B met age age2  inc E2-E7  kid col hea male mar nFU i.sFIPS R2-R5 WB16A4B WB16A4J WB16A5B i.ind, robust
est sto d3b	   
reg WB16A3C met age age2  inc E2-E7  kid col hea male mar nFU i.sFIPS R2-R5 WB16A4B WB16A4J WB16A5B i.ind, robust
est sto d3c	   
reg WB16A3D met age age2  inc E2-E7  kid col hea male mar nFU i.sFIPS R2-R5 WB16A4B WB16A4J WB16A5B i.ind, robust
est sto d3d	   
reg WB16A3E met age age2  inc E2-E7  kid col hea male mar nFU i.sFIPS R2-R5 WB16A4B WB16A4J WB16A5B i.ind, robust
est sto d3e



cd /home/aok/papers/swbScalesUrbRurPsid/tex/
estout c* d* using regCD.tex, cells(b(star fmt(%9.2f))) replace style(tex) collabels(, none) stats(N, labels("N")fmt(%9.0f))varlabels(_cons constant) label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001)drop( *sFIPS* *ind*) //order(`v1' `v2')
! sed -i '/^constant/a\ state  dummies &yes&yes&yes&yes&yes&yes&yes&yes\\\\'  regCD.tex
! sed -i '/^constant/a\ industry dummies &yes&yes&yes&yes&yes&yes&yes&yes\\\\'  regCD.tex
! sed -i 's/c3a/c3a\\hspace{.4in} `:var label WB16A1'/g' regCD.tex
! sed -i 's/c3b/c3b\\hspace{.4in} `:var label WB16A2'/g' regCD.tex
! sed -i 's/c3c/c3c\\hspace{.4in} `:var label swls'/g' regCD.tex
 
! sed -i 's/d3a/d3a\\hspace{.35in} `:var label WB16A3A'/g' regCD.tex
! sed -i 's/d3b/d3b\\hspace{.35in} `:var label WB16A3B'/g' regCD.tex
! sed -i 's/d3c/d3c\\hspace{.35in} `:var label WB16A3C'/g' regCD.tex
! sed -i 's/d3d/d3d\\hspace{.35in} `:var label WB16A3D'/g' regCD.tex
! sed -i 's/d3e/d3e\\hspace{.35in} `:var label WB16A3E'/g' regCD.tex





//MAYBE LATER i guess app 2 tables first 2 models from regA

//MAYBE LATERin app sequential elaboration; desc in app; main points in body like that race is critical, flips it
