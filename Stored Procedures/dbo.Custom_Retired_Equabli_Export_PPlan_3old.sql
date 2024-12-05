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
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Retired_Equabli_Export_PPlan_3old]
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME

/*
exec Custom_Equabli_Export_PPlan '20230401', '20230406'
*/

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--Get UTC Date for when file was created
	SELECT FORMAT(GETUTCDATE(), 'yyyyMMddHHmmss') AS utcdate


    -- Insert statements for procedure here
	--Get PDC Settlements and PIF Post dates
SELECT 'pplan' AS record_type
	, m.id2 AS account_id
	, m.id1 AS client_account_number
	, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'acc.0.client_id') AS client_id
	, p.ArrangementID AS partner_plan_number
	, CASE WHEN p.PromiseMode IN (6,7,8) THEN ROUND(CAST(1.0000 - (CEILING(P.totalpaid ) / CEILING(m.current0 + ABS(m.paid))) AS DECIMAL(5,4)), 4) ELSE 0.0000 END AS pct_discount 
	, p.NumPdc AS count_payment
	, CASE p.PromiseMode WHEN 2 THEN 'M' WHEN 3 THEN 'B' WHEN 4 THEN 'B' WHEN 5 THEN 'W' WHEN 6 THEN 'OT' WHEN 7 THEN 'M' WHEN 9 THEN 'M' ELSE 'OT' END AS payment_plan_interval
	, CASE WHEN P.promisemode IN (6,7,8) THEN 'SO' ELSE 'OT' END AS payment_plan_reason
	, p.totalpaid + ABS(m.paid) AS amt_settlement
	, FORMAT(p.firstPay, 'yyyy-MM-dd') AS dt_downpayment
	, (SELECT TOP 1 amount FROM pdc WITH (NOLOCK) WHERE number = p.number AND (active = 1 OR (active = 0 AND printed = 1)) ORDER BY deposit ASC)  AS amt_down_payment
	, CASE WHEN p.PromiseMode IN (6,7,8) THEN FORMAT(p.lastpay, 'yyyy-MM-dd') ELSE '' END AS dt_settlement
	, 'BP' AS payment_method
	, '' AS payment_instrument_i4d
	, 'I' AS payment_plan_status
	, '' AS payment_plan_broken_reason
	, CASE p.PromiseMode WHEN 6 THEN 'SS' WHEN 7 THEN 'SM' WHEN 8 THEN 'PS' ELSE 'OT' END AS payment_plan_type
FROM master m WITH (NOLOCK) INNER JOIN (SELECT P.number, MAX(P.ArrangementID) AS arrangementID, MAX(CAST(p.DateCreated AS DATE)) AS datecreated, COUNT(1) AS NumPdc, 
		p.PromiseMode, MIN(CAST(p.deposit AS DATE)) AS firstPay, MAX(CAST(p.deposit AS DATE)) AS lastpay, CAST(SUM(amount) AS MONEY) AS totalpaid 
		FROM pdc p WITH (NOLOCK) WHERE (active = 1 OR (active = 0 AND printed = 1)) AND CAST(p.DateCreated AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
		GROUP BY p.number, p.PromiseMode) p ON m.number = p.number
WHERE (m.status = 'PDC' OR m.lastpaid BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE))
AND m.customer IN (Select customerid from fact where customgroupid = 381) 
AND CAST(p.DateCreated AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)

UNION ALL

