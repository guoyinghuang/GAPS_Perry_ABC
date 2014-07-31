*-------------------------------------------------------------------------------------*
* THIS FILE WRITES A TABLE FOR THE IMPACT OF THE ECI's in the GENERAL POPULATION GAPS *
* Author: Andrs
* Other stars in the movie: Jorge, Jake

* Inputs: A huge matrix that has a similar form as the output table. It is created by "Constructing the Matrices.do"

cap program drop outtablex_popstatistics
program define outtablex_popstatistics,rclass
version 8.0
syntax using/, mat(string) [Replace APPend noBOX Stack Left ASIS fsize(string) CAPtion(string) asis Format(string) noROWlab longtable clabel(string) label ] ///
[row1s1(string) row1s2(string)  row1s3(string) row1c1(string)   row1c2(string) row1c3(string) row1s4(string) row1c4(string) row1s5(string) row1c5(string) ] ///
[row2s1(string) row2s2(string)  row2s3(string) row2c1(string)   row2c2(string) row2c3(string) row2s4(string) row2c4(string) row2s5(string) row2c5(string) ] ///

*number of pre-treatment variables
local np : word count $pretreat
*number of outcomes
local no : word count $outcomes

tempname hh

*Default font
if "`fsize'"==""{
local fsize small
}

*Default Horizontal spacing
local rh "0.2cm"

** End of user-inputed stuff **

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

**AH: I should put this as options
*file write `hh' "\""newpage" _n
*file write `hh' "\""newgeometry{left=1cm,right=1cm}" _n


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

*transforms the local l in a lot of l|c|c|cÉ or in l|l|l|l...
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




************
	file write `hh' "&"
	file write `hh' "\multicolumn{2}{c}{$Prog Individuals} &"
	file write `hh' "\multicolumn{6}{c}{${${prog}_dataset} Individuals} "
	file write `hh' " \" "\[0.05cm] " 
    file write `hh' " \cline{2-3} \cline{5-9}   " _n 

************


*-----------------------------------------------------*
* First subtitle row (options specified by the user)  *
*-----------------------------------------------------*

if "`row1s1'"!=""{
local rowcommands=" & \multicolumn{`row1c1'}{c}{`row1s1'}" 
}
else{
local rowcommands=" & "
}
if "`row1s2'"!=""{
local rowcommands=" `rowcommands'  & \multicolumn{`row1c2'}{c}{`row1s2'}" 
}
if "`row1s3'"!=""{
local rowcommands=" `rowcommands'  & \multicolumn{`row1c3'}{c}{`row1s3'}" 
}
if "`row1s4'"!=""{
local rowcommands=" `rowcommands'  & \multicolumn{`row1c4'}{c}{`row1s4'}" 
}
if "`row1s5'"!=""{
local rowcommands=" `rowcommands'  & \multicolumn{`row1c5'}{c}{`row1s5'}" 
}

	file write `hh' " `rowcommands' \" 	"\ "   

*------------------------------------------------------*
* Second subtitle row (options specified by the user)  *
*------------------------------------------------------*

if "`row2s1'"!=""{
local rowcommands=" & \multicolumn{`row2c1'}{c}{`row2s1'}" 
}
else{
local rowcommands=" & "
}
if "`row2s2'"!=""{
local rowcommands=" `rowcommands'  & \multicolumn{`row2c2'}{c}{`row2s2'}" 
}
if "`row2s3'"!=""{
local rowcommands=" `rowcommands'  & \multicolumn{`row2c3'}{c}{`row2s3'}" 
}
if "`row2s4'"!=""{
local rowcommands=" `rowcommands'  & \multicolumn{`row2c4'}{c}{`row2s4'}" 
}
if "`row2s5'"!=""{
local rowcommands=" `rowcommands'  & \multicolumn{`row2c5'}{c}{`row2s5'}" 
}


	file write `hh' " `rowcommands' \" 	"\ "   
*Puts a horizontal line
    file write `hh'  " `hl' `hg'   " _n

*------------------------------*
* First data row: Sample size  *
*------------------------------*

