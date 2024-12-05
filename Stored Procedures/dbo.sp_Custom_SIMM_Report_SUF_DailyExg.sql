SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:	Kevin A. Roiz
-- Created  Date: 04/19/2009
-- Description: This proc generates the DAILY SUF file 
-- for SIMM. This is the original version created by Ibrahim
-- Hashimi but has been adjusted to be named according to our
-- naming convention. 
-- 02/18/2010 - KAR modified to handle KPI records.
-- 02/24/2010 - No date range should be specified for the KPI records.
-- 04/26/2010 - Brian Meehan - Added code to strip non-digits from the CCCS phone numbers and also to remove the 1 before phone numbers.
-- 06/21/2010 - KAR Modified to send PDC records.
-- 07/14/2010 - BGM (Simm) Hard coded customer 1121 to always send DEC status if active on our end as required by Resurgent.

-- =============================================

-- exec sp_custom_simm_report_suf_exg 24

CREATE PROCEDURE [dbo].[sp_Custom_SIMM_Report_SUF_DailyExg]
	@CustGroupId int
AS
BEGIN


	SET NOCOUNT ON;
	--FHD setup
	SELECT CONVERT(VARCHAR, GETDATE(), 101) + ' ' + REPLACE(CONVERT(VARCHAR, GETDATE(), 108), ':', '.') AS date, 
		ROUND(RAND() * 10000000000, 0) AS fileid
							/*
							--RHD for BWR Not Needed
							select TOP 1 count(*) as NumCount 
							From Debtors d with (nolock)
							Join Master m with (nolock) on m.number=d.number and d.seq = 0
							where m.customer in (select CustomerId from Fact with (nolock) where CustomGroupId=@custGroupId) 
							and m.Qlevel NOT IN('999') 
							group by d.number 
							*/

	--BWR Records
	
	--RHD BWR account count
	SELECT COUNT(*) AS NumAccts
	From Debtors d with (nolock)
	Join Master m with (nolock) on m.number=d.number and d.seq = 0
	WHERE m.customer in (select CustomerId from Fact with (nolock) where CustomGroupId=@custGroupId) 
	and m.Qlevel NOT IN('999')

	
	--get all debtors that belong to this CustomerGroup
	SELECT 
		m.number			as [number],
		(Select top 1 TheData from MiscExtra with (nolock) where number = m.number and Title = 'ACCTID') as [AcctId],
		m.account			as [AccountNumber],
		Case
			When d.seq=0 then '01'
			Else '02'
		End					as [BorwerType],
		replace(d.ssn,'-','')			as [Ssn],
		dbo.CustomGetFirstName(d.name)	as [FirstName],
		dbo.CustomGetLastName(d.name)	as [LastName],
		d.Street1							as [Street1],
		d.Street2							as [Street2],
		d.City								as [City],
		d.State								as [State],
		replace(d.Zipcode, '-', '')				as [Zip],
		'0' AS WrongContactAddress,
		CONVERT(VARCHAR, d.dob, 101)								as [Dob],
		SUBSTRING([dbo].[StripNonDigits] (d.HomePhone), 0, 10)				as [HomePhone],
		'0' AS WrongContactHomePhone,
		SUBSTRING([dbo].[StripNonDigits] (d.WorkPhone), 0, 10)				as [WorkPhone],
		'0' AS WrongContactWorkPhone,
		''								as [OtherPhone],	--should we put anything here?
		'0' AS WrongContactOtherPhone,
		'0'								as [LangCode],		--0=English
		''								as [BankName],		--what goes here?
		case(d.JobName)
			when null then	'UE'
			else 'FT'
		end								as [Employeed],
		'N'								as [VerifiedHomeOwner]	--Y=verified N=not-verified
		
	From Debtors d with (nolock)
	Join Master m with (nolock) on m.number=d.number and d.seq = 0
	where --m.customer='0001401'
	m.customer in (select CustomerId from Fact with (nolock) where CustomGroupId=@custGroupId) 
	and m.Qlevel NOT IN('999')
	
	
--END BWR

