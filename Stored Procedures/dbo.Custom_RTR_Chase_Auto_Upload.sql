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
set @customer='0001220|'
exec Custom_Pay_Pal_Upload @startDate=@startDate,@endDate=@endDate,@customer=@customer
*/
CREATE                        PROCEDURE [dbo].[Custom_RTR_Chase_Auto_Upload]
	 @startDate datetime,
	 @endDate datetime,
	 @customer varchar(8000),
	 @invoice VARCHAR(8000)

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
			
			--get vrb bko statuses
			INSERT INTO @tmpcms_count (number)
			SELECT DISTINCT number from master m with (nolock) INNER JOIN dbo.StatusHistory s WITH (NOLOCK)
			ON m.number = s.AccountID
			WHERE s.NewStatus IN ('vrb', 'bko') AND s.DateChanged BETWEEN @startDate AND @endDate
			AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))

			DECLARE @tmpcms_payment TABLE(
			[ID] [int] IDENTITY(1,1) NOT NULL,
			[number] [int] NOT NULL,
			[amount] [money] NULL)

			INSERT INTO @tmpcms_payment (number,amount)
			SELECT distinct number,sum(case when batchtype in ('PAR','PCR','PUR') THEN (-1*totalpaid) ELSE totalpaid END)
			FROM payhistory with(nolock)
			WHERE customer in (select string from dbo.CustomStringToSet(@customer, '|')) AND Invoice in (select string from dbo.CustomStringToSet(@invoice, '|'))
			GROUP BY number

			DECLARE @tmpcms_close TABLE(
			[ID] [int] IDENTITY(1,1) NOT NULL,
			[number] [int] NOT NULL,
			[amount] [money] NULL)

			INSERT INTO @tmpcms_close (number,amount)
			SELECT distinct m.number,0
			FROM master m with(nolock)
			WHERE (m.status in ('DEC','CCC','CAD','B07','B13','BKY', 'PLV', 'RSK', 'FRD', 'CND') or m.qlevel in('018','830','840','998'))
			and m.customer in (select string from dbo.CustomStringToSet(@customer, '|')) and m.returned is null
			and m.closed between @startdate and @enddate
			GROUP BY m.number

			INSERT INTO @tmpcms_close (number,amount)
			SELECT distinct m.number,0
			FROM master m with(nolock)
			WHERE m.status in ('SIF','PIF') AND m.closed between (@startdate - 15) and (getdate() - 15) 
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
	cast(getdate() as smalldatetime) as [Date],
	--Type=1
	--SourceCode=1
	m.customer,
	CASE m.customer WHEN '0001220' THEN 'SIMMDC' 
			WHEN '0001256' THEN 'SIMPRI'
			WHEN '0001257' THEN 'SIMTER'
			WHEN '0001258' THEN 'SIMBKP'
			END AS [AgencyCode],
	'SIMM Associates Inc.' AS [AgencyName],
	--Rec1
	(select count(*) FROM PayHistory p with (nolock) JOIN Master m2 with (nolock) ON m2.Number=p.Number WHERE p.invoice in (select string from dbo.CustomStringToSet(@invoice, '|')) AND p.batchtype IN ('PU', 'PA', 'PAR', 'PUR') AND m2.customer=m.customer) /*IN (select string from dbo.CustomStringToSet(@customer, '|')))*/ AS [NumRec1],
	(select SUM(dbo.Custom_CalculatePaymentTotalPaid (p.uid)) FROM PayHistory p with (nolock) JOIN Master m2 with (nolock) ON m2.Number=p.Number WHERE p.invoice in (select string from dbo.CustomStringToSet(@invoice, '|')) AND p.batchtype IN ('PU', 'PA', 'PAR', 'PUR') AND m2.customer=m.customer) /*IN (select string from dbo.CustomStringToSet(@customer, '|')))*/ AS [TotalPay],
	--Rec2
	--(select count(*) FROM PayHistory p with (nolock) JOIN master m2 with (nolock) ON m2.Number = p.Number WHERE p.datepaid between @startDate AND @endDate AND m2.customer=m.customer) /*IN (select string from dbo.CustomStringToSet(@customer, '|')))*/ AS [NumRec2],
	--(select SUM(case when p.batchtype='DAR' then (-1*p.totalpaid) else p.totalpaid END) FROM PayHistory p with (nolock) JOIN master m2 with (nolock) ON m2.Number = p.Number WHERE p.datepaid between @startDate AND @endDate AND m2.customer=m.customer )/*IN (select string from dbo.CustomStringToSet(@customer, '|')))*/ AS [TotalCost],
	--Rec3
	--(select count(*) FROM PayHistory p with (nolock) JOIN master m with (nolock) ON m.Number = p.Number WHERE p.datepaid between @startDate AND @endDate AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))) AS [NumRec3],
	--(select SUM(case when p.batchtype='DAR' then (-1*p.totalpaid) else p.totalpaid END) FROM PayHistory p with (nolock) JOIN master m with (nolock) ON m.Number = p.Number WHERE p.datepaid between @startDate AND @endDate AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))) AS [TotalAdj],
	--Rec4
	(	select count(m.number) 
		FROM master m with (nolock)
		LEFT OUTER JOIN @tmpcms_payment t ON t.number = m.number
		WHERE m.closed between @startDate AND @endDate
		AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
		AND (m.status in ('DEC','CCC','CAD','B07','B13','BKY', 'PLV', 'RSK', 'FRD', 'CND') OR (m.status IN ('sif', 'pif') AND m.closed between (@startdate - 15) and (getdate() - 15))) AND m.returned is null and m.qlevel = '998'
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
	'05539' AS [BankID]
	--Fills
FROM master m with (nolock)
left outer JOIN @tmpcms_count t ON m.number=t.number
left outer JOIN @tmpcms_payment t1 ON m.number=t1.number
left outer join @tmpcms t2 ON t2.number = m.number
left outer join @tmpcms_close t3 ON t3.number = m.number
where m.customer in (select string from dbo.CustomStringToSet(@customer, '|')) and m.customer is not null


SELECT --Payment Record
	'1' AS [RecordCode],
	p.datepaid,
	case when p.batchtype in ('PU', 'PA') then '1' ELSE '3' END as 'paymenttype',
	'1' as 'sourcecode',
	case when p.batchtype in ('PU', 'PA') then 'PAYMENT THROUGH X' ELSE 'PAYMENT REV THROUGH X' END as 'reference',
	dbo.Custom_CalculatePaymentTotalPaid (p.uid) as amountpaid,
	
	case when p.batchtype in ('PUR','PAR') then '-' else '0' end as [sign],
	dbo.Custom_CalculatePaymentTotalPaid (p.uid )as amountpaid,
	case when p.batchtype in ('PUR','PAR') and p.paid1 <> 0 then '-' else '0' end as [sign1],
	p.paid1 as [paid1],
	case when p.batchtype in ('PUR','PAR') and p.paid3 <> 0 then '-' else '0' end as [sign2],
	p.paid3 as [paid3],
	case when p.batchtype in ('PUR','PAR') and p.paid2 <> 0 then '-' else '0' end as [sign3],
	p.paid2 as [paid2],
	'00000000.00' as [paid10],--p.paid10,
	case when p.batchtype in ('PUR','PAR') and p.fee6 <> 0 then '-' else '0' end as [sign4],
	p.fee6 as [fee6],
	/*
	p.paid1,
	p.paid3,
	p.paid2,
	p.paid10,
	p.fee6,
	*/
	'Y' as fee,--Find fee due agency
    p.batchtype,
	' ' AS id1,--Confirm this for new business
	m.account
FROM PayHistory p with (nolock)
JOIN Master m with (nolock)
ON m.Number=p.Number
WHERE p.invoice in (select string from dbo.CustomStringToSet(@invoice, '|'))
AND p.batchtype IN ('PU', 'PA', 'PUR', 'PAR')
AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))

