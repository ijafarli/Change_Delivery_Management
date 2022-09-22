/* Create ID/ECT_Label Table */

proc sql;
*Can you see this;

create table ID_Table 

(ECT_Label char(100),
ECT_Label_ID char(15));

insert into ID_Table
values('AOT 24.99% - 12M Temp', '12M_24_5Y_NW')
values('AOT 24.99% - 12M Temp (Partial Waive) 7Y', '12M_24_7Y_PW')
values('AOT 24.99% - 12M Temp 7Y', '12M_24_7Y_NW')
values('AOT 29.99% - 12M Temp', '12M_29_5Y_NW')
values('AOT 29.99% - 12M Temp (Partial Waive)', '12M_29_5Y_PW')
values('AOT 29.99% - 12M Temp (Partial Waive) 7Y', '12M_29_7Y_PW')
values('AOT 29.99% - 6M Temp', '6M _29_5Y_NW')
values('AOT 29.99% - 6M Temp 7Y', '6M _29_7Y_NW')
values('AOT 32.99% - 12M Temp', '12M_32_5Y_NW')
values('AOT 32.99% - 12M Temp (Partial Waive) 7Y', '12M_32_7Y_PW')
values('AOT 32.99% - 12M Temp 7Y', '12M_32_7Y_NW');

select * 
from ID_Table
;quit;


data current_ECT_offers_assigned;
length ECT_Label_ID $50;
set current nobs=nobs;

if current_int > 37.99 then interest_group = "> 37.99";
if current_int <= 37.99 then interest_group = "<=37.99";


*Current Delinquency Increase Loans;


	if loan_type = 'Increase' then do;	

		if Balance_Group = "> 5000" then do;
			if current_int > 37.99 then do;
				if random_number <= 0.50 then ECT_Label_ID = '6M _29_7Y_NW'; *C_INC_>_>_1;
				else ECT_LABEL_ID = '12M_32_7Y_NW'; *C_INC_>_>_2;
					end;
			if current_int <= 37.99 then
				ECT_Label_ID = '6M _29_7Y_NW'; *C_INC_>_<_1;
					end;
						

		if balance_group = "<= 5000" then do;
			if current_int > 37.99 then do;
				if random_number <= 0.50 then ECT_Label_ID = '6M _29_5Y_NW'; *C_INC_<_>_1;
				else ECT_Label_ID = '12M_32_5Y_NW'; *C_INC_<_>_2;
					end;
			if current_int <= 37.99 then ECT_Label_ID = '6M _29_5Y_NW'; *C_INC_<_<_1;
				end;
end;
	
*Current Delinquency New Loans;

	if loan_type = 'New' then do;

		if Balance_Group = "> 5000" then do;
			if current_int > 37.99 then do;
				if random_number <= 0.50 then ECT_Label_ID = '6M _29_7Y_NW'; *C_NEW_>_>_1;
				else ECT_LABEL_ID = '12M_32_7Y_NW'; *C_NEW_>_>_2;
					end;
			if current_int <= 37.99 then
				ECT_Label_ID = '6M _29_7Y_NW'; *C_NEW_>_<_1;
					end;
									
		if balance_group = "<= 5000" then do;
			if current_int > 37.99 then do;
				if random_number <= 0.50 then ECT_Label_ID = '6M _29_5Y_NW'; *C_NEW_<_>_1;
				else ECT_Label_ID = '12M_32_5Y_NW'; *C_NEW_<_>_2;

					end;
			if current_int <= 37.99 then ECT_Label_ID = '6M _29_5Y_NW'; *C_NEW_<_<_1;
				end;
end;

*Current Delinquency Refinance Loans;

	if loan_type = 'Refinance' then do;

		if Balance_Group = "> 5000" then do;
			if current_int > 37.99 then do;
				if random_number <= 0.50 then ECT_Label_ID = '6M _29_7Y_NW'; *C_REF_>_>_1;
				else ECT_LABEL_ID = '12M_32_7Y_NW'; *C_REF_>_>_2;
					end;
			if current_int <= 37.99 then
				ECT_Label_ID = '6M _29_7Y_NW'; *C_REF_>_<_1;
					end;
									
		if balance_group = "<= 5000" then do;
			if current_int > 37.99 then do;
				if random_number <= 0.50 then ECT_Label_ID = '6M _29_5Y_NW'; *C_REF_<_>_1;
				else ECT_Label_ID = '12M_32_5Y_NW'; *C_REF_<_>_2;
					end;
			if current_int <= 37.99 then ECT_Label_ID = '6M _29_5Y_NW'; *C_REF_<_<_1;
				end;
end;


run;

/* Test Output */

