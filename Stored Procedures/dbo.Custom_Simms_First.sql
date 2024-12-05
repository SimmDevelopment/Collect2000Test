SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO










/*
declare @startDate datetime
declare @endDate datetime
declare @customer varchar(8000)

set @startDate='20070208'
set @endDate='20070211'
--set @endDate='12/20/2006 12:15:00'
set @customer='0000905|'
exec Custom_Simms_First @startDate=@startDate,@endDate=@endDate,@customer=@customer
*/
CREATE                        PROCEDURE [dbo].[Custom_Simms_First]
	 @startDate datetime,
	 @endDate datetime,
	 @customer varchar(8000)

AS
BEGIN
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
			SELECT m.number,0
			FROM master m with(nolock)
			WHERE (m.status in ('DEC','CCC','CAD','B07','B13','BKY') or m.qlevel in('018','830','840','998'))
			and m.customer in (select string from dbo.CustomStringToSet(@customer, '|')) and m.returned is null
			and m.closed between @startdate and @enddate
			GROUP BY m.number

			INSERT INTO @tmpcms_close (number,amount)
			SELECT m.number,0
			FROM master m with(nolock)
			WHERE m.status in ('SIF','PIF') 
			and m.customer in (select string from dbo.CustomStringToSet(@customer, '|')) and m.returned is null
			GROUP BY m.number

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
	'SIM' AS [AgencyCode],
	'SIMM Associates Inc.' AS [AgencyName],
	--Rec1
	'0' AS [NumRec1],--(select count(*) FROM PayHistory p with (nolock) JOIN Master m2 with (nolock) ON m2.Number=p.Number WHERE p.datepaid between @startDate AND @endDate AND p.batchtype IN ('PU', 'PA', 'PAR', 'PUR') AND m2.customer=m.customer) /*IN (select string from dbo.CustomStringToSet(@customer, '|')))*/ AS [NumRec1],
	'0' AS [TotalPay],-- (select SUM(dbo.Custom_CalculatePaymentTotalPaid (p.uid)) FROM PayHistory p with (nolock) JOIN Master m2 with (nolock) ON m2.Number=p.Number WHERE p.datepaid between @startDate AND @endDate AND p.batchtype IN ('PU', 'PA', 'PAR', 'PUR') AND m2.customer=m.customer) /*IN (select string from dbo.CustomStringToSet(@customer, '|')))*/ AS [TotalPay],
	--Rec2
	'0' AS [NumRec2],--(select count(*) FROM PayHistory p with (nolock) JOIN master m2 with (nolock) ON m2.Number = p.Number WHERE p.datepaid between @startDate AND @endDate AND m2.customer=m.customer) /*IN (select string from dbo.CustomStringToSet(@customer, '|')))*/ AS [NumRec2],
	'0' AS [TotalCost],--(select SUM(case when p.batchtype='DAR' then (-1*p.totalpaid) else p.totalpaid END) FROM PayHistory p with (nolock) JOIN master m2 with (nolock) ON m2.Number = p.Number WHERE p.datepaid between @startDate AND @endDate AND m2.customer=m.customer )/*IN (select string from dbo.CustomStringToSet(@customer, '|')))*/ AS [TotalCost],
	--Rec3
	'0' AS [NumRec3],
	--(select count(*) FROM PayHistory p with (nolock) JOIN master m with (nolock) ON m.Number = p.Number WHERE p.datepaid between @startDate AND @endDate AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))) AS [NumRec3],
	--(select SUM(case when p.batchtype='DAR' then (-1*p.totalpaid) else p.totalpaid END) FROM PayHistory p with (nolock) JOIN master m with (nolock) ON m.Number = p.Number WHERE p.datepaid between @startDate AND @endDate AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))) AS [TotalAdj],
	--Rec4
	(	select count(m.number) 
		FROM master m with (nolock)
		LEFT OUTER JOIN @tmpcms_payment t ON t.number = m.number
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
	'05625' AS [BankID]
	--Fills
FROM master m with (nolock)
left outer JOIN @tmpcms_count t ON m.number=t.number
left outer JOIN @tmpcms_payment t1 ON m.number=t1.number
left outer join @tmpcms t2 ON t2.number = m.number
left outer join @tmpcms_close t3 ON t3.number = m.number
where m.customer in (select string from dbo.CustomStringToSet(@customer, '|')) and m.customer is not null


--SELECT --Payment Record
--	'1' AS [RecordCode],
--	p.datepaid,
--	case when p.batchtype in ('PU', 'PA') then '1' ELSE '3' END as 'paymenttype',
--	'1' as 'sourcecode',
--	case when p.batchtype in ('PU', 'PA') then 'PAYMENT THROUGH X' ELSE 'PAYMENT REV THROUGH X' END as 'reference',
--	dbo.Custom_CalculatePaymentTotalPaid (p.uid) as amountpaid,
--	p.paid1,
--	p.paid3,
--	p.paid2,
--	p.paid10,
--	p.fee6,
--	' ' as fee,--Find fee due agency
--    p.batchtype,
--	m.id1,--Confirm this for new business
--	m.account
--FROM PayHistory p with (nolock)
--JOIN Master m with (nolock)
--ON m.Number=p.Number
--WHERE p.datepaid between @startDate AND @endDate
--AND p.batchtype IN ('PU', 'PA', 'PUR', 'PAR')
--AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))

