SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE         procedure [dbo].[AIM_Placement_SelectTransactionsReadyForFileBatch]
(
	@agencyId int
)
as
begin 

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
	select @sendequipment = value from aim_appsetting where [key] = 'AIM.Placements.SendEquipment'
	select @sendpatientinfo = value from aim_appsetting where [key] = 'AIM.Placements.SendPatientInfo'
	select @sendinsurance =	value from aim_appsetting where [key] = 'AIM.Placements.SendInsurance'
	select @sendmiscextra = value from aim_appsetting where [key] = 'AIM.Placements.SendMiscExtra'
	select @sendnotes = value from aim_appsetting where [key] = 'AIM.Placements.SendNotes'
	select @sendbanko = value from aim_appsetting where [key] = 'AIM.Placements.SendBanko'
	select @senddeceased = value from aim_appsetting where [key] = 'AIM.Placements.SendDeceased'
	select @sendassets = value from aim_appsetting where [key] = 'AIM.Placements.SendAssets'
	select @sendjudgments = value from aim_appsetting where [key] = 'AIM.Placements.SendJudgments'
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
		isnull(convert(varchar(8),clidlc,112),'19000101') as last_charge,
		isnull(convert(varchar(8),lastpaid,112),'19000101') as last_paid,
		isnull(convert(varchar(8),userdate1,112),'19000101') as userdate1,
		isnull(convert(varchar(8),userdate2,112),'19000101') as userdate2,
		isnull(convert(varchar(8),userdate3,112),'19000101') as userdate3,
		
		originalcreditor as original_creditor,   -- *** Column not found ***
		isnull(convert(varchar(8),lastinterest,112),'19000101') as last_interest,
		isnull(interestrate,0) as interestrate,
		custdivision as customer_division,
		custdistrict as customer_district,
		custbranch as customer_branch,
		id1,
		id2,
		desk,
		customer,
		isnull(convert(varchar(8),chargeoffdate,112),'19000101') as chargeoffdate,
		isnull(convert(varchar(8),delinquencydate,112),'19000101') as delinquencydate,
		isnull(lastpaidamt,0) as last_paid_amount,
		isnull(convert(varchar(8),contractdate,112),'19000101') as contractdate,
		isnull(convert(varchar(8),clidlp,112),'19000101') as clidlp,
		isnull(convert(varchar(8),clidlc,112),'19000101') as clidlc,
		isnull(clialp,0) as clialp,
		isnull(clialc,0) as clialc,
		previouscreditor as previous_creditor,
		ISNULL(p.ContractDate,ReceivedDate) as purchaseddate,
		c.AlphaCode as customer_alphacode,
		c.Company as customer_company,
		c.Name as customer_name,
		ig.Name as AIM_InvestorGroupName,
		sg.Name as AIM_SellerGroupName,
		'' as [Filler]


		
	from 	master m with (nolock)
		join #placeaccounts a on a.referenceNumber = m.number
		join customer c with (nolock) on c.customer = m.customer
		left outer join AIM_Portfolio p WITH (NOLOCK) ON p.portfolioid = m.purchasedportfolio
		join AIM_Group ig WITH (NOLOCK) ON p.InvestorGroupID = ig.GroupID
		join AIM_Group sg WITH (NOLOCK) ON p.SellerGroupID = sg.GroupID
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
		isnull(convert(varchar(8),dv.dob,112),'19000101') as date_of_birth,
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
		debtorid as debtor_number,  -- *** Column not found ***,
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
 		mv.number as file_number,
 		account as account,  
 		title as title,
 		thedata as misc_data
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
		isnull(convert(varchar(8),created,112),'19000101') as note_created_datetime,
		action as note_action,
		result as note_result,
		comment as note_comment,
		'' as [Filler]
	from 
		notes n with (nolock)
		join master m with (nolock) on m.number = n.number
		join #placeaccounts a on a.referencenumber = n.number
end
else
begin
	select top 0
		n.number as file_number,
		isnull(convert(varchar(8),created,112),'19000101') as created_datetime,
		action as note_action,
		result as note_result,
		comment as note_comment
	from 
		notes n with (nolock)
		join master m with (nolock) on m.number = n.number
		join #placeaccounts a on a.referencenumber = n.number
end




