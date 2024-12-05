SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G. Meehan
-- Create date: 02/06/2024
-- Description:	For NCB gets Daily Productivity KPI and Collections and Month to date totals
-- Changes:	02/14/2024 BGM Running Row Totals Calculated in Report Manager
-- =============================================
CREATE PROCEDURE [dbo].[Custom_NCB_Daily_Prod_Report_ReportManager_bu]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

-- Exec Custom_NCB_Daily_Prod_Report_ReportManager_bu

	SET NOCOUNT ON;
DECLARE @startMonth AS DATE
DECLARE @endMonth AS DATE
DECLARE @startNextMonth AS DATE
DECLARE @endNextMonth AS DATE
DECLARE @date AS DATE

SET @date = CAST(GETDATE() AS DATE)
SET @startMonth = CAST(dbo.F_START_OF_MONTH(@date) AS DATE)
SET @endMonth = CAST(dbo.F_END_OF_MONTH(@date) AS DATE)
SET @startNextMonth = CAST(dbo.F_START_OF_MONTH(dateadd(MM, 1, @date)) AS DATE)
SET @endNextMonth = CAST(dbo.F_END_OF_MONTH(dateadd(MM, 1, @date)) AS DATE)

    -- Insert statements for procedure here
CREATE TABLE #NCBDailyProdStageing(
		Customer VARCHAR(10),
		ProdDate DATE,
		Pays MONEY,
		PDCs MONEY,
		NumCalls INT,
		NumRPCs INT,
		MTDNumProm INT,
		MTDAmtProm MONEY,
		MTDNumPays INT,
		MTDNumLetters INT,
		MTDNumTexts INT,
		NextMthStartNumPDC INT,
		NextMthStartAmtPDC MONEY,
		NextMthStartNumPCC INT,
		NextMthStartAmtPCC MONEY
		)
	 -- Insert statements for procedure here
INSERT INTO #NCBDailyProdStageing 
(Customer, ProdDate, Pays, PDCs, NumCalls, NumRPCs, MTDNumProm, MTDAmtProm, MTDNumPays, MTDNumLetters, MTDNumTexts, NextMthStartNumPDC, NextMthStartAmtPDC, NextMthStartNumPCC
, NextMthStartAmtPCC)

--MTD $ Collections Posted
SELECT customer, datepaid, ISNULL(SUM(CASE WHEN batchtype LIKE '%r' THEN -(totalpaid) ELSE totalpaid END), 0) AS Pays, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
FROM payhistory WITH (NOLOCK)
WHERE customer IN (SELECT CustomerID FROM Fact WHERE CustomGroupID = 393) AND batchtype LIKE 'p%' AND CAST(datepaid AS DATE) BETWEEN @startMonth AND @endMonth
GROUP BY customer, datepaid

UNION ALL

--MTD $ PDCs ACH
SELECT customer, entered, 0, ISNULL(SUM(amount), 0) AS MTDPDC, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
FROM pdc WITH (NOLOCK)
WHERE customer in (Select customerid from fact where customgroupid = 393) AND cast(deposit AS DATE) BETWEEN @startMonth AND @endMonth AND active = 1
GROUP BY customer, entered

UNION ALL

--MTD $ PCCs
SELECT customer, dcc.DateEntered, 0, ISNULL(SUM(amount), 0) AS MTDPDC, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
FROM DebtorCreditCards dcc WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON dcc.Number = m.number
WHERE customer in (Select customerid from fact where customgroupid = 393) AND CAST(dcc.DepositDate AS DATE) BETWEEN @startMonth AND @endMonth AND isactive = 1
GROUP BY customer, dcc.DateEntered

UNION ALL

--Key Performance Indicators
--MTD Calls
SELECT customer, CAST(created AS DATE), 0, 0, COUNT(*) AS MTDCalls, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
FROM notes n WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON n.number = m.number
WHERE m.customer in (Select customerid from fact where customgroupid = 393) AND CAST(created AS DATE) BETWEEN @startMonth AND @endMonth
AND (action IN (SELECT code FROM action WITH (NOLOCK) WHERE WasAttempt = 1) OR action IN ('mnual', 'dial'))
AND user0 + result <> 'dialconnectf'
GROUP BY customer, CAST(created AS DATE)

