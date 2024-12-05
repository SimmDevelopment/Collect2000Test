SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 01/14/2021
-- Description:	Create Non-Monetary file for upload
-- Changes:
-- =============================================

--exec Custom_UnionBank_Post_Export_NonMon_File '20210510', '20210510'

CREATE PROCEDURE [dbo].[Custom_UnionBank_Post_Export_NonMon_File] 
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
DECLARE @customer INT
SET @customer = 319	

SET @startDate = CONVERT(VARCHAR, DATEADD(hh, 16, dbo.F_START_OF_DAY(@startDate -1)))
SET @endDate = CONVERT(VARCHAR, DATEADD(hh, 16, dbo.F_START_OF_DAY(@endDate)))


--Drop temp tables if they already exist
IF EXISTS ( SELECT  *
	FROM    tempdb.sys.tables
	WHERE   name LIKE '#tmpSysPrin%' ) 
		BEGIN
			DROP TABLE #tmpSysPrin
		END
IF EXISTS ( SELECT  *
    FROM    tempdb.sys.tables
    WHERE   name LIKE '#tmprecord216%' ) 
		BEGIN
			DROP TABLE #tmprecord216
		END      

IF EXISTS ( SELECT  *
    FROM    tempdb.sys.tables
    WHERE   name LIKE '#tmprecord037%' ) 
		BEGIN
			DROP TABLE #tmprecord037
		END      

IF EXISTS ( SELECT  *
    FROM    tempdb.sys.tables
    WHERE   name LIKE '#tmprecord056%' ) 
		BEGIN
			DROP TABLE #tmprecord056
		END      

IF EXISTS ( SELECT  *
    FROM    tempdb.sys.tables
    WHERE   name LIKE '#tmprecord115%' ) 
		BEGIN
			DROP TABLE #tmprecord115
		END
		
IF EXISTS ( SELECT  *
    FROM    tempdb.sys.tables
    WHERE   name LIKE '#tmprecord698%' ) 
		BEGIN
			DROP TABLE #tmprecord698
		END 
		
IF EXISTS ( SELECT  *
    FROM    tempdb.sys.tables
    WHERE   name LIKE '#tmprecord699%' ) 
		BEGIN
			DROP TABLE #tmprecord699
		END 
		
--IF EXISTS ( SELECT  *
--    FROM    tempdb.sys.tables
--    WHERE   name LIKE '#tmprecord783%' ) 
--		BEGIN
--			DROP TABLE #tmprecord783
--		END      
		
IF EXISTS ( SELECT  *
    FROM    tempdb.sys.tables
    WHERE   name LIKE '#tmprecord793%' ) 
		BEGIN
			DROP TABLE #tmprecord793
		END      			     		      

--Create Temp Table to store customer alphacodes
CREATE TABLE #tmpSysPrin
(
  [ID] [int] IDENTITY(1, 1)
             NOT NULL ,
  [SysPrin] VARCHAR(10) NOT NULL
)

--Permanent Collection Code
CREATE TABLE #tmprecord216
(
  [ID] [int] IDENTITY(1, 1)
             NOT NULL ,
  [AccountNumber] VARCHAR(16) NULL ,
  [TransID] VARCHAR(3) NULL,
  [SubTran] VARCHAR(2) NULL ,
  [CollAssign] VARCHAR(2) NULL,
  [UserID] VARCHAR(6) NULL,
  [SysPrin] VARCHAR(10) NULL    

)

--Update Home Phone
CREATE TABLE #tmprecord037
(
  [ID] [int] IDENTITY(1, 1)
             NOT NULL ,
  [AccountNumber] VARCHAR(16) NULL ,
  [TransID] VARCHAR(3) NULL,
  [HomePhoneNumber] VARCHAR(10) NULL ,
  [UserID] VARCHAR(6) NULL,
  [SysPrin] VARCHAR(10) NULL
)

--Update Work Phone
CREATE TABLE #tmprecord056
(
  [ID] [int] IDENTITY(1, 1)
             NOT NULL ,
  [AccountNumber] VARCHAR(16) NULL ,
  [TransID] VARCHAR(3) NULL,
  [WorkPhoneNumber] VARCHAR(10) NULL ,
  [UserID] VARCHAR(6) NULL,
  [SysPrin] VARCHAR(10) NULL
)

--Send Memo
CREATE TABLE #tmprecord115
(
  [ID] [int] IDENTITY(1, 1)
             NOT NULL ,
  [AccountNumber] VARCHAR(16) NULL ,
  [TransID] VARCHAR(3) NULL,
  [UserID] VARCHAR(3) NULL,
  [Memo] VARCHAR(57) NULL ,
  [SysPrin] VARCHAR(10) NULL,
  [seq] int null
)

--Update Address
CREATE TABLE #tmprecord698
(
  [ID] [int] IDENTITY(1, 1)
             NOT NULL ,
  [AccountNumber] VARCHAR(16) NULL ,
  [TransID] VARCHAR(3) NULL,
  [SubTran] VARCHAR(2) NULL,
  [CustNumber] VARCHAR(2) NULL ,
  [AddressTypeCode] VARCHAR(1) NULL ,
  [AddrData] VARCHAR(50) NULL ,
  [Filler] VARCHAR (50) ,
  [SysPrin] VARCHAR(10) NULL    
)

--Update Cell Phone
CREATE TABLE #tmprecord699
(
  [ID] [int] IDENTITY(1, 1)
             NOT NULL ,
  [AccountNumber] VARCHAR(16) NULL ,
  [TransID] VARCHAR(3) NULL,
  [SubCode] VARCHAR(4) NULL,
  [CellPhoneNumber] VARCHAR(10) NULL ,
  [UserID] VARCHAR(6) NULL,  
  [SysPrin] VARCHAR(10) NULL
)

