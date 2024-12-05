SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*			CHANGES
Date | Name | Description
8/13/2014 BGM Added DPV Status code to send DSP code on non-probate accounts for disputes
7/7/2015 BGM Changed BKO to closing type code
6/13/2016 BGM Removed AEX code being sent as UNC per client do not use UNC.
8/17/2016 BGM Changed it so a bad phone number will be sent as (000-000-0000)
2/8/2018 BGM added DIN to Close Codes
4/17/2020 BGM added DIS to keeper codes
7/20/2020 KSE added new close codes for Warehouse streams
02/23/2021 BGM Updated SIF/PIF code for Warehouse streams
06/07/2021 BGM Added customer breakdown for response codes to TMPCMS_count record 4 query
*/






/*
declare @startDate datetime
declare @endDate datetime
declare @customer varchar(8000)

set @startDate='20211013'
set @endDate='20211013'
--set @endDate='12/20/2006 12:15:00'
set @customer='0001220'
exec Custom_Pay_Pal_Upload_nopay_New @startDate=@startDate,@endDate=@endDate,@customer=@customer
*/
CREATE                        PROCEDURE [dbo].[Custom_Pay_Pal_Upload_NoPay_New]
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
			WHERE dbo.date(a.DateChanged) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)
			AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))

			INSERT INTO @tmpcms_count (number)
			SELECT DISTINCT AccountID from PhoneHistory p with (nolock)
			JOIN master m with (nolock)
			ON m.Number=p.AccountId
			WHERE dbo.date(p.DateChanged) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)
			AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))

			--get vrb bko statuses and keeper statuses
			INSERT INTO @tmpcms_count (number)
			SELECT DISTINCT number from master m with (nolock) INNER JOIN dbo.StatusHistory s WITH (NOLOCK)
			ON m.number = s.AccountID
			WHERE ((s.NewStatus IN ('vrb', 'vcd', 'lcp') AND dbo.date(s.DateChanged) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)) OR
			m.status IN ('pdc', 'pcc', 'ppa', 'nsf', 'dcc', 'dbd', 'npc', 'hot', 'DIS') OR 
			(m.status IN ('mhd', 'nhd') AND (SELECT TOP 1 oldstatus FROM dbo.StatusHistory WITH (NOLOCK) WHERE AccountID = m.number AND NewStatus IN ('mhd', 'nhd') ORDER BY DateChanged DESC)
			IN ('pdc', 'pcc', 'ppa', 'nsf', 'dcc', 'dbd', 'npc', 'hot', 'DIS') AND s.NewStatus IN ('mhd', 'nhd')))
			AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
			
--			DECLARE @tmpcms_payment TABLE(
--			[ID] [int] IDENTITY(1,1) NOT NULL,
--			[number] [int] NOT NULL,
--			[amount] [money] NULL)
--
--			INSERT INTO @tmpcms_payment (number,amount)
--			SELECT distinct number,sum(case when batchtype in ('PAR','PCR','PUR') THEN (-1*totalpaid) ELSE totalpaid END)
--			FROM payhistory with(nolock)
--			WHERE customer in (select string from dbo.CustomStringToSet(@customer, '|'))
--			GROUP BY number

			DECLARE @tmpcms_close TABLE(
			[ID] [int] IDENTITY(1,1) NOT NULL,
			[number] [int] NOT NULL,
			[amount] [money] NULL)

			INSERT INTO @tmpcms_close (number,amount)
			SELECT distinct m.number,0
			FROM master m with(nolock)
			WHERE (m.status in ('DEC','CCS','CAD','B07','B13','BKY', 'BKO', 'DPV', 'PLV', 'RSK', 'FRD', 'CND', 'MIL', 'DIP', 'POA', 'WVI', 'OOS', 'DIN','PCL','CMP') or m.qlevel in('018','830','840','998'))
			and m.customer in (select string from dbo.CustomStringToSet(@customer, '|')) and m.returned is null
			and dbo.date(m.closed) between dbo.date(@startdate) and dbo.date(@enddate)
			GROUP BY m.number

			INSERT INTO @tmpcms_close (number,amount)
			SELECT distinct m.number,0
			FROM master m with(nolock)
			WHERE m.status in ('SIF','PIF') AND dbo.date(m.closed) between dbo.date((@startdate - 15)) and dbo.date((getdate() - 15))
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
	WHERE dbo.date(a.DateChanged) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)
	AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))