UNION ALL

--MTD RPCs
SELECT customer, CAST(created AS DATE), 0, 0, 0, COUNT(*) AS MTDRPC, 0, 0, 0, 0, 0, 0, 0, 0, 0
FROM notes n WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON n.number = m.number
WHERE m.customer in (Select customerid from fact where customgroupid = 393) AND CAST(created AS DATE) BETWEEN @startMonth AND @endMonth
AND (action IN (SELECT code FROM action WITH (NOLOCK) WHERE WasAttempt = 1) OR action IN ('mnual', 'dial'))
AND user0 + result <> 'dialconnectf' AND result IN (SELECT code FROM result r WITH (NOLOCK) WHERE contacted = 1)
GROUP BY customer, CAST(created AS DATE)

UNION ALL

--MTD # of PDCs
SELECT customer, CAST(entered AS DATE), 0, 0, 0, 0, ISNULL(COUNT(*), 0) AS MTDNumProm, 0, 0, 0, 0, 0, 0, 0, 0
FROM pdc WITH (NOLOCK)
WHERE customer in (Select customerid from fact where customgroupid = 393) AND CAST(entered AS DATE) BETWEEN @startMonth AND @endMonth
AND (active = 1 OR IsBatched = 1 OR (Printed = 1 AND Active = 0))
GROUP BY customer, CAST(entered AS DATE)

UNION ALL

--MTD # of PCCs
SELECT customer, CAST(dcc.DateEntered AS DATE), 0, 0, 0, 0, ISNULL(COUNT(*), 0) AS MTDNumProm, 0, 0, 0, 0, 0, 0, 0, 0
FROM DebtorCreditCards dcc WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON dcc.Number = m.number
WHERE customer in (Select customerid from fact where customgroupid = 393) AND CAST(DateEntered AS DATE) BETWEEN @startMonth AND @endMonth
AND (dcc.IsActive = 1 OR IsBatched = 1 OR (Printed = 'Y' AND dcc.IsActive = 0))
GROUP BY customer, CAST(DateEntered AS DATE)

UNION ALL

--MTD # of PPAs
SELECT customer, CAST(p.Entered AS DATE), 0, 0, 0, 0, ISNULL(COUNT(*), 0) AS MTDNumProm, 0, 0, 0, 0, 0, 0, 0, 0
FROM promises p WITH (NOLOCK)
WHERE customer in (Select customerid from fact where customgroupid = 393) AND CAST(p.Entered AS DATE) BETWEEN @startMonth AND @endMonth
AND (p.Suspended = 0 OR p.Suspended IS NULL) AND (p.Active = 1 OR (p.Active = 0 AND p.Kept = 1))
GROUP BY customer, CAST(Entered AS DATE)

UNION ALL

--MTD $ of PDCs
SELECT customer, CAST(entered AS DATE), 0, 0, 0, 0, 0, ISNULL(SUM(amount), 0) AS MTDAmtProm, 0, 0, 0, 0, 0, 0, 0
FROM pdc WITH (NOLOCK)
WHERE customer in (Select customerid from fact where customgroupid = 393) AND CAST(entered AS DATE) BETWEEN @startMonth AND @endMonth
AND (active = 1 OR IsBatched = 1 OR (Printed = 1 AND Active = 0))
GROUP BY customer, CAST(entered AS DATE)

UNION ALL

--MTD $ of PCCs
SELECT customer, CAST(DateEntered AS DATE), 0, 0, 0, 0, 0, ISNULL(SUM(amount), 0) AS MTDAmtProm, 0, 0, 0, 0, 0, 0, 0
FROM DebtorCreditCards dcc WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON dcc.Number = m.number
WHERE customer in (Select customerid from fact where customgroupid = 393) AND CAST(DateEntered AS DATE) BETWEEN @startMonth AND @endMonth
AND (dcc.IsActive = 1 OR IsBatched = 1 OR (Printed = 'Y' AND dcc.IsActive = 0))
GROUP BY customer, CAST(DateEntered AS DATE)