--Update Email
CREATE TABLE #tmprecord783
(
  [ID] [int] IDENTITY(1, 1)
             NOT NULL ,
  [AccountNumber] VARCHAR(16) NULL ,
  [TransID] VARCHAR(3) NULL,
  [SubTran] VARCHAR(2) NULL,
  [HighRiskCollID] VARCHAR(3) NULL ,
  [UserID] VARCHAR(6) NULL,  
  [SysPrin] VARCHAR(10) NULL    
)

--High Risk Collection ID
CREATE TABLE #tmprecord793
(
  [ID] [int] IDENTITY(1, 1)
             NOT NULL ,
  [AccountNumber] VARCHAR(16) NULL ,
  [TransID] VARCHAR(3) NULL,
  [SubCode] VARCHAR(4) NULL,
  [EmailAddress] VARCHAR(50) NULL ,
  [UserID] VARCHAR(6) NULL,  
  [SysPrin] VARCHAR(10) NULL
)

--Get all SysPrin Combos
INSERT INTO #tmpSysPrin
        (SysPrin)
SELECT m.id2
FROM master m WITH (NOLOCK)
WHERE customer IN ('0001118', '0001121', '0001122')

--Record 216 Add Permanent Collection Code *****(Need to program this still)*******
INSERT INTO #tmprecord216 
		 (AccountNumber, TransID, SubTran, CollAssign, UserID, SysPrin )
SELECT m.account, '216' AS TransID, '14' AS SubTran, 
		CASE WHEN status IN ('BKY', 'B07', 'B11', 'B13') AND customer IN ('0001118', '0001122') THEN '1B' 
			WHEN status IN ('BKY', 'B07', 'B11', 'B13') AND customer = '0001121' THEN '2B'
			WHEN status IN ('CAD', 'CND') THEN 'CD'
			WHEN status IN ('DEC') AND customer IN ('0001118', '0001122') THEN '1D'
			WHEN status IN ('DEC') AND customer = '0001121' THEN '2D'
			WHEN status = 'PIF' THEN 'ZP'
			WHEN status = 'SIF' THEN 'ZS'
			WHEN status = 'AEX' THEN 'ZZ'
			WHEN status = 'MIL' THEN 'ZM'
			WHEN status IN ('RSK') AND customer IN ('0001118', '0001122') THEN '1L'
			WHEN status IN ('RSK') AND customer = '0001121' THEN '2L'
			WHEN status IN ('FRD') AND customer IN ('0001118', '0001122') THEN '1F'
			WHEN status IN ('FRD') AND customer = '0001121' THEN '2F'
			WHEN status IN ('CCR', 'DIP', 'RCL') THEN 'UH'
			WHEN status IN ('ATY') AND customer IN ('0001118', '0001122') THEN '1L'
			WHEN status IN ('ATY') AND customer = '0001121' THEN '2L'
			ELSE '  ' END AS CollAssign, 'SIM ZZ' AS UserID, m.id2 AS SysPrin
FROM master m WITH (NOLOCK)
WHERE customer IN ('0001118', '0001121', '0001122') 
AND ((status IN ('AEX', 'ATY', 'BKY', 'B07', 'B11', 'B13', 'CAD', 'CCR', 'CND', 'DEC', 'DIP', 'FRD', 'MIL', 
	'RCL', 'RSK') 
	AND closed BETWEEN @startDate AND @endDate) 
	OR (status IN ('SIF', 'PIF') AND closed BETWEEN DATEADD(dd, 0, @startdate) AND DATEADD(dd, 0, @enddate)))-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))

UNION ALL

SELECT m.account, '216' AS TransID, '14' AS SubTran, 
		CASE 
			WHEN status IN ('ALV') AND customer IN ('0001118', '0001122') THEN '1A'
			WHEN status IN ('ALV') AND customer = '0001121' THEN '2A'
			ELSE '  ' END AS CollAssign, 'SIM ZZ' AS UserID, m.id2 AS SysPrin
FROM master m WITH (NOLOCK) INNER JOIN dbo.StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID
WHERE customer IN ('0001118', '0001121', '0001122') 
AND status IN ('ALV') AND m.number IN (SELECT accountid FROM statushistory WITH (NOLOCK) WHERE m.number = AccountID AND NewStatus = 'ALV' AND DateChanged BETWEEN @startDate AND @endDate)
	

--UNION ALL

----Record 029 Add Permanent Collection Code Attorney Rep
--SELECT m.account, '029' AS TransID, '800' AS CollCode, '       ' AS Keyword, 'SIM ZZ' AS UserID, m.id2 AS SysPrin
--FROM master m WITH (NOLOCK)
--WHERE customer IN ('0001118', '0001121', '0001122') AND status = 'ATY' AND closed BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))

--UNION ALL

----Record 029 Add Permanent Collection Code Cease and Desist
--SELECT m.account, '029' AS TransID, '851' AS CollCode, '       ' AS Keyword, 'SIM ZZ' AS UserID, m.id2 AS SysPrin
--FROM master m WITH (NOLOCK)
--WHERE customer IN ('0001118', '0001121', '0001122') AND status IN ('CAD', 'CND') AND closed BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))


--Record 037 Update Home Phone
INSERT INTO #tmprecord037
        (AccountNumber ,TransID ,HomePhoneNumber ,UserID , SysPrin)
