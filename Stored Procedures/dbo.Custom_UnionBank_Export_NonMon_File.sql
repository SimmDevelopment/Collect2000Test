SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- Changes:
-- 8/1/2019 - BGM, removed debtor sequence number on address changes.
-- 10/31/2019 - BGM Changed sys prin to new field id2
-- 11/01/2019 - BGM Added start/end datetime fixed for 4 p.m. previous day to 4 p.m. current day(enddate
-- 11/12/2019 - BGM Added 115 record to notify what part of an address change was made.
-- Live customer = 0002332  Test customer = 0001103
-- =============================================

--exec custom_unionbank_export_nonmon_file '20191115', '20191115'

CREATE PROCEDURE [dbo].[Custom_UnionBank_Export_NonMon_File] 
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
DECLARE @customer VARCHAR(10)
SET @customer = '0001103'	

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
    WHERE   name LIKE '#tmprecord029%' ) 
		BEGIN
			DROP TABLE #tmprecord029
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
		
IF EXISTS ( SELECT  *
    FROM    tempdb.sys.tables
    WHERE   name LIKE '#tmprecord783%' ) 
		BEGIN
			DROP TABLE #tmprecord783
		END      
		
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
CREATE TABLE #tmprecord029
(
  [ID] [int] IDENTITY(1, 1)
             NOT NULL ,
  [AccountNumber] VARCHAR(16) NULL ,
  [TransID] VARCHAR(3) NULL,
  [ChargeOffCollCode] VARCHAR(3) NULL ,
  [KeyWord] VARCHAR(7) NULL,
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
  [seq] INT null
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
SELECT DISTINCT CASE WHEN SUBSTRING(m.id1, 6, 1) = '5' THEN '3599' ELSE '3616' END + '  ' + CASE WHEN SUBSTRING(m.id1, 7, 1) = '1' THEN '1000' ELSE '2000' END
FROM master m WITH (NOLOCK)
WHERE customer = @customer

--Record 029 Add Permanent Collection Code *****(Need to program this still)*******
INSERT INTO #tmprecord029 
		 (AccountNumber, TransID, ChargeOffCollCode, KeyWord, UserID, SysPrin )
SELECT m.id1, '029' AS TransID, '852' AS CollCode, '       ' AS Keyword, 'SIM ZZ' AS UserID, CASE WHEN SUBSTRING(m.id1, 6, 1) = '5' THEN '3599' ELSE '3616' END + '  ' + CASE WHEN SUBSTRING(m.id1, 7, 1) = '1' THEN '1000' ELSE '2000' END AS SysPrin
FROM master m WITH (NOLOCK)
WHERE customer = @customer AND status IN ('DEC') AND closed BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))

UNION ALL

--Record 029 Add Permanent Collection Code Bankruptcy
SELECT m.id1, '029' AS TransID, '800' AS CollCode, '       ' AS Keyword, 'SIM ZZ' AS UserID, CASE WHEN SUBSTRING(m.id1, 6, 1) = '5' THEN '3599' ELSE '3616' END + '  ' + CASE WHEN SUBSTRING(m.id1, 7, 1) = '1' THEN '1000' ELSE '2000' END AS SysPrin
FROM master m WITH (NOLOCK)
WHERE customer = @customer AND status LIKE 'b%' AND closed BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))

UNION ALL

--Record 029 Add Permanent Collection Code Attorney Rep
SELECT m.id1, '029' AS TransID, '800' AS CollCode, '       ' AS Keyword, 'SIM ZZ' AS UserID, CASE WHEN SUBSTRING(m.id1, 6, 1) = '5' THEN '3599' ELSE '3616' END + '  ' + CASE WHEN SUBSTRING(m.id1, 7, 1) = '1' THEN '1000' ELSE '2000' END AS SysPrin
FROM master m WITH (NOLOCK)
WHERE customer = @customer AND status = 'ATY' AND closed BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))

UNION ALL