--Get PCC Settlments and PIF post dates
SELECT 'pplan' AS record_type
	, m.id2 AS account_id
	, m.id1 AS client_account_number
	, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'acc.0.client_id') AS client_id
	, p.ArrangementID AS partner_plan_number
	, CASE WHEN p.PromiseMode IN (6,7,8) THEN ROUND(CAST(1.0000 - (CEILING(P.totalpaid ) / CEILING(m.current0 + ABS(m.paid))) AS DECIMAL(5,4)), 4) ELSE 0.0000 END AS pct_discount 
	, p.NumPdc AS count_payment
	, CASE p.PromiseMode WHEN 2 THEN 'M' WHEN 3 THEN 'B' WHEN 4 THEN 'B' WHEN 5 THEN 'W' WHEN 6 THEN 'OT' WHEN 7 THEN 'M' WHEN 9 THEN 'M' ELSE 'OT' END AS payment_plan_interval
	, CASE WHEN P.promisemode IN (6,7,8) THEN 'SO' ELSE 'OT' END AS payment_plan_reason
	, p.totalpaid + ABS(m.paid) AS amt_settlement
	, FORMAT(p.firstPay, 'yyyy-MM-dd') AS dt_downpayment
	, (SELECT TOP 1 amount FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND (IsActive = 1 OR (IsActive = 0 AND printed = 'Y')) ORDER BY DepositDate ASC)  AS amt_down_payment
	, CASE WHEN p.PromiseMode IN (6,7,8) THEN FORMAT(p.lastpay, 'yyyy-MM-dd') ELSE '' END AS dt_settlement
	, 'BP' AS payment_method
	, '' AS payment_instrument_i4d
	, 'I' AS payment_plan_status
	, '' AS payment_plan_broken_reason
	, CASE p.PromiseMode WHEN 6 THEN 'SS' WHEN 7 THEN 'SM' WHEN 8 THEN 'PS' ELSE 'OT' END AS payment_plan_type
FROM master m WITH (NOLOCK) INNER JOIN (SELECT P.number, MAX(P.ArrangementID) AS arrangementID, MAX(CAST(p.DateCreated AS DATE)) AS datecreated, COUNT(1) AS NumPdc, 
		p.PromiseMode, MIN(CAST(p.DepositDate AS DATE)) AS firstPay, MAX(CAST(p.DepositDate AS DATE)) AS lastpay, CAST(SUM(amount) AS MONEY) AS totalpaid 
		FROM DebtorCreditCards p WITH (NOLOCK) WHERE (isactive = 1 OR (isactive = 0 AND printed = 'Y')) AND CAST(p.DateCreated AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
		GROUP BY p.number, p.PromiseMode) p ON m.number = p.number
WHERE m.status = 'PCC' 
AND m.customer IN (Select customerid from fact where customgroupid = 381) 
AND CAST(p.DateCreated AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)

--Get Promise Settlements and PIF Post Dates
SELECT 'pplan' AS record_type
	, m.id2 AS account_id
	, m.id1 AS client_account_number
	, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'acc.0.client_id') AS client_id
	, p.ArrangementID AS partner_plan_number
	, CASE WHEN p.PromiseMode IN (6,7,8) THEN ROUND(CAST(1.0000 - (CEILING(P.totalpaid ) / CEILING(m.current0 + ABS(m.paid))) AS DECIMAL(5,4)), 4) ELSE 0.0000 END AS pct_discount 
	, p.NumPdc AS count_payment
	, CASE p.PromiseMode WHEN 2 THEN 'M' WHEN 3 THEN 'B' WHEN 4 THEN 'B' WHEN 5 THEN 'W' WHEN 6 THEN 'OT' WHEN 7 THEN 'M' WHEN 9 THEN 'M' ELSE 'OT' END AS payment_plan_interval
	, CASE WHEN P.promisemode IN (6,7,8) THEN 'SO' ELSE 'OT' END AS payment_plan_reason
	, p.totalpaid + ABS(m.paid) AS amt_settlement
	, FORMAT(p.firstPay, 'yyyy-MM-dd') AS dt_downpayment
	, (SELECT TOP 1 amount FROM promises WITH (NOLOCK) WHERE acctid = p.acctid AND (active = 1 OR (active = 0 AND kept = 1)) ORDER BY duedate ASC)  AS amt_down_payment
	, CASE WHEN p.PromiseMode IN (6,7,8) THEN FORMAT(p.lastpay, 'yyyy-MM-dd') ELSE '' END AS dt_settlement
	, 'OT' AS payment_method
	, '' AS payment_instrument_i4d
	, 'I' AS payment_plan_status
	, '' AS payment_plan_broken_reason
	, CASE p.PromiseMode WHEN 6 THEN 'SS' WHEN 7 THEN 'SM' WHEN 8 THEN 'PS' ELSE 'OT' END AS payment_plan_type