UNION ALL

--MTD $ of PPAs
SELECT customer, CAST(entered AS DATE), 0, 0, 0, 0, 0, ISNULL(SUM(amount), 0) AS MTDAmtProm, 0, 0, 0, 0, 0, 0, 0
FROM promises p WITH (NOLOCK)
WHERE customer in (Select customerid from fact where customgroupid = 393) AND CAST(p.Entered AS DATE) BETWEEN @startMonth AND @endMonth
AND (p.Suspended = 0 OR p.Suspended IS NULL) AND (p.Active = 1 OR (p.Active = 0 AND p.Kept = 1))
GROUP BY customer, CAST(Entered AS DATE)

UNION ALL

--MTD # of Payments
SELECT customer, CAST(datepaid AS DATE), 0, 0, 0, 0, 0, 0, ISNULL(COUNT(*), 0) AS MTDnumPays, 0, 0, 0, 0, 0, 0
FROM payhistory WITH (NOLOCK) 
WHERE customer in (Select customerid from fact where customgroupid = 393) AND batchtype LIKE 'p%'
AND CAST(datepaid AS DATE) BETWEEN @startMonth AND @endMonth
GROUP BY customer, CAST(datepaid AS DATE)

UNION ALL

--MTD # of Letters
SELECT lr.CustomerCode, CASE WHEN DATEPART(WEEKDAY, CAST(DateProcessed -1 AS DATE)) IN (1,7) THEN CAST(lr.DateProcessed -3 AS DATE) ELSE CAST(DateProcessed -1 AS DATE) END,
--CAST(lr.DateProcessed AS DATE),
0, 0, 0, 0, 0, 0, 0, ISNULL(COUNT(*), 0) AS MTDnumLtr, 0, 0, 0, 0, 0
FROM LetterRequest lr WITH (NOLOCK)
WHERE customercode in (Select customerid from fact where customgroupid = 393) AND 
cast(DateProcessed AS DATE) BETWEEN @startMonth AND @endMonth
GROUP BY CustomerCode, CASE WHEN DATEPART(WEEKDAY, CAST(DateProcessed -1 AS DATE)) IN (1,7) THEN CAST(lr.DateProcessed -3 AS DATE) ELSE CAST(DateProcessed -1 AS DATE) END

UNION ALL

--MTD # of Texts
SELECT m.customer, CAST(n.created AS DATE), 0, 0, 0, 0, 0, 0, 0, 0, ISNULL(COUNT(*), 0) AS MTDnumTxt, 0, 0, 0, 0
FROM notes n WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON n.number = m.number
WHERE m.customer in (Select customerid from fact where customgroupid = 393) AND cast(created AS DATE) BETWEEN @startMonth AND @endMonth
AND action = 'TXT1' AND user0 = 'SBT'
GROUP BY customer, CAST(created AS DATE)

UNION ALL

--Futures
--Next Month Start # PDCs ACHs

SELECT customer, CASE WHEN pdc.entered <= cast('20240201' AS DATE) THEN cast('20240201' AS DATE) WHEN DATEPART(WEEKDAY, CAST(pdc.entered -1 AS DATE)) IN (1,7) THEN CAST(getdate() -3 AS DATE) ELSE CAST(pdc.entered -1 AS DATE) END,
--CASE WHEN DATEPART(WEEKDAY, CAST(getdate() -1 AS DATE)) IN (1,7) THEN CAST(getdate() -3 AS DATE) ELSE CAST(getdate() -1 AS DATE) END,
--CAST(getdate() -1 AS DATE),
0, 0, 0, 0, 0, 0, 0, 0, 0, ISNULL(COUNT(*), 0) AS NextMthStartNumPDC, 0, 0, 0
FROM pdc pdc WITH (NOLOCK)
WHERE customer in (Select customerid from fact where customgroupid = 393) AND CAST(deposit AS DATE) between @startNextMonth AND @endNextMonth
AND active = 1
GROUP BY customer, pdc.entered

