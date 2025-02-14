SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




--select id as Id, name as GroupName from customcustgroups
--select CustomerId from fact where CustomGroupId is not null
--select top 5 name,* from debtors
-- =============================================
-- Author:		Ibrahim Hashimi
-- ALTER  date: 01/30/2006
-- Description:	
-- =============================================
/*
Exec Custom_ReportSherman_Ex2 @startDate='20060101', @endDate='20060130',@customer='Arrow'
Exec Custom_ReportSherman_SUF @custGroupId=24
select top 4 * from debtors
*/
CREATE       PROCEDURE [dbo].[Custom_ReportSherman_SUF]
	@CustGroupId int
--	@startDate as DateTime,
--	@endDate as DateTime,
--	@customer as varchar(7)
AS
BEGIN
	SET NOCOUNT ON;

	--get all debtors that belong to this CustomerGroup
	Select
		m.number			as [number],
		(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'ACCTID')				as [AcctId],
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
		[dbo].[StripNonDigits] (d.Zipcode)				as [Zip],
		d.dob								as [Dob],
		[dbo].[StripNonDigits] (d.HomePhone)				as [HomePhone],
		[dbo].[StripNonDigits] (d.WorkPhone)				as [WorkPhone],
		''								as [OtherPhone],	--should we put anything here?
		'0'								as [LangCode],		--0=English
		''								as [BankName],		--what goes here?
		case(d.JobName)
			when null then	'UE'
			else 'FT'
		end								as [Employeed],
		'N'								as [VerifiedHomeOwner],	--Y=verified N=not-verified
		'end'
	From Debtors d with (nolock)
	Join Master m with (nolock) on m.number=d.number
	where --m.customer='0001401'
	m.customer in (select CustomerId from Fact with (nolock) where CustomGroupId=@custGroupId)and 
	m.returned is null and (m.closed > '20070201' or m.closed is null) and d.seq = 0
	
	select d.number as [Number], count(*) as [NumCount] 
	From Debtors d with (nolock)
	Join Master m with (nolock) on m.number=d.number
	where --m.customer='0001401'
	m.customer in (select CustomerId from Fact with (nolock) where CustomGroupId=@custGroupId) and 
	m.returned is null and (m.closed > '20070201' or m.closed is null) and d.seq = 0
	group by d.number 
--END

-- *************** get the balance info here ************************************************
	--get all debtors that belong to this CustomerGroup
	Select
		m.number			as [number],
		(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'ACCTID')				as [AcctId],
		m.account			as [AccountNumber],
		m.Current1			as [PrinBal],
		m.Current2			as [IntBal],				--is this right?
		m.Current3			as [CostBal],				--is this right?
		m.Current4			as [FeeBal],				--is this right?
		m.Clidlp			as [LastPayDate],
		0.0				as [LastPayAmount]			--how to determine?
	From master m with (nolock)--From Debtors d with (nolock)
	--Join Master m with (nolock) on m.number=d.number
	where 
	--m.customer='0001401'
	m.customer in (select CustomerId from Fact with (nolock) where CustomGroupId=@custGroupId) and
	m.returned is null and (m.closed > '20070201' or m.closed is null)
	group by m.number,m.account,m.Current1,m.Current2,m.Current3,m.Current4,m.Clidlp	
	
-- *************** get the bankruptcy info here ************************************************
	Select	m.number		as [number],
			(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'ACCTID')			as [AcctId],
			m.account			as [AccountNumber],
			ban.chapter		as [Chapter],
			ban.CaseNumber	as [CaseNumber],
			ban.DateFiled	as [FileDate],
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
						When ban.DischargeDate is null then ban.DateFiled
						Else ban.DischargeDate
					End
				Else ban.DateFiled
			End				as [BkStatusDate],
			ban.DismissalDate	as [DismissDate],
			ban.DischargeDate	as [DischargeDate],
			ban.DateFiled		as [DateFiled],
			'bankruptcy end'
	From Master m with (nolock)
	Join Debtors d with (nolock) on d.number=m.number
	Join Bankruptcy ban with (nolock) on ban.debtorid=d.debtorid	
	where 
	--m.customer='0001401'
	m.customer in (select CustomerId from Fact with (nolock) where CustomGroupId=@custGroupId)
	and ban.debtorid is not null and m.returned is null	--is this right?