-- *************** get the balance info here ************************************************
	--get all debtors that belong to this CustomerGroup
	
	SELECT COUNT(*) AS NumAccts
	From master m with (nolock)--From Debtors d with (nolock)
	--Join Master m with (nolock) on m.number=d.number
	where 
	--m.customer='0001401'
	m.customer in (select CustomerId from Fact with (nolock) where CustomGroupId=@custGroupId) 
	and m.Qlevel NOT IN('999') 

	
	SELECT  
		m.number			as [number],
		(Select top 1 TheData from MiscExtra with (nolock) where number = m.number and Title = 'ACCTID') as [AcctId],
		m.account			as [AccountNumber],
		m.Current1			as [PrinBal],
		m.Current2			as [IntBal],				--is this right?
		m.Current3			as [CostBal],				--is this right?
		m.Current4			as [FeeBal],				--is this right?
		CONVERT(VARCHAR, m.Clidlp, 101)			as [LastPayDate],
		0.0				as [LastPayAmount]			--how to determine?
	From master m with (nolock)--From Debtors d with (nolock)
	--Join Master m with (nolock) on m.number=d.number
	where 
	--m.customer='0001401'
	m.customer in (select CustomerId from Fact with (nolock) where CustomGroupId=@custGroupId) 
	and m.Qlevel NOT IN('999') 
	
-- *************** get the bankruptcy info here ************************************************
	SELECT COUNT(*) AS NumAccts
	From Master m with (nolock)
	Join Debtors d with (nolock) on d.number=m.number
	Join Bankruptcy ban with (nolock) on ban.debtorid=d.debtorid	
	where 
	--m.customer='0001401'
	m.customer in (select CustomerId from Fact with (nolock) where CustomGroupId=@custGroupId)
	and ban.debtorid is not null 
	and m.Qlevel NOT IN('999') AND m.status IN('B07','B11','B13','BKY')

	
	
	Select	m.number		as [number],
			(Select top 1 TheData from MiscExtra with (nolock) where number = m.number and Title = 'ACCTID')			as [AcctId],
			m.account			as [AccountNumber],
			Case
				WHEN ban.chapter = 06  THEN '13'
				WHEN ban.chapter = 52  THEN '07'
				WHEN ban.chapter = 53  THEN '11'
				WHEN ban.chapter = 54  THEN '12'
				ELSE ban.chapter
			END as [Chapter],
			ban.CaseNumber	as [CaseNumber],
			CONVERT(VARCHAR, ban.DateFiled, 101)	as [FileDate],
			Case
				When ban.DismissalDate is null then 
					Case
						When ban.DischargeDate is null then '02'	--02 = Filed
						Else '20'			--20 = Discharged
					End
				Else '15'					--15 = Dismissed
			End				as [BkStatus],

			Case
				When ban.DismissalDate is null then 
					Case
						When ban.DischargeDate is null then CONVERT(VARCHAR, ban.DateFiled, 101)
						Else CONVERT(VARCHAR, ban.DischargeDate, 101)
					End
				Else CONVERT(VARCHAR, ban.DateFiled, 101)
			End				as [BkStatusDate],
			ban.DismissalDate	as [DismissDate],
			ban.DischargeDate	as [DischargeDate],
			ban.DateFiled		as [DateFiled]
	From Master m with (nolock)
	Join Debtors d with (nolock) on d.number=m.number
	Join Bankruptcy ban with (nolock) on ban.debtorid=d.debtorid	
	where 
	--m.customer='0001401'
	m.customer in (select CustomerId from Fact with (nolock) where CustomGroupId=@custGroupId)
	and ban.debtorid is not null 
	and m.Qlevel NOT IN('999') AND m.status IN('B07','B11','B13','BKY')

-- *************** get the deceased info here ************************************************
	SELECT COUNT(*) AS NumAccts
	From Deceased dec with (nolock)
	Join Master m with (nolock) on m.number=dec.AccountId
	Join Debtors d with (nolock) on d.number=m.number and d.debtorid=dec.debtorid
	where 
	--m.customer='0001401'
	m.customer in (select CustomerId from Fact with (nolock) where CustomGroupId=@custGroupId)
	and dec.AccountId is not null and m.returned is null

	
	SELECT 	dec.AccountId		as [number],
			(Select top 1 TheData from MiscExtra with (nolock) where number = m.number and Title = 'ACCTID') as [AcctId],
			m.account			as [AccountNumber],
			Case
				When m.seq=0 Then '01'
				Else '02'
			End					as [BorwerType],
			CONVERT(VARCHAR, dec.Dod, 101)				as [DateOfDeath]
	From Deceased dec with (nolock)
	Join Master m with (nolock) on m.number=dec.AccountId
	Join Debtors d with (nolock) on d.number=m.number and d.debtorid=dec.debtorid
	where 
	--m.customer='0001401'
	m.customer in (select CustomerId from Fact with (nolock) where CustomGroupId=@custGroupId)
	and dec.AccountId is not null and m.returned is null

