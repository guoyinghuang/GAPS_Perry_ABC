*--------------------------*
*** get_perry_results.do ***
*--------------------------*

*Author: Andrés
*The team: Jake, Jorge
*Creation Date: Aug7, 2013
*This version: 	Aug7, 2013

*Takes as inputs: 	a Perry dataset
*					global pretreat
*					number of pretreatment variables
*					a set of results from prof. Heckman's paper on Perry

*It can't be fully automatic !! It is programmed manually
*Gives as output:	a matrix of outcomes
*					a list of labels for those outcomes
*					a number of outcomes

cd "${perry_data}"
use "Perry_Clean.dta", clear
sort id
merge id using data_from_rod
drop _merge

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

	matrix perry_`j'=auxDeath_`j'\Death_`j'
	matrix list perry_`j'
}

*Perry Matrix
*Define the number of outcomes
local nout : word count $outcomes
local nout =`nout'*2


foreach j in 0 1 {
matrix Death_`j'=J(`nout',2,.)
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

matrix Death_1=perry_1\Death_1
matrix Death_0=perry_0\Death_0

* we are not really using these names: hsgrad19 empp_27 inc_27 empp_40 inc_40
matrix treat=J(2,6,.)
matrix treat[1,1]=1
matrix treat[1,2]=0.02
matrix treat[1,3]=0.1
matrix treat[1,4]=4380*1.27
matrix treat[1,5]=0.29
matrix treat[1,6]=7020*1.27

matrix treat[2,1]=0
matrix treat[2,2]=0.56
matrix treat[2,3]=0.28
matrix treat[2,4]=4000*1.27
matrix treat[2,5]=-0.01
matrix treat[2,6]=5270*1.27