insert into @tmpcms (number)
	SELECT DISTINCT AccountID from PhoneHistory p
	JOIN master m with (nolock)
	ON m.Number=p.AccountId
	WHERE dbo.date(p.DateChanged) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)
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
			WHEN '0002462' THEN 'SIMWHS'
			WHEN '0002468' THEN 'SIMWTR'
			WHEN '0002469' THEN 'SIMWSC'
			END AS [AgencyCode],
	'SIMM Associates Inc.' AS [AgencyName],
	--Rec1
	--(select count(*) FROM PayHistory p with (nolock) JOIN Master m2 with (nolock) ON m2.Number=p.Number WHERE p.invoice in (select string from dbo.CustomStringToSet(@invoice, '|')) AND p.batchtype IN ('PU', 'PA', 'PAR', 'PUR') AND m2.customer=m.customer) /*IN (select string from dbo.CustomStringToSet(@customer, '|')))*/ AS [NumRec1],
	--(select SUM(dbo.Custom_CalculatePaymentTotalPaid (p.uid)) FROM PayHistory p with (nolock) JOIN Master m2 with (nolock) ON m2.Number=p.Number WHERE p.invoice in (select string from dbo.CustomStringToSet(@invoice, '|')) AND p.batchtype IN ('PU', 'PA', 'PAR', 'PUR') AND m2.customer=m.customer) /*IN (select string from dbo.CustomStringToSet(@customer, '|')))*/ AS [TotalPay],
	--Rec2
	--(select count(*) FROM PayHistory p with (nolock) JOIN master m2 with (nolock) ON m2.Number = p.Number WHERE p.datepaid between @startDate AND @endDate AND m2.customer=m.customer) /*IN (select string from dbo.CustomStringToSet(@customer, '|')))*/ AS [NumRec2],
	--(select SUM(case when p.batchtype='DAR' then (-1*p.totalpaid) else p.totalpaid END) FROM PayHistory p with (nolock) JOIN master m2 with (nolock) ON m2.Number = p.Number WHERE p.datepaid between @startDate AND @endDate AND m2.customer=m.customer )/*IN (select string from dbo.CustomStringToSet(@customer, '|')))*/ AS [TotalCost],
	--Rec3
	--(select count(*) FROM PayHistory p with (nolock) JOIN master m with (nolock) ON m.Number = p.Number WHERE p.datepaid between @startDate AND @endDate AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))) AS [NumRec3],
	--(select SUM(case when p.batchtype='DAR' then (-1*p.totalpaid) else p.totalpaid END) FROM PayHistory p with (nolock) JOIN master m with (nolock) ON m.Number = p.Number WHERE p.datepaid between @startDate AND @endDate AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))) AS [TotalAdj],
	--Rec4
	((	
		select count(DISTINCT number) 
		FROM @tmpcms_close
	)
	--(	select count(m2.number) 
	--	FROM master m2 with (nolock)
	--	LEFT OUTER JOIN @tmpcms_payment t ON t.number = m2.number
	--	WHERE dbo.date(m2.closed) between dbo.date(@startDate) AND dbo.date(@endDate)
	--	AND m2.customer = m.customer
	--	AND (m2.status in ('DEC','CCS','CAD','B07','B13','BKY', 'PLV', 'RSK', 'FRD', 'CND', 'MIL', 'DIP') OR (m2.status IN ('sif', 'pif') AND m2.closed between (@startdate - 15) and (getdate() - 15))) AND m2.returned is null and m2.qlevel = '998'
	--)
	+
	(	select count(DISTINCT m2.number) 
		FROM @tmpcms_count t 
		JOIN master m2 with (nolock) ON m2.Number=t.Number 
		
		WHERE m2.customer=m.customer AND m2.STATUS IN ('pdc', 'pcc', 'ppa', 'nsf', 'dcc', 'dbd', 'npc', 'hot', 'mhd', 'nhd', 'DIS')
	))
		AS [NumRec4],
	--Rec5
	(
		select count(distinct m2.number) 
		FROM @tmpcms_count t 
		JOIN master m2 with (nolock) ON m2.Number=t.Number 
		left JOIN CourtCases c with (nolock) ON m2.Number=c.AccountID 
		left JOIN Courts ct with (nolock) ON c.CourtID=ct.CourtID
		where m2.customer=m.customer AND m2.STATUS NOT IN ('pdc', 'pcc', 'ppa', 'nsf', 'dcc', 'dbd', 'npc', 'hot', 'mhd', 'nhd', 'DIS')
	)
		AS [NumRec5],
	--Filler
	'05539' AS [BankID]
	--Fills
