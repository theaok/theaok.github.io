//redone sp22
version 16

//!! TODO  compare with this http://www.stata.com/meeting/wcsug07/medeiros_reg_ex.pdf


/********************/
/* string functions */
/********************/

help string functions
//there is also... help math functions, like round, abs, logit....
  
//abbrev(str,n)	returns str abbreviated to n characters
//itrim(str)	returns str without consecutive spaces
//length(str)	returns number of characters in str
//lower(str)	returns str without lowercase letters only
//ltrim(str)	removes leading spaces
//proper(str)	capitalizes all letters not preceded by letters
//real(str)	converts str to numeric or missing
//regexm(str,re)	evaluates whether str matches regular expression re
//regexr(str1, re, str2)	replaces the first substring of str1 that matches reg. exp. re with str2
//regexs(n)	 
//reverse(str)	returs str reversed
//rtrim(str)	drops trailing spaces
//string(n)	converts number n to string
//strmatch(str1,str2)	testes whether str1 matches pattern str2
//strpos(str1,str2)	returns position of str2 in str1
//strtoname(str[,p])	translates str into stata name (replaces characters not allowed by Stata)
//substr(str,n1,n2)	extracts characters n1 through n2 from str
*very useful!! eg:
di substr("Camden County",1,6)
di substr("Camden County",-6,.)


//trim(str)	removes both leading and trailing spaces
//upper(str)	converts all letters to uppercase
//word(str,n)	returns nth word from str (if n<0 starts counting from right)
di word("adam is best at stata",2)
//wordcount(str)	returns number of words in str or number of spaces minus 1
di wordcount("adam is best at stata")

//---
help split //very handy!!
webuse splitxmpl,clear
l
//parse by " " (space) 
split var1, gen(geog)
l

webuse splitxmpl2, clear
l
//parse by comma
split var1, parse(,) gen(geog)
l

webuse splitxmpl3, clear
l
//parse by comma-followed-by-space and space 
split date, parse(", "" ") gen(ndate)
l

webuse splitxmpl4, clear
l
//parse by comma and destring
split x, parse(,) destring
l

//more on split command
//http://www.stata.com/support/faqs/data/splitstr.html


//egenmore:  sieve() seems useful for cleaning weird chars
/*
https://www.statalist.org/forums/forum/general-stata-discussion/general/1354264-special-characters-in-string-vars
https://www.statalist.org/forums/forum/general-stata-discussion/general/1368547-removing-numeric-characters-in-a-string-variable
*/



/***********************/
/* regular expressions */
/***********************/


almost the same as POSIX.2

// match ... of the preceeding expression
// * zero or more
// + one or more
// ? zero or one

// a-z range of char; can be 0-9 or 5-8 or B-D etc; put in set []; see below 
// . any char

// \ escape

// ^ match at the beginning
// $ match at the end

// | or

// [] set; e.g. [a-zA-Z0-9 ], note space !
// () subexpression group

//-----------------------SKIP FROM HERE----------------------

//some explanation below, but you'll really get it with examples further below

//regexm - used to find matching strings, evaluates to one if there is a match, and zero otherwise
//regexs - used to return the nth substring within an expression matched by regexm (hence, regexm must always be run before regexs, note that an "if" is evaluated first even though it appears later on the line of syntax).
//regexr - used to replace a matched expression with something else.

//regexr(source,regular-expression, string to replace) 
//regexr(my_data," bad "," good ")

//------------------------UNTIL HERE------------------------


//this is a key command
//gen <var> = regexs(1) if regexm(<from_var>, "<before pattern>(extract pattern) <after pattern>")
//e.g.
//gen city = regexs(1) if regexm(cit_st_zip, "([A-Za-z ]*)[,]")

display regexm("907-789-3939", "([0-9]*)\-([0-9]*)\-([0-9]*)")
display regexs(0)
display regexs(1)
display regexs(2)
display regexs(3)
//error:
display regexs(4)

clear
input str40 var 
	12jan2003
	1April1995
	17may1977
	02September2000
   joe
   kate
end
l
cap drop date
gen date = regexs(0) if(regexm(var, "^[0-9]+[a-zA-Z]+[0-9]+$"))
l

//---
//How do I remove leading  zeros from string variables?
clear
input  str10 zeros
01
11
110
0210
002200
end
l

