SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Brian Meehan, Simm Associates, Inc.
-- Create date: 4/20/2013
-- Description:	Prepares Notes information to send to client
-- =============================================

/*Use below for testing output

declare @startDate datetime
declare @endDate datetime
declare @customer varchar(8000)

set @startDate='20130416'
set @endDate='20130418'
--set @endDate='12/20/2006 12:15:00'
set @customer='255001|255002|255003|255004|256001|256002'
exec Custom_RTR_Chase_Auto_Upload_Notes @startDate=@startDate,@endDate=@endDate,@customer=@customer
*/
CREATE                        PROCEDURE [dbo].[Custom_RTR_Chase_Auto_Upload_Notes_Old]
	 @startDate datetime,
	 @endDate datetime,
	 @customer varchar(8000)

AS
BEGIN

DECLARE @id2 VARCHAR(50)
declare cur cursor for 
	
	--load the cursor with the alpha codes from the customer table
	SELECT DISTINCT AlphaCode FROM customer WITH (NOLOCK) WHERE customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
	
open cur

--get the information from the cursor and into the variables
fetch from cur into @id2
while @@fetch_status = 0 begin

			IF EXISTS (SELECT * FROM tempdb.sys.tables WHERE name LIKE '#tmpcms_count%')
			DROP TABLE #tmpcms_count
			IF EXISTS (SELECT * FROM tempdb.sys.tables WHERE name LIKE '#tmpcms_close%')
			DROP TABLE #tmpcms_close
			IF EXISTS (SELECT * FROM tempdb.sys.tables WHERE name LIKE '#tmpcms%')
			DROP TABLE #tmpcms

			--Temp table for Address and phone changes
			create TABLE #tmpcms_count (
			[ID] [int] IDENTITY(1,1) NOT NULL,
			[number] [int] NOT NULL)
			
			--Load temp table with address accounts
			INSERT INTO #tmpcms_count (number)
			SELECT DISTINCT AccountID from AddressHistory a with (nolock)
			JOIN master m with (nolock)
			ON m.Number=a.AccountId INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
			WHERE a.DateChanged BETWEEN @startDate AND @endDate
			AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
			AND c.AlphaCode = @id2

			--Load temp table with phone accounts
			INSERT INTO #tmpcms_count (number)
			SELECT DISTINCT AccountID from PhoneHistory p with (nolock)
			JOIN master m with (nolock)
			ON m.Number=p.AccountId INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
			WHERE p.DateChanged BETWEEN @startDate AND @endDate
			AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
			AND p.NewNumber <> ''
			AND c.AlphaCode = @id2
			
			--Temp table for closed accounts
			CREATE TABLE #tmpcms_close (
			[ID] [int] IDENTITY(1,1) NOT NULL,
			[number] [int] NOT NULL,
			[amount] [money] NULL)

			--Insert closed accounts into closed table for all accounts except SIF PIF
			INSERT INTO #tmpcms_close (number,amount)
			SELECT distinct m.number,0
			FROM master m with(nolock) INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
			WHERE (m.status in ('ATY', 'CND', 'CAD', 'DEC', 'LDA', 'MIL', 'NPA', 'OFF', 'OOS', 'AEX', 'BKY', 'B07', 'B11', 'B13') or m.qlevel in('018','830','840','998'))
			and m.customer in (select string from dbo.CustomStringToSet(@customer, '|')) and m.returned is null
			and m.closed between @startdate and @enddate AND c.AlphaCode = @id2
			GROUP BY m.number

			--Insert closed accounts into closed table for SIF PIF accounts for full balance streams 4QFRTR and 4CFRTR
			INSERT INTO #tmpcms_close (number,amount)
			SELECT distinct m.number,0
			FROM master m with(nolock) INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
			WHERE m.status in ('SIF','PIF', 'BSA') AND m.closed between (@startdate - 10) and (@endDate - 10)--10 day hold for 4QF and 4CF customers change as needed for hold period
			and m.customer in (select string from dbo.CustomStringToSet(@customer, '|')) and m.returned is NULL AND c.AlphaCode IN ('4QFRTR', '4CFRTR')
			GROUP BY m.number

			--Insert closed accounts into closed table for SIF PIF accounts in all other streams
			INSERT INTO #tmpcms_close (number,amount)
			SELECT distinct m.number,0
			FROM master m with(nolock) INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
			WHERE m.status in ('SIF','PIF', 'BSA') AND m.closed between (@startdate - 30) and (@endDate - 30)--10 day hold for 4QF and 4CF customers change as needed for hold period
			and m.customer in (select string from dbo.CustomStringToSet(@customer, '|')) and m.returned is NULL AND c.AlphaCode NOT IN ('4QFRTR', '4CFRTR')
			GROUP BY m.number
			