local fmt: word 1 of `format'

	file write `hh' "\textbf{(a)} Sample Size &" (`mat'[1,1]) "& " 
	file write `hh' `fmt' (`mat'[1,2]) "& "

	file write `hh' "\multicolumn{2}{c}{ "         
	file write `hh' `fmt' (`mat'[1,3])
	file write `hh' "} & "         
	
	file write `hh' "\multicolumn{1}{c}{ "         	  
	file write `hh' `fmt' (`mat'[1,4])
	file write `hh' "} &"         _n

	file write `hh' "\multicolumn{2}{c}{ "         	  
	file write `hh' `fmt' (`mat'[1,5])
	file write `hh' "} &"         _n

	file write `hh' "\multicolumn{1}{c}{ "         	  
	file write `hh' `fmt' (`mat'[1,6])
	file write `hh' "} "         _n


	file write `hh' " \" "\[0.05cm] "  _n   

*-----------------------------------*
* Second data row: Population size  *
*-----------------------------------*


local fmt: word 2 of `format'

	file write `hh' "\ \ \ \ \ Population Represented &" (`mat'[2,1]) "& " 
	file write `hh' `fmt' (`mat'[2,2]) "& "
	file write `hh' "\multicolumn{2}{c}{ "         
	file write `hh' `fmt' (`mat'[2,3])
	file write `hh' "} & "         
	
	file write `hh' "\multicolumn{1}{c}{ "         	  
	file write `hh' `fmt' (`mat'[2,4])
	file write `hh' "} &"         _n

	file write `hh' "\multicolumn{2}{c}{ "         	  
	file write `hh' `fmt' (`mat'[2,5])
	file write `hh' "} &"         _n

	file write `hh' "\multicolumn{1}{c}{ "         	  
	file write `hh' `fmt' (`mat'[2,6])
	file write `hh' "} "         _n


	file write `hh' " \" "\[`rh'] \hline"  _n   

*------------------------------*
* Subtitle 1: Population size  *
*------------------------------*

	file write `hh' "\textbf{(b) Pre-Treatment Variables} " 
	file write `hh' " \" "\[`rh'] "  _n   

*-------------------------------------------------*
* Fill the values of the pre-treatment variables  *
*-------------------------------------------------*

*Runs across rows
local pretreatlastrow=`np'*2+2
local p=1

forv i=3/`pretreatlastrow' {

		*runs across columns: for variables' rows
		if `i'/2-floor(`i'/2)!=0{
		
			local rn : word `p' of $pretreat
			local fmt ${`rn'_fmt}
   			if ("`label'"!="") local rn : variable label  `rn'
   			file write `hh' "`rn' & "
			local p=`p'+1

   		        	file write `hh' `fmt' (`mat'[`i',1]) " & "
   		        	file write `hh' `fmt' (`mat'[`i',2]) " & "

					file write `hh' "\multicolumn{2}{c}{ "         	  
					file write `hh' `fmt' (`mat'[`i',3])
					file write `hh' "} &"         _n

					file write `hh' "\multicolumn{1}{c}{ "         	  
					file write `hh' `fmt' (`mat'[`i',4])
					file write `hh' "} &"         _n

					file write `hh' "\multicolumn{2}{c}{ "         	  
					file write `hh' `fmt' (`mat'[`i',5])
					file write `hh' "} &"         _n

					file write `hh' "\multicolumn{1}{c}{ "         	  
					file write `hh' `fmt' (`mat'[`i',6])
					file write `hh' "} "         _n
				            	
            		file write `hh' " \" "\[0.05cm]  " _n
				}

		*runs across columns: for SD' rows
		if `i'/2-floor(`i'/2)==0{
   		file write `hh' " & "
   		        	file write `hh' "(" `fmt' (`mat'[`i',1]) ") & "
   		        	file write `hh' "(" `fmt' (`mat'[`i',2]) ") & "

					file write `hh' "\multicolumn{2}{c}{("         	  
					file write `hh' `fmt' (`mat'[`i',3])
					file write `hh' ")} &"         _n

					file write `hh' "\multicolumn{1}{c}{("         	  
					file write `hh' `fmt' (`mat'[`i',4])
					file write `hh' ")} &"         _n

					file write `hh' "\multicolumn{2}{c}{("         	  
					file write `hh' `fmt' (`mat'[`i',5])
					file write `hh' ")} &"         _n

					file write `hh' "\multicolumn{1}{c}{("         	  
					file write `hh' `fmt' (`mat'[`i',6])
					file write `hh' ")} "         _n

            		file write `hh' " \" "\[`rh']  " _n
				}

   }
		file write `hh' "\hline" _n

*------------------------------*
* Subtitle 2: Adult Outcomes   *
*------------------------------*

	file write `hh' "\textbf{(c) Adult Outcomes} &"
	file write `hh' "Treated &"
	file write `hh' "Control  &"
	file write `hh' "Actual &"
	file write `hh' "If Treated &"
	file write `hh' "Actual &"
	file write `hh' "Actual &"
	file write `hh' "Disadv. &"
	file write `hh' "Actual"

	file write `hh' " \" "\[0.02cm] "  _n   

	file write `hh' " &"
	file write `hh' " &"
	file write `hh' "  &"
	file write `hh' "&"
	file write `hh' " &"
	file write `hh' " &"
	file write `hh' " &"
	file write `hh' " Treated"
	file write `hh' " &"

					 
	file write `hh' " \" "\[`rh'] "  _n   

*----------------------------------------*
* Fill the values of the adult outcomes  *
*----------------------------------------*

*Runs across rows
local outcomeslastrow=(`np'+`no')*2+2
local outcomesfirstrow=`pretreatlastrow'+1
local o=1
forv i=`outcomesfirstrow'/`outcomeslastrow' {





		*runs across columns: for variables' rows
		if `i'/2-floor(`i'/2)!=0{

		local rn : word `o' of $outcomes
   		local fmt ${`rn'_fmt}
   		if ("`label'"!="") local rn : variable label  `rn'
   		file write `hh' "`rn' & "
		local o=`o'+1

   		        	file write `hh' `fmt' (`mat'[`i',1]) " & "
   		        	file write `hh' `fmt' (`mat'[`i',2]) " & "
   		        	file write `hh' `fmt' (`mat'[`i',3]) " & "
   		        	file write `hh' `fmt' (`mat'[`i',4]) " & "
   		        	file write `hh' `fmt' (`mat'[`i',5]) " & "
   		        	file write `hh' `fmt' (`mat'[`i',6]) " & "
   		        	file write `hh' `fmt' (`mat'[`i',7]) " & " 
   		        	file write `hh' `fmt' (`mat'[`i',8])  
				            	
            		file write `hh' " \" "\[0.05cm]  " _n
				}

		*runs across columns: for SD' rows
		if `i'/2-floor(`i'/2)==0{
   		        	file write `hh' " & "
		
   		        	file write `hh' "(" `fmt' (`mat'[`i',1]) ") & "
   		        	file write `hh' "(" `fmt' (`mat'[`i',2]) ") & "
   		        	file write `hh' "(" `fmt' (`mat'[`i',3]) ") & "
   		        	file write `hh' "(" `fmt' (`mat'[`i',4]) ") & "
   		        	file write `hh' "(" `fmt' (`mat'[`i',5]) ") & "
   		        	file write `hh' "(" `fmt' (`mat'[`i',6]) ") & "
   		        	file write `hh' "(" `fmt' (`mat'[`i',7]) ") & "
   		        	file write `hh' "(" `fmt' (`mat'[`i',8]) ")  "

            		file write `hh' " \" "\[`rh']  " _n
				}

   }

*--------------------*
* Subtitle 3: Gaps   *
*--------------------*

	file write `hh' "\hline \hline" _n
	file write `hh' "\textbf{(d) Gaps Applying $Prog} & "
	file write `hh' "\multicolumn{2}{c}{\textbf{Scenario 1:}} & "
	file write `hh' " &"
	file write `hh' "\multicolumn{4}{c}{\textbf{Scenario 2:}}  "
    file write `hh' " \" "\[`rh']  " _n

	file write `hh' " Pop. getting the program: & "
	file write `hh' "\multicolumn{2}{c}{No Action}   & "
	file write `hh' " &"
	file write `hh' "\multicolumn{4}{c}{Disadvantaged Blacks are Treated}  "
    file write `hh' " \" "\[0.02cm]  " _n

	local fmt %12.0fc
	
*-------------*
* Costs row   *
*-------------*

					file write `hh' "Cost of Intervention (2010 Mill.) &"         	  
					file write `hh' "\multicolumn{2}{c}{"         	  
					file write `hh' " 0 "
					file write `hh' "} &"         _n
					file write `hh' " &"
					file write `hh' "\multicolumn{4}{c}{"         	  
					file write `hh' `fmt' (`mat'[2,3]*${${prog}_cost})
					file write `hh' "} &"         _n

    file write `hh' " \" "\[`rh']  " _n
	file write `hh' "\hline" _n


*----------------------*
* Sub-Subtitle: Gaps   *
*----------------------*

	file write `hh' "&"
	file write `hh' "Intra-Black &"
	file write `hh' "Black-White &"
	file write `hh' " &"
	file write `hh' "Intra-Black &"
	file write `hh' "Change &"
	file write `hh' "Black-White &"
	file write `hh' "Change "
	file write `hh' " \" "\[0.02cm] "  _n   

	file write `hh' "&"
	file write `hh' "Gap &"
	file write `hh' "Gap &"
	file write `hh' " &"
	file write `hh' "Gap &"
	file write `hh' "in Gap &"
	file write `hh' "Gap &"
	file write `hh' "in Gap "
	file write `hh' " \" "\[0.01cm] "  _n   


	file write `hh' "\hline" _n

*--------------------*
* Filling the Gaps   *
*--------------------*

local r=1
foreach out in $outcomes{
		local fmt ${`out'_fmt}
   		if "`label'"!="" local rn : variable label  `out'
		local `out'_row=2+`np'*2+`r'*2-1
					file write `hh' "`rn' &"         	  
					file write `hh' `fmt' (`mat'[``out'_row',5]-`mat'[``out'_row',3])
					file write `hh' "&"         
					file write `hh' `fmt' (`mat'[``out'_row',8]-`mat'[``out'_row',6])
					file write `hh' "&"         
					file write `hh' "&"         
					file write `hh' `fmt' (`mat'[``out'_row',5]-`mat'[``out'_row',4])
					file write `hh' "&"   
					file write `hh' %12.0f ((   (`mat'[``out'_row',5]-`mat'[``out'_row',4])   )/(`mat'[``out'_row',5]-`mat'[``out'_row',3])-1)*100
					file write `hh' "\% &"   					      
					file write `hh' `fmt' (`mat'[``out'_row',8]-`mat'[``out'_row',7])
					file write `hh' "&"   
					file write `hh' %12.0f ((   (`mat'[``out'_row',8]-`mat'[``out'_row',7])   )/(`mat'[``out'_row',8]-`mat'[``out'_row',6])-1)*100
					file write `hh' "\% &"         _n
					local r=`r'+1
    file write `hh' " \" "\[`rh']  " _n
}

*---------------------------*
* End of Writing Contents   *
*---------------------------*

    file write `hh' "  `hg' `hg'  `hl' `hl' \end{tabular}" _n
	file write `hh' " \end{center} "  _n
	
	file write `hh' "	{\scriptsize  " _n
	file write `hh' "	{\raggedright " _n 
	file write `hh' " {\bfseries Notes:} The data on the $Prog "
	file write `hh' " subjects come from the ${${prog}_lab} dataset. For all other "
	file write `hh' " groups we rely on data in the ${${prog}_dataset} for individuals born between ${${prog}_years}. "
	file write `hh' "  The ${${prog}_dataset} weights are used to make each sample representative "
	file write `hh' " of its correlative in the population. Disadvantaged blacks meet the "
	file write `hh' " $Prog eligibility criteria. Non-disadvantaged blacks are those that do "
	file write `hh' " not meet $Prog eligibility. All blacks include disadvantaged and non-"
	file write `hh' " disadvantaged blacks and represent the U.S. population of blacks. All "
	file write `hh' " whites represents the entire U.S. population of whites. The first row in "
	file write `hh' " Panel (a) shows the sample sizes. The first two columns for the treatment " 
	file write `hh' " and control individuals and the last four columns for the different categories " 
	file write `hh' " of the ${${prog}_dataset}. The second row of Panel (a) shows how many individuals are "
	file write `hh' " represented by the sample that we consider. Panel (b) describes the pre- "
	file write `hh' " treatment variables for $Prog and the ${${prog}_dataset}. The pretreatment characteristics " 
	file write `hh' " of the control and treatment groups in $Prog are similar because of the "
	file write `hh' " randomized nature of the experiment; our exercise gains validity if these " 
	file write `hh' " are similar to the characteristics of the disadvantaged group in the ${${prog}_dataset} " 
	file write `hh' " which are shown in the third column. The rest of the columns in Panel (b) " 
	file write `hh' " describe the pretreatment variables for the rest of the groups. Panel (c) "
	file write `hh' " describes adult outcomes. The first two columns do so for $Prog. The third column " 
	file write `hh' " describes the actual adult outcomes for the disadvantaged black in the ${${prog}_dataset}, "
	file write `hh' " while column four displays analogous information for the outcomes when the "
	file write `hh' " treatment effects of $Prog are applied. The fifth column presents adult outcomes "
	file write `hh' " for the non-disadvantaged blacks. The sixth and seventh columns present adult outcomes before "
	file write `hh' " and after the treatment effects of $Prog are applied. The "
	file write `hh' " eighth shows adult outcomes for whites. Panel (d) describes the outcome gaps. "
	file write `hh' " Scenario 1 is the baseline scenario, where $Prog is not available. In Scenario 2 "
	file write `hh' " the $Prog Program is available to all disadvantaged blacks. The intra-"
	file write `hh' " black gap measures the difference in adult outcomes between the non-"
	file write `hh' " disadvantaged black population and the disadvantaged black population. " 
	file write `hh' " The black-white gap compares the difference in adult outcomes between the "
	file write `hh' " whole black population and the whole white population. The first two columns "
	file write `hh' " show the gaps under Scenario 1. The last four columns present the gaps under "
	file write `hh' " Scenario 2 and the percent changes from the gaps under Scenario 1. "
	file write `hh' "} } " _n


    file write `hh' " \end{table}" _n
    file close `hh'

end
