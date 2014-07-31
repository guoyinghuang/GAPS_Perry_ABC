
***From this we should run every result in the paper \


*Change 1: the title... I had no last name :(
*Change Pending: put the .do files used in all the evaluations in a 
*                        .do file outside the evaluation particular folders 
*                        and then the particular evaluation .do files in other 
*                        inside. We need to do that after Andrés fixes his code 
*                        to avoid confusing him by now.

/*

Title:		Driver File for Intra-black and Black-White Gaps
Project:	Extension of ECIs to all the population
Authors:	Andres Hojman, Jake Torcasso, Jorge García
Date:		08/04/13

*/
        

//Giving global names to all relevant directories
global klmshare: env klmshare
cd "${klmshare}"
#delimit ;
cd "ERC_Projects";global erc_projects: pwd; cd "ecipop"; global ecipop: pwd; 
cd "Perry"; global perry: pwd; cd "DoFiles"; global dofiles: pwd; cd ..;
cd "Data"; global data: pwd; cd ${ecipop}; cd "Write-up"; global writeup: pwd;
*cd "figures"; global figures: pwd;
#delimit cr


*Results for Perry
*Set global variables

*Change 3: declare the global variables for the pretreatment and outcome variables

*global the pretreatment variables
global pretreat mhgc afqt numsibs welfare_amt
*global the outcomes	
global outcomes dedu3_27 empp_27 inc_27 empp_40 inc_40

*Change 4: put outside all the .do files to have clear what is running when
*          it is important to run income_deciles first and then the matriced
*          because of the current storage at each step

cd ${dofiles}
do UseS

cd ${dofiles}
do income_deciles

cd ${dofiles}
do "Constructing_the_Matrices"