CREATE TABLE #tmpcms (
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[number] [int] NOT NULL
)

INSERT INTO #tmpcms (number)
	SELECT DISTINCT AccountID from AddressHistory a
	JOIN master m with (nolock)
	ON m.Number=a.AccountId INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
	WHERE a.DateChanged BETWEEN @startDate AND @endDate
	AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|')) AND c.AlphaCode = @id2

insert into #tmpcms (number)
	SELECT DISTINCT AccountID from PhoneHistory p
	JOIN master m with (nolock)
	ON m.Number=p.AccountId INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
	WHERE p.DateChanged BETWEEN @startDate AND @endDate
	AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|')) AND c.AlphaCode = @id2
	AND p.NewNumber <> ''


SELECT DISTINCT --Header Record
	--RecordCode coded in exchange
	--Filler coded in exchange
	cast(getdate() as smalldatetime) as [Date],
	--Type=1 coded in exchange
	--SourceCode=1 coded in exchange
	m.customer, --reference only, not needed in file
	c.alphacode AS [AgencyCode], --Entered in the latitude customer properties Alpha Code field
	'Real Time Resolutions' AS [AgencyName],
	--Rec1 not used
	--Rec2 not used
	--Rec3 not used
	--Rec4 Note codes Get number of record 4 records
	(	select ISNULL(count(m.number) , 0)
		FROM master m with (nolock) INNER JOIN customer c WITH (NOLOCK) on m.customer = c.customer
		WHERE m.closed between @startDate AND @endDate
		AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
		AND m.status in ('ATY', 'CND', 'CAD', 'DEC', 'LDA', 'MIL', 'NPA', 'OFF', 'OOS', 'AEX', 'BKY', 'B07', 'B11', 'B13') 
		AND m.returned is null and m.qlevel = '998'	AND c.alphacode = @id2
	)
	+
	(	--Placement Acknowledgements
		SELECT ISNULL(COUNT(m.number), 0)
		FROM master m WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
		WHERE m.received BETWEEN @startDate AND @endDate AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
		AND c.AlphaCode = @id2
	)
	+
	(	--Bad Phone Notifications
		SELECT ISNULL(COUNT(m.number), 0)
		FROM master m WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
		INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
		WHERE n.action = '+++++' AND n.result = '+++++' AND created BETWEEN @startDate AND @endDate
		AND (n.comment LIKE 'Work%Bad' OR n.comment LIKE 'Home%Bad' OR n.comment LIKE 'Fax%Bad' OR n.comment LIKE 'Cell%Bad') --add in other phone types as needed or when added to system
		AND c.AlphaCode = @id2 
	)
	+
	(	--Autodialer no consent notifications
		SELECT ISNULL(COUNT(m.number), 0)
		FROM master m WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
		INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
		WHERE n.result = 'CD' AND created BETWEEN @startDate AND @endDate
		AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
		AND c.AlphaCode = @id2 
	)
	+
	(	--Autodialer yes consent notifications
		SELECT ISNULL(COUNT(m.number), 0)
		FROM master m WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
		INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
		WHERE n.result = 'CG' AND created BETWEEN @startDate AND @endDate
		AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
		AND c.AlphaCode = @id2 
	)
	+
	( --SIF/PIF/BSA Notifications for Full Balance customers
		SELECT ISNULL(COUNT(m.number), 0)
		FROM master m with(nolock) INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
		WHERE m.status in ('SIF','PIF', 'BSA') AND m.closed between (@startdate - 10) and (@endDate - 10)--10 day hold for 4QF and 4CF customers change as needed for hold period
		and m.customer in (select string from dbo.CustomStringToSet(@customer, '|')) and m.returned is NULL AND c.AlphaCode IN ('4QFRTR', '4CFRTR')
		AND c.AlphaCode = @id2		
	)
	+
	( --SIF/PIF/BSA Notifications for Other customers
		SELECT ISNULL(COUNT(m.number), 0)
		FROM master m with(nolock) INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
		WHERE m.status in ('SIF','PIF', 'BSA') AND m.closed between (@startdate - 30) and (@endDate - 30)--30 day hold for 4QF and 4CF customers change as needed for hold period
		and m.customer in (select string from dbo.CustomStringToSet(@customer, '|')) and m.returned is NULL AND c.AlphaCode NOT IN ('4QFRTR', '4CFRTR')
		AND c.AlphaCode = @id2
	)
		AS [NumRec4],
	--Rec5 demographic changes
	(
		select ISNULL(count(distinct m2.number) , 0)
		FROM #tmpcms_count t 
		JOIN master m2 with (nolock) ON m2.Number=t.Number 
		left JOIN CourtCases co with (nolock) ON m2.Number=co.AccountID 
		left JOIN Courts ct with (nolock) ON co.CourtID=ct.CourtID
		INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
		where m2.customer=m.customer AND c.AlphaCode = @id2
	)
		AS [NumRec5],
	--Filler coded in exchange
	'03300' AS [BankID] --Change bank ID when testing is over to production bank ID
	--Fills coded in exchange
