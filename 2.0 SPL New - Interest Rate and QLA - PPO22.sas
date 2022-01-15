/*SPL Interest Rate and QLA, New/Exp
Created on: January 10, 2022
Last Updated: January 14, 2022
Owner: Samia Ajaz  
Validation 1 = Y (Robert)
Validation 2 = N */


/****************************Import grid and assign variables**************************/

options MSGLEVEL=I;
proc import datafile = "/mnt/riskfileshare/~Processes/GDS Automation Testing/Documentation/Requirements/PPO 2022/PPO 5/SPL 75k QLA Grids/Input File - SPL Loan Size and Fees November all.xlsx" 
 out = SPLGrid
 dbms = xlsx
 replace;
run;

proc sql;
	create table spl_int_rate_new_var as 
		select * from tables.final_output_&type.;
quit;

data MQLA_prep;
	set spl_int_rate_new_var;

ApplicationID = VAR2;
Submitforapp2ind = upcase(VAR7);
DE_App1_Risk_Group = ; *[IJ]Why did we create this field?
DE_App2_Risk_Group = ;
RemainingIncome = Res_DE_Var205;
DE_App1_SPL_InterestRateControlG = Res_DE_Var30;
SPL_HomeEquity = Res_DE_Var155; *[IJ] should this be converted to a numb eric value? somewhere below we compare this to a numeric variable
cRes_DE_Var156 = round(input(Res_DE_Var156,12.));

keep
DE_SPL_RemainingIncome ApplicationID Submitforapp2ind
DE_Loan_Type DE_Auto_Product_Type DE_Auto_CASystemDecision 
DE_App1_Auto_AssignedCAStrategy DE_App2_Auto_AssignedCAStrategy
DE_App2_EFSCVRiskScore DE_App1_SPL_InterestRateControlG
App1Province App2Province SPL_HomeEquity VAR7
VAR24 VAR141 Res_DE_Var18 Res_DE_Var78 cRes_DE_Var156 var6 cRes_DE_Var202;
run;

data New_Full;
set MQLA_prep;

If VAR24 in ("ON - Ontario") then app1_new_province = "ON";
else If VAR24 in ("NL - Newfoundland and Labrador") then app1_new_province = "NL";
else If VAR24 in ("SK - Saskatchewan") then app1_new_province = "SK";
else If VAR24 in ("QC - Quebec") then app1_new_province = "QC";
else If VAR24 in ("AB - Alberta") then app1_new_province = "AB";
else If VAR24 in ("BC - British Columbia") then app1_new_province = "BC";
else If VAR24 in ("PE - Prince Edward Island") then app1_new_province = "PE";
else If VAR24 in ("NS - Nova Scotia") then app1_new_province = "NS";
else If VAR24 in ("NB - New Brunswick") then app1_new_province = "NB";
else If VAR24 in ("MB - Manitoba") then app1_new_province = "MB";
else app1_new_province = "Other";

If VAR141 in ("ON - Ontario") then app2_new_province = "ON";
else If VAR141 in ("NL - Newfoundland and Labrador") then app2_new_province = "NL";
else If VAR141 in ("SK - Saskatchewan") then app2_new_province = "SK";
else If VAR141 in ("QC - Quebec") then app2_new_province = "QC";
else If VAR141 in ("AB - Alberta") then app2_new_province = "AB";
else If VAR141 in ("BC - British Columbia") then app2_new_province = "BC";
else If VAR141 in ("PE - Prince Edward Island") then app2_new_province = "PE";
else If VAR141 in ("NS - Nova Scotia") then app2_new_province = "NS";
else If VAR141 in ("NB - New Brunswick") then app2_new_province = "NB";
else If VAR141 in ("MB - Manitoba") then app2_new_province = "MB";
else app2_new_province = "Other";

if SPL_HomeEquity < 0 then SPL_HomeEquity = 0;

cRes_DE_Var202=input(Res_DE_Var202,32.);
if missing(cRes_DE_Var202) 			then SPL_interest_rate= 0;
else if 23 le cRes_DE_Var202 le 24	then SPL_interest_rate_2399= 23.99;
else if 22 le cRes_DE_Var202 le 23 	then SPL_interest_rate_2299= 22.99;
else if 21 le cRes_DE_Var202 le 22 	then SPL_interest_rate_2199= 21.99;
else if 20 le cRes_DE_Var202 le 21 	then SPL_interest_rate_2099= 20.99;
else if 19 le cRes_DE_Var202 le 20	then SPL_interest_rate_1999= 19.99;
else if 18 le cRes_DE_Var202 le 19 	then SPL_interest_rate_1899= 18.99;
else if 17 le cRes_DE_Var202 le 18 	then SPL_interest_rate_1799= 17.99;
else if 16 le cRes_DE_Var202 le 17	then SPL_interest_rate_1699= 16.99;
else if 15 le cRes_DE_Var202 le 16	then SPL_interest_rate_1599= 15.99;
else if 14 le cRes_DE_Var202 le 15	then SPL_interest_rate_1499= 14.99;
else if 13 le cRes_DE_Var202 le 14	then SPL_interest_rate_1399= 13.99;
else if 12 le cRes_DE_Var202 le 13	then SPL_interest_rate_1299= 12.99;
else if 11 le cRes_DE_Var202 le 12	then SPL_interest_rate_1199= 11.99;
else if 10 le cRes_DE_Var202 le 11	then SPL_interest_rate_1099= 10.99;
else if 9 le cRes_DE_Var202 le 10 	then SPL_interest_rate_0999= 9.99;

/*Create App1 EFS_CV risk groups - Updated 2022*/
if Res_DE_Var18 > 682 then Risk_Group = 'Risk Group 1';
if Res_DE_Var18 <= 682 and Res_DE_Var18 >= 646 then Risk_Group = 'Risk Group 2';
if Res_DE_Var18 <= 645 and Res_DE_Var18 >= 627 then Risk_Group = 'Risk Group 3';
if Res_DE_Var18 <= 626 and Res_DE_Var18 >= 610 then Risk_Group = 'Risk Group 4';
if Res_DE_Var18 <= 609 and Res_DE_Var18 >= 593 then Risk_Group = 'Risk Group 5';
if Res_DE_Var18 <= 592 and Res_DE_Var18 >= 577 then Risk_Group = 'Risk Group 6';
if Res_DE_Var18 <= 576 and Res_DE_Var18 >= 565  then Risk_Group = 'Risk Group 7';
If 565 > Res_DE_Var18 then Risk_Group = 'FAIL';

/* Create App2 EFS_CV risk groups - Updated 2022 */
if Res_DE_Var78 > 682 then Risk_Group = 'Risk Group 1';
if Res_DE_Var78 <= 682 and Res_DE_Var78 >= 646 then Risk_Group = 'Risk Group 2';
if Res_DE_Var78 <= 645 and Res_DE_Var78 >= 627 then Risk_Group = 'Risk Group 3';
if Res_DE_Var78 <= 626 and Res_DE_Var78 >= 610 then Risk_Group = 'Risk Group 4';
if Res_DE_Var78 <= 609 and Res_DE_Var78 >= 593 then Risk_Group = 'Risk Group 5';
if Res_DE_Var78 <= 592 and Res_DE_Var78 >= 577 then Risk_Group = 'Risk Group 6';
if Res_DE_Var78 <= 576 and Res_DE_Var78  >= 565  then Risk_Group = 'Risk Group 7';
If 565 > Res_DE_Var78 then Risk_Group = 'FAIL';

App1_EFS_CV_Risk_Score = input(Res_DE_Var18,32.);
App2_EFS_CV_Risk_Score = input(Res_DE_Var78,32.);
run;

/****************************Check for App1 and App2**************************/

data SPL_Apps SPL_Apps2;
set New_Full;

where var253 = '1';

if Res_DE_Var172 ne "FAIL" then do;
/*				if Res_DE_Var27 = 'Champion_App1 SPL EFS CV New Loan QLA Strategy' then*/
output SPL_Apps;
			end;

if Res_DE_Var172 ne "FAIL" and var7 = "Y" then do;
/*	if Res_DE_Var27 = 'Champion_App1 SPL EFS CV New Loan QLA Strategy' then */
output SPL_Apps2;
end;
run;

/****************************Assign Interest Rate based on App1 EFSCVScore**************************/
data SPL_Apps;
set SPL_Apps;

if var6 = 'NEW' then do;
if Res_DE_Var7 = '007' then ; *[IJ] This wont work, you need extra do statement here
SPL_interest_rate_0999	= . ; 
SPL_interest_rate_1099	= . ; 
SPL_interest_rate_1199	= . ; 
SPL_interest_rate_1299	= . ; 
SPL_interest_rate_1399	= . ; 
SPL_interest_rate_1499	= . ; 
SPL_interest_rate_1599	= . ; 
SPL_interest_rate_1699	= . ; 
SPL_interest_rate_1799	= . ; 
SPL_interest_rate_1899	= . ; 
SPL_interest_rate_1999	= . ; 
SPL_interest_rate_2099	= . ; 
SPL_interest_rate_2199	= . ; 
SPL_interest_rate_2299	= . ; 
SPL_interest_rate_2399	= . ; 

if App1_EFS_CV_Risk_Score > 682 then do;
Rate_ind_0999 = 1;
Rate_ind_1099 = 1;
Rate_ind_1199 = 1;
Rate_ind_1299 = 1;
Rate_ind_1399 = 0;
Rate_ind_1499 = 1;
Rate_ind_1599 = 0;
Rate_ind_1699 = 0;
Rate_ind_1799 = 0;
Rate_ind_1899 = 0;
Rate_ind_1999 = 0;
Rate_ind_2099 = 0;
Rate_ind_2199 = 0;
Rate_ind_2299 = 0;
Rate_ind_2399 = 0;
end;
else if 645 <App1_EFS_CV_Risk_Score <=682 then do;
Rate_ind_0999 = 0;
Rate_ind_1099 = 0;
Rate_ind_1199 = 1;
Rate_ind_1299 = 1;
Rate_ind_1399 = 1;
Rate_ind_1499 = 1;
Rate_ind_1599 = 0;
Rate_ind_1699 = 0;
Rate_ind_1799 = 0;
Rate_ind_1899 = 0;
Rate_ind_1999 = 0;
Rate_ind_2099 = 0;
Rate_ind_2199 = 0;
Rate_ind_2299 = 0;
Rate_ind_2399 = 0;
end;
else if 626 <App1_EFS_CV_Risk_Score <=645 then do;
Rate_ind_0999 = 0;
Rate_ind_1099 = 0;
Rate_ind_1199 = 0;
Rate_ind_1299 = 0;
Rate_ind_1399 = 0;
Rate_ind_1499 = 0;
Rate_ind_1599 = 0;
Rate_ind_1699 = 0;
Rate_ind_1799 = 1;
Rate_ind_1899 = 0;
Rate_ind_1999 = 0;
Rate_ind_2099 = 0;
Rate_ind_2199 = 0;
Rate_ind_2299 = 0;
Rate_ind_2399 = 0;
end;
else if 609 <App1_EFS_CV_Risk_Score <=626 then do;
Rate_ind_0999 = 0;
Rate_ind_1099 = 0;
Rate_ind_1199 = 0;
Rate_ind_1299 = 0;
Rate_ind_1399 = 0;
Rate_ind_1499 = 0;
Rate_ind_1599 = 0;
Rate_ind_1699 = 0;
Rate_ind_1799 = 0;
Rate_ind_1899 = 0;
Rate_ind_1999 = 1;
Rate_ind_2099 = 0;
Rate_ind_2199 = 0;
Rate_ind_2299 = 0;
Rate_ind_2399 = 0;
end;
else if 592 <App1_EFS_CV_Risk_Score <=609 then do;
Rate_ind_0999 = 0;
Rate_ind_1099 = 0;
Rate_ind_1199 = 0;
Rate_ind_1299 = 0;
Rate_ind_1399 = 0;
Rate_ind_1499 = 0;
Rate_ind_1599 = 0;
Rate_ind_1699 = 0;
Rate_ind_1799 = 0;
Rate_ind_1899 = 0;
Rate_ind_1999 = 0;
Rate_ind_2099 = 0;
Rate_ind_2199 = 1;
Rate_ind_2299 = 0;
Rate_ind_2399 = 0;
end;
else do;
Rate_ind_0999 = 0;
Rate_ind_1099 = 0;
Rate_ind_1199 = 0;
Rate_ind_1299 = 0;
Rate_ind_1399 = 0;
Rate_ind_1499 = 0;
Rate_ind_1599 = 0;
Rate_ind_1699 = 0;
Rate_ind_1799 = 0;
Rate_ind_1899 = 0;
Rate_ind_1999 = 0;
Rate_ind_2099 = 0;
Rate_ind_2199 = 0;
Rate_ind_2299 = 0;
Rate_ind_2399 = 1;
end;
output;
end;
run;

/****************************Assign Rate indicator to SPL interest rate**************************/
%macro apply_caps(input_table, output_table, rate, rate2);
data &output_table.;
set &input_table.;

if Rate_ind_&rate = 1 then SPL_interest_rate_&rate = &rate2;

