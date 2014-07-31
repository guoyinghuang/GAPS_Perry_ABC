/*
Description:

This do-file works inside generate_psid_data.do. 

It creates data for individuals (a lot of it missing
because I am targetting people born between 1972 and 1977, a later 
follow-up around age 30, and their parents at birth), which I 
can then later differentiate between the child's , father, FU
Head or the child himself. 


*/


//renaming and labelling variables
rename V2828 race		//race of Head in 1972
label define vlrace 1 "White" 2 "Black" 3 "Hispanic" 7 "Other"
label values race vlrace
label variable race "Race of id individual, 1=White, 2=Black, 3=Hispanic, 7=Other"
gen male = ER32000 == 1 if ER32000 != .
label define vlmale 1 "Male" 0 "Female" 
label values male vlmale
label variable male "Sex of id individual, 1=Male, 0=Female"
gen black = race == 2 if race == 2
gen white = race == 1 if race == 1
label var black "Black = 1"
label var white "White = 1"

//age by year (=1 if <=1 years old in year)
gen age1972	=	ER30094 
gen age1973	=	ER30120 
gen age1974	=	ER30141 
gen age1975	=	ER30163 
gen age1976	=	ER30191 
gen age1977	=	ER30220

forvalues year = 1972/1977 {
	label var age`year' "Age in year `year'"
}

//Birth cohort
gen birthcohort = 	cond(age1972 == 1, 1972, ///
			cond(age1973 == 1, 1973, ///
			cond(age1974 == 1, 1974, ///
			cond(age1975 == 1, 1975, ///
			cond(age1976 == 1, 1976, ///
			cond(age1977 == 1, 1977, ///
			.))))))
			
label variable birthcohort "Year child was born"


//interview numbers by year (same within FU)
gen int1972	=	ER30091
gen int1973	=	ER30117
gen int1974	=	ER30138
gen int1975	=	ER30160
gen int1976	=	ER30188
gen int1977	=	ER30217

forvalues year = 1972/1977 {
	label var age`year' "Interview number in year `year'"
}

//sequence numbers by year (=1 if Head)
gen seq1969 	=	ER30021
gen seq1970 	= 	ER30044
gen seq1971	=	ER30068
gen seq1972	=	ER30092 		
gen seq1973	=	ER30118
gen seq1974	=	ER30139
gen seq1975	=	ER30161
gen seq1976	=	ER30189
gen seq1977	=	ER30218
gen seq1978	= 	ER30247
gen seq1979 	= 	ER30284
gen seq1980 	= 	ER30314

gen seq1999 	= 	ER33502
gen seq2001 	= 	ER33602
gen seq2003 	= 	ER33702
gen seq2005	=	ER33802
gen seq2007 	= 	ER33902
gen seq2009	= 	ER34002
gen seq2011 	=	ER34102

forvalues year = 1969/2011 {
	local v = "seq`year'"
	di "`v'"
	capture confirm variable `v'
	if !_rc {
		label var `v' "Sequence number in year `year'"
	}
}

//relationship to head by year
*1=Head, 2=Wife, 3=(Step)Child, 4=Sibling, 5=Parent, 6=(Great)Grandchild
*7=Other Relative, 8=Nonrelative, 9=Husband
gen relhead1968 = 	ER30003
gen relhead1969 = 	ER30022
gen relhead1970 = 	ER30045
gen relhead1971 = 	ER30069
gen relhead1972 =	ER30093	
gen relhead1973 = 	ER30119
gen relhead1974 = 	ER30140
gen relhead1975 = 	ER30162
gen relhead1976 =	ER30190
gen relhead1977 = 	ER30219
gen relhead1978 = 	ER30248
gen relhead1979 = 	ER30285
gen relhead1980 = 	ER30315

*10=Head, 20=Legal Wife, 22="Wife"/Cohabitator, 30=(Adopted)Child, 33=Stepchild
*35=Child of "wife", 37=Son/Daughter in law, 38=Foster child, 40=Sibling, 
*47=Sibling in law, 48=Sibling of cohabitator, ...see codebook
gen relhead1999 = 	ER33503
gen relhead2001 = 	ER33603
gen relhead2003 = 	ER33703
gen relhead2005 = 	ER33803
gen relhead2007 = 	ER33903
gen relhead2009 = 	ER34003
gen relhead2011 = 	ER34103

forvalues year = 1968/2011 {
	local v = "relhead`year'"
	capture confirm variable `v'
	if !_rc {
		label var `v' "Relation to head in year `year'"
	}
}

//Longitudinal - Individual Weights
gen lweight1972  =	ER30116
gen lweight1973  = 	ER30137
gen lweight1974  = 	ER30159
gen lweight1975  = 	ER30187
gen lweight1976  = 	ER30216
gen lweight1977  = 	ER30245

gen lweight2001  =	ER33637
gen lweight2003  =	ER33740
gen lweight2005  = 	ER33848
gen lweight2007  = 	ER33950

forvalues year = 1968/2011 {
	local v = "lweight`year'"
	capture confirm variable `v'
	if !_rc {
		label var `v' "Longitudinal weight in year `year'"
	}
}

//Cross-sectional - Individual Weights
gen cweight2001  = 	ER33639
gen cweight2003  = 	ER33742
gen cweight2005  = 	ER33849
gen cweight2007  = 	ER33951

forvalues year = 1968/2011 {
	local v = "cweight`year'"
	capture confirm variable `v'
	if !_rc {
		label var `v' "Cross-sectional weight in year `year'"
	}
}