SELECT hp.account, '037', dbo.StripNonDigits(hp.PhoneNumber) AS newnumber, 'SIM ZZ', hp.sysprin AS SysPrin
FROM (SELECT m.account, DateAdded, PhoneNumber, m.id2 AS sysprin
FROM master m WITH (NOLOCK) INNER JOIN Phones_Master pm WITH (NOLOCK) ON m.number = pm.Number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND PhoneTypeID = 1 AND Phonestatusid = 2 AND DateAdded BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))
AND pm.LoginName <> 'SYNC'

UNION all

SELECT m.account, DateChanged AS DateAdded, CASE WHEN NewNumber = '' THEN '0000000000' ELSE dbo.StripNonDigits(NewNumber) END AS newnumber, CASE WHEN SUBSTRING(m.id1, 6, 1) = '5' THEN '3599' ELSE '3616' END + '  ' +  CASE WHEN SUBSTRING(m.id1, 7, 1) = '1' THEN '1000' ELSE '2000' END AS sysprin
FROM master m WITH (NOLOCK) INNER JOIN PhoneHistory ph WITH (NOLOCK) ON m.number = ph.AccountID
WHERE m.customer IN ('0001118', '0001121', '0001122') AND ((oldnumber not IN ('0000000000', '9999999999') AND ph.newnumber = '') OR (ph.NewNumber <> '')) AND phonetype = 1 AND DateChanged BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))
) hp
ORDER BY hp.DateAdded desc

--Record 056 Update Work Phone
INSERT INTO #tmprecord056
        (AccountNumber ,TransID ,WorkPhoneNumber ,UserID , SysPrin)
SELECT hp.account, '056', dbo.StripNonDigits(hp.PhoneNumber) AS newnumber, 'SIM ZZ', hp.SysPrin
FROM (SELECT m.account, DateAdded, PhoneNumber, m.id2 AS sysprin
FROM master m WITH (NOLOCK) INNER JOIN Phones_Master pm WITH (NOLOCK) ON m.number = pm.Number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND PhoneTypeID = 2 AND Phonestatusid = 2 AND DateAdded BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))
AND pm.LoginName <> 'SYNC'

UNION all

SELECT m.account, DateChanged AS DateAdded, CASE WHEN NewNumber = '' THEN '0000000000' ELSE NewNumber END AS newnumber, m.id2 AS sysprin
FROM master m WITH (NOLOCK) INNER JOIN PhoneHistory ph WITH (NOLOCK) ON m.number = ph.AccountID
WHERE m.customer IN ('0001118', '0001121', '0001122') AND ((oldnumber not IN ('0000000000', '9999999999') AND ph.newnumber = '') OR (ph.NewNumber <> '')) AND phonetype = 2 AND DateChanged BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))
) hp
ORDER BY hp.DateAdded desc	

--Record 115 Memo or Note RPC and payment/Promise Taken
INSERT INTO #tmprecord115
        (AccountNumber ,TransID ,UserID , Memo ,SysPrin, seq)
--SELECT DISTINCT m.account, '115', 'SIM' AS UserID, CASE WHEN n.ACTION LIKE 'I%' THEN 'INB ' ELSE 'OB ' END + CASE WHEN n.result IN ('tt') then 'Right party contacted'
--ELSE SUBSTRING(ISNULL('Payment Taken: ' + (SELECT TOP 1 CONVERT(VARCHAR(10), amount) FROM promises p WITH (NOLOCK) WHERE AcctID = m.number ORDER BY DueDate desc) 
--	+ ' Due: ' + (SELECT TOP 1 CONVERT(VARCHAR(10), DueDate, 101) FROM promises p WITH (NOLOCK) WHERE AcctID = m.number ORDER BY DueDate desc), 'Payment Taken, No info available'), 1, 57) END AS Memo, m.id2 AS SysPrin, 0 AS seq
--FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
--WHERE m.customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))
--AND n.result IN ('ipay', 'achcc', 'i99', 'pay', 'pp', 'tt')

--UNION ALL

--Record 115 Memmo or Note BKY/DEC/RSK/MIL
SELECT DISTINCT m.account, '115', 'SIM' AS UserID, CASE WHEN m.status IN ('BKY', 'B07', 'B11', 'B13', 'B12') THEN 'CHP ' + CONVERT(VARCHAR(3), b.Chapter) + ' filed ' + CONVERT(VARCHAR(10), b.DateFiled, 101) + ' case ' + b.casenumber 
WHEN m.STATUS = 'DEC' THEN 'DOD ' + CONVERT(VARCHAR(10), d2.dod, 101) END AS Memo, 
m.id2 AS SysPrin, 0 AS seq
FROM master m WITH (NOLOCK) INNER JOIN dbo.Debtors d WITH (NOLOCK) ON m.number = d.Number LEFT OUTER JOIN dbo.Bankruptcy b WITH (NOLOCK) ON d.DebtorID = b.DebtorID
LEFT OUTER JOIN dbo.Deceased d2 WITH (NOLOCK) ON d.DebtorID = d2.DebtorID
WHERE m.customer IN ('0001118', '0001121', '0001122') AND m.status IN ('DEC', 'BKY', 'B07', 'B11', 'B13', 'B12') AND closed BETWEEN @startDate AND @endDate
AND (d.debtorid =b.DebtorID OR d.DebtorID = d2.DebtorID)

UNION ALL

SELECT DISTINCT m.account, '115', 'SIM' AS UserID, CASE WHEN ah.oldstreet1 <> ah.newstreet1 THEN 'STR1UPD ' ELSE '' END + CASE WHEN ah.OldStreet2 <> ah.NewStreet2 THEN 'STR2UPD ' ELSE '' END
	 + CASE WHEN ah.OldCity <> ah.NewCity THEN 'CITYUPD ' ELSE '' END + CASE WHEN ah.OldState <> ah.NewState THEN 'STATEUPD ' ELSE '' END 
	 + CASE WHEN ah.OldZipcode <> ah.NewZipcode THEN 'ZIPUPD' ELSE '' END AS Memo,
