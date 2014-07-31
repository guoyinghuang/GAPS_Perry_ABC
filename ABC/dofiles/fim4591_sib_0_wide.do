cd ${dataraw}
#delimit ;

**************************************************************************
   Label           : fim4591_sib_0_wide
   Rows            : 31255
   Columns         : 71
   ASCII File Date : August 7, 2013
*************************************************************************;


infix 
         ER30001             1 - 4    
         ER30002             5 - 7    
         SEX                 8 - 8    
         ID68_S01            9 - 12   
         PN_S01             13 - 15   
         SEX_S01            16 - 16   
         TYPE_S01           17 - 17   
         ID68_S02           18 - 21   
         PN_S02             22 - 24   
         SEX_S02            25 - 25   
         TYPE_S02           26 - 26   
         ID68_S03           27 - 30   
         PN_S03             31 - 33   
         SEX_S03            34 - 34   
         TYPE_S03           35 - 35   
         ID68_S04           36 - 39   
         PN_S04             40 - 42   
         SEX_S04            43 - 43   
         TYPE_S04           44 - 44   
         ID68_S05           45 - 48   
         PN_S05             49 - 51   
         SEX_S05            52 - 52   
         TYPE_S05           53 - 53   
         ID68_S06           54 - 57   
         PN_S06             58 - 60   
         SEX_S06            61 - 61   
         TYPE_S06           62 - 62   
         ID68_S07           63 - 66   
         PN_S07             67 - 69   
         SEX_S07            70 - 70   
         TYPE_S07           71 - 71   
         ID68_S08           72 - 75   
         PN_S08             76 - 78   
         SEX_S08            79 - 79   
         TYPE_S08           80 - 80   
         ID68_S09           81 - 84   
         PN_S09             85 - 87   
         SEX_S09            88 - 88   
         TYPE_S09           89 - 89   
         ID68_S10           90 - 93   
         PN_S10             94 - 96   
         SEX_S10            97 - 97   
         TYPE_S10           98 - 98   
         ID68_S11           99 - 102  
         PN_S11            103 - 105  
         SEX_S11           106 - 106  
         TYPE_S11          107 - 107  
         ID68_S12          108 - 111  
         PN_S12            112 - 114  
         SEX_S12           115 - 115  
         TYPE_S12          116 - 116  
         ID68_S13          117 - 120  
         PN_S13            121 - 123  
         SEX_S13           124 - 124  
         TYPE_S13          125 - 125  
         ID68_S14          126 - 129  
         PN_S14            130 - 132  
         SEX_S14           133 - 133  
         TYPE_S14          134 - 134  
         ID68_S15          135 - 138  
         PN_S15            139 - 141  
         SEX_S15           142 - 142  
         TYPE_S15          143 - 143  
         ID68_S16          144 - 147  
         PN_S16            148 - 150  
         SEX_S16           151 - 151  
         TYPE_S16          152 - 152  
         ID68_S17          153 - 156  
         PN_S17            157 - 159  
         SEX_S17           160 - 160  
         TYPE_S17          161 - 161  
