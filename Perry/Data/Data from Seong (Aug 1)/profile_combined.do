

clear 
set mem 300m 
set more off 

use C:\Seong\Perry\Outcomes_2007\EarningsProfiles\earnings_proj_.dta

keep id male group dead40 id_19-id_43 edu_19-edu_43 empp_19-empp_43 status_19-status_43 wtenure_19-wtenure_43 mearn_19-mearn_43 mearn_aa_19-mearn_aa_43 mearn_bb_19-mearn_bb_43 mearn_cc_19-mearn_cc_43 fbirthage dteenbirth mary_27 mary_40 marm_27 marm_40 HScost GEDtuit coltuit colcost tuit_2740 educost_2740 voc_cost everwelf27 everwelf40 everwelflife welfmth27 welfmth40 welfamt40 

sort id 

merge id using C:\Seong\Perry\Data\kids_temp.dta 
drop _merge 

append using C:\Seong\Perry\Outcomes_2007\EarningsProfiles\0320\NLSYprofile.dta

quietly gen     perry=1 if id<=123 
quietly replace perry=0 if perry==. 

quietly replace nchild_born_27=birth27 if perry==1
quietly replace nchild_born_40=birth40 if perry==1
quietly gen child1927=nchild_born_27
quietly gen child2740=nchild_born_40-nchild_born_27
quietly replace child2740=0 if child2740~=. & child2740<0

quietly replace marm_27=mary_27*12 if perry==0
quietly replace marm_40=mary_40*12 if perry==0
quietly gen marm1927=marm_27
quietly gen marm2740=marm_40-marm_27

forval age=19(1)43 { 
       quietly replace id_`age'=1 if perry==0 & id_`age'~=. 
       }

egen    fage=rsum(id_19-id_43)
quietly replace fage=fage+18

quietly replace dead40=2 if perry==0 & fage<40

forval age=44(1)65 { 
       quietly gen id_`age'=. 
       }

quietly replace id=caseid+123 if id==.

forval age=44(1)65 { 
       quietly gen empp_`age'=. 
       }
forval age=44(1)65 { 
       quietly gen mearn_bb_`age'=. 
       }

forval age=19(1)43 { 
       forval level=0(1)5 { 
              quietly gen     dedu`level'_`age'=1 if edu_`age'==`level'
              quietly replace dedu`level'_`age'=0 if dedu`level'_`age'==. 
              } 
       } 

forval age=19(1)43 { 
       quietly replace prison_`age'=1 if perry==1 & status_`age'==3
       } 

forval age=19(1)43 { 
       quietly gen nobs_`age'=0
       forval age_p=19(1)`age' { 
              quietly replace nobs_`age'=nobs_`age'+1 if empp_`age_p'~=. 
              } 
       quietly egen   nempp_`age'=rsum(empp_19-empp_`age')
       quietly egen nprison_`age'=rsum(prison_19-prison_`age')
       
       quietly gen  exp_`age'=nempp_`age'
       quietly gen exp2_`age'=exp_`age'^2
       } 
forval age=19(1)43 { 
       quietly gen wtenure2_`age'=wtenure_`age'^2
       }
quietly gen rprison3140=(nprison_40-nprison_30)/10

forval age=19(1)43 {
       quietly gen     lmearn_bb_`age'=ln(mearn_bb_`age') if  mearn_bb_`age'~=. & mearn_bb_`age'>1
       quietly replace lmearn_bb_`age'=0                  if lmearn_bb_`age'==. & mearn_bb_`age'~=. & mearn_bb_`age'<=1
       }

gen eduf=. 
forval age=43(-1)19 { 
       quietly replace eduf=edu_`age' if eduf==. 
       }

sort id 
save "C:\Seong\Perry\Outcomes_2008\0624_recal\codes\bootstrapping\profile_combined.dta", replace
