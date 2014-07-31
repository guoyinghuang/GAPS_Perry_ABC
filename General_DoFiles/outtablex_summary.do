*-------------------------------------------------------------------------------------*
* THIS FILE WRITES A TABLE FOR THE IMPACT OF THE ECI's in the GENERAL POPULATION GAPS *
* Author: Andrés
* Other stars in the movie: Jorge, Jake, Rodrigo, Seong

* Inputs: A huge matrix that has a similar form as the output table. It is created by "Constructing the Matrices.do"

cap program drop outtablex_summary
program define outtablex_summary,rclass
version 8.0
syntax using/, mat(string) [Replace APPend noBOX Stack Left ASIS fsize(string) CAPtion(string) asis Format(string) noROWlab longtable clabel(string) label ] ///
[row1s1(string) row1s2(string)  row1s3(string) row1c1(string)   row1c2(string) row1c3(string) row1s4(string) row1c4(string) row1s5(string) row1c5(string) ] ///
[row2s1(string) row2s2(string)  row2s3(string) row2c1(string)   row2c2(string) row2c3(string) row2s4(string) row2c4(string) row2s5(string) row2c5(string) ] ///

tempname hh

*number of pre-treatment variables
local np : word count $pretreat
*number of outcomes
local no : word count $outcomes

*Default font
if "`fsize'"==""{
local fsize small
}

*Horizontal spacing
local rh "0.2cm"

*--------------------*
* Starting the table *
*--------------------*

local formatn: word count `format'
local nr=rowsof(`mat')
local nc=colsof(`mat')
local rnames : rownames(`mat')
local cnames : colnames(`mat')

*The default option for the label of the table seems to be clabel
if "`clabel'"=="" {
    local labelc "clabel"
}
else {
    local labelc  "`clabel'"
}

*I guess this replaces the file or attaches a whole latex file on the bottom, starting a new table environment. Why would that be useful?
if "`replace'" 	== "replace" local opt "replace"
if "`append'" 	== "append" local opt "append"

*Opening the file chosen in the options
file open `hh' using "`using'.tex", write `opt'
file write `hh' "% matrix: `mat' file: `using'.tex  $S_DATE $S_TIME" _n
* add h to prefer here


* If nobox, then, at the end of each row, we just go to the next line. Otherwise, we put a bar and then go to next line
* I think nobox should be nothing and else should be a line, and it should be just one local
local nc1 = `nc'-1
if "`box'" == "nobox" {
    local hg "\hline"
	}
else {
    local vb "|"
    local hl "\hline"
    }

*----------------------------------*
**  Prepares the tabular command  **
*----------------------------------*

*Default is align center, but sometimes we might want to align left
						local align "c"
if "`left'" == "left" 	local align "l"
local l "l"

*transforms the local l in a lot of l|c|c|c… or in l|l|l|l...
forv i=1/`nc' {
    local l `l'`vb'`align'
    }
local l "`l'"

*------------------------------------*
** Commands to initialize the table **
*------------------------------------*

*Creates a new table environment or puts the table stacked in the old table environment
if "`stack'"==""{
    	file write `hh' "\begin{table}[htbp]" _n
    	}
    	
if "`caption'" ~= "" {
        file write `hh' "\caption{\label{`labelc'} `caption'}\medskip" _n
        }

    file write `hh' "\footnotesize "
    file write `hh' " \begin{center} "
    file write `hh' "\begin{tabular}{`l'}"  "`hl' `hl' `hg' `hg'    " _n

*----------------------*
* Title: Programs      *
*----------------------*
					file write `hh' "\textbf{ } &"         	  
					file write `hh' "\multicolumn{2}{c}{"         	  
					file write `hh' "The Perry Preschool Program"
					file write `hh' "} &"        
					file write `hh' "\multicolumn{2}{c}{"         	  
					file write `hh' "The Abecedarian Project"
					file write `hh' "} "        
					file write `hh' " \" "\[0.1cm]  \hline " _n

local lab_1 "Males"
local lab_0 "Females"
local lab_2 "Both Genders"
local pop_1 1
local pop_0 11
local pop_2 21