FROM master m with (nolock)
left outer JOIN @tmpcms_count t ON m.number=t.number
--left outer JOIN @tmpcms_payment t1 ON m.number=t1.number
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
--	'Y' as fee,--Find fee due agency
--    p.batchtype,
--	' ' AS id1,--Confirm this for new business
--	m.account
--FROM PayHistory p with (nolock)
--JOIN Master m with (nolock)
--ON m.Number=p.Number
--WHERE p.invoice in (select string from dbo.CustomStringToSet(@invoice, '|'))
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
	'PTP' AS [NoteCode],--outgoing note code
	--substring(n.comment,0,140) AS [Narrative1],
	 'PROMISE TO PAY' AS [Narrative1],
	--substring(n.comment,140,140) AS [Narrative2],
	'' AS [Narrative2],
	m.id2 AS [FirstDataAcct],
	m.account AS [AccountID]
--select top 10 * from master with(nolock)
FROM @tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
LEFT OUTER JOIN statushistory s WITH(NOLOCK) ON s.accountid= m.number
LEFT OUTER JOIN pdc p on p.number = m.number
WHERE m.qlevel in('018','830','840') and dbo.date(p.deposit) between dbo.date(@startDate) and dbo.date(@endDate)
)
union all
(SELECT distinct --Note record select top 10 * from Deceased
	'4' AS [RecordCode],
	cast(isnull(m.closed,NULL) as smalldatetime) as [Date],--n.created as [Date],
	case WHEN m.customer = '0001220' THEN 
		CASE when m.status like 'B%' then 'DBK'
			when m.status='CAD' then 'DCR'
			when m.status='CCS' then 'DCR'
			WHEN m.STATUS = 'FRD' THEN 'DCR'
			when m.status='SIF' then 'SIF'
			when m.status='PIF' then 'PIF'
			WHEN m.STATUS = 'AEX' THEN 'DCR'
			WHEN M.STATUS = 'PLV' THEN 'ALV'
			WHEN m.STATUS = 'RSK' THEN 'LTG'
			WHEN M.STATUS = 'MIL' THEN 'MIL'
			WHEN M.STATUS = 'DIP' THEN 'DIP'
			WHEN M.STATUS = 'POA' THEN 'POA'
			WHEN m.STATUS = 'WVI' THEN 'WVI'
			WHEN m.STATUS = 'OOS' THEN 'OOS'
			WHEN m.STATUS = 'DIN' THEN 'DIN'
			ELSE 'PTP'
		END
		WHEN m.customer in ('0001256','0001257','0001258','0002462') THEN
		CASE WHEN m.STATUS LIKE 'B%' THEN 'BKT'
			when m.STATUS IN ('CAD', 'CND') then 'CAD'
			WHEN m.STATUS = 'DEC' THEN 'DEC'
			WHEN m.STATUS = 'DPV' THEN 'DSP'
			WHEN m.STATUS = 'FRD' THEN 'FRD'
			WHEN m.STATUS = 'RSK' THEN 'LTG'
			WHEN m.STATUS = 'SIF' THEN 'SIF'
			WHEN m.STATUS = 'PIF' THEN 'PIF'
			WHEN M.STATUS = 'MIL' THEN 'MIL'
			WHEN M.STATUS = 'DIP' THEN 'DIP'
			WHEN M.STATUS = 'POA' THEN 'POA'
			WHEN m.STATUS = 'WVI' THEN 'WVI'
			--WHEN m.STATUS = 'AEX' THEN 'UNC'
			WHEN m.STATUS = 'OOS' THEN 'OOS'
			WHEN m.STATUS = 'DIN' THEN 'DIN'
			ELSE 'PTP'
		END
		WHEN customer in ('0002468','0002469') THEN
		CASE WHEN m.STATUS LIKE 'B%' THEN 'PBT'
			when m.STATUS IN ('CAD', 'CND') then 'PCD'
			WHEN m.STATUS = 'DEC' THEN 'PDC'
			WHEN m.STATUS = 'DPV' THEN 'PDP'
			WHEN m.STATUS = 'FRD' THEN 'PFD'
			WHEN m.STATUS = 'RSK' THEN 'PLT'
			WHEN m.STATUS = 'SIF' THEN 'SIF'
			WHEN m.STATUS = 'PIF' THEN 'PPF'
			WHEN M.STATUS = 'MIL' THEN 'MIL'
			WHEN M.STATUS = 'DIP' THEN 'DIP'
			WHEN M.STATUS = 'POA' THEN 'POA'
			WHEN m.STATUS = 'WVI' THEN 'PWV'
			--WHEN m.STATUS = 'AEX' THEN 'UNC'
			WHEN m.STATUS = 'OOS' THEN 'POO'
			WHEN m.STATUS = 'DIN' THEN 'DIN'
			WHEN m.STATUS = 'PCL' THEN 'PCL'
			WHEN m.STATUS = 'CMP' THEN 'PCM'
			ELSE 'PTP'
		END  		
	END AS [NoteCode],--outgoing note code
	--substring(n.comment,0,140) AS [Narrative1],
	CASE WHEN m.customer = '0001220' THEN
		CASE WHEN m.status like 'B%' THEN 'CONFIRMED BK'
			WHEN m.status in ('CAD','CCS') THEN 'DECEASED RECALL'
			WHEN m.STATUS = 'FRD' THEN 'DECEASED RECALL'
			WHEN m.status = 'PIF' THEN 'PAID IN FULL'
			WHEN m.status = 'SIF' THEN 'SETLD IN FULL/DO NOT RPT'
			WHEN m.STATUS = 'PLV' THEN 'CONFIRMED ALIVE'
			WHEN m.STATUS = 'RSK' THEN 'LITIGIOUS DEBTOR'
			WHEN M.STATUS = 'MIL' THEN 'Active/Deployed Military'
			WHEN M.STATUS = 'DIP' THEN 'Debtor-In-Prison'
			WHEN m.STATUS = 'AEX' THEN 'DECEASED RECALL'
			WHEN M.STATUS = 'POA' THEN 'POWER OF ATTY'
			WHEN m.STATUS = 'WVI' THEN 'West Virginia'
			WHEN m.STATUS = 'OOS' THEN 'Out of Stat'
			WHEN m.STATUS = 'DIN' THEN 'Deceased-Insolvent'
			ELSE 'PROMISE TO PAY'--substring(n.comment,0,140)
		END
		WHEN m.customer in ('0001256','0001257','0001258','0002462') THEN
		CASE WHEN m.status like 'B%' THEN 'BANKRUPTCY'
			WHEN m.status in ('CAD','CND') THEN 'CEASE AND DESIST'
			WHEN M.STATUS = 'DEC' THEN 'DECEASED'
			WHEN M.STATUS = 'DPV' THEN 'DEBTOR DISPUTES ACCOUNT'
			WHEN m.STATUS = 'FRD' THEN 'FRAUD'
			WHEN m.status = 'PIF' THEN 'PAID IN FULL'
			WHEN m.status = 'SIF' THEN 'SETLD IN FULL/DO NOT RPT'
			WHEN m.STATUS = 'RSK' THEN 'LITIGIOUS DEBTOR'
			WHEN M.STATUS = 'MIL' THEN 'Active/Deployed Military'
			WHEN M.STATUS = 'DIP' THEN 'Debtor-In-Prison'
			WHEN M.STATUS = 'POA' THEN 'POWER OF ATTY'
			WHEN m.STATUS = 'WVI' THEN 'West Virginia'
			--WHEN m.STATUS = 'AEX' THEN 'UNCOLLECTABLE'
			WHEN m.STATUS = 'OOS' THEN 'Out of Stat'
			WHEN m.STATUS = 'DIN' THEN 'Deceased-Insolvent'
			ELSE 'PROMISE TO PAY'--substring(n.comment,0,140)
		end
		WHEN m.customer in ('0002468','0002469') THEN
		CASE WHEN m.status like 'B%' THEN 'BANKRUPTCY'
			WHEN m.status in ('CAD','CND') THEN 'CEASE AND DESIST'
			WHEN M.STATUS = 'DEC' THEN 'DECEASED'
			WHEN M.STATUS = 'DPV' THEN 'DEBTOR DISPUTES ACCOUNT'
			WHEN m.STATUS = 'FRD' THEN 'FRAUD'
			WHEN m.status = 'PIF' THEN 'PAID IN FULL'
			WHEN m.status = 'SIF' THEN 'SETLD IN FULL/DO NOT RPT'
			WHEN m.STATUS = 'RSK' THEN 'LITIGIOUS DEBTOR'
			WHEN M.STATUS = 'MIL' THEN 'Active/Deployed Military'
			WHEN M.STATUS = 'DIP' THEN 'Debtor-In-Prison'
			WHEN M.STATUS = 'POA' THEN 'POWER OF ATTY'
			WHEN m.STATUS = 'WVI' THEN 'West Virginia'
			--WHEN m.STATUS = 'AEX' THEN 'UNCOLLECTABLE'
			WHEN m.STATUS = 'OOS' THEN 'Out of Stat'
			WHEN m.STATUS = 'DIN' THEN 'Deceased-Insolvent'
			WHEN m.STATUS = 'PCL' THEN 'BUSINESS CLOSED'
			WHEN m.STATUS = 'CMP' THEN 'COMPLAINT'
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

WHERE m.status in ('DEC','CCS','CAD', 'DPV', 'PLV', 'RSK', 'FRD', 'CND', 'MIL', 'DIP', 'POA', 'WVI', 'OOS', 'DIN','PCL','CMP')
AND m.returned is null and m.qlevel = '998'
)
union all
(SELECT distinct --Note record select top 10 * from Deceased
	'4' AS [RecordCode],
	cast(isnull(m.closed,NULL) as smalldatetime) as [Date],--n.created as [Date],
	CASE WHEN m.customer in ('0001220', '0001256','0001257','0001258','0002462') THEN
		CASE 
			when m.status='SIF' then 'SIF'
			when m.status='PIF' then 'PIF'
		END
	WHEN m.customer in ('0002468', '0002469') THEN
		CASE 
			WHEN m.STATUS = 'SIF' THEN 'SIF'
			WHEN m.STATUS = 'PIF' THEN 'PPF'
		END 		
	END AS [NoteCode],--outgoing note code
	--substring(n.comment,0,140) AS [Narrative1],
	CASE WHEN m.customer in ('0001220', '0001256','0001257','0001258','0002462') THEN
		CASE 
			WHEN m.status = 'PIF' THEN 'PAID IN FULL'
			WHEN m.status = 'SIF' THEN 'SETLD IN FULL/DO NOT RPT'
		END
	WHEN m.customer in ('0002468', '0002469') THEN
		CASE 
			WHEN m.status = 'PIF' THEN 'PAID IN FULL'
			WHEN m.status = 'SIF' THEN 'SETLD IN FULL/DO NOT RPT'
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
AND dbo.date(m.closed) between dbo.date((@startdate - 15)) and dbo.date((getdate() - 15) )
and m.returned is null and m.qlevel = '998'
)
union all
(SELECT distinct --Note record select top 10 * from Deceased
	'4' AS [RecordCode],
	cast(GETDATE() as smalldatetime) as [Date],--n.created as [Date],
	case 
		WHEN m.customer = '0001220' THEN 
			case 
				when m.status IN ('BKY', 'B07', 'B11', 'B13') then 'DBK'
				when m.status IN ('VRB', 'BKO') then 'BKP'
				WHEN m.STATUS IN ('VCD') THEN 'CAD'
			END
		WHEN m.customer in ('0001256','0001257','0001258','0002462') THEN		
			case 
				when m.status IN ('BKY', 'B07', 'B11', 'B13') then 'BKT'
				when m.status IN ('VRB', 'BKO') then 'BKP'
				WHEN m.STATUS IN ('VCD') THEN 'CAD'
			END 
		WHEN m.customer in ('0002468','0002469') THEN		
			case 
				when m.status IN ('BKY', 'B07', 'B11', 'B13', 'BKO','VRB') then 'PBT'
				--when m.status IN ('VRB') then 'PPB'
				WHEN m.STATUS IN ('VCD') THEN 'PCD'
			END 	
	end
	AS [NoteCode],--outgoing note code
	--substring(n.comment,0,140) AS [Narrative1],
	CASE 	
		WHEN m.status IN ('BKY', 'B07', 'B11', 'B13', 'BKO','VRB') THEN 'BANKRUPTCY'
		--WHEN m.status IN ('VRB') THEN 'BANKRUPTCY PENDING'
		WHEN m.STATUS IN ('VCD') THEN 'CEASE AND DESIST'
		
	END AS [Narrative1],
	--substring(n.comment,140,140) AS [Narrative2],
	'' AS [Narrative2],
	m.id2 AS [FirstDataAcct],
	m.account AS [AccountID]
--select top 10 * from master with(nolock)
FROM @tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
LEFT OUTER JOIN statushistory s WITH(NOLOCK) ON s.accountid= m.number
WHERE m.status in ('VRB', 'BKO', 'BKY', 'B07', 'B11', 'B13', 'VCD') AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
)

