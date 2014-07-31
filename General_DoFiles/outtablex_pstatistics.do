*-------------------------------------------------------------------------------------*
* THIS FILE WRITES A TABLE FOR THE IMPACT OF THE ECI's in the GENERAL POPULATION GAPS *
* Author: Andrés
* Other stars in the movie: Jorge, Jake, Rodrigo, Seong

* Inputs: A huge matrix that has a similar form as the output table. It is created by "Constructing the Matrices.do"

cap program drop outtablex_pstatistics
program define outtablex_pstatistics,rclass
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

************

	file write `hh' "&"
	file write `hh' "\multicolumn{2}{c}{Scenario 1: No Action} &"
	file write `hh' "\multicolumn{6}{c}{Scenario 2: Disadvantaged Black Treated} "
	file write `hh' " \" "\[0.05cm] " 
    file write `hh' "\hline" _n 

************

*----------------------*
* SubPanel 1: Female   *
*----------------------*

*Redefine labels to go through the same loops



	file write `hh' " \textbf{(a) Female:} & "
	file write `hh' "\multicolumn{2}{c}{}   & "
	file write `hh' " &"
	file write `hh' "\multicolumn{4}{c}{}  "
	file write `hh' " \" "\[0.02cm] "  _n

	local fmt %12.0fc

*-------------*
* Total row   *
*-------------*

					file write `hh' "\textbf{Individuals Treated} &"         	  
					file write `hh' "\multicolumn{2}{c}{"         	  
					file write `hh' " 0 "
					file write `hh' "} &"         _n
					file write `hh' " &"
					file write `hh' "\multicolumn{4}{c}{"         	  
					file write `hh' `fmt' (`mat'[2,3])
					file write `hh' "} &"         _n
					file write `hh' " \" "\[`rh']  " _n
	
*-------------*
* Costs row   *
*-------------*

					file write `hh' "\textbf{Cost of Intervention (2010 Mill.)} &"         	  
					file write `hh' "\multicolumn{2}{c}{"         	  
					file write `hh' " 0 "
					file write `hh' "} &"         _n
					file write `hh' " &"
					file write `hh' "\multicolumn{4}{c}{"         	  
					file write `hh' `fmt' (`mat'[2,3]*${${prog}_cost})
					file write `hh' "} &"         _n
					file write `hh' " \" "\[`rh']  " _n
					
*----------------------*
* Sub-Subtitle: Gaps   *
*----------------------*

	file write `hh' "\textbf{Gaps}&"
	file write `hh' "Intra-Black &"
	file write `hh' "Black-White &"
	file write `hh' " &"
	file write `hh' "Intra-Black &"
	file write `hh' "Change &"
	file write `hh' "Black-White &"
	file write `hh' "Change "
	file write `hh' " \" "\[0.02cm] "  _n   
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

*----------------------*
* SubPanel 1: Male     *
*----------------------*

*Rename the labels to go through the same loop
	
	file write `hh' "\hline" _n
	file write `hh' " \textbf{(b) Male:} & "
	file write `hh' "\multicolumn{2}{c}{}   & "
	file write `hh' " &"
	file write `hh' "\multicolumn{4}{c}{}  "
	file write `hh' " \" "\[0.02cm] "  _n

	local fmt %12.0fc

*-------------*
* Total row   *
*-------------*

					file write `hh' "\textbf{Individuals Treated} &"         	  
					file write `hh' "\multicolumn{2}{c}{"         	  
					file write `hh' " 0 "
					file write `hh' "} &"         _n
					file write `hh' " &"
					file write `hh' "\multicolumn{4}{c}{"         	  
					file write `hh' `fmt' (`mat'[2,11])
					file write `hh' "} &"         _n
					file write `hh' " \" "\[`rh']  " _n
					
*-------------*
* Costs row   *
*-------------*

					file write `hh' "\textbf{Cost of Intervention (2010 Mill.)} &"         	  
					file write `hh' "\multicolumn{2}{c}{"         	  
					file write `hh' " 0 "
					file write `hh' "} &"         _n
					file write `hh' " &"
					file write `hh' "\multicolumn{4}{c}{"         	  
					file write `hh' `fmt' (`mat'[2,11]*${${prog}_cost})
					file write `hh' "} &"         _n
					file write `hh' " \" "\[`rh']  " _n
					
*----------------------*
* Sub-Subtitle: Gaps   *
*----------------------*

	file write `hh' "\textbf{Gaps}&"
	file write `hh' "Intra-Black &"
	file write `hh' "Black-White &"
	file write `hh' " &"
	file write `hh' "Intra-Black &"
	file write `hh' "Change &"
	file write `hh' "Black-White &"
	file write `hh' "Change "
	file write `hh' " \" "\[0.02cm] "  _n   
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
					file write `hh' `fmt' (`mat'[``out'_row',13]-`mat'[``out'_row',11])
					file write `hh' "&"         
					file write `hh' `fmt' (`mat'[``out'_row',16]-`mat'[``out'_row',14])
					file write `hh' "&"         
					file write `hh' "&"         
					file write `hh' `fmt' (`mat'[``out'_row',13]-`mat'[``out'_row',12])
					file write `hh' "&"   
					file write `hh' %12.0f ((   (`mat'[``out'_row',13]-`mat'[``out'_row',12])   )/(`mat'[``out'_row',13]-`mat'[``out'_row',11])-1)*100
					file write `hh' "\% &"   					      
					file write `hh' `fmt' (`mat'[``out'_row',16]-`mat'[``out'_row',15])
					file write `hh' "&"   
					file write `hh' %12.0f ((   (`mat'[``out'_row',16]-`mat'[``out'_row',15])   )/(`mat'[``out'_row',16]-`mat'[``out'_row',14])-1)*100
					file write `hh' "\% &"         _n
					local r=`r'+1
    file write `hh' " \" "\[`rh']  " _n
}

