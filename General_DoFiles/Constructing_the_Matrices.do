* MIND THE GAP *

*----------------------------------*
*** Constructing_the_Matrices.do ***
*----------------------------------*

* Author:			Andrés
* The whole posse: 	Jake, Jorge
* First version:	Aug1
* This version:		Aug7

*Takes as inputs:	global outcomes
*					global pretreat
*					global prog
*					matrices perry_1 perry_0 (or abc_1 abc_0)  Out_nt_1 Out_nt_0 white_1 white_0

* This .do file creates the table for the calculation of the gaps, taking as inputs some matrices given by Jorge

*create locals for first row of pretreat, pretreat rows,
*last row of pretreat, first row of outcomes, outcome rows, and last row of outcomes
local no : word count $outcomes
local np : word count $pretreat
* for matrices when descriptive stats are included
local frp=2+1
local p_r=`np'*2
local lrp=2+`p_r'
local fro=2+`p_r'+1
local o_r=`no'*2
local lro=2+`p_r'+`o_r'

* for matrices where descriptive stats are not included:outcome final and outcome1
local of=`p_r'+`o_r'
local o1=`p_r'+1

foreach j in 0 1 {
	*put all stats in the correct order
	mat sc1_`j'		=Death_`j'[1..2,1]
	mat sc2_`j'		=Death_`j'[1..2,2]
	mat sc3_`j'		=N_`j'[1..2,1]
	mat sc4_`j' 	=J(2,1,.)
	mat sc4_`j'[1,1]=N_`j'[1,2]-N_`j'[1,1]
	mat sc4_`j'[2,1]=N_`j'[2,2]-N_`j'[2,1]
	mat sc5_`j' 	=N_`j'[1..2,2]
	mat sc6_`j' 	=N_`j'[1..2,3]
	mat sc78_`j' 	=J(2,2,.)
	mat s_`j'		=sc1_`j',sc2_`j',sc3_`j',sc4_`j',sc5_`j',sc6_`j',sc78_`j'

	*put all pre-treat in the correct order
	mat pc1_`j'		=Death_`j'[`frp'..`lrp',1]
	mat pc2_`j'		=Death_`j'[`frp'..`lrp',2]
	mat pc3_`j'		=Out_nt_`j'[1..`p_r',3]
	mat pc4_`j'		=Out_nt_`j'[1..`p_r',2]
	mat pc5_`j'		=Out_nt_`j'[1..`p_r',1]
	mat pc6_`j'		=white_`j'[1..`p_r',1]
	mat pc78_`j'	=J(`p_r',2,.)
	mat p_`j'		=pc1_`j',pc2_`j',pc3_`j',pc4_`j',pc5_`j',pc6_`j',pc78_`j'

	*put all outcomes in the correct order
	mat oc1_`j'		=Death_`j'[`fro'..`lro',1]
	mat oc2_`j'		=Death_`j'[`fro'..`lro',2]
	mat oc3_`j'		=Out_nt_`j'[`o1'..`of',3]
	mat oc4_`j'		=Out_t1_`j'[1..`o_r',1]
	mat oc5_`j'		=Out_nt_`j'[`o1'..`of',2]
	mat oc6_`j'		=Out_nt_`j'[`o1'..`of',1]
	mat oc7_`j'		=Out_t1all_`j'[1..`o_r',1]
	mat oc8_`j'		=white_`j'[`o1'..`of',1]
	mat o_`j'		=oc1_`j',oc2_`j',oc3_`j',oc4_`j',oc5_`j',oc6_`j',oc7_`j',oc8_`j'

	matrix A_`j'	=s_`j'\p_`j'\o_`j'

	local rnames ""
	local variables $pretreat $outcomes
	foreach var in `variables'{
	local rnames= "`rnames' `var' `var'_sd"
	}
	matrix rownames A_`j'= sample pop `rnames'
	mat list A_`j'

}
*Gather the statistics in the SUMmary matrix

			*** males ***
*n_population
matrix SUM[1,${${prog}_col1}]=A_1[2,3]
	**Intra-Black gaps **
*gap outcome 1
local r=`fro'+(${${prog}_out1order}-1)*2
matrix SUM[2,${${prog}_col1}]=A_1[`r',5]-A_1[`r',3]
matrix SUM[3,${${prog}_col1}]=A_1[`r',5]-A_1[`r',4]
matrix SUM[4,${${prog}_col1}]=(SUM[3,${${prog}_col1}]/SUM[2,${${prog}_col1}]-1)*100
*gap outcome 2
local r=`fro'+(${${prog}_out2order}-1)*2
matrix SUM[5,${${prog}_col1}]=A_1[`r',5]-A_1[`r',3]
matrix SUM[6,${${prog}_col1}]=A_1[`r',5]-A_1[`r',4]
matrix SUM[7,${${prog}_col1}]=(SUM[6,${${prog}_col1}]/SUM[5,${${prog}_col1}]-1)*100
*gap outcome 3
local r=`fro'+(${${prog}_out3order}-1)*2
matrix SUM[8,${${prog}_col1}]=A_1[`r',5]-A_1[`r',3]
matrix SUM[9,${${prog}_col1}]=A_1[`r',5]-A_1[`r',4]
matrix SUM[10,${${prog}_col1}]=(SUM[9,${${prog}_col1}]/SUM[8,${${prog}_col1}]-1)*100

	**White-Black gaps **
*gap outcome 1
local r=`fro'+(${${prog}_out1order}-1)*2
matrix SUM[2,${${prog}_col2}]=A_1[`r',8]-A_1[`r',6]
matrix SUM[3,${${prog}_col2}]=A_1[`r',8]-A_1[`r',7]
matrix SUM[4,${${prog}_col2}]=(SUM[3,${${prog}_col2}]/SUM[2,${${prog}_col2}]-1)*100
*gap outcome 2
local r=`fro'+(${${prog}_out2order}-1)*2
matrix SUM[5,${${prog}_col2}]=A_1[`r',8]-A_1[`r',6]
matrix SUM[6,${${prog}_col2}]=A_1[`r',8]-A_1[`r',7]
matrix SUM[7,${${prog}_col2}]=(SUM[6,${${prog}_col2}]/SUM[5,${${prog}_col2}]-1)*100
*gap outcome 3
local r=`fro'+(${${prog}_out3order}-1)*2
matrix SUM[8,${${prog}_col2}]=A_1[`r',8]-A_1[`r',6]
matrix SUM[9,${${prog}_col2}]=A_1[`r',8]-A_1[`r',7]
matrix SUM[10,${${prog}_col2}]=(SUM[9,${${prog}_col2}]/SUM[8,${${prog}_col2}]-1)*100

			*** females ***
*n_population
matrix SUM[11,${${prog}_col1}]=A_0[2,3]
	**Intra-Black gaps **
*gap outcome 1
local r=`fro'+(${${prog}_out1order}-1)*2
matrix SUM[12,${${prog}_col1}]=A_0[`r',5]-A_0[`r',3]
matrix SUM[13,${${prog}_col1}]=A_0[`r',5]-A_0[`r',4]
matrix SUM[14,${${prog}_col1}]=(SUM[13,${${prog}_col1}]/SUM[12,${${prog}_col1}]-1)*100
*gap outcome 2
local r=`fro'+(${${prog}_out2order}-1)*2
matrix SUM[15,${${prog}_col1}]=A_0[`r',5]-A_0[`r',3]
matrix SUM[16,${${prog}_col1}]=A_0[`r',5]-A_0[`r',4]
matrix SUM[17,${${prog}_col1}]=(SUM[16,${${prog}_col1}]/SUM[15,${${prog}_col1}]-1)*100
*gap outcome 3
local r=`fro'+(${${prog}_out3order}-1)*2
matrix SUM[18,${${prog}_col1}]=A_0[`r',5]-A_0[`r',3]
matrix SUM[19,${${prog}_col1}]=A_0[`r',5]-A_0[`r',4]
matrix SUM[20,${${prog}_col1}]=(SUM[19,${${prog}_col1}]/SUM[18,${${prog}_col1}]-1)*100

	**White-Black gaps **
*gap outcome 1
local r=`fro'+(${${prog}_out1order}-1)*2
matrix SUM[12,${${prog}_col2}]=A_0[`r',8]-A_0[`r',6]
matrix SUM[13,${${prog}_col2}]=A_0[`r',8]-A_0[`r',7]
matrix SUM[14,${${prog}_col2}]=(SUM[13,${${prog}_col2}]/SUM[12,${${prog}_col2}]-1)*100
*gap outcome 2
local r=`fro'+(${${prog}_out2order}-1)*2
matrix SUM[15,${${prog}_col2}]=A_0[`r',8]-A_0[`r',6]
matrix SUM[16,${${prog}_col2}]=A_0[`r',8]-A_0[`r',7]
matrix SUM[17,${${prog}_col2}]=(SUM[16,${${prog}_col2}]/SUM[15,${${prog}_col2}]-1)*100
*gap outcome 3
local r=`fro'+(${${prog}_out3order}-1)*2
matrix SUM[18,${${prog}_col2}]=A_0[`r',8]-A_0[`r',6]
matrix SUM[19,${${prog}_col2}]=A_0[`r',8]-A_0[`r',7]
matrix SUM[20,${${prog}_col2}]=(SUM[19,${${prog}_col2}]/SUM[18,${${prog}_col2}]-1)*100

matrix aux1${prog}=J(10,1,.)
matrix aux2${prog}=J(10,1,.)
local male_ratio=SUM[1,${${prog}_col1}]/(SUM[1,${${prog}_col1}]+SUM[11,${${prog}_col1}])
matrix aux0${prog}			=SUM[1,${${prog}_col1}]+SUM[11,${${prog}_col1}]
matrix aux1${prog}			=SUM[2..10,${${prog}_col1}]*`male_ratio'+SUM[12..20,${${prog}_col1}]*(1-`male_ratio')
matrix aux2${prog}			=SUM[2..10,${${prog}_col2}]*`male_ratio'+SUM[12..20,${${prog}_col2}]*(1-`male_ratio')

foreach val in 3 6 9 {
local pre		=`val'-1
local prepre 	=`val'-2
matrix aux1${prog}[`val',1]		=(aux1${prog}[`pre',1]/aux1${prog}[`prepre',1]-1)*100
matrix aux2${prog}[`val',1]		=(aux2${prog}[`pre',1]/aux2${prog}[`prepre',1]-1)*100
}




matrix aux0${prog}=aux0${prog},.\aux1${prog},aux2${prog}

*Append matrices A_0 and A_1 to use in the table that
*combines man and female informarmation. Use simple 
*linear comibation for overall
matrix A=[A_0, A_1]
matrix B_0 = .5*A_0
matrix B_1 = .5*A_1
matrix B = B_0 + B_1
mat_capp AB : A B 


cd "${general_dofiles}"
do "outtablex_popstatistics.do"
do "outtablex_summary.do"

cd "${writeup}"
qui outtablex_popstatistics using "tabmal_$prog", ///
mat(A_1)   nobox replace fsize(scriptsize) ///
caption(Hypothetical Extension of the ${${prog}_lab} to the Disadvantaged Black, Male) /// 
asis label clabel("tab:tabmal_$prog")  ///
row1s1("    ") row1c1(2) 							row1s2(Disadvantaged ) 	row1c2(2)	row1s3(Non-disadv.) row1c3(1) row1s4(All Blacks) row1c4(2) row1s5(All Whites) row1c5(1)	///
row2s1(Treatment) row2c1(1) row2s2(Control) row2c2(1)		row2s3(Blacks) 			row2c3(2)  	row2s4(Blacks) 	row2c4(1) 		row2s5(" ") 	 row2c5(2)   ///
format(%12.0f %12.0fc %12.0f %12.0f %12.0f %12.0f %12.0f %12.0f %12.0f %12.2f %12.2f %12.2f %12.2f %12.2f %12.2f %12.2f %12.2f %12.2f %12.2f %12.0fc %12.2f)

qui outtablex_popstatistics using "tabfem_$prog", ///
mat(A_0)   nobox replace fsize(scriptsize) ///
caption(Hypothetical Extension of the ${${prog}_lab} to the Disadvantaged Black, Female) /// 
asis label clabel("tab:tabfem_$prog")  ///
row1s1("      ") row1c1(2) 							row1s2(Disadvantaged ) 	row1c2(2)	row1s3(Non-disadv.) row1c3(1) row1s4(All Blacks) row1c4(2) row1s5(All Whites) row1c5(1)	///
row2s1(Treatment) row2c1(1) row2s2(Control) row2c2(1)		row2s3(Blacks) 			row2c3(2)  	row2s4(Blacks) 	row2c4(1) 		row2s5(" ") 	 row2c5(2)   ///
format(%12.0f %12.0fc %12.0f %12.0f %12.0f %12.0f %12.0f %12.0f %12.0f %12.2f %12.2f %12.2f %12.2f %12.2f %12.2f %12.2f %12.2f %12.2f %12.2f %12.0fc %12.2f)

cd "${general_dofiles}"
do "outtablex_pstatistics.do"
cd "${writeup}"

qui outtablex_pstatistics using "tabp_$prog", ///
mat(AB)   nobox replace fsize(scriptsize) ///
caption(Outcome Gaps after a Hypothetical Extension of the ${${prog}_lab} to the Disadvantaged Black) /// 
asis label clabel("tab:tabp_$prog")  