%mend apply_caps;
%apply_caps(SPL_Apps,SPL_Apps,0999,9.99);
%apply_caps(SPL_Apps,SPL_Apps,1099, 10.99);
%apply_caps(SPL_Apps,SPL_Apps,1199, 11.99);
%apply_caps(SPL_Apps,SPL_Apps,1299, 12.99);
%apply_caps(SPL_Apps,SPL_Apps,1399, 13.99);
%apply_caps(SPL_Apps,SPL_Apps,1499, 14.99);
%apply_caps(SPL_Apps,SPL_Apps,1599, 15.99);
%apply_caps(SPL_Apps,SPL_Apps,1699, 16.99);
%apply_caps(SPL_Apps,SPL_Apps,1799, 17.99);
%apply_caps(SPL_Apps,SPL_Apps,1899, 18.99);
%apply_caps(SPL_Apps,SPL_Apps,1999, 19.99);
%apply_caps(SPL_Apps,SPL_Apps,2099, 20.99);
%apply_caps(SPL_Apps,SPL_Apps,2199, 21.99);
%apply_caps(SPL_Apps,SPL_Apps,2299, 22.99);
%apply_caps(SPL_Apps,SPL_Apps,2399, 23.99);
run;

/****************************For App1**************************/
/********Join with grid and assign MaxAffordableQLA for each interest rate*****************/
*[IJ] You needed to create a macro function for this. too many repetitions
proc sql;
Create Table QLA_0999 as
select a.*, b.Region format=$5., b.Afford_QLA, b.RateInDecNew, b.RI
from SPL_Apps as a
left join SPLGrid as b
on upcase(a.app1_new_province) = upcase(b.Region) and a.SPL_interest_rate_0999 = b.RateInDecNew
and a.RemainingIncome >= round(b.RI,0.01)
where round(RateInDecNew,0.01) = 9.99
;quit;
proc sort data = QLA_0999;
    by descending App_ID descending Afford_QLA;
run;
data Afford_QLA_0999; set QLA_0999;
rename Afford_QLA=AffordQLA_0999;
 by descending App_ID descending Afford_QLA; 
if first.App_ID then output;
run;
data MaxAffordQLA_0999;
set Afford_QLA_0999;
MaxAffordQLA_0999= AffordQLA_0999;
run;

proc sql;
Create Table QLA_1099 as
select a.*, b.Region format=$5., b.Afford_QLA, b.RateInDecNew, b.RI
from SPL_Apps as a
left join SPLGrid as b
on upcase(a.app1_new_province) = upcase(b.Region) and a.SPL_interest_rate_1099 = b.RateInDecNew
and a.RemainingIncome >= round(b.RI,0.01)
where round(RateInDecNew,0.01) = 10.99
;quit;
proc sort data = QLA_1099;
    by descending App_ID descending Afford_QLA;
run;
data Afford_QLA_1099; set QLA_1099;
rename Afford_QLA=AffordQLA_1099;
 by descending App_ID descending Afford_QLA; 
if first.App_ID then output;
run;
data MaxAffordQLA_1099;
set Afford_QLA_1099;
MaxAffordQLA_1099= AffordQLA_1099;
run;


proc sql;
Create Table QLA_1199 as
select a.*, b.Region format=$5., b.Afford_QLA, b.RateInDecNew, b.RI
from SPL_Apps as a
left join SPLGrid as b
on upcase(a.app1_new_province) = upcase(b.Region) and a.SPL_interest_rate_1199 = b.RateInDecNew
and a.RemainingIncome >= round(b.RI,0.01)
where round(RateInDecNew,0.01) = 11.99
;quit;
proc sort data = QLA_1199;
    by descending App_ID descending Afford_QLA;
run;
data Afford_QLA_1199; set QLA_1199;
rename Afford_QLA=AffordQLA_1199;
 by descending App_ID descending Afford_QLA; 
if first.App_ID then output;
run;
data MaxAffordQLA_1199;
set Afford_QLA_1199;
MaxAffordQLA_1199= AffordQLA_1199;
run;


proc sql;
Create Table QLA_1299 as
select a.*, b.Region format=$5., b.Afford_QLA, b.RateInDecNew, b.RI
from SPL_Apps as a
left join SPLGrid as b
on upcase(a.app1_new_province) = upcase(b.Region) and a.SPL_interest_rate_1299 = b.RateInDecNew
and a.RemainingIncome >= round(b.RI,0.01)
where round(RateInDecNew,0.01) = 12.99
;quit;
proc sort data = QLA_1299;
    by descending App_ID descending Afford_QLA;
run;
data Afford_QLA_1299; set QLA_1299;
rename Afford_QLA=AffordQLA_1299;
 by descending App_ID descending Afford_QLA; 
if first.App_ID then output;
run;
data MaxAffordQLA_1299;
set Afford_QLA_1299;
MaxAffordQLA_1299= AffordQLA_1299;
run;


proc sql;
Create Table QLA_1399 as
select a.*, b.Region format=$5., b.Afford_QLA, b.RateInDecNew, b.RI
from SPL_Apps as a
left join SPLGrid as b
on upcase(a.app1_new_province) = upcase(b.Region) and a.SPL_interest_rate_1399 = b.RateInDecNew
and a.RemainingIncome >= round(b.RI,0.01)
where round(RateInDecNew,0.01) = 13.99
;quit;
proc sort data = QLA_1399;
    by descending App_ID descending Afford_QLA;
run;
data Afford_QLA_1399; set QLA_1399;
rename Afford_QLA=AffordQLA_1399;
 by descending App_ID descending Afford_QLA; 
if first.App_ID then output;
run;
data MaxAffordQLA_1399;
set Afford_QLA_1399;
MaxAffordQLA_1399= AffordQLA_1399;
run;


proc sql;
Create Table QLA_1499 as
select a.*, b.Region format=$5., b.Afford_QLA, b.RateInDecNew, b.RI
from SPL_Apps as a
left join SPLGrid as b
on upcase(a.app1_new_province) = upcase(b.Region) and a.SPL_interest_rate_1499 = b.RateInDecNew
and a.RemainingIncome >= round(b.RI,0.01)
where round(RateInDecNew,0.01) = 14.99
;quit;
proc sort data = QLA_1499;
    by descending App_ID descending Afford_QLA;
run;
data Afford_QLA_1499; set QLA_1499;
rename Afford_QLA=AffordQLA_1499;
 by descending App_ID descending Afford_QLA; 
if first.App_ID then output;
run;
data MaxAffordQLA_1499;
set Afford_QLA_1499;
MaxAffordQLA_1499= AffordQLA_1499;
run;

proc sql;
Create Table QLA_1599 as
select a.*, b.Region format=$5., b.Afford_QLA, b.RateInDecNew, b.RI
from SPL_Apps as a
left join SPLGrid as b
on upcase(a.app1_new_province) = upcase(b.Region) and a.SPL_interest_rate_1599 = b.RateInDecNew
and a.RemainingIncome >= round(b.RI,0.01)
where round(Rateindecnew,0.01) = 15.99
;quit;
proc sort data = QLA_1599;
    by descending App_ID descending Afford_QLA;
run;
data Afford_QLA_1599; set QLA_1599;
rename Afford_QLA=AffordQLA_1599;
 by descending App_ID descending Afford_QLA; 
if first.App_ID then output;
run;
data MaxAffordQLA_1599;
set Afford_QLA_1599;
MaxAffordQLA_1599= AffordQLA_1599;
run;

proc sql;
Create Table QLA_1699 as
select a.*, b.Region format=$5., b.Afford_QLA, b.RateInDecNew, b.RI
from SPL_Apps as a
left join SPLGrid as b
on upcase(a.app1_new_province) = upcase(b.Region) and a.SPL_interest_rate_1699 = b.RateInDecNew
and a.RemainingIncome >= round(b.RI,0.01)
where round(RateInDecNew,0.01) = 16.99
;quit;
proc sort data = QLA_1699;
    by descending App_ID descending Afford_QLA;
run;
data Afford_QLA_1699; set QLA_1699;
rename Afford_QLA=AffordQLA_1699;
 by descending App_ID descending Afford_QLA; 
if first.App_ID then output;
run;
data MaxAffordQLA_1699;
set Afford_QLA_1699;
MaxAffordQLA_1699= AffordQLA_1699;
run;

proc sql;
Create Table QLA_1799 as
select a.*, b.Region format=$5., b.Afford_QLA, b.RateInDecNew, b.RI
from SPL_Apps as a
left join SPLGrid as b
on upcase(a.app1_new_province) = upcase(b.Region) and a.SPL_interest_rate_1799 = b.RateInDecNew
and a.RemainingIncome >= round(b.RI,0.01)
where round(RateInDecNew,0.01) = 17.99
;quit;
proc sort data = QLA_1799;
    by descending App_ID descending Afford_QLA;
run;
data Afford_QLA_1799; set QLA_1799;
rename Afford_QLA=AffordQLA_1799;
 by descending App_ID descending Afford_QLA; 
if first.App_ID then output;
run;
data MaxAffordQLA_1799;
set Afford_QLA_1799;
MaxAffordQLA_1799= AffordQLA_1799;
run;

proc sql;
Create Table QLA_1899 as
select a.*, b.Region format=$5., b.Afford_QLA, b.RateInDecNew, b.RI
from SPL_Apps as a
left join SPLGrid as b
on upcase(a.app1_new_province) = upcase(b.Region) and a.SPL_interest_rate_1899 = b.RateInDecNew
and a.RemainingIncome >= round(b.RI,0.01)
where round(RateInDecNew,0.01) = 18.99
;quit;
proc sort data = QLA_1899;
    by descending App_ID descending Afford_QLA;
run;
data Afford_QLA_1899; set QLA_1899;
rename Afford_QLA=AffordQLA_1899;
 by descending App_ID descending Afford_QLA; 
if first.App_ID then output;
run;
data MaxAffordQLA_1899;
set Afford_QLA_1899;
MaxAffordQLA_1899= AffordQLA_1899;
run;

proc sql;
Create Table QLA_1999 as
select a.*, b.Region format=$5., b.Afford_QLA, b.RateInDecNew, b.RI
from SPL_Apps as a
left join SPLGrid as b
on upcase(a.app1_new_province) = upcase(b.Region) and a.SPL_interest_rate_1999 = b.RateInDecNew
and a.RemainingIncome >= round(b.RI,0.01)
where round(RateInDecNew,0.01) = 19.99
;quit;
proc sort data = QLA_1999;
    by descending App_ID descending Afford_QLA;
run;
data Afford_QLA_1999; set QLA_1999;
rename Afford_QLA=AffordQLA_1999;
 by descending App_ID descending Afford_QLA; 
if first.App_ID then output;
run;
data MaxAffordQLA_1999;
set Afford_QLA_1999;
MaxAffordQLA_1999= AffordQLA_1999;
run;

proc sql;
Create Table QLA_2099 as
select a.*, b.Region format=$5., b.Afford_QLA, b.RateInDecNew, b.RI
from SPL_Apps as a
left join SPLGrid as b
on upcase(a.app1_new_province) = upcase(b.Region) and a.SPL_interest_rate_2099 = b.RateInDecNew
and a.RemainingIncome >= round(b.RI,0.01)
where round(RateInDecNew,0.01) = 20.99
;quit;
proc sort data = QLA_2099;
    by descending App_ID descending Afford_QLA;
run;
data Afford_QLA_2099; set QLA_2099;
rename Afford_QLA=AffordQLA_2099;
 by descending App_ID descending Afford_QLA; 
if first.App_ID then output;
run;
data MaxAffordQLA_2099;
set Afford_QLA_2099;
MaxAffordQLA_2099= AffordQLA_2099;
run;

proc sql;
Create Table QLA_2199 as
select a.*, b.Region format=$5., b.Afford_QLA, b.RateInDecNew, b.RI
from SPL_Apps as a
left join SPLGrid as b
on upcase(a.app1_new_province) = upcase(b.Region) and a.SPL_interest_rate_2199 = b.RateInDecNew
and a.RemainingIncome >= round(b.RI,0.01)
where round(RateInDecNew,0.01) = 21.99
;quit;
proc sort data = QLA_2199;
    by descending App_ID descending Afford_QLA;
run;
data Afford_QLA_2199; set QLA_2199;
rename Afford_QLA=AffordQLA_2199;
 by descending App_ID descending Afford_QLA; 
if first.App_ID then output;
run;
data MaxAffordQLA_2199;
set Afford_QLA_2199;
MaxAffordQLA_2199= AffordQLA_2199;
run;

proc sql;
Create Table QLA_2299 as
select a.*, b.Region format=$5., b.Afford_QLA, b.RateInDecNew, b.RI
from SPL_Apps as a
left join SPLGrid as b
on upcase(a.app1_new_province) = upcase(b.Region) and a.SPL_interest_rate_2299 = b.RateInDecNew
and a.RemainingIncome >= round(b.RI,0.01)
where round(RateInDecNew,0.01) = 22.99
;quit;
proc sort data = QLA_2299;
    by descending App_ID descending Afford_QLA;
run;
data Afford_QLA_2299; set QLA_2299;
rename Afford_QLA=AffordQLA_2299;
 by descending App_ID descending Afford_QLA; 
if first.App_ID then output;
run;
data MaxAffordQLA_2299;
set Afford_QLA_2299;
MaxAffordQLA_2299= AffordQLA_2299;
run;