m.id2 AS SysPrin, 0 AS seq
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0 INNER JOIN AddressHistory ah WITH (NOLOCK) ON d.DebtorID = ah.DebtorID
WHERE customer IN ('0001118', '0001121', '0001122') AND datechanged BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))

UNION ALL

SELECT DISTINCT m.account, '115', 'SIM' AS UserID, CASE WHEN n.ACTION LIKE 'I%' THEN 'INB ' ELSE 'OB ' END + CASE WHEN n.result IN ('tt') then 'Right party contacted'
ELSE SUBSTRING(ISNULL('Payment Taken: ' + (SELECT TOP 1 CONVERT(VARCHAR(10), amount) FROM promises p WITH (NOLOCK) WHERE AcctID = m.number ORDER BY DueDate desc) 
	+ ' Due: ' + (SELECT TOP 1 CONVERT(VARCHAR(10), DueDate, 101) FROM promises p WITH (NOLOCK) WHERE AcctID = m.number ORDER BY DueDate desc), 'Payment Taken, No info available'), 1, 57) END AS Memo, 
	m.id2 AS SysPrin, 1 AS seq
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate
AND n.result IN ('ipay', 'achcc', 'i99', 'pay', 'pp')

UNION ALL

SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 0, 57), '') AS Memo, 
	m.id2 AS SysPrin, 2 AS seq 
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate
AND n.result IN ('ipay', 'achcc', 'i99', 'pay', 'pp')
and convert(varchar(57), n.comment) <> ''

UNION ALL

SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 57, 57), '') AS Memo, 
	m.id2 AS SysPrin, 3 AS seq 
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate
AND n.result IN ('ipay', 'achcc', 'i99', 'pay', 'pp')
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 57, 57), '') <> ''


UNION ALL

SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 114, 57), '') AS Memo, 
	m.id2 AS SysPrin, 4 AS seq 
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate
AND n.result IN ('ipay', 'achcc', 'i99', 'pay', 'pp')
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 114, 57), '') <> ''

UNION ALL

SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 171, 57), '') AS Memo, 
	m.id2 AS SysPrin, 5 AS seq 
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate
AND n.result IN ('ipay', 'achcc', 'i99', 'pay', 'pp')
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 171, 57), '') <> ''

UNION ALL

SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 228, 57), '') AS Memo, 
	m.id2 AS SysPrin, 6 AS seq 
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate
AND n.result IN ('ipay', 'achcc', 'i99', 'pay', 'pp')
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 228, 57), '') <> ''

UNION ALL

SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 285, 57), '') AS Memo, 
	m.id2 AS SysPrin, 7 AS seq 
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate
AND n.result IN ('ipay', 'achcc', 'i99', 'pay', 'pp')
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 285, 57), '') <> ''

UNION ALL

SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 342, 57), '') AS Memo, 
	m.id2 AS SysPrin, 8 AS seq 
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate
AND n.result IN ('ipay', 'achcc', 'i99', 'pay', 'pp')
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 342, 57), '') <> ''

UNION ALL

SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 399, 57), '') AS Memo, 
	m.id2 AS SysPrin, 9 AS seq 
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate
AND n.result IN ('ipay', 'achcc', 'i99', 'pay', 'pp')
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 399, 57), '') <> ''

UNION ALL

SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 456, 57), '') AS Memo, 
	m.id2 AS SysPrin, 10 AS seq 
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate
AND n.result IN ('ipay', 'achcc', 'i99', 'pay', 'pp')
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 456, 57), '') <> ''

UNION ALL

SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 513, 57), '') AS Memo, 
	m.id2 AS SysPrin, 11 AS seq 
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate
AND n.result IN ('ipay', 'achcc', 'i99', 'pay', 'pp')
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 513, 57), '') <> ''

UNION ALL

SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 570, 57), '') AS Memo, 
	m.id2 AS SysPrin, 12 AS seq 
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate
AND n.result IN ('ipay', 'achcc', 'i99', 'pay', 'pp')
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 570, 57), '') <> ''

UNION ALL

SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 627, 57), '') AS Memo, 
	m.id2 AS SysPrin, 13 AS seq 
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate
AND n.result IN ('ipay', 'achcc', 'i99', 'pay', 'pp')
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 627, 57), '') <> ''

UNION ALL

SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 684, 57), '') AS Memo, 
	m.id2 AS SysPrin, 14 AS seq 
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate
AND n.result IN ('ipay', 'achcc', 'i99', 'pay', 'pp')
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 684, 57), '') <> ''

UNION ALL

SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 741, 57), '') AS Memo, 
	m.id2 AS SysPrin, 15 AS seq 
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate
AND n.result IN ('ipay', 'achcc', 'i99', 'pay', 'pp')
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 741, 57), '') <> ''

UNION ALL

SELECT DISTINCT m.account, '115', 'SIM' AS UserID, CASE WHEN n.ACTION LIKE 'I%' THEN 'INB ' ELSE 'OB ' END + CASE WHEN n.result IN ('tt') then 'Right party contacted'
ELSE SUBSTRING(ISNULL('Payment Taken: ' + (SELECT TOP 1 CONVERT(VARCHAR(10), amount) FROM promises p WITH (NOLOCK) WHERE AcctID = m.number ORDER BY DueDate desc) 
	+ ' Due: ' + (SELECT TOP 1 CONVERT(VARCHAR(10), DueDate, 101) FROM promises p WITH (NOLOCK) WHERE AcctID = m.number ORDER BY DueDate desc), 'Payment Taken, No info available'), 1, 57) END AS Memo, 
	m.id2 AS SysPrin, 16 AS seq
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate
AND n.result IN ('tt', 'ITT')