--SELECT --Cost Disbursement Record
--	'2' AS [RecordCode],
--	p.datepaid AS [Date],
--	'C' AS [Type],
--	'1' AS [SourceCode],
--	case when p.batchtype='DA' then 'Adjustment' else 'Adjustment Up' END AS [Reference],
--	case when p.batchtype='DAR' then (-1*p.totalpaid) else p.totalpaid END AS [Amount],
--	' ' as [DueAgency], --Y or N?
--	'    ' AS [TransCode],
--	' ' AS id1,
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
--	' ' AS id1,
--	m.account
--FROM PayHistory p with (nolock)
--JOIN master m with (nolock)
--ON m.Number = p.Number
--WHERE p.datepaid between @startDate AND @endDate
--AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))



(
SELECT distinct --Note record select top 10 * from Deceased
	'4' AS [RecordCode],
	cast(isnull(isnull(p.deposit,s.datechanged),getdate())as smalldatetime) as [Date],--n.created as [Date],
	case WHEN m.customer = '0001220' THEN 
		CASE when m.status like 'B%' then 'DBK'
			when m.status='CAD' then 'DCR'
			when m.status='CCC' then 'DCR'
			WHEN m.STATUS = 'FRD' THEN 'DCR'
			when m.status='SIF' then 'SIF'
			when m.status='PIF' then 'PIF'
			WHEN m.STATUS = 'AEX' THEN 'DCR'
			WHEN M.STATUS = 'PLV' THEN 'ALV'
			WHEN m.STATUS = 'RSK' THEN 'RSK'
			ELSE 'PTP'
		END
		WHEN m.customer <> '0001220' THEN
		CASE WHEN m.STATUS LIKE 'B%' THEN 'BKP'
			when m.STATUS IN ('CAD', 'CND') then 'CAD'
			WHEN m.STATUS = 'DEC' THEN 'DEC'
			WHEN m.STATUS = 'DSP' THEN 'DSP'
			WHEN m.STATUS = 'FRD' THEN 'FRD'
			WHEN m.STATUS = 'RSK' THEN 'LTG'
			WHEN m.STATUS = 'SIF' THEN 'SIF'
			WHEN m.STATUS = 'PIF' THEN 'PIF'
			ELSE 'PTP'
		END 		
	END AS [NoteCode],--outgoing note code
	--substring(n.comment,0,140) AS [Narrative1],
	CASE WHEN m.customer = '0001220' THEN
		CASE WHEN m.status like 'B%' THEN 'CONFIRMED BK'
			WHEN m.status in ('CAD','CCC') THEN 'DECEASED RECALL'
			WHEN m.STATUS = 'FRD' THEN 'DECEASED RECALL'
			WHEN m.status = 'PIF' THEN 'PAID IN FULL'
			WHEN m.status = 'SIF' THEN 'SETLD IN FULL/DO NOT RPT'
			WHEN m.STATUS = 'PLV' THEN 'CONFIRMED ALIVE'
			WHEN m.STATUS = 'RSK' THEN 'PREVIOUS FDCPA LITIGATION'
			ELSE 'PROMISE TO PAY'--substring(n.comment,0,140)
		END
		WHEN m.customer <> '0001220' THEN
		CASE WHEN m.status like 'B%' THEN 'BANKRUPTCY'
			WHEN m.status in ('CAD','CND') THEN 'CEASE AND DESIST'
			WHEN M.STATUS = 'DEC' THEN 'DECEASED'
			WHEN M.STATUS = 'DSP' THEN 'DEBTOR DISPUTES ACCOUNT'
			WHEN m.STATUS = 'FRD' THEN 'FRAUD'
			WHEN m.status = 'PIF' THEN 'PAID IN FULL'
			WHEN m.status = 'SIF' THEN 'SETLD IN FULL/DO NOT RPT'
			WHEN m.STATUS = 'RSK' THEN 'LITIGIOUS DEBTOR'
			ELSE 'PROMISE TO PAY'--substring(n.comment,0,140)
		end
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
(SELECT distinct --Note record select top 10 * from Deceased
	'4' AS [RecordCode],
	cast(isnull(m.closed,NULL) as smalldatetime) as [Date],--n.created as [Date],
	case WHEN customer = '0001220' THEN 
		CASE when m.status like 'B%' then 'DBK'
			when m.status='CAD' then 'DCR'
			when m.status='CCC' then 'DCR'
			WHEN m.STATUS = 'FRD' THEN 'DCR'
			when m.status='SIF' then 'SIF'
			when m.status='PIF' then 'PIF'
			WHEN m.STATUS = 'AEX' THEN 'DCR'
			WHEN M.STATUS = 'PLV' THEN 'ALV'
			WHEN m.STATUS = 'RSK' THEN 'RSK'
			ELSE 'PTP'
		END
		WHEN customer <> '0001220' THEN
		CASE WHEN m.STATUS LIKE 'B%' THEN 'BKP'
			when m.STATUS IN ('CAD', 'CND') then 'CAD'
			WHEN m.STATUS = 'DEC' THEN 'DEC'
			WHEN m.STATUS = 'DSP' THEN 'DSP'
			WHEN m.STATUS = 'FRD' THEN 'FRD'
			WHEN m.STATUS = 'RSK' THEN 'LTG'
			WHEN m.STATUS = 'SIF' THEN 'SIF'
			WHEN m.STATUS = 'PIF' THEN 'PIF'
			ELSE 'PTP'
		END 		
	END AS [NoteCode],--outgoing note code
	--substring(n.comment,0,140) AS [Narrative1],
	CASE WHEN m.customer = '0001220' THEN
		CASE WHEN m.status like 'B%' THEN 'CONFIRMED BK'
			WHEN m.status in ('CAD','CCC') THEN 'DECEASED RECALL'
			WHEN m.STATUS = 'FRD' THEN 'DECEASED RECALL'
			WHEN m.status = 'PIF' THEN 'PAID IN FULL'
			WHEN m.status = 'SIF' THEN 'SETLD IN FULL/DO NOT RPT'
			WHEN m.STATUS = 'PLV' THEN 'CONFIRMED ALIVE'
			WHEN m.STATUS = 'RSK' THEN 'PREVIOUS FDCPA LITIGATION'
			ELSE 'PROMISE TO PAY'--substring(n.comment,0,140)
		END
		WHEN m.customer <> '0001220' THEN
		CASE WHEN m.status like 'B%' THEN 'BANKRUPTCY'
			WHEN m.status in ('CAD','CND') THEN 'CEASE AND DESIST'
			WHEN M.STATUS = 'DEC' THEN 'DECEASED'
			WHEN M.STATUS = 'DSP' THEN 'DEBTOR DISPUTES ACCOUNT'
			WHEN m.STATUS = 'FRD' THEN 'FRAUD'
			WHEN m.status = 'PIF' THEN 'PAID IN FULL'
			WHEN m.status = 'SIF' THEN 'SETLD IN FULL/DO NOT RPT'
			WHEN m.STATUS = 'RSK' THEN 'LITIGIOUS DEBTOR'
			ELSE 'PROMISE TO PAY'--substring(n.comment,0,140)
		end
	END AS [Narrative1],
	--substring(n.comment,140,140) AS [Narrative2],
	'' AS [Narrative2],
	m.id2 AS [FirstDataAcct],
	m.account AS [AccountID]
--select top 10 * from master with(nolock)
FROM @tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
LEFT OUTER JOIN statushistory s WITH(NOLOCK) ON s.accountid= m.number

WHERE m.status in ('DEC','CCC','CAD','B07','B13','BKY', 'PLV', 'RSK', 'FRD', 'CND')
AND m.returned is null and m.qlevel = '998'
)
union all
(SELECT distinct --Note record select top 10 * from Deceased
	'4' AS [RecordCode],
	cast(isnull(m.closed,NULL) as smalldatetime) as [Date],--n.created as [Date],
	case WHEN customer = '0001220' THEN 
		CASE when m.status like 'B%' then 'DBK'
			when m.status='CAD' then 'DCR'
			when m.status='CCC' then 'DCR'
			WHEN m.STATUS = 'FRD' THEN 'DCR'
			when m.status='SIF' then 'SIF'
			when m.status='PIF' then 'PIF'
			WHEN m.STATUS = 'AEX' THEN 'DCR'
			WHEN M.STATUS = 'PLV' THEN 'ALV'
			WHEN m.STATUS = 'RSK' THEN 'RSK'
			ELSE 'PTP'
		END
		WHEN customer <> '0001220' THEN
		CASE WHEN m.STATUS LIKE 'B%' THEN 'BKP'
			when m.STATUS IN ('CAD', 'CND') then 'CAD'
			WHEN m.STATUS = 'DEC' THEN 'DEC'
			WHEN m.STATUS = 'DSP' THEN 'DSP'
			WHEN m.STATUS = 'FRD' THEN 'FRD'
			WHEN m.STATUS = 'RSK' THEN 'LTG'
			WHEN m.STATUS = 'SIF' THEN 'SIF'
			WHEN m.STATUS = 'PIF' THEN 'PIF'
			ELSE 'PTP'
		END 		
	END AS [NoteCode],--outgoing note code
	--substring(n.comment,0,140) AS [Narrative1],
	CASE WHEN m.customer = '0001220' THEN
		CASE WHEN m.status like 'B%' THEN 'CONFIRMED BK'
			WHEN m.status in ('CAD','CCC') THEN 'DECEASED RECALL'
			WHEN m.STATUS = 'FRD' THEN 'DECEASED RECALL'
			WHEN m.status = 'PIF' THEN 'PAID IN FULL'
			WHEN m.status = 'SIF' THEN 'SETLD IN FULL/DO NOT RPT'
			WHEN m.STATUS = 'PLV' THEN 'CONFIRMED ALIVE'
			WHEN m.STATUS = 'RSK' THEN 'PREVIOUS FDCPA LITIGATION'
			ELSE 'PROMISE TO PAY'--substring(n.comment,0,140)
		END
		WHEN m.customer <> '0001220' THEN
		CASE WHEN m.status like 'B%' THEN 'BANKRUPTCY'
			WHEN m.status in ('CAD','CND') THEN 'CEASE AND DESIST'
			WHEN M.STATUS = 'DEC' THEN 'DECEASED'
			WHEN M.STATUS = 'DSP' THEN 'DEBTOR DISPUTES ACCOUNT'
			WHEN m.STATUS = 'FRD' THEN 'FRAUD'
			WHEN m.status = 'PIF' THEN 'PAID IN FULL'
			WHEN m.status = 'SIF' THEN 'SETLD IN FULL/DO NOT RPT'
			WHEN m.STATUS = 'RSK' THEN 'LITIGIOUS DEBTOR'
			ELSE 'PROMISE TO PAY'--substring(n.comment,0,140)
		end
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
AND m.closed between (@startdate - 15) and (getdate() - 15) 
and m.returned is null and m.qlevel = '998'
)
union all
(SELECT distinct --Note record select top 10 * from Deceased
	'4' AS [RecordCode],
	cast(GETDATE() as smalldatetime) as [Date],--n.created as [Date],
	case when m.status IN ('VRB', 'BKO') then 'BKP'
		
	END AS [NoteCode],--outgoing note code
	--substring(n.comment,0,140) AS [Narrative1],
	CASE WHEN m.status IN ('VRB', 'BKO') THEN 'BANKRUPTCY PENDING'
		
	END AS [Narrative1],
	--substring(n.comment,140,140) AS [Narrative2],
	'' AS [Narrative2],
	m.id2 AS [FirstDataAcct],
	m.account AS [AccountID]
--select top 10 * from master with(nolock)
FROM @tmpcms_count t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
LEFT OUTER JOIN statushistory s WITH(NOLOCK) ON s.accountid= m.number
WHERE m.status in ('VRB', 'BKO') AND m.customer IN ('0001256', '0001257', '0001258')
)



--------Account Master

SELECT DISTINCT
m.customer as [Customer],
'5' AS [RecordCode], 
cast(getdate() as smalldatetime) as [Date],
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
case when c.DateUpdated BETWEEN @startDate AND @endDate then cast(c.JudgementAmt as varchar(10)) else '000000000000' END AS [JudgeAmount],
case when c.DateUpdated BETWEEN @startDate AND @endDate then c.JudgementDate else NULL END   AS [JudgeDate] ,
case when c.DateUpdated BETWEEN @startDate AND @endDate then c.Remarks else '' END AS [JudgeReference] ,
case when c.DateUpdated BETWEEN @startDate AND @endDate then c.JudgementIntRate else 0 END AS [IntRate],
case when c.DateUpdated BETWEEN @startDate AND @endDate then c.intFromDate else NULL END AS [IntStartDate],
case when c.DateUpdated BETWEEN @startDate AND @endDate then ct.County else '' END AS [JudgeCounty],
case when c.DateUpdated BETWEEN @startDate AND @endDate then ct.CourtName else '' END AS [JudgeCourt],
'' AS [JudgeSheriff],
case when c.DateUpdated BETWEEN @startDate AND @endDate then cast(c.JudgementAmt as varchar(10)) else '000000000000' END AS [JudgePrin],
case when c.DateUpdated BETWEEN @startDate AND @endDate then cast(c.JudgementOtherAward as varchar(10)) else '000000000000' END AS [JudgeOtherInc],
case when c.DateUpdated BETWEEN @startDate AND @endDate then cast(c.JudgementIntAward as varchar(10)) else '000000000000' END AS [JudgeInt],
case when c.DateUpdated BETWEEN @startDate AND @endDate then cast(c.JudgementCostAward as varchar(10)) else '000000000000' END AS [JudgeCost],
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
WHERE m.status in ('DEC','CCC','CAD','B07','B13','BKY', 'PLV', 'RSK', 'FRD', 'CND')
AND m.returned is null and m.qlevel = '998'
and  m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))


