local klmshare: env klmshare
display "`klmshare'" 
version 12.0
set more off
clear all

*******************************************************************************************
*******************************************************************************************
/*

Project    : eci_pop 

Description: thi file generates the data source the we use to apply the treatment effects
             for the case of the Perry Preschool Program.

             The file uses the data sources provided by Linor Kiknadze and Seong Moon: 

The files are the following:

			 profile_combined: a data set that has non-missing values of the relevant variables
							   only for the black provided by Seong Moon.
		   profile_combined_1: a data set that has the same structure as profile_combined but 
		                       includes information for white. By some pre-test we trust in the information
							   of profile_combined for the black and in the information of profile_combined_1
							   for the white.
							   
			  NLSY_key       : a data set that flags the disadvantaged individuals (the Perry comparable
			                   sample).
		    earningsFromLinor: a data set that uses the original source that Linor Kiknadze shared with 
			                   us and that is created through the .do file mapLinortoSeong.do. This extracts some 
							   of the outcomes of interest from the dataset with are not in either 
							   profile_combined or profile_combined_1.

*This version: 7/8/2013

*This .do file: Jorge L. García G.-Menéndez
*This project : Jorge L. García G.-Menéndez, Andrés Hojman, Jake Torcasso

*/

*Comments: if you want the representative population of 1979 use cross_sect_weight as weights
*          if you want to use the over-samples groups use weight as weights 
*          (this I need to confirm with Linor)
*          the weights are frequency weights (see NLSY79-cNLSY79_description for more info)
*          family size, I think, is best approximated by number of siblings in 1979

/*
*          the variable year indicates the year of the survey
*          for example, if you do keep if year == 1979 
*          you see that there are 12,686 individuals aged between 14-22
*          exactly what the NLSY79 targeted
*/

/*
           We are interested on indivuduals at ages 27 and 40
		   Note that: if we keep if year == 1988 we get the 
		   representative sample of the 1979 when their median
		   age is 27
		   
		   Likewise: if we keep if year == 2001 the median age is 40
*/ 

*******************************************************************************************
*******************************************************************************************

*Set locations
*In my laptop

/*
global analysis_location = "C:\Users\Jorge\Desktop\Summer2013\HeckmanGroup\ComparingData\NLSYData\Output\"
global data_location     = "C:\Users\Jorge\Desktop\Summer2013\HeckmanGroup\ComparingData\NLSYData\Data\"
global dofiles_location  = "C:\Users\Jorge\Desktop\Summer2013\HeckmanGroup\ComparingData\NLSYData\DoFiles\"
*/

*In klmshare
//Giving global names to all relevant directories
global erc: env erc
global klmshare: env klmshare
cd "${klmshare}"
#delimit ;
cd "ercprojects"; global erc_projects: pwd; cd "ecipop"; global ecipop: pwd; 
cd "Perry"; global perry: pwd; cd "Data"; global data: pwd; 
cd ${erc}; cd "ercprojects"; cd "ecipop"; cd "Perry"; cd "DoFiles"; 
global dofiles: pwd; cd ..; cd ..; cd "Write-up"; global writeup: pwd;
*cd "figures"; global figures: pwd;
#delimit cr

**Need to run this here
cd ${dofiles}
do mapLinortoSeong.do 

*Open the primary data source first version (Seong's)
cd "${data}"
use profile_combined, clear

*Drop Perry individuals to match with the data that flags
*individuals to order them in the different groups
drop if group !=. 
replace id = id - 123

*Merge the .do file that flags the individuals in "weak" profiles
merge 1:1 id using NLSY_key
tab  _merge
drop if _merge !=3
drop _merge
*If the id's are the same we are home free because the merge is perfect

*Merge the earnings from Linor
merge 1:1 id using earningsFromLinor
tab _merge
drop if _merge != 3
drop _merge

*keep individuals for which the weight is keyed
keep if weightkey == 1

*generate a variable with the three restrictions for disadvantaged black
gen allkey = .
replace allkey = 1 if afqtkey == 1 & SESkey == 1 & sibskey == 1

	*Our variables of interest are the following
	*Employment at age 27: empp_27
	*Employment at age 40: empp_40
	*Earnings   at age 27: mearn_bb_27
    *Earnings   at age 40: mearn_bb_40
	*HS indi    at age 19: dedu3_19

*global the pretreatment variables
global pretreat mhgc afqt numsibs welfare_amt
*global the outcomes	
global outcomes dedu3_19 empp_27 inc_27 empp_40 inc_40

*keep relevant variables
keep $outcomes $pretreat id allkey afqtkey SESkey sibskey weightkey black male dedu4_19 dedu5_19 weight famincome79

*Save to temporary memory to merge with the whites information
*Thus, keep only information for black

keep if black == 1

tempfile profile_combined_prov
save "`profile_combined_prov'", replace

*Open the primary data source second version (Seong's)
*to get the white individuals' data 
cd "${data}"
use profile_combined_1, clear

*Drop Perry individuals to match with the data that flags
*individuals to order them in the different groups
drop if group !=. 
replace id = id - 123

*Merge the .do file that flags the individuals in "weak" profiles
merge m:1 id using NLSY_key
tab  _merge
drop if _merge != 3
drop _merge
*If the id's are the same we are home free because the merge is perfect

*Merge the earnings from Linor
merge m:1 id using earningsFromLinor
tab _merge
drop if _merge !=3
drop _merge

*keep individuals for which the weight is keyed
keep if weightkey == 1

*keep only white individuals to append with the information 
*for black
keep if white == 1
keep $outcomes $pretreat id white male dedu4_19 dedu5_19 weight famincome79

*Save to temporary memory to merge with the whites information
tempfile profile_combined_1_prov
save "`profile_combined_1_prov'", replace

append using `profile_combined_prov'

*Fix/Create some variables
replace welfare_amt = 1 if welfare_amt >0
*generate indicator for the non-disadvantaged black
gen nondblack = . 
replace nondblack = 1 if allkey == . & black == 1
*Include some college and college as high school
replace dedu3_19 = 1 if dedu4_19 == 1
replace dedu3_19 = 1 if dedu5_19 == 1

*Open the primary data source first version (Seong's)
cd "${data}"
save SNLSY79, replace