--Record 029 Add Permanent Collection Code Cease and Desist
SELECT m.id1, '029' AS TransID, '851' AS CollCode, '       ' AS Keyword, 'SIM ZZ' AS UserID, CASE WHEN SUBSTRING(m.id1, 6, 1) = '5' THEN '3599' ELSE '3616' END + '  ' + CASE WHEN SUBSTRING(m.id1, 7, 1) = '1' THEN '1000' ELSE '2000' END AS SysPrin
FROM master m WITH (NOLOCK)
WHERE customer = @customer AND status IN ('CAD', 'CND') AND closed BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))


--Record 037 Update Home Phone
INSERT INTO #tmprecord037
        (AccountNumber ,TransID ,HomePhoneNumber ,UserID , SysPrin)
SELECT hp.id1, '037', dbo.StripNonDigits(hp.PhoneNumber) AS newnumber, 'SIM ZZ', hp.sysprin AS SysPrin
FROM (SELECT m.id1, DateAdded, PhoneNumber, CASE WHEN SUBSTRING(m.id1, 6, 1) = '5' THEN '3599' ELSE '3616' END + '  ' + CASE WHEN SUBSTRING(m.id1, 7, 1) = '1' THEN '1000' ELSE '2000' END AS sysprin
FROM master m WITH (NOLOCK) INNER JOIN Phones_Master pm WITH (NOLOCK) ON m.number = pm.Number
WHERE m.customer = @customer AND PhoneTypeID = 1 AND Phonestatusid = 2 AND DateAdded BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))
AND pm.LoginName <> 'SYNC'

UNION all

SELECT m.id1, DateChanged AS DateAdded, CASE WHEN NewNumber = '' THEN '0000000000' ELSE dbo.StripNonDigits(NewNumber) END AS newnumber, CASE WHEN SUBSTRING(m.id1, 6, 1) = '5' THEN '3599' ELSE '3616' END + '  ' +  CASE WHEN SUBSTRING(m.id1, 7, 1) = '1' THEN '1000' ELSE '2000' END AS sysprin
FROM master m WITH (NOLOCK) INNER JOIN PhoneHistory ph WITH (NOLOCK) ON m.number = ph.AccountID
WHERE m.customer = @customer AND ((oldnumber not IN ('0000000000', '9999999999') AND ph.newnumber = '') OR (ph.NewNumber <> '')) AND phonetype = 1 AND DateChanged BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))
) hp
ORDER BY hp.DateAdded desc

--Record 056 Update Work Phone
INSERT INTO #tmprecord056
        (AccountNumber ,TransID ,WorkPhoneNumber ,UserID , SysPrin)
SELECT hp.id1, '056', dbo.StripNonDigits(hp.PhoneNumber) AS newnumber, 'SIM ZZ', hp.SysPrin
FROM (SELECT m.id1, DateAdded, PhoneNumber, CASE WHEN SUBSTRING(m.id1, 6, 1) = '5' THEN '3599' ELSE '3616' END + '  ' + CASE WHEN SUBSTRING(m.id1, 7, 1) = '1' THEN '1000' ELSE '2000' END AS sysprin
FROM master m WITH (NOLOCK) INNER JOIN Phones_Master pm WITH (NOLOCK) ON m.number = pm.Number
WHERE m.customer = @customer AND PhoneTypeID = 2 AND Phonestatusid = 2 AND DateAdded BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))
AND pm.LoginName <> 'SYNC'

UNION all

SELECT m.id1, DateChanged AS DateAdded, CASE WHEN NewNumber = '' THEN '0000000000' ELSE NewNumber END AS newnumber, CASE WHEN SUBSTRING(m.id1, 6, 1) = '5' THEN '3599' ELSE '3616' END + '  ' + CASE WHEN SUBSTRING(m.id1, 7, 1) = '1' THEN '1000' ELSE '2000' END AS sysprin
FROM master m WITH (NOLOCK) INNER JOIN PhoneHistory ph WITH (NOLOCK) ON m.number = ph.AccountID
WHERE m.customer = @customer AND ((oldnumber not IN ('0000000000', '9999999999') AND ph.newnumber = '') OR (ph.NewNumber <> '')) AND phonetype = 2 AND DateChanged BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))
) hp
ORDER BY hp.DateAdded desc	

