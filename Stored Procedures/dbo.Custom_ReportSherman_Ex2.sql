SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









-- =============================================
-- Author:		Ibrahim Hashimi
-- ALTER  date: 01/30/2006
-- Description:	
-- =============================================
/*
Exec Custom_ReportSherman_Ex2 @startDate='20060312', @endDate='20060327',@customer='0001401'
*/
CREATE        PROCEDURE [dbo].[Custom_ReportSherman_Ex2]
	@startDate as DateTime,
	@endDate as DateTime,
	@customer as varchar(8000)
AS
BEGIN
	SET NOCOUNT ON;

	--we need to find all the accounts with these status codes in this date range:
	--	B07,B13,BKY
	--	DEC, PIF, SIF,

	Select		'1873'		as [ServicerId],		--***** Needs updating ********--
			m.number		as [Number],
			--d.number		as [ShermanId],		--***** Needs updating ********--
			(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'ACCTID')			as [ShermanId],
			m.account		as [Account],
			d.Street1		as [Street1],
			d.Street2		as [Street2],
			d.City			as [City],
			d.State			as [State],
			d.Zipcode		as [Zipcode],
			d.homephone		as [Phone],
			d.Dob			as [Dob],
			m.Current1		as [PrinBal],			--is this right?
			m.Current2		as [InterestBal],		--is this right?
			m.clidlp		as [LastPayDate],		--is this right?
			m.lastinterest	as [IntEffectiveDate],	--****how to determine this?
			isnull(m.specialnote,'')		as [CommissionRate],
--			(select top 1 TheData from MiscExtra with (nolock) 
--				where number=m.number and Title='Commission Rate'
--			) as [CommissionRate],
			Case(m.status)
				when 'B07' then 'BAN'
				WHEN 'B11' THEN 'BAN'
				when 'B13' then 'BAN'
				when 'BKY' then 'BAN'
				when 'DEC' then 'DEC'
				when 'PIF' then 'PIF'
				when 'SIF' then 'SIF'
				when 'AEX' then 'AEX'
				when 'EXH' then 'AEX'
				WHEN 'ATY' then 'ATT'
				WHEN 'CCC' THEN 'CCC'
				WHEN 'CND' THEN 'CDR'
				WHEN 'PDC' THEN 'PDC'
				WHEN 'PIF' THEN 'PIF'
				WHEN 'PPA' THEN 'PPA'
				WHEN 'HOT' THEN 'PRM'
				WHEN 'BRK' THEN 'PRM'
				WHEN 'PTP' THEN 'PRM'
				WHEN 'RTP' THEN 'PTP'
				WHEN 'SIF' THEN 'SIF'
				WHEN 'SKP' THEN 'SKP'
				WHEN 'UTL' THEN 'SKP'
				WHEN 'VDS' THEN 'DIS'
				WHEN 'DSP' THEN 'WDS'
				else 'ACT'
			End				as [Status],

	--******** BEGIN UNKNOWN REGION
			cccs.Companyname			as [CcaAgency],
			null						as [CcaProposedPmt],	--*** Update
			cccs.[AcceptedAmount]		as [CcaStartBal],		--*** Update
			cccs.Phone					as [CcaPhone],
			ban.chapter					as [Chapter],
			ban.CaseNumber				as [CaseNum],
			ban.DateFiled				as [LawsuitFileDate],
			ban.CourtState				as [StateFiled],
			ban.DateFiled				as [FileDate],			--diff between this and LawsuitFileDate?
			ban.DismissalDate			as [DismissDate],
			null						as [JudgementDate],		--how to determine this?
			null						as [Assets],			--how to determine this?
			ban.DischargeDate			as [DischargeDate],
			null						as [BarDate],			--how to determine this?
			null						as [CourtID],			--what is CourtID?
			ban.Trustee					as [Trustee],
			dec.Dod						as [DateOfDeath],
			
			Case(m.status)
				when 'PIF' then 'Y'
				when 'SIF' then 'Y'
				when 'CND' then 'Y'
				else 'N'
			End						as [FileClosed],		--check this qlevel < 998?
			null						as [JudgementAmount],	--how to determine this?
			atty.Name					as [AttyName],
			atty.Street1				as [AttyAddress],
			atty.City					as [AttyCity],	
			atty.State					as [AttyState],
			atty.Zipcode				as [AttyZipcode],
			atty.Phone					as [AttyPhone],
			m.number				as [Number],
			m.feecode				as [feecode],
			m.customer				as [Customer]
	From Debtors d with (nolock)
	Join Master m with (nolock) on m.number=d.number
	left join CCCS cccs with (nolock) on cccs.debtorid=d.number
	left join Bankruptcy ban with (nolock) on ban.Debtorid=d.number
	left join Deceased dec with (nolock) on dec.debtorid=d.number
	left join Attorney atty with (nolock) on atty.AttorneyId=m.attorney
	left join Customer c with (nolock) on c.customer=m.customer
	left join FeeScheduleDetails fsd with (nolock) on fsd.code=c.customer--m.feecode
	where d.seq=0 --m.status in ('B07','B13','BKY','DEC','PIF','SIF') and d.seq=0
	and m.qlevel<'999'
	and m.customer in (select string from dbo.CustomStringToSet(@customer,'|'))
	and m.received between @startDate and @endDate
END

/*
select top 5 feecode,lastinterest,* from master
select top 5 CollectorFeeSchedule,* from customer
select top 5 paidentifier,* from PayHistory
select top 5 * from customer
select Column_Name,Table_Name from Information_Schema.Columns where Column_Name like '%fee%' and TABLE_NAME='Customer' order by Column_Name
select Column_Name,Table_Name from Information_Schema.Columns where TABLE_NAME='PayHistory' order by Column_Name
select disticnt tablename from InformationSchema.Columns
select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME like '%fee%'
select top 5 * from FeeScheduleDetails

Select count(*) From Master m
Join debtors d on d.number=m.number
Where m.qlevel <'999' and m.customer='0001401'

Select count(*) From Debtors d
Join Master m on m.number=d.number
	left join CCCS cccs with (nolock) on cccs.debtorid=d.number
	left join Bankruptcy ban with (nolock) on ban.Debtorid=d.number
	left join Deceased dec with (nolock) on dec.debtorid=d.number
	left join Attorney atty with (nolock) on atty.AttorneyId=m.attorney
	left join FeeScheduleDetails fsd on fsd.code=m.feecode
Where d.seq=0 and m.customer='0001401' and m.qlevel<'999'
*/









GO
