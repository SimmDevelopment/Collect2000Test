SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Procedure [dbo].[AIM_Placement_ReRun_SelectTransactionsReadyForFile]


@agencyid int,
@batchid int
as
/* *************************************************************************
*  This proc gets all accounts to be placed 
*  and returns them in their own tables. (file ready)
*  Then marks the transaction table as being processed.
*
***********************************************************************/

	
	
	select
		number as file_number,
		account as account,
		current1 as principle,
		current2 as interest,
		current3 as other3,
		current4 as other4,
		current5 as other5,
		current6 as other6,
		current7 as other7,
		current8 as other8,
		current9 as other9,
		clidlc as last_charge,
		lastpaid as last_paid,
		userdate1 as userdate1,
		userdate2 as userdate2,
		userdate3 as userdate3,
		originalcreditor as original_creditor,   -- *** Column not found ***
		lastinterest as last_interest,
		interestrate as interestrate,
		custdivision as customer_division,
		custdistrict as customer_district,
		custbranch as customer_branch,
		id1,
		id2,
m.desk,
		customer,
		chargeoffdate,
		delinquencydate,
		isnull(lastpaidamt,0) as last_paid_amount,
		contractdate,
		clidlp,
		clialp,
		clialc
	from 
		AIM_batchfilehistory bfh join AIM_AccountTransaction act on bfh.batchfilehistoryid = act.batchfilehistoryid
		join AIM_AccountReference ar on ar.accountreferenceid = act.accountreferenceid
		join master m on m.number = ar.referenceNumber
	where
		bfh.batchid = @batchid and bfh.agencyid = @agencyid
	select 	
		number as file_number,
		account as account,  
		[name] as [name],
		street1 as street1,
		street2 as street2,
		city as city,
		state as state,
		zipcode as zipcode,
		homephone as home_phone,
		workphone as work_phone,
		ssn as ssn,
		mr as mail_return,
		othername as other_name,
		dob as date_of_birth,
		jobname as job_name,
		jobaddr1 as job_street1,
		jobaddr2 as job_street2,
		jobcsz as job_city_state_zipcode,
		spouse as spouse_name,
		spousejobname as spouse_job_name,
		spousejobaddr1 as spouse_job_street1,
		spousejobaddr2 as spouse_job_street2,
		spousejobcsz as spouse_job_city_state_zipcode,
		spousehomephone as spouse_home_phone,
		spouseworkphone as spouse_work_phone,
		debtorid as debtor_number  -- *** Column not found ***
	from 
		AIM_batchfilehistory bfh join AIM_AccountTransaction act on bfh.batchfilehistoryid = act.batchfilehistoryid
		join AIM_AccountReference ar on ar.accountreferenceid = act.accountreferenceid
		 join
		AIM_DebtorView dv
		on dv.Number = ar.referencenumber
	where
		bfh.batchid = @batchid and bfh.agencyid = @agencyid
	select 	
		number as file_number,
		account as account,  
		title as title,
		thedata as misc_data
	from 
		AIM_batchfilehistory bfh join AIM_AccountTransaction act on bfh.batchfilehistoryid = act.batchfilehistoryid
		join AIM_AccountReference ar on ar.accountreferenceid = act.accountreferenceid
		 join
		AIM_MiscView mv
		on ar.referenceNumber = mv.number
	where 
		bfh.batchid = @batchid and bfh.agencyid = @agencyid

GO