//In the Family Unit and In institution or Dead, by Year
foreach year of numlist 1968/2011 {
	capture confirm variable seq`year'
	if !_rc {
		gen withinFU`year'	= inrange(seq`year',1,20) == 1 if inlist(seq`year',.,0) == 0
		label var withinFU`year' "Within FU in year `year'"
		gen prison`year'  	= inrange(seq`year',51,59) == 1 if inlist(seq`year',.,0) == 0
		label var prison`year' "In Institution in year `year'"
		gen dead`year'	   	= inrange(seq`year',81,89) == 1 if inlist(seq`year',.,0) == 0
		label var dead`year' "Dead in year `year'"
		gen newFU`year'    	= inrange(seq`year',71,80) == 1 if inlist(seq`year',.,0) == 0
		label var newFU`year' "In new FU in year `year'"	
	}
	if `year' == 1968 {
		gen withinFU`year' = 	inrange(relhead`year',1,7) == 1 if inlist(relhead`year',.,9,0) == 0
		label var withinFU`year' "Within FU in year `year'"
	}
	
}

local statuses prison dead newFU withinFU
foreach status of local statuses {
	gen `status'_at30 = 	cond(birthcohort == 1972, `status'2001, ///
				cond(birthcohort == 1973, `status'2003, ///
				cond(birthcohort == 1974, `status'2003, ///
				cond(birthcohort == 1975, `status'2005, ///
				cond(birthcohort == 1976, `status'2005, ///
				cond(birthcohort == 1977, `status'2007, ///
				.))))))
}

//Weights by age
gen cweight_at30 	= 	cweight2003
label var cweight_at30		"2003 individual cross-sectional weight for core/immigrants"

gen lweight_at30 	=	lweight2003
label var lweight_at30  	"2003 longitudinal weight for core/immigrants"
				
gen weight_atbirth	=	cond(birthcohort == 1972, lweight1972, ///
				cond(birthcohort == 1973, lweight1973, ///
				cond(birthcohort == 1974, lweight1974, ///
				cond(birthcohort == 1975, lweight1975, ///
				cond(birthcohort == 1976, lweight1976, ///
				cond(birthcohort == 1977, lweight1977, ///
				.))))))


//Creating indicators for wife of head and is head, by year
foreach year of numlist 1968/2011 {
	capture confirm variable relhead`year'
	if !_rc{
		if `year' == 1968 {
			* Is Wife of Head
			gen wife`year' = 	relhead`year' == 2 if inlist(relhead`year',.,9,0) == 0
			
			*Is Head
			gen head`year' = 	relhead`year' == 1 if inlist(relhead`year',.,9,0) == 0
		}
		else if `year' <= 1980 {
			
			* Is Wife of Head
			gen wife`year' = 	relhead`year' == 2 if inlist(relhead`year',.,9,0) == 0
			
			*Is Head
			gen head`year' = 	(relhead`year' == 1 & seq`year' == 1) ///
						if (inlist(relhead`year',.,9,0) == 0 & ///
						inlist(seq`year',.,0) == 0)
		}
		if `year' >= 1999 {
			
			* Is Wife of Head
			gen wife`year' = 	inlist(relhead`year',22,20) == 1 ///
						if inlist(relhead`year',0,.) == 0
			
			* Is Head
			gen head`year' = 	(relhead`year' == 10 & seq`year' == 1) ///
						if (inlist(relhead`year',0,.) == 0 & ///
						inlist(seq`year',0,.) == 0)
		}
		label var wife`year' "Wife of Head in year `year'"
		label var head`year' "Head in year `year'"
	}
}

gen head_at30 = 		cond(birthcohort == 1972, head2001, ///
				cond(birthcohort == 1973, head2003, ///
				cond(birthcohort == 1974, head2003, ///
				cond(birthcohort == 1975, head2005, ///
				cond(birthcohort == 1976, head2005, ///
				cond(birthcohort == 1977, head2007, ///
				.))))))
				
gen wife_at30 = 		cond(birthcohort == 1972, wife2001, ///
				cond(birthcohort == 1973, wife2003, ///
				cond(birthcohort == 1974, wife2003, ///
				cond(birthcohort == 1975, wife2005, ///
				cond(birthcohort == 1976, wife2005, ///
				cond(birthcohort == 1977, wife2007, ///
				.))))))


//Indicator for Head works by year
*1=Working, 2=Unemployed, 3=Retired/disabled, 4=Housewife, 5=Student, 6=Other
gen headwork1972 = 	V2581 == 1 if V2581 != .
gen headwork1973 = 	V3114 == 1 if V3114 != .
gen headwork1974 = 	V3528 == 1 if V3528 != .
gen headwork1975 = 	V3967 == 1 if V3967 != .
gen headwork1976 = 	V4458 == 1 if V4458 != .
gen headwork1977 = 	V5373 == 1 if V5373 != .

*1=Working, 2=Temp. lay off, 3=Unemployed, 4=Retired, 5=Permanently disabled, 6=Housewife
*7=Student, 8=Other
gen headwork2001 =	ER33612 == 1 if inlist(ER33612,.,9,0) == 0
gen headwork2003 =	ER21123 == 1 if inlist(ER21123,.,9,0) == 0
gen headwork2005 =	ER25104 == 1 if inlist(ER25104,.,9,0) == 0
gen headwork2007 =	ER36109 == 1 if inlist(ER36109,.,9,0) == 0

forvalues year = 1968/2011 {
	local v = "headwork`year'"
	capture confirm variable `v'
	if !_rc {
		label var `v' "Head works in year `year'"
	}
}

//Indicator for Wife of head works by year
*1=Working, 2=Temp. lay off, 3=Unemployed, 4=Retired, 5=Permanently disabled, 6=Housewife
*7=Student, 8=Other
gen wifework2003 =	ER21373 == 1 if inlist(ER21373,.,99,0) == 0
gen wifework2005 =	ER25362 == 1 if inlist(ER25362,.,99,0) == 0
gen wifework2007 =	ER36367	== 1 if inlist(ER36367,.,99,32,0) == 0

forvalues year = 1968/2011 {
	local v = "wifework`year'"
	capture confirm variable `v'
	if !_rc {
		label var `v' "Wife of Head works in year `year'"
	}
}

//Indicator for working
foreach year of numlist 1972/1977 {
	
	*Works if Head works and is Head
	capture confirm variable headwork`year' head`year'
	if !_rc {
		gen work`year' = headwork`year' if head`year' == 1
		label variable work`year' "Working in year `year'"
	}
	
	*Works if Wife of Head works and is Wife of Head
	capture confirm variable wifework`year' wife`year'
	if !_rc {
		replace work`year' = wifework`year' if wife`year' == 1
	}
}


//Individual level working status
gen work1999 = 		ER33512 == 1 if inlist(ER33512,.,9,0) == 0
gen work2001 = 		ER33612 == 1 if inlist(ER33612,.,9,0) == 0
gen work2003 = 		ER33712 == 1 if inlist(ER33712,.,9,0) == 0
gen work2005 = 		ER33813 == 1 if inlist(ER33813,.,9,0) == 0
gen work2007 = 		ER33913 == 1 if inlist(ER33913,.,9,0) == 0
gen work2009 = 		ER34016 == 1 if inlist(ER34016,.,9,0) == 0
gen work2011 = 		ER34116 == 1 if inlist(ER34116,.,9,0) == 0

foreach year of numlist 2001(2)2011 {
	label var work`year' "Working in year `year'"
}

gen work_at30    =	cond(birthcohort == 1972, work2001, ///
			cond(birthcohort == 1973, work2003, ///
			cond(birthcohort == 1974, work2003, ///
			cond(birthcohort == 1975, work2005, ///
			cond(birthcohort == 1976, work2005, ///
			cond(birthcohort == 1977, work2007, ///
			.))))))
label var work_at30  "Employed at 30"

//Indicator for Idleness of Head by year
*1=Working, 2=Unemployed, 3=Retired/disabled, 4=Housewife, 5=Student, 6=Other
gen headidle1972 = 	inlist(V2581,1,5) == 0 if V2581 != .
gen headidle1973 = 	inlist(V3114,1,5) == 0 if V3114 != .
gen headidle1974 = 	inlist(V3528,1,5) == 0 if V3528 != .
gen headidle1975 = 	inlist(V3967,1,5) == 0 if V3967 != .

*1=Working, 2=temp. lay off, 3=look for work, 4=retired/perm. disabled, 5=perm. disabled
*6=housewife, 7=student, 8=other
gen headidle1976 = 	inlist(V4458,1,7) == 0 if V4458 != .
gen headidle1977 = 	inlist(V5373,1,7) == 0 if V5373 != .

*1=Working, 2=Temp. lay off, 3=Unemployed, 4=Retired, 5=Permanently disabled, 6=Housewife
*7=Student, 8=Other
gen headidle2001 =	inlist(ER33612,1,7) == 0 if inlist(ER33612,9,0,.) == 0
gen headidle2003 =	inlist(ER21123,1,7) == 0 if inlist(ER21123,99,0,.,22) == 0
gen headidle2005 =	inlist(ER25104,1,7) == 0 if inlist(ER25104,99,0,.) == 0
gen headidle2007 =	inlist(ER36109,1,7) == 0 if inlist(ER36109,99,98,.) == 0

forvalues year = 1968/2011 {
	local v = "headidle`year'"
	capture confirm variable `v'
	if !_rc {
		label var `v' "Head not working or studying in year `year'"
	}
}

//Indicator for Wife of head is idle by year
*1=Working, 2=Temp. lay off, 3=Unemployed, 4=Retired, 5=Permanently disabled, 6=Housewife
*7=Student, 8=Other
gen wifeidle2003 =	inlist(ER21373,1,7) == 0 if inlist(ER21373,99,0,.) == 0
gen wifeidle2005 =	inlist(ER25362,1,7) == 0 if inlist(ER25362,99,0,.) == 0
gen wifeidle2007 =	inlist(ER36367,1,7) == 0 if inlist(ER36367,99,0,.,32) == 0

forvalues year = 1968/2011 {
	local v = "wifeidle`year'"
	capture confirm variable `v'
	if !_rc {
		label var `v' "Wife not working or studying in year `year'"
	}
}

//Indicator for idle
foreach year of numlist 1972/1977 {
	
	*Works if Head works and is Head
	capture confirm variable headidle`year' head`year'
	if !_rc {
		gen idle`year' = headidle`year' if head`year' == 1
		label variable idle`year' "Not working or studying in year `year'"
	}
	
	*Works if Wife of Head works and is Wife of Head
	capture confirm variable wifeidle`year' wife`year'
	if !_rc {
		replace idle`year' = wifeidle`year' if wife`year' == 1
	}
}

//Individual level idleness
gen idle2001 = 		inlist(ER33612,1,7) == 0 if inlist(ER33612,9,0,.) == 0
gen idle2003 = 		inlist(ER33712,1,7) == 0 if inlist(ER33712,9,0,.) == 0
gen idle2005 = 		inlist(ER33813,1,7) == 0 if inlist(ER33813,9,0,.) == 0
gen idle2007 = 		inlist(ER33913,1,7) == 0 if inlist(ER33913,9,0,.) == 0
gen idle2009 = 		inlist(ER34016,1,7) == 0 if inlist(ER34016,9,0,.) == 0
gen idle2011 = 		inlist(ER34116,1,7) == 0 if inlist(ER34116,9,0,.) == 0

foreach year of numlist 2001(2)2011 {
	label var idle`year' "Not working or studying in year `year'"
}

gen idle_at30 = 	cond(birthcohort == 1972, idle2001, ///
			cond(birthcohort == 1973, idle2003, ///
			cond(birthcohort == 1974, idle2003, ///
			cond(birthcohort == 1975, idle2005, ///
			cond(birthcohort == 1976, idle2005, ///
			cond(birthcohort == 1977, idle2007, ///
			.))))))
label var idle_at30 "Not working or studying in year `year'"

//Occupation
gen head_occ1972 = 	V2583 if inlist(V2583,99,0,.) == 0
gen head_occ1973 = 	V3116 if inlist(V3116,99,0,.) == 0
gen head_occ1974 = 	V3531 if inlist(V3531,99,0,.) == 0
gen head_occ1975 = 	V3969 if inlist(V3969,99,0,.) == 0
gen head_occ1976 = 	V4460 if inlist(V4460,99,0,.) == 0
gen head_occ1977 = 	V5375 if inlist(V5375,99,0,.) == 0

foreach year of numlist 1972/1977 {

	gen lowskill`year' = ///
	inlist(head_occ`year',11,21,30,31,32,33,34,40,41,42,43,49,55,56,61,83,84) == 1 if head_occ`year' != .
	label var lowskill`year' "Head in low skill occupation in year `year'"
}

//Cigarettes smoked per day (for wife and head of wife)
gen cighead2001 = 	ER19709 if inlist(ER19709,998,999,.) == 0
gen cigwife2001 = 	ER19817 if inlist(ER19817,998,999,115,154,.) == 0
gen cighead2003 = 	ER23124 if inlist(ER23124,998,999,.) == 0
gen cigwife2003 = 	ER23251 if inlist(ER23251,998,999,.) == 0
gen cighead2005 = 	ER27099 if inlist(ER27099,998,999,.) == 0
gen cigwife2005 = 	ER27222 if inlist(ER27222,998,999,.) == 0
gen cighead2007 = 	ER38310 if inlist(ER38310,998,999,.) == 0
gen cigwife2007 =	ER39407 if inlist(ER39407,998,999,.) == 0

//Cigarettes per day by year
foreach year of numlist 2001 2003 2005 2007 {
	
	gen cigperday_yr`year' = cighead`year' if head`year' == 1
	replace cigperday_yr`year' = cigwife`year' if wife`year' == 1
	label var cigperday_yr`year' "Cigarettes smoked per day in year `year'"
}

gen cigperday_at30 = 	cond(birthcohort == 1972, cigperday_yr2001, ///
			cond(birthcohort == 1973, cigperday_yr2003, ///
			cond(birthcohort == 1974, cigperday_yr2003, ///
			cond(birthcohort == 1975, cigperday_yr2005, ///
			cond(birthcohort == 1976, cigperday_yr2005, ///
			cond(birthcohort == 1977, cigperday_yr2007, ///
			.))))))
label var cigperday_at30 "Cigarettes smoked per day at age 30"

//Ability (sentence completion, Ammon's quick test)

gen cognitive1 = V195 if (head1968 == 1 & inlist(V195,99,98,.) == 0) 
label variable cognitive1 "Word-to-picture Score - 1968"
gen cognitive2 = V2949 if head1972 == 1
label variable cognitive2 "Sentence completion test, number correct/13 - 1972"


//Region of Family Unit (FU)

gen region1972 = 	V2911 if inlist(V2911,9,.) == 0
gen region1973 = 	V3279 if inlist(V3279,9,.) == 0
gen region1974 = 	V3699 if inlist(V3699,9,.) == 0
gen region1975 = 	V4178 if inlist(V4178,9,.) == 0
gen region1976 = 	V5054 if inlist(V5054,9,.) == 0
gen region1977 = 	V5633 if inlist(V5633,9,.) == 0

forvalues year = 1968/2011 {
	local v = "region`year'"
	capture confirm variable `v'
	if !_rc {
		label var `v' "Region of FU in year `year'"
	}
}