FROM master m WITH (NOLOCK) INNER JOIN (SELECT P.acctid, MAX(P.ArrangementID) AS arrangementID, MAX(CAST(p.DateCreated AS DATE)) AS datecreated, COUNT(1) AS NumPdc, 
		p.PromiseMode, MIN(CAST(p.duedate AS DATE)) AS firstPay, MAX(CAST(p.duedate AS DATE)) AS lastpay, CAST(SUM(amount) AS MONEY) AS totalpaid 
		FROM promises p WITH (NOLOCK) WHERE (active = 1 OR (active = 0 AND p.kept = 1)) AND CAST(p.DateCreated AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
		GROUP BY p.acctid, p.PromiseMode) p ON m.number = p.acctid
WHERE (m.status = 'PPA' OR m.lastpaid BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE))
AND m.customer IN (Select customerid from fact where customgroupid = 381) 
AND CAST(p.DateCreated AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)

UNION ALL

--Get Broken Settlments
SELECT 'pplan' AS record_type
	, m.id2 AS account_id
	, m.id1 AS client_account_number
	, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'acc.0.client_id') AS client_id
	, ISNULL(ISNULL(p.ArrangementID, pc.arrangementID), pr.arrangementid) AS partner_plan_number
	, 0.0000 AS pct_discount 
	, '' AS count_payment
	, '' AS payment_plan_interval
	, '' AS payment_plan_reason
	, '' AS amt_settlement
	, '' AS dt_downpayment
	, '' AS amt_down_payment
	, '' AS dt_settlement
	, '' AS payment_method
	, '' AS payment_instrument_i4d
	, 'V' AS payment_plan_status
	, 'NS' AS payment_plan_broken_reason
	, '' AS payment_plan_type
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
AND m.customer IN (Select customerid from fact where customgroupid = 381) 
AND m.number IN (SELECT TOP 1 sh.AccountID FROM StatusHistory sh WITH (NOLOCK) WHERE sh.AccountID = m.number AND sh.NewStatus IN ('DCC', 'NSF', 'BKN') 
AND CAST(sh.DateChanged AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE))

UNION ALL	

--Get Completed Plans
SELECT 'pplan' AS record_type
	, m.id2 AS account_id
	, m.id1 AS client_account_number
	, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'acc.0.client_id') AS client_id
	, ISNULL(ISNULL(p.ArrangementID, pc.arrangementID), pr.arrangementid) AS partner_plan_number
	, 0.0000 AS pct_discount 
	, '' AS count_payment
	, '' AS payment_plan_interval
	, '' AS payment_plan_reason
	, '' AS amt_settlement
	, '' AS dt_downpayment
	, '' AS amt_down_payment
	, '' AS dt_settlement
	, '' AS payment_method
	, '' AS payment_instrument_i4d
	, 'C' AS payment_plan_status
	, '' AS payment_plan_broken_reason
	, CASE WHEN status = 'PIF' AND (P.PromiseMode = 8 OR pc.PromiseMode = 8 OR pr.promisemode = 8) AND (p.NumPdc = 1 OR pc.NumPdc = 1 OR pr.numpdc = 1) THEN 'PS'
			WHEN status = 'PIF' AND (P.PromiseMode IN (6,7) OR pc.PromiseMode IN (6,7) OR pr.promisemode IN (6,7)) AND (p.NumPdc > 1 OR pc.NumPdc > 1 OR pr.numpdc > 1) THEN 'PM'
			WHEN status = 'SIF' AND (P.PromiseMode = 8 OR pc.PromiseMode = 8 OR pr.promisemode = 8) AND (p.NumPdc = 1 OR pc.NumPdc = 1 OR pr.numpdc = 1) THEN 'SS'
			WHEN status = 'SIF' AND (P.PromiseMode IN (6,7) OR pc.PromiseMode IN (6,7) OR pr.promisemode IN (6,7)) AND (p.NumPdc > 1 OR pc.NumPdc > 1 OR pr.numpdc > 1) THEN 'SM' ELSE 'OT' END AS payment_plan_type
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
AND (p.PromiseMode IN (6,7,8) OR pc.PromiseMode IN (6,7,8) OR pr.promisemode IN (6,7,8))
AND m.customer IN (Select customerid from fact where customgroupid = 381) 
END
GO
