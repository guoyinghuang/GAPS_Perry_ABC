* MIND THE GAP *
* Author Andrés
* The whole posse: Jake, Jorge, Rod, Seong
* This .do file creates the table for the calculation of the gaps, taking as inputs some matrices given by Jorge
//Giving global names to all relevant directories
global klmshare: env klmshare
cd "${klmshare}"
#delimit ;
cd "ERC_Projects"; global erc_projects: pwd; cd "ecipop"; global ecipop: pwd; 
cd "Perry"; global perry: pwd; cd "DoFiles"; global dofiles: pwd; cd ..;
cd "Data"; global data: pwd; cd ${ecipop}; cd "Write-up"; global writeup: pwd;
*cd "figures"; global figures: pwd;
#delimit cr

cd ${data}
use "Perry_Clean.dta", clear
set more off
* Generating the Results Matrix for Perry *

local outcomes="m_edu iq3 sibnum welfare"
local nvar : word count `outcomes'
local nvar =`nvar'*2

foreach j in 1 0{
	local rnames = ""
	matrix Death_`j'=J(`nvar',2,.)
	matrix colnames Death_`j' = treat cont
	foreach var in `outcomes'{
		local rnames= "`rnames' `var' `var'_sd"
		}
	matrix rownames Death_`j' =`rnames'

	local r=1
	foreach var in `outcomes'{
		sum `var' if 				treat==1 & male==`j'
		matrix Death_`j'[`r'*2-1,1]=r(mean)
		matrix Death_`j'[`r'*2,1]=r(sd)
		sum `var' if 				treat==0 & male==`j'
		matrix Death_`j'[`r'*2-1,2]=r(mean)
		matrix Death_`j'[`r'*2,2]=r(sd)

		local r=`r'+1
		}
	matrix list Death_`j'

	matrix auxDeath_`j'=J(2,2,.)
	count if treat==1 & male==`j'
	matrix auxDeath_`j'[1,1]=r(N)
	count if treat==0 & male==`j'
	matrix auxDeath_`j'[1,2]=r(N)

	matrix perry_`j'=auxDeath_`j'\Death_`j'
	matrix list perry_`j'

	}

*Perry Matrix

foreach j in 0 1 {
matrix Death_`j'=J(10,2,.)
matrix colnames Death_`j'= treat cont
}




*control males
matrix Death_1[1,2]=0.54 		
matrix Death_1[2,2]=0.51
matrix Death_1[3,2]=0.56 		
matrix Death_1[4,2]=0.50
matrix Death_1[5,2]=12495*1.27 	
matrix Death_1[6,2]=11354*1.27
matrix Death_1[7,2]=0.50 		
matrix Death_1[8,2]=0.51
matrix Death_1[9,2]=21119*1.27 	
matrix Death_1[10,2]=23970*1.27

*treated males
matrix Death_1[1,1]=0.48 		
matrix Death_1[2,1]=0.51
matrix Death_1[3,1]=0.60 		
matrix Death_1[4,1]=0.50
matrix Death_1[5,1]=14858*1.27 	
matrix Death_1[6,1]=10572*1.27
matrix Death_1[7,1]=0.70 		
matrix Death_1[8,1]=0.47
matrix Death_1[9,1]=27347*1.27 	
matrix Death_1[10,1]=24224*1.27

*control females
matrix Death_0[1,2]=0.31 		
matrix Death_0[2,2]=0.47
matrix Death_0[3,2]=0.55 		
matrix Death_0[4,2]=0.51
matrix Death_0[5,2]=8986*1.27 		
matrix Death_0[6,2]=9007*1.27
matrix Death_0[7,2]=0.82 		
matrix Death_0[8,2]=0.39
matrix Death_0[9,2]=17374*1.27 	
matrix Death_0[10,2]=16907*1.27

*treated females
matrix Death_0[1,1]=0.84 		
matrix Death_0[2,1]=0.37
matrix Death_0[3,1]=0.80 		
matrix Death_0[4,1]=0.41
matrix Death_0[5,1]=11554*1.27 	
matrix Death_0[6,1]=9393*1.27
matrix Death_0[7,1]=0.83 		
matrix Death_0[8,1]=0.38
matrix Death_0[9,1]=20866*1.27 	
matrix Death_0[10,1]=20292*1.27



foreach var in m_edu iq3 sibnum welfare hs27 emp27 inc27 emp40 inc40 {
gen `var'_sd=.
label var `var'_sd ""
}
label var m_edu		"Mother's years of school"
label var welfare 	"Child's Family on Welfare"
label var sibnum 	"Number of Siblings"
label var iq3 		"Binet IQ or Std. AFQT"
label var hs27 		"Completed High Sch. at 27"
label var emp27 	"Employed at 27"
label var inc27 	"Labor Income at 27"
label var emp40 	"Employed at 40"
label var inc40 	"Labor Income at 40"