gen region_atbirth = 	cond(birthcohort == 1972, region1972, ///
			cond(birthcohort == 1973, region1973, ///
			cond(birthcohort == 1974, region1974, ///
			cond(birthcohort == 1975, region1975, ///
			cond(birthcohort == 1976, region1976, ///
			cond(birthcohort == 1977, region1977, ///
			.))))))

label variable region_atbirth "Location (broad region) of Family Unit in year `year'"
label define vlreg 	1 "Northeast" 2 "North Central" 3 "South" 4 "West" ///
				5 "Alaska, Hawaii" 6 "Foreign Country"
label values region_atbirth vlreg

//Siblings in the Family Unit at birth

foreach year of numlist 1972/1977 {
	egen siblings`year' = count(id) if (relhead`year' == 3 | relhead`year' == 6), ///
	by(int`year' relhead`year')
	
	replace siblings`year' = siblings`year' - 1
	
}

gen siblings_atbirth = 	cond(birthcohort == 1972, siblings1972, ///
			cond(birthcohort == 1973, siblings1973, ///
			cond(birthcohort == 1974, siblings1974, ///
			cond(birthcohort == 1975, siblings1975, ///
			cond(birthcohort == 1976, siblings1976, ///
			cond(birthcohort == 1977, siblings1977, ///
			.))))))
			
