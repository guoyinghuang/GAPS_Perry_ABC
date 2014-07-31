/*

Title:		Constructing Graphs of positions through  deciles
Project:	Intra-black and black-white Gaps in Adult Outcomes: An Extension of 
			the Perry Program
Authors:	Jake Torcasso, Andrés Hojman, 
Date:		08/02/13

*Comment:   this file is specially tailored for each program becaise of the namings 
*           of the plots and the construction of the inputs (which are continuous variables)

*/

cd ${${prog}_data}
*Use source data of the PSID which is left open by the previous .do file

*Generate the file Earnings_female and Earnings_male to use them as inputs 
*for the graphs. They are simply columns of the different income that we consider

foreach num of numlist 0 1{
		preserve
		
		keep if black == 1 & male == `num'
		keep income_at30 weight
		
		rename income_at30 inc30b
		gen wb30 = weight
		drop weight
		
		gen fakeid = _n
		tempfile black_`num'
		save "`black_`num''", replace
		
		restore
		
		preserve
		
		keep if black == 1 & allkey != 1 & male == `num'
		keep income_at30 weight
		
		rename income_at30 incbld30
		gen wbld30 = weight
		drop weight
		
		gen fakeid = _n
		tempfile blackbld_`num'
		save "`blackbld_`num''", replace
		
		restore
		
		preserve
		
		keep if black == 1 & allkey == 1 & male == `num'
		keep income_at30 weight
		
		rename income_at30 incd30
		gen wd30 = weight
		drop weight
		
		gen fakeid = _n
		tempfile blackd_`num'
		save "`blackd_`num''", replace
		
		restore
		
		preserve
		
		keep if black == 1 & allkey == 1 & male == `num'
		keep tpl_income_at30 weight
		
		rename tpl_income_at30 inctd30
		gen wtd30 = weight 
		drop weight
		
		gen fakeid = _n
		tempfile blacktd_`num'
		save "`blacktd_`num''", replace
		
		restore
		
		preserve
		
		keep if black == 1 & male == `num'
		keep tpl_income_at30 weight
		
		rename tpl_income_at30 incbat30
		gen wbat30 = weight
		drop weight
		
		gen fakeid = _n
		tempfile blackbat_`num'
		save "`blackbat_`num''", replace
		
		restore		
}
	
	*Generate the file Earnings_female and Earnings_male
foreach num of numlist 0 1 {
	preserve
	keep if male == `num'
		keep income_at30 weight 
			gen ww30 = weight
			rename income_at30 incww30 
			gen fakeid = _n
			
			tempfile Earnings_`num'
			save "`Earnings_`num''"
			restore
	}

*Merge the rest of the income variables: black, black non-disadvantaged, etc...
foreach num of numlist 0 1 {
	use `Earnings_`num'', clear
	
	foreach file in black blackbld blackd blacktd blackbat {
	merge 1:1 fakeid using ``file'_`num''
	tab _merge
	drop if _merge == 2
	drop _merge
	
	save "`Earnings_`num''", replace
	
	}
}

*Output as a comma separated sheet. This are simply the incomes 
*by category with their respective weights named in a way that 
*can be looped over to create the graphs

use `Earnings_0', clear
drop fakeid
outsheet using Earnings_female.csv, replace

use `Earnings_1', clear
drop fakeid
outsheet using Earnings_male.csv, replace



//Names for the groups:
local groups b bld d td bat w
local blabel 		"All black"
local bldlabel		"Non-disadvantaged black"
local dlabel		"Disadvantaged black"
local tdlabel		"Disadvantaged black after treatment"
local batlabel		"Black after disadvantaged black treated"
local wlabel		"All white"

local sex male female 

