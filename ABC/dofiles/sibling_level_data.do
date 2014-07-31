/*
Description:	This dofile runs within generate_psid_data.do immediately
		after individual_data.do generates individual-level data. 
		
		It takes data for the siblings of the target children 
		and maps it back onto the child-level data. 
*/


preserve
keep id age1972 age1973 age1974 age1975 age1976 age1977 behind

foreach v of varlist _all {
	rename `v' `v'_sib
}
tempfile sibling_data
save `sibling_data', replace 
restore


forvalues i = 1/17 {
	qui rename id_sib`i' id_sib
	qui merge m:1 id_sib using `sibling_data', nogen keep(master match)
	foreach v of varlist *_sib {
		qui rename `v' `v'`i'
	}
	gen older_sib`i' = ///
	cond(birthcohort == 1972, age1972_sib`i' > age1972, ///
	cond(birthcohort == 1973, age1973_sib`i' > age1973, ///
	cond(birthcohort == 1974, age1974_sib`i' > age1974, ///
	cond(birthcohort == 1975, age1975_sib`i' > age1975, ///
	cond(birthcohort == 1976, age1976_sib`i' > age1976, ///
	cond(birthcohort == 1977, age1977_sib`i' > age1977, ///
	.))))))
	gen older_behind_sib`i' = (behind_sib`i' == 1) * (older_sib`i' == 1) if ///
	(behind_sib`i' != . & older_sib`i' != .)
	replace older_behind_sib`i' = 0 if id_sib`i' == .
}



egen sibling_behind = rowmax(older_behind_sib*)

label var sibling_behind "Child has an older sibling behind in school at birth"