FROM master m with (nolock)
left outer JOIN #tmpcms_count t ON m.number=t.number
left outer join #tmpcms t2 ON t2.number = m.number
left outer join #tmpcms_close t3 ON t3.number = m.number
INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
where m.customer in (select string from dbo.CustomStringToSet(@customer, '|')) and m.customer is not NULL 
AND c.AlphaCode = @id2


(--Gather Post date and Promise accounts to send
SELECT distinct 
	'4' AS [RecordCode],
	cast(isnull(isnull(p.deposit,s.datechanged),getdate())as smalldatetime) as [Date],--return either the deposit date of the post date or the date the status changed or current date
	CASE	
			WHEN m.STATUS IN ('PDC', 'PCC') THEN 'PPA'
			WHEN m.STATUS = 'PPA' THEN 'PTP'			
			ELSE 'PTP'
	END AS [NoteCode],--outgoing note code
	CASE 
			WHEN m.STATUS IN ('PDC', 'PCC') THEN 'Payment Arrangement'
			WHEN m.STATUS = 'PPA' THEN 'Promise to Pay'
			ELSE 'PROMISE TO PAY'
	END AS [Narrative1], --Must use these narratives
	'' AS [Narrative2],  --not used for Promises/post-dates
	c.AlphaCode AS [FirstDataAcct], --Entered in the latitude customer properties Alpha Code field
	m.account AS [AccountID]
FROM #tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
LEFT OUTER JOIN statushistory s WITH(NOLOCK) ON s.accountid= m.number
LEFT OUTER JOIN pdc p on p.number = m.number
INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
WHERE m.qlevel in('018', '820', '830','840') and p.deposit between @startDate and @endDate AND c.AlphaCode = @id2
)
union all
(--Gather closed accounts
SELECT distinct 
	'4' AS [RecordCode],
	cast(isnull(m.closed,NULL) as smalldatetime) as [Date],
	CASE WHEN m.STATUS = 'ATY' THEN 'ATY'
			WHEN m.STATUS IN ('CND', 'CAD') THEN 'CD'
			WHEN m.STATUS = 'CCR' THEN 'CCR'
			WHEN m.STATUS = 'LDA' THEN 'LDA'
			WHEN m.STATUS = 'MIL' THEN 'MIL'
			WHEN m.STATUS = 'NPA' THEN 'NPA'
			WHEN m.STATUS = 'OFF' THEN 'OFF'
			WHEN m.STATUS = 'OOS' THEN 'OOS'
			WHEN m.STATUS = 'AEX' THEN 'UNC'
			ELSE ''
	END AS [NoteCode],--outgoing note code
	CASE WHEN m.status = 'ATY' THEN 'DBTR REPRESENTED BY ATTY'
			WHEN m.status = 'BSA' THEN 'Below Settlement Authority'
			WHEN M.STATUS IN ('CND', 'CAD') THEN 'Cease & Desist'
			WHEN M.STATUS = 'CCR' THEN 'Client Close & Return'
			WHEN m.status = 'LDA' THEN 'Litigious Debtor Account'
			WHEN m.status = 'MIL' THEN 'Military Status'
			WHEN m.STATUS = 'NPA' THEN 'Non-pursuable account'
			WHEN m.STATUS = 'OFF' THEN 'Possible Offset'
			WHEN m.STATUS = 'OOS' THEN 'OUT OF STATUTE'
			WHEN m.STATUS = 'AEX' THEN 'Return Uncollectable'
			ELSE ''
	END AS [Narrative1],
	'' AS [Narrative2],
	c.AlphaCode AS [FirstDataAcct],
	m.account AS [AccountID]
FROM #tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
LEFT OUTER JOIN statushistory s WITH(NOLOCK) ON s.accountid= m.number
INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
WHERE m.status in ('ATY', 'CND', 'CAD', 'LDA', 'MIL', 'NPA', 'OFF', 'OOS', 'AEX')
AND m.returned is null and m.qlevel = '998' AND c.AlphaCode = @id2
)
union all
(--Gather SIF PIF Accounts
SELECT distinct 
	'4' AS [RecordCode],
	cast(isnull(m.closed,NULL) as smalldatetime) as [Date],
	CASE 
			WHEN m.STATUS = 'BSA' THEN 'BSA'
			WHEN m.STATUS = 'PIF' THEN 'PIF'
			WHEN m.STATUS = 'SIF' THEN 'SIF'
			ELSE ''
	END AS [NoteCode],--outgoing note code
	CASE 
			WHEN m.STATUS = 'BSA' THEN 'Below Settlement Authority'
			WHEN m.status = 'PIF' THEN 'Return Paid in Full'
			WHEN m.status = 'SIF' THEN 'Return Settled in Full'
			ELSE ''
	END AS [Narrative1],
	'' AS [Narrative2],
	c.AlphaCode AS [FirstDataAcct],
	m.account AS [AccountID]
FROM #tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
LEFT OUTER JOIN statushistory s WITH(NOLOCK) ON s.accountid= m.number
INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
WHERE m.status in ('BSA', 'PIF', 'SIF')
AND ((m.closed between (@startdate - 30) and (@endDate - 30) and @id2 NOT in ('4QFRTR', '4CFRTR')) or 
(m.closed between (@startdate - 10) and (@endDate - 10) and @id2 in ('4QFRTR', '4CFRTR')))--Hold days
and m.returned is null and m.qlevel = '998' AND c.AlphaCode = @id2
)
union all
(-- Gather Bankruptcy information
SELECT distinct 
	'4' AS [RecordCode],
	cast(GETDATE() as smalldatetime) as [Date],
	case 
		when m.status IN ('BKY', 'B07', 'B11', 'B13') then 'BAC'
		ELSE ''
	END AS [NoteCode],--outgoing note code
	CASE 	WHEN m.status IN ('BKY', 'B07', 'B11', 'B13') THEN 'Return Bankruptcy Confirmed'
		ELSE ''
	END AS [Narrative1],
	'case # ' + b.CaseNumber + ' Filed ' + CONVERT(VARCHAR(10), b.DateFiled, 101) + ' Chapter ' + CONVERT(VARCHAR(2), b.chapter) + 'Attorney ' + da.Name + ' ' + da.City + ' '  + da.State + ' ' + da.Phone AS [Narrative2],
	c.AlphaCode AS [FirstDataAcct],
	m.account AS [AccountID]
FROM #tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
INNER JOIN dbo.Bankruptcy b WITH (NOLOCK) ON d.DebtorID = b.DebtorID
INNER JOIN dbo.DebtorAttorneys da WITH (NOLOCK) ON d.DebtorID = da.DebtorID
WHERE m.status in ('BKY', 'B07', 'B11', 'B13') AND c.AlphaCode = @id2
and m.returned is null and m.qlevel = '998'
)
UNION ALL
(-- Gather Deceased information
SELECT distinct 
	'4' AS [RecordCode],
	cast(GETDATE() as smalldatetime) as [Date],
	case 
		when m.status IN ('DEC') then 'DEC'
		ELSE ''
	END AS [NoteCode],--outgoing note code
	CASE 	WHEN m.status IN ('DEC') THEN 'Return Deceased'
		ELSE ''
	END AS [Narrative1],
	'DOD ' + CONVERT(VARCHAR(10), de.DOD, 101) + ' Court ' + de.CourtDivision + ' ' + de.courtstreet1 + ' ' + de.CourtCity + ' ' + de.CourtState + ' ' + de.CourtZipcode + ' ' + de.CourtPhone AS [Narrative2],
	c.AlphaCode AS [FirstDataAcct],
	m.account AS [AccountID]
FROM #tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
LEFT OUTER JOIN statushistory s WITH(NOLOCK) ON s.accountid= m.number
INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
INNER JOIN deceased de WITH (NOLOCK) ON d.DebtorID = de.DebtorID
WHERE m.status in ('DEC') AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|')) AND c.AlphaCode = @id2
and m.returned is null and m.qlevel = '998'
)
UNION ALL
(--Gather bad cell phone numbers
SELECT distinct 
	'4' AS [RecordCode],
	cast(GETDATE() as smalldatetime) as [Date], 
	'CCE' AS [NoteCode], 
	'Cease and Desist Cell Phone - Do Not Call ' + REPLACE(REPLACE(REPLACE(substring(n.comment, 6, 14), '(', ''), ')', ''), ' ', '-') AS [Narrative1],
	'' AS [Narrative2],
	c.AlphaCode AS [FirstDataAcct],
	m.account AS [AccountID]
FROM master m WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
		WHERE n.action = '+++++' AND n.result = '+++++' AND created BETWEEN @startDate AND @endDate
		AND n.comment LIKE 'Cell%Bad' AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
		AND c.AlphaCode = @id2 
)
UNION ALL
(--Gather bad phone numbers
SELECT distinct 
	'4' AS [RecordCode],
	cast(GETDATE() as smalldatetime) as [Date], 
	'TPN' AS [NoteCode], 
	'Third Party Number - Do Not Call ' + REPLACE(REPLACE(REPLACE(substring(n.comment, 6, 14), '(', ''), ')', ''), ' ', '-') AS [Narrative1],
	'' AS [Narrative2],
	c.AlphaCode AS [FirstDataAcct],
	m.account AS [AccountID]
FROM master m WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
		WHERE n.action = '+++++' AND n.result = '+++++' AND created BETWEEN @startDate AND @endDate
		AND (n.comment LIKE 'Work%Bad' OR n.comment LIKE 'Home%Bad' OR n.comment LIKE 'Fax%Bad') --add in other phone types as needed or when added to system
		AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
		AND c.AlphaCode = @id2 
)
UNION ALL
(--Gather auto dialer no consent
SELECT distinct 
	'4' AS [RecordCode],
	cast(GETDATE() as smalldatetime) as [Date], 
	'NCC' AS [NoteCode], 
	'No Cell Phone Autodialer Consent - Do Not Auto-Dial ' + REPLACE(REPLACE(REPLACE(REPLACE(RIGHT(CONVERT(VARCHAR(55), n.comment), 14), '(', ''), ')', ''), ' ', ''), '-', '') AS [Narrative1],
	'' AS [Narrative2],
	c.AlphaCode AS [FirstDataAcct],
	m.account AS [AccountID]
FROM master m WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
		WHERE n.result = 'CD' AND created BETWEEN @startDate AND @endDate
		AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
		AND c.AlphaCode = @id2 
)
UNION ALL
(--Gather auto dialer no consent
SELECT distinct 
	'4' AS [RecordCode],
	cast(GETDATE() as smalldatetime) as [Date], 
	'CLL' AS [NoteCode], 
	'Cell Phone Autodialer Consent - ' + REPLACE(REPLACE(REPLACE(REPLACE(RIGHT(CONVERT(VARCHAR(55), n.comment), 14), '(', ''), ')', ''), ' ', ''), '-', '') AS [Narrative1],
	'' AS [Narrative2],
	c.AlphaCode AS [FirstDataAcct],
	m.account AS [AccountID]
FROM master m WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
		WHERE n.result = 'CG' AND created BETWEEN @startDate AND @endDate
		AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
		AND c.AlphaCode = @id2 
)
UNION ALL

