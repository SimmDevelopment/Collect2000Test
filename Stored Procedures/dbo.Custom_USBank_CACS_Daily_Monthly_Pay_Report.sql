SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 04/03/2020
-- Description:	Daily and MTD report numbers
-- =============================================

--Exec Custom_USBank_CACS_Daily_Monthly_Pay_Report '20200413', '20200413'


CREATE PROCEDURE [dbo].[Custom_USBank_CACS_Daily_Monthly_Pay_Report]
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS ( SELECT  *
	FROM    tempdb.sys.tables
	WHERE   name LIKE '#tmpusbankrpcnotes%' ) 
		BEGIN
			DROP TABLE #tmpusbankrpcnotes
		END
CREATE TABLE #tmpusbankrpcnotes
(
  [ID] [int] IDENTITY(1, 1)
             NOT NULL ,
  [FileNumber] INT NULL ,
  [DateCreated] DATETIME NULL
)


SET @startDate = dbo.F_START_OF_DAY(@startDate)
SET @endDate = DATEADD(ss, -1, dbo.F_START_OF_DAY(DATEADD(dd, 1, @endDate)))

--Populate temptable with all RPCs
INSERT INTO #tmpusbankrpcnotes ( FileNumber, DateCreated )
SELECT number, MIN(created)
FROM notes n WITH (NOLOCK)
WHERE number IN (
SELECT number 
FROM master m WITH (NOLOCK)
WHERE customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 113))
AND result IN (SELECT code FROM result WITH (NOLOCK) WHERE contacted = 1)
GROUP BY n.number



--Number unique RPCs
SELECT CAST(@endDate AS DATE) AS RunDate, (SELECT COUNT(DISTINCT FileNumber) AS firstRPC FROM #tmpusbankrpcnotes t
WHERE DateCreated BETWEEN @startDate AND @endDate) AS UniqueFirstRPC,

--Number Broken Accounts
(SELECT COUNT(DISTINCT number)
FROM master m WITH (NOLOCK)
WHERE number IN (SELECT AccountID 
                 FROM StatusHistory sh WITH (NOLOCK) WHERE AccountID = m.number AND NewStatus IN ('bkn', 'nsf', 'dcc') AND DateChanged BETWEEN @startDate AND @endDate)
      AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 113)
      AND number IN (SELECT number FROM payhistory p WITH (NOLOCK) WHERE number = m.number AND batchtype = 'pu' AND datepaid < @startDate)) AS NumBKN,

--Number pays or promises
(SELECT COUNT(DISTINCT number)
FROM master m WITH (NOLOCK)
WHERE  customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 113) 
--AND (status IN ('pdc', 'pcc', 'ppa') OR 
AND (m.number IN (SELECT number FROM payhistory p WITH (NOLOCK) WHERE number = m.number AND datepaid BETWEEN @startDate AND @endDate)
OR m.number IN (SELECT number FROM pdc WITH (NOLOCK) WHERE number = m.number AND deposit BETWEEN @startDate AND @endDate)
OR m.number IN (SELECT AcctID FROM promises WITH (NOLOCK) WHERE AcctID = m.number AND DueDate BETWEEN @startDate AND @endDate)
OR m.number IN (SELECT Number FROM DebtorCreditCards WITH (NOLOCK) WHERE Number = m.number AND DepositDate BETWEEN @startDate AND @endDAte)))  AS numPromPay,


--Payments on same day as RPC
(SELECT COUNT(DISTINCT number)
FROM payhistory p WITH (NOLOCK) INNER JOIN #tmpusbankrpcnotes t WITH (NOLOCK) ON number = FileNumber AND DateCreated BETWEEN @startDate AND @endDate
WHERE entered = CAST(DateCreated AS DATE)) AS PayonFirstRPC,

--Change Agreement
(SELECT COUNT(DISTINCT number)
FROM notes n WITH (NOLOCK)
WHERE number IN (SELECT number
                 FROM master m WITH (NOLOCK)
                 WHERE customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 113))
      AND created BETWEEN @startDate AND @endDate AND action = 'prom' AND result IN ('alter', 'del'))  AS numChngDel,

--Average Payment
(SELECT AVG(totalpaid)
FROM payhistory p WITH (NOLOCK)
WHERE customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 113) AND datepaid BETWEEN @startDate AND @endDate
AND batchtype = 'pu') AS AvgPay


DROP TABLE #tmpusbankrpcnotes
END
GO
