cd "${${prog}_data}"
use ${${prog}_ready_data}, clear
rename ${${prog}_edu} edu
rename ${${prog}_inc} ink








*I assume the incomes are already in 2010 dollars
	gen ink_cat=.
	replace ink_cat=1 if 			 	ink<=10000
	replace ink_cat=2 if ink>10000 	& 	ink<=15000
	replace ink_cat=3 if ink>15000 	& 	ink<=20000
	replace ink_cat=4 if ink>20000  &   ink<=25000
	replace ink_cat=5 if ink>25000 	& 	ink<=30000
	replace ink_cat=6 if ink>30000 	& 	ink<=35000
	replace ink_cat=7 if ink>35000 	

*I am not using this
	label def ink_cat 1 "10,000 or less" 2 "10,000 to 15,000" 3 "15,000 to 20,000 " 4 "20,000 to 25,000" 5 "25,000 to 30,000" 6 "30,000 to 35,000" 7 "35,000 and more"
	label val ink_cat ink_cat
	tab ink_cat if allkey==1

*I need to do this because we have imputed data in PSID
	gen edu_cat=.
	replace edu_cat=edu
	replace edu_cat=8 	if edu_cat<=8.5
	replace edu_cat=9 	if edu_cat>8.5 & edu_cat<=9.5
	replace edu_cat=10 	if edu_cat>9.5 & edu_cat<=10.5
	replace edu_cat=11 	if edu_cat>10.5 & edu_cat<=11.5
	replace edu_cat=12 	if edu_cat>11.5 & edu_cat<=12.5
	replace edu_cat=13 	if edu_cat>12.5	
	label def edu_cat 8 "8-" 13 "13+"
	label val edu_cat edu_cat

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

foreach group in b all{
gen densD`group'=.
gen densND`group'=.

bysort disad_`group': egen denominator`group'=sum(weight)
sum denominator`group' 					if disad_`group'==1
replace densD`group'=weight/r(mean) 	if disad_`group'==1
sum denominator`group' 					if disad_`group'==0
replace densND`group'=weight/r(mean) 	if disad_`group'==0

local alt_ink alternate
local nolab_ink nolab
local hg1abcb -0.02
local hg2abcb -0.055
local hg1abcall -0.02
local hg2abcall -0.055
local hg1perryb -0.008
local hg2perryb -0.02
local hg1perryall -0.016
local hg2perryall -0.040

local len1 =13-4
local len2 =13*2-3
local len3 =13*3-2
local len4 =13*4-1
local len5 =13*5
local len6 =13*6
local len7 =13*7

*Education
graph bar (sum) densD`group' densND`group', over(disad_`group', label(nolab) gap(-0.1))  over (edu_cat , gap(-0.1) ) ///
bargap(-0.1) graphregion(fcolor(white) )  														///
bar(1, color(gs2) )  bar(2, color(gs10) )														///
legend( order (1 "Disadvantaged" 2 "`label_`group''") reg(lc(white))  )  						
cd ${writeup}
graph export "${prog}_moedu_`group'.pdf", as(pdf) replace

*Income
graph bar (sum) densD`group' densND`group', over(disad_`group', label(nolab) gap(-0.1))  over (ink_cat , gap(-0.1) label(nolab) ) ///
bargap(-0.1) graphregion(fcolor(white) )  														///
bar(1, color(gs2) )  bar(2, color(gs10) )														///
legend( ring(100) order (1 "Disadvantaged" 2 "`label_`group''") reg(lc(white)) position(6)  bmargin(medlarge) 		)				///
text(`hg1${prog}`group'' `len1'  "10,000")  text(`hg1${prog}`group'' `len2'  "10,001 to") text(`hg1${prog}`group'' `len3'  "15,001 to")  text(`hg1${prog}`group'' `len4'  "20,001 to") ///
 text(`hg1${prog}`group'' `len5'  "25,001 to") text(`hg1${prog}`group'' `len6'  "30,001 to") text(`hg1${prog}`group'' `len7'  "35,001")  ///
text(`hg2${prog}`group'' `len1'  "or less") text(`hg2${prog}`group'' `len2'  "15,000")    text(`hg2${prog}`group'' `len3'  "20,000")  ///
text(`hg2${prog}`group'' `len4'  "25,000") text(`hg2${prog}`group'' `len5'  "30,000") text(`hg2${prog}`group'' `len6'  "35,000") text(`hg2${prog}`group'' `len7'  "or more") 
cd ${writeup}
graph export "${prog}_moink_`group'.pdf", as(pdf) replace

}


