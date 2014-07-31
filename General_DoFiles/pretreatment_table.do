matrix PRE=J(8,6,.)
local perry_c1	1
local abc_c1		4
local perry_prev 	mhgc numsibs famincome79
local abc_prev		mother_edu siblings_atbirth income_atbirth

foreach prog in perry abc{
	cd "${`prog'_data}"
	use ${`prog'_ready_data}, clear
	
	* Graphs for Disadvantaged vs Blacks *
	gen disad_b=.
	replace disad_b=1 if allkey==1 & black==1 & weight>0
	replace disad_b=0 if allkey==. & black==1 & weight>0
	local label_b "Non-disadvantaged Blacks"
	* Graphs for Disadvantaged vs All *
	gen disad_all=.
	replace disad_all=1 if allkey==1 & black==1 & weight>0
	replace disad_all=0 if allkey==. 			& weight>0
	local label_all "Non-disadvantaged Population"

local c2=``prog'_c1'+1
local c3=``prog'_c1'+2
	local r=1
		sum weight if disad_b==1 [w=weight]
		matrix PRE[`r',``prog'_c1']=r(sum_w)
		sum weight if disad_b==0 [w=weight]
		matrix PRE[`r',`c2']=r(sum_w)
		sum weight if disad_all==0 [w=weight]
		matrix PRE[`r',`c3']=r(sum_w)
		sum weight [w=weight]
		local total=r(sum_w)
	local r=2
		sum weight if disad_b==1 [w=weight]
		matrix PRE[`r',``prog'_c1']=r(sum_w)/`total'
		sum weight if disad_b==0 [w=weight]
		matrix PRE[`r',`c2']=r(sum_w)/`total'
		sum weight if disad_all==0 [w=weight]
		matrix PRE[`r',`c3']=r(sum_w)/`total'
		sum weight [w=weight]
	local r=3	
	
	foreach var in ``prog'_prev'{	
		sum `var' if disad_b==1 [w=weight]
		matrix PRE[`r',``prog'_c1']=r(mean)
		sum `var' if disad_b==0 [w=weight]
		matrix PRE[`r',`c2']=r(mean)
		sum `var' if disad_all==0 [w=weight]
		matrix PRE[`r',`c3']=r(mean)
		local r=1+`r'
		sum `var' if disad_b==1 [w=weight]
		matrix PRE[`r',``prog'_c1']=r(sd)
		sum `var' if disad_b==0 [w=weight]
		matrix PRE[`r',`c2']=r(sd)
		sum `var' if disad_all==0 [w=weight]
		matrix PRE[`r',`c3']=r(sd)
		local r=1+`r'
		}
}
label var siblings_atbirth 		"Number of Siblings at Birth"
label var mother_edu	 		"Mother's years of schooling"
label var income_atbirth		"Family income"

local rnames = ""
foreach var in `abc_prev' {
	local rnames= "`rnames' `var' `var'_sd"
	}
gen n=.
gen prop=.
label var n "nada"
label var prop "nada"

matrix rownames PRE =n prop `rnames'
*local rnames : rownames(PRE)
*local rn : word 3 of `rnames'
*local rn : variable label  `rn'
*di "`rn'"
*asd

cd "${general_dofiles}"
do outtablex_pretreat.do

cd "${writeup}"
qui outtablex_pretreat using "pretreat", ///
mat(PRE)   nobox replace fsize(scriptsize ) ///
caption(Comparison of the Pretreatment Variables Across Groups) /// 
asis label clabel("tab:pretreat")  ///
row1s1("      ") row1c1(1) 	row1s2("Perry Birth Cohort") 	row1c2(3)	row1s3("Abecedarian Birth Cohort") row1c3(3) row1s4( ) row1c4( ) row1s5( ) row1c5( )	row1s6( ) row1c6( ) row1s7( ) row1c7( ) ///
row2s1("      ") row2c1(1) 	row2s2(Disadvantaged) row2c2(1)		row2s3(Non-Disad.) row2c3(1)  	row2s4(Non-Disad.) 	row2c4(1) 		row2s5(Disadvantaged) 	 row2c5(1) 	row2s6(Non-Disadv.) 	 row2c6(1) row2s7(Non-Disadv.) 	 row2c7(1)  ///
row3s1("      ") row3c1(1) 	row3s2(Blacks) row3c2(1)			row3s3(Blacks) row3c3(1)  		row3s4(Population) 	row3c4(1) 		row3s5(Blacks) 	 row3c5(1) 			row3s6(Blacks) 	 row3c6(1)  		row3s7(Population) 	 row3c7(1)  ///
format(%12.0f %12.0fc %12.0f %12.0f %12.0f %12.0f )

matrix list PRE

