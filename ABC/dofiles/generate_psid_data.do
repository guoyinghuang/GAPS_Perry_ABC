/*
TITLE: 		Generating PSID Data for ECI Population Study
AUTHOR:		Jake Torcasso
DATE:		7/30/13


*/

/*
0.	
	Setting Stata settings and directories.
**********************************************************************************
*/

clear all
set more off
set matsize 11000

//Giving global names to all relevant directories
global erc: env erc
global klmshare: env klmshare
cd "${klmshare}"
#delimit ;
cd "ercprojects"; cd "ecipop"; cd "ABC"; cd "data"; cd "raw"; global dataraw: pwd; cd ..; cd "refined"; 
global datarefined: pwd; cd ..; cd "intermediary"; global dataintermediary: pwd;
cd "${erc}"; cd "ercprojects"; cd "ecipop"; cd "Write-up"; global writeup: pwd; cd ..; 
cd "ABC"; cd "dofiles"; global dofiles: pwd;
#delimit cr

/*
1.a	
	Connect child ids to their parent ids. 
**********************************************************************************
*/

cd ${dofiles}
do fim4576_gid_BA_2_BAL_wide	//getting family id and person number of family members

*Generatin child's ID, mother's ID and father's ID
*flagging for natural mother/father
gen id 				= ER30001*1000 + ER30002
gen father_id 			= ER30001_P_F*1000 + ER30002_P_F
gen naturalfather 		= 1 if father_id != .
replace father_id 		= ER30001_P_AF*1000 + ER30002_P_AF if father_id == .
replace naturalfather	= 0 if (naturalfather == . & father_id != .)
gen mother_id			= ER30001_P_M*1000 + ER30002_P_M
gen naturalmother		= 1 if mother_id != .
replace mother_id		= ER30001_P_AM*1000 + ER30002_P_AM if mother_id == .
replace naturalmother		= 0 if (naturalmother == . & mother_id != .)

label variable id 		"Unique Child ID, Based on 1968 Family ID and Person ID"
label variable father_id	"Father's ID, Based on 1968 Family ID and Person ID"
label variable mother_id 	"Mother's ID, Based on 1968 Family ID and Person ID"
label variable naturalmother	"Child is NOT adopted by Mother"
label variable naturalfather	"Child is NOT adopted by Father"
label define natural 1 "Natural" 0 "Adopted"
label values naturalmother naturalfather natural

keep id father_id mother_id naturalmother naturalfather ER30001

tempfile psid_ids
save `psid_ids', replace

clear

/*
1.b	
	Connect child ids to their sibling's ids. 
**********************************************************************************
*/

cd ${dofiles}
do fim4591_sib_0_wide
drop SEX*
forvalues num = 1/17 {
	if `num' < 10 {
		local sibnum = "0`num'"
	}
	else {
		local sibnum = `num'
	}
	gen id_sib`num' = ID68_S`sibnum' * 1000 + PN_S`sibnum'
	rename TYPE_S`sibnum' type_sib`num'
}
drop ID68* PN_S*
gen id 	= ER30001*1000 + ER30002
drop ER*

merge 1:1 id using `psid_ids', nogen

*sibtype 4 (5) refers to the situation where the mother (father) is unknown
label define sibtype 1 "Full Sibling" 2 "Half Sibling-Mother" 3 "Half Sibling-Father" ///
4 ">=Half Sibling-Mother" 5 ">=Half Sibling-Father" 6 "Other"

label values type_sib* sibtype

save `psid_ids', replace

/*
2.	
	Drawing in data using txt and do files generated from PSID website:
**********************************************************************************
*/
clear
cd ${dofiles}
do custom_draw
gen id = ER30001*1000 + ER30002		//regenerating ids to merge with id data
label variable id "Unique ID, from 1968 family ID and person number"

merge 1:1 id using `psid_ids', nogen 

order id father_id mother_id ER32000 V181

*dropping supplemental latino sample
drop if inrange(ER30001,7001,9308)

//from the family level data and individual data, creating additional
//individual level and sibling level data. 
cd ${dofiles}
do individual_data
do sibling_level_data

*flagging variables
gen keepbyage = .
gen keepbyhead = .

foreach year of numlist 1972/1977 {
	
	*flag for born between 1972 and 1977
	replace keepbyage = 1 if age`year' == 1
	
	*flag if Head of household sometime in 1972 to 1977
	replace keepbyhead = 1 if head`year' == 1
	
}

cd ${dataintermediary}
save psid_all_individuals, replace

/*
3.	
	Flagging target children and setting up data at the child-level 
	for these children. Getting the head of household at child's birth 
	id and the child's relationship to this head and mapping it back
	to the child. 
**********************************************************************************
*/


//A dataset to hold only those that became Heads of FU between 1972 and 1977
preserve
keep if keepbyhead == 1
rename id head_id
keep head_id head19* int19*
tempfile heads1972_1977
save `heads1972_1977', replace
restore

//A dataset to contain data for children born between 1972 and 1977
gen head_birth_id = .
label variable head_birth_id "id of individual's Head of FU at birth"
gen relation_head_birth = .
label variable relation_head_birth "Relationship to Head of FU at birth"
label define vlrelat 	1 "Head" 2 "Wife" 3 "(Step)Child" 4 "Sibling" 5 "Parent" ///
			6 "(Great)Grandchild" 7 "Other Relative" 8 "Nonrelative" ///
			9 "Husband" 