proc sql;
Create Table QLA_2399 as
select a.*, b.Region format=$5., b.Afford_QLA, b.RateInDecNew, b.RI
from SPL_Apps as a
left join SPLGrid as b
on upcase(a.app1_new_province) = upcase(b.Region) and a.SPL_interest_rate_2399 = b.RateInDecNew
and a.RemainingIncome >= round(b.RI,0.01)
where round(RateInDecNew,0.01) = 23.99
;quit;
proc sort data = QLA_2399;
    by descending App_ID descending Afford_QLA;
run;
data Afford_QLA_2399; set QLA_2399;
rename Afford_QLA=AffordQLA_2399;
 by descending App_ID descending Afford_QLA ; 
if first.App_ID then output;
run;
data MaxAffordQLA_2399;
set Afford_QLA_2399;
MaxAffordQLA_2399 = AffordQLA_2399;
run;

proc sql;
Create Table AffordQLA_joined as
select a.*, b.MaxAffordQLA_0999 ,  c.MaxAffordQLA_1099,  d.MaxAffordQLA_1199,   e.MaxAffordQLA_1299,  f.MaxAffordQLA_1399,  g.MaxAffordQLA_1499,  h.MaxAffordQLA_1599,  i.MaxAffordQLA_1699,  j.MaxAffordQLA_1799,  k.MaxAffordQLA_1899,  l.MaxAffordQLA_1999,  m.MaxAffordQLA_2099,  n.MaxAffordQLA_2199,  o.MaxAffordQLA_2299,   p.MaxAffordQLA_2399
from SPL_Apps as a
left join MaxAffordQLA_0999 as b
on a.App_ID = b.App_ID
left join MaxAffordQLA_1099 as c
on a.App_ID = c.App_ID
left join MaxAffordQLA_1199 as d
on a.App_ID = d.App_ID
left join MaxAffordQLA_1299 as e 
on a.App_ID = e.App_ID
left join MaxAffordQLA_1399 as f
on a.App_ID = f.App_ID
left join MaxAffordQLA_1499 as g
on a.App_ID = g.App_ID
left join MaxAffordQLA_1599 as h
on a.App_ID = h.App_ID
left join MaxAffordQLA_1699 as i
on a.App_ID = i.App_ID
left join MaxAffordQLA_1799 as j
on a.App_ID = j.App_ID
left join MaxAffordQLA_1899 as k
on a.App_ID = k.App_ID
left join MaxAffordQLA_1999 as l
on a.App_ID = l.App_ID
left join MaxAffordQLA_2099 as m
on a.App_ID = m.App_ID
left join MaxAffordQLA_2199 as n
on a.App_ID = n.App_ID
left join MaxAffordQLA_2299 as o
on a.App_ID = o.App_ID
left join MaxAffordQLA_2399 as p
on a.App_ID = p.App_ID
;quit;

/** ASSIGNING Blank MaxQLA to 0*/
data AffordQLA_joined;
set AffordQLA_joined;
if MaxAffordQLA_0999 = . then MaxAffordQLA_0999 = 0;
if MaxAffordQLA_1099 = . then MaxAffordQLA_1099 = 0;
if MaxAffordQLA_1199 = . then MaxAffordQLA_1199 = 0;
if MaxAffordQLA_1299 = . then MaxAffordQLA_1299 = 0;
if MaxAffordQLA_1399 = . then MaxAffordQLA_1399 = 0;
if MaxAffordQLA_1499 = . then MaxAffordQLA_1499 = 0;
if MaxAffordQLA_1599 = . then MaxAffordQLA_1599 = 0;
if MaxAffordQLA_1699 = . then MaxAffordQLA_1699 = 0;
if MaxAffordQLA_1799 = . then MaxAffordQLA_1799 = 0;
if MaxAffordQLA_1899 = . then MaxAffordQLA_1899 = 0;
if MaxAffordQLA_1999 = . then MaxAffordQLA_1999 = 0;
if MaxAffordQLA_2099 = . then MaxAffordQLA_2099 = 0;
if MaxAffordQLA_2199 = . then MaxAffordQLA_2199 = 0;
if MaxAffordQLA_2299 = . then MaxAffordQLA_2299 = 0;
if MaxAffordQLA_2399 = . then MaxAffordQLA_2399 = 0;
run;

/*Assign Max Affordable Limit for App1*/

data MaxLimit;
set AffordQLA_joined;
If 626 < app1_EFSCVRiskScore <= 645 and MaxAffordQLA_1799 > 50000 then MaxAffordQLA_1799 = 50000;
If 610 <= app1_EFSCVRiskScore <= 626 and MaxAffordQLA_1999  > 50000 then MaxAffordQLA_1999 = 50000;
If 593 <= app1_EFSCVRiskScore <= 609 and MaxAffordQLA_2199  > 25000 then MaxAffordQLA_2199  = 25000;
If app1_EFSCVRiskScore < 593 and MaxAffordQLA_2399  > 20000 then MaxAffordQLA_2399 = 20000;
run;

/*Calculate SPL QLA for each int rate*/

data SPLQLA;
set MaxLimit;

SPL_QLA_0999= Min (SPL_HomeEquity, MaxAffordQLA_0999);
SPL_QLA_1099= Min (SPL_HomeEquity, MaxAffordQLA_1099);
SPL_QLA_1199= Min (SPL_HomeEquity, MaxaffordQLA_1199);
SPL_QLA_1299= Min (SPL_HomeEquity, MaxAffordQLA_1299);
SPL_QLA_1399= Min (SPL_HomeEquity, MaxAffordQLA_1399);
SPL_QLA_1499= Min (SPL_HomeEquity, MaxAffordQLA_1499);
SPL_QLA_1599= Min (SPL_HomeEquity, MaxAffordQLA_1599);
SPL_QLA_1699= Min (SPL_HomeEquity, MaxAffordQLA_1699);
SPL_QLA_1799= Min (SPL_HomeEquity, MaxAffordQLA_1799);
SPL_QLA_1899= Min (SPL_HomeEquity, MaxAffordQLA_1899);
SPL_QLA_1999= Min (SPL_HomeEquity, MaxAffordQLA_1999);
SPL_QLA_2099= Min (SPL_HomeEquity, MaxAffordQLA_2099);
SPL_QLA_2199= Min (SPL_HomeEquity, MaxAffordQLA_2199);
SPL_QLA_2299= Min (SPL_HomeEquity, MaxAffordQLA_2299);
SPL_QLA_2399= Min (SPL_HomeEquity, MaxAffordQLA_2399);

run;

/*Assign Score based QLA and interest rate for App1*/

data ScoreQLA;
set SPLQLA1;

If EFSCVRiskScore > 682 then do;
If 70000.01 <= SPL_QLA_0999 <= 75000 then do ;
SPLQLA = SPL_QLA_0999 ;
SPLInterestRate
 = 9.99; 
end;
Else If 65000.01 <= SPL_QLA_1099 <= 70000 then do;
SPLQLA = SPL_QLA_1099 ;
SPLInterestRate
 = 10.99; 
end;
Else If 60000.01 <= SPL_QLA_1199 <= 65000 then do; 
SPLQLA = SPL_QLA_1199 ;
SPLInterestRate
 = 11.99; 
end;
Else If 55000.01 <= SPL_QLA_1299 <= 60000 then do; 
SPLQLA = SPL_QLA_1299;
SPLInterestRate
 = 12.99; end;
Else If 50100.01<= SPL_QLA_1299 <= 55000 then do; 
SPLQLA = SPL_QLA_1299;
SPLInterestRate
 = 12.99; end;
Else do
SPLQLA = SPL_QLA_1499;  
SPLInterestRate
 = 14.99;
end;
end;

If 646 <= EFSCVRiskScore <= 682 then do;
If 70000.01 <= SPL_QLA_1199 <= 75000 then do; 
SPLQLA = SPL_QLA_1199;
SPLInterestRate
 = 11.99; 
end;
Else If 65000.01 <= SPL_QLA_1299 <= 70000 then do; 
SPLQLA = SPL_QLA_1299;
SPLInterestRate
 = 12.99; end;
Else If 60000.01 <= SPL_QLA_1399 <= 65000 then do; 
SPLQLA = SPL_QLA_1399;
SPLInterestRate
 = 13.99; end;
Else If 55000.01 <= SPL_QLA_1499 <= 60000 then do; 
SPLQLA = SPL_QLA_1499;
SPLInterestRate
 = 14.99; end;
Else If 50100.01<= SPL_QLA_1499 <= 55000 then do; 
SPLQLA = SPL_QLA_1499; SPLInterestRate
 = 14.99; end;
Else do SPLQLA = SPL_QLA_1499; SPLInterestRate
 = 14.99;end;
end;

If 627 <= EFSCVRiskScore <= 645 then do;
SPLQLA = SPL_QLA_1799; SPLInterestRate
 = 17.99; end;
If 610 <= EFSCVRiskScore <= 626 then do;
SPLQLA = SPL_QLA_1999; SPLInterestRate
 = 19.99; end;
If 593 <= EFSCVRiskScore <= 609 then do ;
SPLQLA = SPL_QLA_2199 ; SPLInterestRate
 = 21.99;end;
If 577 <= EFSCVRiskScore <= 592 then  do ;
SPLQLA = SPL_QLA_2399 ; SPLInterestRate
 = 23.99;end;
If 564 <= EFSCVRiskScore <= 576 then  do ;
SPLQLA = SPL_QLA_2399 ;SPLInterestRate
 = 23.99;end;

run;

/************************** SPL QLA Adjustments for App1 with updated RI cutoffs******************************************/

Data SPL_new_app1_QLA_capped; set ScoreQLA;

If SPLInterestRate = 9.99 then do;
if app1_new_province ="AB" then do;
		if RemainingIncome < 251.3 then SPLQLA = 0;
		end;
	if app1_new_province ="BC" then do;
		if RemainingIncome < 251.3 then SPLQLA= 0;
		end;
	if app1_new_province ="MB" then do;
		if RemainingIncome <255.38 then SPLQLA= 0;
		end;
	if app1_new_province ="NB" then do;
		if RemainingIncome < 251.3 then SPLQLA= 0;
		end;
	if app1_new_province ="NL" then do;
		if RemainingIncome < 260.05 then SPLQLA= 0;
		end;
	if app1_new_province ="NS" then do;
		if RemainingIncome < 251.3 then SPLQLA= 0;
		end;
	if app1_new_province ="ON" then do;
		if RemainingIncome < 255.96 then SPLQLA= 0;
		end;
	if app1_new_province ="PE" then do;
		if RemainingIncome < 251.3 then SPLQLA = 0;
		end;
	if app1_new_province ="QC" then do;
		if RemainingIncome < 250.49 then SPLQLA= 0;
		end;
	if app1_new_province ="SK" then do;
		if RemainingIncome < 251.3 then SPLQLA= 0;
		end;
end;

If SPLInterestRate = 10.99  then do;
if app1_new_province= "AB" then do; 
if RemainingIncome <268.79 then SPLQLA = 0;end;

if app1_new_province= "BC" then do; if 
 RemainingIncome
 <268.79 then SPLQLA = 0;end;


if app1_new_province= "MB" then do; if 
 RemainingIncome
 <273.16 then SPLQLA = 0;end;


if app1_new_province= "NB" then do; if 
 RemainingIncome
 <268.79 then SPLQLA = 0;end;


if app1_new_province= "NL" then do; if 
 RemainingIncome
 <278.16 then SPLQLA = 0;end;


if app1_new_province= "NS" then do; if 
 RemainingIncome
 <268.79 then SPLQLA = 0;end;


if app1_new_province= "ON" then do; if 
 RemainingIncome
 <273.79 then SPLQLA = 0;end;


if app1_new_province= "PE" then do; if 
 RemainingIncome
 <268.79 then SPLQLA = 0;end;


if app1_new_province= "QC" then do; if 
 RemainingIncome
 <267.93 then SPLQLA = 0;end;


if app1_new_province= "SK" then do; if 
 RemainingIncome
 <268.79 then SPLQLA = 0;end;

end;

If SPLInterestRate
 = 11.99 then do;
if app1_new_province= "AB" then do; if 
 RemainingIncome
 < 286.74 then SPLQLA = 0; end;

if app1_new_province= "BC" then do; if 
 RemainingIncome
 <286.74 then SPLQLA = 0; end;

if app1_new_province= "MB" then do; if 
 RemainingIncome
 <291.4 then SPLQLA = 0; end;

if app1_new_province= "NB" then do; if 
 RemainingIncome
 <286.74 then SPLQLA = 0; end;

if app1_new_province= "NL" then do; if 
 RemainingIncome
 <296.73 then SPLQLA = 0; end;

if app1_new_province= "NS" then do; if 
 RemainingIncome
 <286.74 then SPLQLA = 0; end;

if app1_new_province= "ON" then do; if 
 RemainingIncome
 <292.07 then SPLQLA = 0; end;

if app1_new_province= "PE" then do; if 
 RemainingIncome
 <286.74 then SPLQLA = 0; end;

if app1_new_province= "QC" then do; if 
 RemainingIncome
 <285.82 then SPLQLA = 0; end;

if app1_new_province= "SK" then do; if 
 RemainingIncome
 <286.74 then SPLQLA = 0; end;
		
end;
If SPLInterestRate
 = 12.99 then do;
if app1_new_province= "AB" then do; if 
 RemainingIncome
 <305.11 then SPLQLA = 0; end;

