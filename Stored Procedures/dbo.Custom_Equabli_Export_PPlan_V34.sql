SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 03/22/2023
-- Description:	Export Payment Plan Information
-- Changes:
--	04/14/2023 BGM Test group = 111, Production group = 381
--	04/14/2023 BGM Moved to Production
--	04/20/2023 BRM Added promises
--	12/08/2023 BGM Updated to V3.4
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Equabli_Export_PPlan_V34]
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME

/*
	exec Custom_Equabli_Export_PPlan_V34 '20231201', '20240101'
*/

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--Get UTC Date for when file was created
	SELECT FORMAT(GETUTCDATE(), 'yyyyMMddHHmmss') AS utcdate

--Customer Group ID Test = 114 Production = 381
DECLARE @groupid INT
SET @groupid = 114

    -- Insert statements for procedure here
--Get PDC Settlements and PIF Post dates
SELECT 'pplan' AS recordType
	, m.id2 AS equabliAccountNumber
	, m.id1 AS clientAccountNumber
	, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'acc.0.equabliClientId') AS equabliClientId
	, p.ArrangementID AS paymentPlanId
	, CASE WHEN p.PromiseMode IN (6,7,8) THEN ROUND(CAST(1.0000 - (CEILING(P.totalpaid ) / CEILING(m.current0 + ABS(m.paid))) AS DECIMAL(5,4)), 4) ELSE 0.0000 END AS discountPercentage 
	, p.NumPdc AS noOfPayments
	, CASE p.PromiseMode WHEN 2 THEN 'M' WHEN 3 THEN 'B' WHEN 4 THEN 'B' WHEN 5 THEN 'W' WHEN 6 THEN 'O' WHEN 7 THEN 'M' WHEN 9 THEN 'M' 
		ELSE CASE WHEN (DATEDIFF(dd, p.firstPay, (p.lastpay)) + 1) / p.NumPdc = 1 THEN 'D' ELSE 'O' END END AS planInterval
	, CASE WHEN P.promisemode IN (6,7,8) OR m.current0 = P.totalpaid THEN 'SO' ELSE 'OT' END AS planReason
	, p.totalpaid + ABS(m.paid) AS settlementAmount
	, FORMAT(p.firstPay, 'yyyy-MM-dd') AS downPaymentDate
	, (SELECT TOP 1 amount FROM pdc WITH (NOLOCK) WHERE number = p.number AND (active = 1 OR (active = 0 AND printed = 1 AND ProcessStatus = 'Active')) ORDER BY deposit ASC)  AS downPaymentAmount
	, CASE WHEN p.PromiseMode IN (6,7,8) OR m.current0 = P.totalpaid THEN FORMAT(p.lastpay, 'yyyy-MM-dd') ELSE '' END AS settlementDate
	, 'BP' AS paymentMethod
	, 'I' AS planStatus
	, '' AS planBrokenReason
	, CASE p.PromiseMode WHEN 6 THEN 'SF' WHEN 7 THEN 'SF' WHEN 8 THEN 'PF' ELSE
	CASE WHEN m.current0 = P.totalpaid THEN 'PF' ELSE '' END END AS planType
FROM master m WITH (NOLOCK) INNER JOIN (SELECT P.number, MAX(P.ArrangementID) AS arrangementID, MAX(CAST(p.DateCreated AS DATE)) AS datecreated, COUNT(1) AS NumPdc, 
		p.PromiseMode, MIN(CAST(p.deposit AS DATE)) AS firstPay, MAX(CAST(p.deposit AS DATE)) AS lastpay, CAST(SUM(amount) AS MONEY) AS totalpaid 
		FROM pdc p WITH (NOLOCK) WHERE (active = 1 OR (active = 0 AND printed = 1 AND ProcessStatus = 'Active')) AND CAST(p.DateCreated AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
		GROUP BY p.number, p.PromiseMode) p ON m.number = p.number
WHERE (m.status = 'PDC' OR m.lastpaid BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE))
AND m.customer IN (Select customerid from fact where customgroupid = @groupid) 
AND CAST(p.DateCreated AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)

UNION ALL