foreach gen in 1 0 2{
*----------*
* Gender   *
*----------*

					file write `hh' " \textbf{`lab_`gen''} & "
					file write `hh' "& & & "
					file write `hh' " \" "\[0.1cm]  " _n

*-------------------------*
* Target Population row   *
*-------------------------*
					local fmt %12.0fc
					file write `hh' "\textbf{Target Population} &"         	  
					file write `hh' "\multicolumn{2}{c}{"         	  
					file write `hh' `fmt' (`mat'[`pop_`gen'',1])
					file write `hh' "} &"        
					file write `hh' "\multicolumn{2}{c}{"         	  
					file write `hh' `fmt' (`mat'[`pop_`gen'',3])
					file write `hh' "} "        
					file write `hh' " \" "\[0.1cm]  " _n
	
*-------------*
* Costs row   *
*-------------*
					file write `hh' "\textbf{Cost of Intervention (2010 Mill.)} &"         	  
					file write `hh' "\multicolumn{2}{c}{"         	  
					file write `hh' `fmt' (`mat'[`pop_`gen'',1])*${perry_cost}
					file write `hh' "} &"        
					file write `hh' "\multicolumn{2}{c}{"         	  
					file write `hh' `fmt' (`mat'[`pop_`gen'',3])*${abc_cost}
					file write `hh' "} "
					file write `hh' " \" "\[0.1cm]  " _n
					
*----------------------*
* Sub-Subtitle: Gaps   *
*----------------------*

	file write `hh' "\textbf{Gaps}&"
	file write `hh' "Intra-Black &"
	file write `hh' "Black-White &"
	file write `hh' "Intra-Black &"
	file write `hh' "Black-White "
	file write `hh' " \" "\[0.1cm] "
*	file write `hh' "\hline" _n

*-------------------*
* Filling the Gaps  *
*-------------------*
local lab_b 	"Gap without intervention" 
local lab_c 	"Gap after intervention"
local lab_d		"Change in gap"
local perd		"\%"

local r=`pop_`gen''
foreach out in 1 2 3{
		local fmt ${form`out'}
   		local rn "${out`out'name}"

*First row: name of outcome		
	    								file write `hh' "\textbf{ `rn'} &"         	  
					file write `hh' "&"         
					file write `hh' "&"         
					file write `hh' "&"         
    				file write `hh' " \" "\[0.02cm]  " _n

	foreach row in b c d{
		local r=`r'+1
					if "`row'"=="d" local fmt "%12.0fc"
					file write `hh' " `lab_`row'' &"         	  
					file write `hh' `fmt' (`mat'[`r',1]) "`per`row''"
					file write `hh' "&"         
					file write `hh' `fmt' (`mat'[`r',2]) "`per`row''"
					file write `hh' "&"         
					file write `hh' `fmt' (`mat'[`r',3]) "`per`row''"
					file write `hh' "&"   
					file write `hh' `fmt' (`mat'[`r',4]) "`per`row''"
					if "`row'"=="d"	file write `hh' " \" "\[0.1cm]  "
					else 			file write `hh' " \" "\[0.02cm]  "

    				
		}

	}

file write `hh' " \" "\[`rh']  \hline " _n

*gender
}
*---------------------------*
* End of Writing Contents   *
*---------------------------*

    file write `hh' " \hline \end{tabular}" _n
	file write `hh' " \end{center} "  _n
	
	file write `hh' "	{\scriptsize  " _n
	file write `hh' "	{\raggedright " _n 
	file write `hh' "{\bfseries Notes:} The NLSY79/PSID weights are used to make each sample representative"
	file write `hh' " of the population. Disadvantaged blacks meet the "
	file write `hh' " eligibility criteria of the respective ECI. Non-disadvantaged blacks do "
	file write `hh' " not. All blacks include disadvantaged and non-"
	file write `hh' " disadvantaged blacks and represent the U.S. population of blacks. All "
	file write `hh' " whites represents the entire U.S. population of whites. The intra-"
	file write `hh' " black gap measures the difference in adult outcomes between the non-"
	file write `hh' " disadvantaged black population and the disadvantaged black population. " 
	file write `hh' " The black-white gap compares the difference in adult outcomes between the "
	file write `hh' " whole black population and the whole white population. The cost is expressed in 2010 millions of dollars."
	file write `hh' " The first column labels the results presented in the next four columns. The second and third columns present"
	file write `hh' " results for Perry and the fourth and fifth for ABC. The gap with no intervention refers to Scenario 1, where"
	file write `hh' " people do not have access to the program. Gap after inteverntion represents Scenario 2, where the program is made"
	file write `hh' " available to all individuals and they are applied the average treatment effect. The change in gap refers to the "
	file write `hh' " percentage change between these two scenarios. Since the treatment effects are not measured at the same ages we"
	file write `hh' " indicate the age at which the outcome is measured. The first"
	file write `hh' " number corresponds to Perry and the second to ABC."
	file write `hh' "} } " _n
    file write `hh' " \end{table}" _n
    file close `hh'

end

