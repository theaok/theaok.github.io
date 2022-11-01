/* tables_examples.do

The tables command was changed substantially in Stata 17.
The new version can do **almost anything**, but it takes time
to master. These examples should help you get started with it.

Paul Jargowsky, August 2022
Revised October 2022


*/
cls
clear

webuse nhanes2l
label var highbp "Blood Pressure"
label define highbp 0 "Normal" 1 "High"
label values highbp highbp

* General structure: 
* table (row stuff) (column stuff) (subtables), statistic(....)

* 1. Frequencies (counts)
* race by sex, then table is re
table (race) (sex) (region)

* 2. Percentages: stat(percent, across(variables))
* In the table specification, "var" represents variables
* and "result" represents different statistics

* Cell percents across entire table 
* Adds to 100 at extreme lower right 
table (race) (sex) (region), ///
	statistic(percent) ///
	nformat(%9.1f  percent ) sformat(%s%%  percent )

* Cell percents within table/subtables
* Adds to 100 at lower right of each subtable
table (race) (sex) (), ///
	statistic(percent) /// <-- is default
	nformat(%9.1f  percent ) sformat(%s%%  percent )
/* same as:
table (race) (sex) (region), ///
	statistic(percent, across(race#sex)) 
	nformat(%9.1f  percent ) sformat(%s%%  percent )
*/

* Row percents (over the columns)
* Adds to 100 at right of every row
table (race) (sex) (region), ///
	statistic(percent, across(sex)) ///
	nformat(%9.1f  percent ) sformat(%s%%  percent )
	
* Column percents (over all rows)
* Adds to 100 at bottow of every column
*   When there is one table
table (race) (sex) (), /// 
	statistic(percent, across(race)) ///
	nformat(%9.1f  percent ) sformat(%s%%  percent )
*   Columns percents over all subtables
*   Adds to 100 in total row of total subtable
table (race) (sex) (region), ///
	statistic(percent, across(race#region)) ///
	nformat(%9.1f  percent ) sformat(%s%%  percent )
*   Column percents over the rows w/in subtables
*   Adds to 100 in total row of all subtables
table (race) (sex) (region), ///
	statistic(percent, across(race)) ///
	nformat(%9.1f  percent ) sformat(%s%%  percent )

* If multiple vars on a row or column, can specify 
* row or column percents over one or both
*   Row percentages over race only
table (region) (sex race) (), ///
	statistic(percent, across(race)) ///
	nformat(%9.1f  percent ) sformat(%s%%  percent )
*   Row percentages over sex only
table (region) (race sex) (), ///
	statistic(percent, across(sex)) ///
	nformat(%9.1f  percent ) sformat(%s%%  percent )
*   Row percentages over both race and sex
table (region) (race sex) (), ///
	statistic(percent, across(race#sex)) ///
	nformat(%9.1f  percent ) sformat(%s%%  percent )
	
* 3. Descriptive Statistics

* Stats on variables (on rows, organized by vars in columns, )
table (race) (result var) (),  ///
	statistic(mean  age height weight) ///
	statistic(sd    age height weight) ///
	nformat(%9.1f  mean) nformat(%9.2f  sd)
	
* Stats on variables (vars over results in columns )
table (race) (var result) (),  ///
	statistic(mean  age height weight) ///
	statistic(sd  age height weight) ///
	nformat(%9.1f  mean) nformat(%9.2f  sd)

* Descriptive Statistics on variables
* Stats on variables (on rows, organized by stat)
table (result var) (sex) (),  ///
	statistic(mean age height weight) ///
	statistic(sd   age height weight) ///
	nformat(%9.1f  mean) nformat(%9.2f  sd)
	
* Stats on variables (on rows, organized by var)
table (var result) (sex) (),  ///
	statistic(mean  age height weight) ///
	statistic(sd  age height weight) ///
	nformat(%9.1f  mean) nformat(%9.2f  sd)
	
* Stats on variables (vars on rows, sex over results on cols)
table (var) (sex result) (),  ///
	statistic(mean  age height weight) ///
	statistic(sd  age height weight) ///
	nformat(%9.1f  mean) nformat(%9.2f  sd)
	
* Stats on variables, stats by table
table (var) (sex) (result),  ///
	statistic(mean  age height weight) ///
	statistic(sd  age height weight) ///
	nformat(%9.1f  mean) nformat(%9.2f  sd)

* Stats on variables, vars by table
table (result) (sex) (var),  ///
	statistic(mean  age height weight) ///
	statistic(sd  age height weight) ///
	nformat(%9.1f  mean) nformat(%9.2f  sd)

* results moved to column
table (race) (sex result) (),  ///
	statistic(mean  age height weight) ///
	statistic(sd  age height weight) ///
	nformat(%9.1f  mean) nformat(%9.2f  sd)

* variables moved to columns
table (race sex) (var result) (),  ///
	statistic(mean  age height weight) ///
	statistic(sd  age height weight) ///
	nformat(%9.1f  mean) nformat(%9.2f  sd)
	

* 4. Combine frequencies, percentages, stats
* Percents = % with & without HBP by Sex	
table (var result) (sex highbp) (),  totals(sex) ///
	statistic(frequency) ///
	statistic(percent, across(highbp)) ///
	statistic(mean  age height weight) ///
	statistic(sd  age height weight) ///
	nformat(%9.1f  percent ) sformat(%s%%  percent ) ///
	nformat(%9.1f  mean) nformat(%9.1f  sd) style(Table-1)

	
	
* Just those with high blood pressure 
table (var result) ( highbp[1] sex ) (), totals(sex) ///
	statistic(frequency) ///
	statistic(percent, across(highbp)) ///
	statistic(mean  age height weight) ///
	statistic(sd  age height weight) ///
	nformat(%9.1f  percent ) sformat(%s%%  percent ) ///
	nformat(%9.1f  mean) nformat(%9.1f  sd)
	* Note: in this table, the percents are 
	* percent of males and females *with* high
	* blood pressure (compare to previous table).
	* It doesn't add to 100 in any direction. 
	* You implicitly know that the percent w/out
	* HBP is 1-p.
	* This can't be done using "if highbp== 1", because 
	* the base is not included (all males, all females)

* Use "if" to limit to people with HBP only
table (var result) (sex) () if highbp ==  1, totals(sex) ///
	statistic(frequency) ///
	/* statistic(percent, across(highbp)) */  /// <- causes error
	statistic(mean  age height weight) ///
	statistic(sd  age height weight) ///
	nformat(%9.1f  percent) sformat(%s%%  percent ) ///
	nformat(%9.1f  mean) nformat(%9.1f  sd) 
	* You can't get the incidence of HBP, but the
	* statistics are correct. (Compare to above.)


* 5. (More advanced) Table of Hypothesis Tests
table (command) (result), ///
	command(Males=r(P1) Females=r(P2) Difference=r(P_diff) r(p): ///
	prtest diabetes, by(sex)) ///
		command(Males=r(P1) Females=r(P2) Difference=r(P_diff) r(p): ///
	prtest heartatk, by(sex)) ///
		command(Males=r(P1) Females=r(P2) Difference=r(P_diff) r(p): ///
	prtest highbp, by(sex)) ///
	nformat(%5.3f) style(table-right)
* Fix up labels.
collect label levels command 1 "Diabetes" 2 "Heart attack" 3 "High BP", modify
collect label levels result p "p-value", modify
collect preview

