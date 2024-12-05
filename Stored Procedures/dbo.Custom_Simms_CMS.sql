SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE                          PROCEDURE [dbo].[Custom_Simms_CMS]
	@startDate datetime,
	@endDate datetime,
	@customer varchar(8000)

AS
BEGIN
	set @endDate=@endDate+1
			Declare @theCustomers Table (
				[ID] [int] IDENTITY(1,1) NOT NULL,
				Customer varchar(7)
			)
			
			Insert into @theCustomers(customer)
			Select string from dbo.CustomStringToSet(@customer,'|')

			DECLARE @tmpcms_count TABLE(
			[ID] [int] IDENTITY(1,1) NOT NULL,
			[number] [int] NOT NULL)

			INSERT INTO @tmpcms_count (number)
			SELECT DISTINCT AccountID from AddressHistory a with (nolock)
			JOIN master m with (nolock)
			ON m.Number=a.AccountId
			WHERE a.DateChanged BETWEEN @startDate AND @endDate
			AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))

			INSERT INTO @tmpcms_count (number)
			SELECT DISTINCT AccountID from PhoneHistory p with (nolock)
			JOIN master m with (nolock)
			ON m.Number=p.AccountId
			WHERE p.DateChanged BETWEEN @startDate AND @endDate
			AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))

			DECLARE @tmpcms_payment TABLE(
			[ID] [int] IDENTITY(1,1) NOT NULL,
			[number] [int] NOT NULL,
			[amount] [money] NULL)

			INSERT INTO @tmpcms_payment (number,amount)
			SELECT number,sum(case when batchtype in ('PAR','PCR','PUR') THEN (-1*totalpaid) ELSE totalpaid END)
			FROM payhistory with(nolock)
			WHERE customer in (select string from dbo.CustomStringToSet(@customer, '|'))
			GROUP BY number

			DECLARE @tmpcms_close TABLE(
			[ID] [int] IDENTITY(1,1) NOT NULL,
			[number] [int] NOT NULL,
			[amount] [money] NULL)


			INSERT INTO @tmpcms_close (number,amount)
			SELECT m.number,current0
			FROM master m with(nolock)
			WHERE m.status in ('DEC','CCC','CAD','B07','B13','BKY')
			and m.customer in (select string from dbo.CustomStringToSet(@customer, '|')) and m.returned is null
			and m.closed between @startdate and @enddate
			GROUP BY m.number,m.current0

			INSERT INTO @tmpcms_close (number,amount)
			SELECT m.number,(select sum(dbo.Custom_CalculatePaymentTotalPaid (p.uid)) from payhistory p with(nolock) where p.number = m.number and p.datepaid between (m.lastpaid - 90) and m.lastpaid) --changed to reflect the 90 days prior to date last paid was 
			FROM master m with(nolock)
			WHERE m.status in ('PIF','SIF')
			and m.closed < (@startdate - 30) and m.returned is null and m.qlevel = '998'
			and m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
			GROUP BY m.number,m.current0, m.lastpaid

DECLARE @tmpcms TABLE(
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[number] [int] NOT NULL
)

INSERT INTO @tmpcms (number)
	SELECT DISTINCT AccountID from AddressHistory a
	JOIN master m with (nolock)
	ON m.Number=a.AccountId
	WHERE a.DateChanged BETWEEN @startDate AND @endDate
	AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))

insert into @tmpcms (number)
	SELECT DISTINCT AccountID from PhoneHistory p
	JOIN master m with (nolock)
	ON m.Number=p.AccountId
	WHERE p.DateChanged BETWEEN @startDate AND @endDate
	AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))