update master set qlevel = '999', returned = CONVERT(DateTime, CONVERT(CHAR,getdate(), 103),103)
FROM @tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
--LEFT OUTER JOIN statushistory s WITH(NOLOCK) ON s.accountid= m.number
WHERE m.status in ('DEC','CCC','CAD','B07','B13','BKY', 'PLV', 'RSK', 'FRD', 'CND')
AND m.returned is null and m.qlevel = '998'
and  m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))


insert into notes(number,created,user0,action,result,comment)
select m.number,getdate(),'EXCH_SP','+++++','+++++','Account was Returned to customer in a file'
FROM @tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
--LEFT OUTER JOIN statushistory s WITH(NOLOCK) ON s.accountid= m.number
WHERE m.status in ('PIF','SIF')
AND m.closed between (@startdate - 15) and (getdate() - 15) 
and m.returned is null and m.qlevel = '998'
and  m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))

update master set qlevel = '999', returned = CONVERT(DateTime, CONVERT(CHAR,getdate(), 103),103)
FROM @tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
--LEFT OUTER JOIN statushistory s WITH(NOLOCK) ON s.accountid= m.number
WHERE m.status in ('PIF','SIF')
AND m.closed between (@startdate - 15) and (getdate() - 15) 
and m.returned is null and m.qlevel = '998'
and  m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
GO
