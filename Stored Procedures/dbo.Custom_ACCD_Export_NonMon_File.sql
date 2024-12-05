SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_ACCD_Export_NonMon_File] 
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
DECLARE @customer VARCHAR(10)
SET @customer = '0001043'	

--Drop temp tables if they already exist
IF EXISTS ( SELECT  *
	FROM    tempdb.sys.tables
	WHERE   name LIKE '#tmpSysPrin%' ) 
		BEGIN
			DROP TABLE #tmpSysPrin
		END
IF EXISTS ( SELECT  *
    FROM    tempdb.sys.tables
    WHERE   name LIKE '#tmprecord007%' ) 
		BEGIN
			DROP TABLE #tmprecord007
		END      
IF EXISTS ( SELECT  *
    FROM    tempdb.sys.tables
    WHERE   name LIKE '#tmprecord008%' ) 
		BEGIN
			DROP TABLE #tmprecord008
		END      
IF EXISTS ( SELECT  *
    FROM    tempdb.sys.tables
    WHERE   name LIKE '#tmprecord016%' ) 
		BEGIN
			DROP TABLE #tmprecord016
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
    WHERE   name LIKE '#tmprecord699%' ) 
		BEGIN
			DROP TABLE #tmprecord699
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

--Address Update Table
CREATE TABLE #tmprecord007
(
  [ID] [int] IDENTITY(1, 1)
             NOT NULL ,
  [AccountNumber] VARCHAR(16) NULL ,
  [TransID] VARCHAR(3) NULL,
  [AddressLine1] VARCHAR(26) NULL ,
  [City] VARCHAR(18) NULL ,
  [State] VARCHAR(2) NULL ,
  [ZipCode] VARCHAR(5) NULL ,
  [ZipPlus4] VARCHAR(4) NULL,
  [UserID] VARCHAR(6) NULL,
  [SysPrin] VARCHAR(10) NULL
)

--Address Line2 or Business Name Update Table
CREATE TABLE #tmprecord008
(
  [ID] [int] IDENTITY(1, 1)
             NOT NULL ,
  [AccountNumber] VARCHAR(16) NULL ,
  [TransID] VARCHAR(3) NULL,
  [AddressLine2] VARCHAR(26) NULL ,
  [UserID] VARCHAR(6) NULL,
  [SysPrin] VARCHAR(10) NULL
)

--Change External Status
CREATE TABLE #tmprecord016
(
  [ID] [int] IDENTITY(1, 1)
             NOT NULL ,
  [AccountNumber] VARCHAR(16) NULL ,
  [TransID] VARCHAR(3) NULL,
  [NewStatus] VARCHAR(1) NULL ,
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
SELECT DISTINCT id1 + '  ' + id2
FROM master m WITH (NOLOCK)
WHERE customer = @customer

--Record 007 Address Change
INSERT INTO #tmprecord007
        (AccountNumber , TransID , AddressLine1 , City , State , ZipCode , ZipPlus4 , UserID, SysPrin)
SELECT m.account, '007' AS TransID, UPPER(NewStreet1) AS Addr1, UPPER(NewCity) AS City, UPPER(NewState) AS STATE, SUBSTRING(NewZipcode, 1, 5) AS NewZip, CASE WHEN LEN(NewZipcode) > 5 THEN RIGHT(NewZipcode, 4) ELSE '' end AS NewZip4, 'SIM ZZ' AS UserID, m.id1 + '  ' + m.id2 AS SysPrin
FROM AddressHistory ah WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON ah.AccountID = m.number
WHERE customer = @customer AND datechanged BETWEEN dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, dbo.F_START_OF_DAY(@endDate))

--Record 008 Street2
INSERT INTO #tmprecord008
        (AccountNumber , TransID , AddressLine2 , UserID , SysPrin)
SELECT m.account, '008', UPPER(NewStreet2) AS Addr2, 'SIM ZZ' AS UserID, m.id1 + '  ' + m.id2 AS SysPrin
FROM AddressHistory ah WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON ah.AccountID = m.number
WHERE customer = @customer AND oldstreet2 <> newstreet2 AND datechanged BETWEEN dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, dbo.F_START_OF_DAY(@endDate))

--Record 016 Change External Status
INSERT INTO #tmprecord016
        (AccountNumber , TransID , NewStatus , UserID , SysPrin)
SELECT m.account, '016', CASE WHEN m.status = 'DEC' THEN 'I' WHEN m.status = 'CXL' THEN 'C' END AS newstatus, 'SIM ZZ', m.id1 + '  ' + m.id2 AS SysPrin
FROM master m WITH (NOLOCK)
WHERE customer = @customer AND status IN ('DEC', 'CXL') AND closed BETWEEN dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, dbo.F_START_OF_DAY(@endDate))

--Record 037 Update Home Phone
INSERT INTO #tmprecord037
        (AccountNumber ,TransID ,HomePhoneNumber ,UserID , SysPrin)
SELECT hp.account, '037', hp.PhoneNumber AS newnumber, 'SIM ZZ', hp.id1 + '  ' + hp.id2 AS SysPrin
FROM (SELECT m.account, DateAdded, PhoneNumber, m.id1, m.id2
FROM master m WITH (NOLOCK) INNER JOIN Phones_Master pm WITH (NOLOCK) ON m.number = pm.Number
WHERE m.customer = @customer AND PhoneTypeID = 1 AND Phonestatusid = 2 AND DateAdded BETWEEN dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, dbo.F_START_OF_DAY(@endDate))

UNION all