if app1_new_province= "BC" then do; if 
 RemainingIncome
 <305.11 then SPLQLA = 0; end;

if app1_new_province= "MB" then do; if 
 RemainingIncome
 <310.07 then SPLQLA = 0; end;

if app1_new_province= "NB" then do; if 
 RemainingIncome
 <305.11 then SPLQLA = 0; end;

if app1_new_province= "NL" then do; if 
 RemainingIncome
 <315.73 then SPLQLA = 0; end;

if app1_new_province= "NS" then do; if 
 RemainingIncome
 <305.11 then SPLQLA = 0; end;

if app1_new_province= "ON" then do; if 
 RemainingIncome
 <310.78 then SPLQLA = 0; end;

if app1_new_province= "PE" then do; if 
 RemainingIncome
 <305.11 then SPLQLA = 0; end;

if app1_new_province= "QC" then do; if 
 RemainingIncome
 <304.13 then SPLQLA = 0; end;

if app1_new_province= "SK" then do; if 
 RemainingIncome
 <305.11 then SPLQLA = 0; end;

		
end;
If SPLInterestRate
 = 13.99  then do;
if app1_new_province= "AB" then do; if 
 RemainingIncome
 <323.85 then SPLQLA = 0; end;

if app1_new_province= "BC" then do; if 
 RemainingIncome
 <323.85 then SPLQLA = 0; end;

if app1_new_province= "MB" then do; if 
 RemainingIncome
 <329.12 then SPLQLA = 0; end;

if app1_new_province= "NB" then do; if 
 RemainingIncome
 <323.85 then SPLQLA = 0; end;

if app1_new_province= "NL" then do; if 
 RemainingIncome
 <335.13 then SPLQLA = 0; end;

if app1_new_province= "NS" then do; if 
 RemainingIncome
 <323.85 then SPLQLA = 0; end;

if app1_new_province= "ON" then do; if 
 RemainingIncome
 <329.87 then SPLQLA = 0; end;

if app1_new_province= "PE" then do; if 
 RemainingIncome
 <323.85 then SPLQLA = 0; end;

if app1_new_province= "QC" then do; if 
 RemainingIncome
 <322.81 then SPLQLA = 0; end;

if app1_new_province= "SK" then do; if 
 RemainingIncome
 <323.85 then SPLQLA = 0; end;

		
end;
If SPLInterestRate
 = 14.99  then do;
if app1_new_province= "AB" then do; if 
 RemainingIncome
 <342.94 then SPLQLA = 0; end;

if app1_new_province= "BC" then do; if 
 RemainingIncome
 <342.94 then SPLQLA = 0; end;

if app1_new_province= "MB" then do; if 
 RemainingIncome
 <348.52 then SPLQLA = 0; end;

if app1_new_province= "NB" then do; if 
 RemainingIncome
 <342.94 then SPLQLA = 0; end;

if app1_new_province= "NL" then do; if 
 RemainingIncome
 <354.89 then SPLQLA = 0; end;

if app1_new_province= "NS" then do; if 
 RemainingIncome
 <342.94 then SPLQLA = 0; end;

if app1_new_province= "ON" then do; if 
 RemainingIncome
 <349.31 then SPLQLA = 0; end;

if app1_new_province= "PE" then do; if 
 RemainingIncome
 <342.94 then SPLQLA = 0; end;

if app1_new_province= "QC" then do; if 
 RemainingIncome
 <341.84 then SPLQLA = 0; end;

if app1_new_province= "SK" then do; if 
 RemainingIncome
 <342.94 then SPLQLA = 0; end;

		
end;
If SPLInterestRate
 = 15.99 then do;
if app1_new_province= "AB" then do; if 
 RemainingIncome
 <362.34 then SPLQLA = 0; end;

if app1_new_province= "BC" then do; if 
 RemainingIncome
 <362.34 then SPLQLA = 0; end;

if app1_new_province= "MB" then do; if 
 RemainingIncome
 <368.23 then SPLQLA = 0; end;

if app1_new_province= "NB" then do; if 
 RemainingIncome
 <362.34 then SPLQLA = 0; end;

if app1_new_province= "NL" then do; if 
 RemainingIncome
 <374.96 then SPLQLA = 0; end;

if app1_new_province= "NS" then do; if 
 RemainingIncome
 <362.34 then SPLQLA = 0; end;

if app1_new_province= "ON" then do; if 
 RemainingIncome
 <369.07 then SPLQLA = 0; end;

if app1_new_province= "PE" then do; if 
 RemainingIncome
 <362.34 then SPLQLA = 0; end;

if app1_new_province= "QC" then do; if 
 RemainingIncome
 <361.18 then SPLQLA = 0; end;

if app1_new_province= "SK" then do; if 
 RemainingIncome
 <362.34 then SPLQLA = 0; end;

		
end;
If SPLInterestRate
 = 16.99 then do;
if app1_new_province= "AB" then do; if 
 RemainingIncome
 <382.03 then SPLQLA = 0; end;

if app1_new_province= "BC" then do; if 
 RemainingIncome
 <382.03 then SPLQLA = 0;end;

if app1_new_province= "MB" then do; if 
 RemainingIncome
 <388.24 then SPLQLA = 0;end;

if app1_new_province= "NB" then do; if 
 RemainingIncome
 <382.03 then SPLQLA = 0;end;

if app1_new_province= "NL" then do; if 
 RemainingIncome
 <395.33 then SPLQLA = 0;end;

if app1_new_province= "NS" then do; if 
 RemainingIncome
 <382.03 then SPLQLA = 0;end;

if app1_new_province= "ON" then do; if 
 RemainingIncome
 <389.12 then SPLQLA = 0;end;

if app1_new_province= "PE" then do; if 
 RemainingIncome
 <382.03 then SPLQLA = 0;end;

if app1_new_province= "QC" then do; if 
 RemainingIncome
 <380.8 then SPLQLA = 0;end;

if app1_new_province= "SK" then do; if 
 RemainingIncome
 <382.03 then SPLQLA = 0;end;

	end;
If SPLInterestRate
 = 17.99  then do;
if app1_new_province= "AB" then do; if 
 RemainingIncome
 <401.96 then SPLQLA = 0;end;


if app1_new_province= "BC" then do; if 
 RemainingIncome
 <401.96 then SPLQLA = 0;end;


if app1_new_province= "MB" then do; if 
 RemainingIncome
 <408.49 then SPLQLA = 0;end;


if app1_new_province= "NB" then do; if 
 RemainingIncome
 <401.96 then SPLQLA = 0;end;


if app1_new_province= "NL" then do; if 
 RemainingIncome
 <415.96 then SPLQLA = 0;end;


if app1_new_province= "NS" then do; if 
 RemainingIncome
 <401.96 then SPLQLA = 0;end;


if app1_new_province= "ON" then do; if 
 RemainingIncome
 <409.43 then SPLQLA = 0;end;


if app1_new_province= "PE" then do; if 
 RemainingIncome
 <401.96 then SPLQLA = 0;end;


if app1_new_province= "QC" then do; if 
 RemainingIncome
 <400.67 then SPLQLA = 0;end;


if app1_new_province= "SK" then do; if 
 RemainingIncome
 <401.96 then SPLQLA = 0;end;

end;
If SPLInterestRate
 = 18.99  then do;
if app1_new_province= "AB" then do; if 
 RemainingIncome
 <422.12 then SPLQLA = 0;end;


if app1_new_province= "BC" then do; if 
 RemainingIncome
 <422.12 then SPLQLA = 0;end;


if app1_new_province= "MB" then do; if 
 RemainingIncome
 <428.98 then SPLQLA = 0;end;


if app1_new_province= "NB" then do; if 
 RemainingIncome
 <422.12 then SPLQLA = 0;end;


if app1_new_province= "NL" then do; if 
 RemainingIncome
 <436.82 then SPLQLA = 0;end;


if app1_new_province= "NS" then do; if 
 RemainingIncome
 <422.12 then SPLQLA = 0;end;


if app1_new_province= "ON" then do; if 
 RemainingIncome
 <429.96 then SPLQLA = 0;end;


if app1_new_province= "PE" then do; if 
 RemainingIncome
 <422.12 then SPLQLA = 0;end;


if app1_new_province= "QC" then do; if 
 RemainingIncome
 <420.77 then SPLQLA = 0;end;


if app1_new_province= "SK" then do; if 
 RemainingIncome
 <422.12 then SPLQLA = 0;end;


end;
If SPLInterestRate
 = 19.99 then do;
if app1_new_province= "AB" then do; if 
 RemainingIncome
 <442.48 then SPLQLA = 0;end;


if app1_new_province= "BC" then do; if 
 RemainingIncome
 <442.48 then SPLQLA = 0;end;


if app1_new_province= "MB" then do; if 
 RemainingIncome
 <449.67 then SPLQLA = 0;end;


if app1_new_province= "NB" then do; if 
 RemainingIncome
 <442.48 then SPLQLA = 0;end;


if app1_new_province= "NL" then do; if 
 RemainingIncome
 <457.89 then SPLQLA = 0;end;


if app1_new_province= "NS" then do; if 
 RemainingIncome
 <442.48 then SPLQLA = 0;end;


if app1_new_province= "ON" then do; if 
 RemainingIncome
 <450.7 then SPLQLA = 0;end;


if app1_new_province= "PE" then do; if 
 RemainingIncome
 <442.48 then SPLQLA = 0;end;


if app1_new_province= "QC" then do; if 
 RemainingIncome
 <441.06 then SPLQLA = 0;end;


if app1_new_province= "SK" then do; if 
 RemainingIncome
 <442.48 then SPLQLA = 0;end;
end;

If SPLInterestRate
 = 20.99 then do;
if app1_new_province= "AB" then do; if 
 RemainingIncome
 <463.02 then SPLQLA = 0;end;


if app1_new_province= "BC" then do; if 
 RemainingIncome
 <463.02 then SPLQLA = 0;end;


if app1_new_province= "MB" then do; if 
 RemainingIncome
 <463.02 then SPLQLA = 0;end;


if app1_new_province= "NB" then do; if 
 RemainingIncome
 <463.02 then SPLQLA = 0;end;


if app1_new_province= "NL" then do; if 
 RemainingIncome
 <479.14 then SPLQLA = 0;end;


if app1_new_province= "NS" then do; if 
 RemainingIncome
 <463.02 then SPLQLA = 0;end;


if app1_new_province= "ON" then do; if 
 RemainingIncome
 <471.62 then SPLQLA = 0;end;


if app1_new_province= "PE" then do; if 
 RemainingIncome
 <463.02 then SPLQLA = 0;end;


if app1_new_province= "QC" then do; if 
 RemainingIncome
 <461.53 then SPLQLA = 0;end;


if app1_new_province= "SK" then do; if 
 RemainingIncome
 <463.02 then SPLQLA = 0;end;
end;

If SPLInterestRate
 = 21.99  then do;
if app1_new_province= "AB" then do; if 
 RemainingIncome
 <483.71 then SPLQLA = 0;end;


if app1_new_province= "BC" then do; if 
 RemainingIncome
 <483.71 then SPLQLA = 0;end;


if app1_new_province= "MB" then do; if 
 RemainingIncome
 <491.57 then SPLQLA = 0;end;


if app1_new_province= "NB" then do; if 
 RemainingIncome
 <483.71 then SPLQLA = 0;end;


if app1_new_province= "NL" then do; if 
 RemainingIncome
 <500.56 then SPLQLA = 0;end;


if app1_new_province= "NS" then do; if 
 RemainingIncome
 <483.71 then SPLQLA = 0;end;


if app1_new_province= "ON" then do; if 
 RemainingIncome
 <492.7 then SPLQLA = 0;end;


if app1_new_province= "PE" then do; if 
 RemainingIncome
 <483.71 then SPLQLA = 0;end;


if app1_new_province= "QC" then do; if 
 RemainingIncome
 <482.16 then SPLQLA = 0;end;


if app1_new_province= "SK" then do; if 
 RemainingIncome
 <483.71 then SPLQLA = 0;end;
end;

If SPLInterestRate
 = 22.99  then do;
if app1_new_province= "AB" then do; if 
 RemainingIncome
 <504.54 then SPLQLA = 0;end;


if app1_new_province= "BC" then do; if 
 RemainingIncome
 <504.54 then SPLQLA = 0;end;


if app1_new_province= "MB" then do; if 
 RemainingIncome
 <512.74 then SPLQLA = 0;end;


if app1_new_province= "NB" then do; if 
 RemainingIncome
 <504.54 then SPLQLA = 0;end;


if app1_new_province= "NL" then do; if 
 RemainingIncome
 <522.11 then SPLQLA = 0;end;


if app1_new_province= "NS" then do; if 
 RemainingIncome
 <504.54 then SPLQLA = 0;end;


if app1_new_province= "ON" then do; if 
 RemainingIncome
 <513.91 then SPLQLA = 0;end;


if app1_new_province= "PE" then do; if 
 RemainingIncome
 <504.54 then SPLQLA = 0;end;


if app1_new_province= "QC" then do; if 
 RemainingIncome
 <502.92 then SPLQLA = 0;end;


if app1_new_province= "SK" then do; if 
 RemainingIncome
 <504.54 then SPLQLA = 0;end;
end;

If SPLInterestRate
 = 23.99 then do;
if app1_new_province= "AB" then do; if 
 RemainingIncome
 <525.49 then SPLQLA = 0;end;