--SELECT --Cost Disbursement Record
--	'2' AS [RecordCode],
--	p.datepaid AS [Date],
--	'C' AS [Type],
--	'1' AS [SourceCode],
--	case when p.batchtype='DA' then 'Adjustment' else 'Adjustment Up' END AS [Reference],
--	case when p.batchtype='DAR' then (-1*p.totalpaid) else p.totalpaid END AS [Amount],
--	' ' as [DueAgency], --Y or N?
--	'    ' AS [TransCode],
--	m.id1,
--	m.account
--FROM PayHistory p with (nolock)
--JOIN master m with (nolock)
--ON m.Number = p.Number
--WHERE p.datepaid between @startDate AND @endDate
--AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
	
--SELECT --Adjustment Record
--	'3' AS [RecordCode],
--	p.datepaid AS [Date],
--	'C' AS [Type],
--	'1' AS [SourceCode],
--	case when p.batchtype='DA' then 'Adjustment' else 'Adjustment Up' END AS [Reference],
--	case when p.batchtype='DAR' then (-1*p.totalpaid) else p.totalpaid END AS [TotalAdjustAmt],
--	p.Batchtype,
--	'' AS [Code1],
--	case when p.batchtype='DAR' then (-1*p.paid1) else p.paid1 END AS [AmntPrin],
--	'' AS [Code2],
--	case when p.batchtype='DAR' then (-1*p.paid3) else p.paid3 END AS [AmntOther],
--	'' AS [Code3],
--	case when p.batchtype='DAR' then (-1*p.paid2) else p.paid2 END AS [AmntInt],
--	'' AS [Code4],
--	case when p.batchtype='DAR' then (-1*p.paid10) else p.paid10 END AS [AmntCost],
--	'' AS [Code5],
--	'' AS [Amount5], --Amount?
--	'' AS [Code6],
--	'' AS [Amount6],
--	'' AS [Code7],
--	'' AS [Amount7],
--	'' AS [Code8],
--	'' AS [Amount8],
--	'' AS [Code9],
--	'' AS [Amount9],
--	'' AS [Code10],
--	'' AS [Amount10],
--	m.id1,
--	m.account
--FROM PayHistory p with (nolock)
--JOIN master m with (nolock)
--ON m.Number = p.Number
--WHERE p.datepaid between @startDate AND @endDate
--AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))



