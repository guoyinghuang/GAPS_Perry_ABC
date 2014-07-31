preserve

local regressors 	siblings_atbirth ///
			father_absent relatives_absent welfare_atbirth income_atbirth
local missing 		unstable_work father_edu mother_edu mother_age_atbirth head_lowiq

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

local regressors `regressors' constant

preserve
gen constant = 1
mkmat `regressors', mat(X)
mkmat id, mat(ID)
matrix Zhat = ID, X*(B')
local colnames id `missing'
matrix colnames Zhat = `colnames'
clear
svmat Zhat, names(col)

tempfile imputed_variables
save `imputed_variables', replace

restore

merge 1:1 id using `imputed_variables', nogen update

