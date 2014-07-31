/*
Creating dataset of id, earnings at year 1988 and earnings at 2000.
*/

clear all
set more off
//Giving global names to all relevant directories
global klmshare: env klmshare
cd "${klmshare}"
#delimit ;
cd "ercprojects"; global erc_projects: pwd; cd "ecipop"; global ecipop: pwd; 
cd "Perry"; global perry: pwd; cd "Data"; global data: pwd; cd ${ecipop}; 
#delimit cr

cd ${data}

use NLSY79MergedData_llk_short_V3.dta, clear

//Creating Dataset from Years 1988 and 2001
keep if year == 1988 | year == 2001 | year == 1979
gen white = race == 3 if race != .

keep id total_wage_income_V2 year afqt_pre_std_new welfare_amt mhgc numsibs white weight
replace total_wage_income_V2 =  1.12*total_wage_income_V2

tempfile allyears
save `allyears'

//1979 - Baseline Data
keep if year == 1979

keep id afqt_pre_std_new welfare_amt mhgc numsibs white weight
sum afqt_pre_std_new [fw = weight]
gen afqt = (afqt_pre_std_new - `r(mean)' )/`r(sd)'
replace afqt = afqt*15 + 100

drop afqt_pre_std_new weight


tempfile baseline
save `baseline', replace

//1988 Earnings Data
use `allyears', clear
keep if year == 1988

keep id total*

rename total_wage_income_V2 inc_27

tempfile 1988
save `1988', replace

//2001 Earnings Data
use `allyears', clear

keep if year == 2001

keep id total*

rename total_wage_income_V2 inc_40

merge 1:1 id using `1988', nogen
merge 1:1 id using `baseline', nogen
*Merge family income in 1979
merge m:1 id using famincome79
keep if _merge == 3
drop _merge

label var inc_27 "Total annual earnings at age 27, 2010 Dollars"
label var inc_40 "Total annual earnings at age 40, 2010 Dollars"
save earningsFromLinor, replace
