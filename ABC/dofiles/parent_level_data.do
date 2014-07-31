/*
Description:	This dofile runs within generate_psid_data.do after
		individual_data.do generates individual-level and 
		sibling_level_data.do generates sibling-level data. 
		
		It generates information about the target child's 
		parents and merges this information back onto the
		child-level data. 
*/

cd ${dataintermediary}

tempfile child_data
save `child_data', replace

//b. Datasets containing information on target children's parents and head of FU at birth

local parent father mother head_birth

foreach par of local parent {
	
	*keeping only parent ids matched to target children
	use `child_data', clear
	keep `par'_id
	rename `par'_id id
	keep if id != .
	duplicates drop
	
	*merging in data for parents
	qui merge 1:1 id using psid_all_individuals
	keep if _merge == 3
	drop _merge
	
	*prefixing variable names in `par' datasets
	rename father_id `par'_father_id
	rename mother_id `par'_mother_id
	foreach v of varlist _all {
		if 	("`v'" != "`par'_mother_id" & "`v'" != "`par'_father_id" ) {
			rename `v' `par'_`v'
		}
		
	}
	
	tempfile `par'_data
	save ``par'_data', replace

}


/*
4.	
	Creating child-relative data from Parent (Father and Mother) and 
	Head of Family Unit (FU) Individual Data
**********************************************************************************
*/

foreach par of local parent {

	use `child_data', clear
	qui d *, varlist
	local child_vars `r(varlist)'
	qui merge m:1 `par'_id using ``par'_data', nogen
	
	//The following 'by birth year variables' must be constructed here
	//and not in individual files because they are relative to the 
	//child's birth cohort, not the parents'
	*working status
	gen `par'_works_atbirth = 		cond(birthcohort == 1972, `par'_work1972, 		///
						cond(birthcohort == 1973, `par'_work1973, 		///
						cond(birthcohort == 1974, `par'_work1974, 		///
						cond(birthcohort == 1975, `par'_work1975, 		///
						cond(birthcohort == 1976, `par'_work1976, 		///
						cond(birthcohort == 1977, `par'_work1977, 		///
						.))))))
					
	*low skill occupation
	gen `par'_lowskill_atbirth = 		cond(birthcohort == 1972, `par'_lowskill1972, 		///
						cond(birthcohort == 1973, `par'_lowskill1973, 		///
						cond(birthcohort == 1974, `par'_lowskill1974, 		///
						cond(birthcohort == 1975, `par'_lowskill1975, 		///
						cond(birthcohort == 1976, `par'_lowskill1976, 		///
						cond(birthcohort == 1977, `par'_lowskill1977, 		///
						.))))))
					
	*grade completed
	gen `par'_grade_complet_atbirth = 	cond(birthcohort == 1972, `par'_grade_complet1972, 	///
						cond(birthcohort == 1973, `par'_grade_complet1973, 	///
						cond(birthcohort == 1974, `par'_grade_complet1974, 	///
						cond(birthcohort == 1975, `par'_grade_complet1975, 	///
						cond(birthcohort == 1976, `par'_grade_complet1976, 	///
						cond(birthcohort == 1977, `par'_grade_complet1977, 	///
						.))))))
	
	*absent at birth
	gen `par'_absent_atbirth = 		cond(birthcohort == 1972, `par'_withinFU1972, 		///
						cond(birthcohort == 1973, `par'_withinFU1973, 		///
						cond(birthcohort == 1974, `par'_withinFU1974, 		///
						cond(birthcohort == 1975, `par'_withinFU1975, 		///
						cond(birthcohort == 1976, `par'_withinFU1976, 		///
						cond(birthcohort == 1977, `par'_withinFU1977, 		///
						.))))))
	recode `par'_absent_atbirth (1 = 0) (0 . = 1)
	
	*age at birth
	gen `par'_age_atbirth	=		cond(birthcohort == 1972, `par'_age1972, 		///
						cond(birthcohort == 1973, `par'_age1973, 		///
						cond(birthcohort == 1974, `par'_age1974, 		///
						cond(birthcohort == 1975, `par'_age1975, 		///
						cond(birthcohort == 1976, `par'_age1976, 		///
						cond(birthcohort == 1977, `par'_age1977, 		///
						.))))))
	*Labelling new variables
	label var `par'_lowskill_atbirth 		"`par' in low skill occupation at birth"
	label variable `par'_cognitive1 		"`par' Word-to-Picture Score in 1968"
	label variable `par'_cognitive2 		"`par' Sentence Completion Score (<=13) in 1972"
	label variable `par'_works_atbirth 		"`par' works when child was born"
	label variable `par'_grade_complet_atbirth 	"Graded completed by `par' by child's birth"
	label variable `par'_absent_atbirth 		"`par' not in FU at birth"
	label variable `par'_age_atbirth 		"`par''s age at birth"
	
	keep 	`child_vars' `par'_works_atbirth `par'_cognitive* `par'_head*  `par'_lowskill*birth ///
		`par'_grade_comp*birth `par'_withinFU* `par'_absent* `par'_age_atbirth
		
	save `child_data', replace
}
