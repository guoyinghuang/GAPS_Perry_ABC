*** Imputations-ABC-PSID.do ***
* Author: Andrés (Aug 5,2013)
* Other stars in this project (Impact of ECI's on Population Inequality Gaps): Jake, Jorge

* This .do file imputes in PSID the necessary variables to create a sample that is comparable to ABC

* I am not clear on what is the difference between father0 and hrabc1

* 1. variables used in risk index:	no_father relatives sib_behind wlfare fa_unskilled mo_lowiq referral
* 2. Other pre-treatment variables: 	mo_age mo_edu fa_edu famincome sibnum
* 3. Non-available variables: 		sib_lowiq counseling special



preserve

//Obtaining parameters of LP model in Perry for imputation in the PSID
cd ${dataintermediary}
use "birth12.dta", clear

rename agema0 	mo_age
rename edma0	mo_edu
rename edfa0	fa_edu
rename income_c	famincome
rename sibnum	sibnum

rename hrabc1	no_father
rename hrabc2	relatives
rename hrabc3	sib_behind
rename hrabc4	welfare
rename hrabc5	fa_unskilled
rename hrabc6	mo_lowiq
rename hrabc7	sib_lowiq
rename hrabc8	referral
rename hrabc9	prof_help
rename hrabc10	special

*Variables in the Perry Data
local regressors 	= "mo_age sibnum no_father relatives welfare"
local missing 		= "sib_lowiq prof_help special"

local first = 1
foreach component in  `missing' {
	regress `component' `regressors'
	if `first' == 1 {
		matrix B = e(b)
	}
	else {
		matrix B = B\e(b)
	}
	
	local first = 0
}
restore

//Applying LP parameters to the PSID Data

*Variables in the PSID
local regressors	mother_age_atbirth siblings_atbirth ///
			father_absent relatives_absent welfare_atbirth
local missing		sib_lowiq prof_help special

sum `regressors' 

local regressors `regressors' constant

preserve
gen constant = 1
mkmat `regressors', mat(X)
mkmat id, mat(ID)
matrix Zhat = ID, X*(B')
matrix colnames Zhat = id sib_lowiq prof_help special
clear
svmat Zhat, names(col)

tempfile imputed_risk_variables
save `imputed_risk_variables', replace

restore

merge 1:1 id using `imputed_risk_variables', nogen

/*
gen index=0
replace index=index+8 if mo_edu<=6
replace index=index+7 if mo_edu==7
replace index=index+6 if mo_edu==8
replace index=index+3 if mo_edu==9
replace index=index+2 if mo_edu==10
replace index=index+1 if mo_edu==11

replace index=index+8 if fa_edu<=6
replace index=index+7 if fa_edu==7
replace index=index+6 if fa_edu==8
replace index=index+3 if fa_edu==9
replace index=index+2 if fa_edu==10
replace index=index+1 if fa_edu==11

replace index=index+8 if famincome<1000
replace index=index+7 if famincome>=1001&famincome<=2000
replace index=index+6 if famincome>=2001&famincome<=3000
replace index=index+5 if famincome>=3001&famincome<=4000
replace index=index+4 if famincome>=4001&famincome<=5000
replace index=index+0 if famincome>=5001&famincome<=6000

replace index=index+3 if father0==0
replace index=index+3 if relatives==0
replace index=index+3 if sib_behind==1
replace index=index+3 if welfare==1
replace index=index+3 if fa_unskilled==1
replace index=index+3 if sib_lowiq>=0.5
replace index=index+3 if mo_lowiq==1
replace index=index+3 if referral>=0.5
replace index=index+1 if counseling>=0.5
replace index=index+1 if special>=0.5

keep if index<=11
local pretreat	= "mo_edu sibnum welfare father0"
*/