local index =  1
foreach s of local sex {

	insheet using Earnings_`s'.csv, tab clear

	//Renaming variables for convention, so I can loop
	rename inc30b incb30
	rename incww30 incw30

	tempfile alldata
	save `alldata', replace


	//Generating Deciles of income by group by age
	local iteration = 1
	foreach group of local groups {
		
		foreach age of numlist 30 {
		
			use `alldata', clear
			
			keep inc`group'`age' w`group'`age'
			drop if (inc`group'`age' == . & w`group'`age' == .)
			
			xtile decile = inc`group'`age' [fw = w`group'`age'], nquantiles(10)
			
			
			bysort decile: egen Dinc`s'`group'`age' = min(inc`group'`age')

			label var Dinc`s'`group'`age' "Income by decile, age `age', for ``group'label'"
			
			drop inc`group'`age' w`group'`age' 
			duplicates drop
			drop if decile == .
			
			if `iteration' == 1 {
				tempfile decile_data
				save `decile_data', replace
			}
			else {
				merge 1:1 decile using `decile_data', nogen
				save `decile_data', replace
			}
			local iteration = `iteration' + 1
		}
	}

	if `index' == 1 {
		tempfile first_decile_set
		save `first_decile_set', replace
	}
	else {
		merge 1:1 decile using `first_decile_set', nogen
	}
	
	local index = `index' + 1
	
}


*----------------------------*
* Construct decile matrices  *
*----------------------------*


preserve
keep	Dincmalew30 Dincmalebat30 Dincmaleb30
order 	Dincmalew30 Dincmalebat30 Dincmaleb30
mkmat _all, mat(DECmale)

restore
keep 	Dincfemalew30 Dincfemalebat30 Dincfemaleb30
order 	Dincfemalew30 Dincfemalebat30 Dincfemaleb30
mkmat _all, mat(DECfemale)

*----------------------------*
* Construct graphs for males *
*----------------------------*

*we are using ABC
insheet using Earnings_male.csv, clear
matrix DEC = DECmale
	rename inc30b incb30
	rename incww30 incw30

gen d_in_b30=.
gen td_in_bat30=.
gen b_in_w30=.
gen bat_in_w30=.

forvalues r =  1/9{
	replace d_in_b30=`r' 	if incd30 >=DEC[`r',3]&	incd30<DEC[`r'+1,3]
	replace td_in_bat30=`r' if inctd30>=DEC[`r',2]&	inctd30<DEC[`r'+1,2]
	replace b_in_w30=`r' 	if incb30>=DEC[`r',1]&	incb30<DEC[`r'+1,1]
	replace bat_in_w30=`r' 	if incbat30>=DEC[`r',1]&	incbat30<DEC[`r'+1,1]

}
	replace d_in_b30=10 	if incd30>=DEC[10,3]&	incd30!=.
	replace td_in_bat30=10  if inctd30>=DEC[10,2]&	inctd30!=.
	replace b_in_w30=10 	if incb30>DEC[10,1]&	incb30!=.
	replace bat_in_w30=10 	if incbat30>DEC[10,1]&	incbat30!=.


*I will create counterfactual populations for the graphs

foreach y in 30{
gen d_in_b`y'_pre	=d_in_b`y'
gen d_in_b`y'_post	=td_in_bat`y'
gen b_in_w`y'_pre	=b_in_w`y'
gen b_in_w`y'_post	=bat_in_w`y'
}

* * *

local txtlh_d_in_b30 	="|-Disadvantaged Blacks, No Treatment-|"
local txtrh_d_in_b30 	="|--Disadvantaged Blacks, Treatment--|"
local d_in_b30_name 	3


local txtlh_b_in_w30 	="|------All Blacks, No Treatment------|"
local txtrh_b_in_w30 	="|--All Blacks, Disadvantaged Treated--|"
local b_in_w30_name 	4


** Graph 1 **
foreach y in 30 {
	foreach graph in d_in_b`y' b_in_w`y' {
	preserve

	keep if   `graph'!=.
	expand 2, gen(clone)
	gen cf=.
	replace cf=`graph'_pre 		if clone==0
	replace cf=`graph'_post 	if clone==1
	replace cf=`graph'_post+11 	if clone==1

*Creating fake observations so that all values of the deciles (and the empty place at decile 11) are represented in the sample
	count
	local extra = r(N)+21
	set obs `extra'
	forvalues dec = 1/21{
		replace cf=`dec' if _n==r(N)+`dec'
		}

egen denominator=sum(weight)	if cf!=.
gen dens=weight/denominator 	if cf!=.

bysort cf: egen aux=sum(dens)
sum aux
local height=r(max)
local txtht1 =`height'*-1/30
local txtht2 =`height'*-1/13


	local text1 = ""
	local text2 = ""
	local text3 = ""
	local text4 = ""
	local gap=4.8
	forvalues c=1/5{
	local space=`gap'*`c'-3
	local text1=`" `text1' text(`txtht1' `space' `"`c'"') "'
	}
	forvalues c=6/10{
	local space=`gap'*`c'-3
	local text2=`" `text2' text(`txtht1' `space' `"`c'"') "'
	}
	forvalues c=11/15{
	local space=`gap'*`c'+2
	local d=`c'-10
	local text3=`" `text3' text(`txtht1' `space' `"`d'"') "'
	}
	forvalues c=16/20{
	local space=`gap'*`c'+2
	local d=`c'-10
	local text4=`" `text4' text(`txtht1' `space' `"`d'"') "'
	}

	graph bar (sum) dens, over(cf, axis(off line fill ) ) ///
	bar(1, color(gs10) )  ytitle(Frequency  ) allc graphregion(fcolor(white) ) ///
	ylabel(,glcolor(gs14)) ///
	`text2' `text1' `text3' `text4' 			///
	text(`txtht2' 25 "`txtlh_`graph''") 	///
	text(`txtht2' 75 "`txtrh_`graph''") 	///
	text(0 50  "------------------------------------------------------------------------------------------------------------")
	
	cd ${writeup}
	graph export "male``graph'_name'_abc.pdf", as(pdf) replace
	cd ${${prog}_data}
	
	restore
}
} 