UNION ALL

--Next Month Start $ PDCs ACHs
SELECT customer, CASE WHEN pdc.entered <= cast('20240201' AS DATE) THEN cast('20240201' AS DATE) WHEN DATEPART(WEEKDAY, CAST(pdc.entered -1 AS DATE)) IN (1,7) THEN CAST(getdate() -3 AS DATE) ELSE CAST(pdc.entered -1 AS DATE) END,
--CASE WHEN DATEPART(WEEKDAY, CAST(getdate() -1 AS DATE)) IN (1,7) THEN CAST(getdate() -3 AS DATE) ELSE CAST(getdate() -1 AS DATE) END,
--CAST(getdate() -1 AS DATE),
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ISNULL(SUM(amount), 0) AS NextMthStartAmtPDC, 0, 0
FROM pdc pdc WITH (NOLOCK)
WHERE customer in (Select customerid from fact where customgroupid = 393) AND CAST(deposit AS DATE) between @startNextMonth AND @endNextMonth
AND active = 1
GROUP BY customer, pdc.entered

UNION ALL

--Next Month Start # PCC
SELECT customer, CASE WHEN dcc.DateEntered <= cast('20240201' AS DATE) THEN cast('20240201' AS DATE) WHEN DATEPART(WEEKDAY, CAST(dcc.DateEntered -1 AS DATE)) IN (1,7) THEN CAST(getdate() -3 AS DATE) ELSE CAST(dcc.DateEntered -1 AS DATE) END,
--CASE WHEN DATEPART(WEEKDAY, CAST(getdate() -1 AS DATE)) IN (1,7) THEN CAST(getdate() -3 AS DATE) ELSE CAST(getdate() -1 AS DATE) END,
--CAST(getdate() -1 AS DATE),
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ISNULL(COUNT(*), 0) AS NextMthStartNumPCC, 0
FROM DebtorCreditCards dcc WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON dcc.Number = m.number
WHERE customer in (Select customerid from fact where customgroupid = 393) AND CAST(dcc.DepositDate AS DATE) between @startNextMonth AND @endNextMonth
AND isactive = 1
GROUP BY customer, dcc.DateEntered

UNION ALL

--Next Month Start $ PCC
SELECT customer, CASE WHEN dcc.DateEntered <= cast('20240201' AS DATE) THEN cast('20240201' AS DATE) WHEN DATEPART(WEEKDAY, CAST(dcc.DateEntered -1 AS DATE)) IN (1,7) THEN CAST(getdate() -3 AS DATE) ELSE CAST(dcc.DateEntered -1 AS DATE) END,
--CASE WHEN DATEPART(WEEKDAY, CAST(getdate() -1 AS DATE)) IN (1,7) THEN CAST(getdate() -3 AS DATE) ELSE CAST(getdate() -1 AS DATE) END,
--CAST(getdate() -1 AS DATE),
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ISNULL(SUM(amount), 0) AS NextMthStartAmtPCC
FROM DebtorCreditCards dcc WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON dcc.Number = m.number
WHERE customer in (Select customerid from fact where customgroupid = 393) AND CAST(dcc.DepositDate AS DATE) between @startNextMonth AND @endNextMonth
AND isactive = 1
GROUP BY customer, dcc.DateEntered