label var siblings_atbirth "Number of siblings child has (in FU) at birth"

//Foodstamps

*Money saved using foodstamps
gen foodstamp1970  = 	V1183
gen foodstamp1971  =	V1884
gen foodstamp1972  = 	V2478	//actually from 1971, 1972 not available
gen foodstamp1973  = 	V3443
gen foodstamp1974  = 	V3851
gen foodstamp1975  = 	V4364
gen foodstamp1976  = 	V5279 if inlist(V5279,99,.) == 0
gen foodstamp1977  = 	V5778 if inlist(V5778,99,.) == 0

gen foodstamp_atbirth = 	cond(birthcohort == 1972 & foodstamp1972 != ., foodstamp1972 > 0, ///
				cond(birthcohort == 1973 & foodstamp1973 != ., foodstamp1973 > 0, ///
				cond(birthcohort == 1974 & foodstamp1974 != ., foodstamp1974 > 0, ///
				cond(birthcohort == 1975 & foodstamp1975 != ., foodstamp1975 > 0, ///
				cond(birthcohort == 1976 & foodstamp1976 != ., foodstamp1976 > 0, ///
				cond(birthcohort == 1977 & foodstamp1977 != ., foodstamp1977 > 0, ///
				.))))))

label var foodstamp_atbirth "Family supported by food stamps at child's birth"

