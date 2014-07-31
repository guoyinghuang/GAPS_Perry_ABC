*-------------------------------------------------------------------------------------*
* THIS FILE WRITES A TABLE  *
* Author: Andrs

cap program drop outtablex_pretreat
program define outtablex_pretreat,rclass
version 8.0
syntax using/, mat(string) [Replace APPend noBOX Stack Left ASIS fsize(string) CAPtion(string) asis Format(string) noROWlab longtable clabel(string) label ] ///
[row1s1(string) row1s2(string)  row1s3(string) row1c1(string)   row1c2(string) row1c3(string) row1s4(string) row1c4(string) row1s5(string) row1c5(string) row1s6(string) row1c6(string) row1s7(string) row1c7(string)] ///
[row2s1(string) row2s2(string)  row2s3(string) row2c1(string)   row2c2(string) row2c3(string) row2s4(string) row2c4(string) row2s5(string) row2c5(string) row2s6(string) row2c6(string) row2s7(string) row2c7(string)] ///
[row3s1(string) row3s2(string)  row3s3(string) row3c1(string)   row3c2(string) row3c3(string) row3s4(string) row3c4(string) row3s5(string) row3c5(string) row3s6(string) row3c6(string) row3s7(string) row3c7(string)] ///

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

*-----------------------------------------------------*
* First subtitle row (options specified by the user)  *
*-----------------------------------------------------*

if "`row1s1'"!=""{
local rowcommands="  \multicolumn{`row1c1'}{c}{`row1s1'}" 
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
if "`row1s6'"!=""{
local rowcommands=" `rowcommands'  & \multicolumn{`row1c6'}{c}{`row1s6'}" 
}
if "`row1s7'"!=""{
local rowcommands=" `rowcommands'  & \multicolumn{`row1c&'}{c}{`row1s7'}" 
}

	file write `hh' " `rowcommands' \" 	"\ "   

*------------------------------------------------------*
* Second subtitle row (options specified by the user)  *
*------------------------------------------------------*

if "`row2s1'"!=""{
local rowcommands="  \multicolumn{`row2c1'}{c}{`row2s1'}" 
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
if "`row2s6'"!=""{
local rowcommands=" `rowcommands'  & \multicolumn{`row2c6'}{c}{`row2s6'}" 
}
if "`row2s7'"!=""{
local rowcommands=" `rowcommands'  & \multicolumn{`row2c7'}{c}{`row2s7'}" 
}


	file write `hh' " `rowcommands' \" 	"\ "   

*------------------------------------------------------*
* Third subtitle row (options specified by the user)  *
*------------------------------------------------------*

if "`row3s1'"!=""{
local rowcommands="  \multicolumn{`row3c1'}{c}{`row3s1'}" 
}
else{
local rowcommands=" & "
}
if "`row3s2'"!=""{
local rowcommands=" `rowcommands'  & \multicolumn{`row3c2'}{c}{`row3s2'}" 
}
if "`row3s3'"!=""{
local rowcommands=" `rowcommands'  & \multicolumn{`row3c3'}{c}{`row3s3'}" 
}
if "`row3s4'"!=""{
local rowcommands=" `rowcommands'  & \multicolumn{`row3c4'}{c}{`row3s4'}" 
}
if "`row3s5'"!=""{
local rowcommands=" `rowcommands'  & \multicolumn{`row3c5'}{c}{`row3s5'}" 
}
if "`row3s6'"!=""{
local rowcommands=" `rowcommands'  & \multicolumn{`row3c6'}{c}{`row3s6'}" 
}
if "`row3s7'"!=""{
local rowcommands=" `rowcommands'  & \multicolumn{`row3c7'}{c}{`row3s7'}" 
}

	file write `hh' " `rowcommands' \" 	"\ "   
*Puts a horizontal line
    file write `hh'  " `hl' `hg'   " _n

*------------------------------------*
** Headings **
*------------------------------------*
local fmt "%12.0fc"
    file write `hh' "Population "
forv j=1/`nc' {
   	file write `hh'  " & "  `fmt' (`mat'[1,`j']) 
	}
	file write `hh' " \" "\[0.1cm]  " _n

local fmt "%12.2f"
    file write `hh' "Proportion of Total Population"
forv j=1/`nc' {
   	file write `hh'  " & "  `fmt' (`mat'[2,`j']) 
	}
    file write `hh' " \" "\[0.1cm]  " _n



*-------------------------------------------------*
* Fill the values of the pre-treatment variables  *
*-------------------------------------------------*
*Runs across rows
forv i=3/`nr' {

		*runs across columns: for variables' rows
		if `i'/2-floor(`i'/2)!=0{
				local rn : word `i' of `rnames'
				local fmt ${`rn'_fmt}
   				if ("`label'"!="") local rn : variable label  `rn'
   				file write `hh' "`rn' "
				forv j=1/`nc'{
   		        		file write `hh'  " & "  `fmt' (`mat'[`i',`j']) 
				        }	
            	file write `hh' " \" "\[0.05cm]  " _n
				}

		*runs across columns: for SD' rows
		if `i'/2-floor(`i'/2)==0{
				forv j=1/`nc'{
   		        	file write `hh' "& (" `fmt' (`mat'[`i',`j']) ")"
					}
            	file write `hh' " \" "\[0.05cm]  " _n
   				}
}
*---------------------------*
* End of Writing Contents   *
*---------------------------*

    file write `hh' "  `hg' `hg'  `hl' `hl' \end{tabular}" _n
	file write `hh' " \end{center} "  _n
	
	file write `hh' "	{\scriptsize  " _n
	file write `hh' "	{\raggedright " _n 
	file write `hh' "{\bfseries Notes:} The table shows the means of the variables indicated in the rows for the different groups " 
	file write `hh' " indicated in the columns. Standard Deviations are in parenthesis. The NLSY79/PSID weights are used to make each sample representative"
	file write `hh' " of its corresponding in the population. Disadvantaged blacks meet the "
	file write `hh' " respective eligibility criteria. (see \citet{Ramey_Smith_1977_AJMD} and \citet{heckman2010analyzing} ). Non-disadvantaged blacks do "
	file write `hh' " not. Non Disadv. Population includes non-disadvantaged blacks and all non-black people. "
	file write `hh' " Family Income is in 2010 dollars. It is measured as a 3-years average around the age of birth on the PSID,  "
	file write `hh' " and around age 14-20 in the NLSY. "
	file write `hh' "} } " _n
    file write `hh' " \end{table}" _n
    file close `hh'



end