--Record 115 Memo or Note RPC and payment/Promise Taken
INSERT INTO #tmprecord115
        (AccountNumber ,TransID ,UserID , Memo ,SysPrin, seq)
SELECT DISTINCT m.id1, '115', 'SIM' AS UserID, CASE WHEN n.ACTION LIKE 'I%' THEN 'INB ' ELSE 'OB ' END + CASE WHEN n.result IN ('tt') then 'Right party contacted'
ELSE SUBSTRING(ISNULL('Payment Taken: ' + (SELECT TOP 1 CONVERT(VARCHAR(10), amount) FROM promises p WITH (NOLOCK) WHERE AcctID = m.number ORDER BY DueDate desc) 
	+ ' Due: ' + (SELECT TOP 1 CONVERT(VARCHAR(10), DueDate, 101) FROM promises p WITH (NOLOCK) WHERE AcctID = m.number ORDER BY DueDate desc), 'Payment Taken, No info available'), 1, 57) END AS Memo, CASE WHEN SUBSTRING(m.id1, 6, 1) = '5' THEN '3599' ELSE '3616' END + '  ' + CASE WHEN SUBSTRING(m.id1, 7, 1) = '1' THEN '1000' ELSE '2000' END AS SysPrin, 0 AS seq
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer = @customer AND created BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))
AND n.result IN ('ipay', 'achcc', 'i99', 'pay', 'pp', 'tt')

UNION ALL

--Record 115 Memmo or Note BKY/DEC/RSK/MIL
SELECT DISTINCT m.id1, '115', 'SIM' AS UserID, CASE WHEN n.action IN ('BNKO') THEN n.action + ' Info Rcvd from ' + user0 + ' Vendor'
WHEN user0 IN ('CBC') AND n.ACTION IN ('DECD') THEN 'DOD Info Rcvd from ' + user0 + ' Vendor' WHEN user0 = 'SIMM' AND n.ACTION = 'DECD' THEN 'DOD Info Rcvd from SIMM Internal DB'  END AS Memo, 
CASE WHEN SUBSTRING(m.id1, 6, 1) = '5' THEN '3599' ELSE '3616' END + '  ' + CASE WHEN SUBSTRING(m.id1, 7, 1) = '1' THEN '1000' ELSE '2000' END AS SysPrin, 0 AS seq
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer = @customer AND status IN ('DEC', 'BKY', 'B07', 'B11', 'B13', 'B12') AND created BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))
AND user0 IN ('CBC', 'SIMM') AND n.action IN ('BNKO', 'DECD') AND n.result IN ('IF')

UNION ALL

SELECT DISTINCT m.id1, '115', 'SIM' AS UserID, CASE WHEN ah.oldstreet1 <> ah.newstreet1 THEN 'STR1UPD ' ELSE '' END + CASE WHEN ah.OldStreet2 <> ah.NewStreet2 THEN 'STR2UPD ' ELSE '' END
	 + CASE WHEN ah.OldCity <> ah.NewCity THEN 'CITYUPD ' ELSE '' END + CASE WHEN ah.OldState <> ah.NewState THEN 'STATEUPD ' ELSE '' END 
	 + CASE WHEN ah.OldZipcode <> ah.NewZipcode THEN 'ZIPUPD' ELSE '' END AS Memo,
CASE WHEN SUBSTRING(m.id1, 6, 1) = '5' THEN '3599' ELSE '3616' END + '  ' + CASE WHEN SUBSTRING(m.id1, 7, 1) = '1' THEN '1000' ELSE '2000' END AS SysPrin, 0 AS seq
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0 INNER JOIN AddressHistory ah WITH (NOLOCK) ON d.DebtorID = ah.DebtorID
WHERE customer = @customer AND datechanged BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))