// Use of Welfare

*Income from other welfare
gen othwelfare1970 = 	V1211
gen othwelfare1971 = 	V1913
gen othwelfare1972 =	V3067
gen othwelfare1973 = 	V3479 
gen othwelfare1974 = 	V3879
gen othwelfare1975 = 	V4394
gen othwelfare1976 = 	V5305
gen othwelfare1977 = 	V5805

foreach year of numlist 1970/1977 {
	gen welfare`year' = 	othwelfare`year' > 0  if othwelfare`year' != . 
}

foreach year of numlist 1972/1977 {
	local twoyearsago = `year' - 2
	local oneyearago  = `year' - 1
	replace welfare`year' = welfare`twoyearsago' if (welfare`year' == 0 | welfare`year' == .)
	replace welfare`year' = welfare`oneyearago'  if (welfare`year' == 0 | welfare`year' == .) 
}

gen welfare_atbirth = 	cond(birthcohort == 1972, welfare1972, ///
			cond(birthcohort == 1973, welfare1973, ///
			cond(birthcohort == 1974, welfare1974, ///
			cond(birthcohort == 1975, welfare1975, ///
			cond(birthcohort == 1976, welfare1976, ///
			cond(birthcohort == 1977, welfare1977, ///
			.))))))

label variable welfare_atbirth "Head of FU or Wife of Head Recieved Welfare within 3yrs prior to child's birth"


//Family Income (updating to 2010 dollars ~ See www.bls.gov)
gen familyincome1969 =	5.94 * V1514 if V1514 != .
gen familyincome1970 = 	5.62 * V2226 * (V2226 > 1) if V2226 != .
gen familyincome1971 = 	5.38 * V2852 * (V2852 > 1) if V2852 != .
gen familyincome1972 = 	5.22 * V3256 * (V3256 > 1) if V3256 != .
gen familyincome1973 = 	4.91 * V3676 * (V3676 > 1) if V3676 != .
gen familyincome1974 = 	4.42 * V4154 * (V4154 > 1) if V4154 != .
gen familyincome1975 = 	4.05 * V5029 * (V5029 > 1) if V5029 != .
gen familyincome1976 =	3.83 * V5626 * (V5626 > 1) if V5626 != .
gen familyincome1977 =	3.60 * V6173 * (V6173 > 1) if V6173 != .
gen familyincome1978 =	3.34 * V6766 * (V6766 > 1) if V6766 != .
gen familyincome1979 = 	3.00 * V7412 * (V7412 > 1) if V7412 != .
gen familyincome1980 = 	2.65 * V8065 * (V8065 > 1) if V8065 != .

forvalues year = 1968/2011 {
	local v = "familyincome`year'"
	capture confirm variable `v'
	if !_rc {
		label var `v' "Family income ($2010) in year `year'"
	}
}

foreach year of numlist 1972/1977 {
	local v familyincome
	local prior = `year' - 1
	local next  = `year' + 1
	egen family_inc`year' = rowmean(`v'`prior' `v'`next' `v'`year')
} 	

gen income_atbirth = 	cond(birthcohort == 1972, family_inc1972, ///
			cond(birthcohort == 1973, family_inc1973, ///
			cond(birthcohort == 1974, family_inc1974, ///
			cond(birthcohort == 1975, family_inc1975, ///
			cond(birthcohort == 1976, family_inc1976, ///
			cond(birthcohort == 1977, family_inc1977, ///
			.))))))

label var income_atbirth "Three year average of annual family income around child's birth year ($ 2010)"

//Child support
gen childsupport1971 = 	V2863 > 0 if V2863 != .
gen childsupport1972 = 	V3267 > 0 if V3267 != .
gen childsupport1973 = 	V3687 > 0 if V3687 != .
gen childsupport1974 = 	V4165 > 0 if V4165 != .
gen childsupport1975 = 	V5041 > 0 if V5041 != .
gen childsupport1976 = 	V5310 > 0 if V5310 != .
gen childsupport1977 = 	V5810 > 0 if V5810 != .
gen childsupport1978 = 	V6421 > 0 if V6421 != .

//Annual Labor Income Adjusted to 2010 Dollars
gen headlabinc1996 = 	1.39*ER12080
gen wifelabinc1996 = 	1.39*ER12082
gen headlabinc1998 = 	1.34*ER16463
gen wifelabinc1998 = 	1.34*ER16465
gen headlabinc2000 = 	1.27*ER20443
gen wifelabinc2000 = 	1.27*ER20447
gen headlabinc2002 = 	1.21*ER24116
gen wifelabinc2002 = 	1.21*ER24135
gen headlabinc2004 = 	1.15*ER27931
gen wifelabinc2004 = 	1.15*ER27943
gen headlabinc2006 = 	1.08*ER40921
gen wifelabinc2006 = 	1.08*ER40933
gen headlabinc2008 = 	1.01*ER46829
gen wifelabinc2008 = 	1.01*ER46841
gen headlabinc2010 = 	1.00*ER52237
gen wifelabinc2010 = 	1.00*ER52249

forvalues year = 1968/2011 {
	local v = "wifelabinc`year'"
	capture confirm variable `v'
	if !_rc {
		label var `v' "Labor income of Head's Wife in year `year'"
	}
}

forvalues year = 1968/2011 {
	local v = "headlab`year'"
	capture confirm variable `v'
	if !_rc {
		label var `v' "Labor income of Head in year `year'"
	}
}