foreach j in 0 1 {



*put all stats in the correct order
mat sc1_`j'	=perry_`j'[1..2,1]
mat sc2_`j'	=perry_`j'[1..2,2]
mat sc3_`j'	=N_`j'[1..2,1]
mat sc4_`j' =J(2,1,.)
mat sc4_`j'[1,1]=N_`j'[1,2]-N_`j'[1,1]
mat sc4_`j'[2,1]=N_`j'[2,2]-N_`j'[2,1]
mat sc5_`j' =N_`j'[1..2,2]
mat sc6_`j' =N_`j'[1..2,3]
mat sc78_`j' =J(2,2,.)
mat s_`j'=sc1_`j',sc2_`j',sc3_`j',sc4_`j',sc5_`j',sc6_`j',sc78_`j'

*put all pre-treat in the correct order
mat pc1_`j'	=perry_`j'[3..10,1]
mat pc2_`j'	=perry_`j'[3..10,2]
mat pc3_`j'	=Out_nt_`j'[1..8,3]
mat pc4_`j'	=Out_nt_`j'[1..8,2]
mat pc5_`j'	=Out_nt_`j'[1..8,1]
mat pc6_`j'	=white_`j'[1..8,1]
mat pc78_`j'=J(8,2,.)
mat p_`j'=pc1_`j',pc2_`j',pc3_`j',pc4_`j',pc5_`j',pc6_`j',pc78_`j'

*put all outcomes in the correct order
mat oc1_`j'	=Death_`j'[1..10,1]
mat oc2_`j'	=Death_`j'[1..10,2]
mat oc3_`j'	=Out_nt_`j'[9..18,3]
mat oc4_`j'	=Out_t1_`j'[1..10,1]
mat oc5_`j'	=Out_nt_`j'[9..18,2]
mat oc6_`j'	=Out_nt_`j'[9..18,1]
mat oc7_`j'	=Out_t1all_`j'[1..10,1]
mat oc8_`j'	=white_`j'[9..18,1]
mat o_`j'=oc1_`j',oc2_`j',oc3_`j',oc4_`j',oc5_`j',oc6_`j',oc7_`j',oc8_`j'

matrix A_`j'=s_`j'\p_`j'\o_`j'

set trace on
local rnames ""
local outcomes m_edu iq3 sibnum welfare hs27 emp27 inc27 emp40 inc40
foreach var in `outcomes'{
local rnames= "`rnames' `var' `var'_sd"
}
matrix rownames A_`j'= sample pop `rnames'
mat list A_`j'

}

cd ${dofiles}
do "outtablex_popstatistics.do"

cd ${writeup}
qui outtablex_popstatistics using "tab_mal", ///
mat(A_1)   nobox replace fsize(scriptsize) ///
caption(Hypothetical Extension of the Perry Preeschool Program to the Disadvantaged Black, Male) /// 
asis label clabel("tab:tab_mal")  ///
row1s1("    ") row1c1(2) 							row1s2(Disadvantaged ) 	row1c2(2)	row1s3(Non-disadv.) row1c3(1) row1s4(All Blacks) row1c4(2) row1s5(All Whites) row1c5(1)	///
row2s1(Treatment) row2c1(1) row2s2(Control) row2c2(1)		row2s3(Blacks) 			row2c3(2)  	row2s4(Blacks) 	row2c4(1) 		row2s5(" ") 	 row2c5(2)   ///
format(%12.0f %12.0fc %12.0f %12.0f %12.0f %12.0f %12.0f %12.0f %12.0f %12.2f %12.2f %12.2f %12.2f %12.2f %12.2f %12.2f %12.2f %12.2f %12.2f %12.0fc %12.2f)

qui outtablex_popstatistics using "tab_fem", ///
mat(A_0)   nobox replace fsize(scriptsize) ///
caption(Hypothetical Extension of the Perry Preeschool Program to the Disadvantaged Black, Female) /// 
asis label clabel("tab:tab_fem")  ///
row1s1("      ") row1c1(2) 							row1s2(Disadvantaged ) 	row1c2(2)	row1s3(Non-disadv.) row1c3(1) row1s4(All Blacks) row1c4(2) row1s5(All Whites) row1c5(1)	///
row2s1(Treatment) row2c1(1) row2s2(Control) row2c2(1)		row2s3(Blacks) 			row2c3(2)  	row2s4(Blacks) 	row2c4(1) 		row2s5(" ") 	 row2c5(2)   ///
format(%12.0f %12.0fc %12.0f %12.0f %12.0f %12.0f %12.0f %12.0f %12.0f %12.2f %12.2f %12.2f %12.2f %12.2f %12.2f %12.2f %12.2f %12.2f %12.2f %12.0fc %12.2f)

cd ${dofiles}
do "outtablex_pstatistics.do"
cd ${writeup}

*Append matrices A_0 and A_1 to use in the table that
*combines man and female informarmation. Use simple 
*linear comibation for overall

mat_capp A : A_0 A_1
matrix B_0 = .5*A_0
matrix B_1 = .5*A_1
matrix B = B_0 + B_1
mat_capp AB : A B 

qui outtablex_pstatistics using "tab_p", ///
mat(AB)   nobox replace fsize(scriptsize) ///
caption(Outcome Gaps after a Hypothetical Extension of the Perry Preeschool Program to the Disadvantaged Black) /// 
asis label clabel("tab:tab_p")  ///