if app1_new_province= "BC" then do; if 
 RemainingIncome
 <525.49 then SPLQLA = 0;end;


if app1_new_province= "MB" then do; if 
 RemainingIncome
 <534.03 then SPLQLA = 0;end;


if app1_new_province= "NB" then do; if 
 RemainingIncome
 <525.49 then SPLQLA = 0;end;


if app1_new_province= "NL" then do; if 
 RemainingIncome
 <543.8 then SPLQLA = 0;end;


if app1_new_province= "NS" then do; if 
 RemainingIncome
 <525.49 then SPLQLA = 0;end;


if app1_new_province= "ON" then do; if 
 RemainingIncome
 <535.25 then SPLQLA = 0;end;


if app1_new_province= "PE" then do; if 
 RemainingIncome
 <525.49 then SPLQLA = 0;end;


if app1_new_province= "QC" then do; if 
 RemainingIncome
 <523.81 then SPLQLA = 0;end;


if app1_new_province= "SK" then do; if 
 RemainingIncome
 <525.49 then SPLQLA = 0;end;

If SPL_HomeEquity < 15000 then SPLQLA =0;
If App2_EFSCVRiskScore < 564 then SPLQLA= 0;

end;
run;

/*Calculating interest rate and QLA for App2*/
/*Assign int rate based on EFSCVRiskScore for app2 */

data SPL_Apps2;
set SPL_Apps2;

if Res_DE_Var7 = '007' then ;
SPL_interest_rate_0999	= . ; 
SPL_interest_rate_1099	= . ; 
SPL_interest_rate_1199	= . ; 
SPL_interest_rate_1299	= . ; 
SPL_interest_rate_1399	= . ; 
SPL_interest_rate_1499	= . ; 
SPL_interest_rate_1599	= . ; 
SPL_interest_rate_1699	= . ; 
SPL_interest_rate_1799	= . ; 
SPL_interest_rate_1899	= . ; 
SPL_interest_rate_1999	= . ; 
SPL_interest_rate_2099	= . ; 
SPL_interest_rate_2199	= . ; 
SPL_interest_rate_2299	= . ; 
SPL_interest_rate_2399	= . ; 

if App2_EFS_CV_Risk_Score > 682 then do;
Rate_ind_0999 = 1;
Rate_ind_1099 = 1;
Rate_ind_1199 = 1;
Rate_ind_1299 = 1;
Rate_ind_1399 = 0;
Rate_ind_1499 = 1;
Rate_ind_1599 = 0;
Rate_ind_1699 = 0;
Rate_ind_1799 = 0;
Rate_ind_1899 = 0;
Rate_ind_1999 = 0;
Rate_ind_2099 = 0;
Rate_ind_2199 = 0;
Rate_ind_2299 = 0;
Rate_ind_2399 = 0;
end;
else if 645 <App2_EFS_CV_Risk_Score <=682 then do;
Rate_ind_0999 = 0;
Rate_ind_1099 = 0;
Rate_ind_1199 = 1;
Rate_ind_1299 = 1;
Rate_ind_1399 = 1;
Rate_ind_1499 = 1;
Rate_ind_1599 = 0;
Rate_ind_1699 = 0;
Rate_ind_1799 = 0;
Rate_ind_1899 = 0;
Rate_ind_1999 = 0;
Rate_ind_2099 = 0;
Rate_ind_2199 = 0;
Rate_ind_2299 = 0;
Rate_ind_2399 = 0;
end;
else if 626 <App2_EFS_CV_Risk_Score <=645 then do;
Rate_ind_0999 = 0;
Rate_ind_1099 = 0;
Rate_ind_1199 = 0;
Rate_ind_1299 = 0;
Rate_ind_1399 = 0;
Rate_ind_1499 = 0;
Rate_ind_1599 = 0;
Rate_ind_1699 = 0;
Rate_ind_1799 = 1;
Rate_ind_1899 = 0;
Rate_ind_1999 = 0;
Rate_ind_2099 = 0;
Rate_ind_2199 = 0;
Rate_ind_2299 = 0;
Rate_ind_2399 = 0;
end;
else if 609 <App2_EFS_CV_Risk_Score <=626 then do;
Rate_ind_0999 = 0;
Rate_ind_1099 = 0;
Rate_ind_1199 = 0;
Rate_ind_1299 = 0;
Rate_ind_1399 = 0;
Rate_ind_1499 = 0;
Rate_ind_1599 = 0;
Rate_ind_1699 = 0;
Rate_ind_1799 = 0;
Rate_ind_1899 = 0;
Rate_ind_1999 = 1;
Rate_ind_2099 = 0;
Rate_ind_2199 = 0;
Rate_ind_2299 = 0;
Rate_ind_2399 = 0;
end;
else if 592 <App2_EFS_CV_Risk_Score <=609 then do;
Rate_ind_0999 = 0;
Rate_ind_1099 = 0;
Rate_ind_1199 = 0;
Rate_ind_1299 = 0;
Rate_ind_1399 = 0;
Rate_ind_1499 = 0;
Rate_ind_1599 = 0;
Rate_ind_1699 = 0;
Rate_ind_1799 = 0;
Rate_ind_1899 = 0;
Rate_ind_1999 = 0;
Rate_ind_2099 = 0;
Rate_ind_2199 = 1;
Rate_ind_2299 = 0;
Rate_ind_2399 = 0;
end;
else do;
Rate_ind_0999 = 0;
Rate_ind_1099 = 0;
Rate_ind_1199 = 0;
Rate_ind_1299 = 0;
Rate_ind_1399 = 0;
Rate_ind_1499 = 0;
Rate_ind_1599 = 0;
Rate_ind_1699 = 0;
Rate_ind_1799 = 0;
Rate_ind_1899 = 0;
Rate_ind_1999 = 0;
Rate_ind_2099 = 0;
Rate_ind_2199 = 0;
Rate_ind_2299 = 0;
Rate_ind_2399 = 1;
end;
output;
run;

/*Assign rate indicator 1 to SPL interest rate variable */
%macro apply_caps(input_table, output_table, rate, rate2);
data &output_table.;
set &input_table.;

if Rate_ind_&rate = 1 then SPL_interest_rate_&rate = &rate2;

%mend apply_caps;
%apply_caps(SPL_Apps2,SPL_Apps2,0999,9.99);
%apply_caps(SPL_Apps2,SPL_Apps2,1099, 10.99);
%apply_caps(SPL_Apps2,SPL_Apps2,1199, 11.99);
%apply_caps(SPL_Apps2,SPL_Apps2,1299, 12.99);
%apply_caps(SPL_Apps2,SPL_Apps2,1399, 13.99);
%apply_caps(SPL_Apps2,SPL_Apps2,1499, 14.99);
%apply_caps(SPL_Apps2,SPL_Apps2,1599, 15.99);
%apply_caps(SPL_Apps2,SPL_Apps2,1699, 16.99);
%apply_caps(SPL_Apps2,SPL_Apps2,1799, 17.99);
%apply_caps(SPL_Apps2,SPL_Apps2,1899, 18.99);
%apply_caps(SPL_Apps2,SPL_Apps2,1999, 19.99);
%apply_caps(SPL_Apps2,SPL_Apps2,2099, 20.99);
%apply_caps(SPL_Apps2,SPL_Apps2,2199, 21.99);
%apply_caps(SPL_Apps2,SPL_Apps2,2299, 22.99);
%apply_caps(SPL_Apps2,SPL_Apps2,2399, 23.99);
run;

/*App2 - Join with grid and assign MaxAffordableQLA and SPLQLA for each interest rate*/
proc sql;
Create Table QLA_0999_app2 as
select a.*, b.Region format=$5., b.Afford_QLA, b.RateInDecNew, b.RI
from SPL_Apps2 as a
left join SPLGrid as b
on upcase(a.app2_new_province) = upcase(b.Region) and a.SPL_interest_rate_0999 = b.RateInDecNew
and a.RemainingIncome >= round(b.RI,0.01)
where round(RateInDecNew,0.01) = 9.99
;quit;
proc sort data = QLA_0999_app2;
    by descending App_ID descending Afford_QLA;
run;
data Afford_QLA_0999_app2; set QLA_0999_app2;
rename Afford_QLA=Afford_QLA_0999_app2;
 by descending App_ID descending Afford_QLA; 
if first.App_ID then output;
run;
data MaxAffordQLA_0999_app2;
set Afford_QLA_0999_app2;
MaxAffordQLA_0999_app2= AffordQLA_0999;
run;

proc sql;
Create Table QLA_1099_app2 as
select a.*, b.Region format=$5., b.Afford_QLA, b.RateInDecNew, b.RI
from SPL_Apps2 as a
left join SPLGrid as b
on upcase(a.app2_new_province) = upcase(b.Region) and a.SPL_interest_rate_1099 = b.RateInDecNew
and a.RemainingIncome >= round(b.RI,0.01)
where round(RateInDecNew,0.01) = 10.99
;quit;
proc sort data = QLA_1099_app2;
    by descending App_ID descending Afford_QLA;
run;
data Afford_QLA_1099_app2; set QLA_1099_app2;
rename Afford_QLA=Afford_QLA_1099_app2;
 by descending App_ID descending Afford_QLA; 
if first.App_ID then output;
run;
data MaxAffordQLA_1099_app2;
set Afford_QLA_1099_app2;
MaxAffordQLA_1099_app2= Afford_QLA_1099_app2;
run;


proc sql;
Create Table QLA_1199_app2 as
select a.*, b.Region format=$5., b.Afford_QLA, b.RateInDecNew, b.RI
from SPL_Apps2 as a
left join SPLGrid as b
on upcase(a.app2_new_province) = upcase(b.Region) and a.SPL_interest_rate_1199 = b.RateInDecNew
and a.RemainingIncome >= round(b.RI,0.01)
where round(RateInDecNew,0.01) = 11.99
;quit;
proc sort data = QLA_1199_app2;
    by descending App_ID descending Afford_QLA;
run;
data Afford_QLA_1199_app2; set QLA_1199_app2;
rename Afford_QLA=AffordQLA_1199_app2;
 by descending App_ID descending Afford_QLA; 
if first.App_ID then output;
run;
data MaxAffordQLA_1199_app2;
set Afford_QLA_1199_app2;
MaxAffordQLA_1199_app2= AffordQLA_1199_app2;
run;


proc sql;
Create Table QLA_1299_app2 as
select a.*, b.Region format=$5., b.Afford_QLA, b.RateInDecNew, b.RI
from SPL_Apps2 as a
left join SPLGrid as b
on upcase(a.app2_new_province) = upcase(b.Region) and a.SPL_interest_rate_1299 = b.RateInDecNew
and a.RemainingIncome >= round(b.RI,0.01)
where round(RateInDecNew,0.01) = 12.99
;quit;
proc sort data = QLA_1299_app2;
    by descending App_ID descending Afford_QLA;
run;
data Afford_QLA_1299_app2; set QLA_1299_app2;
rename Afford_QLA=AffordQLA_1299_app2;
 by descending App_ID descending Afford_QLA; 
if first.App_ID then output;
run;
data MaxAffordQLA_1299_app2;
set Afford_QLA_1299_app2;
MaxAffordQLA_1299_app2= AffordQLA_1299_app2;
run;


proc sql;
Create Table QLA_1399_app2 as
select a.*, b.Region format=$5., b.Afford_QLA, b.RateInDecNew, b.RI
from SPL_Apps2 as a
left join SPLGrid as b
on upcase(a.app1_new_province) = upcase(b.Region) and a.SPL_interest_rate_1399 = b.RateInDecNew
and a.RemainingIncome >= round(b.RI,0.01)
where round(RateInDecNew,0.01) = 13.99
;quit;
proc sort data = QLA_1399_app2;
    by descending App_ID descending Afford_QLA;
run;
data Afford_QLA_1399_app2; set QLA_1399_app2;
rename Afford_QLA=AffordQLA_1399_app2;
 by descending App_ID descending Afford_QLA_app2; 
if first.App_ID then output;
run;
data MaxAffordQLA_1399_app2;
set Afford_QLA_1399_app2;
MaxAffordQLA_1399_app2= AffordQLA_1399_app2;
run;


proc sql;
Create Table QLA_1499_app2 as
select a.*, b.Region format=$5., b.Afford_QLA, b.RateInDecNew, b.RI
from SPL_Apps2 as a
left join SPLGrid as b
on upcase(a.app1_new_province) = upcase(b.Region) and a.SPL_interest_rate_1499 = b.RateInDecNew
and a.RemainingIncome >= round(b.RI,0.01)
where round(RateInDecNew,0.01) = 14.99
;quit;
proc sort data = QLA_1499_app2;
    by descending App_ID descending Afford_QLA;
run;
data Afford_QLA_1499_app2; set QLA_1499_app2;
rename Afford_QLA=AffordQLA_1499_app2;
 by descending App_ID descending Afford_QLA; 
if first.App_ID then output;
run;
data MaxAffordQLA_1499_app2;
set Afford_QLA_1499_app2;
MaxAffordQLA_1499_app2= AffordQLA_1499_app2;
run;

