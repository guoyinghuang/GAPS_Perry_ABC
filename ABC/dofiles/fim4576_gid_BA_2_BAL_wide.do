cd ${dataraw}
#delimit ;

**************************************************************************
   Label           : fim4576_gid_BA_2_BAL_wide
   Rows            : 35933
   Columns         : 10
   ASCII File Date : July 30, 2013
*************************************************************************;


infix 
         ER30001             1 - 4    
         ER30002             5 - 7    
         ER30001_P_AF        8 - 11   
         ER30002_P_AF       12 - 14   
         ER30001_P_AM       15 - 18   
         ER30002_P_AM       19 - 21   
         ER30001_P_F        22 - 25   
         ER30002_P_F        26 - 28   
         ER30001_P_M        29 - 32   
         ER30002_P_M        33 - 35  
using fim4576_gid_BA_2_BAL_wide.txt, clear 
;
label variable  ER30001            "1968 INTERVIEW NUMBER" ;
label variable  ER30002            "PERSON NUMBER 68" ;
label variable  ER30001_P_AF       "1968 INTERVIEW NUMBER /PARENT /ADOPTIVE FATHER" ;
label variable  ER30002_P_AF       "PERSON NUMBER 68 /PARENT /ADOPTIVE FATHER" ;
label variable  ER30001_P_AM       "1968 INTERVIEW NUMBER /PARENT /ADOPTIVE MOTHER" ;
label variable  ER30002_P_AM       "PERSON NUMBER 68 /PARENT /ADOPTIVE MOTHER" ;
label variable  ER30001_P_F        "1968 INTERVIEW NUMBER /PARENT /FATHER" ;
label variable  ER30002_P_F        "PERSON NUMBER 68 /PARENT /FATHER" ;
label variable  ER30001_P_M        "1968 INTERVIEW NUMBER /PARENT /MOTHER" ;
label variable  ER30002_P_M        "PERSON NUMBER 68 /PARENT /MOTHER" ;
