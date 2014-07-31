/*
Title:		Driver File for Intra-black and Black-White Gaps
Project:	Extending IHDP and NFP treatments to the population
Authors:	Will Burgo
Date:		07/01/14
*/


//Will's globals


//Giving global names to all relevant directories
//global erc: env erc
//global klmshare: env klmshare
set more off
global erc: env erc
global klmshare: env klmshare
cd "z:\"
#delimit ;
cd "ercprojects"; pwd; cd "ecipop"; global ecipopklmshare: pwd;
cd "C:\Users\William\Documents\GitHub"; cd "ecipop"; global ecipoplocal: pwd;
cd "Write-up"; global writeup: pwd; cd ${ecipoplocal}; cd "General_DoFiles"; 
global general_dofiles: pwd;

cd ${ecipoplocal}; cd "Perry"; cd "DoFiles"; global perry_dofiles: pwd; 
cd ${ecipopklmshare}; cd "Perry"; cd "Data"; global perry_data: pwd; 

cd ${ecipoplocal}; cd "ABC"; cd "dofiles"; global abc_dofiles: pwd; 
cd ${ecipopklmshare}; cd "ABC"; cd "data"; cd "raw"; global abc_dataraw: pwd; cd ..; cd "refined"; 
global abc_datarefined: pwd; cd ..; cd "intermediary"; global abc_dataintermediary: pwd;
#delimit cr
global abc_data ${abc_datarefined}

clear all
*This is for using files from Andrés' computer
*global perry_dofiles	"/Users/andreshojman/Google Drive/Heckman Work Group/Population Statistics/Perry/DoFiles"
*global perry_data 		"/Users/andreshojman/Google Drive/Heckman Work Group/Population Statistics/Perry/Data"
*global writeup			"/Users/andreshojman/Google Drive/Heckman Work Group/Population Statistics/Write-up"

*Define globals that distinguish both programs
global perry_dataset NLSY79
global perry_lab "Perry Preschool Program"
global perry_years "1954 and 1964"
global perry_ready_data SNLSY79
global perry_cost 0.019208
global perry_edu 	mhgc
global perry_inc	famincome79

global abc_dataset PSID
global abc_lab "Carolina Abecedarian Program"
global abc_years "1972 and 1977"
global abc_ready_data PSID_child_level
global abc_cost 0.076939
global abc_edu 	mother_edu
global abc_inc	income_atbirth

*-------------------------------*
** Summary Stats Table: Inputs **
*-------------------------------*
* matrix is of the size of:
*   [3(emp,hs)*3(gap1,gap2,%)+1(npop)]*2(male,fem)=20
matrix SUM=J(20,4,.)
global perry_col1 	1
global perry_col2 	2
global abc_col1 	3
global abc_col2 	4

*the matrix is filled in constructing_the_matrices.do

*outcomes
global out1name			"High School Graduation at 19-30"
global form1			"%12.2f"
global perry_out1order 	1
global abc_out1order 	3

global out2name			"Employment at 27-30"
global form2			"%12.2f"
global perry_out2order	2
global abc_out2order	2

global out3name			"Earnings at 27-30"
global form3			"%12.0fc"
global perry_out3order 	3
global abc_out3order 	4

*---------------------*
** PERRY SIMULATIONS **
*---------------------*
global Prog 			Perry
global prog 			perry


*----------------------------------*
* 1. Get the basic stats for Perry *
*----------------------------------* 
global pretreat m_edu iq3 sibnum welfare
global outcomes hsgrad19 empp_27 inc_27 empp_40 inc_40

cd "${perry_dofiles}"
do get_perry_results

*----------------------------------*
* 1.5 Pretreatment bar graphs      *
*----------------------------------* 
cd "${general_dofiles}"
do pretreatment_bar_graphs.do

*-----------------------------------*
* 2. Simulate the treatment effects *
*-----------------------------------* 
global pretreat mhgc afqt numsibs welfare_amt
global outcomes dedu3_19 empp_27 inc_27 empp_40 inc_40