forvalues year = 1998(2)2008 {
	local next = `year' + 1
	replace headlabinc`year' = 0 if (headlabinc`year' == . & head`next' == 1 & work`next' == 0)
	replace wifelabinc`year' = 0 if (wifelabinc`year' == . & wife`next' == 1 & work`next' == 0)
}

foreach year of numlist 1998 2000 2002 2004 2006 2008 {
	local v1 headlabinc
	local v2 wifelabinc
	local prior 	= `year' - 2
	local next 	= `year' + 2
	local inty	= `year' + 1
	egen head_income`year' 	= rowmean(`v1'`year' `v1'`next' `v1'`prior')
	egen wife_income`year' 	= rowmean(`v2'`year' `v2'`next' `v2'`prior')
	gen income`year' 	= head_income`year' if head`inty' == 1
	replace income`year' 	= wife_income`year' if wife`inty' == 1	
}

gen income_at30 = 	cond(birthcohort == 1972, income2002, ///
			cond(birthcohort == 1973, income2002, ///
			cond(birthcohort == 1974, income2004, ///
			cond(birthcohort == 1975, income2004, ///
			cond(birthcohort == 1976, income2006, ///
			cond(birthcohort == 1977, income2006, ///
			.))))))
replace income_at30 = 0 if (income_at30 == . & work_at30 == 0)
		
label var income_at30 "3yr Avg. of Labor Income at age 30, ($ 2010)"

//Education Level Attained

gen grade_complet1972 	= 	ER30100 if inlist(ER30100,0,99,.) == 0 
gen grade_complet1973 	= 	ER30126 if inlist(ER30126,0,99,.) == 0 
gen grade_complet1974 	= 	ER30147 if inlist(ER30147,0,99,.) == 0
gen grade_complet1975 	= 	ER30169 if inlist(ER30169,0,99,.) == 0
gen grade_complet1976 	= 	ER30197 if inlist(ER30197,0,99,.) == 0
gen grade_complet1977 	= 	ER30226 if inlist(ER30226,0,99,.) == 0

gen grade_complet2001 	= 	ER33616 if inlist(ER33616,98,99,0,.) == 0
gen grade_complet2003 	= 	ER33716 if inlist(ER33716,98,99,0,.) == 0
gen grade_complet2005 	= 	ER33817 if inlist(ER33817,98,99,0,.) == 0
gen grade_complet2007 	= 	ER33917 if inlist(ER33917,98,99,0,.) == 0
gen grade_complet2009  	= 	ER34020 if inlist(ER34020,98,99,0,.) == 0

forvalues year = 1968/2011 {
	local v = "grade_complet`year'"
	capture confirm variable `v'
	if !_rc {
		label var `v' "Grade completed (individual) in year `year'"
	}
}

gen grade_complet_at30 	= 	cond(birthcohort == 1972, grade_complet2001, ///
				cond(birthcohort == 1973, grade_complet2003, ///
				cond(birthcohort == 1974, grade_complet2003, ///
				cond(birthcohort == 1975, grade_complet2005, ///
				cond(birthcohort == 1976, grade_complet2005, ///
				cond(birthcohort == 1977, grade_complet2007, ///
				.))))))

label var grade_complet_at30 "Highest Grade Completed by Age 30"

//Graduated from High School by age 30
gen hs_grad_at30 = grade_complet_at30 >= 12 if grade_complet_at30 != .
label var hs_grad_at30 "High School grad at 30"

//Obtained at least 4-year degree
gen degree_at30 = grade_complet_at30 >= 16 if grade_complet_at30 != .
label var degree_at30 "4 Year Collee Degree at 30"

//Father's and Mother's education of Head and Wife of Head

gen wifefather_edu1999  = ER15809 if inlist(ER15809,98,99,0,.) == 0
gen wifemother_edu1999  = ER15818 if inlist(ER15818,98,99,0,.) == 0
gen headfather_edu1999	= ER15894 if inlist(ER15894,98,99,0,12,.) == 0
gen headmother_edu1999  = ER15903 if inlist(ER15903,98,99,0,12,.) == 0
gen wifefather_edu2001  = ER19870 if inlist(ER19870,98,99,0,.) == 0
gen wifemother_edu2001  = ER19879 if inlist(ER19879,98,99,0,.) == 0
gen headfather_edu2001  = ER19955 if inlist(ER19955,98,99,0,.) == 0
gen headmother_edu2001  = ER19964 if inlist(ER19964,98,99,0,.) == 0
gen wifefather_edu2003  = ER23307 if inlist(ER23307,99,0,.) == 0
gen wifemother_edu2003  = ER23316 if inlist(ER23316,99,0,.) == 0
gen headfather_edu2003  = ER23392 if inlist(ER23392,99,0,.) == 0
gen headmother_edu2003  = ER23401 if inlist(ER23401,99,0,.) == 0
gen wifefather_edu2005  = ER27267 if inlist(ER27267,99,0,.) == 0
gen wifemother_edu2005  = ER27277 if inlist(ER27277,99,0,.) == 0
gen headfather_edu2005  = ER27356 if inlist(ER27356,99,0,.) == 0
gen headmother_edu2005  = ER27366 if inlist(ER27366,99,0,.) == 0
gen wifefather_edu2007  = ER40442 if inlist(ER40442,99,0,.) == 0
gen wifemother_edu2007  = ER40452 if inlist(ER40452,99,0,.) == 0
gen headfather_edu2007  = ER40531 if inlist(ER40531,99,0,12,.) == 0
gen headmother_edu2007  = ER40541 if inlist(ER40541,99,0,.) == 0
gen wifefather_edu2009  = ER46414 if inlist(ER46414,99,0,.) == 0
gen wifemother_edu2009  = ER46424 if inlist(ER46424,99,0,.) == 0
gen headfather_edu2009  = ER46508 if inlist(ER46508,99,0,.) == 0
gen headmother_edu2009  = ER46518 if inlist(ER46518,99,0,.) == 0

