/*

Here are the changes 
second changes
third change
Fourth Change
**************************V6 August 17, 2020****************************************

1. Remaininc("24. ET - Remaining Income & DTI" in original testing file)
2. Date: June 18, 2020
3. CMO Phase 2.0 Implementation
4. Search for "CMO PHASE 2.0" to find the changes in the code
*/
data m3;
	set m2;

	/*set table2.final_output_new_full;*/
	cRes_DE_Var422 = input(Res_DE_Var422,32.);
	cRes_DE_Var421 = input(Res_DE_Var421,32.);
	cRes_DE_Var416 = input(Res_DE_Var416,32.);
	cRes_DE_Var321 = input(Res_DE_Var321,32.);
	cRes_DE_Var18 = input(Res_DE_Var18,32.);
	cVAR253 = input(VAR253,32.);
	cRes_DE_Var528 = input(Res_DE_Var528, 32.);
	cRes_DE_Var529 = input(Res_DE_Var529, 32.);
	cRes_DE_Var532 = input(Res_DE_Var532, 32.);
	cRes_DE_Var533 = input(Res_DE_Var533, 32.);
	cRes_DE_Var330 = input(Res_DE_Var330,32.);
	cRes_DE_Var407 = input(Res_DE_Var407,32.);
	cRes_DE_Var419= input(Res_DE_Var419,32.);

	/*****************************Create Banking New Loan Adjusted CV Risk Groups; CMO Phase 2.0*************************/
	Strategy_Bank_Adj_Cv_RG_App1 = upcase(Res_DE_Var528);
	Strategy_Bank_Adj_Cv_RG_G2_App1 = upcase(Res_DE_Var528);
	Declined_Bank_Adj_Cv_RG_App1 = upcase(Res_DE_Var528);
	Strategy_Bank_Adj_Cv_RG_App2 = upcase(Res_DE_Var533);
	Strategy_Bank_Adj_Cv_RG_G2_App2 = upcase(Res_DE_Var533);
	Declined_Bank_Adj_Cv_RG_App2 = upcase(Res_DE_Var533);
	cRes_DE_Var531 = input(Res_DE_Var531,32.);
	cRes_DE_Var537 = input(Res_DE_Var537,32.);

	/*********************EFS Banking Strategy Grid 2; Adjusted CV Risk Groups App1; CMO Phase 2.0***********************************************/
	Income75=.70*cRes_DE_Var422;
	Income65=.65*cRes_DE_Var422;
	Income60=.60*cRes_DE_Var422;
	Income55=.55*cRes_DE_Var422;
	if VAR9="FULL" and VAR6="NEW" then do;
		if res_de_Var44 in ("CreditAdjudication_Challenger_EFS_Quebec3.0_New_Loan","CreditAdjudication_Challenger_EFS_Quebec2.0_New_Loan") then
			AT_UPL_RemainingIncomeApp1 = sum(Income55, -cRes_DE_Var421);
		AT_UPL_RemainingIncome = AT_UPL_RemainingIncomeApp1;
		if Res_DE_Var44 ="CreditAdjudication_Challenger_EFS_CAB_App1" then do;
			if VAR7='N' then do;
				if cRes_DE_Var416 in (46.96,44.96) then do;
					if cRes_DE_Var321 = -1 then do;
						AT_UPL_RemainingIncomeApp1 = sum(Income55, -cRes_DE_Var421);
					end;
					if cRes_DE_Var321 >= 0 then do;
						if Res_DE_Var145 in ("RISK GROUP 1","RISK GROUP 2") then do;
							if 	VAR52='Own' then do;
								AT_UPL_RemainingIncomeApp1 = sum(Income70, -cRes_DE_Var421);
							end;
							else if VAR52='Rent' then do;
								AT_UPL_RemainingIncomeApp1 = sum(Income65, -cRes_DE_Var421);
							end;
						end;
						if Res_DE_Var145 in ("RISK GROUP 3","RISK GROUP 4","RISK GROUP 5","RISK GROUP 6") then do;
							AT_UPL_RemainingIncomeApp1 = sum(Income60, -cRes_DE_Var421);
						end;
					end;
				end;
				if cRes_DE_Var416 not in (46.96,44.96) then do;
					if cRes_DE_Var18 >= 646 and VAR52='Own' then do;
						AT_UPL_RemainingIncomeApp1 = sum(Income65, -Res_DE_Var421);
					end;
					else do;
						AT_UPL_RemainingIncomeApp1 = sum(Income55, -Res_DE_Var421);
					end;
				end;
				AT_UPL_RemainingIncome=AT_UPL_RemainingIncomeApp1;
			end;
			if VAR7='Y' then do;
				if cRes_DE_Var416 in (46.96,44.96) then do;
					if cRes_DE_Var321 = -1 then do;
						AT_UPL_RemainingIncomeApp2 = sum(Income55, -cRes_DE_Var421);
					end;
					if cRes_DE_Var321 >= 0 then do;
						if Res_DE_Var145 in ("RISK GROUP 1","RISK GROUP 2") then do;
							if 	VAR52='Own' then do;
								AT_UPL_RemainingIncomeApp2 = sum(Income70, -cRes_DE_Var421);
							end;
							else if VAR52='Rent' then do;
								AT_UPL_RemainingIncomeApp2 = sum(Income65, -cRes_DE_Var421);
							end;
						end;
						if Res_DE_Var145 in ("RISK GROUP 3","RISK GROUP 4","RISK GROUP 5","RISK GROUP 6") then do;
							AT_UPL_RemainingIncomeApp2 = sum(Income60, -cRes_DE_Var421);
						end;
					end;
					if cRes_DE_Var330 = -1 then do;
						AT_UPL_RemainingIncomeApp2 = sum(Income55, -cRes_DE_Var421);
					end;
					if cRes_DE_Var330 >= 0 then do;
						if Res_DE_Var145 in ("RISK GROUP 1","RISK GROUP 2") then do;
							if 	VAR52='Own' then do;
								AT_UPL_RemainingIncomeApp2 = sum(Income70, -cRes_DE_Var421);
							end;
							else if VAR52='Rent' then do;
								AT_UPL_RemainingIncomeApp2 = sum(Income65, -cRes_DE_Var421);
							end;
						end;
						if Res_DE_Var145 in ("RISK GROUP 3","RISK GROUP 4","RISK GROUP 5","RISK GROUP 6") then do;
							AT_UPL_RemainingIncomeApp2 = sum(Income60, -cRes_DE_Var421);
						end;
					end;
					if VAR7='N' then do;
						AT_UPL_RemainingIncome=AT_UPL_RemainingIncomeApp1;
					end;
					if VAR7='Y' then do;
						AT_UPL_RemainingIncome=AT_UPL_RemainingIncomeApp2;
					end;
				end;
				if cRes_DE_Var416 not in (46.96,44.96) then do;
					if cRes_DE_Var18 >= 646 and VAR52='Own' then do;
						AT_UPL_RemainingIncome = sum(Income65, -Res_DE_Var421);
					end;
					else do;
						AT_UPL_RemainingIncome = sum(Income55, -Res_DE_Var421);
					end;
				end;
			end;

			/*		end;*/
			/*			if VAR1 NE "1" then do;*/
			/*				if Res_DE_Var342 eq "FAIL" then do;*/
			/*					AT_UPL_RemainingIncome = sum(Income55, -Res_DE_Var421);*/
			/*				end;*/
			/*			end;*/
		end;

		/*Strategy Model Remanininc Calculation; Starts; CMO Phase 2.0*/
		if Res_DE_Var44 ="CreditAdjudication_Challenger_EFS_Banking_New_Loan" then do;
			if cRes_DE_Var416 in (46.96,44.96) then do;
				if Strategy_Bank_Adj_Cv_RG_App1 in ("RISK GROUP 1","RISK GROUP 2") then do;
					if 	VAR52='Own' then do;
						AT_UPL_RemainingIncomeApp1 = sum(Income65, -cRes_DE_Var421);
					end;
					else if VAR52='Rent' then do;
						AT_UPL_RemainingIncomeApp1 = sum(Income55, -cRes_DE_Var421);
					end;
				end;
				if Strategy_Bank_Adj_Cv_RG_App1 not in ("RISK GROUP 1","RISK GROUP 2") then do;
					AT_UPL_RemainingIncomeApp1 = sum(Income55, -cRes_DE_Var421);
				end;
			end;
			if cRes_DE_Var416 not in (46.96,44.96) then do;
				if Strategy_Bank_Adj_Cv_RG_App1 in ("RISK GROUP 1","RISK GROUP 2") then do;
					if VAR52='Own' then do;
						AT_UPL_RemainingIncomeApp1 = sum(Income65, -Res_DE_Var421);
					end;
					if VAR52='Rent' then do;
						AT_UPL_RemainingIncomeApp1 = sum(Income55, -Res_DE_Var421);
					end;
				end;
				else if Strategy_Bank_Adj_Cv_RG_App1 not in ("RISK GROUP 1","RISK GROUP 2") then do;
					AT_UPL_RemainingIncomeApp1 = sum(Income55, -Res_DE_Var421);
				end;
			end;
			if VAR7='Y' then do;
				if cRes_DE_Var416 in (46.96,44.96) then do;
					if Strategy_Bank_Adj_Cv_RG_App1 in ("RISK GROUP 1","RISK GROUP 2") then do;
						if 	VAR52='Own' then do;
							AT_UPL_RemainingIncomeApp2 = sum(Income65, -cRes_DE_Var421);
						end;
						else if VAR52='Rent' then do;
							AT_UPL_RemainingIncomeApp2 = sum(Income55, -cRes_DE_Var421);
						end;
					end;
					if Strategy_Bank_Adj_Cv_RG_App1 not in ("RISK GROUP 1","RISK GROUP 2") then do;
						AT_UPL_RemainingIncomeApp2 = sum(Income55, -cRes_DE_Var421);
					end;
				end;
				if cRes_DE_Var416 not in (46.96,44.96) then do;
					if Strategy_Bank_Adj_Cv_RG_App1 in ("RISK GROUP 1","RISK GROUP 2") then do;
						if VAR52='Own' then do;
							AT_UPL_RemainingIncomeApp2 = sum(Income65, -Res_DE_Var421);
						end;
						if VAR52='Rent' then do;
							AT_UPL_RemainingIncomeApp2 = sum(Income55, -Res_DE_Var421);
						end;
					end;
					else if Strategy_Bank_Adj_Cv_RG_App1 not in ("RISK GROUP 1","RISK GROUP 2") then do;
						AT_UPL_RemainingIncomeApp2 = sum(Income55, -Res_DE_Var421);
					end;
				end;
			end;

			/*Strategy Model Remanininc Calculation; Ends; CMO Phase 2.0*/
			if VAR7='N' then do;
				AT_UPL_RemainingIncome=AT_UPL_RemainingIncomeApp1;
			end;
			if VAR7='Y' then do;
				AT_UPL_RemainingIncome=AT_UPL_RemainingIncomeApp2;
			end;
		end;
		if Res_DE_Var44 = "CreditAdjudication_Champion_EFS_CV_App1" then do;
			if cRes_DE_Var18 >= 646 and VAR52='Own' then do;
				AT_UPL_RemainingIncome = sum(Income65, -Res_DE_Var421);
			end;
			else do;
				AT_UPL_RemainingIncome = sum(Income55, -Res_DE_Var421);
			end;
		end;

		/*Declined Model Remanininc Calculation; Start; CMO Phase 2.0*/
		if Res_DE_Var45 ="QLA_Challenger_EFS_Banking_Declined_New_loan" then do;
			AT_UPL_RemainingIncome = sum(Income55, -cRes_DE_Var421);
		end;

		/*Declined Model Remanininc Calculation; End; CMO Phase 2.0*/
		/*Remaininc Calc for Blank CA Strategy; Start; CMO Phase 2.0*/
		if Res_DE_Var44 ="" and Res_TU_Var353 ne 'H' and Res_DE_Var45 = '' then do;
			AT_UPL_RemainingIncome = sum(Income55, -cRes_DE_Var421);
		end;
		if Res_DE_Var44 ne "CreditAdjudication_Challenger_EFS_CAB_App1" then do;
			if Res_DE_Var44 = "CreditAdjudication_Champion_EFS_CV_App1" then do;
				if cRes_DE_Var18 >= 646 and VAR52='Own' then do;
					AT_UPL_RemainingIncome = sum(Income65, -Res_DE_Var421);
				end;
				else do;
					AT_UPL_RemainingIncome = sum(Income55, -Res_DE_Var421);
				end;
			end;
			if Res_DE_Var44 = "CreditAdjudication_Challenger_EFS_RIM_New_Loan" then do;
				if cRes_DE_Var18 >= 631 and VAR52='Own' then do;
					AT_UPL_RemainingIncome = sum(Income65, -Res_DE_Var421);
				end;
				else do;
					AT_UPL_RemainingIncome = sum(Income55, -Res_DE_Var421);
				end;
			end;
		end;
	end;
	if VAR9="EXPRESS" and VAR6="NEW" then do;
		if cRes_DE_Var18 >= 646 and VAR52='Own' then do;
			AT_UPL_RemainingIncome = sum(Income65, -Res_DE_Var421);
		end;
		else do;
			AT_UPL_RemainingIncome = sum(Income55, -Res_DE_Var421);
		end;
	end;
	if var6 = "INCREASE" and var260='1' then do;
		if var105 = "-1"  then do;
			if var52 = "Own" and cres_de_Var18 >= 646 then
				cal_remaining_income = cRes_DE_Var422 *0.65 - cRes_DE_Var421;
			else cal_remaining_income = cRes_DE_Var422 *0.55 - cRes_DE_Var421;
		end;
		else cal_remaining_income = cRes_DE_Var422 *0.55 - cRes_DE_Var421;
	AT_UPL_RemainingIncome = cal_remaining_income;
	end;