if(@senddeceased = 'True')
begin
SELECT
	'CDEC' as record_type,
	db.debtorid as debtor_number,
	db.number as file_number,
	rtrim(ltrim(replace(replace(db.ssn,'-',''),' ',''))) as ssn,
	substring(db.name,charindex(',',db.name,0)+2,len(db.name)-charindex(',',db.name,0)) as first_name,
	substring(db.name,0,charindex(',',db.name,0))  as last_name,
	d.state as state,
	rtrim(ltrim(replace(replace(d.postalcode,'-',''),' ',''))) as postal_code,
	isnull(convert(varchar(8),d.dob,112),'19000101')as date_of_birth,
	isnull(convert(varchar(8),d.dod,112),'19000101') as date_of_death,
	d.matchcode as match_code,
	isnull(convert(varchar(8),d.transmitteddate,112),'19000101') as transmit_date,
      [ClaimDeadline] AS    claim_deadline_date,
      [DateFiled] AS		 filed_date,
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
	join debtors db with (nolock) on db.debtorid = d.debtorid
	join #placeaccounts a on a.referencenumber = db.number
	

end
else
begin
SELECT top 0
	'CDEC' as record_type,
	db.debtorid as debtor_number,
	db.number as file_number,
	db.ssn as ssn,
	substring(db.name,charindex(',',db.name,0)+2,len(db.name)-charindex(',',db.name,0)) as first_name,
	substring(db.name,0,charindex(',',db.name,0))  as last_name,
	d.state as state,
	d.postalcode as postal_code,
	isnull(convert(varchar(8),d.dob,112),'19000101') as date_of_birth,
	isnull(convert(varchar(8),d.dod,112),'19000101') as date_of_death,
	d.matchcode as match_code,
	isnull(convert(varchar(8),d.transmitteddate,112),'19000101') as transmit_date,
      [ClaimDeadline] AS    claim_deadline_date,
      [DateFiled] AS		 filed_date,
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
	join debtors db with (nolock) on db.debtorid = d.debtorid
	join #placeaccounts a on a.referencenumber = db.number
	

end



if(@sendbanko = 'True')
begin
SELECT
	'CBKP' as record_type,
	d.debtorid as debtor_number,
	d.number as file_number,
	isnull(b.chapter,0) as chapter,
	isnull(convert(varchar(8),b.datefiled,112),'19000101') as date_filed,
	b.casenumber as case_number,
	b.courtdistrict as court_district,
	b.courtdivision as court_division,
	b.courtphone as court_phone,
	b.courtstreet1 as court_address1,
	b.courtstreet2 as court_address2,
	b.courtcity as court_city,
	b.courtstate as court_state,
	rtrim(ltrim(replace(replace(b.courtzipcode,'-',''),' ',''))) as court_zipcode,
	b.trustee as trustee,
	b.trusteestreet1 as trustee_address1,
	b.trusteestreet2 as trustee_address2,
	b.trusteecity as trustee_city,
	b.trusteestate as trustee_state,
	rtrim(ltrim(replace(replace(b.trusteezipcode,'-',''),' ',''))) as trustee_zipcode,
	b.trusteephone as trustee_phone,
	cast(CASE WHEN b.has341info = 1 THEN '1' ELSE '0' END as varchar(1)) as three_forty_one_info_flag,
	isnull(convert(varchar(8),b.datetime341,112),'19000101') as three_forty_one_date,
	b.location341 as three_forty_one_location,
	replace(replace(b.comments,char(13),' '),char(10),' ') as comments,
	b.status as status,
	isnull(convert(varchar(8),b.transmitteddate,112),'19000101') as transmit_date,
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
	AuctionFeeAmount AS auction_fee_amount,
	AuctionAppliedAmount AS auction_applied_amount,
	SecuredAmount AS secured_amount,
	SecuredPercentage AS secured_percentage,
	UnsecuredAmount AS unsecured_amount,
	UnsecuredPercentage AS unsecured_percentage,
	ConvertedFrom AS converted_from_chapter,
	CASE HasAsset WHEN 0 THEN 'F' ELSE 'T' END AS has_asset,
	CASE Reaffirm WHEN 0 THEN 'F' ELSE 'T' END AS reaffirm_flag,
	[ReaffirmTerms] AS reaffirm_terms,
	VoluntaryTerms AS voluntary_terms,
	[SurrenderMethod] AS surrender_method,
	AuctionHouse AS auction_house,
	'' as [Filler]
			

