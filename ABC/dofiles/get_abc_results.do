*--------------------------*
*** get_abc_results.do ***
*--------------------------*

*Author: Andrés
*The team: Jake, Jorge
*Creation Date: Aug8, 2013
*This version: 	Aug8, 2013

*Takes as inputs: 	an ABC dataset
*					global pretreat
*					a set of results from prof. Heckman's paper on ABC

*It can't be fully automatic !! It is programmed manually
*Gives as output:	a matrix of ABC results
*					a list of labels for those variables

cd "${abc_dataintermediary}"
use "ABC_clean.dta", clear
recode fa_home (1=0) (0=1)
foreach var in $pretreat $outcomes{
destring `var', replace
replace `var'=. if `var'==9999|`var'==-9999
}
replace inc=inc*1.08*1000

local nvar : word count $pretreat
local nvar =`nvar'*2

foreach j in 1 0{
	
	*Assigning names to the rows
	local rnames = ""
	matrix Death_`j'=J(`nvar',2,.)
	matrix colnames Death_`j' = treat cont
	foreach var in $pretreat {
		local rnames= "`rnames' `var' `var'_sd"
		}
	matrix rownames Death_`j' =`rnames'

	*Calculating means of pretreat variables
	local r=1
	foreach var in $pretreat {
		sum `var' if 				treat==1 & male==`j'
		matrix Death_`j'[`r'*2-1,1]=r(mean)
		matrix Death_`j'[`r'*2,1]=r(sd)
		sum `var' if 				treat==0 & male==`j'
		matrix Death_`j'[`r'*2-1,2]=r(mean)
		matrix Death_`j'[`r'*2,2]=r(sd)

		local r=`r'+1
		}
	matrix list Death_`j'

	*calculating sample/pop statistics rows
	matrix auxDeath_`j'=J(2,2,.)
	count if treat==1 & male==`j'
	matrix auxDeath_`j'[1,1]=r(N)
	count if treat==0 & male==`j'
	matrix auxDeath_`j'[1,2]=r(N)

	matrix abc_`j'=auxDeath_`j'\Death_`j'
	matrix list abc_`j'
}

*abc Matrix
*Define the number of outcomes
local nout : word count $outcomes
local nout =`nout'*2


foreach j in 0 1 {
matrix Death_`j'=J(`nout',2,.)
matrix colnames Death_`j'= treat cont
}

/*
*control means for males
matrix Death_1[1,2]=0.048
matrix Death_1[2,2]=.
matrix Death_1[3,2]=0.619		
matrix Death_1[4,2]=.
matrix Death_1[5,2]=0.524
matrix Death_1[6,2]=.


*treated males
matrix Death_1[1,1]=0.048+0.246
matrix Death_1[2,1]=.
matrix Death_1[3,1]=0.619+0.241
matrix Death_1[4,1]=.
matrix Death_1[5,1]=0.524+0.172
matrix Death_1[6,1]=.


*control females
matrix Death_0[1,2]=0.036
matrix Death_0[2,2]=.
matrix Death_0[3,2]=0.714
matrix Death_0[4,2]=.
matrix Death_0[5,2]=0.536
matrix Death_0[6,2]=.


*treated females
matrix Death_0[1,1]=0.036+0.161
matrix Death_0[2,1]=.
matrix Death_0[3,1]=0.714+0.063
matrix Death_0[4,1]=.
matrix Death_0[5,1]=0.536+0.166
matrix Death_0[6,1]=.
*/

*** Given that the SD's were not in Rodrigo's paper, we need to calculate them ourselves
foreach j in 0 1 {

	local r=1
	foreach out in $outcomes{
		sum `out' if treat==1 & male==`j'
		matrix Death_`j'[`r',1]=r(mean)
		sum `out' if treat==0 & male==`j'
		matrix Death_`j'[`r',2]=r(mean)
		local r=`r'+2
		}

	local r=2
	foreach out in $outcomes{
		sum `out' if treat==1 & male==`j'
		matrix Death_`j'[`r',1]=r(sd)
		sum `out' if treat==0 & male==`j'
		matrix Death_`j'[`r',2]=r(sd)
		local r=`r'+2
		}
}

matrix Death_1=abc_1\Death_1
matrix Death_0=abc_0\Death_0

matrix treat=J(2,5,.)
matrix treat[1,1]=1
matrix treat[1,2]=0.246
matrix treat[1,3]=0.241
matrix treat[1,4]=0.172
matrix treat[1,5]=21631*1.08

matrix treat[2,1]=0
matrix treat[2,2]=0.161
matrix treat[2,3]=0.063
matrix treat[2,4]=0.166
matrix treat[2,5]=863*1.08

