clear
use "/Users/andreshojman/Google Drive/Forecasting-Backup/ABC-rawdata/Preschool/Data/birth12.dta"

rename agema0 	mo_age
rename edma0	mo_edu
rename edfa0	fa_edu
rename income_c	famincome
rename sibnum	sibnum

rename hrabc1	no_father
rename hrabc2	no_relatives
rename hrabc3	sib_behind
rename hrabc4	welfare
rename hrabc5	fa_unskilled
rename hrabc6	mo_lowiq
rename hrabc7	sib_lowiq
rename hrabc8	referral
rename hrabc9	prof_help
rename hrabc10	special

gen index=0
replace index=index+8 if mo_edu<=6
replace index=index+7 if mo_edu==7
replace index=index+6 if mo_edu==8
replace index=index+3 if mo_edu==9
replace index=index+2 if mo_edu==10
replace index=index+1 if mo_edu==11

replace index=index+8 if fa_edu<=6
replace index=index+7 if fa_edu==7
replace index=index+6 if fa_edu==8
replace index=index+3 if fa_edu==9
replace index=index+2 if fa_edu==10
replace index=index+1 if fa_edu==11

replace index=index+8 if famincome==1|famincome==2
replace index=index+7 if famincome==3
replace index=index+6 if famincome==4
replace index=index+5 if famincome==5
replace index=index+4 if famincome==6
replace index=index+0 if famincome==7
replace index=index+0 if famincome>=8

replace index=index+3 if no_father==1
replace index=index+3 if no_relatives==1
replace index=index+3 if sib_behind==1
replace index=index+3 if welfare==1
replace index=index+3 if fa_unskilled==1
replace index=index+3 if sib_lowiq==1
replace index=index+3 if mo_lowiq==1
replace index=index+3 if referral==1
replace index=index+1 if prof_help==1
replace index=index+1 if special==1

gen dif=index-hri0
count if dif==0
sum dif
sort dif

regress dif no_father no_relatives sib_behind welfare fa_unskilled mo_lowiq sib_lowiq referral prof_help special mo_edu fa_edu

asd
browse dif index hri0 no_father no_relatives sib_behind welfare fa_unskilled mo_lowiq sib_lowiq referral prof_help special mo_edu fa_edu famincome if fa_edu==.