gen nozero = regexs(1) if regexm(zeros, "[0]*([1-9][0-9]*)")
l

//another more cumbersome method here
//http://www.stata.com/support/faqs/data/leadingzeros.html  


//!!!! a really good example LETS DO IT (skip weirder ones toward the middle and end starting with names):
//https://stats.idre.ucla.edu/stata/faq/how-can-i-extract-a-portion-of-a-string-variable-using-regular-expressions/



//--------------------SKIP ALL from here (convoluted), better use Py!-------------------------------
//---------------------but if you're stata afficionado, do at home----------------------------

//--- a more complicated example, rather cumbersome...can skim/zip through, but without going into the convoluted detail!
//from http://www.unc.edu/home/danb/data_programming/stata/code/regex.html [dead link now]
clear
input str40 company_name 
"Coca-Cola"
"Coca Cola"
"CocaCola"
"  The Coca-Cola Company"
"Coca-Cola Company, The"
"Coke"
"Coca-Cola Company"
"Johnson & Johnson"
"J & J"
"J&J"
"Johnson and Johnson"
"Johnson & Johnson"
"Johnson&Johnson"
"JPMorgan Chase & Co."
"JPMorgan chase & co"
"JPMorgan chase & co.rpaorotin"
"JP Morgan"
"J.P. Morgan"
"J.P. Morgan Chase & Company"
"Kimberly-Clark Corporation"
"Kimberly  Clark    Corporation"
"Kimberly-Clark Corp."
"Kimberly Clark Corp"
"McKinsey & Company, inc."
"McKinsey & Company, Inc"
"McKinsey & Company,inc."
"McKinsey & Company,Inc"
"McKinsey & Company Inc."
"McKinsey & Company inc"
"McKinsey & Company Incorporated"
"McKinsey & Company"
"McKinsey and Company"
end
l

gen slim_company= trim(company_name)

** Remove "The(space)" only at the beginning of a company name: **
 * The caret symbol "^" when outside brackets "[]" means that the pattern has to be at
 *  the beginning of the string. The caret symbol "^" when inside brackets means 
 *  "match anything except this pattern"/"match anything until this pattern is found".  
 * The order of the characters inside brackets is not revevant. So "^[tThHeE]+ "
 *  would match: "HeT ", "heehTe "... 
 * It is a good idea to use trim() to remove leading and trailing blanks whenever
 *  you are wanting to find patterns at the beginning or end of a string.
 * This does a case insensitive match and only finds the word "the" followed by a space
 *  when it's at the begining of a string. ** 
replace slim_company= regexr(trim(company_name),"^[tT][hH][eE] ","")
list if slim_company != trim(company_name)

** Replace multiple spaces with just one space: **
 * The plus "+" sign after a pattern means to match 1 or more of the previous characters.
*replace slim_company= regexr(slim_company," +"," ")
*replace slim_company= regexr(slim_company," +"," ")
** ... ** 
** This is better done with itrim() as it does all instances not just the first match. **
replace slim_company= itrim(slim_company)
list if slim_company != trim(company_name)


** Remove ", Inc." at the end of company names: **
 * "$" means only when the pattern is at the end of the string. 
 * Patterns like: ", inc.  ", ", Inc. " and ", Inc" will be found. 
 * The period character needs to be preceded by a backslash "\", which is an escape character, 
 *  so that "." is not seen as the metacharacter it is when it is outside brackets "[]".  
 *  A period inside brackets is seen as the period character. **
replace slim_company= regexr(trim(slim_company),"(, |,| )[iI][nN][cC](\.|)$","")
list  if regexm(lower(company_name),"[, ]inc(\.|)$") == 1

gen slim_company2= trim(company_name)
** Remove all versions of ", Inc." at the end of company names: **
 * The asterisk "*" means to match zero or more matches of the previous pattern.
 * The vertical bar "|" means to match the previous pattern or the next pattern.
 * The parentheses create groups of patterns.
 * This will match: " in", " Inc", " inc.", " Corp", " co.", " corporation" (any combination 
 *  of the letters in the brackets so it may make undesired matches): **
replace slim_company2= regexr(trim(company_name),"(\. |, |,| )[incorpatedCRPATIONED]*(\.|)$","")
list company_name slim_company2  if slim_company2 != trim(company_name)
drop slim_company2


