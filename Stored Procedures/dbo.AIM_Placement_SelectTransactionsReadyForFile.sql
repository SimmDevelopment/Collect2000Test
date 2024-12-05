SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_Placement_SelectTransactionsReadyForFile]
(
	@agencyId INT,
	@transactionTypeID INT
)
AS
BEGIN 

/* *************************************************************************
*  This proc gets all accounts to be placed 
*  and returns them in their own tables. (file ready)
*  Then marks the transaction table as being processed.
*
****************************************************************************/
	declare @sqlbatchsize int
	select @sqlbatchsize = cast(cast(value as varchar) as int) from aim_appsetting where [key] = 'AIM.Database.SqlBatchTransactionSize'

	declare @sendequipment varchar(10)
	declare @sendmiscextra varchar(10)
	declare @sendnotes varchar(10)
	declare @sendbanko varchar(10)
	declare @senddeceased varchar(10)
	declare @sendpatientinfo varchar(10)
	declare @sendinsurance varchar(10)
	declare @sendassets varchar(10)
	declare @sendjudgments varchar(10)
	declare @agencyVersion varchar(10)
	declare @SendAuto varchar(10)
	declare @SendComplaint varchar(10)
	declare @SendDispute varchar(10)

	select @sendequipment = value from aim_appsetting where [key] = 'AIM.Placements.SendEquipment'
	select @sendpatientinfo = value from aim_appsetting where [key] = 'AIM.Placements.SendPatientInfo'
	select @sendinsurance =	value from aim_appsetting where [key] = 'AIM.Placements.SendInsurance'
	select @sendmiscextra = value from aim_appsetting where [key] = 'AIM.Placements.SendMiscExtra'
	select @sendnotes = value from aim_appsetting where [key] = 'AIM.Placements.SendNotes'
	select @sendbanko = value from aim_appsetting where [key] = 'AIM.Placements.SendBanko'
	select @senddeceased = value from aim_appsetting where [key] = 'AIM.Placements.SendDeceased'
	select @sendassets = value from aim_appsetting where [key] = 'AIM.Placements.SendAssets'
	select @sendjudgments = value from aim_appsetting where [key] = 'AIM.Placements.SendJudgments'
	select @agencyVersion = ISNULL(RTRIM(LTRIM(agencyversion)),'8.3.0') FROM AIM_Agency WITH (NOLOCK) WHERE agencyId = @agencyId
	select @SendAuto = ISNULL([value],'False') from aim_appsetting where [key] = 'AIM.Placements.SendAuto'
	select @SendComplaint = ISNULL([value],'False') from aim_appsetting where [key] = 'AIM.Placements.SendComplaint'
	select @SendDispute = ISNULL([value],'False') from aim_appsetting where [key] = 'AIM.Placements.SendDispute'

	create table #placeaccounts (referenceNumber int primary key, accountreferenceid int)
	declare @executeSQL varchar(1000)
	set @executeSQL =
	'insert into #placeaccounts
	select	top ' + cast(@sqlbatchsize as VARCHAR(16)) + ' referenceNumber
		,max(ar.accountreferenceid)
	from	AIM_accountreference ar with (nolock)
		join AIM_accounttransaction atr with (nolock) on atr.accountreferenceid = ar.accountreferenceid
	where	atr.agencyid = ' + CAST(@agencyId as VARCHAR(8)) + ' 
		and transactiontypeid = 1 
		and transactionstatustypeid = 1
	group by referencenumber'
	
	exec(@executeSQL)

	select	
		'CACT' as record_type
		,number as file_number,
		account as account,
		cast(current1 as decimal(10,2)) as principle,
		cast(current2 as decimal(10,2)) as interest,
		cast(current3 as decimal(10,2)) as other3,
		cast(current4 as decimal(10,2)) as other4,
		cast(current5 as decimal(10,2)) as other5,
		cast(current6 as decimal(10,2)) as other6,
		cast(current7 as decimal(10,2)) as other7,
		cast(current8 as decimal(10,2)) as other8,
		cast(current9 as decimal(10,2)) as other9,
		REPLACE(CONVERT(VARCHAR(10), clidlc, 102),'.','-')+' 00:00:00.000' as last_charge,  
		REPLACE(CONVERT(VARCHAR(10), lastpaid, 102),'.','-')+' 00:00:00.000' as last_paid,  
		REPLACE(CONVERT(VARCHAR(10), userdate1, 102),'.','-')+' 00:00:00.000' as userdate1,  
		REPLACE(CONVERT(VARCHAR(10), userdate2, 102),'.','-')+' 00:00:00.000' as userdate2,  
		REPLACE(CONVERT(VARCHAR(10), userdate3, 102),'.','-')+' 00:00:00.000' as userdate3,  
		
		originalcreditor as original_creditor,   -- *** Column not found ***
		REPLACE(CONVERT(VARCHAR(10), lastinterest, 102),'.','-')+' 00:00:00.000' as last_interest,
		isnull(interestrate,0) as interestrate,
		custdivision as customer_division,
		custdistrict as customer_district,
		custbranch as customer_branch,
		id1,
		id2,
		desk,
		c.customer,
		REPLACE(CONVERT(VARCHAR(10), chargeoffdate, 102),'.','-')+' 00:00:00.000' as chargeoffdate,  
	    REPLACE(CONVERT(VARCHAR(10), delinquencydate, 102),'.','-')+' 00:00:00.000' as delinquencydate,  
	    isnull(lastpaidamt,0) as last_paid_amount,  
	    REPLACE(CONVERT(VARCHAR(10), m.contractdate, 102),'.','-')+' 00:00:00.000' as contractdate,  
	    REPLACE(CONVERT(VARCHAR(10), clidlp, 102),'.','-')+' 00:00:00.000' as clidlp,  
	    REPLACE(CONVERT(VARCHAR(10), clidlc, 102),'.','-')+' 00:00:00.000' as clidlc,  
		isnull(clialp,0) as clialp,
		isnull(clialc,0) as clialc,
		previouscreditor as previous_creditor,
		ISNULL(REPLACE(CONVERT(VARCHAR(10), p.ContractDate, 102),'.','-')+' 00:00:00.000', REPLACE(CONVERT(VARCHAR(10), Received, 102),'.','-')+' 00:00:00.000') AS purchaseddate,  
		c.AlphaCode as customer_alphacode,
		c.Company as customer_company,
		c.Name as customer_name,
		ig.Name as AIM_InvestorGroupName,
		sg.Name as AIM_SellerGroupName,
		IB.ItemizationDate as ItemizationDate,
		IB.ItemizationDateType as ItemizationDateType,
		IB.ItemizationBalance0 as ItemizationBalance,
		IB.ItemizationBalance1 as ItemizationPrincipal,
		IB.ItemizationBalance2 as ItemizationInterest,
		IB.ItemizationBalance3 as ItemizationFeesCharges,
		IB.ItemizationBalance4 as ItemizationPaymentsCredits,
		IB.ItemizationBalance5 as ItemizationOther,
		'' as [Filler]


		
	from 	master m with (nolock)
		join #placeaccounts a on a.referenceNumber = m.number
		join customer c with (nolock) on c.customer = m.customer
		OUTER APPLY (SELECT TOP 1 * FROM [dbo].[ItemizationBalance] WITH (NOLOCK) WHERE AccountID = m.number ORDER BY ItemizationID DESC) AS IB
		left outer join AIM_Portfolio p WITH (NOLOCK) ON p.portfolioid = m.purchasedportfolio
		left outer join  AIM_Group ig WITH (NOLOCK) ON p.InvestorGroupID = ig.GroupID
		left outer join  AIM_Group sg WITH (NOLOCK) ON p.SellerGroupID = sg.GroupID
	order by m.number

	select 
		'CD0' + cast(dv.seq as varchar(1)) as record_type
		,dv.number as file_number,
		m.account as account,  
		dv.[name] as [name],
		dv.street1 as street1,
		dv.street2 as street2,
		dv.city as city,
		dv.state as state,
		rtrim(ltrim(replace(replace(dv.zipcode,'-',''),' ',''))) as zipcode,
		dv.homephone as home_phone,
		dv.workphone as work_phone,
		rtrim(ltrim(replace(replace(dv.ssn,'-',''),' ',''))) as ssn,
		dv.mr as mail_return,
		dv.othername as other_name,
		REPLACE(CONVERT(VARCHAR(10), dv.dob, 102),'.','-')+' 00:00:00.000' as date_of_birth,
		dv.jobname as job_name,
		dv.jobaddr1 as job_street1,
		dv.jobaddr2 as job_street2,
		dv.jobcsz as job_city_state_zipcode,
		dv.spouse as spouse_name,
		dv.spousejobname as spouse_job_name,
		spousejobaddr1 as spouse_job_street1,
		spousejobaddr2 as spouse_job_street2,
		spousejobcsz as spouse_job_city_state_zipcode,
		spousehomephone as spouse_home_phone,
		spouseworkphone as spouse_work_phone,
		dv.debtorid as debtor_number,  -- *** Column not found ***,
		dv.county as county,
		dv.country as country,
		da.Name as attorney_name,
		da.Firm as attorney_firm,
		da.Addr1 as attorney_street1,
		da.Addr2 as attorney_street2,
		da.City as attorney_city,
		da.State as attorney_state,
		da.Zipcode as attorney_zipcode,
		da.Phone as attorney_phone,
		da.Fax as attorney_fax,
		da.Comments as attorney_notes,
		'' as [Filler]
	from 	debtors dv with (nolock)
		join #placeaccounts a on a.referenceNumber = dv.number
		join master m with (nolock) on m.number = a.referencenumber
		left outer join debtorattorneys da WITH (NOLOCK) ON dv.debtorid = da.debtorid
	order by m.number,dv.seq ASC

	IF(@agencyVersion = '10.8.0') BEGIN