SELECT m.account, DateChanged AS DateAdded, CASE WHEN NewNumber = '' THEN '0000000000' ELSE NewNumber END AS newnumber, m.id1, m.id2
FROM master m WITH (NOLOCK) INNER JOIN PhoneHistory ph WITH (NOLOCK) ON m.number = ph.AccountID
WHERE m.customer = @customer AND phonetype = 1 AND DateChanged BETWEEN dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, dbo.F_START_OF_DAY(@endDate))
) hp
ORDER BY hp.DateAdded desc

--Record 056 Update Work Phone
INSERT INTO #tmprecord056
        (AccountNumber ,TransID ,WorkPhoneNumber ,UserID , SysPrin)
SELECT hp.account, '056', hp.PhoneNumber AS newnumber, 'SIM ZZ', hp.id1 + '  ' + hp.id2 AS SysPrin
FROM (SELECT m.account, DateAdded, PhoneNumber, m.id1, m.id2
FROM master m WITH (NOLOCK) INNER JOIN Phones_Master pm WITH (NOLOCK) ON m.number = pm.Number
WHERE m.customer = @customer AND PhoneTypeID = 2 AND Phonestatusid = 2 AND DateAdded BETWEEN dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, dbo.F_START_OF_DAY(@endDate))

UNION all

SELECT m.account, DateChanged AS DateAdded, CASE WHEN NewNumber = '' THEN '0000000000' ELSE NewNumber END AS newnumber, m.id1, m.id2
FROM master m WITH (NOLOCK) INNER JOIN PhoneHistory ph WITH (NOLOCK) ON m.number = ph.AccountID
WHERE m.customer = @customer AND phonetype = 2 AND DateChanged BETWEEN dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, dbo.F_START_OF_DAY(@endDate))
) hp
ORDER BY hp.DateAdded desc	

--Record 115 Memo or Note
INSERT INTO #tmprecord115
        (AccountNumber ,TransID ,UserID , Memo ,SysPrin)
SELECT m.account, '115', 'SIM' AS UserID, SUBSTRING(n.comment, 1, 57) AS Memo, m.id1 + '  ' + m.id2 AS SysPrin
FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer = @customer AND created BETWEEN dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, dbo.F_START_OF_DAY(@endDate))
AND n.result = 'TT'

--Record 699 Update Cell Phone
INSERT INTO #tmprecord699
        (AccountNumber ,TransID , SubCode, CellPhoneNumber ,UserID , SysPrin)
SELECT hp.account, '699', '2001', hp.PhoneNumber AS newnumber, 'SIM ZZ', hp.id1 + '  ' + hp.id2 AS SysPrin
FROM (SELECT m.account, DateAdded, PhoneNumber, m.id1, m.id2
FROM master m WITH (NOLOCK) INNER JOIN Phones_Master pm WITH (NOLOCK) ON m.number = pm.Number
WHERE m.customer = @customer AND PhoneTypeID = 3 AND Phonestatusid = 2 AND DateAdded BETWEEN dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, dbo.F_START_OF_DAY(@endDate))

UNION all

SELECT m.account, DateChanged AS DateAdded, CASE WHEN NewNumber = '' THEN '0000000000' ELSE NewNumber END AS newnumber, m.id1, m.id2
FROM master m WITH (NOLOCK) INNER JOIN PhoneHistory ph WITH (NOLOCK) ON m.number = ph.AccountID
WHERE m.customer = @customer AND phonetype = 3 AND DateChanged BETWEEN dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, dbo.F_START_OF_DAY(@endDate))
) hp
ORDER BY hp.DateAdded desc	

--Record 793 Email Update
INSERT INTO #tmprecord793
        (AccountNumber ,TransID , SubCode, UserID , EmailAddress ,SysPrin)
SELECT m.account, '793', '0101', 'SIM ZZ' AS UserID, NewEmail, m.id1 + '  ' + m.id2 AS SysPrin
FROM master m WITH (NOLOCK) INNER JOIN EmailHistory eh WITH (NOLOCK) ON m.number = eh.AccountID
WHERE m.customer = @customer AND DateChanged BETWEEN dbo.F_START_OF_DAY(@startDate) AND DATEADD(ss, -1, dbo.F_START_OF_DAY(@endDate))





SELECT DISTINCT sp.SysPrin
FROM (SELECT DISTINCT SysPrin FROM #tmprecord007 t
UNION SELECT DISTINCT SysPrin FROM #tmprecord008 t2
UNION SELECT DISTINCT SysPrin FROM #tmprecord016 t3
UNION SELECT DISTINCT SysPrin FROM #tmprecord037 t4
UNION SELECT DISTINCT SysPrin FROM #tmprecord056 t5
UNION SELECT DISTINCT SysPrin FROM #tmprecord115 t6
UNION SELECT DISTINCT SysPrin FROM #tmprecord699 t7
UNION SELECT DISTINCT SysPrin FROM #tmprecord793 t8
) sp

SELECT *
FROM #tmprecord007 t

SELECT *
FROM #tmprecord008 t

SELECT *
FROM #tmprecord016 t

SELECT *
FROM #tmprecord037 t

SELECT *
FROM #tmprecord056 t

SELECT *
FROM #tmprecord115 t

SELECT *
FROM #tmprecord699 t

SELECT *
FROM #tmprecord793 t

DROP TABLE #tmpSysPrin
DROP TABLE #tmprecord007
DROP TABLE #tmprecord008
DROP TABLE #tmprecord016
DROP TABLE #tmprecord037
DROP TABLE #tmprecord056
DROP TABLE #tmprecord115
DROP TABLE #tmprecord699
DROP TABLE #tmprecord793	

END
GO