( --Get all newly placed accounts
SELECT distinct 
	'4' AS [RecordCode],
	cast(GETDATE() as smalldatetime) as [Date], 
	'ACK' AS [NoteCode], 
	'PLACEMENT ACKNOWLEDGEMENT FROM ' + c.AlphaCode + '.' AS [Narrative1],
	'' AS [Narrative2],
	c.AlphaCode AS [FirstDataAcct],
	m.account AS [AccountID]
FROM master m WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
		WHERE m.received BETWEEN @startDate AND @endDate AND m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
		AND c.AlphaCode = @id2
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
'' as [id1],
m.account

FROM #tmpcms t
JOIN master m with (nolock) ON m.Number=t.Number AND m.id2 = @id2
left JOIN CourtCases c with (nolock) ON m.Number=c.AccountID
left JOIN Courts ct with (nolock) ON c.CourtID=ct.CourtID


/*  Might not be needed since they will send recall codes on accounts as sent above
--Insert note on account that is returned with below close codes
insert into notes(number,created,user0,action,result,comment)
select m.number,getdate(),'EXCH_SP','+++++','+++++','Account was Returned to customer in a file'
FROM #tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
WHERE m.status in ('DEC','CCC','CAD','B07','B13','BKY', 'PLV', 'RSK', 'FRD', 'CND')
AND m.returned is null and m.qlevel = '998'
and  m.customer IN (select string from dbo.CustomStringToSet(@customer, '|')) AND c.AlphaCode = @id2

--Update master to set account as returned
update master set qlevel = '999', returned = CONVERT(DateTime, CONVERT(CHAR,getdate(), 103),103)
FROM #tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
WHERE m.status in ('DEC','CCC','CAD','B07','B13','BKY', 'PLV', 'RSK', 'FRD', 'CND')
AND m.returned is null and m.qlevel = '998'
and  m.customer IN (select string from dbo.CustomStringToSet(@customer, '|')) AND c.AlphaCode = @id2

--Insert note on account that is returned as SIF PIF
insert into notes(number,created,user0,action,result,comment)
select m.number,getdate(),'EXCH_SP','+++++','+++++','Account was Returned to customer in a file'
FROM #tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
WHERE m.status in ('PIF','SIF')
AND m.closed between (@startdate - 15) and (getdate() - 15) 
and m.returned is null and m.qlevel = '998'
and  m.customer IN (select string from dbo.CustomStringToSet(@customer, '|')) AND c.AlphaCode = @id2

--update master to set accounts as returned
update master set qlevel = '999', returned = CONVERT(DateTime, CONVERT(CHAR,getdate(), 103),103)
FROM #tmpcms_close t
LEFT OUTER JOIN master m with (nolock) ON t.number = m.number
INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
WHERE m.status in ('PIF','SIF')
AND m.closed between (@startdate - 15) and (getdate() - 15) 
and m.returned is null and m.qlevel = '998'
and  m.customer IN (select string from dbo.CustomStringToSet(@customer, '|')) AND c.AlphaCode = @id2
*/



fetch from cur into @id2
	
end
DROP TABLE #tmpcms_count
DROP TABLE #tmpcms_close
DROP TABLE #tmpcms
--close and free up all the resources.
close cur
deallocate cur
end
GO