SELECT DISTINCT --Header Record
	--RecordCode
	--Filler
	getdate() AS [Date],
	--Type=1
	--SourceCode=1
	m.customer,
	case 
		when m.customer='0000511' then 'AL0125'
		when m.customer='0000627' then 'AL0204'
		when m.customer='0000591' then 'AL0171'
		when m.customer='0000619' then 'AL0200'
		when m.customer='0000633' then 'AL0217'
		when m.customer='0000676' then 'AL0283'
		when m.customer='0000644' then 'AL0225'
		when m.customer='0000677' then 'AL0284'
		when m.customer='0000896' then 'AL0349'
		when m.customer='0000905' then 'AL0401'
		else ''
	end AS [AgencyCode],
	case
		when m.customer='0000511' then 'SIMM Associates Inc.'
		when m.customer='0000627' then 'SIMM Associates Inc.'
		when m.customer='0000591' then 'SIMM Associates Inc.'
		when m.customer='0000619' then 'SIMM Associates Inc.'
		when m.customer='0000633' then 'SIMM Associates Inc.'
		when m.customer='0000676' then 'SIMM Associates Inc.'
		when m.customer='0000644' then 'SIMM Associates Inc.'
		when m.customer='0000677' then 'SIMM Associates Inc.'
		when m.customer='0000896' then 'SIMM Associates Inc.'
		when m.customer='0000905' then 'SIMM Associates Inc.'
		else ''
	end AS [AgencyName],
	--Rec1
	'0' AS [NumRec1],
	'0' AS [TotalPay],
	--Rec2
	'0' AS [NumRec2],
	'0' AS [TotalCost],
	--Rec3
	'0' AS [NumRec3],
	--Rec4
	(	select count(m.number) 
		FROM @tmpcms_close t
		LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
		WHERE m.closed between @startDate AND @endDate
		AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
		AND m.status in ('SIF','PIF','DEC','CCC','CAD','B07','B13','BKY')
	)
		AS [NumRec4],
	--Rec5
	(
		select count(distinct m2.number) 
		FROM @tmpcms_count t 
		JOIN master m2 with (nolock) ON m2.Number=t.Number 
		left JOIN CourtCases c with (nolock) ON m2.Number=c.AccountID 
		left JOIN Courts ct with (nolock) ON c.CourtID=ct.CourtID
		where m2.customer=m.customer 
	)
		AS [NumRec5],
	--Filler
	case
		when m.customer='0000511' then '05242'
		when m.customer='0000627' then '05242'
		when m.customer='0000591' then '06070'
		when m.customer='0000619' then '06070'
		when m.customer='0000633' then '06070'
		when m.customer='0000676' then '06070'
		when m.customer='0000644' then '06488'
		when m.customer='0000677' then '06488'
		when m.customer='0000896' then '06112'
		when m.customer='0000905' then '05625'
	end AS [BankID]
	--Fills
FROM master m with (nolock)
left outer JOIN @tmpcms_count t ON m.number=t.number
left outer JOIN @tmpcms_payment t1 ON m.number=t1.number
left outer join @tmpcms t2 ON t2.number = m.number
left outer join @tmpcms_close t3 ON t3.number = m.number
where m.customer in (select string from dbo.CustomStringToSet(@customer, '|')) and m.customer is not null

(
SELECT 
	'4' AS [RecordCode],
	m.closed as [Date],--n.created as [Date],
	case 
		when m.status like 'B%' then 'BUN'
		when m.status='DEC' AND exists(select DOD from Deceased with (nolock) where AccountId=m.number) then 'DEC'
		when m.status='DEC' then 'DUN'
		when m.status='CAD' then 'DNC'
		when m.status='CCC' then 'PCC'
		when m.status='SIF' then 'SIF'
		when m.status='PIF' then 'PIF'
		ELSE ''
	END AS [NoteCode],--outgoing note code
	
	'' AS [Narrative1],
	'' AS [Narrative2],
	m.id2 AS [FirstDataAcct],
	m.account AS [AccountID]

FROM @tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
WHERE m.status in ('DEC','CCC','CAD','B07','B13','BKY')
AND m.returned is null and m.qlevel = '998'
)
union all
(SELECT 
	'4' AS [RecordCode],
	(m.closed + 30) as [Date],--n.created as [Date],
	case 
		when m.status like 'B%' then 'BKY'
		when m.status='DEC' AND exists(select DOD from Deceased with (nolock) where AccountId=m.number) then 'DEC'
		when m.status='DEC' then 'DUN'
		when m.status='CAD' then 'DNC'
		when m.status='CCC' then 'PCC'
		when m.status='SIF' then 'SIF'
		when m.status='PIF' then 'PIF'
		ELSE 'PTP'
	END AS [NoteCode],--outgoing note code
	CASE 	WHEN m.status = 'PIF' THEN 'PAID IN FULL RECEIVED'
		WHEN m.status = 'SIF' THEN ('BAL AT TIME OF SIF: '+
				rtrim(ltrim(cast(str((isnull(t.amount,0) + m.current0),9,0) as varchar(11))))+
				' SIF%: '+
				rtrim(ltrim(cast(str((100*((isnull(t.amount,0))/(isnull(t.amount,0) + m.current0))),9,0) as varchar(11))))+
				' SIF TOTAL: '+
				rtrim(ltrim(cast(str(isnull(t.amount,0),9,0) as varchar(11))))+
				' BAL AFTER SIFF: '+
				rtrim(ltrim(cast(str(m.current0,9,0) as varchar(11)))))
		ELSE ''
	END AS [Narrative1],
	'' AS [Narrative2],
	m.id2 AS [FirstDataAcct],
	m.account AS [AccountID]
FROM @tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
WHERE m.status in ('PIF','SIF')
and m.closed < (@startdate - 30) and m.returned is null and m.qlevel = '998'
)