label values relation_head_birth vlrelat
keep if keepbyage == 1
tempfile child_data
save `child_data', replace


*Adding to child data the ids of their FU Head at birth and 
*their relation to that Head
foreach year of numlist 1972/1977 {
	use `heads1972_1977', clear
	keep if head`year' == 1
	keep head_id int`year'
	qui merge 1:m int`year' using `child_data'
	drop if _merge == 1 
	drop _merge
	replace head_birth_id = head_id if age`year' == 1 
	replace relation_head_birth = relhead`year' if age`year' == 1
	drop head_id
	save `child_data', replace
}


order id head_birth_id father_id mother_id relation_head_birth male race
keep 	id mother_id father_id head_birth_id male race birthcohort naturalmother naturalfather ///
	relation_head_birth region_atbirth siblings_atbirth welfare_atbirth income_atbirth	///
	income_at30 cigperday_at30 grade_complet_at30 idle_at30 family_support foodstamp*birth ///
	sibling_behind relatives_absent head_start_attend trouble_read_atbirth need_care_atbirth ///
	dead*30 prison*30 newFU*30 weight*birth cweight*30 lweight*30 black white work_at30 ///
	degree_at30 hs_grad_at30 father_edu mother_edu head_at30 wife_at30

//Generating the parent-level data and mapping it back to the child-level data.	
cd ${dofiles}	
do parent_level_data

/*
4. 		Post-processing the data for comparability with ABC

****************************************************************************************
*/

gen father_empl_risk_atbirth 	= 	(father_lowskill_atbirth == 1 | father_works_atbirth == 0) if ///
					(father_lowskill_atbirth != . | father_works_atbirth != .)

label var father_empl_risk_atbirth "Father has unstable, unskilled, or semiskilled work."

drop 	*withinFU* father_head* mother_absent* head*absent* ///
	mother_head* head_birth_head*

gen head_lowiq = ///
(head_birth_cognitive1 < 10 | head_birth_cognitive2 < 8 | trouble_read_atbirth == 1) if ///
(head_birth_cognitive1 != . | head_birth_cognitive2 != . | trouble_read_atbirth != .)

//renaming variables
gen weight = cweight_at30
rename father_absent_atbirth father_absent
rename father_empl_risk_atbirth unstable_work

//replacing individual data from family questions of Head and Wife's Mother's and Father's Education
replace mother_grade_complet_atbirth = mother_edu if mother_grade_complet_atbirth == .
replace father_grade_complet_atbirth = father_edu if father_grade_complet_atbirth == .
drop father_edu mother_edu
rename mother_grade_complet_atbirth  mother_edu
rename father_grade_complet_atbirth  father_edu

//Imputing variables with many missings within PSID
cd ${dofiles}
do imputewithinpsid

replace unstable_work 	= 1 if unstable_work 	>= 0.5
replace unstable_work 	= 0 if unstable_work 	<  0.5
replace head_lowiq	= 1 if head_lowiq	>= 0.5
replace head_lowiq 	= 0 if head_lowiq	<  0.5

//ABC-like Risk Index
gen mother_edu_weight 	= mother_edu
recode mother_edu_weight (2/6 = 8) (7 = 7) (8 = 6) (9 = 3) (10 = 2) (11 = 1) (12/17 = 0)

gen father_edu_weight 	= father_edu
recode father_edu_weight (2/6 = 8) (7 = 7) (8 = 6) (9 = 3) (10 = 2) (11 = 1) (12/17 = 0)

*Adjusting income to 1972 dollars from 2010 dollars (divide by 5.22)
gen income_w 			= 	income_atbirth/5.22
gen income_weight 		= 	cond(income_w >=0 & income_w <=1000, 8, ///
					cond(income_w <= 2000, 7, ///
					cond(income_w <= 3000, 6, ///
					cond(income_w <= 4000, 5, ///
					cond(income_w <= 5000, 4, ///
					cond(income_w > 5000, 0, ///
					.))))))
//Found in PSID Data
gen father_absent_weight 	= 3 * father_absent
gen relatives_absent_weight 	= 3 * relatives_absent
gen siblings_behind_weight 	= 3 * sibling_behind
gen welfare_weight		= 3 * welfare_atbirth
gen father_empl_risk_weight 	= 3 * unstable_work
gen head_iq_weight 		= 3 * head_lowiq
		
gen fam_assist_weight 		= 3 * foodstamp_atbirth

//Imputation Procedure for Variables Unavailable in PSID
cd ${dofiles}
do Imputations-ABC-PSID
replace sib_lowiq = 1 if sib_lowiq >= 0.5
replace sib_lowiq = 0 if sib_lowiq <  0.5
replace prof_help = 1 if prof_help >= 0.5
replace prof_help = 0 if prof_help <  0.5
replace special   = 1 if special   >= 0.5
replace special   = 0 if special   <  0.5

//Not in PSID, predicted from LP model in Perry, applied to like pretreatment and 
//risk variables in the PSID
gen sib_lowiq_weight		= 3 * sib_lowiq
gen prof_help_weight		= 1 * prof_help
gen special_weight		= 1 * special

global risk_index_variables income_weight father_absent_weight relatives_absent_weight 	///
siblings_behind_weight welfare_weight father_empl_risk_weight head_iq_weight		///
sib_lowiq_weight fam_assist_weight prof_help_weight special_weight

egen abc_risk_index = rowtotal(${risk_index_variables})
label var abc_risk_index "A Risk Index comparable to the ABC, 13-factor Risk Index"
gen allkey = (abc_risk_index > 11 & black == 1) if (black == 1 & abc_risk_index > 11)
label var allkey "allkey = 1 if ABC eligibile & black, by risk index > 11"
gen nondblack = (abc_risk_index <= 11 & black == 1) if (black == 1 & abc_risk_index <= 11)
label var nondblack "1 if black and not ABC eligible"

keep if weight > 0
cd ${datarefined}
save PSID_child_level, replace