proc sql;
Create Table QLA_1599_app2 as
select a.*, b.Region format=$5., b.Afford_QLA, b.RateInDecNew, b.RI
from SPL_Apps2 as a
left join SPLGrid as b
on upcase(a.app1_new_province) = upcase(b.Region) and a.SPL_interest_rate_1599 = b.RateInDecNew
and a.RemainingIncome >= round(b.RI,0.01)
where round(Rateindecnew,0.01) = 15.99
;quit;
proc sort data = QLA_1599_app2;
    by descending App_ID descending Afford_QLA;
run;
data Afford_QLA_1599_app2; set QLA_1599_app2;
rename Afford_QLA=AffordQLA_1599_app2;
 by descending App_ID descending Afford_QLA; 
if first.App_ID then output;
run;
data MaxAffordQLA_1599_app2;
set Afford_QLA_1599_app2;
MaxAffordQLA_1599_app2= AffordQLA_1599_app2;
run;

proc sql;
Create Table QLA_1699_app2 as
select a.*, b.Region format=$5., b.Afford_QLA, b.RateInDecNew, b.RI
from SPL_Apps2 as a
left join SPLGrid as b
on upcase(a.app1_new_province) = upcase(b.Region) and a.SPL_interest_rate_1699 = b.RateInDecNew
and a.RemainingIncome >= round(b.RI,0.01)
where round(RateInDecNew,0.01) = 16.99
;quit;
proc sort data = QLA_1699_app2;
    by descending App_ID descending Afford_QLA;
run;
data Afford_QLA_1699_app2; set QLA_1699_app2;
rename Afford_QLA=AffordQLA_1699_app2;
 by descending App_ID descending Afford_QLA; 
if first.App_ID then output;
run;
data MaxAffordQLA_1699_app2;
set Afford_QLA_1699_app2;
MaxAffordQLA_1699_app2= AffordQLA_1699_app2;
run;

proc sql;
Create Table QLA_1799_app2 as
select a.*, b.Region format=$5., b.Afford_QLA, b.RateInDecNew, b.RI
from SPL_Apps2 as a
left join SPLGrid as b
on upcase(a.app1_new_province) = upcase(b.Region) and a.SPL_interest_rate_1799 = b.RateInDecNew
and a.RemainingIncome >= round(b.RI,0.01)
where round(RateInDecNew,0.01) = 17.99
;quit;
proc sort data = QLA_1799_app2;
    by descending App_ID descending Afford_QLA;
run;
data Afford_QLA_1799_app2; set QLA_1799_app2;
rename Afford_QLA=AffordQLA_1799_app2;
 by descending App_ID descending Afford_QLA; 
if first.App_ID then output;
run;
data MaxAffordQLA_1799_app2;
set Afford_QLA_1799_app2;
MaxAffordQLA_1799_app2= AffordQLA_1799_app2;
run;

proc sql;
Create Table QLA_1899_app2 as
select a.*, b.Region format=$5., b.Afford_QLA, b.RateInDecNew, b.RI
from SPL_Apps2 as a
left join SPLGrid as b
on upcase(a.app1_new_province) = upcase(b.Region) and a.SPL_interest_rate_1899 = b.RateInDecNew
and a.RemainingIncome >= round(b.RI,0.01)
where round(RateInDecNew,0.01) = 18.99
;quit;
proc sort data = QLA_1899_app2;
    by descending App_ID descending Afford_QLA;
run;
data Afford_QLA_1899_app2; set QLA_1899_app2;
rename Afford_QLA=AffordQLA_1899_app2;
 by descending App_ID descending Afford_QLA; 
if first.App_ID then output;
run;
data MaxAffordQLA_1899_app2;
set Afford_QLA_1899_app2;
MaxAffordQLA_1899_app2= AffordQLA_1899_app2;
run;

proc sql;
Create Table QLA_1999_app2 as
select a.*, b.Region format=$5., b.Afford_QLA, b.RateInDecNew, b.RI
from SPL_Apps2 as a
left join SPLGrid as b
on upcase(a.app1_new_province) = upcase(b.Region) and a.SPL_interest_rate_1999 = b.RateInDecNew
and a.RemainingIncome >= round(b.RI,0.01)
where round(RateInDecNew,0.01) = 19.99
;quit;
proc sort data = QLA_1999_app2;
    by descending App_ID descending Afford_QLA;
run;
data Afford_QLA_1999_app2; set QLA_1999_app2;
rename Afford_QLA=AffordQLA_1999_app2;
 by descending App_ID descending Afford_QLA; 
if first.App_ID then output;
run;
data MaxAffordQLA_1999_app2;
set Afford_QLA_1999_app2;
MaxAffordQLA_1999_app2= AffordQLA_1999_app2;
run;

proc sql;
Create Table QLA_2099_app2 as
select a.*, b.Region format=$5., b.Afford_QLA, b.RateInDecNew, b.RI
from SPL_Apps2 as a
left join SPLGrid as b
on upcase(a.app1_new_province) = upcase(b.Region) and a.SPL_interest_rate_2099 = b.RateInDecNew
and a.RemainingIncome >= round(b.RI,0.01)
where round(RateInDecNew,0.01) = 20.99
;quit;
proc sort data = QLA_2099_app2;
    by descending App_ID descending Afford_QLA;
run;
data Afford_QLA_2099_app2; set QLA_2099_app2;
rename Afford_QLA=AffordQLA_2099_app2;
 by descending App_ID descending Afford_QLA; 
if first.App_ID then output;
run;
data MaxAffordQLA_2099_app2;
set Afford_QLA_2099_app2;
MaxAffordQLA_2099_app2= AffordQLA_2099_app2;
run;

proc sql;
Create Table QLA_2199_app2 as
select a.*, b.Region format=$5., b.Afford_QLA, b.RateInDecNew, b.RI
from SPL_Apps2 as a
left join SPLGrid as b
on upcase(a.app1_new_province) = upcase(b.Region) and a.SPL_interest_rate_2199 = b.RateInDecNew
and a.RemainingIncome >= round(b.RI,0.01)
where round(RateInDecNew,0.01) = 21.99
;quit;
proc sort data = QLA_2199_app2;
    by descending App_ID descending Afford_QLA;
run;
data Afford_QLA_2199_app2; set QLA_2199_app2;
rename Afford_QLA=AffordQLA_2199_app2;
 by descending App_ID descending Afford_QLA; 
if first.App_ID then output;
run;
data MaxAffordQLA_2199_app2;
set Afford_QLA_2199_app2;
MaxAffordQLA_2199_app2= AffordQLA_2199_app2;
run;

proc sql;
Create Table QLA_2299_app2 as
select a.*, b.Region format=$5., b.Afford_QLA, b.RateInDecNew, b.RI
from SPL_Apps2 as a
left join SPLGrid as b
on upcase(a.app1_new_province) = upcase(b.Region) and a.SPL_interest_rate_2299 = b.RateInDecNew
and a.RemainingIncome >= round(b.RI,0.01)
where round(RateInDecNew,0.01) = 22.99
;quit;
proc sort data = QLA_2299_app2;
    by descending App_ID descending Afford_QLA;
run;
data Afford_QLA_2299_app2; set QLA_2299_app2;
rename Afford_QLA=AffordQLA_2299_app2;
 by descending App_ID descending Afford_QLA; 
if first.App_ID then output;
run;
data MaxAffordQLA_2299_app2;
set Afford_QLA_2299_app2;
MaxAffordQLA_2299_app2= AffordQLA_2299_app2;
run;

proc sql;
Create Table QLA_2399_app2 as
select a.*, b.Region format=$5., b.Afford_QLA, b.RateInDecNew, b.RI
from SPL_Apps2 as a
left join SPLGrid as b
on upcase(a.app1_new_province) = upcase(b.Region) and a.SPL_interest_rate_2399 = b.RateInDecNew
and a.RemainingIncome >= round(b.RI,0.01)
where round(RateInDecNew,0.01) = 23.99
;quit;
proc sort data = QLA_2399_app2;
    by descending App_ID descending Afford_QLA;
run;
data Afford_QLA_2399_app2; set QLA_2399_app2;
rename Afford_QLA=AffordQLA_2399_app2;
 by descending App_ID descending Afford_QLA ; 
if first.App_ID then output;
run;
data MaxAffordQLA_2399_app2;
set Afford_QLA_2399_app2;
MaxAffordQLA_2399_app2 = AffordQLA_2399_app2;
run;

/*Join tables for MAXAffordable QLA*/
proc sql;
Create Table AffordQLA_joined2 as
select a.*, b.MaxAffordQLA_0999_app2 ,  c.MaxAffordQLA_1099_app2,  d.MaxAffordQLA_1199_app2,   e.MaxAffordQLA_1299_app2,  f.MaxAffordQLA_1399_app2,  g.MaxAffordQLA_1499_app2,  h.MaxAffordQLA_1599_app2,  i.MaxAffordQLA_1699_app2,  j.MaxAffordQLA_1799_app2,  k.MaxAffordQLA_1899_app2,  l.MaxAffordQLA_1999_app2,  m.MaxAffordQLA_2099_app2,  n.MaxAffordQLA_2199_app2,  o.MaxAffordQLA_2299_app2,   p.MaxAffordQLA_2399_app2
from SPL_Apps2 as a
left join MaxAffordQLA_0999_app2 as b
on a.App_ID = b.App_ID
left join MaxAffordQLA_1099_app2 as c
on a.App_ID = c.App_ID
left join MaxAffordQLA_1199_app2 as d
on a.App_ID = d.App_ID
left join MaxAffordQLA_1299_app2 as e 
on a.App_ID = e.App_ID
left join MaxAffordQLA_1399_app2 as f
on a.App_ID = f.App_ID
left join MaxAffordQLA_1499_app2 as g
on a.App_ID = g.App_ID
left join MaxAffordQLA_1599_app2 as h
on a.App_ID = h.App_ID
left join MaxAffordQLA_1699_app2 as i
on a.App_ID = i.App_ID
left join MaxAffordQLA_1799_app2 as j
on a.App_ID = j.App_ID
left join MaxAffordQLA_1899_app2 as k
on a.App_ID = k.App_ID
left join MaxAffordQLA_1999_app2 as l
on a.App_ID = l.App_ID
left join MaxAffordQLA_2099_app2 as m
on a.App_ID = m.App_ID
left join MaxAffordQLA_2199_app2 as n
on a.App_ID = n.App_ID
left join MaxAffordQLA_2299_app2 as o
on a.App_ID = o.App_ID
left join MaxAffordQLA_2399_app2 as p
on a.App_ID = p.App_ID
;quit;

/** Set Blank QLA to 0*/
data AffordQLA_joined2;
set AffordQLA_joined2;
if MaxAffordQLA_0999_app2 = . then MaxAffordQLA_0999_app2 = 0;
if MaxAffordQLA_1099_app2 = . then MaxAffordQLA_1099_app2 = 0;
if MaxAffordQLA_1199_app2 = . then MaxAffordQLA_1199_app2 = 0;
if MaxAffordQLA_1299_app2 = . then MaxAffordQLA_1299_app2 = 0;
if MaxAffordQLA_1399_app2 = . then MaxAffordQLA_1399_app2 = 0;
if MaxAffordQLA_1499_app2 = . then MaxAffordQLA_1499_app2 = 0;
if MaxAffordQLA_1599_app2 = . then MaxAffordQLA_1599_app2 = 0;
if MaxAffordQLA_1699_app2 = . then MaxAffordQLA_1699_app2 = 0;
if MaxAffordQLA_1799_app2 = . then MaxAffordQLA_1799_app2 = 0;
if MaxAffordQLA_1899_app2 = . then MaxAffordQLA_1899_app2 = 0;
if MaxAffordQLA_1999_app2 = . then MaxAffordQLA_1999_app2 = 0;
if MaxAffordQLA_2099_app2 = . then MaxAffordQLA_2099_app2 = 0;
if MaxAffordQLA_2199_app2 = . then MaxAffordQLA_2199_app2 = 0;
if MaxAffordQLA_2299_app2 = . then MaxAffordQLA_2299_app2 = 0;
if MaxAffordQLA_2399_app2 = . then MaxAffordQLA_2399_app2 = 0;
run;

/*Assign Max Affordable Limit for and app2*/

data MaxLimit2;
set AffordQLA_joined2;
If 626 < App2_EFSCVRiskScore <= 645 and MaxAffordQLA_1799_app2 > 50000 then MaxAffordQLA_1799_app2 = 50000;
If 610 <= App2_EFSCVRiskScore <= 626 and MaxAffordQLA_1999_app2  > 50000 then MaxAffordQLA_1999_app2 = 50000;
If 593 <= App2_EFSCVRiskScore <= 609 and MaxAffordQLA_2199_app2  > 25000 then MaxAffordQLA_2199_app2  = 25000;
If App2_EFSCVRiskScore < 593 and MaxAffordQLA_2399_app2  > 20000 then MaxAffordQLA_2399_app2 = 20000;
run;

/*Calculate SPL QLA for each int rate*/

data SPLQLA2;
set MaxLimit2;