*------------------------------*
* Construct graphs for females *
*------------------------------*
matrix DEC = DECfemale

*we are using ABC
insheet using Earnings_female.csv, clear
	rename inc30b incb30
	rename incww30 incw30

gen d_in_b30=.
gen td_in_bat30=.
gen b_in_w30=.
gen bat_in_w30=.

forvalues r =  1/9{

	replace d_in_b30=`r' 	if incd30>=DEC[`r',3]&	incd30<DEC[`r'+1,3]
	replace td_in_bat30=`r' if inctd30>=DEC[`r',2]&	inctd30<DEC[`r'+1,2]

	replace b_in_w30=`r' 	if incb30>=DEC[`r',1]&	incb30<DEC[`r'+1,1]
	replace bat_in_w30=`r' 	if incbat30>=DEC[`r',1]&	incbat30<DEC[`r'+1,1]
}
	replace d_in_b30=10 	if incd30>DEC[10,3]&	incd30!=.
	replace td_in_bat30=10 if inctd30>DEC[10,2]&	inctd30!=.

	replace b_in_w30=10 	if incb30>DEC[10,1]&	incb30!=.
	replace bat_in_w30=10 	if incbat30>DEC[10,1]&	incbat30!=.

*I will create counterfactual populations for the graphs

foreach y in 30{
gen d_in_b`y'_pre	=d_in_b`y'
gen d_in_b`y'_post	=td_in_bat`y'
gen b_in_w`y'_pre	=b_in_w`y'
gen b_in_w`y'_post	=bat_in_w`y'
}

* * *
local txtlh_d_in_b30 	="|-Disadvantaged Blacks, No Treatment-|"
local txtrh_d_in_b30 	="|--Disadvantaged Blacks, Treatment--|"
local d_in_b30_name 	3


local txtlh_b_in_w30 	="|------All Blacks, No Treatment------|"
local txtrh_b_in_w30 	="|--All Blacks, Disadvantaged Treated--|"
local b_in_w30_name 	4


** Graph 1 **
foreach y in 30 {
	foreach graph in d_in_b`y' b_in_w`y' {
	preserve

	keep if   `graph'!=.
	expand 2, gen(clone)
	gen cf=.
	replace cf=`graph'_pre 		if clone==0
	replace cf=`graph'_post 	if clone==1
	replace cf=`graph'_post+11 	if clone==1

*Creating fake observations so that all values of the deciles (and the empty place at decile 11) are represented in the sample
	count
	local extra = r(N)+21
	set obs `extra'
	forvalues dec = 1/21{
		replace cf=`dec' if _n==r(N)+`dec'
		}

egen denominator=sum(weight)	if cf!=.
gen dens=weight/denominator 	if cf!=.

bysort cf: egen aux=sum(dens)
sum aux
local height=r(max)
local txtht1 =`height'*-1/30
local txtht2 =`height'*-1/13

	local text1 = ""
	local text2 = ""
	local text3 = ""
	local text4 = ""
	local gap=4.8
	forvalues c=1/5{
	local space=`gap'*`c'-3
	local text1=`" `text1' text(`txtht1' `space' `"`c'"') "'
	}
	forvalues c=6/10{
	local space=`gap'*`c'-3
	local text2=`" `text2' text(`txtht1' `space' `"`c'"') "'
	}
	forvalues c=11/15{
	local space=`gap'*`c'+2
	local d=`c'-10
	local text3=`" `text3' text(`txtht1' `space' `"`d'"') "'
	}
	forvalues c=16/20{
	local space=`gap'*`c'+2
	local d=`c'-10
	local text4=`" `text4' text(`txtht1' `space' `"`d'"') "'
	}


	graph bar (sum) dens, over(cf, axis(off line fill ) ) ///
	ytitle(Frequency  ) allc graphregion(fcolor(white) ) bar(1, color(gs10) )  ///
	ylabel(,glcolor(gs14)) ///
	`text2' `text1' `text3' `text4' 			///
	text(`txtht2' 23 "`txtlh_`graph''") 	///
	text(`txtht2' 78 "`txtrh_`graph''") 	///
	text(0 50  "------------------------------------------------------------------------------------------------------------")
	
	cd ${writeup}
	graph export "female``graph'_name'_abc.pdf", as(pdf) replace
	cd ${data}
	
	restore
}
} 