--Get PCC Settlments and PIF post dates
SELECT 'pplan' AS recordType
	, m.id2 AS equabliAccountNumber
	, m.id1 AS clientAccountNumber
	, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'acc.0.equabliClientId') AS equabliClientId
	, p.ArrangementID AS paymentPlanId
	, CASE WHEN p.PromiseMode IN (6,7,8) THEN ROUND(CAST(1.0000 - (CEILING(P.totalpaid ) / CEILING(m.current0 + ABS(m.paid))) AS DECIMAL(5,4)), 4) ELSE 0.0000 END AS discountPercentage 
	, p.NumPdc AS noOfPayments
	, CASE p.PromiseMode WHEN 2 THEN 'M' WHEN 3 THEN 'B' WHEN 4 THEN 'B' WHEN 5 THEN 'W' WHEN 6 THEN 'O' WHEN 7 THEN 'M' WHEN 9 THEN 'M' 
		ELSE CASE WHEN (DATEDIFF(dd, p.firstPay, (p.lastpay)) + 1) / p.NumPdc = 1 THEN 'D' ELSE 'O' END END AS planInterval
	, CASE WHEN P.promisemode IN (6,7,8) OR m.current0 = P.totalpaid THEN 'SO' ELSE 'OT' END AS planReason
	, p.totalpaid + ABS(m.paid) AS settlementAmount
	, FORMAT(p.firstPay, 'yyyy-MM-dd') AS downPaymentDate
	, (SELECT TOP 1 amount FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND (IsActive = 1 OR (IsActive = 0 AND printed = 'Y')) ORDER BY DepositDate ASC)  AS downPaymentAmount
	, CASE WHEN p.PromiseMode IN (6,7,8) OR m.current0 = P.totalpaid THEN FORMAT(p.lastpay, 'yyyy-MM-dd') ELSE '' END AS settlementDate
	, 'CP' AS paymentMethod
	, 'I' AS planStatus
	, '' AS planBrokenReason
	, CASE p.PromiseMode WHEN 6 THEN 'SF' WHEN 7 THEN 'SF' WHEN 8 THEN 'PF' ELSE
	CASE WHEN m.current0 = P.totalpaid THEN 'PF' ELSE '' END END AS planType
FROM master m WITH (NOLOCK) INNER JOIN (SELECT P.number, MAX(P.ArrangementID) AS arrangementID, MAX(CAST(p.DateCreated AS DATE)) AS datecreated, COUNT(1) AS NumPdc, 
		p.PromiseMode, MIN(CAST(p.DepositDate AS DATE)) AS firstPay, MAX(CAST(p.DepositDate AS DATE)) AS lastpay, CAST(SUM(amount) AS MONEY) AS totalpaid 
		FROM DebtorCreditCards p WITH (NOLOCK) WHERE (isactive = 1 OR (isactive = 0 AND printed = 'Y')) AND CAST(p.DateCreated AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
		GROUP BY p.number, p.PromiseMode) p ON m.number = p.number
WHERE m.status = 'PCC' 
AND m.customer IN (Select customerid from fact where customgroupid = @groupid) 
AND CAST(p.DateCreated AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)

UNION ALL

--Get Promise Settlements and PIF Post Dates
SELECT 'pplan' AS recordType
	, m.id2 AS equabliAccountNumber
	, m.id1 AS clientAccountNumber
	, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'acc.0.equabliClientId') AS equabliClientId
	, p.ArrangementID AS paymentPlanId
	, CASE WHEN p.PromiseMode IN (6,7,8) THEN ROUND(CAST(1.0000 - (CEILING(P.totalpaid ) / CEILING(m.current0 + ABS(m.paid))) AS DECIMAL(5,4)), 4) ELSE 0.0000 END AS discountPercentage 
	, p.NumPdc AS noOfPayments
	, CASE p.PromiseMode WHEN 2 THEN 'M' WHEN 3 THEN 'B' WHEN 4 THEN 'B' WHEN 5 THEN 'W' WHEN 6 THEN 'O' WHEN 7 THEN 'M' WHEN 9 THEN 'M' 
		ELSE CASE WHEN (DATEDIFF(dd, p.firstPay, (p.lastpay)) + 1) / p.NumPdc = 1 THEN 'D' ELSE 'O' END END AS planInterval
	, CASE WHEN P.promisemode IN (6,7,8) OR m.current0 = P.totalpaid THEN 'SO' ELSE 'OT' END AS planReason
	, p.totalpaid + ABS(m.paid) AS settlementAmount
	, FORMAT(p.firstPay, 'yyyy-MM-dd') AS downPaymentDate
	, (SELECT TOP 1 amount FROM promises WITH (NOLOCK) WHERE acctid = p.acctid AND (active = 1 OR (active = 0 AND kept = 1)) ORDER BY duedate ASC)  AS downPaymentAmount
	, CASE WHEN p.PromiseMode IN (6,7,8) OR m.current0 = P.totalpaid THEN FORMAT(p.lastpay, 'yyyy-MM-dd') ELSE '' END AS settlementDate
	, 'OT' AS paymentMethod
	, 'I' AS planStatus
	, '' AS planBrokenReason
	, CASE p.PromiseMode WHEN 6 THEN 'SF' WHEN 7 THEN 'SF' WHEN 8 THEN 'PF' ELSE
	CASE WHEN m.current0 = P.totalpaid THEN 'PF' ELSE '' END END AS planType