SPL_QLA_0999_app2= Min (SPL_HomeEquity, MaxAffordQLA_0999_app2);
SPL_QLA_1099_app2= Min (SPL_HomeEquity, MaxAffordQLA_1099_app2);
SPL_QLA_1199_app2= Min (SPL_HomeEquity, MaxaffordQLA_1199_app2);
SPL_QLA_1299_app2= Min (SPL_HomeEquity, MaxAffordQLA_1299_app2);
SPL_QLA_1399_app2= Min (SPL_HomeEquity, MaxAffordQLA_1399_app2);
SPL_QLA_1499_app2= Min (SPL_HomeEquity, MaxAffordQLA_1499_app2);
SPL_QLA_1599_app2= Min (SPL_HomeEquity, MaxAffordQLA_1599_app2);
SPL_QLA_1699_app2= Min (SPL_HomeEquity, MaxAffordQLA_1699_app2);
SPL_QLA_1799_app2= Min (SPL_HomeEquity, MaxAffordQLA_1799_app2);
SPL_QLA_1899_app2= Min (SPL_HomeEquity, MaxAffordQLA_1899_app2);
SPL_QLA_1999_app2= Min (SPL_HomeEquity, MaxAffordQLA_1999_app2);
SPL_QLA_2099_app2= Min (SPL_HomeEquity, MaxAffordQLA_2099_app2);
SPL_QLA_2199_app2= Min (SPL_HomeEquity, MaxAffordQLA_2199_app2);
SPL_QLA_2299_app2= Min (SPL_HomeEquity, MaxAffordQLA_2299_app2);
SPL_QLA_2399_app2= Min (SPL_HomeEquity, MaxAffordQLA_2399_app2);
run;

/*Assign Score based QLA and interest rate*/

data ScoreQLA2;
set SPLQLA2;

If App2_EFSCVRiskScore > 682 then do;
If 70000.01 <= SPL_QLA_0999_app2 <= 75000 then do ;
SPLQLA2 = SPL_QLA_0999_app2 ;
SPLInterestRate_app2 = 9.99; 
end;
Else If 65000.01 <= SPL_QLA_1099_app2 <= 70000 then do;
SPLQLA2 = SPL_QLA_1099_app2 ;
SPLInterestRate_app2
 = 10.99; 
end;
Else If 60000.01 <= SPL_QLA_1199_app2 <= 65000 then do; 
SPLQLA2 = SPL_QLA_1199_app2 ;
SPLInterestRate_app2
 = 11.99; 
end;
Else If 55000.01 <= SPL_QLA_1299_app2 <= 60000 then do; 
SPLQLA2 = SPL_QLA_1299_app2;
SPLInterestRate_app2
 = 12.99; end;
Else If 50100.01<= SPL_QLA_1299_app2 <= 55000 then do; 
SPLQLA2 = SPL_QLA_1299_app2;
SPLInterestRate_app2
 = 12.99; end;
Else do
SPLQLA2 = SPL_QLA_1499_app2;  
SPLInterestRate_app2
 = 14.99;
end;
end;

If 646 <= App2_EFSCVRiskScore <= 682 then do;
If 70000.01 <= SPL_QLA_1199_app2 <= 75000 then do; 
SPLQLA2 = SPL_QLA_1199_app2;
SPLInterestRate_app2
 = 11.99; 
end;
Else If 65000.01 <= SPL_QLA_1299_app2 <= 70000 then do; 
SPLQLA2 = SPL_QLA_1299_app2;
SPLInterestRate_app2
 = 12.99; end;
Else If 60000.01 <= SPL_QLA_1399_app2 <= 65000 then do; 
SPLQLA2 = SPL_QLA_1399_app2;
SPLInterestRate_app2
 = 13.99; end;
Else If 55000.01 <= SPL_QLA_1499_app2 <= 60000 then do; 
SPLQLA2 = SPL_QLA_1499_app2;
SPLInterestRate_app2
 = 14.99; end;
Else If 50100.01<= SPL_QLA_1499_app2 <= 55000 then do; 
SPLQLA2 = SPL_QLA_1499_app2; SPLInterestRate_app2
 = 14.99; end;
Else do SPLQLA2 = SPL_QLA_1499_app2; SPLInterestRate_app2
 = 14.99;end;
end;

If 627 <= App2_EFSCVRiskScore <= 645 then do;
SPLQLA2 = SPL_QLA_1799_app2; SPLInterestRate_app2
 = 17.99; end;
If 610 <= App2_EFSCVRiskScore <= 626 then do;
SPLQLA2 = SPL_QLA_1999_app2; SPLInterestRate_app2
 = 19.99; end;
If 593 <= App2_EFSCVRiskScore <= 609 then do ;
SPLQLA2 = SPL_QLA_2199_app2 ; SPLInterestRate_app2
 = 21.99;end;
If 577 <= App2_EFSCVRiskScore <= 592 then  do ;
SPLQLA2 = SPL_QLA_2399_app2 ; SPLInterestRate_app2
 = 23.99;end;
If 564 <= App2_EFSCVRiskScore <= 576 then  do ;
SPLQLA2 = SPL_QLA_2399_app2 ;SPLInterestRate_app2
 = 23.99;end;
run;

/************************** SPL QLA Adjustments for App2 with updated RI cutoffs******************************************/

Data SPL_new_app2_QLA_capped; set ScoreQLA2;

Data SPL_new_app1_QLA_capped; set ScoreQLA;

If SPLInterestRate_app2 = 9.99 then do;
if app2_new_province ="AB" then do;
		if RemainingIncome < 251.3 then SPLQLA2 = 0;
		end;
	if app2_new_province ="BC" then do;
		if RemainingIncome < 251.3 then SPLQLA2= 0;
		end;
	if app2_new_province ="MB" then do;
		if RemainingIncome <255.38 then SPLQLA2= 0;
		end;
	if app2_new_province ="NB" then do;
		if RemainingIncome < 251.3 then SPLQLA2= 0;
		end;
	if app2_new_province ="NL" then do;
		if RemainingIncome < 260.05 then SPLQLA2= 0;
		end;
	if app2_new_province ="NS" then do;
		if RemainingIncome < 251.3 then SPLQLA2= 0;
		end;
	if app2_new_province ="ON" then do;
		if RemainingIncome < 255.96 then SPLQLA2= 0;
		end;
	if app2_new_province ="PE" then do;
		if RemainingIncome < 251.3 then SPLQLA2 = 0;
		end;
	if app2_new_province ="QC" then do;
		if RemainingIncome < 250.49 then SPLQLA2= 0;
		end;
	if app2_new_province ="SK" then do;
		if RemainingIncome < 251.3 then SPLQLA2= 0;
		end;
end;

If SPLInterestRate_app2 = 10.99  then do;
if app2_new_province= "AB" then do; 
if RemainingIncome <268.79 then SPLQLA2 = 0;end;

if app2_new_province= "BC" then do; if 
 RemainingIncome
 <268.79 then SPLQLA2 = 0;end;


if app2_new_province= "MB" then do; if 
 RemainingIncome
 <273.16 then SPLQLA2 = 0;end;


if app2_new_province= "NB" then do; if 
 RemainingIncome
 <268.79 then SPLQLA2 = 0;end;


if app2_new_province= "NL" then do; if 
 RemainingIncome
 <278.16 then SPLQLA2 = 0;end;


if app2_new_province= "NS" then do; if 
 RemainingIncome
 <268.79 then SPLQLA2 = 0;end;


if app2_new_province= "ON" then do; if 
 RemainingIncome
 <273.79 then SPLQLA2 = 0;end;


if app2_new_province= "PE" then do; if 
 RemainingIncome
 <268.79 then SPLQLA2 = 0;end;


if app2_new_province= "QC" then do; if 
 RemainingIncome
 <267.93 then SPLQLA2 = 0;end;


if app2_new_province= "SK" then do; if 
 RemainingIncome
 <268.79 then SPLQLA2 = 0;end;

end;

If SPLInterestRate_app2
 = 11.99 then do;
if app2_new_province= "AB" then do; if 
 RemainingIncome
 < 286.74 then SPLQLA2 = 0; end;

if app2_new_province= "BC" then do; if 
 RemainingIncome
 <286.74 then SPLQLA2 = 0; end;

if app2_new_province= "MB" then do; if 
 RemainingIncome
 <291.4 then SPLQLA2 = 0; end;

if app2_new_province= "NB" then do; if 
 RemainingIncome
 <286.74 then SPLQLA2 = 0; end;

if app2_new_province= "NL" then do; if 
 RemainingIncome
 <296.73 then SPLQLA2 = 0; end;

if app2_new_province= "NS" then do; if 
 RemainingIncome
 <286.74 then SPLQLA2 = 0; end;

if app2_new_province= "ON" then do; if 
 RemainingIncome
 <292.07 then SPLQLA2 = 0; end;

if app2_new_province= "PE" then do; if 
 RemainingIncome
 <286.74 then SPLQLA2 = 0; end;

if app2_new_province= "QC" then do; if 
 RemainingIncome
 <285.82 then SPLQLA2 = 0; end;

if app2_new_province= "SK" then do; if 
 RemainingIncome
 <286.74 then SPLQLA2 = 0; end;
		
end;
If SPLInterestRate_app2
 = 12.99 then do;
if app2_new_province= "AB" then do; if 
 RemainingIncome
 <305.11 then SPLQLA2 = 0; end;

if app2_new_province= "BC" then do; if 
 RemainingIncome
 <305.11 then SPLQLA2 = 0; end;

if app2_new_province= "MB" then do; if 
 RemainingIncome
 <310.07 then SPLQLA2 = 0; end;

if app2_new_province= "NB" then do; if 
 RemainingIncome
 <305.11 then SPLQLA2 = 0; end;

if app2_new_province= "NL" then do; if 
 RemainingIncome
 <315.73 then SPLQLA2 = 0; end;

if app2_new_province= "NS" then do; if 
 RemainingIncome
 <305.11 then SPLQLA2 = 0; end;

if app2_new_province= "ON" then do; if 
 RemainingIncome
 <310.78 then SPLQLA2 = 0; end;

if app2_new_province= "PE" then do; if 
 RemainingIncome
 <305.11 then SPLQLA2 = 0; end;

if app2_new_province= "QC" then do; if 
 RemainingIncome
 <304.13 then SPLQLA2 = 0; end;

if app2_new_province= "SK" then do; if 
 RemainingIncome
 <305.11 then SPLQLA2 = 0; end;

		
end;
If SPLInterestRate_app2
 = 13.99  then do;
if app2_new_province= "AB" then do; if 
 RemainingIncome
 <323.85 then SPLQLA2 = 0; end;

if app2_new_province= "BC" then do; if 
 RemainingIncome
 <323.85 then SPLQLA2 = 0; end;

if app2_new_province= "MB" then do; if 
 RemainingIncome
 <329.12 then SPLQLA2 = 0; end;

if app2_new_province= "NB" then do; if 
 RemainingIncome
 <323.85 then SPLQLA2 = 0; end;

if app2_new_province= "NL" then do; if 
 RemainingIncome
 <335.13 then SPLQLA2 = 0; end;

if app2_new_province= "NS" then do; if 
 RemainingIncome
 <323.85 then SPLQLA2 = 0; end;

if app2_new_province= "ON" then do; if 
 RemainingIncome
 <329.87 then SPLQLA2 = 0; end;

if app2_new_province= "PE" then do; if 
 RemainingIncome
 <323.85 then SPLQLA2 = 0; end;

if app2_new_province= "QC" then do; if 
 RemainingIncome
 <322.81 then SPLQLA2 = 0; end;

if app2_new_province= "SK" then do; if 
 RemainingIncome
 <323.85 then SPLQLA2 = 0; end;

		
end;
If SPLInterestRate_app2
 = 14.99  then do;
if app2_new_province= "AB" then do; if 
 RemainingIncome
 <342.94 then SPLQLA2 = 0; end;

if app2_new_province= "BC" then do; if 
 RemainingIncome
 <342.94 then SPLQLA2 = 0; end;

if app2_new_province= "MB" then do; if 
 RemainingIncome
 <348.52 then SPLQLA2 = 0; end;

if app2_new_province= "NB" then do; if 
 RemainingIncome
 <342.94 then SPLQLA2 = 0; end;

if app2_new_province= "NL" then do; if 
 RemainingIncome
 <354.89 then SPLQLA2 = 0; end;

if app2_new_province= "NS" then do; if 
 RemainingIncome
 <342.94 then SPLQLA2 = 0; end;

if app2_new_province= "ON" then do; if 
 RemainingIncome
 <349.31 then SPLQLA2 = 0; end;

if app2_new_province= "PE" then do; if 
 RemainingIncome
 <342.94 then SPLQLA2 = 0; end;

if app2_new_province= "QC" then do; if 
 RemainingIncome
 <341.84 then SPLQLA2 = 0; end;

if app2_new_province= "SK" then do; if 
 RemainingIncome
 <342.94 then SPLQLA2 = 0; end;

		
end;
If SPLInterestRate_app2
 = 15.99 then do;
if app2_new_province= "AB" then do; if 
 RemainingIncome
 <362.34 then SPLQLA2 = 0; end;

if app2_new_province= "BC" then do; if 
 RemainingIncome
 <362.34 then SPLQLA2 = 0; end;

if app2_new_province= "MB" then do; if 
 RemainingIncome
 <368.23 then SPLQLA2 = 0; end;

if app2_new_province= "NB" then do; if 
 RemainingIncome
 <362.34 then SPLQLA2 = 0; end;

if app2_new_province= "NL" then do; if 
 RemainingIncome
 <374.96 then SPLQLA2 = 0; end;

if app2_new_province= "NS" then do; if 
 RemainingIncome
 <362.34 then SPLQLA2 = 0; end;