*naming the columns of treat
local cnames "male"
foreach var in $outcomes{
local cnames ="`cnames' ta_`var' "
}
matrix colnames treat = `cnames'
preserve
drop _all
svmat treat, names(col)
cd ${perry_data}
save treat, replace
restore

cd "${general_dofiles}"
do UseS

*------------------------------------*
* 3. Construct the graphs of deciles *
*------------------------------------* 
*At least by now, income_deciles is just for Perry, as ABC has no significant income effects
cd "${perry_dofiles}"
do income_deciles_perry

*----------------------------------*
* 4. Write the big table for Perry *
*----------------------------------* 
cd "${perry_dofiles}"
* Create and label every variable that we are using so that outtablex recognizes them
clear

//Creating phantom variables so table constructor can read labels
foreach var in $pretreat $outcomes {
gen `var'_sd=.
label var `var'_sd ""
}

label var mhgc			"Mother's years of school"
label var welfare_amt	"Child's Family on Welfare"
label var numsibs 		"Number of Siblings"
label var afqt 			"Binet IQ or Std. AFQ"
label var dedu3_19 		"High School grad at 19"
label var empp_27 		"Employed at 27"
label var inc_27 		"Earnings at 27 (in 2010 dollars)"
label var empp_40 		"Employed at 40"
label var inc_40 		"Earnings at 40 (in 2010 dollars)"

global mhgc_fmt 		"%12.2f"
global welfare_amt_fmt	"%12.2f"
global numsibs_fmt 		"%12.2f"
global afqt_fmt 		"%12.2f"

global dedu3_19_fmt 	"%12.2f"
global empp_27_fmt 		"%12.2f"
global inc_27_fmt 		"%12.0fc"
global empp_40_fmt 		"%12.2f"
global inc_40_fmt 		"%12.0fc"

cd "${general_dofiles}"
do Constructing_the_Matrices

*-----------------*
* ABC SIMULATIONS *
*-----------------*

global Prog ABC
global prog abc

*----------------------------------*
* 1. Get the basic stats for ABC *
*----------------------------------* 
global pretreat mo_edu sibnum fa_home 
global outcomes degree4 works hsgrad inc
cd "${abc_dofiles}"
do get_abc_results

*----------------------------------*
* 1.5 Pretreatment bar graphs      *
*----------------------------------* 
cd "${general_dofiles}"
do pretreatment_bar_graphs.do

*-----------------------------------*
* 2. Simulate the treatment ABC *
*-----------------------------------* 
global pretreat mother_edu siblings_atbirth father_absent
global outcomes degree_at30 work_at30 hs_grad_at30 income_at30

local cnames "male"
foreach var in $outcomes{
local cnames ="`cnames' ta_`var' "
}
matrix colnames treat = `cnames'

preserve
drop _all
svmat treat, names(col)

cd ${abc_data}
save treat, replace
restore

cd "${general_dofiles}"
do UseS

*------------------------------------*
* 3. Construct the graphs of deciles *
*------------------------------------* 
*TO DO: Write decile graph for ABC
cd "${abc_dofiles}"
do income_deciles_abc

*----------------------------------*
* 4. Write the big table for ABC *
*----------------------------------* 
cd "${abc_dofiles}"
* Create and label every variable that we are using so that outtablex recognizes them
clear

//Creating phantom variables so table constructor can read labels
foreach var in $pretreat $outcomes {
gen `var'_sd=.
label var `var'_sd ""
}

label var siblings_atbirth 		"Number of Siblings at Birth"
label var mother_edu	 		"Mother's years of schooling"
label var father_absent		 	"Father Absent at Birth"

label var degree_at30 			"4 Year College Degree at 30"
label var hs_grad_at30			"High School Grad at 30"
label var work_at30				"Employed at 30"
label var inc					"Earnings at 30 (in 2010 dollars)"

global siblings_atbirth_fmt		"%12.2f"
global mother_edu_fmt 			"%12.2f"
global father_absent_fmt		"%12.2f"
global income_atbirth_fmt		"%12.0fc"
global degree_at30_fmt			"%12.2f"
global hs_grad_at30_fmt			"%12.2f"
global work_at30_fmt			"%12.2f"
global income_at30_fmt			"%12.0fc"

cd "${general_dofiles}"
do Constructing_the_Matrices

*-----------------------------------*
* Almost FINALE: Pretreatment table *
*-----------------------------------* 
cd "${general_dofiles}"
do pretreatment_table.do

*----------------------------------*
* FINALE: Summary table            *
*----------------------------------* 
matrix aux0=aux0perry,aux0abc
matrix SUM=SUM\aux0
matrix list SUM

qui outtablex_summary using "summary", ///
mat(SUM)   nobox replace fsize(scriptsize) ///
caption(Hypothetical Extension of Perry and ABC: a Summary of the Change in the Outcome Gaps) /// 
asis label clabel("tab:summary")  ///
row1s1("      ") row1c1(1) 	row1s2("The Perry Preschool Program") 	row1c2(2)	row1s3("The Abecedarian Project") row1c3(2) row1s4( ) row1c4( ) row1s5( ) row1c5( )	///
row2s1(  ) row2c1( ) 	row2s2() row2c2( )		row2s3( ) 			row2c3( )  	row2s4( ) 	row2c4( ) 		row2s5( ) 	 row2c5( )   ///
format(%12.0f %12.0fc %12.0f %12.0f %12.0f %12.0f )

