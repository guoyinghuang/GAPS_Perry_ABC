local klmshare: env klmshare
display "`klmshare'" 
version 12.0
set more off
*clear all

*******************************************************************************************
*******************************************************************************************
/*

Project    : eci_pop 

Description: this file uses a source data that is nationally representative 
             and applies treatment effects from an program evaluations to. 
			 Then, it creates matrices that characterize the groups of interest
			 of the population: sample size, population represented, pre-treatment
			 variables and outcomes. The information is piled in matrices and 
			 it is labeled. 
			 
			 Needs: 
			 
			 allkey    : indicator of the disadvantaged black
			 black     : indicator of the black
			 nondblack :
			 white     : indicator of the white
			 weights   : a variable of frequency weights called weight
			 treat     : a data base that has the ATE for each variable
			             for men and women separately. The level of observation in that 
					     data base is given by a variable called male so that we can 
					     merge m:1 the male variable and input each individual the ATE.
					     name the variables in this database as ta_`var' where var is 
					     the name of the variable in the global outcomes described below
					  
			 
			 A data source that opened in the driver before running this .do file
			 
			 Define in the driver .do file the pre-treatment variables as a global called pretreat
			                               the outcome variables as a globla called outcomes
										   

*This version: 7/8/2013

*This .do file: Jorge L. García G.-Menéndez
*This project : Jorge L. García G.-Menéndez, Andrés Hojman, Jake Torcasso

*/

*Comments: 
*******************************************************************************************
*******************************************************************************************

*Set locations
*In my laptop

/*
global analysis_location = "C:\Users\Jorge\Desktop\Summer2013\HeckmanGroup\ComparingData\NLSYData\Output\"
global data_location     = "C:\Users\Jorge\Desktop\Summer2013\HeckmanGroup\ComparingData\NLSYData\Data\"
global dofiles_location  = "C:\Users\Jorge\Desktop\Summer2013\HeckmanGroup\ComparingData\NLSYData\DoFiles\"
*/


*First merge
*Merge the data with the ATEs
cd "${${prog}_data}"
use ${${prog}_ready_data}, clear
merge m:1 male using treat
tab _merge
drop if _merge != 3
drop _merge

*First: calculate the number of sample points and the number
*       of the corresponding representative population.
	foreach var of varlist allkey black {
		foreach num of numlist 0 1 {
		
		*Nnotweighted
		summ `var' if male == `num'
		local Nnw = r(N)
		
		*Nweighted
		summ `var' [fw=weight] if male == `num'
		local Nw = r(N)
		
		matrix N_`var'_`num' = ([`Nnw',`Nw'])'
		matrix colnames N_`var'_`num' = `var'_`num'
	    matrix rownames N_`var'_`num' = Nnw Nw
	}
		}