/*Exporting Phone & Consent related data*/
		select --top 0
		'CUPP' as record_type,
		pm.debtorid as debtor_number,
		pm.number as file_number,
		Relationship as relationship,
		PhoneTypeID as phone_type_id,
		PhoneStatusID as phone_status_id,
		cast(isnull([OnHold],0) as varchar(1)) as on_hold,
		PhoneNumber as phone_number,
		PhoneExt as phone_ext,
		PhoneName as phone_name,
		CASE WHEN s.ManifestID IS NOT NULL THEN s.Description WHEN u.LoginName IS NOT NULL THEN 'User' ELSE pm.LoginName
		END as source,
		CASE WHEN pc.AllowManualCall = 1 THEN 'Y' ELSE 'N' END AS AllowManualCalling, 
		   CASE WHEN pc.AllowAutoDialer = 1 THEN 'Y' ELSE 'N' END AS AllowAutoDialer,
		   CASE WHEN pc.AllowFax = 1 THEN 'Y' ELSE 'N' END AS AllowFax,
		   CASE WHEN pc.AllowText = 1 THEN 'Y' ELSE 'N' END AS AllowText,
		   CAST(pc.WrittenConsent AS VARCHAR(1)) AS WrittenConsent,
		   CAST(pc.ObtainedFrom AS nvarchar(100)) AS ObtainedFrom, 
		   pc.EffectiveDate AS EffectiveDate, 
		   CAST(pc.comment AS nvarchar(120)) AS Comment,
		CASE WHEN [MondayDoNotCall] = 1 THEN 'Y' ELSE 'N' END as [MondayNeverCall],
		[MondayCallWindowStart],
		[MondayCallWindowEnd],
		[MondayNoCallWindowStart],
		[MondayNoCallWindowEnd],
		CASE WHEN [TuesdayDoNotCall] = 1 THEN 'Y' ELSE 'N' END as [TuesdayNeverCall],
		[TuesdayCallWindowStart],
		[TuesdayCallWindowEnd],
		[TuesdayNoCallWindowStart],
		[TuesdayNoCallWindowEnd],
		CASE WHEN [WednesdayDoNotCall] = 1 THEN 'Y' ELSE 'N' END as [WednesdayNeverCall],
		[WednesdayCallWindowStart],
		[WednesdayCallWindowEnd],
		[WednesdayNoCallWindowStart],
		[WednesdayNoCallWindowEnd],
		CASE WHEN [ThursdayDoNotCall] = 1 THEN 'Y' ELSE 'N' END  as [ThursdayNeverCall],
		[ThursdayCallWindowStart],
		[ThursdayCallWindowEnd],
		[ThursdayNoCallWindowStart],
		[ThursdayNoCallWindowEnd],
		CASE WHEN [FridayDoNotCall] = 1 THEN 'Y' ELSE 'N' END  as [FridayNeverCall],
		[FridayCallWindowStart],
		[FridayCallWindowEnd],
		[FridayNoCallWindowStart],
		[FridayNoCallWindowEnd],
		CASE WHEN [SaturdayDoNotCall] = 1 THEN 'Y' ELSE 'N' END  as [SaturdayNeverCall],
		[SaturdayCallWindowStart],
		[SaturdayCallWindowEnd],
		[SaturdayNoCallWindowStart],
		[SaturdayNoCallWindowEnd], 
		CASE WHEN [SundayDoNotCall] = 1 THEN 'Y' ELSE 'N' END  as [SundayNeverCall],
		[SundayCallWindowStart],  
		[SundayCallWindowEnd],  
		[SundayNoCallWindowStart],  
		[SundayNoCallWindowEnd],
		'' as [Filler]
		from #placeaccounts a INNER JOIN phones_master pm with (nolock) on a.referencenumber = pm.number
		OUTER APPLY
		(SELECT TOP 1 * FROM Phones_Consent pc WITH (NOLOCK) WHERE pc.MasterPhoneId = pm.MasterPhoneID ORDER BY PhonesConsentId DESC) AS pc
		LEFT OUTER JOIN dbo.Phones_Preferences AS PP WITH (NOLOCK) ON PP.MasterPhoneId=pm.MasterPhoneID
		LEFT OUTER JOIN ServiceHistory sh WITH (NOLOCK) ON sh.RequestID = pm.RequestID
		LEFT OUTER JOIN Services s WITH (NOLOCK) ON sh.serviceid = s.serviceid
		LEFT OUTER JOIN Users u WITH (NOLOCK) ON pm.LoginName = u.LoginName

		/*Exporting Email & Consent related data*/
		select
		'CEML' as record_type,
		d.number as File_number,
		d.debtorid as debtor_number,
		CASE 
		 WHEN d.ContactMethod='Letter' THEN '1'
		 WHEN d.ContactMethod='Phone' THEN '2'
		 WHEN d.ContactMethod='Email' THEN '3'
		 WHEN d.ContactMethod='SMS' THEN '4'
		  ELSE NULL END AS PreferredMethod,
		E.[Email] as EmailAddress,
		TypeCd as EmailType,
		CASE WHEN E.ConsentGiven = 1 THEN 'Y' ELSE 'N' END AS ConsentToEmail, 
		CAST(E.WrittenConsent AS VARCHAR(1)) AS Method,
		ConsentSource as ObtainedFrom,
		ModifiedWhen as EffectiveDate,
		E.comment as Comment,
		CASE WHEN E.TypeCd = 'Work' THEN 'Y' ELSE 'N' END AS WorkEmail,
		'' as Filler
		FROM dbo.Email AS E WITH (NOLOCK)
		INNER JOIN  dbo.Debtors as D WITH (NOLOCK) ON E.DebtorId=D.DebtorID
		INNER JOIN #placeaccounts a ON a.referencenumber=D.Number
		
		/*Payment transaction data*/
		SELECT 'CHST' as record_type,
		number as file_number,
		datepaid AS [Date],
		totalpaid AS [Amount],
		CASE WHEN batchtype IN ('PU', 'PC', 'DA', 'PA') THEN 'D' 
		WHEN 
		batchtype IN ('PUR', 'PCR', 'DAR', 'PAR') THEN 
		'C' ELSE '' END AS [Type],
		[UID] AS [Reference],
		[Comment],
		'' AS Filler
		FROM payhistory AS PH with (NOLOCK)
		INNER JOIN #placeaccounts A ON A.referencenumber=PH.number
		UNION
		SELECT 'CHST' as record_type
			  ,[FileNumber] as file_number
			  ,[TransactionDate] as [Date]
			  ,[AmountOfTransaction] as [Amount]
			  ,[TransactionType] as [Type]
			  ,[TransactionReference] as [Reference]
			  ,[TransactionComment] as [Comment]
			  ,'' AS Filler
		FROM [dbo].[HistoricalTransactions] AS HT
		INNER JOIN #placeaccounts A ON A.referencenumber=HT.FileNumber
	END
	ELSE BEGIN
		select
		'CUPP' as record_type,
		pm.debtorid as debtor_number,
		pm.number as file_number,
		Relationship as relationship,
		PhoneTypeID as phone_type_id,
		PhoneStatusID as phone_status_id,
		cast(isnull([OnHold],0) as varchar(1)) as on_hold,
		PhoneNumber as phone_number,
		PhoneExt as phone_ext,
		PhoneName as phone_name,
		CASE WHEN s.ManifestID IS NOT NULL THEN s.Description WHEN u.LoginName IS NOT NULL THEN 'User' ELSE pm.LoginName
		END as source,
		'' as [Filler]
		from #placeaccounts a join phones_master pm with (nolock) on a.referencenumber = pm.number
		LEFT OUTER JOIN ServiceHistory sh WITH (NOLOCK) ON sh.RequestID = pm.RequestID
		LEFT OUTER JOIN Services s WITH (NOLOCK) ON sh.serviceid = s.serviceid
		LEFT OUTER JOIN Users u WITH (NOLOCK) ON pm.LoginName = u.LoginName
	END

if(@sendmiscextra = 'True')
begin
 	select 
		'CMIS' as record_type
		,mv.number as file_number,
 		account as account,  
 		title as title,
 		thedata as misc_data,
		'' as [Filler]
 	from 
 		miscextra mv with (nolock)
 		join master m with (nolock) on m.number = mv.number
 		join #placeaccounts a on a.referenceNumber = mv.number
end
else
begin

 	select top 0
		'CMIS' as record_type
		,mv.number as file_number,
 		account as account,  
 		title as title,
 		thedata as misc_data,
		'' as [Filler]
 	from 
 		miscextra mv with (nolock)
 		join master m with (nolock) on m.number = mv.number
 		join #placeaccounts a on a.referenceNumber = mv.number
end

if(@sendnotes = 'True')
begin
	select 
		'CNOT' as record_type
		,n.number as file_number,
		created as note_created_datetime,
		action as note_action,
		result as note_result,
		--comment as note_comment,
		[dbo].[fnRemoveUnwantedCharsFromNoteComment](n.uid) as note_comment,
		'' as [Filler]
	from 
		notes n with (nolock)
		join master m with (nolock) on m.number = n.number
		join #placeaccounts a on a.referencenumber = n.number
end
else
begin
	select top 0
		'CNOT' as record_type
		,n.number as file_number,
		created as note_created_datetime,
		action as note_action,
		result as note_result,
		--comment as note_comment,
		[dbo].[fnRemoveUnwantedCharsFromNoteComment](n.uid) as note_comment,
		'' as [Filler]
	from 
		notes n with (nolock)
		join master m with (nolock) on m.number = n.number
		join #placeaccounts a on a.referencenumber = n.number
end