union all
(SELECT distinct --Note record select top 10 * from Deceased
	'4' AS [RecordCode],
	cast(GETDATE() as smalldatetime) as [Date],--n.created as [Date],
	case 
		WHEN m.customer = '0001220' THEN 
			case 
				when m.status IN ('BKY', 'B07', 'B11', 'B13') then 'DBK'
				when m.status IN ('VRB', 'BKO') then 'BKP'
				WHEN m.STATUS IN ('VCD') THEN 'CAD'
				WHEN m.STATUS IN ('pdc', 'pcc', 'ppa', 'nsf', 'dcc', 'dbd', 'npc', 'hot', 'mhd', 'nhd', 'DIS') THEN 'HLD'
				WHEN m.STATUS = 'LCP' THEN 'LTG'

			END
		WHEN m.customer in ('0001256','0001257','0001258','0002462') THEN		
			case 
				when m.status IN ('BKY', 'B07', 'B11', 'B13') then 'BKT'
				when m.status IN ('VRB', 'BKO') then 'BKP'
				WHEN m.STATUS IN ('VCD') THEN 'CAD'
				WHEN m.STATUS IN ('pdc', 'pcc', 'ppa', 'nsf', 'dcc', 'dbd', 'npc', 'hot', 'mhd', 'nhd', 'DIS') THEN 'HLD'
				WHEN m.STATUS = 'LCP' THEN 'LTG'

			END 
		WHEN m.customer in ('0002468','0002469') THEN		
			case 
				when m.status IN ('BKY', 'B07', 'B11', 'B13', 'BKO','VRB') then 'PBT'
				WHEN m.STATUS IN ('VCD') THEN 'PCD'
				WHEN m.STATUS IN ('pdc', 'pcc', 'ppa', 'nsf', 'dcc', 'dbd', 'npc', 'hot', 'mhd', 'nhd', 'DIS') THEN 'HLD'
				WHEN m.STATUS = 'LCP' THEN 'LTG'

			END 	
	end
	AS [NoteCode],--outgoing note code
	--substring(n.comment,0,140) AS [Narrative1],
	CASE 	
		WHEN m.status IN ('BKY', 'B07', 'B11', 'B13', 'BKO','VRB') THEN 'BANKRUPTCY'
		WHEN m.STATUS IN ('VCD') THEN 'CEASE AND DESIST'
		WHEN m.STATUS IN ('pdc', 'pcc', 'ppa', 'nsf', 'dcc', 'dbd', 'npc', 'hot', 'mhd', 'nhd', 'DIS') THEN '30 DAY HOLD FROM RECALL'
		WHEN m.STATUS = 'LCP' THEN 'LITIGIOUS DEBTOR'

	END AS [Narrative1],

--substring(n.comment,140,140) AS [Narrative2],
	'' AS [Narrative2],
	m.id2 AS [FirstDataAcct],
	m.account AS [AccountID]
--select top 10 * from master with(nolock)
FROM @tmpcms_count t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
LEFT OUTER JOIN statushistory s WITH(NOLOCK) ON s.accountid= m.number
WHERE m.status in ('VRB', 'BKY', 'B07', 'B11', 'B13', 'VCD', 'LCP', 'pdc', 'pcc', 'ppa', 'nsf', 'dcc', 'dbd', 'npc', 'hot', 'mhd', 'nhd', 'DIS') 
AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
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
CASE WHEN m.HomePhone IN (SELECT phonenumber FROM Phones_Master WITH (NOLOCK) WHERE Number = m.number AND PhoneNumber = m.homephone AND PhoneStatusID = 1 AND PhoneTypeID = 1) THEN '(000-000-0000)' ELSE m.homephone END AS HomePhone,
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
WHERE m.status in ('DEC','CCS','CAD','B07','B13','BKY', 'BKO', 'DPV', 'PLV', 'RSK', 'FRD', 'CND', 'MIL', 'DIP', 'POA', 'WVI', 'OOS', 'DIN','PCL','CMP')
AND m.returned is null and m.qlevel = '998'
and  m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))