forvalues year = 1999(2)2009 {
	recode headfather_edu`year'(1 = 2.5) (2 = 7) (3 = 10) (4/5 = 12) (6 = 14) (7 = 16) (8 = 17)
	recode headmother_edu`year'(1 = 2.5) (2 = 7) (3 = 10) (4/5 = 12) (6 = 14) (7 = 16) (8 = 17)
	recode wifefather_edu`year'(1 = 2.5) (2 = 7) (3 = 10) (4/5 = 12) (6 = 14) (7 = 16) (8 = 17)
	recode wifemother_edu`year'(1 = 2.5) (2 = 7) (3 = 10) (4/5 = 12) (6 = 14) (7 = 16) (8 = 17)
	
	label var headfather_edu`year' "Head's Father's Grade Completed in year `year'"
	label var headmother_edu`year' "Head's Mother's Grade Completed in year `year'"
	label var wifefather_edu`year' "Wife of Head's Father's Grade Completed in year `year'"
	label var wifemother_edu`year' "Wife of Head's Mother's Grade Completed in year `year'"
}

gen father_edu = headfather_edu1999 if head1999 == 1
replace father_edu = wifefather_edu1999 if wife1999 == 1
gen mother_edu = headmother_edu1999 if head1999 == 1
replace mother_edu = wifemother_edu1999 if wife1999 == 1

forvalues year = 2001(2)2009 {
	replace father_edu = headfather_edu`year' if father_edu == . & head`year' == 1
	replace father_edu = wifefather_edu`year' if father_edu == . & wife`year' == 1
	replace mother_edu = headmother_edu`year' if mother_edu == . & head`year' == 1
	replace mother_edu = wifemother_edu`year' if mother_edu == . & wife`year' == 1
}

//Head/Wife Grade Completed

gen headgrcomp1975 = 	V4093 	if inlist(V4093,99,.) == 0
gen headgrcomp1976 = 	V4684	if inlist(V4684,99,.) == 0
gen headgrcomp1977 = 	V5608	if inlist(V5608,99,.) == 0
gen headgrcomp1978 = 	V6157	if inlist(V6157,99,.) == 0
gen headgrcomp1979 = 	V6754	if inlist(V6754,99,.) == 0
gen headgrcomp1980 = 	V7387	if inlist(V7387,99,.) == 0
gen headgrcomp1981 = 	V8039	if inlist(V8039,99,.) == 0
gen headgrcomp1982 = 	V8663	if inlist(V8663,99,.) == 0
gen headgrcomp1983 = 	V9349	if inlist(V9349,99,.) == 0
gen headgrcomp1984 = 	V10996	if inlist(V10996,99,.) == 0
gen wifegrcomp1975 = 	V4102 	if inlist(V4102,.,99,0) == 0
gen wifegrcomp1976 = 	V4695	if inlist(V4695,.,99,0) == 0
gen wifegrcomp1977 = 	V5567	if inlist(V5567,.,99,0) == 0
gen wifegrcomp1978 = 	V6116 	if inlist(V6116,.,99,0) == 0
gen wifegrcomp1979 = 	V6713	if inlist(V6713,.,99,0) == 0
gen wifegrcomp1980 = 	V7346	if inlist(V7346,.,99,0) == 0
gen wifegrcomp1981 = 	V7998	if inlist(V7998,.,99,0) == 0
gen wifegrcomp1982 = 	V8622	if inlist(V8622,.,99,0) == 0
gen wifegrcomp1983 = 	V9308	if inlist(V9308,.,99,0) == 0
gen wifegrcomp1984 = 	V10955	if inlist(V10955,.,99,0) == 0

forvalues year = 1968/2011 {
	local v = "headgrcomp`year'"
	capture confirm variable `v'
	if !_rc {
		label var `v' "Head last grade completed in year `year'"
	}
}

forvalues year = 1968/2011 {
	local v = "wifegrcomp`year'"
	capture confirm variable `v'
	if !_rc {
		label var `v' "Wife of Head last grade completed in year `year'"
	}
}

//Average HH education

forvalues year = 1975/1984 {
	egen hhedu`year' = rowmean(wifegrcomp`year' headgrcomp`year')
	label var hhedu`year' "Average of wife and Head's grade completed in year `year'"
}

//Learning disability or special education
gen learning_disability = ER33260 == 1  if inlist(ER33260,1,5) == 1
gen special_ed		= ER33259 == 1  if inlist(ER33259,1,5) == 1
gen grade_repeat 	= ER33246 == 1	if inlist(ER33246,1,5) == 1

egen behind	 	= rowmax(learning_disability special_ed grade_repeat)
label var behind	"In 1995, ==1 if had learn. disab., spec. edu., or rptd. a grade" 


//Family members nearby
gen family_support = 	V2576 == 1 if inlist(V2576,9,.) == 0
label var family_support "Family of Head in 1972 nearby."

//Absence of relatives
gen relatives_absent = family_support == 0 if family_support != .
label var relatives_absent "Relatives are not nearby (1972 only)"

//Attended Head Start
gen head_start_attend = ER33261 == 1 if inlist(ER33261,1,5) == 1
label var head_start_attend "Ever attended Head Start by 1995"

//Trouble Reading
gen trouble_read1975 = V4096 if inlist(V4096,1,5) == 1
gen trouble_read1976 = V4687 if inlist(V4687,1,5) == 1
gen trouble_read1977 = V5611 if inlist(V5611,1,5) == 1

gen trouble_read_atbirth = 	cond(birthcohort == 1972, trouble_read1975, ///
				cond(birthcohort == 1973, trouble_read1975, ///
				cond(birthcohort == 1974, trouble_read1975, ///
				cond(birthcohort == 1975, trouble_read1975, ///
				cond(birthcohort == 1976, trouble_read1976, ///
				cond(birthcohort == 1977, trouble_read1977, ///
				.))))))