-- *************** get the WOR info here ************************************************
	SELECT COUNT(*) AS NumAccts
	From master m with (nolock)
	where 
	m.customer in (select CustomerId from Fact with (nolock) where CustomGroupId=@custGroupId)
	and m.Qlevel NOT IN('999')

	
	Select	 m.number						as [number],
			(Select top 1 TheData from MiscExtra with (nolock) where number = m.number and Title = 'ACCTID')							as [AcctId],
			m.account			as [AccountNumber],
			case when m.customer IN ('0001121', '0001134') and status NOT IN ('CLM', 'SIF', 'PIF', 'B07', 'B11', 'B13', 'BKY', 'EXH', 'ATY', 'CCC', 'CND', 'CAD', 'PCC', 'PDC', 'DCC', 'DBD', 'PPA', 'HOT', 'NSF', 'BKN', 'PTP', 'STL', 'SKP', 'UTL', 'VDS', 'NPC', 'DSP') then 'DEC' 
			WHEN m.customer IN ('0001121', '0001134') AND status = 'aex' THEN 'DCF'
				else dbo.GetShermanStatus(m.status) end	as [Status],
			CASE WHEN m.customer IN ('0001121', '0001134') AND status = 'aex' THEN 1 ELSE 0 end	as [CloseAndReturn],		--TODO: How to know this?
			Case
				When specialnote is not null then specialnote
				Else '0.5000'
			End								as [CommRate],				--TODO: Get from MiscExtra if possible
			''								as [OtherAssets],			--TODO: Find this info?
			CONVERT(VARCHAR, (
				Select top 1 letter.DateProcessed 
				From LetterRequest letter with (nolock)
				Where letter.AccountId = m.number
				Order by DateProcessed desc
			), 101)								as [LastLetterDate],
			CONVERT(VARCHAR, (
				Select top 1 note.created
				From notes note with (nolock)
				Join Result res on res.code=note.result
				Where note.number=m.number and res.worked=1
			), 101)								as [LastCallDate],			--TODO: Update these codes

			''								as [LastSkipDate],			--TODO: What to put here?
			Case when datediff(dd, m.received, getdate()) > 365 then

				Case
					when exists (select * from LetterRequest where LetterCode='91' and AccountId=m.number)
			   		Then (select top 1 CONVERT(VARCHAR, DateProcessed, 101) from LetterRequest with (nolock) where LetterId='164' and DateProcessed is not null and AccountId=m.number
						  order by DateProcessed desc)
					Else ''
				end

			Else 

				Case
					when exists (select * from LetterRequest where LetterCode='26' and AccountId=m.number)
			   		Then (select top 1 CONVERT(VARCHAR, DateProcessed, 101) from LetterRequest with (nolock) where LetterId='40' and DateProcessed is not null and AccountId=m.number
						  order by DateProcessed desc)
					Else ''
				End					

			End								as [LastGLBNoticeDate]	
	From master m with (nolock)
	where 
	m.customer in (select CustomerId from Fact with (nolock) where CustomGroupId=@custGroupId)
	and m.Qlevel NOT IN('999')