*Capture a number of observations matrix for men and women
		foreach num of numlist 0 1 {
	
		mat_capp N_`num' : N_allkey_`num'  N_black_`num'
		}
	
	foreach var of varlist $outcomes $pretreat{
		foreach vary of varlist black nondblack allkey{
			foreach num of numlist 0 1 {
		
		summ `var' [fw=weight] if `vary' == 1 & male == `num'
		local mean = r(mean)
		local sd   = r(sd)
		
		matrix `var'_`vary'_`num' = ([`mean',`sd'])'
		matrix colnames `var'_`vary'_`num' = `vary'_`num'
	    matrix rownames `var'_`vary'_`num' = mean sd
		
		}
	}
}

	foreach num of numlist 0 1 {
		foreach var of varlist black nondblack allkey { 
			
			matrix `var'_`num' = [.,.]'
				matrix colnames `var'_`num' = `var'_`num'
				matrix rownames `var'_`num' = mean sd
				
				
				foreach vary of varlist $pretreat $outcomes {
					mat_rapp `var'_`num' : `var'_`num' `vary'_`var'_`num'
		
		}
		            matrix `var'_`num' = `var'_`num'[3..., 1]
	}
}	 
		
	*Append the matrices with the basics for black and allkey
	*For men
		mat_capp Out_nt_1 : black_1  nondblack_1  
		mat_capp Out_nt_1 : Out_nt_1 allkey_1
	*For women
		mat_capp Out_nt_0 : black_0 nondblack_0 
		mat_capp Out_nt_0 : Out_nt_0 allkey_0
	
***Treat the perry like individuals
***Calculate their relevant variables
	foreach var of varlist $outcomes {
		gen     tpl_`var' = `var'
		replace tpl_`var' = `var' + ta_`var' if allkey == 1
}	
		
	foreach var of varlist $outcomes{
			foreach num of numlist 0 1 {
		
		summ tpl_`var' [fw=weight] if allkey == 1 & male == `num'
		local mean = r(mean)
		local sd   = r(sd)
		
		matrix `var'_`num'_allk = ([`mean',`sd'])'
		matrix colnames `var'_`num'_allk = `vary'_`num'
	    matrix rownames `var'_`num'_allk = mean sd
		
		}
	}	
	
	
		
		
		
		foreach num of numlist 0 1 {
			matrix Out_t1_`num' = [.,.]'
			matrix colnames Out_t1_`num' = _`num'
			matrix rownames Out_t1_`num' = mean sd
			
			foreach var of varlist $outcomes {
				mat_rapp Out_t1_`num' : Out_t1_`num' `var'_`num'_allk
				}
			matrix Out_t1_`num' = Out_t1_`num'[3..., 1]
			}
	
				

***Calculate the relvant values for black given treatment
	foreach var of varlist $outcomes{
			foreach num of numlist 0 1 {
		
		summ tpl_`var' [fw=weight] if black == 1 & male == `num'
		local mean = r(mean)
		
		local sd   = r(sd)
		
		matrix `var'_`num'_al = ([`mean',`sd'])'
		matrix colnames `var'_`num'_al = `vary'_`num'
	    matrix rownames `var'_`num'_al = mean sd
		
		}
	}	
		
		
		
		foreach num of numlist 0 1 {
			matrix Out_t1all_`num' = [.,.]'
			matrix colnames Out_t1all_`num' = _`num'
			matrix rownames Out_t1all_`num' = mean sd
			
			foreach var of varlist $outcomes {
				mat_rapp Out_t1all_`num' : Out_t1all_`num' `var'_`num'_al
				}
			matrix Out_t1all_`num' = Out_t1all_`num'[3..., 1]
			}			

*Get the magnificent vector for the white individuals
	foreach var of varlist $pretreat $outcomes {
			foreach num of numlist 0 1 {
		
		summ `var' [fw=weight] if white == 1 & male == `num'
		local mean = r(mean)
		local sd   = r(sd)
		
		matrix `var'_white_`num' = ([`mean',`sd'])'
		matrix colnames `var'_white_`num' = white_`num'
	    matrix rownames `var'_white_`num' = mean sd
	}
}

	foreach num of numlist 0 1 {
		matrix white_`num' = [.,.]'
		matrix colnames white_`num' = white_`num'
		matrix rownames white_`num'   = mean sd
			foreach var of varlist $pretreat $outcomes {
			mat_rapp white_`num' : white_`num' `var'_white_`num'
			}
			matrix white_`num' = white_`num'[3...,1]
	}	
		
		foreach num of numlist 0 1 {
		*Nnotweighted
		summ white if male == `num'
		local Nnw = r(N)
		
		*Nweighted
		summ white [fw=weight] if male == `num'
		local Nw = r(N)
		
		matrix N_white_`num' = ([`Nnw',`Nw'])'
		matrix colnames N_white_`num' = white_`num'
	    matrix rownames N_white_`num' = Nnw Nw
		
		*Append to the number of disadvantaged and black
		mat_capp N_`num' : N_`num' N_white_`num'
	}
	
