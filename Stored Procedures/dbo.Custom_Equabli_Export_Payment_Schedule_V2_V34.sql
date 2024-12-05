SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 03/29/2023
-- Description:	Export Payment Schedule Information
-- Changes:
--	04/14/2023 BGM Added UTC date for header
--	04/14/2023 BGM Moved to production
--	04/14/2023 BGM Changed from date range to invoice number
--  07/19/2023 BGM PSchedule report should breakout each payment setup in a payment plan.  Not just a payment that was made on a payment plan as it has been doing since day 1.
--	12/08/2023 BGM Converted to Version 3.4
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Equabli_Export_Payment_Schedule_V2_V34]
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME	
	
/*
	exec Custom_Equabli_Export_Payment_Schedule_V2_V34 '20231205', '20231230'
*/


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		SELECT FORMAT(GETUTCDATE(), 'yyyyMMddHHmmss') AS utcdate

--Customer Group ID Test = 114 Production = 381
DECLARE @groupid INT
SET @groupid = 114


--Get PDC Settlements and PIF Post dates
SELECT 'pschedule' AS recordType  	
, m.id2 AS equabliAccountNumber
, m.id1 AS clientAccountNumber
, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'acc.0.equabliClientId') AS equabliClientId
, p.ArrangementID AS paymentPlanId
, ROW_NUMBER() OVER(PARTITION BY m.id2 ORDER BY p.deposit ASC) AS paymentSerial
, p.amount AS paymentAmount
, CASE WHEN p.approvedby = 'Payweb' THEN 'BI' WHEN p.pdc_type IN (6,7,8) THEN 'CK' ELSE 'BP' END AS paymentMethod
, FORMAT(deposit, 'yyyy-MM-dd') AS paymentDate
, 'UP' AS paymentScheduleStatus
FROM master m WITH (NOLOCK) INNER JOIN pdc p WITH (NOLOCK) ON m.number = P.number
WHERE active = 1 AND p.onhold IS NULL
AND m.customer IN (Select customerid from fact where customgroupid = @groupid) 
AND (active = 1 OR (active = 0 AND printed = 1)) AND CAST(p.DateCreated AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)

UNION ALL

--Get PCC Settlements and PIF Post dates
SELECT 'pschedule' AS recordType  	
, m.id2 AS equabliAccountNumber
, m.id1 AS clientAccountNumber
, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'acc.0.equabliClientId') AS equabliClientId
, p.ArrangementID AS paymentPlanId
, ROW_NUMBER() OVER(PARTITION BY m.id2 ORDER BY p.depositdate ASC) AS paymentSerial
, p.amount AS paymentAmount
, CASE WHEN p.approvedby = 'Payweb' THEN 'CI' ELSE 'CD' END AS paymentMethod
, FORMAT(p.depositdate, 'yyyy-MM-dd') AS paymentDate
, 'UP' AS paymentScheduleStatus
FROM master m WITH (NOLOCK) INNER JOIN debtorcreditcards p WITH (NOLOCK) ON m.number = P.number
WHERE p.isactive = 1 AND p.onholddate IS NULL
AND m.customer IN (Select customerid from fact where customgroupid = @groupid) 
AND (isactive = 1 OR (isactive = 0 AND printed = 'Y')) AND CAST(p.DateCreated AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)

UNION ALL

--Get PPA Settlements and PIF Post dates
SELECT 'pschedule' AS recordType  	
, m.id2 AS equabliAccountNumber
, m.id1 AS clientAccountNumber
, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'acc.0.equabliClientId') AS equabliClientId
, p.ArrangementID AS paymentPlanId
, ROW_NUMBER() OVER(PARTITION BY m.id2 ORDER BY p.duedate ASC) AS paymentSerial
, p.amount AS paymentAmount
, 'OT' AS paymentMethod
, FORMAT(p.duedate, 'yyyy-MM-dd') AS paymentDate
, 'UP' AS paymentScheduleStatus
FROM master m WITH (NOLOCK) INNER JOIN promises p WITH (NOLOCK) ON m.number = P.acctid
WHERE p.active = 1 AND (p.suspended IS NULL OR p.suspended = 0)
AND m.customer IN (Select customerid from fact where customgroupid = @groupid) 
AND (active = 1 OR (active = 0 AND p.kept = 1)) AND CAST(p.DateCreated AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)

UNION ALL

--SIF PIF Payments made
SELECT 'pschedule' AS recordType  	
, m.id2 AS equabliAccountNumber
, m.id1 AS clientAccountNumber
, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'acc.0.equabliClientId') AS equabliClientId
, p.ArrangementID AS paymentPlanId
, ROW_NUMBER() OVER(PARTITION BY m.id2 ORDER BY p.deposit ASC) AS paymentSerial
, p.amount AS paymentAmount
, CASE WHEN p.approvedby = 'Payweb' THEN 'BI' WHEN p.pdc_type IN (6,7,8) THEN 'CK' ELSE 'BP' END AS paymentMethod
, FORMAT(deposit, 'yyyy-MM-dd') AS paymentDate
, CASE WHEN status IN ('SIF', 'PIF') THEN 'PD' ELSE 'UP' END AS paymentScheduleStatus
FROM master m WITH (NOLOCK) INNER JOIN payhistory p1 WITH (NOLOCK) ON m.number = p1.number INNER JOIN pdc p WITH (NOLOCK) ON p1.PostDateUID = P.UID
WHERE cast(p1.datepaid AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE) 
--AND active = 1 AND p.onhold IS NULL
AND m.customer IN (Select customerid from fact where customgroupid = @groupid) 
--AND (active = 1 OR (active = 0 AND printed = 1)) AND CAST(p.DateCreated AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
AND m.status IN ('SIF', 'PIF')

UNION ALL 

--Broken Post Dated Payments
SELECT 'pschedule' AS recordType  	
, m.id2 AS equabliAccountNumber
, m.id1 AS clientAccountNumber
, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'acc.0.equabliClientId') AS equabliClientId
, p.ArrangementID AS paymentPlanId
, ROW_NUMBER() OVER(PARTITION BY m.id2 ORDER BY p.deposit ASC) AS paymentSerial
, p.amount AS paymentAmount
, CASE WHEN p.approvedby = 'Payweb' THEN 'BI' WHEN p.pdc_type IN (6,7,8) THEN 'CK' ELSE 'BP' END AS paymentMethod
, FORMAT(deposit, 'yyyy-MM-dd') AS paymentDate
, CASE WHEN p.PaymentLinkUID IS NOT NULL AND isbatched = 1 THEN 'PD' WHEN printed = 0 AND active = 0 AND p.ProcessStatus IS NOT NULL AND p.IsBatched IS NULL THEN 'CL' ELSE 'UP' END AS paymentScheduleStatus
FROM master m WITH (NOLOCK) INNER JOIN (SELECT TOP 1 p.ArrangementID, p.number 
FROM pdc p WITH (NOLOCK) 
WHERE customer IN (Select customerid from fact where customgroupid = @groupid) 
AND CAST(p.DateCreated AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE) ORDER BY p.ArrangementID DESC) AS pdc ON m.number = pdc.number
INNER JOIN pdc p WITH (NOLOCK) ON m.number = P.number
WHERE pdc.ArrangementID = p.ArrangementID
AND m.customer IN (Select customerid from fact where customgroupid = @groupid) 
AND CAST(p.DateCreated AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
AND onhold IS NULL

END

GO