UNION ALL
--First 57 characters
SELECT DISTINCT m.id1, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 0, 57), '') AS Memo,
CASE WHEN SUBSTRING(m.id1, 6, 1) = '5' THEN '3599' ELSE '3616' END + '  ' + CASE WHEN SUBSTRING(m.id1, 7, 1) = '1' THEN '1000' ELSE '2000' END AS SysPrin, 1 AS seq
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE customer = @customer AND created BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))
AND n.action IN ('CO') AND n.result IN ('CO')
and convert(varchar(57), n.comment) <> ''

UNION ALL
--Second 57 characters
SELECT DISTINCT m.id1, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 57, 57), '') AS Memo,
CASE WHEN SUBSTRING(m.id1, 6, 1) = '5' THEN '3599' ELSE '3616' END + '  ' + CASE WHEN SUBSTRING(m.id1, 7, 1) = '1' THEN '1000' ELSE '2000' END AS SysPrin, 2 AS seq
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE customer = @customer AND created BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))
AND n.action IN ('CO') AND n.result IN ('CO')
and convert(varchar(57), n.comment) <> ''
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 40, 40), '') <> ''

UNION ALL
--Third 57 characters
SELECT DISTINCT m.id1, '115', 'SIM' AS UserID, isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 114, 57), '') AS Memo,
CASE WHEN SUBSTRING(m.id1, 6, 1) = '5' THEN '3599' ELSE '3616' END + '  ' + CASE WHEN SUBSTRING(m.id1, 7, 1) = '1' THEN '1000' ELSE '2000' END AS SysPrin, 3 AS seq
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE customer = @customer AND created BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))
AND n.action IN ('CO') AND n.result IN ('CO')
and convert(varchar(57), n.comment) <> ''
and isnull(substring(replace(replace(replace(convert(varchar(1000),n.comment),char(13) + char(10),' '), char(13), ' '), char(10), ' '), 114, 40), '') <> ''

----Record 698 Address Change Street 1
INSERT INTO #tmprecord698
        (AccountNumber , TransID , SubTran , CustNumber , AddressTypeCode , AddrData, Filler , SysPrin)
SELECT m.id1, '698' AS TransID, '03' AS SubTran, '01' AS CustNumber,
	'1' AS AddressTypeCode,  left(NewStreet1, 50) AS AddrData, 'XX    ' AS Filler, CASE WHEN SUBSTRING(m.id1, 6, 1) = '5' THEN '3599' ELSE '3616' END + '  ' + CASE WHEN SUBSTRING(m.id1, 7, 1) = '1' THEN '1000' ELSE '2000' END AS SysPrin
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0 INNER JOIN AddressHistory ah WITH (NOLOCK) ON d.DebtorID = ah.DebtorID
WHERE customer = @customer AND datechanged BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))

UNION ALL

----Record 698 Address Change City
SELECT m.id1, '698' AS TransID, '08' AS SubTran, '01' AS CustNumber,
	'1' AS AddressTypeCode,  left(NewCity, 25) AS AddrData, '' AS Filler, CASE WHEN SUBSTRING(m.id1, 6, 1) = '5' THEN '3599' ELSE '3616' END + '  ' + CASE WHEN SUBSTRING(m.id1, 7, 1) = '1' THEN '1000' ELSE '2000' END AS SysPrin
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0 INNER JOIN AddressHistory ah WITH (NOLOCK) ON d.DebtorID = ah.DebtorID
WHERE customer = @customer AND datechanged BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))

UNION ALL