-- *************** get the CCA info here ************************************************
	SELECT COUNT(*) AS NumAccts
	From CCCS cccs with (nolock)
	Join Debtors d with (nolock) on d.debtorid=cccs.debtorid
	Join Master m with (nolock) on m.number=d.number
	where 
	m.customer in (select CustomerId from Fact where CustomGroupId=@custGroupId)
	and cccs.debtorid is not null
	and m.Qlevel NOT IN('999') 



	Select	m.number			as [number],
			(Select top 1 TheData from MiscExtra with (nolock) where number = m.number and Title = 'ACCTID')				as [AcctId],
			m.account			as [AccountNumber],
			substring(cccs.CompanyName, 1, 30)	as [AgencyName],
			case when substring([dbo].[StripNonDigits] (cccs.Phone), 1, 1) = 1 then substring([dbo].[StripNonDigits] (cccs.Phone), 2, 10) else substring([dbo].[StripNonDigits] (cccs.Phone), 1, 10) end			as [AgencyPhone],
			''					as [ProposalDate],			--TODO: We don't know this info
			''					as [ProposalPmt]			--TODO: We don't have this info
			
	From CCCS cccs with (nolock)
	Join Debtors d with (nolock) on d.debtorid=cccs.debtorid
	Join Master m with (nolock) on m.number=d.number
	where 
	m.customer in (select CustomerId from Fact where CustomGroupId=@custGroupId)
	and cccs.debtorid is not null
	and m.Qlevel NOT IN('999') 



	
	-- ADDED BY KAR on 06/21/2010 NEED TO SEND PDC Record NOW.
	-- PDC Records
	
	
		/*Valid values for PaymentType
		0 = ACH 
		1 = Credit Card 
		2 = Debit Card 
		
		Valid Values for StandardEntryClassCode
		TEL = Telephone Payment 
		WEB = Internet Payment 
		Valid Values for ACHAcctType
		0 = Personal Checking
		1 = Personal Savings 

		Valid Values for CCAcctType
		Visa = Visa 
		MC = Master Card 
		Amex = American Express 
		Disc = Discover
		*/
	--================================================================================================================================================
	SELECT (SELECT COUNT(*) 	FROM DebtorCreditCards dc WITH (NOLOCK)
	INNER JOIN master m WITH (NOLOCK)
	ON m.number = dc.number
	WHERE dc.IsActive = 1 AND DATEDIFF(d,getdate(),dc.depositdate) >= 0
	AND dc.CreditCard IN('0001','0002','0003') AND m.Qlevel NOT IN('999') AND
	m.customer in (select CustomerId from Fact where CustomGroupId=@custGroupId) 
) + (SELECT COUNT(*) 	FROM PDC p WITH (NOLOCK)
	INNER JOIN master m WITH (NOLOCK)
	ON m.number = p.number
	INNER JOIN debtorbankinfo di WITH (NOLOCK)
	ON di.AcctId = m.number
	WHERE p.Active = 1 AND DATEDIFF(d,getdate(),p.deposit) >= 0 AND m.Qlevel NOT IN('999') AND 
	m.customer in (select CustomerId from Fact where CustomGroupId=@custGroupId)
) AS NumAccts
	
	
	select 	m.number	as [number],					
			(Select TOP 1 TheData from MiscExtra with (nolock) where number = m.number and Title = 'ACCTID')				as [AcctId],
			m.Account	as [AccountNumber],
			1			as [PaymentType],
			CONVERT(VARCHAR, dc.depositdate, 101) 	as [PaymentScheduledDate],
			dc.amount		as [PaymentAmount],
			'TEL'			as [StandardEntryClassCode],
			''				as [ACHAccountType],
			''				as [BankRoutingNumber],
			''				as [BankAccountNumber],
			CASE dc.CreditCard
				WHEN '0001' THEN 'Visa'
				WHEN '0002' THEN 'Amex'
				WHEN '0003' THEN 'Disc'
			END 		as [CCAcctType]
	FROM DebtorCreditCards dc WITH (NOLOCK)
	INNER JOIN master m WITH (NOLOCK)
	ON m.number = dc.number
	WHERE dc.IsActive = 1 AND DATEDIFF(d,getdate(),dc.depositdate) >= 0
	AND dc.CreditCard IN('0001','0002','0003') AND m.Qlevel NOT IN('999') AND
	m.customer in (select CustomerId from Fact where CustomGroupId=@custGroupId) 
	

	UNION ALL

	select 	m.number	as [number],					
			(Select TOP 1 TheData from MiscExtra with (nolock) where number = m.number and Title = 'ACCTID')				as [AcctId],
			m.Account	as [AccountNumber],
			0			as [PaymentType],
			CONVERT(VARCHAR, p.deposit, 101) 	as [PaymentScheduledDate],
			p.amount		as [PaymentAmount],
			'TEL'			as [StandardEntryClassCode],
			CASE di.AccountType
				WHEN 'C' THEN '0'
				WHEN 'S' THEN '1'
				ELSE '0'
			END				as [ACHAccountType],
			di.ABANumber	as [BankRoutingNumber],
			di.AccountNumber	as [BankAccountNumber],
			'' as [CCAcctType]
	FROM PDC p WITH (NOLOCK)
	INNER JOIN master m WITH (NOLOCK)
	ON m.number = p.number
	INNER JOIN debtorbankinfo di WITH (NOLOCK)
	ON di.AcctId = m.number
	WHERE p.Active = 1 AND DATEDIFF(d,getdate(),p.deposit) >= 0 AND m.Qlevel NOT IN('999') AND 
	m.customer in (select CustomerId from Fact where CustomGroupId=@custGroupId)
		
	--ALT Record
	SELECT COUNT(*) AS NumAccts
	From Deceased dec with (nolock)
	Join Master m with (nolock) on m.number=dec.AccountId
	Join Debtors d with (nolock) on d.number=m.number and d.debtorid=dec.debtorid
	where 
	--m.customer='0001401'
	m.customer in (select CustomerId from Fact with (nolock) where CustomGroupId=@custGroupId)
	and dec.AccountId is not null and m.returned is NULL AND (dec.CourtDivision <> '' and dec.CourtStreet1 <> '' and dec.CourtPhone <> '')

	
	SELECT 	dec.AccountId		as [number],
			(Select top 1 TheData from MiscExtra with (nolock) where number = m.number and Title = 'ACCTID') as [AcctId],
			m.account			as [AccountNumber],
			'22' AS [AltContactTypeID],
			dec.CourtDivision AS [Name],
			dec.CourtStreet1 AS [Address],
			dec.courtstreet2 AS [Address2],
			dec.CourtCity AS [City],
			dec.CourtState AS [State],
			dec.CourtZipcode AS [Zip],
			'0' AS WrongContactAddress,
			SUBSTRING(REPLACE(dec.CourtPhone, '-', ''), 0, 11) AS [Phone],
			'0' AS WrongContactPhone,
			CONVERT(VARCHAR, m.received, 101) AS [NotificationDate]
	From Deceased dec with (nolock)
	Join Master m with (nolock) on m.number=dec.AccountId
	Join Debtors d with (nolock) on d.number=m.number and d.debtorid=dec.debtorid
	where 
	--m.customer='0001401'
	m.customer in (select CustomerId from Fact with (nolock) where CustomGroupId=@custGroupId)
	and dec.AccountId is not null and m.returned is NULL AND (dec.CourtDivision <> '' and dec.CourtStreet1 <> '' and dec.CourtPhone <> '')



	--PRB Info
	SELECT COUNT(*) AS NumAccts
	From Deceased dec with (nolock)
	Join Master m with (nolock) on m.number=dec.AccountId
	Join Debtors d with (nolock) on d.number=m.number and d.debtorid=dec.debtorid
	where 
	--m.customer='0001401'
	m.customer in (select CustomerId from Fact with (nolock) where CustomGroupId=@custGroupId)
	and dec.AccountId is not null and m.returned is NULL AND m.status = 'clm'

	
	SELECT 	dec.AccountId		as [number],
			(Select top 1 TheData from MiscExtra with (nolock) where number = m.number and Title = 'ACCTID') as [AcctId],
			m.account			as [AccountNumber],
			dec.CaseNumber AS ProbateCaseNumber,
			CONVERT(VARCHAR, dec.DateFiled, 101) AS ProbateFileDate,
			CONVERT(VARCHAR, dec.ClaimDeadline, 101) AS ProbateBarDate
	From Deceased dec with (nolock)
	Join Master m with (nolock) on m.number=dec.AccountId
	Join Debtors d with (nolock) on d.number=m.number and d.debtorid=dec.debtorid
	where 
	--m.customer='0001401'
	m.customer in (select CustomerId from Fact with (nolock) where CustomGroupId=@custGroupId)
	and dec.AccountId is not null and m.returned is NULL AND m.status = 'clm'

		
		
END
GO