UNION ALL

SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 0, 57), '') AS Memo, 
	m.id2 AS SysPrin, 17 AS seq 
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate
AND n.result IN (SELECT code FROM result r WITH (NOLOCK) WHERE contacted = 1 AND code NOT IN ('ipay', 'achcc', 'i99', 'pay', 
'pp', 'ccdnc', 'crno', 'crpp', 'crpy', 'cy', 'icy', 'ld', 'ntm', 'parpy', 'ph', 'rd', 'resp', 'wt'))
and convert(varchar(57), n.comment) <> ''

UNION ALL

SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 57, 57), '') AS Memo, 
	m.id2 AS SysPrin, 18 AS seq 
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate
AND n.result IN (SELECT code FROM result r WITH (NOLOCK) WHERE contacted = 1 AND code NOT IN ('ipay', 'achcc', 'i99', 'pay', 
'pp', 'ccdnc', 'crno', 'crpp', 'crpy', 'cy', 'icy', 'ld', 'ntm', 'parpy', 'ph', 'rd', 'resp', 'wt'))
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 57, 57), '') <> ''


UNION ALL

SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 114, 57), '') AS Memo, 
	m.id2 AS SysPrin, 19 AS seq 
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate
AND n.result IN (SELECT code FROM result r WITH (NOLOCK) WHERE contacted = 1 AND code NOT IN ('ipay', 'achcc', 'i99', 'pay', 
'pp', 'ccdnc', 'crno', 'crpp', 'crpy', 'cy', 'icy', 'ld', 'ntm', 'parpy', 'ph', 'rd', 'resp', 'wt'))
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 114, 57), '') <> ''

UNION ALL

SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 171, 57), '') AS Memo, 
	m.id2 AS SysPrin, 20 AS seq 
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate
AND n.result IN (SELECT code FROM result r WITH (NOLOCK) WHERE contacted = 1 AND code NOT IN ('ipay', 'achcc', 'i99', 'pay', 
'pp', 'ccdnc', 'crno', 'crpp', 'crpy', 'cy', 'icy', 'ld', 'ntm', 'parpy', 'ph', 'rd', 'resp', 'wt'))
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 171, 57), '') <> ''

UNION ALL

SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 228, 57), '') AS Memo, 
	m.id2 AS SysPrin, 21 AS seq 
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate
AND n.result IN (SELECT code FROM result r WITH (NOLOCK) WHERE contacted = 1 AND code NOT IN ('ipay', 'achcc', 'i99', 'pay', 
'pp', 'ccdnc', 'crno', 'crpp', 'crpy', 'cy', 'icy', 'ld', 'ntm', 'parpy', 'ph', 'rd', 'resp', 'wt'))
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 228, 57), '') <> ''

UNION ALL

SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 285, 57), '') AS Memo, 
	m.id2 AS SysPrin, 22 AS seq 
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate
AND n.result IN (SELECT code FROM result r WITH (NOLOCK) WHERE contacted = 1 AND code NOT IN ('ipay', 'achcc', 'i99', 'pay', 
'pp', 'ccdnc', 'crno', 'crpp', 'crpy', 'cy', 'icy', 'ld', 'ntm', 'parpy', 'ph', 'rd', 'resp', 'wt'))
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 285, 57), '') <> ''

UNION ALL

SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 342, 57), '') AS Memo, 
	m.id2 AS SysPrin, 23 AS seq 
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate
AND n.result IN (SELECT code FROM result r WITH (NOLOCK) WHERE contacted = 1 AND code NOT IN ('ipay', 'achcc', 'i99', 'pay', 
'pp', 'ccdnc', 'crno', 'crpp', 'crpy', 'cy', 'icy', 'ld', 'ntm', 'parpy', 'ph', 'rd', 'resp', 'wt'))
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 342, 57), '') <> ''

UNION ALL

SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 399, 57), '') AS Memo, 
	m.id2 AS SysPrin, 24 AS seq 
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate
AND n.result IN (SELECT code FROM result r WITH (NOLOCK) WHERE contacted = 1 AND code NOT IN ('ipay', 'achcc', 'i99', 'pay', 
'pp', 'ccdnc', 'crno', 'crpp', 'crpy', 'cy', 'icy', 'ld', 'ntm', 'parpy', 'ph', 'rd', 'resp', 'wt'))
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 399, 57), '') <> ''

UNION ALL

SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 456, 57), '') AS Memo, 
	m.id2 AS SysPrin, 25 AS seq 
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate
AND n.result IN (SELECT code FROM result r WITH (NOLOCK) WHERE contacted = 1 AND code NOT IN ('ipay', 'achcc', 'i99', 'pay', 
'pp', 'ccdnc', 'crno', 'crpp', 'crpy', 'cy', 'icy', 'ld', 'ntm', 'parpy', 'ph', 'rd', 'resp', 'wt'))
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 456, 57), '') <> ''

UNION ALL

SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 513, 57), '') AS Memo, 
	m.id2 AS SysPrin, 26 AS seq 
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate
AND n.result IN (SELECT code FROM result r WITH (NOLOCK) WHERE contacted = 1 AND code NOT IN ('ipay', 'achcc', 'i99', 'pay', 
'pp', 'ccdnc', 'crno', 'crpp', 'crpy', 'cy', 'icy', 'ld', 'ntm', 'parpy', 'ph', 'rd', 'resp', 'wt'))
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 513, 57), '') <> ''

UNION ALL

SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 570, 57), '') AS Memo, 
	m.id2 AS SysPrin, 27 AS seq 
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate
AND n.result IN (SELECT code FROM result r WITH (NOLOCK) WHERE contacted = 1 AND code NOT IN ('ipay', 'achcc', 'i99', 'pay', 
'pp', 'ccdnc', 'crno', 'crpp', 'crpy', 'cy', 'icy', 'ld', 'ntm', 'parpy', 'ph', 'rd', 'resp', 'wt'))
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 570, 57), '') <> ''

UNION ALL

SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 627, 57), '') AS Memo, 
	m.id2 AS SysPrin, 28 AS seq 
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate
AND n.result IN (SELECT code FROM result r WITH (NOLOCK) WHERE contacted = 1 AND code NOT IN ('ipay', 'achcc', 'i99', 'pay', 
'pp', 'ccdnc', 'crno', 'crpp', 'crpy', 'cy', 'icy', 'ld', 'ntm', 'parpy', 'ph', 'rd', 'resp', 'wt'))
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 627, 57), '') <> ''

UNION ALL

SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 684, 57), '') AS Memo, 
	m.id2 AS SysPrin, 29 AS seq 
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate
AND n.result IN (SELECT code FROM result r WITH (NOLOCK) WHERE contacted = 1 AND code NOT IN ('ipay', 'achcc', 'i99', 'pay', 
'pp', 'ccdnc', 'crno', 'crpp', 'crpy', 'cy', 'icy', 'ld', 'ntm', 'parpy', 'ph', 'rd', 'resp', 'wt'))
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 684, 57), '') <> ''

UNION ALL

SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 741, 57), '') AS Memo, 
	m.id2 AS SysPrin, 30 AS seq 
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate
AND n.result IN (SELECT code FROM result r WITH (NOLOCK) WHERE contacted = 1 AND code NOT IN ('ipay', 'achcc', 'i99', 'pay', 
'pp', 'ccdnc', 'crno', 'crpp', 'crpy', 'cy', 'icy', 'ld', 'ntm', 'parpy', 'ph', 'rd', 'resp', 'wt'))
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 741, 57), '') <> ''


UNION ALL

--First 57 characters
SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 0, 57), '') AS Memo,
m.id2 AS SysPrin, 31 AS seq
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))
AND n.action IN ('CO') AND n.result IN ('CO')
AND n.user0 <> 'SYSTEM'
and convert(varchar(57), n.comment) <> ''

UNION ALL

--Second 57 characters
SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 57, 57), '') AS Memo,
m.id2 AS SysPrin, 32 AS seq
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))
AND n.action IN ('CO') AND n.result IN ('CO')
AND n.user0 <> 'SYSTEM'
and convert(varchar(57), n.comment) <> ''
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 57, 57), '') <> ''

UNION ALL

--Third 57 characters
SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 114, 57), '') AS Memo,
m.id2 AS SysPrin, 33 AS seq
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))
AND n.action IN ('CO') AND n.result IN ('CO')
AND n.user0 <> 'SYSTEM'
and convert(varchar(57), n.comment) <> ''
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 114, 57), '') <> ''

UNION ALL

--Forth 57 characters
SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 171, 57), '') AS Memo,
m.id2 AS SysPrin, 34 AS seq
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))
AND n.action IN ('CO') AND n.result IN ('CO')
AND n.user0 <> 'SYSTEM'
and convert(varchar(57), n.comment) <> ''
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 171, 57), '') <> ''

UNION ALL

--Fifth 57 characters
SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 228, 57), '') AS Memo,
m.id2 AS SysPrin, 35 AS seq
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))
AND n.action IN ('CO') AND n.result IN ('CO')
AND n.user0 <> 'SYSTEM'
and convert(varchar(57), n.comment) <> ''
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 228, 57), '') <> ''

UNION ALL

--Sixth 57 characters
SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 285, 57), '') AS Memo,
m.id2 AS SysPrin, 36 AS seq
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))
AND n.action IN ('CO') AND n.result IN ('CO')
AND n.user0 <> 'SYSTEM'
and convert(varchar(57), n.comment) <> ''
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 285, 57), '') <> ''

UNION ALL

--Seventh 57 characters
SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 342, 57), '') AS Memo,
m.id2 AS SysPrin, 37 AS seq
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))
AND n.action IN ('CO') AND n.result IN ('CO')
AND n.user0 <> 'SYSTEM'
and convert(varchar(57), n.comment) <> ''
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 342, 57), '') <> ''

UNION ALL

--Eighth 57 characters
SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 399, 57), '') AS Memo,
m.id2 AS SysPrin, 38 AS seq
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))
AND n.action IN ('CO') AND n.result IN ('CO')
AND n.user0 <> 'SYSTEM'
and convert(varchar(57), n.comment) <> ''
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 399, 57), '') <> ''

UNION ALL

--Ninth 57 characters
SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 456, 57), '') AS Memo,
m.id2 AS SysPrin, 39 AS seq
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))
AND n.action IN ('CO') AND n.result IN ('CO')
AND n.user0 <> 'SYSTEM'
and convert(varchar(57), n.comment) <> ''
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 456, 57), '') <> ''

UNION ALL

--Tenth 57 characters
SELECT DISTINCT m.account, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 513, 57), '') AS Memo,
m.id2 AS SysPrin, 40 AS seq
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))
AND n.action IN ('CO') AND n.result IN ('CO')
AND n.user0 <> 'SYSTEM'
and convert(varchar(57), n.comment) <> ''
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 513, 57), '') <> ''

UNION ALL