using fim4591_sib_0_wide.txt, clear 
;
label variable  ER30001            "1968 INTERVIEW # OF INDIVIDUAL" ;
label variable  ER30002            "PERSON # OF INDIVIDUAL" ;
label variable  SEX                "GENDER OF INDIVIDUAL" ;
label variable  ID68_S01           "1968 INTERVIEW # OF SIBLING" ;
label variable  PN_S01             "PERSON # OF SIBLING" ;
label variable  SEX_S01            "GENDER OF SIBLING" ;
label variable  TYPE_S01           "TYPE OF SIBLING" ;
label variable  ID68_S02           "1968 INTERVIEW # OF SIBLING" ;
label variable  PN_S02             "PERSON # OF SIBLING" ;
label variable  SEX_S02            "GENDER OF SIBLING" ;
label variable  TYPE_S02           "TYPE OF SIBLING" ;
label variable  ID68_S03           "1968 INTERVIEW # OF SIBLING" ;
label variable  PN_S03             "PERSON # OF SIBLING" ;
label variable  SEX_S03            "GENDER OF SIBLING" ;
label variable  TYPE_S03           "TYPE OF SIBLING" ;
label variable  ID68_S04           "1968 INTERVIEW # OF SIBLING" ;
label variable  PN_S04             "PERSON # OF SIBLING" ;
label variable  SEX_S04            "GENDER OF SIBLING" ;
label variable  TYPE_S04           "TYPE OF SIBLING" ;
label variable  ID68_S05           "1968 INTERVIEW # OF SIBLING" ;
label variable  PN_S05             "PERSON # OF SIBLING" ;
label variable  SEX_S05            "GENDER OF SIBLING" ;
label variable  TYPE_S05           "TYPE OF SIBLING" ;
label variable  ID68_S06           "1968 INTERVIEW # OF SIBLING" ;
label variable  PN_S06             "PERSON # OF SIBLING" ;
label variable  SEX_S06            "GENDER OF SIBLING" ;
label variable  TYPE_S06           "TYPE OF SIBLING" ;
label variable  ID68_S07           "1968 INTERVIEW # OF SIBLING" ;
label variable  PN_S07             "PERSON # OF SIBLING" ;
label variable  SEX_S07            "GENDER OF SIBLING" ;
label variable  TYPE_S07           "TYPE OF SIBLING" ;
label variable  ID68_S08           "1968 INTERVIEW # OF SIBLING" ;
label variable  PN_S08             "PERSON # OF SIBLING" ;
label variable  SEX_S08            "GENDER OF SIBLING" ;
label variable  TYPE_S08           "TYPE OF SIBLING" ;
label variable  ID68_S09           "1968 INTERVIEW # OF SIBLING" ;
label variable  PN_S09             "PERSON # OF SIBLING" ;
label variable  SEX_S09            "GENDER OF SIBLING" ;
label variable  TYPE_S09           "TYPE OF SIBLING" ;
label variable  ID68_S10           "1968 INTERVIEW # OF SIBLING" ;
label variable  PN_S10             "PERSON # OF SIBLING" ;
label variable  SEX_S10            "GENDER OF SIBLING" ;
label variable  TYPE_S10           "TYPE OF SIBLING" ;
label variable  ID68_S11           "1968 INTERVIEW # OF SIBLING" ;
label variable  PN_S11             "PERSON # OF SIBLING" ;
label variable  SEX_S11            "GENDER OF SIBLING" ;
label variable  TYPE_S11           "TYPE OF SIBLING" ;
label variable  ID68_S12           "1968 INTERVIEW # OF SIBLING" ;
label variable  PN_S12             "PERSON # OF SIBLING" ;
label variable  SEX_S12            "GENDER OF SIBLING" ;
label variable  TYPE_S12           "TYPE OF SIBLING" ;
label variable  ID68_S13           "1968 INTERVIEW # OF SIBLING" ;
label variable  PN_S13             "PERSON # OF SIBLING" ;
label variable  SEX_S13            "GENDER OF SIBLING" ;
label variable  TYPE_S13           "TYPE OF SIBLING" ;
label variable  ID68_S14           "1968 INTERVIEW # OF SIBLING" ;
label variable  PN_S14             "PERSON # OF SIBLING" ;
label variable  SEX_S14            "GENDER OF SIBLING" ;
label variable  TYPE_S14           "TYPE OF SIBLING" ;
label variable  ID68_S15           "1968 INTERVIEW # OF SIBLING" ;
label variable  PN_S15             "PERSON # OF SIBLING" ;
label variable  SEX_S15            "GENDER OF SIBLING" ;
label variable  TYPE_S15           "TYPE OF SIBLING" ;
label variable  ID68_S16           "1968 INTERVIEW # OF SIBLING" ;
label variable  PN_S16             "PERSON # OF SIBLING" ;
label variable  SEX_S16            "GENDER OF SIBLING" ;
label variable  TYPE_S16           "TYPE OF SIBLING" ;
label variable  ID68_S17           "1968 INTERVIEW # OF SIBLING" ;
label variable  PN_S17             "PERSON # OF SIBLING" ;
label variable  SEX_S17            "GENDER OF SIBLING" ;
label variable  TYPE_S17           "TYPE OF SIBLING" ;