FROM
	bankruptcy b with (nolock) join debtors d with (nolock) on b.debtorid = d.debtorid
	join #placeaccounts a on a.referencenumber = d.number


end
else
begin
SELECT top 0
	'CBKP' as record_type,
	d.debtorid as debtor_number,
	d.number as file_number,
	b.chapter as chapter,
	isnull(convert(varchar(8),b.datefiled,112),'19000101') as date_filed,
	b.casenumber as case_number,
	b.courtcity as court_city,
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
	isnull(convert(varchar(8),b.datetime341,112),'19000101') as three_forty_one_date,
	b.location341 as three_forty_one_location,
	b.comments as comments,
	b.status as status,
	isnull(convert(varchar(8),b.transmitteddate,112),'19000101') as transmit_date,
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
	AuctionFeeAmount AS auction_fee_amount,
	AuctionAppliedAmount AS auction_applied_amount,
	SecuredAmount AS secured_amount,
	SecuredPercentage AS secured_percentage,
	UnsecuredAmount AS unsecured_amount,
	UnsecuredPercentage AS unsecured_percentage,
	ConvertedFrom AS converted_from_chapter,
	CASE HasAsset WHEN 0 THEN 'F' ELSE 'T' END AS has_asset,
	CASE Reaffirm WHEN 0 THEN 'F' ELSE 'T' END AS reaffirm_flag,
	[ReaffirmTerms] AS reaffirm_terms,
	VoluntaryTerms AS voluntary_terms,
	[SurrenderMethod] AS surrender_method,
	AuctionHouse AS auction_house,
	'' as [Filler]
		

FROM
	bankruptcy b with (nolock) join debtors d with (nolock) on b.debtorid = d.debtorid
	join #placeaccounts a on a.referencenumber = d.number

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
      ,isnull(convert(varchar(8),p.dob,112),'19000101') as [DOB]
      ,p.[MaritalStatus]
      ,p.[EmployerName]
      ,p.[WorkPhone]
      ,p.[PatientRecNumber]
      ,p.[GuarantorRecNumber]
      ,isnull(convert(varchar(8),p.AdmissionDate,112),'19000101') as [AdmissionDate]
      ,isnull(convert(varchar(8),p.ServiceDate,112),'19000101') as [ServiceDate]
      ,isnull(convert(varchar(8),p.DischargeDate,112),'19000101') as [DischargeDate]
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
      ,p.[KinPhone]
      
  FROM [PatientInfo] p WITH (NOLOCK)
	JOIN #placeaccounts a on a.referencenumber = p.AccountID

end
else
begin
SELECT top 0
		p.[AccountID] as file_number
      ,p.[Name]
      ,p.[Street1]
      ,p.[Street2]
      ,p.[City]
      ,p.[State]
      ,p.[ZipCode]
      ,p.[Country]
      ,p.[Phone]
      ,rtrim(ltrim(replace(replace(p.SSN,'-',''),' ',''))) as SSN
      ,p.[Sex]
      ,p.[Age]
      ,isnull(convert(varchar(8),p.[DOB],112),'19000101') as DOB
      ,p.[MaritalStatus]
      ,p.[EmployerName]
      ,p.[WorkPhone]
      ,p.[PatientRecNumber]
      ,p.[GuarantorRecNumber]
      ,isnull(convert(varchar(8),p.[AdmissionDate],112),'19000101') as AdmissionDate
      ,isnull(convert(varchar(8),p.[ServiceDate],112),'19000101') as ServiceDate
      ,isnull(convert(varchar(8),p.[DischargeDate],112),'19000101') as DischargeDate
      ,p.[FacilityName]
      ,p.[FacilityStreet1]
      ,p.[FacilityStreet2]
      ,p.[FacilityCity]
      ,p.[FacilityState]
      ,p.[FacilityZipCode]
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
      ,p.[KinZipCode]
      ,p.[KinCountry]
      ,p.[KinPhone]
		
      
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
      ,isnull(convert(varchar(8),[InsuredBirthday],112),'19000101') as [InsuredBirthday]
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
SELECT 
		top 0
      [Number] as file_number
	  ,[InsuranceId] as insurance_id
      ,[InsuredName]
      ,[InsuredStreet1]
      ,[InsuredStreet2]
      ,[InsuredCity]
      ,[InsuredState]
      ,[InsuredZip]
      ,[InsuredPhone]
      ,isnull(convert(varchar(8),[InsuredBirthday],112),'19000101') as InsuredBirthday
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
      ,[CarrierZip]
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
      ,[RecoveredDate]
       ,CASE isnull([Commissionable],0) WHEN 0 THEN 'F' WHEN 1 THEN 'T' ELSE 'F' END as [Commissionable]
      ,[WhenLoaded]
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
      ,[Val]
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
      ,[RecoveredDate]
      ,[Commissionable]
      ,[WhenLoaded]
      ,[UID] as equipment_id
      ,'' as Filler
  FROM [PBEquipment] e WITH (NOLOCK)
		join #placeaccounts a on a.referencenumber = e.number