----Record 698 Address Change State
SELECT m.id1, '698' AS TransID, '09' AS SubTran, '01' AS CustNumber,
	'1' AS AddressTypeCode,  left(NewState, 2) AS AddrData, '' AS Filler, CASE WHEN SUBSTRING(m.id1, 6, 1) = '5' THEN '3599' ELSE '3616' END + '  ' + CASE WHEN SUBSTRING(m.id1, 7, 1) = '1' THEN '1000' ELSE '2000' END AS SysPrin
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0 INNER JOIN AddressHistory ah WITH (NOLOCK) ON d.DebtorID = ah.DebtorID
WHERE customer = @customer AND datechanged BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))

UNION ALL

----Record 698 Address Change Zipcode
SELECT m.id1, '698' AS TransID, '10' AS SubTran, '01' AS CustNumber,
	'1' AS AddressTypeCode,  left(NewZipcode, 10) AS AddrData, '' AS Filler, CASE WHEN SUBSTRING(m.id1, 6, 1) = '5' THEN '3599' ELSE '3616' END + '  ' + CASE WHEN SUBSTRING(m.id1, 7, 1) = '1' THEN '1000' ELSE '2000' END AS SysPrin
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0 INNER JOIN AddressHistory ah WITH (NOLOCK) ON d.DebtorID = ah.DebtorID
WHERE customer = @customer AND datechanged BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))

UNION ALL

----Record 698 Address Change Country
SELECT m.id1, '698' AS TransID, '11' AS SubTran, '01' AS CustNumber,
	'1' AS AddressTypeCode,  'USA' AS AddrData, '' AS Filler, CASE WHEN SUBSTRING(m.id1, 6, 1) = '5' THEN '3599' ELSE '3616' END + '  ' + CASE WHEN SUBSTRING(m.id1, 7, 1) = '1' THEN '1000' ELSE '2000' END AS SysPrin
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0 INNER JOIN AddressHistory ah WITH (NOLOCK) ON d.DebtorID = ah.DebtorID
WHERE customer = @customer AND datechanged BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))
ORDER BY CustNumber

--Record 699 Update Cell Phone
INSERT INTO #tmprecord699
        (AccountNumber ,TransID , SubCode, CellPhoneNumber ,UserID , SysPrin)
SELECT hp.id1, '699', '2001', hp.PhoneNumber AS newnumber, 'SIM ZZ', hp.SysPrin
FROM (SELECT m.id1, DateAdded, PhoneNumber, CASE WHEN SUBSTRING(m.id1, 6, 1) = '5' THEN '3599' ELSE '3616' END + '  ' + CASE WHEN SUBSTRING(m.id1, 7, 1) = '1' THEN '1000' ELSE '2000' END AS sysprin
FROM master m WITH (NOLOCK) INNER JOIN Phones_Master pm WITH (NOLOCK) ON m.number = pm.Number
WHERE m.customer = @customer AND pm.phonenumber NOT IN (m.homephone, m.workphone) AND PhoneTypeID = 3 AND Phonestatusid = 2 AND DateAdded BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))
AND pm.LoginName <> 'SYNC'

UNION all

SELECT m.id1, DateChanged AS DateAdded, CASE WHEN NewNumber = '' THEN '0000000000' ELSE NewNumber END AS newnumber, CASE WHEN SUBSTRING(m.id1, 6, 1) = '5' THEN '3599' ELSE '3616' END + '  ' + CASE WHEN SUBSTRING(m.id1, 7, 1) = '1' THEN '1000' ELSE '2000' END AS sysprin
FROM master m WITH (NOLOCK) INNER JOIN PhoneHistory ph WITH (NOLOCK) ON m.number = ph.AccountID
WHERE m.customer = @customer AND ((oldnumber not IN ('0000000000', '9999999999') AND ph.newnumber = '') OR (ph.NewNumber <> '')) AND phonetype = 3 AND DateChanged BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))
) hp
ORDER BY hp.DateAdded desc	

--Record 783 Add High Risk Coll ID
INSERT INTO #tmprecord783 
		 (AccountNumber, TransID, SubTran, HighRiskCollID, UserID, SysPrin )