if app2_new_province= "ON" then do; if 
 RemainingIncome
 <369.07 then SPLQLA2 = 0; end;

if app2_new_province= "PE" then do; if 
 RemainingIncome
 <362.34 then SPLQLA2 = 0; end;

if app2_new_province= "QC" then do; if 
 RemainingIncome
 <361.18 then SPLQLA2 = 0; end;

if app2_new_province= "SK" then do; if 
 RemainingIncome
 <362.34 then SPLQLA2 = 0; end;

		
end;
If SPLInterestRate_app2
 = 16.99 then do;
if app2_new_province= "AB" then do; if 
 RemainingIncome
 <382.03 then SPLQLA2 = 0; end;

if app2_new_province= "BC" then do; if 
 RemainingIncome
 <382.03 then SPLQLA2 = 0;end;

if app2_new_province= "MB" then do; if 
 RemainingIncome
 <388.24 then SPLQLA2 = 0;end;

if app2_new_province= "NB" then do; if 
 RemainingIncome
 <382.03 then SPLQLA2 = 0;end;

if app2_new_province= "NL" then do; if 
 RemainingIncome
 <395.33 then SPLQLA2 = 0;end;

if app2_new_province= "NS" then do; if 
 RemainingIncome
 <382.03 then SPLQLA2 = 0;end;

if app2_new_province= "ON" then do; if 
 RemainingIncome
 <389.12 then SPLQLA2 = 0;end;

if app2_new_province= "PE" then do; if 
 RemainingIncome
 <382.03 then SPLQLA2 = 0;end;

if app2_new_province= "QC" then do; if 
 RemainingIncome
 <380.8 then SPLQLA2 = 0;end;

if app2_new_province= "SK" then do; if 
 RemainingIncome
 <382.03 then SPLQLA2 = 0;end;

	end;
If SPLInterestRate_app2
 = 17.99  then do;
if app2_new_province= "AB" then do; if 
 RemainingIncome
 <401.96 then SPLQLA2 = 0;end;


if app2_new_province= "BC" then do; if 
 RemainingIncome
 <401.96 then SPLQLA2 = 0;end;


if app2_new_province= "MB" then do; if 
 RemainingIncome
 <408.49 then SPLQLA2 = 0;end;


if app2_new_province= "NB" then do; if 
 RemainingIncome
 <401.96 then SPLQLA2 = 0;end;


if app2_new_province= "NL" then do; if 
 RemainingIncome
 <415.96 then SPLQLA2 = 0;end;


if app2_new_province= "NS" then do; if 
 RemainingIncome
 <401.96 then SPLQLA2 = 0;end;


if app2_new_province= "ON" then do; if 
 RemainingIncome
 <409.43 then SPLQLA2 = 0;end;


if app2_new_province= "PE" then do; if 
 RemainingIncome
 <401.96 then SPLQLA2 = 0;end;


if app2_new_province= "QC" then do; if 
 RemainingIncome
 <400.67 then SPLQLA2 = 0;end;


if app2_new_province= "SK" then do; if 
 RemainingIncome
 <401.96 then SPLQLA2 = 0;end;

end;
If SPLInterestRate_app2
 = 18.99  then do;
if app2_new_province= "AB" then do; if 
 RemainingIncome
 <422.12 then SPLQLA2 = 0;end;


if app2_new_province= "BC" then do; if 
 RemainingIncome
 <422.12 then SPLQLA2 = 0;end;


if app2_new_province= "MB" then do; if 
 RemainingIncome
 <428.98 then SPLQLA2 = 0;end;


if app2_new_province= "NB" then do; if 
 RemainingIncome
 <422.12 then SPLQLA2 = 0;end;


if app2_new_province= "NL" then do; if 
 RemainingIncome
 <436.82 then SPLQLA2 = 0;end;


if app2_new_province= "NS" then do; if 
 RemainingIncome
 <422.12 then SPLQLA2 = 0;end;


if app2_new_province= "ON" then do; if 
 RemainingIncome
 <429.96 then SPLQLA2 = 0;end;


if app2_new_province= "PE" then do; if 
 RemainingIncome
 <422.12 then SPLQLA2 = 0;end;


if app2_new_province= "QC" then do; if 
 RemainingIncome
 <420.77 then SPLQLA2 = 0;end;


if app2_new_province= "SK" then do; if 
 RemainingIncome
 <422.12 then SPLQLA2 = 0;end;


end;
If SPLInterestRate_app2
 = 19.99 then do;
if app2_new_province= "AB" then do; if 
 RemainingIncome
 <442.48 then SPLQLA2 = 0;end;


if app2_new_province= "BC" then do; if 
 RemainingIncome
 <442.48 then SPLQLA2 = 0;end;


if app2_new_province= "MB" then do; if 
 RemainingIncome
 <449.67 then SPLQLA2 = 0;end;


if app2_new_province= "NB" then do; if 
 RemainingIncome
 <442.48 then SPLQLA2 = 0;end;


if app2_new_province= "NL" then do; if 
 RemainingIncome
 <457.89 then SPLQLA2 = 0;end;


if app2_new_province= "NS" then do; if 
 RemainingIncome
 <442.48 then SPLQLA2 = 0;end;


if app2_new_province= "ON" then do; if 
 RemainingIncome
 <450.7 then SPLQLA2 = 0;end;


if app2_new_province= "PE" then do; if 
 RemainingIncome
 <442.48 then SPLQLA2 = 0;end;


if app2_new_province= "QC" then do; if 
 RemainingIncome
 <441.06 then SPLQLA2 = 0;end;


if app2_new_province= "SK" then do; if 
 RemainingIncome
 <442.48 then SPLQLA2 = 0;end;
end;

If SPLInterestRate_app2
 = 20.99 then do;
if app2_new_province= "AB" then do; if 
 RemainingIncome
 <463.02 then SPLQLA2 = 0;end;


if app2_new_province= "BC" then do; if 
 RemainingIncome
 <463.02 then SPLQLA2 = 0;end;


if app2_new_province= "MB" then do; if 
 RemainingIncome
 <463.02 then SPLQLA2 = 0;end;


if app2_new_province= "NB" then do; if 
 RemainingIncome
 <463.02 then SPLQLA2 = 0;end;


if app2_new_province= "NL" then do; if 
 RemainingIncome
 <479.14 then SPLQLA2 = 0;end;


if app2_new_province= "NS" then do; if 
 RemainingIncome
 <463.02 then SPLQLA2 = 0;end;


if app2_new_province= "ON" then do; if 
 RemainingIncome
 <471.62 then SPLQLA2 = 0;end;


if app2_new_province= "PE" then do; if 
 RemainingIncome
 <463.02 then SPLQLA2 = 0;end;


if app2_new_province= "QC" then do; if 
 RemainingIncome
 <461.53 then SPLQLA2 = 0;end;


if app2_new_province= "SK" then do; if 
 RemainingIncome
 <463.02 then SPLQLA2 = 0;end;
end;

If SPLInterestRate_app2
 = 21.99  then do;
if app2_new_province= "AB" then do; if 
 RemainingIncome
 <483.71 then SPLQLA2 = 0;end;


if app2_new_province= "BC" then do; if 
 RemainingIncome
 <483.71 then SPLQLA2 = 0;end;


if app2_new_province= "MB" then do; if 
 RemainingIncome
 <491.57 then SPLQLA2 = 0;end;


if app2_new_province= "NB" then do; if 
 RemainingIncome
 <483.71 then SPLQLA2 = 0;end;


if app2_new_province= "NL" then do; if 
 RemainingIncome
 <500.56 then SPLQLA2 = 0;end;


if app2_new_province= "NS" then do; if 
 RemainingIncome
 <483.71 then SPLQLA2 = 0;end;


if app2_new_province= "ON" then do; if 
 RemainingIncome
 <492.7 then SPLQLA2 = 0;end;


if app2_new_province= "PE" then do; if 
 RemainingIncome
 <483.71 then SPLQLA2 = 0;end;


if app2_new_province= "QC" then do; if 
 RemainingIncome
 <482.16 then SPLQLA2 = 0;end;


if app2_new_province= "SK" then do; if 
 RemainingIncome
 <483.71 then SPLQLA2 = 0;end;
end;

If SPLInterestRate_app2
 = 22.99  then do;
if app2_new_province= "AB" then do; if 
 RemainingIncome
 <504.54 then SPLQLA2 = 0;end;


if app2_new_province= "BC" then do; if 
 RemainingIncome
 <504.54 then SPLQLA2 = 0;end;


if app2_new_province= "MB" then do; if 
 RemainingIncome
 <512.74 then SPLQLA2 = 0;end;


if app2_new_province= "NB" then do; if 
 RemainingIncome
 <504.54 then SPLQLA2 = 0;end;


if app2_new_province= "NL" then do; if 
 RemainingIncome
 <522.11 then SPLQLA2 = 0;end;


if app2_new_province= "NS" then do; if 
 RemainingIncome
 <504.54 then SPLQLA2 = 0;end;


if app2_new_province= "ON" then do; if 
 RemainingIncome
 <513.91 then SPLQLA2 = 0;end;


if app2_new_province= "PE" then do; if 
 RemainingIncome
 <504.54 then SPLQLA2 = 0;end;


if app2_new_province= "QC" then do; if 
 RemainingIncome
 <502.92 then SPLQLA2 = 0;end;


if app2_new_province= "SK" then do; if 
 RemainingIncome
 <504.54 then SPLQLA2 = 0;end;
end;

If SPLInterestRate_app2
 = 23.99 then do;
if app2_new_province= "AB" then do; if 
 RemainingIncome
 <525.49 then SPLQLA2 = 0;end;


if app2_new_province= "BC" then do; if 
 RemainingIncome
 <525.49 then SPLQLA2 = 0;end;


if app2_new_province= "MB" then do; if 
 RemainingIncome
 <534.03 then SPLQLA2 = 0;end;


if app2_new_province= "NB" then do; if 
 RemainingIncome
 <525.49 then SPLQLA2 = 0;end;


if app2_new_province= "NL" then do; if 
 RemainingIncome
 <543.8 then SPLQLA2 = 0;end;


if app2_new_province= "NS" then do; if 
 RemainingIncome
 <525.49 then SPLQLA2 = 0;end;


if app2_new_province= "ON" then do; if 
 RemainingIncome
 <535.25 then SPLQLA2 = 0;end;


if app2_new_province= "PE" then do; if 
 RemainingIncome
 <525.49 then SPLQLA2 = 0;end;


if app2_new_province= "QC" then do; if 
 RemainingIncome
 <523.81 then SPLQLA2 = 0;end;


if app2_new_province= "SK" then do; if 
 RemainingIncome
 <525.49 then SPLQLA2 = 0;end;

If SPL_HomeEquity < 15000 then SPLQLA2 =0;
If App2_EFSCVRiskScore < 564 then SPLQLA2= 0;

end;
run;



proc sql;
create table SPL_QLA_temp as
select a.var2, a.var7,a.app1_province, a.app2_province, a.res_de_var78, a.Res_DE_Var18, a.var256, a.RemainingIncome, a.SPL_HomeEquity,
	b.SPLQLA as Calculated_SPL_New_App1_QLA, a.res_de_var31 as Request_SPL_New_App1_QLA,
	c.SPLQLA2 as Calculated_SPL_New_App2_QLA, a.res_de_var94 as Request_SPL_New_App2_QLA,
	max(b.SPLQLA, c.SPLQLA2) + 100 AS Calculated_SPL_New_QLA, a.res_de_var204 as GDS_SPL_New_QLA,
	a.res_de_var193 as Response_Credit_Contributor, min(SPLInterestRate,SPLInterestRate_app2) AS Final_Int_rate_new
from SPL_Apps as a
left join SPL_new_app1_QLA_capped as b on a.var2 = b.var2
left join SPL_new_app2_QLA_capped as c on a.var2 = c.var2
;quit;

/*Check table for final SPL QLA, Interest Rate, and SPL Contributor*/

data CHECK_SPL_QLA_Final;
format Calculated_Credit_Contributor $12.;
set SPL_QLA_temp;
if missing(Calculated_SPL_New_App2_QLA) then Calculated_SPL_New_App2_QLA = 0;
if Calculated_SPL_New_QLA = 100 then Calculated_SPL_New_QLA = 0;
if Calculated_SPL_New_App1_QLA = Calculated_SPL_New_App2_QLA and var7 = "Y" then Calculated_Credit_Contributor = 'Shared';
if Calculated_SPL_New_App1_QLA > Calculated_SPL_New_App2_QLA and var7="Y" then Calculated_Credit_Contributor = 'Applicant 1';
if Calculated_SPL_New_App1_QLA < Calculated_SPL_New_App2_QLA then Calculated_Credit_Contributor = 'Applicant 2';
if var7 = "N" then Calculated_Credit_Contributor = 'Applicant 1';

check_SPL_QLA = (Calculated_SPL_New_QLA = GDS_SPL_New_QLA);
check_IR = (Final_Int_rate_new = Response_SPL_New_QLA); 
check_SPL_contributor = (Calculated_Credit_Contributor = Response_Credit_Contributor);

keep var2 var7 app1_province app2_province Final_Int_rate_new check_IR Calculated_SPL_New_QLA GDS_SPL_New_QLA check_SPL_QLA Calculated_Credit_Contributor Response_Credit_Contributor check_SPL_contributor;
run;