*----------------------*
* SubPanel 1: All      *
*----------------------*

*Rename the labels to go through the same loop
	
	file write `hh' "\hline" _n
	file write `hh' " \textbf{(c) All:} & "
	file write `hh' "\multicolumn{2}{c}{}   & "
	file write `hh' " &"
	file write `hh' "\multicolumn{4}{c}{}  "
	file write `hh' " \" "\[0.02cm] "  _n

	local fmt %12.0fc

*-------------*
* Total row   *
*-------------*

					file write `hh' "\textbf{Individuals Treated} &"         	  
					file write `hh' "\multicolumn{2}{c}{"         	  
					file write `hh' " 0 "
					file write `hh' "} &"         _n
					file write `hh' " &"
					file write `hh' "\multicolumn{4}{c}{"         	  
					file write `hh' `fmt' (`mat'[2,3] + `mat'[2,11])
					file write `hh' "} &"         _n
					file write `hh' " \" "\[`rh']  " _n
	
*-------------*
* Costs row   *
*-------------*

					file write `hh' "\textbf{Cost of Intervention (2010 Mill.)} &"         	  
					file write `hh' "\multicolumn{2}{c}{"         	  
					file write `hh' " 0 "
					file write `hh' "} &"         _n
					file write `hh' " &"
					file write `hh' "\multicolumn{4}{c}{"         	  
					file write `hh' `fmt' (`mat'[2,3]*${${prog}_cost} + `mat'[2,11]*${${prog}_cost})
					file write `hh' "} &"         _n
					file write `hh' " \" "\[`rh']  " _n
					
*----------------------*
* Sub-Subtitle: Gaps   *
*----------------------*

	file write `hh' "\textbf{Gaps}&"
	file write `hh' "Intra-Black &"
	file write `hh' "Black-White &"
	file write `hh' " &"
	file write `hh' "Intra-Black &"
	file write `hh' "Change &"
	file write `hh' "Black-White &"
	file write `hh' "Change "
	file write `hh' " \" "\[0.02cm] "  _n   
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
					file write `hh' `fmt' (`mat'[``out'_row',21]-`mat'[``out'_row',19])
					file write `hh' "&"         
					file write `hh' `fmt' (`mat'[``out'_row',24]-`mat'[``out'_row',22])
					file write `hh' "&"         
					file write `hh' "&"         
					file write `hh' `fmt' (`mat'[``out'_row',21]-`mat'[``out'_row',20])
					file write `hh' "&"   
					file write `hh' %12.0f ((   (`mat'[``out'_row',21]-`mat'[``out'_row',20])   )/(`mat'[``out'_row',21]-`mat'[``out'_row',19])-1)*100
					file write `hh' "\% &"   					      
					file write `hh' `fmt' (`mat'[``out'_row',24]-`mat'[``out'_row',23])
					file write `hh' "&"   
					file write `hh' %12.0f ((   (`mat'[``out'_row',24]-`mat'[``out'_row',23])   )/(`mat'[``out'_row',24]-`mat'[``out'_row',22])-1)*100
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
	file write `hh' "{\bfseries Notes:} Panels (a), (b), and (c) present restults for female,"
	file write `hh' " male, and the overall population, respectively. The ${${prog}_dataset} weights are used to make each sample representative"
	file write `hh' " of its corresponding in the population. Disadvantaged blacks meet the "
	file write `hh' " $Prog eligibility criteria. Non-disadvantaged blacks do "
	file write `hh' " not. All blacks include disadvantaged and non-"
	file write `hh' " disadvantaged blacks and represent the U.S. population of blacks. All "
	file write `hh' " whites represents the entire U.S. population of whites. "
	file write `hh' " Scenario 1 is the baseline scenario, where $Prog is not available. Scenario 2 "
	file write `hh' " makes the $Prog Program available to all disadvantaged blacks. The intra-"
	file write `hh' " black gap measures the difference in adult outcomes between the non-"
	file write `hh' " disadvantaged black population and the disadvantaged black population. " 
	file write `hh' " The black-white gap compares the difference in adult outcomes between the "
	file write `hh' " whole black population and the whole white population. The cost is expressed in 2010 millions of dollars."
	file write `hh' " In the subsection that presents the gaps the first two columns display the actual gaps. The third column shows"
	file write `hh' " the gap after the treatment effects of Perry are applied to the disadvantaged black. The fourth column presents the"
	file write `hh' " the percentagae change between the first and the third columns. The fifth colum displays the black-white gap"
	file write `hh' " after the treatment effects of $Prog are applied to the disadvantaged black.  The last column presents the"
	file write `hh' " the percentagae change between the fifth and the second columns."
	file write `hh' "} } " _n

    file write `hh' " \end{table}" _n
    file close `hh'

end

