
clear 
clear matrix
clear mata
set more off
set maxvar 5000
set matsize 6000


cd "C:\MyResearch\ABC\working\2012\1202\" 


use C:\MyData\PSID\data\forABC\black_PSID_3_8_11.dta

/***** Generate key variables *****/ 

quietly gen key_yob =1 if 1971<=yob & yob<=1980

quietly gen     key_male=1 if sex==1
quietly replace key_male=0 if sex==2 

quietly gen     key_black=black 

/*
quietly gen relhead0=. 
forval year=71(1)80 { 
       quietly gen     relhead_`year'=related`year' 
       quietly replace relhead0      =relhead_`year'           if yob==1900+`year' 
       } 
quietly drop relhead_*
*/

quietly gen agema0=. 
forval year=1971(1)1980 { 
       quietly gen     agema_`year'= yob - yobmother if yob==`year' 
       quietly replace agema0=agema_`year'           if yob==`year' & agema0==. & agema_`year'>0
       } 
quietly drop agema_*
       
quietly gen marst0_2=. 
quietly replace marst0_2=1 if marryb==1
quietly replace marst0_2=0 if 2<=marryb & marryb<=5

save C:\MyResearch\ABC\working\2012\1202\PSID_main_working.dta, replace 


/* edma0 */ 
use C:\MyResearch\ABC\working\2012\1202\PSID_main_working.dta
keep if mid~=. 
quietly gen k_sample=1 
rename mid mid68
keep famid68 num68 mid68 k_sample
sort mid68
save C:\MyResearch\ABC\working\2012\1202\ksample_temp.dta, replace 

use C:\MyResearch\ABC\working\2012\1202\PSID_main_working.dta
quietly gen mid68=famid68*1000+num68 
keep mid68 grade* 
rename grade* mgrade* 
sort mid68
save C:\MyResearch\ABC\working\2012\1202\msample_temp.dta, replace 

use  C:\MyResearch\ABC\working\2012\1202\ksample_temp.dta
merge m:1 mid68 using C:\MyResearch\ABC\working\2012\1202\msample_temp.dta
drop _merge 
keep if k_sample==1
sort famid68 num68
save C:\MyResearch\ABC\working\2012\1202\ksample_temp.dta, replace 
 
use C:\MyResearch\ABC\working\2012\1202\PSID_main_working.dta
sort famid68 num68 
merge 1:1 famid68 num68 using  C:\MyResearch\ABC\working\2012\1202\ksample_temp.dta
drop _merge 

quietly gen edma0=. 
forval year=71(1)80 { 
       quietly replace mgrade`year'=. if mgrade`year'==0 | 90<mgrade`year'
       quietly replace edma0=mgrade`year' if edma0==. & yob==1900 + `year' 
       quietly replace edma0=mgrade`year' if edma0==.  
       }  
gen m_test_sample=1
sort mid68
save C:\MyResearch\ABC\working\2012\1202\PSID_main_working.dta, replace 


/* Get mother's IQ from 1972 test */ 
use C:\MyResearch\ABC\working\2012\1202\PSID_main_working.dta
drop mid68
rename id mid68
keep mid68 IQscore
keep if IQscore~=. 
rename IQscore mIQscore
sort mid68
save C:\MyResearch\ABC\working\2012\1202\PSID_m_test_temp.dta, replace  

use C:\MyResearch\ABC\working\2012\1202\PSID_main_working.dta
merge m:1 mid68 using C:\MyResearch\ABC\working\2012\1202\PSID_m_test_temp.dta, update
drop _merge 
keep if m_test_sample==1
sort famid68 num68 



/* gen family income */ 
       
quietly gen fincome0=. 
forval year=71(1)80 { 
       quietly replace fincome0=income_hw_taxable`year' if yob==1900 + `year'
       }  

#delimit; 
gen key=1 if key_yob  ==1 & 
             key_black==1 &
             agema0~=. & agema0>0
             ; 
#delimit cr 



/***** Construct HRI *****/




save PSID_main_working.dta, replace 

/***** Generate Output file *****/ 

gen PSID=1 
keep if key==1 
keep famid68 num68 id PSID yob key_male agema0 marst0_2 edma0 fincome0 mIQscore

rename key_male  male 



save PSID_match_working.dta, replace 

 