label var trouble_read_atbirth "Head has trouble reading at child's birth."

//Head Disabled 
gen head_disab1970 = 	V1412 > 0 if inlist(V1412,9,0,.) == 0 
gen head_disab1971 = 	V2124 > 0 if inlist(V2124,9,0,.) == 0
gen head_disab1972 = 	V2720 > 0 if inlist(V2720,9,0,.) == 0
gen head_disab1973 = 	V3246 > 0 if inlist(V3246,9,0,.) == 0
gen head_disab1974 = 	V3668 > 0 if inlist(V3668,9,0,.) == 0
gen head_disab1975 = 	V4147 > 0 if inlist(V4147,9,0,.) == 0
gen head_disab1978 = 	V6104 > 0 if inlist(V6104,99,0,.) == 0

//Other person requires extra care
gen extra_care1970 = 	inlist(V1418,1,2) == 1 if inlist(V1418,1,2,5) == 1
gen extra_care1971 = 	inlist(V2130,1,2) == 1 if inlist(V2130,1,2,5) == 1
gen extra_care1972 = 	inlist(V2726,1,2) == 1 if inlist(V2726,1,2,5) == 1
gen extra_care1976 = 	V4629 > 0 if inlist(V4629,99,0,.) == 0
gen extra_care1977 = 	V5565 > 0 if inlist(V5565,99,0,.) == 0

//Someone in family needs extra care
egen need_care1970 = 	rowmax(extra_care1970 head_disab1970)
egen need_care1971 = 	rowmax(extra_care1971 head_disab1971)
egen need_care1972 = 	rowmax(extra_care1972 head_disab1972)
egen need_care1973 = 	rowmax(extra_care1972 head_disab1973)
egen need_care1974 = 	rowmax(extra_care1976 head_disab1974)
egen need_care1975 = 	rowmax(extra_care1976 head_disab1975)
egen need_care1976 = 	rowmax(extra_care1976 head_disab1975)
egen need_care1977 = 	rowmax(extra_care1977 head_disab1978)

gen need_care_atbirth = cond(birthcohort == 1972, need_care1972, ///
			cond(birthcohort == 1973, need_care1973, ///
			cond(birthcohort == 1974, need_care1974, ///
			cond(birthcohort == 1975, need_care1975, ///
			cond(birthcohort == 1976, need_care1976, ///
			cond(birthcohort == 1977, need_care1977, ///
			.))))))
label var need_care_atbirth "Someone in family needs extra care/is disabled as child's birth"

//Needs Standards (adjusted to 2010 dollars)

gen needstd1967 = 	6.53 * V32 
gen needstd1968 = 	6.27 * V495
gen needstd1969 = 	5.94 * V1170
gen needstd1970 = 	5.62 * V1871
gen needstd1971 = 	5.38 * V2471
gen needstd1972 = 	5.22 * V3020
gen needstd1973 = 	4.91 * V3440
gen needstd1974 = 	4.42 * V3840
gen needstd1975 = 	4.05 * V4349
gen needstd1976 = 	3.83 * V5257
gen needstd1977 = 	3.60 * V5758
gen needstd1978 = 	3.34 * V6364
gen needstd1979 = 	3.00 * V6962
gen needstd1980 = 	2.65 * V7554

forvalues year = 1968/2011 {
	local v = "needstd`year'"
	capture confirm variable `v'
	if !_rc {
		label var `v' "Food need standard ($2010) in year `year'"
	}
}

//In poverty (according to food needs standards)

forvalues year = 1970/1980 {
	gen belowfdstd`year' = 	familyincome`year' < needstd`year' if ///
				(familyincome`year' != . & needstd`year' != .)
	label var belowfdstd`year' "Family income below food needs standard, year `year'"
}

//Marital Status
*1=married, 2=single, 3=widowed, 4=divorced, 5=separated
gen maritalstat1968 = 	V239	if inlist(V239,.,9) == 0 //8=married, spouse absent, 9 =na
gen maritalstat1969 = 	V607	
gen maritalstat1970 = 	V1365	
gen maritalstat1971 = 	V2072	
gen maritalstat1972 = 	V2670 
gen maritalstat1973 = 	V3181 	
gen maritalstat1974 = 	V3598	
gen maritalstat1976 = 	V4603	
gen maritalstat1977 = 	V5650	
gen maritalstat1978 = 	V6197	
gen maritalstat1979 = 	V6790	
gen maritalstat1980 = 	V7435	

forvalues year = 1968/2011 {
	local v = "maritalstat`year'"
	capture confirm variable `v'
	if !_rc {
		label var `v' "Marital status of Head in year `year'"
	}
}

//Number of Children in FU Under 18
*1,2,3,4,5,6,7,8, 9 = 9 or more
gen numchild1968 = 	V398
gen numchild1969 = 	V550
gen numchild1970 = 	V1242
gen numchild1971 = 	V1945
gen numchild1972 = 	V2545
gen numchild1973 = 	V3098
gen numchild1974 = 	V3511
gen numchild1975 = 	V3924
gen numchild1976 = 	V4439
gen numchild1977 = 	V5353
gen numchild1978 = 	V5853
gen numchild1979 = 	V6465
gen numchild1980 = 	V7070

forvalues year = 1968/2011 {
	local v = "numchild`year'"
	capture confirm variable `v'
	if !_rc {
		label var `v' "Number of children in year `year'"
	}
}

//Household Intact
forvalues year = 1968/1980 {
	capture confirm variable maritalstat`year' 
	if !_rc {
		gen hhintact`year' = 	(maritalstat`year' == 1) | ///
					(maritalstat`year' == 2 & numchild`year' == 0) if ///
					maritalstat`year' != .
		label var hhintact`year' "Household intact in year `year'"
	}
}
/*Other Ideas for Variables
Have some data on oldest child born, can construct a teen parent indicator
Marital Status
*/