proc sql;

create table current_offers as 
select a.*, b.ECT_Label
from current_ect_offers_assigned a 
left join ID_Table b

on a.ECT_Label_ID = b.ECT_Label_ID
;quit;



data _1_30_ECT_offers_assigned;
length ECT_Label_ID $50;
set lm_1_30 nobs=nobs;


if current_int > 37.99 then interest_group = "> 37.99";
if current_int <= 37.99 then interest_group = "<=37.99";

if input(branch,32.) in (4529) then do;
	 ECT_Label_ID = '12M_29_5Y_PW'; *1+_POS;

end;
	else if  input(branch,32.) not in (4529) then do;

*1-30 L/M Delinquency Increase Loans;

if risk_segment = 'Low & Medium' then do;

	if loan_type = 'Increase' then do;	

		if Balance_Group = "> 5000" then do;
			if current_int > 37.99 then do;
				if random_number <= 0.50 then ECT_Label_ID = '6M _29_7Y_NW'; *1-30_LM_INC_>_>_1;
				else ECT_LABEL_ID = '12M_32_7Y_NW'; *1-30_LM_INC_>_>_2;
					end;
			if current_int <= 37.99 then
				ECT_Label_ID = '6M _29_7Y_NW'; *1-30_LM_INC_>_<_1;
					end;
									
		if balance_group = "<= 5000" then do;
			if current_int > 37.99 then do;
				if random_number <= 0.50 then ECT_Label_ID = '6M _29_5Y_NW'; *1-30_LM_INC_<_>_1;
				else ECT_Label_ID = '12M_32_5Y_NW'; *1-30_LM_INC_<_>_2;
					end;
			if current_int <= 37.99 then ECT_Label_ID = '6M _29_5Y_NW'; *1-30_LM_INC_<_<_1;
				end;
end;
	

*1-30 L/M Delinquency New Loans;

	if loan_type = 'New' then do;	

		if Balance_Group = "> 5000" then do;
			if current_int > 37.99 then do;
				if random_number <= 0.33 then ECT_Label_ID = '12M_24_7Y_NW'; *1-30_LM_NEW_>_>_1;
				if 0.33 < random_number <= 0.66 then ECT_Label_ID = '6M _29_7Y_NW'; *1-30_LM_NEW_>_>_2;
				if random_number > 0.66 then ECT_Label_ID = '12M_32_7Y_NW'; *1-30_LM_NEW_>_>_1;
					end;
			if current_int <= 37.99 then do;
				if random_number <= 0.50 then ECT_Label_ID = '12M_24_7Y_NW'; *1-30_LM_NEW_>_<_1;
				else ECT_Label_ID = '6M _29_7Y_NW'; *1-30_LM_NEW_>_<_2;
					end;
						end;
						

		if balance_group = "<= 5000" then do;
			if current_int > 37.99 then do;
			if random_number <= 0.33 then ECT_Label_ID = '12M_24_5Y_NW'; *1-30_LM_NEW_<_>_1;
				if 0.33 < random_number <= 0.66 then ECT_Label_ID = '6M _29_5Y_NW'; *1-30_LM_NEW_<_>_2;
				if random_number > 0.66 then ECT_Label_ID = '12M_32_5Y_NW'; *1-30_LM_NEW_<_>_3;
					end;
			if current_int <= 37.99 then ECT_Label_ID = '6M _29_5Y_NW'; *1-30_LM_NEW_<_<_1;
				end;
end;
	end;


*1-30 L/M Delinquency Refinance Loans;

	if loan_type = 'Refinance' then do;	

		if Balance_Group = "> 5000" then do;
			if current_int > 37.99 then do;
				if random_number <= 0.50 then ECT_Label_ID = '12M_24_7Y_NW'; *1-30_LM_REF_>_>_1;
				else ECT_LABEL_ID = '6M _29_7Y_NW'; *1-30_LM_REF_>_>_2;
					end;
			if current_int <= 37.99 then
				ECT_Label_ID = '12M_24_7Y_NW'; *1-30_LM_REF_>_<_1;
					end;
									

		if balance_group = "<= 5000" then do;
			if current_int > 37.99 then do;
				if random_number <= 0.50 then ECT_Label_ID = '12M_24_5Y_NW'; *1-30_LM_REF_<_>_1;
				else ECT_LABEL_ID = '6M _29_5Y_NW'; *1-30_LM_REF_<_>_2;
					end;
			if current_int <= 37.99 then
				ECT_Label_ID = '12M_24_5Y_NW'; *1-30_LM_REF_<_<_1;
					end;
end;
	end;

*1-30 High Delinquency Increase Loans;