FROM master m WITH (NOLOCK) INNER JOIN (SELECT P.acctid, MAX(P.ArrangementID) AS arrangementID, MAX(CAST(p.DateCreated AS DATE)) AS datecreated, COUNT(1) AS NumPdc, 
		p.PromiseMode, MIN(CAST(p.duedate AS DATE)) AS firstPay, MAX(CAST(p.duedate AS DATE)) AS lastpay, CAST(SUM(amount) AS MONEY) AS totalpaid 
		FROM promises p WITH (NOLOCK) WHERE (active = 1 OR (active = 0 AND p.kept = 1)) AND CAST(p.DateCreated AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
		GROUP BY p.acctid, p.PromiseMode) p ON m.number = p.acctid
WHERE (m.status = 'PPA' OR m.lastpaid BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE))
AND m.customer IN (Select customerid from fact where customgroupid = @groupid) 
AND CAST(p.DateCreated AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)

UNION ALL

--Get Broken Settlments
SELECT 'pplan' AS recordType
	, m.id2 AS equabliAccountNumber
	, m.id1 AS clientAccountNumber
	, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'acc.0.equabliClientId') AS equabliClientId
	, ISNULL(ISNULL(p.ArrangementID, pc.arrangementID), pr.arrangementid) AS paymentPlanId
	, 0.0000 AS discountPercentage 
	, '' AS noOfPayments
	, '' AS planInterval
	, '' AS planReason
	, '' AS settlementAmount
	, '' AS downPaymentDate
	, '' AS downPaymentAmount
	, '' AS settlementDate
	, '' AS paymentMethod
	, 'V' AS planStatus
	, 'NS' AS planBrokenReason
	, '' AS planType