--Banko 115
--Part 1
SELECT DISTINCT m.account, '115', 'SIM' AS UserID, 'On ' + CONVERT(VARCHAR(10), n.created, 101) + ' ' + n.action + ' Info Rcvd from ' + user0 + ' Vendor Reported ' AS Memo, 
m.id2 AS SysPrin, 41 AS seq
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
INNER JOIN Bankruptcy b WITH (NOLOCK) ON d.DebtorID = b.DebtorID
WHERE m.customer IN ('0001118', '0001121', '0001122') AND m.status IN ('BKY', 'B07', 'B11', 'B13', 'B12') AND created BETWEEN @startDate AND @endDate
AND user0 IN ('CBC') AND n.action IN ('BNKO') AND n.result IN ('IF')

UNION ALL

--Banko 115
--Part 2
SELECT DISTINCT m.account, '115', 'SIM' AS UserID, 'Case: ' + b.CaseNumber + ' | Filed on: ' + CONVERT(VARCHAR(10), b.datefiled, 101) + ' ' AS Memo, 
m.id2 AS SysPrin, 42 AS seq
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
INNER JOIN Bankruptcy b WITH (NOLOCK) ON d.DebtorID = b.DebtorID
WHERE m.customer IN ('0001118', '0001121', '0001122') AND m.status IN ('BKY', 'B07', 'B11', 'B13', 'B12') AND created BETWEEN @startDate AND @endDate
AND user0 IN ('CBC') AND n.action IN ('BNKO') AND n.result IN ('IF')

UNION ALL

--Banko 115
--Part 3
SELECT DISTINCT m.account, '115', 'SIM' AS UserID, 'Status ' + b.STATUS + ' | Status Date; ' + COALESCE(CONVERT(VARCHAR(10), b.DischargeDate, 101), CONVERT(VARCHAR(10), b.DismissalDate, 101), CONVERT(VARCHAR(10), b.DateFiled, 101)) AS Memo, 
m.id2 AS SysPrin, 43 AS seq
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
INNER JOIN Bankruptcy b WITH (NOLOCK) ON d.DebtorID = b.DebtorID
WHERE m.customer IN ('0001118', '0001121', '0001122') AND m.status IN ('BKY', 'B07', 'B11', 'B13', 'B12') AND created BETWEEN @startDate AND @endDate
AND user0 IN ('CBC') AND n.action IN ('BNKO') AND n.result IN ('IF')

UNION ALL

--DEC 115
SELECT DISTINCT m.account, '115', 'SIM' AS UserID, CASE WHEN user0 IN ('CBC') AND n.ACTION IN ('DECD') THEN 'On ' + CONVERT(VARCHAR(10), n.created, 101) + ' DOD: ' + CONVERT(VARCHAR(10), d2.dod,101) + ' RCVD from ' + user0 + ' Vendor' 
WHEN user0 = 'SIMM' AND n.ACTION = 'DECD' THEN 'On ' + CONVERT(VARCHAR(10), n.created, 101) + ' DOD: ' + CONVERT(VARCHAR(10), d2.dod,101) + ' Found in SIMM Internal DB'  END AS Memo, 
m.id2 AS SysPrin, 44 AS seq
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
INNER JOIN Deceased d2 WITH (NOLOCK) ON d.DebtorID = d2.DebtorID
WHERE m.customer IN ('0001118', '0001121', '0001122') AND status IN ('DEC') AND created BETWEEN @startDate AND @endDate
AND user0 IN ('CBC', 'SIMM') AND n.action IN ('DECD') AND n.result IN ('IF')

UNION ALL

SELECT DISTINCT m.account, '115', 'SIM' AS UserID,'Skip Trace Performed On ' + CONVERT(VARCHAR(10), n.created, 101) AS Memo, 
	m.id2 AS SysPrin, 45 AS seq 
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND created BETWEEN @startDate AND @endDate
AND n.result IN ('sk') AND n.action IN ('sk')

----Record 698 Address Change Street 1
INSERT INTO #tmprecord698
        (AccountNumber , TransID , SubTran , CustNumber , AddressTypeCode , AddrData, Filler , SysPrin)
SELECT m.account, '698' AS TransID, '03' AS SubTran, '01' AS CustNumber,
	'1' AS AddressTypeCode,  left(NewStreet1, 50) AS AddrData, 'SIM ZZ' AS Filler, m.id2 AS SysPrin
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0 INNER JOIN AddressHistory ah WITH (NOLOCK) ON d.DebtorID = ah.DebtorID
WHERE customer IN ('0001118', '0001121', '0001122') AND datechanged BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))

UNION ALL

----Record 698 Address Change City
SELECT m.account, '698' AS TransID, '08' AS SubTran, '01' AS CustNumber,
	'1' AS AddressTypeCode,  left(NewCity, 25) AS AddrData, '' AS Filler, m.id2 AS SysPrin
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0 INNER JOIN AddressHistory ah WITH (NOLOCK) ON d.DebtorID = ah.DebtorID
WHERE customer IN ('0001118', '0001121', '0001122') AND datechanged BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))

UNION ALL

----Record 698 Address Change State
SELECT m.account, '698' AS TransID, '09' AS SubTran, '01' AS CustNumber,
	'1' AS AddressTypeCode,  left(NewState, 2) AS AddrData, '' AS Filler, m.id2 AS SysPrin
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0 INNER JOIN AddressHistory ah WITH (NOLOCK) ON d.DebtorID = ah.DebtorID
WHERE customer IN ('0001118', '0001121', '0001122') AND datechanged BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))

UNION ALL

----Record 698 Address Change Zipcode
SELECT m.account, '698' AS TransID, '10' AS SubTran, '01' AS CustNumber,
	'1' AS AddressTypeCode,  left(NewZipcode, 10) AS AddrData, '' AS Filler, m.id2 AS SysPrin
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0 INNER JOIN AddressHistory ah WITH (NOLOCK) ON d.DebtorID = ah.DebtorID
WHERE customer IN ('0001118', '0001121', '0001122') AND datechanged BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))