--------Account Master

SELECT DISTINCT
m.customer as [Customer],
'5' AS [RecordCode], 
getdate() AS [Date],
'1'		AS [Type],
'1'		AS [SourceCode],
'M'		AS [NameType],
'U'		AS [Function],
m.Name,
m.Street1,
m.Street2,
m.City,
substring(m.State, 1, 2) as State,
m.Zipcode,
m.HomePhone,
case when c.DateUpdated BETWEEN @startDate AND @endDate then c.JudgementAmt else 0 END AS [JudgeAmount],
case when c.DateUpdated BETWEEN @startDate AND @endDate then c.JudgementDate else '        ' END   AS [JudgeDate] ,
case when c.DateUpdated BETWEEN @startDate AND @endDate then c.Remarks else '' END AS [JudgeReference] ,
case when c.DateUpdated BETWEEN @startDate AND @endDate then c.JudgementIntRate else '' END AS [IntRate],
case when c.DateUpdated BETWEEN @startDate AND @endDate then c.intFromDate else '        ' END AS [IntStartDate],
case when c.DateUpdated BETWEEN @startDate AND @endDate then ct.County else 0 END AS [JudgeCounty],
case when c.DateUpdated BETWEEN @startDate AND @endDate then ct.CourtName else 0 END AS [JudgeCourt],
'' AS [JudgeSheriff],
case when c.DateUpdated BETWEEN @startDate AND @endDate then c.JudgementAmt else 0 END AS [JudgePrin],
case when c.DateUpdated BETWEEN @startDate AND @endDate then c.JudgementOtherAward else 0 END AS [JudgeOtherInc],
case when c.DateUpdated BETWEEN @startDate AND @endDate then c.JudgementIntAward else 0 END AS [JudgeInt],
case when c.DateUpdated BETWEEN @startDate AND @endDate then c.JudgementCostAward else 0 END AS [JudgeCost],
'' AS [Collector],
'' AS [DocketNumber],
m.id1,
m.account

FROM @tmpcms t
JOIN master m with (nolock)
ON m.Number=t.Number
left JOIN CourtCases c with (nolock)
ON m.Number=c.AccountID
left JOIN Courts ct with (nolock)
ON c.CourtID=ct.CourtID
END

insert into notes(number,created,user0,action,result,comment)
select m.number,getdate(),'EXCH_SP','+++++','+++++','Account was Returned to customer in a file'
FROM @tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.numberWHERE m.status in ('DEC','CCC','CAD','B07','B13','BKY')
AND m.returned is null and m.qlevel = '998'
and m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))


update master set qlevel = '999', returned = getdate()
FROM @tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.numberWHERE m.status in ('DEC','CCC','CAD','B07','B13','BKY')
AND m.returned is null and m.qlevel = '998'
and m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))


insert into notes(number,created,user0,action,result,comment)
select m.number,getdate(),'EXCH_SP','+++++','+++++','Account was Returned to customer in a file'
FROM @tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
WHERE m.status in ('PIF','SIF')
and m.closed < (@startdate - 30) and m.returned is null and m.qlevel = '998'
and m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))


update master set qlevel = '999', returned = getdate()
FROM @tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
WHERE m.status in ('PIF','SIF')
and m.closed < (@startdate - 30) and m.returned is null and m.qlevel = '998'
and m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
GO