if(@senddeceased = 'True')
begin
SELECT
	'CDEC' as record_type,
	d.debtorid as debtor_number,
	d.accountid as file_number,
	d.ssn as ssn,
	d.firstname as first_name,
	d.lastname  as last_name,
	d.state as state,
	rtrim(ltrim(replace(replace(d.postalcode,'-',''),' ',''))) as postal_code,
	REPLACE(CONVERT(VARCHAR(10), d.dob, 102),'.','-')+' 00:00:00.000' as date_of_birth,
	d.dod as date_of_death,
	d.matchcode as match_code,
	d.transmitteddate as transmit_date,
    [ClaimDeadline] as claim_deadline_date,
    [DateFiled]   AS  filed_date,
      [CaseNumber] AS		 case_number,
      [Executor] AS		 executor,
      [ExecutorPhone] AS	 executor_phone,
      [ExecutorFax] AS		 executor_fax,
      [ExecutorStreet1] AS	 executor_street1,
      [ExecutorStreet2] AS	 executor_street2,
      [ExecutorState] AS	 executor_state,
      [ExecutorCity] AS	 executor_city,
      [ExecutorZipcode] AS	 executor_zipcode,
      [CourtCity] AS		 court_city,
      [CourtDistrict] AS	 court_district,
      [CourtDivision] AS	 court_division,
      [CourtPhone] AS		 court_phone,
      [CourtStreet1] AS	 court_street1,
      [CourtStreet2] AS	 court_street2,
      [CourtState] AS		 court_state,
      [CourtZipcode] AS	 court_zipcode,  
		'' as [Filler]
FROM
	deceased d  with (nolock)
	join #placeaccounts a on a.referencenumber = d.accountid
	

end
else
begin
SELECT top 0
	'CDEC' as record_type,
	d.debtorid as debtor_number,
	d.accountid as file_number,
	d.ssn as ssn,
	d.firstname as first_name,
	d.lastname  as last_name,
	d.state as state,
	rtrim(ltrim(replace(replace(d.postalcode,'-',''),' ',''))) as postal_code,
	REPLACE(CONVERT(VARCHAR(10), d.dob, 102),'.','-')+' 00:00:00.000' as date_of_birth,
	d.dod as date_of_death,
	d.matchcode as match_code,
	d.transmitteddate as transmit_date,
    [ClaimDeadline] as claim_deadline_date,
    [DateFiled]   AS  filed_date,
      [CaseNumber] AS		 case_number,
      [Executor] AS		 executor,
      [ExecutorPhone] AS	 executor_phone,
      [ExecutorFax] AS		 executor_fax,
      [ExecutorStreet1] AS	 executor_street1,
      [ExecutorStreet2] AS	 executor_street2,
      [ExecutorState] AS	 executor_state,
      [ExecutorCity] AS	 executor_city,
      [ExecutorZipcode] AS	 executor_zipcode,
      [CourtCity] AS		 court_city,
      [CourtDistrict] AS	 court_district,
      [CourtDivision] AS	 court_division,
      [CourtPhone] AS		 court_phone,
      [CourtStreet1] AS	 court_street1,
      [CourtStreet2] AS	 court_street2,
      [CourtState] AS		 court_state,
      [CourtZipcode] AS	 court_zipcode,  
		'' as [Filler]
FROM
	deceased d  with (nolock)
	join #placeaccounts a on a.referencenumber = d.accountid
	

end



if(@sendbanko = 'True')
begin
SELECT
	'CBKP' as record_type,
	b.debtorid as debtor_number,
	b.accountid as file_number,
	b.chapter as chapter,
	b.datefiled as date_filed,
	b.casenumber as case_number,
	b.courtcity as court_city,
	b.courtdistrict as court_district,
	b.courtdivision as court_division,
	b.courtphone as court_phone,
	b.courtstreet1 as court_street1,
	b.courtstreet2 as court_street2,
	b.courtstate as court_state,
	b.courtzipcode as court_zipcode,
	b.trustee as trustee,
	b.trusteestreet1 as trustee_street1,
	b.trusteestreet2 as trustee_street2,
	b.trusteecity as trustee_city,
	b.trusteestate as trustee_state,
	b.trusteezipcode as trustee_zipcode,
	b.trusteephone as trustee_phone,
	cast(CASE WHEN b.has341info = 1 THEN '1' ELSE '0' END as varchar(1)) as three_forty_one_info_flag,
	b.datetime341 as three_forty_one_date,
	b.location341 as three_forty_one_location,
	b.comments as comments,
	b.status as status,
	b.transmitteddate as transmit_date,
	[DateNotice] AS notice_date,
    [ProofFiled] AS proof_filed_date,
    [DischargeDate] AS discharge_date,
    [DismissalDate] AS dismissal_date,
    [ConfirmationHearingDate] AS confirmation_hearing_date,
	[ReaffirmDateFiled] AS reaffirm_filed_date,
	[VoluntaryDate] AS voluntary_date,
	[SurrenderDate] AS surrender_date,
	[AuctionDate] AS auction_date,
	[ReaffirmAmount] AS reaffirm_amount,
	[VoluntaryAmount] AS voluntary_amount,
	AuctionAmount AS auction_amount,
	AuctionFee AS auction_fee_amount,
	AuctionAmountApplied AS auction_applied_amount,
	SecuredAmount AS secured_amount,
	SecuredPercentage AS secured_percentage,
	UnsecuredAmount AS unsecured_amount,
	UnsecuredPercentage AS unsecured_percentage,
	ConvertedFrom AS converted_from_chapter,
	CASE HasAsset WHEN 0 THEN 'F' ELSE 'T' END AS has_asset,
	Reaffirm AS reaffirm_flag,
	[ReaffirmTerms] AS reaffirm_terms,
	VoluntaryTerms AS voluntary_terms,
	[SurrenderMethod] AS surrender_method,
	AuctionHouse AS auction_house,
	'' as [Filler]
		

FROM
	bankruptcy b with (nolock) 
	join #placeaccounts a on a.referencenumber = b.accountid


end
else
begin
SELECT top 0
	'CBKP' as record_type,
	b.debtorid as debtor_number,
	b.accountid as file_number,
	b.chapter as chapter,
	b.datefiled as date_filed,
	b.casenumber as case_number,
	b.courtcity as court_city,
	b.courtdistrict as court_district,
	b.courtdivision as court_division,
	b.courtphone as court_phone,
	b.courtstreet1 as court_street1,
	b.courtstreet2 as court_street2,
	b.courtstate as court_state,
	b.courtzipcode as court_zipcode,
	b.trustee as trustee,
	b.trusteestreet1 as trustee_street1,
	b.trusteestreet2 as trustee_street2,
	b.trusteecity as trustee_city,
	b.trusteestate as trustee_state,
	b.trusteezipcode as trustee_zipcode,
	b.trusteephone as trustee_phone,
	cast(CASE WHEN b.has341info = 1 THEN '1' ELSE '0' END as varchar(1)) as three_forty_one_info_flag,
	b.datetime341 as three_forty_one_date,
	b.location341 as three_forty_one_location,
	b.comments as comments,
	b.status as status,
	b.transmitteddate as transmit_date,
	[DateNotice] AS notice_date,
    [ProofFiled] AS proof_filed_date,
    [DischargeDate] AS discharge_date,
    [DismissalDate] AS dismissal_date,
    [ConfirmationHearingDate] AS confirmation_hearing_date,
	[ReaffirmDateFiled] AS reaffirm_filed_date,
	[VoluntaryDate] AS voluntary_date,
	[SurrenderDate] AS surrender_date,
	[AuctionDate] AS auction_date,
	[ReaffirmAmount] AS reaffirm_amount,
	[VoluntaryAmount] AS voluntary_amount,
	AuctionAmount AS auction_amount,
	AuctionFee AS auction_fee_amount,
	AuctionAmountApplied AS auction_applied_amount,
	SecuredAmount AS secured_amount,
	SecuredPercentage AS secured_percentage,
	UnsecuredAmount AS unsecured_amount,
	UnsecuredPercentage AS unsecured_percentage,
	ConvertedFrom AS converted_from_chapter,
	CASE HasAsset WHEN 0 THEN 'F' ELSE 'T' END AS has_asset,
	Reaffirm AS reaffirm_flag,
	[ReaffirmTerms] AS reaffirm_terms,
	VoluntaryTerms AS voluntary_terms,
	[SurrenderMethod] AS surrender_method,
	AuctionHouse AS auction_house,
	'' as [Filler]
FROM
	bankruptcy b with (nolock) 
	join #placeaccounts a on a.referencenumber = b.accountid

end

if(@sendpatientinfo = 'True')
begin
SELECT
		'CPAT' as record_type
	   ,p.[AccountID] as file_number
      ,p.[Name]
      ,p.[Street1]
      ,p.[Street2]
      ,p.[City]
      ,p.[State]
      ,rtrim(ltrim(replace(replace(p.[ZipCode],'-',''),' ',''))) as ZipCode
      ,p.[Country]
      ,p.[Phone]
      ,rtrim(ltrim(replace(replace(p.SSN,'-',''),' ',''))) as SSN
      ,p.[Sex]
      ,isnull(p.[Age],0) as Age
      ,REPLACE(CONVERT(VARCHAR(10), p.dob, 102),'.','-')+' 00:00:00.000' as [DOB]
      ,p.[MaritalStatus]
      ,p.[EmployerName]
      ,p.[WorkPhone]
      ,p.[PatientRecNumber]
      ,p.[GuarantorRecNumber]
      ,p.AdmissionDate as [AdmissionDate]
      ,p.ServiceDate as [ServiceDate]
      ,p.DischargeDate as [DischargeDate]
      ,p.[FacilityName]
      ,p.[FacilityStreet1]
      ,p.[FacilityStreet2]
      ,p.[FacilityCity]
      ,p.[FacilityState]
      ,rtrim(ltrim(replace(replace(p.[FacilityZipCode],'-',''),' ',''))) as [FacilityZipCode]
      ,p.[FacilityCountry]
      ,p.[FacilityPhone]
      ,p.[FacilityFax]
      ,p.[DoctorName]
      ,p.[DoctorPhone]
      ,p.[DoctorFax]
      ,p.[KinName]
      ,p.[KinStreet1]
      ,p.[KinStreet2]
      ,p.[KinCity]
      ,p.[KinState]
      ,rtrim(ltrim(replace(replace(p.[KinZipCode],'-',''),' ',''))) as [KinZipCode]
      ,p.[KinCountry]
      ,p.[KinPhone],
		'' as [Filler]
      
  FROM [PatientInfo] p WITH (NOLOCK)
	JOIN #placeaccounts a on a.referencenumber = p.AccountID