UNION ALL

----Record 698 Address Change Country
SELECT m.account, '698' AS TransID, '11' AS SubTran, '01' AS CustNumber,
	'1' AS AddressTypeCode,  'USA' AS AddrData, '' AS Filler, m.id2 AS SysPrin
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0 INNER JOIN AddressHistory ah WITH (NOLOCK) ON d.DebtorID = ah.DebtorID
WHERE customer IN ('0001118', '0001121', '0001122') AND datechanged BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))
ORDER BY CustNumber

--Record 699 Update Cell Phone
INSERT INTO #tmprecord699
        (AccountNumber ,TransID , SubCode, CellPhoneNumber ,UserID , SysPrin)
SELECT hp.account, '699', '2001', hp.PhoneNumber AS newnumber, 'SIM ZZ', hp.SysPrin
FROM (SELECT m.account, DateAdded, PhoneNumber, m.id2 AS sysprin
FROM master m WITH (NOLOCK) INNER JOIN Phones_Master pm WITH (NOLOCK) ON m.number = pm.Number
WHERE m.customer IN ('0001118', '0001121', '0001122') AND pm.phonenumber NOT IN (m.homephone, m.workphone) AND PhoneTypeID = 3 AND Phonestatusid = 2 AND DateAdded BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))
AND pm.LoginName <> 'SYNC'

UNION all

SELECT m.account, DateChanged AS DateAdded, CASE WHEN NewNumber = '' THEN '0000000000' ELSE NewNumber END AS newnumber, m.id2 AS sysprin
FROM master m WITH (NOLOCK) INNER JOIN PhoneHistory ph WITH (NOLOCK) ON m.number = ph.AccountID
WHERE m.customer IN ('0001118', '0001121', '0001122') AND ((oldnumber not IN ('0000000000', '9999999999') AND ph.newnumber = '') OR (ph.NewNumber <> '')) AND phonetype = 3 AND DateChanged BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))
) hp
ORDER BY hp.DateAdded desc	

----Record 783 Add High Risk Coll ID
--INSERT INTO #tmprecord783 
--		 (AccountNumber, TransID, SubTran, HighRiskCollID, UserID, SysPrin )
--SELECT m.account, '783' AS TransID, '01' AS SubTran, '852' AS HighRiskCollID, 'SIM ZZ' AS UserID, m.id2 AS SysPrin
--FROM master m WITH (NOLOCK)
--WHERE customer IN ('0001118', '0001121', '0001122') AND status IN ('DEC') AND closed BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))

--UNION ALL

----Record 783 Add High Risk Coll ID
--SELECT m.account, '783' AS TransID, '01' AS SubTran, '800' AS HighRiskCollID, 'SIM ZZ' AS UserID, m.id2 AS SysPrin
--FROM master m WITH (NOLOCK)
--WHERE customer IN ('0001118', '0001121', '0001122') AND status LIKE 'b%' AND closed BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))

--UNION ALL

----Record 783 Add High Risk Coll ID
--SELECT m.account, '783' AS TransID, '01' AS SubTran, '851' AS HighRiskCollID, 'SIM ZZ' AS UserID, m.id2 AS SysPrin
--FROM master m WITH (NOLOCK)
--WHERE customer IN ('0001118', '0001121', '0001122') AND status IN ('CAD', 'CND') AND closed BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))


--Record 793 Email Update
INSERT INTO #tmprecord793
        (AccountNumber ,TransID , SubCode, UserID , EmailAddress ,SysPrin)
SELECT m.account, '793', '0101', 'SIM ZZ' AS UserID, NewEmail, m.id2 AS SysPrin
FROM master m WITH (NOLOCK) INNER JOIN EmailHistory eh WITH (NOLOCK) ON m.number = eh.AccountID
WHERE m.customer IN ('0001118', '0001121', '0001122') AND DateChanged BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))





SELECT DISTINCT sp.SysPrin
FROM (
SELECT DISTINCT SysPrin FROM #tmprecord216 t3
UNION SELECT DISTINCT SysPrin FROM #tmprecord037 t4
UNION SELECT DISTINCT SysPrin FROM #tmprecord056 t5
UNION SELECT DISTINCT SysPrin FROM #tmprecord115 t6
UNION SELECT DISTINCT SysPrin FROM #tmprecord698 t7
UNION SELECT DISTINCT SysPrin FROM #tmprecord699 t8
--UNION SELECT DISTINCT SysPrin FROM #tmprecord783 t9
UNION SELECT DISTINCT SysPrin FROM #tmprecord793 t10
) sp

SELECT *
FROM #tmprecord216 t
ORDER BY accountnumber	

SELECT *
FROM #tmprecord037 t
ORDER BY accountnumber

SELECT *
FROM #tmprecord056 t
ORDER BY accountnumber

SELECT *
FROM #tmprecord115 t
ORDER BY accountnumber, seq	DESC

SELECT *
FROM #tmprecord698 t
ORDER BY accountnumber

SELECT *
FROM #tmprecord699 t
ORDER BY accountnumber

--SELECT *
--FROM #tmprecord783 t
--ORDER BY accountnumber

SELECT *
FROM #tmprecord793 t
ORDER BY accountnumber

DROP TABLE #tmpSysPrin
DROP TABLE #tmprecord216
DROP TABLE #tmprecord037
DROP TABLE #tmprecord056
DROP TABLE #tmprecord115
DROP TABLE #tmprecord698
DROP TABLE #tmprecord699
--DROP TABLE #tmprecord783
DROP TABLE #tmprecord793	

END
GO
