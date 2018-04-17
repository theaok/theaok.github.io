
//-------------------------------------------------------------------------------------------
use "https://docs.google.com/uc?id=1W3as-0ijQZSzFCP4-iAjnESSiT6biyIc&export=download", clear


histogram (havedog), by (eatmeat) //aok: good!
/*The graph showed that less people who have a dog eat meat but not necessarily that
people with a dog eat less meat*/

codebook  eatmeat values16

reg eatmeat values16 
//aok: ok makes sense, the more you think that animals need to be treated with dignity/respect the less you eat meat
//aok: need to talk about stats significance! 


//aok: here and below: need to interpret exactly by how much it differes, interpret betas, and stat significance
reg eatmeat male


ta race,gen(R)

d R*

ta R1 race, mi
//I was able to see the number of participants that were white (1) and nonwhite (all other races=0)//

reg eatmeat R1-R6
//this was interesting because all the Rs showed  negative coefficient//

//---------------------------------------------------------------------------------------
use "https://docs.google.com/uc?id=1psJbP1tsWYqk1jn_2XklRSuDWNZt7IAW&export=download", clear
tabulate confed, mi //aok: always add 'mi' option; also this is very usefuL
codebook confed //yeah so 8 and 9 should be made into missing! do similar check on others!!
//aok:codebook relig--this is denomination--so these regresions do not make any sense!
//if anything should be regressing something like 
//ta attend //again, make sure you make missing into dummy  ta attend , nola
regress relig conlabor confed coneduc conclerg conbus confinan
