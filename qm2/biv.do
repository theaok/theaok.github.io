*//class c2 
set more off
version 10


//------------------guessing------------------------------

clear 
input  y x
2  1  
5  2  
6  3  
end
d
l
gen first_guess=x+2
tw(scatter y x)(line first_guess x)
gen second_guess=0 +2*x
tw(scatter y x)(line second_guess x)
gen ols=0.33 +2*x
tw(scatter y x)(line ols x)

*//let's look at the residuals
g r_first_guess=(y-first_guess)^2
g r_second_guess=(y-second_guess)^2
g r_ols=(y-ols)^2
sum r*
egen s_r_first_guess=sum(r_first_guess)
egen s_r_second_guess=sum(r_second_guess)
egen s_r_ols=sum(r_ols)
l s_* in 3



*//TODO and so on... calsulate resid... and calculate reg by hand in stata... e.g. slide 34 solving the problem can be done in stata by hand