** Specifying how the pattern has to start and end helps it from being as messy as this is: **
gen slim_company2= trim(company_name)
replace slim_company2= regexr(trim(company_name),"[incorpatedCRPATIONED]*","")
list company_name slim_company2  if slim_company2 != trim(company_name)
drop slim_company2

list 

** Replace "and" with "&" and make sure "&" is surrounded by spaces: 
 *  regexs(1) is the pattern found with the first set of parentheses in regexm(), 
 *  regexs(2) is the second... **
replace slim_company= regexs(1) + " & " + regexs(3)  if regexm(trim(slim_company),"(^.*)( and |&)(.*$)")
replace slim_company= itrim(slim_company)
list company_name slim_company  if slim_company != trim(company_name)


replace slim_company= regexr(trim(slim_company),"co\.rpaorotin","Co.")
 

** Remove "The " or "the " at the beginning of a string or 
 *  ", The" and ", the" at the end of the string: **
replace slim_company= regexr(trim(slim_company),"([tT]he )|(, [tT]he$)","")
list company_name slim_company  in 1/8


** This is less messy because how the string starts and ends are specified:
replace slim_company= regexr(trim(slim_company),"(\. |, | )[iI]ncorporated$|(\. |, | )[cC]orp[oration]*(\.|)$","")
list company_name slim_company 

replace slim_company= regexr(trim(slim_company),"& [cC]o(\.|)$","& Company")
replace slim_company= regexr(trim(slim_company),"^J & J$","Johnson & Johnson")

** Remove all periods: **
replace slim_company= subinstr(slim_company,".","",.)
list slim_company 

replace slim_company = "Coca-Cola"  if inlist(slim_company,"Coca Cola","CocaCola","Coke","Coca-Cola Company")

replace slim_company = "JPMorgan Chase & Company"  if inlist(slim_company, "JPMorgan chase & Company",  "JP Morgan", "JP Morgan Chase & Company")

replace slim_company = "Kimberly-Clark"  if slim_company == "Kimberly Clark" 

** Create a unique list of company names: **
bysort slim_company: keep if _n == 1
list slim_company

foreach c_name of varlist company_name slim_company { 
  replace `c_name' =  upper(`c_name')
}

list slim_company


*//see here for more http://www.ats.ucla.edu/stat/stata/faq/regex.htm
 


//LATER:
/*
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

l in 1/50

outsheet using "/home/ben/SG.2011/ex.csv", replace comma
*/


*-----------------------------------a practical example-----------------------------

//data comes from lexis nexis
//
//http://www.ncsl.org/research/labor-and-employment/collective-bargaining-legislation-database.aspx

import excel using https://theaok.github.io/dm/2011to2016NCSL.xlsx, sheet(2016) clear
//../upload/2011to2016NCSL.xlsx, sheet(2016) clear

set more off

count
count if (regexm(A, "^0"))
l in 1/100  if (regexm(A, "^0"))

drop if (regexm(A, "^0")) //drop guys that start with 0


l in 1/100


//now the tricky part; identify each obs for reshape

//assuming that each case? number is unique!! this must be true, otherwhise
//this would mess tings up!

gen stateCase=""

foreach s in "AL" "AK" "AZ" "AR" "CA" "CO" "CT" "DE"  "FL" "GA" "HI" "ID" "IL" "IN" "IA" "KS" "KY" "LA" "ME" "MD" "MA" "MI" "MN" "MS" "MO" "MT" "NE" "NV" "NH" "NJ" "NM" "NY" "NC" "ND" "OH" "OK" "OR" "PA" "RI" "SC" "SD" "TN" "TX" "UT" "VT" "VA" "WA" "WV" "WI" "WY"{
//replace state="`s'" if  (regexm(A, "`s'"))
replace stateCase=A if  (regexm(A, "`s'"))
}

l in 1/100

//populate through further

replace stateCase=stateCase[_n-1] if stateCase==""   //(regexm(A, "History: "))


//TODO: check couple at random make sure this is working the way you think it is working!

drop if A==""

//reshape wide A, i(stateCase)j(A) string

//assuming you opnly need status

gen status=""
replace status=A if  (regexm(A, "^Status: "))