if risk_segment = 'High' then do;

	if loan_type = 'Increase' then do;	

		if Balance_Group = "> 5000" then do;
			if current_int > 37.99 then do;
				if random_number <= 0.33 then ECT_Label_ID = '12M_24_7Y_PW'; *1-30_H_INC_>_>_1;
				if 0.33 < random_number <= 0.66 then ECT_Label_ID = '12M_29_7Y_PW'; *1-30_H_INC_>_>_2;
				if random_number > 0.66 then ECT_Label_ID = '12M_32_7Y_PW'; *1-30_H_INC_>_>_3;
					end;
			if current_int <= 37.99 then do;
				ECT_Label_ID = '12M_29_7Y_PW'; *1-30_H_INC_>_<_1;
					end;
						end;
						

		if balance_group = "<= 5000" then do;
			if current_int > 37.99 then do;
				if random_number <= 0.33 then ECT_Label_ID = '12M_24_5Y_NW'; *1-30_H_INC_<_>_1;
				if 0.33 < random_number <= 0.66 then ECT_Label_ID = '12M_29_5Y_NW'; *1-30_H_INC_<_>_2;
				if random_number > 0.66 then ECT_Label_ID = '12M_32_5Y_NW'; *1-30_H_INC_<_>_3;
					end;
			if current_int <= 37.99 then do;
				ECT_Label_ID = '12M_29_5Y_NW'; *1-30_H_INC_<_<_1;
					end;
end;
	end;
		
*1-30 High Delinquency New Loans;	

	if loan_type = 'New' then do;	

		if Balance_Group = "> 5000" then do;
			if current_int > 37.99 then do;
				if random_number <= 0.33 then ECT_Label_ID = '12M_24_7Y_PW'; *1-30_H_NEW_>_>_1;
				if 0.33 < random_number <= 0.66 then ECT_Label_ID = '12M_29_7Y_PW'; *1-30_H_NEW_>_>_2;
				if random_number > 0.66 then ECT_Label_ID = '12M_32_7Y_PW'; *1-30_H_NEW_>_>_3;
					end;
			if current_int <= 37.99 then do;
				ECT_Label_ID = '12M_24_7Y_PW'; *1-30_H_NEW_>_<_1;
					end;
						end;
						
		if balance_group = "<= 5000" then do;
			if current_int > 37.99 then do;
				if random_number <= 0.33 then ECT_Label_ID = '12M_24_5Y_NW'; *1-30_H_NEW_<_>_1;
				if 0.33 < random_number <= 0.66 then ECT_Label_ID = '12M_29_5Y_NW'; *1-30_H_NEW_<_>_2;
				if random_number > 0.66 then ECT_Label_ID = '12M_32_5Y_NW'; *1-30_H_NEW_<_>_3;
					end;
			if current_int <= 37.99 then do;
				ECT_Label_ID = '12M_24_5Y_NW'; *1-30_H_NEW_<_<_1;
					end;
end;
	end;
		
*1-30 High Delinquency Refinance Loans;


	if loan_type = 'Refinance' then do;	

		if Balance_Group = "> 5000" then do;
				if current_int > 37.99 then do;
					if random_number <= 0.50 then ECT_Label_ID = '12M_24_7Y_PW'; *1-30_H_REF_>_>_1;
					else ECT_LABEL_ID = '12M_29_7Y_PW'; *1-30_H_REF_>_>_2;
						end;
				if current_int <= 37.99 then
					ECT_Label_ID = '12M_24_7Y_PW'; *1-30_H_REF_>_<_1;
						end;
										
	
			if balance_group = "<= 5000" then do;
				if current_int > 37.99 then do;
					if random_number <= 0.50 then ECT_Label_ID = '12M_24_5Y_NW'; *1-30_H_REF_<_>_1;
					else ECT_LABEL_ID = '12M_29_5Y_NW'; *1-30_H_REF_<_>_2;
						end;
				if current_int <= 37.99 then
					ECT_Label_ID = '12M_24_5Y_NW'; *1-30_H_REF_<_<_1;
						end;
end;
	end;
	
			

run;

/* Test Output */

proc sql;

create table _1_30_offers as 
select a.*, b.ECT_Label
from _1_30_ECT_offers_assigned a 
left join ID_Table b

on a.ECT_Label_ID = b.ECT_Label_ID
;quit;

data _31plus_ECT_offers_assigned;
length ECT_Label_ID $50;
set _31plus nobs=nobs;


if current_int > 37.99 then interest_group = "> 37.99";
if current_int <= 37.99 then interest_group = "<=37.99";

if input(branch,32.) in (4529) then do;
	 ECT_Label_ID = '12M_29_5Y_PW'; *1+_POS;