-- *************** get the bankruptcy info here ************************************************
	Select	dec.AccountId		as [number],
			(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'ACCTID')				as [AcctId],
			m.account			as [AccountNumber],
			Case
				When m.seq=0 Then '01'
				Else '02'
			End					as [BorwerType],
			dec.Dod				as [DateOfDeath],
	'dec end'
	From Deceased dec with (nolock)
	Join Master m with (nolock) on m.number=dec.AccountId
	Join Debtors d with (nolock) on d.number=m.number and d.debtorid=dec.debtorid
	where 
	--m.customer='0001401'
	m.customer in (select CustomerId from Fact with (nolock) where CustomGroupId=@custGroupId)
	and dec.AccountId is not null and m.returned is null

-- *************** get the WOR info here ************************************************

	Select	m.number						as [number],
			(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'ACCTID')							as [AcctId],
			m.account			as [AccountNumber],
			dbo.GetShermanStatus(m.status)	as [Status],
			0								as [CloseAndReturn],		--TODO: How to know this?
			Case
				When specialnote is not null then specialnote
				Else '0.5000'
			End								as [CommRate],				--TODO: Get from MiscExtra if possible
			''								as [OtherAssets],			--TODO: Find this info?
			(
				Select top 1 letter.DateProcessed 
				From LetterRequest letter with (nolock)
				Where letter.AccountId = m.number
				Order by DateProcessed desc
			)								as [LastLetterDate],
			(
				Select top 1 note.created
				From notes note with (nolock)
				Join Result res on res.code=note.result
				Where note.number=m.number and res.worked=1
			)								as [LastCallDate],			--TODO: Update these codes

			''								as [LastSkipDate],			--TODO: What to put here?
			Case
			    when exists (select * from LetterRequest where LetterCode='00051' and AccountId=m.number)
			   	Then (select top 1 DateProcessed from LetterRequest with (nolock) where LetterId='00051' and DateProcessed is not null
				      order by DateProcessed desc )
			    Else ''
			End								as [LastGLBNoticeDate],
			''								as [LastGLBNoticeDate2],		--TODO: What to put here?
	'wor end'
	From master m with (nolock)
	where 
	--m.customer='0001401'
	m.customer in (select CustomerId from Fact with (nolock) where CustomGroupId=@custGroupId) and
	m.returned is null and (m.closed > '20070201' or m.closed is null)

	Select	m.number			as [number],
			(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'ACCTID')				as [AcctId],
			m.account			as [AccountNumber],
			cccs.CompanyName	as [AgencyName],
			cccs.Phone			as [AgencyPhone],
			''					as [ProposalDate],			--TODO: We don't know this info
			''					as [ProposalPmt],			--TODO: We don't have this info
			'end cccs'
	From CCCS cccs with (nolock)
	Join Debtors d with (nolock) on d.debtorid=cccs.debtorid
	Join Master m with (nolock) on m.number=d.number
	where 
	--m.customer='0001401'
	m.customer in (select CustomerId from Fact where CustomGroupId=@custGroupId)
	and cccs.debtorid is not null
	and m.Qlevel NOT IN('999') AND  
	(m.status IN('B07','B11','B13','BKY','DEC','ATY','CCC','CND','PDC','PPA','HOT','BRK','PTP','VDS','DSP') OR
	((m.status IN('PIF','SIF') AND lastpaid IS NOT NULL AND m.lastpaid <=getdate()-30)))	
END
GO