SELECT m.id1, '783' AS TransID, '01' AS SubTran, '852' AS HighRiskCollID, 'SIM ZZ' AS UserID, CASE WHEN SUBSTRING(m.id1, 6, 1) = '5' THEN '3599' ELSE '3616' END + '  ' + CASE WHEN SUBSTRING(m.id1, 7, 1) = '1' THEN '1000' ELSE '2000' END AS SysPrin
FROM master m WITH (NOLOCK)
WHERE customer = @customer AND status IN ('DEC') AND closed BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))

UNION ALL

--Record 783 Add High Risk Coll ID
SELECT m.id1, '783' AS TransID, '01' AS SubTran, '800' AS HighRiskCollID, 'SIM ZZ' AS UserID, CASE WHEN SUBSTRING(m.id1, 6, 1) = '5' THEN '3599' ELSE '3616' END + '  ' + CASE WHEN SUBSTRING(m.id1, 7, 1) = '1' THEN '1000' ELSE '2000' END AS SysPrin
FROM master m WITH (NOLOCK)
WHERE customer = @customer AND status LIKE 'b%' AND closed BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))

UNION ALL

--Record 783 Add High Risk Coll ID
SELECT m.id1, '783' AS TransID, '01' AS SubTran, '851' AS HighRiskCollID, 'SIM ZZ' AS UserID, CASE WHEN SUBSTRING(m.id1, 6, 1) = '5' THEN '3599' ELSE '3616' END + '  ' + CASE WHEN SUBSTRING(m.id1, 7, 1) = '1' THEN '1000' ELSE '2000' END AS SysPrin
FROM master m WITH (NOLOCK)
WHERE customer = @customer AND status IN ('CAD', 'CND') AND closed BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))


--Record 793 Email Update
INSERT INTO #tmprecord793
        (AccountNumber ,TransID , SubCode, UserID , EmailAddress ,SysPrin)
SELECT m.id1, '793', '0101', 'SIM ZZ' AS UserID, NewEmail, CASE WHEN SUBSTRING(m.id1, 6, 1) = '5' THEN '3599' ELSE '3616' END + '  ' + CASE WHEN SUBSTRING(m.id1, 7, 1) = '1' THEN '1000' ELSE '2000' END AS SysPrin
FROM master m WITH (NOLOCK) INNER JOIN EmailHistory eh WITH (NOLOCK) ON m.number = eh.AccountID
WHERE m.customer = @customer AND DateChanged BETWEEN @startDate AND @endDate-- dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, DATEADD(dd, 1, dbo.F_START_OF_DAY(@endDate)))





SELECT DISTINCT sp.SysPrin
FROM (
SELECT DISTINCT SysPrin FROM #tmprecord029 t3
UNION SELECT DISTINCT SysPrin FROM #tmprecord037 t4
UNION SELECT DISTINCT SysPrin FROM #tmprecord056 t5
UNION SELECT DISTINCT SysPrin FROM #tmprecord115 t6
UNION SELECT DISTINCT SysPrin FROM #tmprecord698 t7
UNION SELECT DISTINCT SysPrin FROM #tmprecord699 t8
UNION SELECT DISTINCT SysPrin FROM #tmprecord783 t9
UNION SELECT DISTINCT SysPrin FROM #tmprecord793 t10
) sp

SELECT *
FROM #tmprecord029 t
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

SELECT *
FROM #tmprecord783 t
ORDER BY accountnumber

SELECT *
FROM #tmprecord793 t
ORDER BY accountnumber

DROP TABLE #tmpSysPrin
DROP TABLE #tmprecord029
DROP TABLE #tmprecord037
DROP TABLE #tmprecord056
DROP TABLE #tmprecord115
DROP TABLE #tmprecord698
DROP TABLE #tmprecord699
DROP TABLE #tmprecord783
DROP TABLE #tmprecord793	

END
GO