keep stateCase status
drop if status==""


//and again double check this !! very likely there are bugs!!

//see more per string practice http://www.ats.ucla.edu/stat/stata/faq/regex.htm

//if html were organized with tables then can use http://www.convertcsv.com/html-table-to-csv.htm

//-------------------------SKIP, doesnt work, LATER fix it-----------------

//-------------------------------text analysis:goodreads example: finding words--------------------------------

//and see pdf

//can also do it better, not just parts of words, but sepaarte words; eg tokenize it forst:
// https://www.reddit.com/r/stata/comments/4xev9t/extracting_n_words_from_a_string/
//or split it!
//https://www.stata.com/manuals13/dsplit.pdf
//
//and then do each word separately matching
//possibly with
//strmatch
//wordcount
//and that way have neatly separte words and can match them
//or this could work in  some way
//list stringvar if strops(stringvar, " INC ") | substr(stringvar, 1, 4) == "INC " | substr(stringvar, -4, 4) == " INC"
//https://www.statalist.org/forums/forum/general-stata-discussion/general/1296929-how-to-find-particular-word-in-string-in-stata

findit egenmore

loc str "Wisteria and Whitford Allgood get kidnapped in the middle of the night and they soon discover that they are a witch and a wizard. The New Order does not allow witches and wizards to exist, Wisteria and Whitford, or Wisty and Whit, are sentenced to death. They soon learn that they have to save the world from the evil New Order. I thought that this was the best book that i have ever read in my life! The only flaw for  it would be how the switches the paragraphs from character to character. It left a little confused in some parts of the story. I would recommend this book to people who like Harry Potter and wizardry or people who just need something, just give it a try."

egen eg= nss(`str') in 6, find("it") insensitive
egen eg2= nss(`str') in 6, find(" it ") insensitive //doesnt work!
egen eg3= noccur(rev) in 6, string(" it ") //works but case sensitive
ta eg
ta eg2
ta eg3


*---------------------------------------------------------------------------------------------------------------------------------
*---------------------------------------------------------------------------------------------------------------------------------
*---------------------------------------------------------------------------------------------------------------------------------
*----------------------_______________SKIP THE FOLLOWING___________________
*---------------------------------------------------------------------------------------------------------------------------------

/*****************/
/* text analysis */
/*****************/

//---word scores

//http://www.tcd.ie/Political_Science/wordscores/
net install http://www.tcd.ie/Political_Science/wordscores/wordscores

//replication dofile http://www.tcd.ie/Political_Science/wordscores/files/APSR_wordscores.do

//paper http://www.kenbenoit.net/pdfs/WORDSCORESAPSR.pdf


/***************/
/* imputations */
/***************/

/* what follows come from: */
/*   http://www.ats.ucla.edu/stat/stata/seminars/missing_data/mi_in_stata_pt1.htm */

use http://www.ats.ucla.edu/stat/stata/seminars/missing_data/hsb2_mar, clear

/* again you should always run the following to see how your data looks like */
des
sum
/* we see that there are some vars with fewer obs -- missing data */


/* let's run a regression */
regress socst write read female math
/* we see that it uses only 145 cases even though we have 145 in our sample */

/* let's store the results */
estimates store cc

/* and now we let's run same regression with full dataset and compare the results */
use http://www.ats.ucla.edu/stat/data/hsb2, clear
regress socst write read female math
estimates store full
estimate table cc full, b se p
/* results are substantively different! */


/* and now let's compare reults with mi   */
use http://www.ats.ucla.edu/stat/stata/seminars/missing_data/mvn_imputation, clear
mi estimate, post: reg socst write read female math
estimates table cc full mvn, b se p
//note that results from mi are not exactly the aame as in full model



/*******************/
/* tips and tricks */
/*******************/

//----------------profile.do

*can put the following into profile.do
help profile

display "Hello world from profile.do"

capture log close statalog

local cdt = "`c(current_date)'"
local cdt: subinstr local cdt " " "-", all

local cti = "`c(current_time)'"
local cti: subinstr local cti ":" ".", all

local statalogname "Stata_Log_Created_on_`cdt'_at_`cti'.log"

noisily display "Saving all results in..."
noisily display "`statalogname'"
log using "`statalogname'" , text name(statal
//----------------