FROM master m WITH (NOLOCK) LEFT OUTER JOIN (SELECT P.number, MAX(P.ArrangementID) AS arrangementID, MAX(CAST(p.DateCreated AS DATE)) AS datecreated, COUNT(1) AS NumPdc, 
		p.PromiseMode, MIN(CAST(p.DepositDate AS DATE)) AS firstPay, MAX(CAST(p.DepositDate AS DATE)) AS lastpay, CAST(SUM(amount) AS MONEY) AS totalpaid 
		FROM DebtorCreditCards p WITH (NOLOCK) WHERE (isactive = 1 OR (isactive = 0 AND printed = 'Y')) 
		AND CAST(p.DateCreated AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
		GROUP BY p.number, p.PromiseMode) p ON m.number = p.number
		LEFT OUTER JOIN (SELECT P.number, MAX(P.ArrangementID) AS arrangementID, MAX(CAST(p.DateCreated AS DATE)) AS datecreated, COUNT(1) AS NumPdc, 
		p.PromiseMode, MIN(CAST(p.deposit AS DATE)) AS firstPay, MAX(CAST(p.deposit AS DATE)) AS lastpay, CAST(SUM(amount) AS MONEY) AS totalpaid 
		FROM pdc p WITH (NOLOCK) WHERE (active = 1 OR (active = 0 AND printed = 1)) 
		AND CAST(p.DateCreated AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
		GROUP BY p.number, p.PromiseMode) pc ON m.number = pc.number
		LEFT OUTER JOIN (SELECT P.acctid, MAX(P.ArrangementID) AS arrangementID, MAX(CAST(p.DateCreated AS DATE)) AS datecreated, COUNT(1) AS NumPdc, 
		p.PromiseMode, MIN(CAST(p.duedate AS DATE)) AS firstPay, MAX(CAST(p.duedate AS DATE)) AS lastpay, CAST(SUM(amount) AS MONEY) AS totalpaid 
		FROM promises p WITH (NOLOCK) WHERE (active = 1 OR (active = 0 AND kept = 1)) 
		AND CAST(p.DateCreated AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
		GROUP BY p.acctid, p.PromiseMode) pr ON m.number = pr.acctid
WHERE m.status IN ('DCC', 'NSF', 'BKN') AND (p.ArrangementID IS NOT NULL OR pc.arrangementID IS NOT NULL OR pr.arrangementid IS NOT NULL)
AND m.customer IN (Select customerid from fact where customgroupid = @groupid) 
AND m.number IN (SELECT TOP 1 sh.AccountID FROM StatusHistory sh WITH (NOLOCK) WHERE sh.AccountID = m.number AND sh.NewStatus IN ('DCC', 'NSF', 'BKN') 
AND CAST(sh.DateChanged AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE))

UNION ALL	

--Get Completed Plans
SELECT 'pplan' AS recordType
	, m.id2 AS equabliAccountNumber
	, m.id1 AS clientAccountNumber
	, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'acc.0.equabliClientId') AS equabliClientId
	, ISNULL(ISNULL(ISNULL(p.ArrangementID, pc.arrangementID), pr.arrangementid), (SELECT TOP 1 ph.uid FROM payhistory ph WITH (NOLOCK) WHERE m.number = ph.number AND batchtype LIKE 'pu' ORDER BY ph.datepaid DESC)) AS paymentPlanId
	, 0.0000 AS discountPercentage 
	, '' AS noOfPayments
	, '' AS planInterval
	, '' AS planReason
	, '' AS settlementAmount
	, '' AS downPaymentDate
	, '' AS downPaymentAmount
	, '' AS settlementDate
	, '' AS paymentMethod
	, 'C' AS planStatus
	, '' AS planBrokenReason
	, CASE WHEN status = 'PIF' THEN 'PF' WHEN status = 'SIF' THEN 'SF' END AS planType
	--CASE WHEN status = 'PIF' AND (P.PromiseMode = 8 OR pc.PromiseMode = 8 OR pr.promisemode = 8) AND (p.NumPdc = 1 OR pc.NumPdc = 1 OR pr.numpdc = 1) THEN 'PF'
	--		WHEN status = 'PIF' AND (P.PromiseMode IN (6,7) OR pc.PromiseMode IN (6,7) OR pr.promisemode IN (6,7)) AND (p.NumPdc > 1 OR pc.NumPdc > 1 OR pr.numpdc > 1) THEN 'PF'
	--		WHEN status = 'PIF' AND 
	--		WHEN status = 'SIF' AND (P.PromiseMode = 8 OR pc.PromiseMode = 8 OR pr.promisemode = 8) AND (p.NumPdc = 1 OR pc.NumPdc = 1 OR pr.numpdc = 1) THEN 'SS'
	--		WHEN status = 'SIF' AND (P.PromiseMode IN (6,7) OR pc.PromiseMode IN (6,7) OR pr.promisemode IN (6,7)) AND (p.NumPdc > 1 OR pc.NumPdc > 1 OR pr.numpdc > 1) THEN 'SM' ELSE 'OT' END AS planType
FROM master m WITH (NOLOCK) LEFT OUTER JOIN (SELECT P.number, MAX(P.ArrangementID) AS arrangementID, MAX(CAST(p.DateCreated AS DATE)) AS datecreated, COUNT(1) AS NumPdc, 
		p.PromiseMode, MIN(CAST(p.DepositDate AS DATE)) AS firstPay, MAX(CAST(p.DepositDate AS DATE)) AS lastpay, CAST(SUM(amount) AS MONEY) AS totalpaid 
		FROM DebtorCreditCards p WITH (NOLOCK) WHERE (isactive = 1 OR (isactive = 0 AND printed = 'Y')) 
		AND p.PromiseMode IN (6,7,8)
		GROUP BY p.number, p.PromiseMode) p ON m.number = p.number
		LEFT OUTER JOIN (SELECT P.number, MAX(P.ArrangementID) AS arrangementID, MAX(CAST(p.DateCreated AS DATE)) AS datecreated, COUNT(1) AS NumPdc, 
		p.PromiseMode, MIN(CAST(p.deposit AS DATE)) AS firstPay, MAX(CAST(p.deposit AS DATE)) AS lastpay, CAST(SUM(amount) AS MONEY) AS totalpaid 
		FROM pdc p WITH (NOLOCK) WHERE (active = 1 OR (active = 0 AND printed = 1)) 
		AND p.PromiseMode IN (6,7,8)
		GROUP BY p.number, p.PromiseMode) pc ON m.number = pc.number
		LEFT OUTER JOIN (SELECT P.acctid, MAX(P.ArrangementID) AS arrangementID, MAX(CAST(p.DateCreated AS DATE)) AS datecreated, COUNT(1) AS NumPdc, 
		p.PromiseMode, MIN(CAST(p.duedate AS DATE)) AS firstPay, MAX(CAST(p.duedate AS DATE)) AS lastpay, CAST(SUM(amount) AS MONEY) AS totalpaid 
		FROM promises p WITH (NOLOCK) WHERE (active = 1 OR (active = 0 AND kept = 1)) 
		AND CAST(p.DateCreated AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
		GROUP BY p.acctid, p.PromiseMode) pr ON m.number = pr.acctid
WHERE m.status IN ('SIF', 'PIF') 
AND CAST(closed AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
--AND (p.PromiseMode IN (6,7,8) OR pc.PromiseMode IN (6,7,8) OR pr.promisemode IN (6,7,8))
AND m.customer IN (Select customerid from fact where customgroupid = @groupid) 
END
GO