end
else
begin
SELECT top 0
		'CPAT' as record_type
	   ,p.[AccountID] as file_number
      ,p.[Name]
      ,p.[Street1]
      ,p.[Street2]
      ,p.[City]
      ,p.[State]
      ,rtrim(ltrim(replace(replace(p.[ZipCode],'-',''),' ',''))) as ZipCode
      ,p.[Country]
      ,p.[Phone]
      ,rtrim(ltrim(replace(replace(p.SSN,'-',''),' ',''))) as SSN
      ,p.[Sex]
      ,isnull(p.[Age],0) as Age
      ,REPLACE(CONVERT(VARCHAR(10), p.dob, 102),'.','-')+' 00:00:00.000' as [DOB]
      ,p.[MaritalStatus]
      ,p.[EmployerName]
      ,p.[WorkPhone]
      ,p.[PatientRecNumber]
      ,p.[GuarantorRecNumber]
      ,p.AdmissionDate as [AdmissionDate]
      ,p.ServiceDate as [ServiceDate]
      ,p.DischargeDate as [DischargeDate]
      ,p.[FacilityName]
      ,p.[FacilityStreet1]
      ,p.[FacilityStreet2]
      ,p.[FacilityCity]
      ,p.[FacilityState]
      ,rtrim(ltrim(replace(replace(p.[FacilityZipCode],'-',''),' ',''))) as [FacilityZipCode]
      ,p.[FacilityCountry]
      ,p.[FacilityPhone]
      ,p.[FacilityFax]
      ,p.[DoctorName]
      ,p.[DoctorPhone]
      ,p.[DoctorFax]
      ,p.[KinName]
      ,p.[KinStreet1]
      ,p.[KinStreet2]
      ,p.[KinCity]
      ,p.[KinState]
      ,rtrim(ltrim(replace(replace(p.[KinZipCode],'-',''),' ',''))) as [KinZipCode]
      ,p.[KinCountry]
      ,p.[KinPhone],
		'' as [Filler]
		
      
  FROM [PatientInfo] p WITH (NOLOCK)
	JOIN #placeaccounts a on a.referencenumber = p.AccountID
end


if(@sendinsurance = 'True')
begin
SELECT 
		'CINS' as record_type
		,[Number] as file_number
	  ,[InsuranceId] as insurance_id
      ,[InsuredName]
      ,[InsuredStreet1]
      ,[InsuredStreet2]
      ,[InsuredCity]
      ,[InsuredState]
      ,rtrim(ltrim(replace(replace([InsuredZip],'-',''),' ',''))) as [InsuredZip]
      ,[InsuredPhone]
      ,[InsuredBirthday] as [InsuredBirthday]
      ,[InsuredSex]
      ,[InsuredEmployer]
      ,cast([AuthPmtToProvidor] as varchar(1)) as AuthPmtToProvidor
      ,cast([AcceptAssignment] as varchar(1)) as AcceptAssignment
      ,[EmployerHealthPlan]
      ,[PolicyNumber]
      ,[PatientRelationToInsured]
      ,[Program]
      ,[GroupNumber]
      ,[GroupName]
      ,[CarrierName]
      ,[CarrierStreet1]
      ,[CarrierStreet2]
      ,[CarrierCity]
      ,[CarrierState]
      ,rtrim(ltrim(replace(replace([CarrierZip],'-',''),' ',''))) as [CarrierZip]
      ,[CarrierDocProviderNumber]
      ,[CarrierRefDocProviderNumber],
		'' as [Filler]
      
      
  FROM [Insurance] i WITH (NOLOCK)
		join #placeaccounts a on a.referencenumber = i.number

end
else
begin
SELECT top 0
		'CINS' as record_type
		,[Number] as file_number
	  ,[InsuranceId] as insurance_id
      ,[InsuredName]
      ,[InsuredStreet1]
      ,[InsuredStreet2]
      ,[InsuredCity]
      ,[InsuredState]
      ,rtrim(ltrim(replace(replace([InsuredZip],'-',''),' ',''))) as [InsuredZip]
      ,[InsuredPhone]
      ,[InsuredBirthday] as [InsuredBirthday]
      ,[InsuredSex]
      ,[InsuredEmployer]
      ,cast([AuthPmtToProvidor] as varchar(1)) as AuthPmtToProvidor
      ,cast([AcceptAssignment] as varchar(1)) as AcceptAssignment
      ,[EmployerHealthPlan]
      ,[PolicyNumber]
      ,[PatientRelationToInsured]
      ,[Program]
      ,[GroupNumber]
      ,[GroupName]
      ,[CarrierName]
      ,[CarrierStreet1]
      ,[CarrierStreet2]
      ,[CarrierCity]
      ,[CarrierState]
      ,rtrim(ltrim(replace(replace([CarrierZip],'-',''),' ',''))) as [CarrierZip]
      ,[CarrierDocProviderNumber]
      ,[CarrierRefDocProviderNumber],
		'' as [Filler]
            
      
  FROM [Insurance] i WITH (NOLOCK)
		join #placeaccounts a on a.referencenumber = i.number

end