(
SELECT --Note record select top 10 * from Deceased
	'4' AS [RecordCode],
	isnull(isnull(p.deposit,s.datechanged),getdate()) as [Date],--n.created as [Date],
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
	--substring(n.comment,0,140) AS [Narrative1],
	CASE 	WHEN m.status = 'PIF' THEN 'PAID IN FULL'
		WHEN m.status = 'SIF' THEN 'SETTLED IN FULL'
		WHEN m.status like 'B%' THEN 'BANKRUPTCY'
		WHEN m.status = 'DEC' THEN 'DECEASED'
		WHEN m.status in ('CAD','CCC') THEN 'CLOSED'
		ELSE 'PROMISE TO PAY'--substring(n.comment,0,140)
	END AS [Narrative1],
	--substring(n.comment,140,140) AS [Narrative2],
	'' AS [Narrative2],
	m.id2 AS [FirstDataAcct],
	m.account AS [AccountID]
--select top 10 * from master with(nolock)
FROM @tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
LEFT OUTER JOIN statushistory s WITH(NOLOCK) ON s.accountid= m.number
LEFT OUTER JOIN pdc p on p.number = m.number
WHERE m.qlevel in('018','830','840') and p.deposit between @startDate and @endDate
)
union all
(SELECT --Note record select top 10 * from Deceased
	'4' AS [RecordCode],
	isnull(m.closed,NULL) as [Date],--n.created as [Date],
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
	--substring(n.comment,0,140) AS [Narrative1],
	CASE 	WHEN m.status = 'PIF' THEN 'PAID IN FULL'
		WHEN m.status = 'SIF' THEN 'SETTLED IN FULL'
		WHEN m.status like 'B%' THEN 'BANKRUPTCY'
		WHEN m.status = 'DEC' THEN 'DECEASED'
		WHEN m.status in ('CAD','CCC') THEN 'CLOSED'
		ELSE 'PROMISE TO PAY'--substring(n.comment,0,140)
	END AS [Narrative1],
	--substring(n.comment,140,140) AS [Narrative2],
	'' AS [Narrative2],
	m.id2 AS [FirstDataAcct],
	m.account AS [AccountID]
--select top 10 * from master with(nolock)
FROM @tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
LEFT OUTER JOIN statushistory s WITH(NOLOCK) ON s.accountid= m.number

WHERE m.status in ('DEC','CCC','CAD','B07','B13','BKY')
AND m.returned is null and m.qlevel = '998'
)
union all
(SELECT --Note record select top 10 * from Deceased
	'4' AS [RecordCode],
	isnull(m.closed,NULL) as [Date],--n.created as [Date],
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
	--substring(n.comment,0,140) AS [Narrative1],
	CASE 	WHEN m.status = 'PIF' THEN 'PAID IN FULL'
		WHEN m.status = 'SIF' THEN 'SETTLED IN FULL'
		WHEN m.status like 'B%' THEN 'BANKRUPTCY'
		WHEN m.status = 'DEC' THEN 'DECEASED'
		WHEN m.status in ('CAD','CCC') THEN 'CLOSED'
		ELSE 'PROMISE TO PAY'--substring(n.comment,0,140)
	END AS [Narrative1],
	--substring(n.comment,140,140) AS [Narrative2],
	'' AS [Narrative2],
	m.id2 AS [FirstDataAcct],
	m.account AS [AccountID]
--select top 10 * from master with(nolock)
FROM @tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
LEFT OUTER JOIN statushistory s WITH(NOLOCK) ON s.accountid= m.number

WHERE m.status in ('PIF','SIF')
--AND m.closed between (@startdate - 30) and (getdate() - 30) 
and m.returned is null and m.qlevel = '998'
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
m.State,
replace(m.Zipcode,'-','') as Zipcode,
m.HomePhone,
case when c.DateUpdated BETWEEN @startDate AND @endDate then c.JudgementAmt else 0 END AS [JudgeAmount],
case when c.DateUpdated BETWEEN @startDate AND @endDate then c.JudgementDate else NULL END   AS [JudgeDate] ,
case when c.DateUpdated BETWEEN @startDate AND @endDate then c.Remarks else '' END AS [JudgeReference] ,
case when c.DateUpdated BETWEEN @startDate AND @endDate then c.JudgementIntRate else 0 END AS [IntRate],
case when c.DateUpdated BETWEEN @startDate AND @endDate then c.intFromDate else NULL END AS [IntStartDate],
case when c.DateUpdated BETWEEN @startDate AND @endDate then ct.County else '' END AS [JudgeCounty],
case when c.DateUpdated BETWEEN @startDate AND @endDate then ct.CourtName else '' END AS [JudgeCourt],
'' AS [JudgeSheriff],
case when c.DateUpdated BETWEEN @startDate AND @endDate then c.JudgementAmt else 0 END AS [JudgePrin],
case when c.DateUpdated BETWEEN @startDate AND @endDate then c.JudgementOtherAward else 0 END AS [JudgeOtherInc],
case when c.DateUpdated BETWEEN @startDate AND @endDate then c.JudgementIntAward else 0 END AS [JudgeInt],
case when c.DateUpdated BETWEEN @startDate AND @endDate then c.JudgementCostAward else 0 END AS [JudgeCost],
'' AS [Collector],
'' AS [DocketNumber],
m.id2 as [id1],
m.account

FROM @tmpcms t
JOIN master m with (nolock) ON m.Number=t.Number
left JOIN CourtCases c with (nolock) ON m.Number=c.AccountID
left JOIN Courts ct with (nolock) ON c.CourtID=ct.CourtID

END

insert into notes(number,created,user0,action,result,comment)
select m.number,getdate(),'EXCH_SP','+++++','+++++','Account was Returned to customer in a file'
FROM @tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
--LEFT OUTER JOIN statushistory s WITH(NOLOCK) ON s.accountid= m.number
WHERE m.status in ('DEC','CCC','CAD','B07','B13','BKY')
AND m.returned is null and m.qlevel = '998'
and  m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))


update master set qlevel = '999', returned = CONVERT(DateTime, CONVERT(CHAR,getdate(), 103),103)
FROM @tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
--LEFT OUTER JOIN statushistory s WITH(NOLOCK) ON s.accountid= m.number
WHERE m.status in ('DEC','CCC','CAD','B07','B13','BKY')
AND m.returned is null and m.qlevel = '998'
and  m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))


insert into notes(number,created,user0,action,result,comment)
select m.number,getdate(),'EXCH_SP','+++++','+++++','Account was Returned to customer in a file'
FROM @tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
--LEFT OUTER JOIN statushistory s WITH(NOLOCK) ON s.accountid= m.number
WHERE m.status in ('PIF','SIF')
--AND m.closed between (@startdate - 30) and (getdate() - 30) 
and m.returned is null and m.qlevel = '998'
and  m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))

update master set qlevel = '999', returned = CONVERT(DateTime, CONVERT(CHAR,getdate(), 103),103)
FROM @tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
--LEFT OUTER JOIN statushistory s WITH(NOLOCK) ON s.accountid= m.number
WHERE m.status in ('PIF','SIF')
--AND m.closed between (@startdate - 30) and (getdate() - 30) 
and m.returned is null and m.qlevel = '998'
and  m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))





GO