end;

else if  input(branch,32.) not in (4529) then do;

*31+ DPD Delinquency Increase Loans;

	if loan_type = 'Increase' then do;	

		if Balance_Group = "> 5000" then do;
			if current_int > 37.99 then do;
				if random_number <= 0.33 then ECT_Label_ID = '12M_24_7Y_PW'; *31+_INC_>_>_1;
				if 0.33 < random_number <= 0.66 then ECT_Label_ID = '12M_29_7Y_PW'; *31+_INC_>_>_2;
				if random_number > 0.66 then ECT_Label_ID = '12M_32_7Y_PW'; *31+_INC_>_>_3;
					end;
			if current_int <= 37.99 then do;
				if random_number <= 0.50 then ECT_Label_ID = '12M_24_7Y_PW'; *31+_INC_>_<_1;
					else ECT_LABEL_ID = '12M_29_7Y_PW'; *31+_INC_>_<_2;
					end;
						end;

		if balance_group = "<= 5000" then do;
			if current_int > 37.99 then do;
					if random_number <= 0.33 then ECT_Label_ID = '12M_24_5Y_NW'; *31+_INC_<_>_1;
				if 0.33 < random_number <= 0.66 then ECT_Label_ID = '12M_29_5Y_NW'; *31+_INC_<_>_2;
				if random_number > 0.66 then ECT_Label_ID = '12M_32_5Y_NW'; *31+_INC_<_>_3;
					end;
			if current_int <= 37.99 then do;
				ECT_Label_ID = '12M_24_5Y_NW'; *31+_INC_<_<_1;
					end;
end;
	end;	
		

*31+ DPD Delinquency New Loans;

	if loan_type = 'New' then do;	

		if Balance_Group = "> 5000" then do;
			if current_int > 37.99 then do;
				if random_number <= 0.33 then ECT_Label_ID = '12M_24_7Y_PW';*31+_NEW_>_>_1;
				if 0.33 < random_number <= 0.66 then ECT_Label_ID = '12M_29_7Y_PW';*31+_NEW_>_>_2;
				if random_number > 0.66 then ECT_Label_ID = '12M_32_7Y_PW';*31+_NEW_>_>_3;
					end;
			if current_int <= 37.99 then do;
				if random_number <= 0.50 then ECT_Label_ID = '12M_24_7Y_PW';*31+_NEW_>_<_1;
					else ECT_LABEL_ID = '12M_29_7Y_PW';*31+_NEW_>_<_2;
					end;
						end;
						

		if balance_group = "<= 5000" then do;
			if current_int > 37.99 then do;
					if random_number <= 0.33 then ECT_Label_ID = '12M_24_5Y_NW'; *31+_NEW_<_>_1;
				if 0.33 < random_number <= 0.66 then ECT_Label_ID = '12M_29_5Y_NW'; *31+_NEW_<_>_2;
				if random_number > 0.66 then ECT_Label_ID = '12M_32_5Y_NW'; *31+_NEW_<_>_3;
					end;
			if current_int <= 37.99 then do;
					if random_number <= 0.50 then ECT_Label_ID = '12M_24_5Y_NW'; *31+_NEW_<_<_1;
					else ECT_LABEL_ID = '12M_29_5Y_NW'; *31+_NEW_<_<_2;
					end;
end;
	end;
		
*31+ DPD Delinquency Refinance Loans;

	if loan_type = 'Refinance' then do;	

		if Balance_Group = "> 5000" then do;
				if current_int > 37.99 then do;
					if random_number <= 0.50 then ECT_Label_ID = '12M_24_7Y_PW'; *31+_REF_>_>_1;
					else ECT_LABEL_ID = '12M_29_7Y_PW'; *31+_REF_>_>_2;
						end;
				if current_int <= 37.99 then
					ECT_Label_ID = '12M_24_7Y_PW'; *31+_REF_>_<_1;
						end;
										
	
			if balance_group = "<= 5000" then do;
				if current_int > 37.99 then do;
					if random_number <= 0.50 then ECT_Label_ID = '12M_24_5Y_NW'; *31+_REF_<_>_1;
					else ECT_LABEL_ID = '12M_29_5Y_NW'; *31+_REF_<_>_2;
						end;
				if current_int <= 37.99 then
					ECT_Label_ID = '12M_24_5Y_NW'; *31+_REF_<_<_1;
						end;
end;
	end;
	
			
run;

/* Test Output */

proc sql;

create table _31plus_offers as 
select a.*, b.ECT_Label
from _31plus_ECT_offers_assigned a 
left join ID_Table b

on a.ECT_Label_ID = b.ECT_Label_ID
;quit;