if(@sendequipment = 'True')
begin
SELECT 
      'CEQP' as record_type
	  ,e.[Number] as file_number
      ,[Act#]
      ,[Collat_desc]
      ,[Lic#]
      ,[Vin#]
      ,[Yr]
      ,[Mk]
      ,[Mdl]
      ,[Ser]
      ,[Color]
      ,[Key_CD]
      ,[Cond]
      ,[Loc]
      ,[tag#]
      ,[Dlr#]
      ,[PLN_CD]
      ,[Repo_DT]
      ,[DSP_DT]
      ,[Ins]
      ,[Prd_Cmplt#]
      ,cast(isnull(e.Val,0.00) as decimal(10,2)) as Val
      ,[UCC_CD]
      ,[Fil_DT]
      ,[Fil_Loc]
      ,[X_COll]
      ,[LN#]
      ,[Rec_Mthd_CD]
      ,[Reas_CD]
      ,[Typ_CO_CD]
      ,[DSP_CD]
      ,[DSP_ANAL]
      ,CASE isnull([Recovered],0) WHEN 0 THEN 'F' WHEN 1 THEN 'T' ELSE 'F' END as [Recovered]
      ,[RecoveredDate] as [RecoveredDate]
       ,CASE isnull([Commissionable],0) WHEN 0 THEN 'F' WHEN 1 THEN 'T' ELSE 'F' END as [Commissionable]
      ,[WhenLoaded] as [WhenLoaded]
      ,[UID] as equipment_id
      ,'' as Filler
	  
  FROM [PBEquipment] e WITH (NOLOCK)
		join #placeaccounts a on a.referencenumber = e.number
  WHERE isnull([Recovered],0) = 0
  order by e.number

end
else
begin
SELECT top 0
      'CEQP' as record_type
	  ,e.[Number] as file_number
      ,[Act#]
      ,[Collat_desc]
      ,[Lic#]
      ,[Vin#]
      ,[Yr]
      ,[Mk]
      ,[Mdl]
      ,[Ser]
      ,[Color]
      ,[Key_CD]
      ,[Cond]
      ,[Loc]
      ,[tag#]
      ,[Dlr#]
      ,[PLN_CD]
      ,[Repo_DT]
      ,[DSP_DT]
      ,[Ins]
      ,[Prd_Cmplt#]
      ,cast(isnull(e.Val,0.00) as decimal(10,2)) as Val
      ,[UCC_CD]
      ,[Fil_DT]
      ,[Fil_Loc]
      ,[X_COll]
      ,[LN#]
      ,[Rec_Mthd_CD]
      ,[Reas_CD]
      ,[Typ_CO_CD]
      ,[DSP_CD]
      ,[DSP_ANAL]
      ,CASE isnull([Recovered],0) WHEN 0 THEN 'F' WHEN 1 THEN 'T' ELSE 'F' END as [Recovered]
      ,[RecoveredDate] as [RecoveredDate]
       ,CASE isnull([Commissionable],0) WHEN 0 THEN 'F' WHEN 1 THEN 'T' ELSE 'F' END as [Commissionable]
      ,[WhenLoaded] as [WhenLoaded]
      ,[UID] as equipment_id
      ,'' as Filler
	  
  FROM [PBEquipment] e WITH (NOLOCK)
		join #placeaccounts a on a.referencenumber = e.number
end

-- Changed by KAR on 09/09/2010 8.3.0 versions send this 8.2.2 does not.
IF(@agencyVersion = '8.3.0' OR @agencyVersion = '10.7.0' OR @agencyVersion = '10.8.0') BEGIN
	IF (@sendassets = 'True')
	BEGIN
	SELECT 
	'CAST' as record_type,
	da.DebtorID as [debtor_number],
	da.AccountID as [file_number],
	da.ID as [asset_id],
	da.AssetType as [asset_type_id],
	da.Name as [asset_name],
	da.Description as [asset_description],
	ISNULL(da.CurrentValue,0) as [asset_value],
	ISNULL(da.LienAmount,0) as [asset_lien_value],
	CASE da.ValueVerified WHEN 1 THEN 'T' ELSE 'F' END as [asset_value_verified_flag],
	CASE da.LienVerified WHEN 1 THEN 'T' ELSE 'F' END as [asset_lien_value_verified_flag],
			'' as [Filler]
	FROM [Debtor_Assets] da WITH (NOLOCK) JOIN #placeaccounts a on da.AccountID = a.referencenumber

	END
	ELSE
	BEGIN
	SELECT TOP 0
	'CAST' as record_type,
	da.DebtorID as [debtor_number],
	da.AccountID as [file_number],
	da.ID as [asset_id],
	da.AssetType as [asset_type_id],
	da.Name as [asset_name],
	da.Description as [asset_description],
	ISNULL(da.CurrentValue,0) as [asset_value],
	ISNULL(da.LienAmount,0) as [asset_lien_value],
	CASE da.ValueVerified WHEN 0 THEN 'F' ELSE 'T' END as [asset_value_verified_flag],
	CASE da.LienVerified WHEN 0 THEN 'F' ELSE 'T' END as [asset_lien_value_verified_flag],
			'' as [Filler]
	FROM [Debtor_Assets] da WITH (NOLOCK) JOIN #placeaccounts a on da.AccountID = a.referencenumber

	END
END

-- Changed by KAR on 09/09/2010 8.3.0 versions send this 8.2.2 does not.
IF(@agencyVersion = '8.3.0' OR @agencyVersion = '10.7.0' OR @agencyVersion = '10.8.0') BEGIN

	IF(@sendjudgments = 'True')
	BEGIN
	SELECT
		  'CJDG' as record_type
		  ,cc.AccountID as [file_number]
		  ,CASE cc.Judgement WHEN 0 THEN 'F' ELSE 'T' END AS [JudgementFlag]
		  ,[CaseNumber]
		  ,[JudgementAmt]
		  ,[JudgementIntAward]
		  ,[JudgementCostAward]
		  ,[JudgementAttorneyCostAward]
		  ,[JudgementOtherAward]
		  ,[JudgementIntRate]
		  ,[IntFromDate] as [IntFromDate]
		  ,[AttorneyAckDate] as [AttorneyAckDate]
		  ,[DateFiled] as [DateFiled]
		  ,[ServiceDate] as [ServiceDate]
		  ,[JudgementDate] as [JudgementDate]
		  ,[JudgementRecordedDate] as [JudgementRecordedDate]
		  ,[DateAnswered] as [DateAnswered]
		  ,[StatuteDeadline] as [StatuteDeadline]
		  ,[CourtDate] as [CourtDate]
		  ,[DiscoveryCutoff] as [DiscoveryCutoff]
		  ,[DiscoveryReplyDate] as [DiscoveryReplyDate]
		  ,[MotionCutoff] as [MotionCutoff]
		  ,[ArbitrationDate] as [ArbitrationDate]
		  ,[LastSummaryJudgementDate] as [LastSummaryJudgementDate]
		  ,[Status]
		  ,[ServiceType]
		  ,[MiscInfo1]
		  ,[MiscInfo2]
		  ,[Remarks]
		  ,[Plaintiff]
		  ,[Defendant]
		  ,[JudgementBook]
		  ,[JudgementPage]
		  ,[Judge]
		  ,[CourtRoom]
		  ,c.[CourtName] AS [CourtName]
		  ,c.[County] AS [CourtCounty]
		  ,c.[Address1] AS [CourtStreet1]
		  ,c.[Address2] AS [CourtStreet2]
		  ,c.[City] AS [CourtCity]
		  ,c.[State] AS [CourtState]
		  ,c.[Zipcode] AS [CourtZipcode]
		  ,c.[Phone] AS [CourtPhone]
		  ,c.[Fax] AS [CourtFax]
		  ,c.[Salutation] AS [CourtSalutation]
		  ,c.[ClerkFirstName] AS [CourtClerkFirstName]
		  ,c.[ClerkMiddleName] AS [CourtClerkMiddleName]
		  ,c.[ClerkLastName] AS [CourtClerkLastName]
		  ,c.[Notes] AS [CourtNotes]
		  
	FROM CourtCases cc WITH (NOLOCK) JOIN Courts c WITH (NOLOCK) ON cc.CourtID = c.CourtID
	JOIN #placeaccounts a ON a.referencenumber = cc.AccountID
	END
	ELSE
	BEGIN
	SELECT TOP 0
		  'CJDG' as record_type
		  ,cc.AccountID as [file_number]
		  ,CASE cc.Judgement WHEN 0 THEN 'F' ELSE 'T' END AS [JudgementFlag]
		  ,[CaseNumber]
		  ,[JudgementAmt]
		  ,[JudgementIntAward]
		  ,[JudgementCostAward]
		  ,[JudgementAttorneyCostAward]
		  ,[JudgementOtherAward]
		  ,[JudgementIntRate]
		  ,[IntFromDate] as [IntFromDate]
		  ,[AttorneyAckDate] as [AttorneyAckDate]
		  ,[DateFiled] as [DateFiled]
		  ,[ServiceDate] as [ServiceDate]
		  ,[JudgementDate] as [JudgementDate]
		  ,[JudgementRecordedDate] as [JudgementRecordedDate]
		  ,[DateAnswered] as [DateAnswered]
		  ,[StatuteDeadline] as [StatuteDeadline]
		  ,[CourtDate] as [CourtDate]
		  ,[DiscoveryCutoff] as [DiscoveryCutoff]
		  ,[DiscoveryReplyDate] as [DiscoveryReplyDate]
		  ,[MotionCutoff] as [MotionCutoff]
		  ,[ArbitrationDate] as [ArbitrationDate]
		  ,[LastSummaryJudgementDate] as [LastSummaryJudgementDate]
		  ,[Status]
		  ,[ServiceType]
		  ,[MiscInfo1]
		  ,[MiscInfo2]
		  ,[Remarks]
		  ,[Plaintiff]
		  ,[Defendant]
		  ,[JudgementBook]
		  ,[JudgementPage]
		  ,[Judge]
		  ,[CourtRoom]
		  ,c.[CourtName] AS [CourtName]
		  ,c.[County] AS [CourtCounty]
		  ,c.[Address1] AS [CourtStreet1]
		  ,c.[Address2] AS [CourtStreet2]
		  ,c.[City] AS [CourtCity]
		  ,c.[State] AS [CourtState]
		  ,c.[Zipcode] AS [CourtZipcode]
		  ,c.[Phone] AS [CourtPhone]
		  ,c.[Fax] AS [CourtFax]
		  ,c.[Salutation] AS [CourtSalutation]
		  ,c.[ClerkFirstName] AS [CourtClerkFirstName]
		  ,c.[ClerkMiddleName] AS [CourtClerkMiddleName]
		  ,c.[ClerkLastName] AS [CourtClerkLastName]
		  ,c.[Notes] AS [CourtNotes]
		  

	FROM CourtCases cc WITH (NOLOCK) JOIN Courts c WITH (NOLOCK) ON cc.CourtID = c.CourtID
	JOIN #placeaccounts a ON a.referencenumber = cc.AccountID
	END
END

IF(@agencyVersion = '8.3.0' OR @agencyVersion = '10.7.0' OR @agencyVersion = '10.8.0')
BEGIN
IF(@SendAuto = 'True')
	BEGIN
		--Auto Data
		SELECT  
			  'CAAU' as record_type
			  ,a.referencenumber as [file_number]
			  ,[BidCloseDate] as [BidCloseDate]
			  ,[CollateralAppraiserCode]
			  ,[BuyerPONumber]
			  ,[DateCollateralAvailableforSale] as [DateCollateralAvailableforSale]
			  ,[DateAppraisalReceived] as [DateAppraisalReceived]
			  ,[InspectionDate] as [InspectionDate]
			  ,[DateofLettertoLienHolder1] as [DateofLettertoLienHolder1]
			  ,[DateofLettertoLienHolder2] as [DateofLettertoLienHolder2]
			  ,[DateRepairsCompleted] as [DateRepairsCompleted]
			  ,[DateRepairsOrdered] as [DateRepairsOrdered]
			  ,[DateRepairsApproved] as [DateRepairsApproved]
			  ,[TitleOrderedDate] as [TitleOrderedDate]
			  ,[TitleSenttoAuction] as [TitleSenttoAuction]
			  ,[DatePaymentReceivedforCollatoral] as [DatePaymentReceivedforCollatoral]
			  ,[TitleReceivedDate] as [TitleReceivedDate]
			  ,[DateCollateralSold] as [DateCollateralSold]
			  ,[DateAppraisalVerified] as [DateAppraisalVerified]
			  ,[DateNoticeSenttoGuarantor] as [DateNoticeSenttoGuarantor]
			  ,[DateNoticeSenttoMaker] as [DateNoticeSenttoMaker]
			  ,[DateNoticeSenttoOther] as [DateNoticeSenttoOther]
			  ,[RepairDescription]
			  ,CASE [CollateralRepairsNeeded] WHEN 1 THEN 'T' ELSE 'F' END AS [CollateralRepairsNeeded]
			  ,CASE [SellAsIsorRepaired]  WHEN 1 THEN 'T' ELSE 'F' END AS [SellAsIsorRepaired]
			  ,[CollateralSalePrice]
			  ,[CollateralStockNumber]
			  ,[RepairedValue]
			  ,[RepairComments]
			  ,[Location]
			  ,[AuctionExpense]
		FROM Auto_Auction AA WITH (NOLOCK)
		JOIN #placeaccounts a ON a.referencenumber = AA.AccountID

		SELECT  
			  'CAAA' as record_type
			  ,a.referencenumber as [file_number]
			  ,[ID]
			  ,[AppraiserCode]
			  ,[AverageValue]
			  ,[RetailValue]
			  ,[AppraisalSourcePublication]
			  ,[AppraisalReceivedDate] as [AppraisalReceivedDate]
		FROM Auto_AuctionAppraisal AA WITH (NOLOCK)
		JOIN #placeaccounts a ON a.referencenumber = AA.AccountID

		SELECT  
			  'CAAB' as record_type
			  ,a.referencenumber as [file_number]
			  ,[ID]
			  ,[BidderCode]
			  ,[BidAmount]
			  ,CASE [AcceptBid] WHEN 1 THEN 'T' ELSE 'F' END AS [AcceptBid]
			  ,[BidDate] as [BidDate]
		FROM Auto_AuctionBid AA WITH (NOLOCK)
		JOIN #placeaccounts a ON a.referencenumber = AA.AccountID

		SELECT  
			  'CARB' as record_type
			  ,a.referencenumber as [file_number]
			  ,[ID]
			  --,[AccountID]
			  ,[RepairCode]
			  ,[RepairEstimate]
			  ,CASE [AcceptEstimate]  WHEN 1 THEN 'T' ELSE 'F' END AS [AcceptEstimate]
		FROM Auto_AuctionRepairBid AA WITH (NOLOCK)
		JOIN #placeaccounts a ON a.referencenumber = AA.AccountID

		SELECT  
			  'CACO' as record_type
			  ,a.referencenumber as [file_number]
			  ,[CollateralYear]
			  ,[Make]
			  ,[Model]
			  ,[Vin]
			  ,[Addons]
			  ,[Color]
			  ,[CollateralMilesHours]
			  ,[MilesHours]
			  ,CASE [CollateralDamaged]  WHEN 1 THEN 'T' ELSE 'F' END AS [CollateralDamaged]
			  ,CASE [CollateralTotaled]  WHEN 1 THEN 'T' ELSE 'F' END AS [CollateralTotaled]
			  ,[ConditionDescription]
			  ,CASE [SellCollateral]  WHEN 1 THEN 'T' ELSE 'F' END AS [SellCollateral]
			  ,[IgnitionKeyNumber]
			  ,[OtherKeyNumber]
			  ,[TagDecalState]
			  ,[TagDecalNumber]
			  ,[TagDecalYear]
			  ,[TitlePosition]
			  ,[TitleState]
			  ,CASE [HaveTitle]  WHEN 1 THEN 'T' ELSE 'F' END AS [HaveTitle]
			  ,[DealerCode]
			  ,[LegalCode]
			  ,[VolumeDate] as [VolumeDate]
			  ,[FinanceChargeDue]
			  ,[LateChargeDue]
			  ,[DealerEndorsementCode]
			  ,[DealerReserveChargeback]
			  ,[TerminationDate] as [TerminationDate]
			  ,[TerminationEffectiveDate] as [TerminationEffectiveDate]
			  ,[FairMarketValue]
			  ,[PurchaseAmount]
			  ,[ManufacturingCode]
			  ,[MSRP]
			  ,[SeriesIdentifier]
			  ,[TitleStatus]
		FROM Auto_Collateral AA WITH (NOLOCK)
		JOIN #placeaccounts a ON a.referencenumber = AA.AccountID

		SELECT  
			  'CARP' as record_type
			  ,a.referencenumber as [file_number]
			  ,[Status]
			  ,[DateRepoAssigned] as [DateRepoAssigned]
			  ,[DateintoStorage] as [DateintoStorage]
			  ,[CollateralCondition]
			  ,CASE [CollateralDrivable]  WHEN 1 THEN 'T' ELSE 'F' END AS [CollateralDrivable]
			  ,[CollateralLeaseEndRepo]
			  ,[CollateralRedeemedby]
			  ,[CollateralRepoCode]
			  ,[CollatoralStorageLocation]
			  ,[DateCollateralReleasedtoBuyer] as [DateCollateralReleasedtoBuyer]
			  ,[CollateralReleased]
			  ,[RepoAddress1]
			  ,[RepoAddress2]
			  ,[RepoCity]
			  ,[RepoState]
			  ,[RepoZipcode]
			  ,[DateRepoCompleted] as [DateRepoCompleted]
			  ,[RedemptionDate] as [RedemptionDate]
			  ,[RedemptionAmount]
			  ,[StorageComments]
			  ,[AgencyName]
			  ,[AgencyPhone]
			  ,[BalanceAtRepo]
			  ,[RepoFees]
			  ,[PropertyStorageFee]
			  ,[KeyCutFee]
			  ,[MiscFees]
			  ,[ImpoundFee]
			  ,[RepoExpenses]
			  ,[PoliceEntity]
		FROM Auto_Repossession AA WITH (NOLOCK)
		JOIN #placeaccounts a ON a.referencenumber = AA.AccountID

		SELECT  
			  'CALS' as record_type
			  ,a.referencenumber as [file_number]
			  ,[TermMonths]
			  ,[MaturityDate] as [MaturityDate]
			  ,[EffectiveDate] as [EffectiveDate]
			  ,[OriginalMiles]
			  ,[ContractMiles]
			  ,[PurchaseMiles]
			  ,[EndofTermMiles]
			  ,[Residual]
			  ,[ContractObligation]
			  ,[SecurityDeposit]
			  ,[UnpaidMonthsPayment]
			  ,[UnpaidTax]
			  ,[ExcessMileage]
			  ,[WearandTear]
			  ,[ReturnDate] as [ReturnDate]
			  ,[ExcessMiles]
			  ,[UnusedMiles]
			  ,[InceptionMiles]
			  ,[MileageCredit]
			  ,[MinorWearCharge]
			  ,[MajorWearCharge]
			  ,[DisposalAssessedAmount]
			  ,[ResidualGainLoss]
			  ,[EndofTermTaxAssessed]
			  ,[OtherTaxAssessed]
			  ,[DispositionDate] as [DispositionDate]
			  ,[InspectionReceivedDate] as [InspectionReceivedDate]

		FROM Auto_Lease AA WITH (NOLOCK)
		JOIN #placeaccounts a ON a.referencenumber = AA.AccountID

		SELECT  
			  'CARH' as record_type
			  ,a.referencenumber as [file_number]
			  ,[ID]
			  ,[LoginName]
			  ,[Status]
			  ,[AgencyName]
			  ,[DateTimeStamp] as [DateTimeStamp]
			  ,[Comment]
		FROM Auto_RepossessionHistory AA WITH (NOLOCK)
		JOIN #placeaccounts a ON a.referencenumber = AA.AccountID

	END
ELSE
	BEGIN
		SELECT TOP 0
			  'CAAU' as record_type
			  ,a.referencenumber as [file_number]
			  ,[BidCloseDate] as [BidCloseDate]
			  ,[CollateralAppraiserCode]
			  ,[BuyerPONumber]
			  ,[DateCollateralAvailableforSale] as [DateCollateralAvailableforSale]
			  ,[DateAppraisalReceived] as [DateAppraisalReceived]
			  ,[InspectionDate] as [InspectionDate]
			  ,[DateofLettertoLienHolder1] as [DateofLettertoLienHolder1]
			  ,[DateofLettertoLienHolder2] as [DateofLettertoLienHolder2]
			  ,[DateRepairsCompleted] as [DateRepairsCompleted]
			  ,[DateRepairsOrdered] as [DateRepairsOrdered]
			  ,[DateRepairsApproved] as [DateRepairsApproved]
			  ,[TitleOrderedDate] as [TitleOrderedDate]
			  ,[TitleSenttoAuction] as [TitleSenttoAuction]
			  ,[DatePaymentReceivedforCollatoral] as [DatePaymentReceivedforCollatoral]
			  ,[TitleReceivedDate] as [TitleReceivedDate]
			  ,[DateCollateralSold] as [DateCollateralSold]
			  ,[DateAppraisalVerified] as [DateAppraisalVerified]
			  ,[DateNoticeSenttoGuarantor] as [DateNoticeSenttoGuarantor]
			  ,[DateNoticeSenttoMaker] as [DateNoticeSenttoMaker]
			  ,[DateNoticeSenttoOther] as [DateNoticeSenttoOther]
			  ,[RepairDescription]
			  ,CASE [CollateralRepairsNeeded] WHEN 1 THEN 'T' ELSE 'F' END AS [CollateralRepairsNeeded]
			  ,CASE [SellAsIsorRepaired]  WHEN 1 THEN 'T' ELSE 'F' END AS [SellAsIsorRepaired]
			  ,[CollateralSalePrice]
			  ,[CollateralStockNumber]
			  ,[RepairedValue]
			  ,[RepairComments]
			  ,[Location]
			  ,[AuctionExpense]
		FROM Auto_Auction AA WITH (NOLOCK)
		JOIN #placeaccounts a ON a.referencenumber = AA.AccountID

		SELECT TOP 0
			  'CAAA' as record_type
			  ,a.referencenumber as [file_number]
			  ,[ID]
			  ,[AppraiserCode]
			  ,[AverageValue]
			  ,[RetailValue]
			  ,[AppraisalSourcePublication]
			  ,[AppraisalReceivedDate] as [AppraisalReceivedDate]
		FROM Auto_AuctionAppraisal AA WITH (NOLOCK)
		JOIN #placeaccounts a ON a.referencenumber = AA.AccountID

		SELECT TOP 0
			  'CAAB' as record_type
			  ,a.referencenumber as [file_number]
			  ,[ID]
			  ,[BidderCode]
			  ,[BidAmount]
			  ,CASE [AcceptBid] WHEN 1 THEN 'T' ELSE 'F' END AS [AcceptBid]
			  ,[BidDate] as [BidDate]
		FROM Auto_AuctionBid AA WITH (NOLOCK)
		JOIN #placeaccounts a ON a.referencenumber = AA.AccountID

		SELECT TOP 0
			  'CARB' as record_type
			  ,a.referencenumber as [file_number]
			  ,[ID]
			  --,[AccountID]
			  ,[RepairCode]
			  ,[RepairEstimate]
			  ,CASE [AcceptEstimate]  WHEN 1 THEN 'T' ELSE 'F' END AS [AcceptEstimate]
		FROM Auto_AuctionRepairBid AA WITH (NOLOCK)
		JOIN #placeaccounts a ON a.referencenumber = AA.AccountID

		SELECT TOP 0
			  'CACO' as record_type
			  ,a.referencenumber as [file_number]
			  ,[CollateralYear]
			  ,[Make]
			  ,[Model]
			  ,[Vin]
			  ,[Addons]
			  ,[Color]
			  ,[CollateralMilesHours]
			  ,[MilesHours]
			  ,CASE [CollateralDamaged]  WHEN 1 THEN 'T' ELSE 'F' END AS [CollateralDamaged]
			  ,CASE [CollateralTotaled]  WHEN 1 THEN 'T' ELSE 'F' END AS [CollateralTotaled]
			  ,[ConditionDescription]
			  ,CASE [SellCollateral]  WHEN 1 THEN 'T' ELSE 'F' END AS [SellCollateral]
			  ,[IgnitionKeyNumber]
			  ,[OtherKeyNumber]
			  ,[TagDecalState]
			  ,[TagDecalNumber]
			  ,[TagDecalYear]
			  ,[TitlePosition]
			  ,[TitleState]
			  ,CASE [HaveTitle]  WHEN 1 THEN 'T' ELSE 'F' END AS [HaveTitle]
			  ,[DealerCode]
			  ,[LegalCode]
			  ,[VolumeDate] as [VolumeDate]
			  ,[FinanceChargeDue]
			  ,[LateChargeDue]
			  ,[DealerEndorsementCode]
			  ,[DealerReserveChargeback]
			  ,[TerminationDate] as [TerminationDate]
			  ,[TerminationEffectiveDate] as [TerminationEffectiveDate]
			  ,[FairMarketValue]
			  ,[PurchaseAmount]
			  ,[ManufacturingCode]
			  ,[MSRP]
			  ,[SeriesIdentifier]
			  ,[TitleStatus]
		FROM Auto_Collateral AA WITH (NOLOCK)
		JOIN #placeaccounts a ON a.referencenumber = AA.AccountID

		SELECT TOP 0
			  'CARP' as record_type
			  ,a.referencenumber as [file_number]
			  ,[Status]
			  ,[DateRepoAssigned] as [DateRepoAssigned]
			  ,[DateintoStorage] as [DateintoStorage]
			  ,[CollateralCondition]
			  ,CASE [CollateralDrivable]  WHEN 1 THEN 'T' ELSE 'F' END AS [CollateralDrivable]
			  ,[CollateralLeaseEndRepo]
			  ,[CollateralRedeemedby]
			  ,[CollateralRepoCode]
			  ,[CollatoralStorageLocation]
			  ,[DateCollateralReleasedtoBuyer] as [DateCollateralReleasedtoBuyer]
			  ,[CollateralReleased]
			  ,[RepoAddress1]
			  ,[RepoAddress2]
			  ,[RepoCity]
			  ,[RepoState]
			  ,[RepoZipcode]
			  ,[DateRepoCompleted] as [DateRepoCompleted]
			  ,[RedemptionDate] as [RedemptionDate]
			  ,[RedemptionAmount]
			  ,[StorageComments]
			  ,[AgencyName]
			  ,[AgencyPhone]
			  ,[BalanceAtRepo]
			  ,[RepoFees]
			  ,[PropertyStorageFee]
			  ,[KeyCutFee]
			  ,[MiscFees]
			  ,[ImpoundFee]
			  ,[RepoExpenses]
			  ,[PoliceEntity]
		FROM Auto_Repossession AA WITH (NOLOCK)
		JOIN #placeaccounts a ON a.referencenumber = AA.AccountID

		SELECT TOP 0
			  'CALS' as record_type
			  ,a.referencenumber as [file_number]
			  ,[TermMonths]
			  ,[MaturityDate] as [MaturityDate]
			  ,[EffectiveDate] as [EffectiveDate]
			  ,[OriginalMiles]
			  ,[ContractMiles]
			  ,[PurchaseMiles]
			  ,[EndofTermMiles]
			  ,[Residual]
			  ,[ContractObligation]
			  ,[SecurityDeposit]
			  ,[UnpaidMonthsPayment]
			  ,[UnpaidTax]
			  ,[ExcessMileage]
			  ,[WearandTear]
			  ,[ReturnDate] as [ReturnDate]
			  ,[ExcessMiles]
			  ,[UnusedMiles]
			  ,[InceptionMiles]
			  ,[MileageCredit]
			  ,[MinorWearCharge]
			  ,[MajorWearCharge]
			  ,[DisposalAssessedAmount]
			  ,[ResidualGainLoss]
			  ,[EndofTermTaxAssessed]
			  ,[OtherTaxAssessed]
			  ,[DispositionDate] as [DispositionDate]
			  ,[InspectionReceivedDate] as [InspectionReceivedDate]

		FROM Auto_Lease AA WITH (NOLOCK)
		JOIN #placeaccounts a ON a.referencenumber = AA.AccountID

		SELECT TOP 0
			  'CARH' as record_type
			  ,a.referencenumber as [file_number]
			  ,[ID]
			  ,[LoginName]
			  ,[Status]
			  ,[AgencyName]
			  ,[DateTimeStamp] as [DateTimeStamp]
			  ,[Comment]
		FROM Auto_RepossessionHistory AA WITH (NOLOCK)
		JOIN #placeaccounts a ON a.referencenumber = AA.AccountID

	END
END

IF(@agencyVersion = '10.7.0' OR @agencyVersion = '10.8.0') BEGIN

	IF(@SendComplaint = 'True')
	BEGIN
	
		-- Insert into reference table since ids need to be communicated back and forth.
		INSERT INTO [dbo].[AIM_Complaint]([Source], [AccountID], [AgencyID], [ComplaintID])
		SELECT 'AIM', a.referencenumber, @agencyId, [Complaint].[ComplaintId]
		FROM [dbo].[Complaint] AS [Complaint] WITH (NOLOCK)
		INNER JOIN #placeaccounts a ON a.referencenumber = [Complaint].[AccountId]
		INNER JOIN dbo.ComplaintCategory AS [ComplaintCategory] WITH (NOLOCK)
			ON Complaint.Category = ComplaintCategory.Code;
		
		SELECT 
		'CCPT' as record_type,
		[Complaint].[AccountId] as [file_number],
		[Complaint].[DebtorId] AS [debtor_number],
		[Complaint].[ComplaintId] AS [id],
		Custom_ListDataComplaintAgainst.Code AS [against_code],
		Custom_ListDataComplaintAgainst.Description AS [against],
		[Complaint].[Against] AS [against_entity],
		ComplaintCategory.Code AS [category],
		[Complaint].[CompensationAmount] AS [compensation_amount],
		[Complaint].[Conclusion] AS [conclusion],
		[Complaint].[DateClosed] AS [date_closed],
		[Complaint].[DateInAdmin] AS [date_in_admin],
		[Complaint].[DateReceived] AS [date_received],
		CASE ISNULL([Complaint].[Deleted],0) WHEN 0 THEN 'N' ELSE 'Y' END  AS [deleted],
		[Complaint].[Details] AS [details],
		CASE ISNULL([Complaint].[Dissatisfaction],0) WHEN 0 THEN 'N' ELSE 'Y' END AS [dissatisfaction],
		[Complaint].[DissatisfactionDate] AS [dissatisfaction_date],
		[Complaint].[Grievances] AS [grievances],
		[Complaint].[InvestigationCommentsToDate] AS [investigation_comments_to_date],
		Custom_ListDataComplaintJustified.Code AS [justified_code],
		Custom_ListDataComplaintJustified.Description AS [justified],
		Custom_LIstDataComplaintOutcome.Code AS [outcome_code],
		Custom_LIstDataComplaintOutcome.Description AS [outcome],
		[Complaint].[Owner] AS [owner],
		[Complaint].[RecourseDate] AS [recourse_date],
		[Complaint].[ReferredBy] AS [referred_by],
		Custom_ListDataComplaintRoot.Code AS [root_cause_code],
		Custom_ListDataComplaintRoot.Description AS [root_cause],
		[Complaint].[SLADays] AS [sla_days],
		Custom_ListDataComplaintStatus.Code AS [status_code],
		Custom_ListDataComplaintStatus.Description AS [status],
		Custom_ListDataComplaintType.Code AS [type_code],
		Custom_ListDataComplaintType.Description AS [type]
		FROM [dbo].[Complaint] AS [Complaint] WITH (NOLOCK)
		INNER JOIN #placeaccounts a ON a.referencenumber = [Complaint].[AccountId]
		LEFT OUTER JOIN Custom_ListData AS [Custom_ListDataComplaintAgainst] WITH (NOLOCK)
			ON Custom_ListDataComplaintAgainst.Code = Complaint.AgainstType AND Custom_ListDataComplaintAgainst.ListCode = 'COMPLTAGST'
		INNER JOIN dbo.ComplaintCategory AS [ComplaintCategory] WITH (NOLOCK)
			ON Complaint.Category = ComplaintCategory.Code
		LEFT OUTER JOIN Custom_ListData AS [Custom_ListDataComplaintJustified] WITH (NOLOCK)
			ON Custom_ListDataComplaintJustified.Code = Complaint.Justified AND Custom_ListDataComplaintJustified.ListCode = 'COMPLTJST'
		LEFT OUTER JOIN Custom_ListData AS [Custom_ListDataComplaintOutcome] WITH (NOLOCK)
			ON Custom_ListDataComplaintOutcome.Code = Complaint.Outcome AND Custom_ListDataComplaintOutcome.ListCode = 'COMPLTOUT'
		LEFT OUTER JOIN Custom_ListData AS [Custom_ListDataComplaintRoot] WITH (NOLOCK)
			ON Custom_ListDataComplaintRoot.Code = Complaint.RootCause AND Custom_ListDataComplaintRoot.ListCode = 'COMPLTROOT'
		LEFT OUTER JOIN Custom_ListData AS [Custom_ListDataComplaintStatus] WITH (NOLOCK)
			ON Custom_ListDataComplaintStatus.Code = Complaint.Status AND Custom_ListDataComplaintStatus.ListCode = 'COMPLTSTAT'
		LEFT OUTER JOIN Custom_ListData AS [Custom_ListDataComplaintType] WITH (NOLOCK)
			ON Custom_ListDataComplaintType.Code = Complaint.Type AND Custom_ListDataComplaintType.ListCode = 'COMPLTTYPE'
		
	END
	ELSE
	BEGIN
		SELECT TOP 0
		'CCPT' as record_type,		
		[Complaint].[AccountId] as [file_number],
		[Complaint].[DebtorId] AS [debtor_number],
		[Complaint].[ComplaintId] AS [id],
		Custom_ListDataComplaintAgainst.Code AS [against_code],
		Custom_ListDataComplaintAgainst.Description AS [against],
		[Complaint].[Against] AS [against_entity],
		ComplaintCategory.Code AS [category],
		[Complaint].[CompensationAmount] AS [compensation_amount],
		[Complaint].[Conclusion] AS [conclusion],
		[Complaint].[DateClosed] AS [date_closed],
		[Complaint].[DateInAdmin] AS [date_in_admin],
		[Complaint].[DateReceived] AS [date_received],
		CASE ISNULL([Complaint].[Deleted],0) WHEN 0 THEN 'N' ELSE 'Y' END  AS [deleted],
		[Complaint].[Details] AS [details],
		CASE ISNULL([Complaint].[Dissatisfaction],0) WHEN 0 THEN 'N' ELSE 'Y' END AS [dissatisfaction],
		[Complaint].[DissatisfactionDate] AS [dissatisfaction_date],
		[Complaint].[Grievances] AS [grievances],
		[Complaint].[InvestigationCommentsToDate] AS [investigation_comments_to_date],
		Custom_ListDataComplaintJustified.Code AS [justified_code],
		Custom_ListDataComplaintJustified.Description AS [justified],
		Custom_LIstDataComplaintOutcome.Code AS [outcome_code],
		Custom_LIstDataComplaintOutcome.Description AS [outcome],
		[Complaint].[Owner] AS [owner],
		[Complaint].[RecourseDate] AS [recourse_date],
		[Complaint].[ReferredBy] AS [referred_by],
		Custom_ListDataComplaintRoot.Code AS [root_cause_code],
		Custom_ListDataComplaintRoot.Description AS [root_cause],
		[Complaint].[SLADays] AS [sla_days],
		Custom_ListDataComplaintStatus.Code AS [status_code],
		Custom_ListDataComplaintStatus.Description AS [status],
		Custom_ListDataComplaintType.Code AS [type_code],
		Custom_ListDataComplaintType.Description AS [type]
		FROM [dbo].[Complaint] AS [Complaint] WITH (NOLOCK)
		INNER JOIN #placeaccounts a ON a.referencenumber = [Complaint].[AccountId]
		LEFT OUTER JOIN Custom_ListData AS [Custom_ListDataComplaintAgainst] WITH (NOLOCK)
			ON Custom_ListDataComplaintAgainst.Code = Complaint.AgainstType AND Custom_ListDataComplaintAgainst.ListCode = 'COMPLTAGST'
		INNER JOIN dbo.ComplaintCategory AS [ComplaintCategory] WITH (NOLOCK)
			ON Complaint.Category = ComplaintCategory.Code
		LEFT OUTER JOIN Custom_ListData AS [Custom_ListDataComplaintJustified] WITH (NOLOCK)
			ON Custom_ListDataComplaintJustified.Code = Complaint.Justified AND Custom_ListDataComplaintJustified.ListCode = 'COMPLTJST'
		LEFT OUTER JOIN Custom_ListData AS [Custom_ListDataComplaintOutcome] WITH (NOLOCK)
			ON Custom_ListDataComplaintOutcome.Code = Complaint.Outcome AND Custom_ListDataComplaintOutcome.ListCode = 'COMPLTOUT'
		LEFT OUTER JOIN Custom_ListData AS [Custom_ListDataComplaintRoot] WITH (NOLOCK)
			ON Custom_ListDataComplaintRoot.Code = Complaint.RootCause AND Custom_ListDataComplaintRoot.ListCode = 'COMPLTROOT'
		LEFT OUTER JOIN Custom_ListData AS [Custom_ListDataComplaintStatus] WITH (NOLOCK)
			ON Custom_ListDataComplaintStatus.Code = Complaint.Status AND Custom_ListDataComplaintStatus.ListCode = 'COMPLTSTAT'
		LEFT OUTER JOIN Custom_ListData AS [Custom_ListDataComplaintType] WITH (NOLOCK)
			ON Custom_ListDataComplaintType.Code = Complaint.Type AND Custom_ListDataComplaintType.ListCode = 'COMPLTTYPE'
	
	END
END

IF(@agencyVersion = '10.7.0' OR @agencyVersion = '10.8.0') BEGIN

	IF(@SendDispute = 'True')
	BEGIN
	
		-- Insert into reference table since ids need to be communicated back and forth.
		INSERT INTO [dbo].[AIM_Dispute]([Source], [AccountID], [AgencyID], [DisputeID])
		SELECT 'AIM', a.referencenumber, @agencyId, [Dispute].[DisputeId]
		FROM [dbo].[Dispute] AS [Dispute] WITH (NOLOCK)
		INNER JOIN #placeaccounts a ON a.referencenumber = [Dispute].[Number];
		
		SELECT 
			'CDIS' [record_type],
			d.[Number] [file_number],
			d.[DebtorId] [debtor_number],
			d.[DisputeId] [id],
			d.[Type] [type_code],
			[dtype].[Description] [type],
			d.[DateReceived] [date_received],
			d.[ReferredBy] [referred_by_code],
			[listref].[Description] [referred_by],
			d.[Details] [details],
			d.[Category] [category_code],
			[listcat].[Description] [category],
			d.[Against] [against_code],
			[listagainst].[Description] [against],
			d.[DateClosed] [date_closed],
			d.[RecourseDate] [recourse_date],
			d.[Justified] [justified],
			d.[Outcome] [outcome_code],
			[listoutcome].[Description] [outcome],
			CASE WHEN ISNULL(d.[Deleted], 0) = 0 THEN 'N' ELSE 'Y' END [deleted],
			CASE WHEN ISNULL(d.[ProofRequired], 0) = 0 THEN 'N' ELSE 'Y' END [proof_required],
			CASE WHEN ISNULL(d.[ProofRequested], 0) = 0 THEN 'N' ELSE 'Y' END [proof_requested],
			CASE WHEN ISNULL(d.[InsufficientProofReceived], 0) = 0 THEN 'N' ELSE 'Y' END [insufficient_proof_received],
			CASE WHEN ISNULL(d.[ProofReceived], 0) = 0 THEN 'N' ELSE 'Y' END [proof_received]
		FROM [dbo].[Dispute] d
		INNER JOIN [#placeaccounts] p
		ON p.[referenceNumber] = d.[Number]
		LEFT OUTER JOIN [dbo].[DisputeType] dtype
		ON dtype.[Code] = d.[Type]
		LEFT OUTER JOIN [dbo].[Custom_ListData] listref
		ON listref.[Code] = d.[ReferredBy] AND listref.[ListCode] = 'DISPUTEREF'
		LEFT OUTER JOIN [dbo].[Custom_ListData] listcat
		ON listcat.[Code] = d.[Category] AND listcat.[ListCode] = 'DISPUTECAT'
		LEFT OUTER JOIN [dbo].[Custom_ListData] listagainst
		ON listagainst.[Code] = d.[Against] AND listagainst.[ListCode] = 'DISPUTEAGT'
		LEFT OUTER JOIN [dbo].[Custom_ListData] listoutcome
		ON listoutcome.[Code] = d.[Outcome] AND listoutcome.[ListCode] = 'DISPUTEOUT'
	
	END
	ELSE
	BEGIN

		SELECT TOP 0
			'CDIS' [record_type],
			d.[Number] [file_number],
			d.[DebtorId] [debtor_number],
			d.[DisputeId] [id],
			d.[Type] [type_code],
			[dtype].[Description] [type],
			d.[DateReceived] [date_received],
			d.[ReferredBy] [referred_by_code],
			[listref].[Description] [referred_by],
			d.[Details] [details],
			d.[Category] [category_code],
			[listcat].[Description] [category],
			d.[Against] [against_code],
			[listagainst].[Description] [against],
			d.[DateClosed] [date_closed],
			d.[RecourseDate] [recourse_date],
			d.[Justified] [justified],
			d.[Outcome] [outcome_code],
			[listoutcome].[Description] [outcome],
			CASE WHEN ISNULL(d.[Deleted], 0) = 0 THEN 'N' ELSE 'Y' END [deleted],
			CASE WHEN ISNULL(d.[ProofRequired], 0) = 0 THEN 'N' ELSE 'Y' END [proof_required],
			CASE WHEN ISNULL(d.[ProofRequested], 0) = 0 THEN 'N' ELSE 'Y' END [proof_requested],
			CASE WHEN ISNULL(d.[InsufficientProofReceived], 0) = 0 THEN 'N' ELSE 'Y' END [insufficient_proof_received],
			CASE WHEN ISNULL(d.[ProofReceived], 0) = 0 THEN 'N' ELSE 'Y' END [proof_received]
		FROM [dbo].[Dispute] d
		INNER JOIN [#placeaccounts] p
		ON p.[referenceNumber] = d.[Number]
		LEFT OUTER JOIN [dbo].[DisputeType] dtype
		ON dtype.[Code] = d.[Type]
		LEFT OUTER JOIN [dbo].[Custom_ListData] listref
		ON listref.[Code] = d.[ReferredBy] AND listref.[ListCode] = 'DISPUTEREF'
		LEFT OUTER JOIN [dbo].[Custom_ListData] listcat
		ON listcat.[Code] = d.[Category] AND listcat.[ListCode] = 'DISPUTECAT'
		LEFT OUTER JOIN [dbo].[Custom_ListData] listagainst
		ON listagainst.[Code] = d.[Against] AND listagainst.[ListCode] = 'DISPUTEAGT'
		LEFT OUTER JOIN [dbo].[Custom_ListData] listoutcome
		ON listoutcome.[Code] = d.[Outcome] AND listoutcome.[ListCode] = 'DISPUTEOUT'			
	
	END
END

UPDATE 	AIM_accounttransaction WITH (ROWLOCK)
	SET transactionstatustypeid = 2 
FROM 
	AIM_accounttransaction att
	JOIN #placeaccounts a ON a.accountreferenceid = att.accountreferenceid
WHERE
	transactiontypeid = 1 
	AND transactionstatustypeid = 1 
	AND agencyid = @agencyId

END
GO