update master set qlevel = '999', returned = CONVERT(DateTime, CONVERT(CHAR,getdate(), 103),103)
FROM @tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
--LEFT OUTER JOIN statushistory s WITH(NOLOCK) ON s.accountid= m.number
WHERE m.status in ('DEC','CCS','CAD','B07','B13','BKY', 'BKO', 'DPV', 'PLV', 'RSK', 'FRD', 'CND', 'MIL', 'DIP', 'POA', 'WVI', 'OOS', 'DIN','PCL','CMP')
AND m.returned is null and m.qlevel = '998'
and  m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))


insert into notes(number,created,user0,action,result,comment)
select m.number,getdate(),'EXCH_SP','+++++','+++++','Account was Returned to customer in a file'
FROM @tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
--LEFT OUTER JOIN statushistory s WITH(NOLOCK) ON s.accountid= m.number
WHERE m.status in ('PIF','SIF')
AND dbo.date(m.closed) between dbo.date((@startdate - 15)) and dbo.date((getdate() - 15) )
and m.returned is null and m.qlevel = '998'
and  m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))

update master set qlevel = '999', returned = CONVERT(DateTime, CONVERT(CHAR,getdate(), 103),103)
FROM @tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
--LEFT OUTER JOIN statushistory s WITH(NOLOCK) ON s.accountid= m.number
WHERE m.status in ('PIF','SIF')
AND dbo.date(m.closed) between dbo.date((@startdate - 15)) and dbo.date((getdate() - 15) )
and m.returned is null and m.qlevel = '998'
and  m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
GO