run;

data m3;
	set m3;

	/*if cVAR253=1 then do;	*/
	AT_UPL_DebtToIncome = cRes_DE_Var421/cRes_DE_Var422;

	/*end;	*/
	/*if cVAR247=1 then do;	*/
	/*	AT_UPL_DebtToIncome = cRes_DE_Var421/cRes_DE_Var422;*/
	/*end;	*/
run;

data check_RI_DTI;
	set m3;

	/*	(keep= VAR52 Res_TU_Var353 VAR1 res_de_var18 Res_DE_Var342 Res_DE_Var419 var2 AT_UPL_RemainingIncomeApp2 AT_UPL_RemainingIncomeApp1 cRes_DE_Var416 cRes_DE_Var330 Res_DE_Var421 VAR9 VAR6 cRes_DE_Var321 cRes_DE_Var422 Res_DE_Var44 cVAR253 Res_DE_Var145 Res_DE_Var419 Res_DE_Var407 AT_UPL_RemainingIncome AT_UPL_DebtToIncome where=(Res_TU_Var353='H'));*/
	if round(input(Res_DE_Var419,32.),0.01)=round(AT_UPL_RemainingIncome,0.01) then
		check_RI=1;
	else check_RI=0;
	AT_DTI=round(AT_UPL_DebtToIncome*100,0.0001);
	if round(input(Res_DE_Var407,32.),0.001)=round(AT_DTI,0.001) then
		check_DTI=1;
	else check_DTI=0;
	keep  var2 Res_DE_Var145 Res_DE_Var342 Strategy_Bank_Adj_Cv_RG_App1 VAR52 var253 res_De_Var416 res_de_Var44 AT_UPL_RemainingIncome Res_DE_Var407 AT_DTI res_De_Var18 Res_DE_Var421 res_DE_Var422 Res_DE_Var419 check_RI check_DTI;

	/*	where=(Res_TU_Var353='H');*/
run;