--SELECT * FROM (
--SELECT ISNULL(nps.Customer, '') AS Customer, c.Date AS CalDate, 
--[MonthDayCust] = ROW_NUMBER() OVER (PARTITION BY customer ORDER BY customer, c.Date)
--, sum(sum(nps.Pays)) OVER (PARTITION BY customer ORDER BY customer, c.date ) AS [MTDPaysPosted]
--, sum(sum(nps.PDCs)) OVER (PARTITION BY customer ORDER BY Customer, c.date) AS [MTDPDCAmt]
--, sum(sum(nps.NumCalls)) OVER (PARTITION BY customer ORDER BY Customer, c.date) AS [MTDNumofCalls]
--, sum(sum(nps.NumRPCs)) OVER (PARTITION BY customer ORDER BY Customer, c.date) AS [MTDNumofRPCs]
--, sum(sum(nps.MTDNumProm)) OVER (PARTITION BY customer ORDER BY Customer, c.date) AS [MTDNumofPromises]
--, sum(sum(nps.MTDAmtProm)) OVER (PARTITION BY customer ORDER BY Customer, c.date) AS [MTDAmtofPromises]
--, sum(sum(nps.MTDNumPays)) OVER (PARTITION BY customer ORDER BY Customer, c.date) AS [MTDNumofPayments]
--, sum(sum(nps.MTDNumLetters)) OVER (PARTITION BY customer ORDER BY Customer, c.date) AS [MTDNumofLetters]
--, sum(sum(nps.MTDNumTexts)) OVER (PARTITION BY customer ORDER BY Customer, c.date) AS [MTDNumofTexts]
--, sum(sum(nps.NextMthStartNumPDC)) OVER (PARTITION BY customer ORDER BY Customer, c.date) AS [NxtMthStartNumofPDC]
--, sum(sum(nps.NextMthStartAmtPDC)) OVER (PARTITION BY customer ORDER BY Customer, c.date) AS [NxtMthStartAmtofPDC]
--, sum(sum(nps.NextMthStartNumPCC)) OVER (PARTITION BY customer ORDER BY Customer, c.date) AS [NxtMthStartNumofPCC]
--, sum(sum(nps.NextMthStartAmtPCC)) OVER (PARTITION BY customer ORDER BY Customer, c.date) AS [NxtMthStartAmtofPCC]
SELECT ISNULL(nps.Customer, '') AS Customer, c.Date AS CalDate, 
--[MonthDayCust] = ROW_NUMBER() OVER (PARTITION BY customer ORDER BY customer, c.Date)
 sum(nps.Pays) AS [MTDPaysPosted]
, sum(nps.PDCs) AS [MTDPDCAmt]
, sum(nps.NumCalls)  AS [MTDNumofCalls]
, sum(nps.NumRPCs)  AS [MTDNumofRPCs]
, sum(nps.MTDNumProm)  AS [MTDNumofPromises]
, sum(nps.MTDAmtProm) AS [MTDAmtofPromises]
, sum(nps.MTDNumPays)  AS [MTDNumofPayments]
, sum(nps.MTDNumLetters)  AS [MTDNumofLetters]
, sum(nps.MTDNumTexts)  AS [MTDNumofTexts]
, sum(nps.NextMthStartNumPDC)  AS [NxtMthStartNumofPDC]
, sum(nps.NextMthStartAmtPDC)  AS [NxtMthStartAmtofPDC]
, sum(nps.NextMthStartNumPCC)  AS [NxtMthStartNumofPCC]
, sum(nps.NextMthStartAmtPCC) AS [NxtMthStartAmtofPCC]
FROM #NCBDailyProdStageing nps 
JOIN Calendar c ON CAST(nps.ProdDate AS DATE) = CAST(c.Date AS DATE)
WHERE c.date BETWEEN CAST(@startMonth AS DATE) AND CASE WHEN DATEPART(WEEKDAY, CAST(getdate() -1 AS DATE)) IN (1,7) THEN CAST(getdate() -3 AS DATE) ELSE CAST(getdate() -1 AS DATE) END-- CAST(getdate() -1  AS DATE)-- CAST(@endMonth AS DATE)
AND ISNULL(nps.Customer, '') <> ''
--AND datepart(weekday, c.date) NOT IN (7,1)
GROUP BY customer, c.Date
--) AS z
--ORDER BY z.CalDate 

-- Exec Custom_NCB_Daily_Prod_Report_ReportManager_bu

END


GO