end

IF (@sendassets = 'True')
BEGIN
SELECT 
'CAST' as record_type,
da.DebtorID as [debtor_number],
da.AccountID as [file_number],
da.ID as [asset_id],
da.Name as [asset_name],
da.Description as [asset_description],
ISNULL(da.CurrentValue,0) as [asset_value],
ISNULL(da.LienAmount,0) as [asset_lien_value],
CASE da.ValueVerified WHEN 0 THEN 'F' ELSE 'T' END as [asset_value_verified_flag],
CASE da.LienVerified WHEN 0 THEN 'F' ELSE 'T' END as [asset_lien_value_verified_flag]
FROM [Debtor_Assets] da WITH (NOLOCK) JOIN #placeaccounts a on da.AccountID = a.referencenumber

END
ELSE
BEGIN
SELECT TOP 0
'CAST' as record_type,
da.DebtorID as [debtor_number],
da.AccountID as [file_number],
da.ID as [asset_id],
da.Name as [asset_name],
da.Description as [asset_description],
ISNULL(da.CurrentValue,0) as [asset_value],
ISNULL(da.LienAmount,0) as [asset_lien_value],
CASE da.ValueVerified WHEN 0 THEN 'F' ELSE 'T' END as [asset_value_verified_flag],
CASE da.LienVerified WHEN 0 THEN 'F' ELSE 'T' END as [asset_lien_value_verified_flag]
FROM [Debtor_Assets] da WITH (NOLOCK) JOIN #placeaccounts a on da.AccountID = a.referencenumber

END


IF(@sendjudgments = 'True')
BEGIN
SELECT
	  'CJDG' as record_type
	  ,cc.AccountID as [file_number]
      ,CASE cc.Judgement WHEN 0 THEN 'F' ELSE 'T' END AS [HasJudgement]
      ,[CaseNumber]
      ,[JudgementAmt]
	  ,[JudgementIntAward]
      ,[JudgementCostAward]
	  ,[JudgementAttorneyCostAward]
      ,[JudgementOtherAward]
      ,[JudgementIntRate]
	  ,[IntFromDate]
	  ,[AttorneyAckDate]
	  ,[DateFiled]
	  ,[ServiceDate]
      ,[JudgementDate]
	  ,[JudgementRecordedDate]
	  ,[DateAnswered]
      ,[StatuteDeadline]
      ,[CourtDate]
      ,[DiscoveryCutoff]
      ,[DiscoveryReplyDate]
      ,[MotionCutoff]
      ,[ArbitrationDate]
      ,[LastSummaryJudgementDate]
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
      ,CASE cc.Judgement WHEN 0 THEN 'F' ELSE 'T' END AS [HasJudgement]
      ,[CaseNumber]
      ,[JudgementAmt]
	  ,[JudgementIntAward]
      ,[JudgementCostAward]
	  ,[JudgementAttorneyCostAward]
      ,[JudgementOtherAward]
      ,[JudgementIntRate]
	  ,[IntFromDate]
	  ,[AttorneyAckDate]
	  ,[DateFiled]
	  ,[ServiceDate]
      ,[JudgementDate]
	  ,[JudgementRecordedDate]
	  ,[DateAnswered]
      ,[StatuteDeadline]
      ,[CourtDate]
      ,[DiscoveryCutoff]
      ,[DiscoveryReplyDate]
      ,[MotionCutoff]
      ,[ArbitrationDate]
      ,[LastSummaryJudgementDate]
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


		update 	AIM_accounttransaction with (rowlock) 
			set transactionstatustypeid = 2 
		from 
			AIM_accounttransaction att
			join #placeaccounts a on a.accountreferenceid = att.accountreferenceid
		where
			transactiontypeid = 1 
			and transactionstatustypeid = 1 
			and agencyid = @agencyId

end

GO
