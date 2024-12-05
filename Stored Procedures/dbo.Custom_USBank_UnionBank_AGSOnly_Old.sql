SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_UnionBank_AGSOnly_Old] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
DECLARE @startdate DATETIME
DECLARE @endDate DATETIME

SET @startDate = DATEADD(dd, 0, GETDATE())
SET @endDate = DATEADD(dd, 0, GETDATE())

SET @startDate = dbo.F_START_OF_DAY(@startDate)
SET @endDate = DATEADD(ss, -1, dbo.F_START_OF_DAY(DATEADD(dd, 1, @endDate)))

SELECT DISTINCT  id2 AS LocationCode, m.account AS Acctnumber, 'AGS' AS CDSID, CONVERT(VARCHAR(8), datecreated, 112) AS TransDate, 'Y' AS ProcessFlag,
'A' AS FunctionCode, 'SIMM      ' AS AgencyId,

--BALANCE AT SETTLEMENT added payhistory lookup for payments made prior to running of Trans Data File to match SIF Log
REPLACE(CONVERT(VARCHAR(14), m.current0), '.', '') + '0000' 
	AS BalAtSettle, 

--SETTLEMENT OFFERED --Removed date range, kept active post dates and added hold restriction
CASE WHEN m.STATUS = 'SIF' THEN REPLACE(CONVERT(VARCHAR(14), ABS(m.paid)), '.', '') + '0000'	
 ELSE (select top 1 REPLACE(CONVERT(VARCHAR(14), SUM(ISNULL(amount, 0)) + ISNULL((SELECT SUM(ISNULL(totalpaid, 0)) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate)), 0)
 ), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE m.number = number 
 --AND DateCreated BETWEEN @startDate AND @endDate 
AND active = 1 AND printed = 0 AND onhold IS NULL AND PromiseMode IN (6,7) 
 ) END AS SettlementOffered, 

--SETTLEMENT IN LIMIT --remvoed date range, kept active post date and added hold restriction
CASE WHEN m.STATUS = 'SIF' AND .20 /*((SELECT top 1 BlanketSif FROM customer WITH (NOLOCK) WHERE customer = m.customer) / 100)*/ < (ABS(m.paid) / dbo.NetOriginalRnd(m.number)) THEN 'Y'
WHEN  .20 /*((SELECT top 1 BlanketSif FROM customer WITH (NOLOCK) WHERE customer = m.customer) / 100)*/ < (select top 1 SUM(amount) / dbo.NetOriginalRnd(m.number) FROM pdc WITH (NOLOCK) WHERE number = p.number 
--AND DateCreated BETWEEN @startDate AND @endDate
AND active = 1 AND printed = 0 AND onhold IS NULL AND PromiseMode IN (6,7) 
) THEN 'Y' ELSE 'N' END AS SettlementInLimit, 

--AGENCY MANAGER APPROVAL --remvoed date range, kept active post date and added hold restriction
CASE WHEN DATEDIFF(MM, (select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number 
--AND DateCreated BETWEEN @startDate AND @endDate 
AND active = 1 AND printed = 0 AND onhold IS NULL AND PromiseMode IN (6,7) 
ORDER BY deposit ASC), (select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number 
--AND DateCreated BETWEEN @startDate AND @endDate 
AND active = 1 AND printed = 0 AND onhold IS NULL AND PromiseMode IN (6,7) 
ORDER BY deposit DESC)) > 18 THEN 'Y ' + (SELECT top 1 ISNULL(u.UserName, 'Not Available') FROM desk d WITH (NOLOCK) INNER JOIN Teams t WITH (NOLOCK) ON d.TeamID = t.ID INNER JOIN Users u WITH (NOLOCK) ON t.SupervisorID = u.ID
 WHERE d.code = p.desk) ELSE 'N' END AS AgencyMGRExcpApprove, 

--SETTLEMENT NEEDS USB APPROVAL
CASE WHEN DATEDIFF(MM, (select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number 
--AND DateCreated BETWEEN @startDate AND @endDate  
AND active = 1 AND printed = 0 AND onhold IS NULL AND PromiseMode IN (6,7) 
ORDER BY deposit ASC), (select TOP 1 CONVERT(VARCHAR(8), deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number 
--AND DateCreated BETWEEN @startDate AND @endDate 
AND active = 1 AND printed = 0 AND onhold IS NULL AND PromiseMode IN (6,7) 
ORDER BY deposit DESC)) > 18 AND (SELECT top 1 result FROM notes WITH (NOLOCK) WHERE number = m.number 
--AND created BETWEEN @startdate AND @enddate 
AND action = 'CO' AND result = 'APPRV') = 'APPRV' THEN 'Y ' + 'USB Manager' ELSE 'N' END AS StlmtNeedsUSBApprov, 

--SETTLEMENT START DATE
(SELECT CONVERT(VARCHAR(8), GETDATE(), 112)) AS SettlementStartDate, 
--(select TOP 1 CONVERT(VARCHAR(8), entered, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number AND DateCreated BETWEEN @startDate AND @endDate ORDER BY deposit ASC) AS SettlementStartDate, 

--NUMBER OF PAYMENTS
--(select top 1 CONVERT(VARCHAR(13), COUNT(*)) FROM pdc WITH (NOLOCK) WHERE number = p.number AND (DateCreated BETWEEN @startDate AND @endDate)) AS NumofPayments, 
(select top 1 COUNT(*) FROM pdc pdc WITH (NOLOCK) WHERE pdc.number = m.number 
--AND DateCreated BETWEEN @startDate AND @endDate 
AND active = 1 AND printed = 0 AND onhold IS NULL AND PromiseMode IN (6,7) 
--AND Active = 1 AND printed = 0
) AS NumofPayments, 

--PROJECTED END DATE
dbo.fnGetEndDatePDCUSB(p.number, p.entered, p.entered) AS ProjEndDate,
--(select top 1 CONVERT(VARCHAR(10), p.deposit, 112) FROM pdc WITH (NOLOCK) WHERE number = p.number 
----AND DateCreated BETWEEN @startDate AND @endDate 
--AND active = 1 AND printed = 0 AND onhold IS NULL AND PromiseMode IN (6,7) 
----AND Active = 1 AND printed = 0
--ORDER BY deposit DESC
--) AS ProjEndDate,

--DATE SETTLEMENT TAKEN
CONVERT(VARCHAR(8), '20230705', 112) AS DateSettlementTaken,

--SETTLEMNT PERCENT OF BALANCE PDC
LEFT(CONVERT(VARCHAR(14), 
REPLACE( 
ROUND( 
CAST( 
(CASE WHEN m.STATUS = 'SIF' THEN ABS(m.paid)	
 ELSE (select top 1 SUM(ISNULL(amount, 0)) + ISNULL((SELECT SUM(ISNULL(totalpaid, 0)) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate)), 0)
 FROM pdc WITH (NOLOCK) WHERE m.number = number 
 --AND DateCreated BETWEEN @startDate AND @endDate 
AND active = 1 AND printed = 0 AND onhold IS NULL AND PromiseMode IN (6,7) 
 ) END) 
 AS DECIMAL (9,3))
 / 
CAST(
(CASE WHEN m.STATUS = 'SIF' THEN m.current0 + m.lastpaidamt
	WHEN m.STATUS <> 'SIF' AND m.lastpaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate) THEN m.current0 + 
	(SELECT SUM(totalpaid) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate)) 
	ELSE m.current0 END) 
AS DECIMAL (9,3))
, 4)  * 100
, '.', '')
)
, 8)
AS SettlementPercOfBalance,

--AMOUNT FORGIVEN
CASE WHEN m.STATUS = 'SIF' THEN REPLACE(CONVERT(VARCHAR(14), dbo.NetOriginalRnd(m.number) - lastpaidamt), '.', '') + '0000'
	ELSE REPLACE(CONVERT(VARCHAR(14), (SELECT top 1 m.current0 - SUM(amount) FROM pdc WITH (NOLOCK) WHERE number = p.number 
	--AND (DateCreated BETWEEN @startDate AND @endDate ) 
AND active = 1 AND printed = 0 AND onhold IS NULL AND PromiseMode IN (6,7) 
	)), '.', '') + '0000' END AS AmountForgiven, 

--SETTLEMENT NEW, UPDATE, PRO
	--SETTLNEW - New Settlement 
			-- Created date in date range, and does not exist in history table
	--SETTLPRO - Settlement Promise Data Update.  Promise date or amount is being changed, 
	-- but total settlement amount and expiration date will remain the same.
			--Created date in date range, and exists in history table but Settlement amount and Projected End Date are same.
	--SETTLUPD - Updated Settlement.  Promise end date or SIF offer amount is being changed
	
--Created date in date range and exists in history table and Settlement amount or Projected End Date are different.
--CASE WHEN m.account NOT IN (SELECT account FROM dbo.Custom_USBank_CACS_SIF_History WITH (NOLOCK) WHERE account = m.account AND DateAdded > @endDate) THEN 'SETTLNEW' 
--	WHEN m.account IN (SELECT account FROM dbo.Custom_USBank_CACS_SIF_History cubcsh WITH (NOLOCK) WHERE account = m.account AND DateAdded > @endDate) AND dbo.fnGetEndDatePDCUSB(p.number, p.entered, p.entered)
--		= (SELECT TOP 1  projectedenddate FROM dbo.Custom_USBank_CACS_SIF_History cubcsh WITH (NOLOCK) WHERE Account = m.account AND DateAdded > @endDate ORDER BY DateAdded DESC)
--		AND CASE WHEN m.STATUS = 'SIF' THEN REPLACE(CONVERT(VARCHAR(14), ABS(m.paid)), '.', '') + '0000'	
-- ELSE (select top 1 SUM(ISNULL(amount, 0)) + ISNULL((SELECT SUM(ISNULL(totalpaid, 0)) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate)), 0)
-- FROM pdc WITH (NOLOCK) WHERE m.number = number AND DateCreated BETWEEN @startDate AND @endDate AND active = 1 AND printed = 0) END
--	= (SELECT TOP 1 settlementamount FROM dbo.Custom_USBank_CACS_SIF_History WITH (NOLOCK) WHERE Account = m.account AND DateAdded < @endDate ORDER BY DateAdded DESC) THEN 'SETTLPRO' ELSE 'SETTLUPD' END AS SettlementUpdate,
'SETTLNEW' AS SettlementUpdate,

--SSN VERIFIED
CASE WHEN m.ssn <> '' THEN 'Y' ELSE 'N' END AS SSNVerified, 
--ADDRESS VERIFIED
CASE WHEN (SELECT top 1 MR FROM debtors  WITH (NOLOCK) WHERE Number = m.number AND seq = 0) = 'Y' THEN 'N' ELSE 'Y' END AS AddressVerified, 
'Settlement Offered' AS SettlementNotes,
--INSTALLMENT INFORMATION
'+' AS DelqSign,

ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0  ORDER BY deposit ASC), '') AS Installment1Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0  ORDER BY deposit ASC), 0) AS Installment1Amt, 
ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0  AND uid NOT IN (SELECT TOP 1 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0  ORDER BY deposit ASC)), '') AS Installment2Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0  AND uid NOT IN (SELECT TOP 1 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0  ORDER BY deposit ASC)), '0') AS Installment2Amt, 
ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0  AND uid NOT IN (SELECT TOP 2 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0  ORDER BY deposit ASC)), '') AS Installment3Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0  AND uid NOT IN (SELECT TOP 2 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0   ORDER BY deposit ASC)), '0') AS Installment3Amt, 
ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 3 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0  ORDER BY deposit ASC)), '') AS Installment4Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 3 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '0') AS Installment4Amt, 
ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 4 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0  ORDER BY deposit ASC)), '') AS Installment5Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 4 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '0') AS Installment5Amt, 
ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 5 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0  ORDER BY deposit ASC)), '') AS Installment6Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 5 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '0') AS Installment6Amt, 
ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 6 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0  ORDER BY deposit ASC)), '') AS Installment7Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 6 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '0') AS Installment7Amt, 
ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 7 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '') AS Installment8Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0AND uid NOT IN (SELECT TOP 7 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '0') AS Installment8Amt, 
ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 8 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '') AS Installment9Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 8 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '0') AS Installment9Amt, 
ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 9 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '') AS Installment10Date,
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 9 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '0') AS Installment10Amt, 
ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 10 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '') AS Installment11Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 10 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '0') AS Installment11Amt, 
ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 11 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '') AS Installment12Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 11 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0  ORDER BY deposit ASC)), '0') AS Installment12Amt, 
ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 12 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '') AS Installment13Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 12 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '0') AS Installment13Amt, 
ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 13 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '') AS Installment14Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 13 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '0') AS Installment14Amt, 
ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 14 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '') AS Installment15Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 14 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '0') AS Installment15Amt, 
ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 15 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '') AS Installment16Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 15 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '0') AS Installment16Amt, 
ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 16 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '') AS Installment17Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 16 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '0') AS Installment17Amt, 
ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 17 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '') AS Installment18Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 17 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '0') AS Installment18Amt, 
ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 18 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '') AS Installment19Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 18 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '0') AS Installment19Amt, 
ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 19 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '') AS Installment20Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 19 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '0') AS Installment20Amt, 
ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 20 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '') AS Installment21Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 20 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '0') AS Installment21Amt, 
ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 21 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '') AS Installment22Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 21 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '0') AS Installment22Amt, 
ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 22 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '') AS Installment23Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 22 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '0') AS Installment23Amt, 
ISNULL((select TOP 1 CASE WHEN UID = dbo.fnGetEndUIDPDCUSB(p.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, deposit), 112) ELSE CONVERT(VARCHAR(8), deposit, 112) END FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 23 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '') AS Installment24Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 AND uid NOT IN (SELECT TOP 23 UID  FROM pdc WITH (NOLOCK) WHERE number = p.number AND PromiseMode IN (6,7) 
AND onhold IS NULL AND Active = 1 AND printed = 0 ORDER BY deposit ASC)), '0') AS Installment24Amt,
'' AS Filler
from master m WITH (NOLOCK) INNER JOIN pdc p WITH (NOLOCK) ON m.number = p.number
WHERE m.customer IN (2569, 2570, 2571, 3089)
--AND p.entered BETWEEN @startDate AND @endDate
AND p.PromiseMode IN (6,7) 
AND p.onhold IS NULL
AND (p.Active = 1 OR (p.Active = 0 AND m.status = 'sif'))
AND (closed IS NULL OR closed > '20230704')

UNION ALL

SELECT DISTINCT   id2 AS LocationCode, m.account AS Acctnumber, 'AGS' AS CDSID, CONVERT(VARCHAR(8), datecreated, 112) AS TransDate, 'Y' AS ProcessFlag,
'A' AS FunctionCode, 'SIMM      ' AS AgencyId, 

--BALANCE AT SETTLEMENT
REPLACE(CONVERT(VARCHAR(14), m.current0), '.', '') + '0000' 
	AS BalAtSettle,

--SETTLEMENT OFFERED
CASE WHEN m.STATUS = 'SIF' THEN REPLACE(CONVERT(VARCHAR(14), ABS(m.paid)), '.', '') + '0000' ELSE 
(select top 1 REPLACE(CONVERT(VARCHAR(14), SUM(ISNULL(amount, 0)) + ISNULL((SELECT SUM(ISNULL(totalpaid, 0)) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate)), 0)
--ABS(m.paid)
), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number 
--AND (DateCreated BETWEEN @startDate AND @endDate ) 
AND IsActive = 1 AND Printed IN ('0', 'N') AND onholddate IS NULL AND PromiseMode IN (6,7) 
) END AS SettlementOffered, 


--SETTLEMENT IN LIMIT
CASE WHEN m.STATUS = 'SIF' AND .20 /*((SELECT top 1 BlanketSif FROM customer WITH (NOLOCK) WHERE customer = m.customer) / 100)*/ < (ABS(m.paid) / dbo.NetOriginalRnd(m.number)) THEN 'Y'
WHEN  .20 /*((SELECT top 1 BlanketSif FROM customer WITH (NOLOCK) WHERE customer = m.customer) / 100)*/ < (select top 1 SUM(amount) / dbo.NetOriginalRnd(m.number) FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number 
--AND (DateCreated BETWEEN @startDate AND @endDate )
AND IsActive = 1 AND Printed IN ('0', 'N') AND onholddate IS NULL AND PromiseMode IN (6,7) 
) THEN 'Y' ELSE 'N' END AS SettlementInLimit, 

--AGENCY MANAGER APPROVAL
CASE WHEN DATEDIFF(MM, (select TOP 1 CONVERT(VARCHAR(8), DepositDate, 112) FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number 
--AND (DateCreated BETWEEN @startDate AND @endDate ) 
AND IsActive = 1 AND Printed IN ('0', 'N') AND onholddate IS NULL AND PromiseMode IN (6,7) 
ORDER BY DepositDate ASC), (select TOP 1 CONVERT(VARCHAR(8), DepositDate, 112) FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number 
--AND (DateCreated BETWEEN @startDate AND @endDate ) 
AND IsActive = 1 AND Printed IN ('0', 'N') AND onholddate IS NULL AND PromiseMode IN (6,7) 
ORDER BY DepositDate DESC)) > 18 THEN 'Y ' + (SELECT top 1 ISNULL(u.UserName, 'Not Available') FROM desk d WITH (NOLOCK) INNER JOIN Teams t WITH (NOLOCK) ON d.TeamID = t.ID INNER JOIN Users u WITH (NOLOCK) ON t.SupervisorID = u.ID
 WHERE d.code = m.desk) ELSE 'N' END AS AgencyMGRExcpApprove, 

--SETTLEMENT NEEDS USB APPROVAL
CASE WHEN DATEDIFF(MM, (select TOP 1 CONVERT(VARCHAR(8), DepositDate, 112) FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number 
--AND (DateCreated BETWEEN @startDate AND @endDate ) 
AND IsActive = 1 AND Printed IN ('0', 'N') AND onholddate IS NULL AND PromiseMode IN (6,7) 
ORDER BY DepositDate ASC), (select TOP 1 CONVERT(VARCHAR(8), DepositDate, 112) FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number 
--AND (DateCreated BETWEEN @startDate AND @endDate ) 
AND IsActive = 1 AND Printed IN ('0', 'N') AND onholddate IS NULL AND PromiseMode IN (6,7) 
ORDER BY DepositDate DESC)) > 18 AND (SELECT top 1 result FROM notes WITH (NOLOCK) WHERE number = m.number 
--AND created BETWEEN @startdate AND @enddate 
AND action = 'CO' AND result = 'APPRV') = 'APPRV' THEN 'Y ' + 'USB Manager' ELSE 'N' END AS StlmtNeedsUSBApprov, 

--SETTLEMENT START DATE
(SELECT CONVERT(VARCHAR(8), GETDATE(), 112)) AS SettlementStartDate, 

--(select TOP 1 CONVERT(VARCHAR(8), DateEntered, 112) FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number 
----AND (DateCreated BETWEEN @startDate AND @endDate ) 
--AND IsActive = 1 AND Printed IN ('0', 'N') AND onholddate IS NULL AND PromiseMode IN (6,7) 
--ORDER BY DepositDate ASC) AS SettlementStartDate,

--NUMBER OF PAYMENTS
--(select top 1 CONVERT(VARCHAR(13), COUNT(*)) FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND (DateCreated BETWEEN @startDate AND @endDate )) AS NumofPayments, 
(select top 1 CONVERT(VARCHAR(13), COUNT(*)) FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number 
--AND DateCreated BETWEEN @startDate AND @endDate 
AND IsActive = 1 AND Printed IN ('0', 'N') AND onholddate IS NULL AND PromiseMode IN (6,7) 
) AS NumofPayments, 

--PROJECTED END DATE
dbo.fnGetEndDatePCCUSB(p.number, P.dateentered, P.dateentered) AS ProjEndDate,

--DATE SETTLEMENT TAKEN
CONVERT(VARCHAR(8), GETDATE(), 112) AS DateSettlementTaken,

--SETTLEMNT PERCENT OF BALANCE PCC
LEFT(CONVERT(VARCHAR(14), 
REPLACE( 
ROUND( 
CAST( 
(CASE WHEN m.STATUS = 'SIF' THEN ABS(m.paid)	
 ELSE (select top 1 SUM(ISNULL(amount, 0)) + ISNULL((SELECT SUM(ISNULL(totalpaid, 0)) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate)), 0)
 FROM DebtorCreditCards WITH (NOLOCK) WHERE m.number = Number 
 --AND DateCreated BETWEEN @startDate AND @endDate 
AND IsActive = 1 AND Printed IN ('0', 'N') AND onholddate IS NULL AND PromiseMode IN (6,7) 
) END) 
 AS DECIMAL (9,3))
 / 
CAST(
(CASE WHEN m.STATUS = 'SIF' THEN m.current0 + ABS(m.paid)
	WHEN m.STATUS <> 'SIF' AND m.lastpaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate) THEN m.current0 + 
	(SELECT SUM(totalpaid) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate)) 
	ELSE m.current0 END) 
AS DECIMAL (9,3))
, 4)  * 100
, '.', '')
)
, 8)
 AS SettlementPercOfBalance, 

--AMOUNT FORGIVEN
CASE WHEN m.STATUS = 'SIF' THEN REPLACE(CONVERT(VARCHAR(14), dbo.NetOriginalRnd(m.number) - ABS(m.paid)), '.', '') + '0000'
--WHEN m.STATUS <> 'SIF' AND m.lastpaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate) THEN REPLACE(CONVERT(VARCHAR(14), dbo.NetOriginalRnd(m.number) - 
--	(SELECT SUM(totalpaid) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate))), '.', '') 
ELSE REPLACE(CONVERT(VARCHAR(14), (SELECT top 1 dbo.NetOriginalRnd(m.number) - (SUM(amount) + ABS(m.paid)) FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number 
--AND (DateCreated BETWEEN @startDate AND @endDate ) 
AND IsActive = 1 AND Printed IN ('0', 'N') AND onholddate IS NULL AND PromiseMode IN (6,7) 
)), '.', '') + '0000' END AS AmountForgiven, 

--SETTLEMENT NEW, UPDATE, PRO
--CASE WHEN m.account NOT IN (SELECT account FROM dbo.Custom_USBank_CACS_SIF_History WITH (NOLOCK) WHERE account = m.account AND DateAdded > @endDate) THEN 'SETTLNEW' 
--	WHEN m.account IN (SELECT account FROM dbo.Custom_USBank_CACS_SIF_History cubcsh WITH (NOLOCK) WHERE account = m.account AND DateAdded > @endDate) AND dbo.fnGetEndDatePCCUSB(p.number, p.dateentered, p.dateentered)
--		= (SELECT TOP 1 projectedenddate FROM dbo.Custom_USBank_CACS_SIF_History cubcsh WITH (NOLOCK) WHERE Account = m.account AND DateAdded > @endDate ORDER BY DateAdded DESC)
--		AND CASE WHEN m.STATUS = 'SIF' THEN REPLACE(CONVERT(VARCHAR(14), ABS(m.paid)), '.', '') + '0000'	
-- ELSE (select top 1 SUM(ISNULL(amount, 0)) + ISNULL((SELECT SUM(ISNULL(totalpaid, 0)) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate)), 0)
-- FROM dbo.DebtorCreditCards WITH (NOLOCK) WHERE m.number = number AND DateCreated BETWEEN @startDate AND @endDate AND IsActive = 1 AND Printed = 'N') END
--	= (SELECT TOP 1 settlementamount FROM dbo.Custom_USBank_CACS_SIF_History WITH (NOLOCK) WHERE Account = m.account AND DateAdded < @endDate ORDER BY DateAdded DESC) THEN 'SETTLPRO' ELSE 'SETTLUPD' END AS SettlementUpdate,
'SETTLNEW' AS SettlementUpdate,

--SSN VERIFIED
CASE WHEN m.ssn <> '' THEN 'Y' ELSE 'N' END AS SSNVerified, 
--ADDRESS VERIFIED
CASE WHEN (SELECT top 1 MR FROM debtors  WITH (NOLOCK) WHERE Number = m.number AND seq = 0) = 'Y' THEN 'N' ELSE 'Y' END AS AddressVerified, 
'Settlement Offered' AS SettlementNotes,
--INSTALLMENT INFORMATION
'+' AS DelqSign,

--Set first installment 2 days into future if due date is same date as file header date
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, p.dateentered, p.dateentered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N') ORDER BY DepositDate ASC), '') AS Installment1Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC), 0) AS Installment1Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, p.dateentered, p.dateentered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 1 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment2Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 1 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment2Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, p.dateentered, p.dateentered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 2 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment3Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 2 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment3Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, p.dateentered, p.dateentered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 3 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment4Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 3 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment4Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, p.dateentered, p.dateentered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 4 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment5Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 4 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment5Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, p.dateentered, p.dateentered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 5 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment6Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 5 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment6Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, p.dateentered, p.dateentered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 6 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment7Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 6 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment7Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, p.dateentered, p.dateentered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 7 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment8Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 7 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment8Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, p.dateentered, p.dateentered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 8 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment9Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 8 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment9Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, p.dateentered, p.dateentered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 9 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment10Date,
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 9 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment10Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, p.dateentered, p.dateentered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 10 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment11Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 10 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment11Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, p.dateentered, p.dateentered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 11 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment12Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 11 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment12Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, p.dateentered, p.dateentered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 12 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment13Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 12 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment13Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, p.dateentered, p.dateentered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 13 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment14Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 13 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment14Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, p.dateentered, p.dateentered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 14 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment15Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 14 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment15Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, p.dateentered, p.dateentered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 15 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment16Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 15 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment16Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, p.dateentered, p.dateentered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 16 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment17Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 16 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment17Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, p.dateentered, p.dateentered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 17 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment18Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 17 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment18Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, p.dateentered, p.dateentered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 18 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment19Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 18 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment19Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, p.dateentered, p.dateentered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 19 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment20Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 19 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment20Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, p.dateentered, p.dateentered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 20 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment21Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 20 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment21Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, p.dateentered, p.dateentered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 21 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment22Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 21 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment22Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, p.dateentered, p.dateentered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 22 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment23Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 22 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment23Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPCCUSB(p.number, p.dateentered, p.dateentered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DepositDate), 112) ELSE CONVERT(VARCHAR(8), DepositDate, 112) END FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 23 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '') AS Installment24Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 23 ID  FROM DebtorCreditCards WITH (NOLOCK) WHERE number = p.number AND OnHoldDate IS NULL AND isActive = 1 AND PromiseMode IN (6,7) AND Printed IN ('0', 'N')
AND OnHoldDate IS NULL AND (isActive = 1 OR (isActive = 0 AND m.status = 'sif'))  ORDER BY DepositDate ASC)), '0') AS Installment24Amt,
'' AS Filler
from master m WITH (NOLOCK) INNER JOIN DebtorCreditCards p WITH (NOLOCK) ON m.number = p.number
WHERE m.customer IN (2569, 2570, 2571, 3089)
--AND p.entered BETWEEN @startDate AND @endDate
AND p.PromiseMode IN (6,7) 
AND p.onholddate IS NULL
AND (p.IsActive = 1 OR (p.IsActive = 0 AND m.status = 'sif'))
AND (closed IS NULL OR closed > '20230704')

UNION ALL

SELECT DISTINCT   
id2 AS LocationCode, 
m.account AS Acctnumber, 
'AGS' AS CDSID, 
CONVERT(VARCHAR(8), datecreated, 112) AS TransDate, 
'Y' AS ProcessFlag,
'A' AS FunctionCode, 
'SIMM      ' AS AgencyId, 

--BALANCE AT SETTLEMENT
REPLACE(CONVERT(VARCHAR(14), m.current0), '.', '') + '0000' 
	AS BalAtSettle,

--SETTLEMENT OFFERED
CASE WHEN m.STATUS = 'SIF' THEN REPLACE(CONVERT(VARCHAR(14), ABS(m.paid)), '.', '') + '0000' ELSE 
(select top 1 REPLACE(CONVERT(VARCHAR(14), SUM(amount) + ISNULL((SELECT SUM(totalpaid) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate)), 0)
), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid 
--AND (Entered BETWEEN @startDate AND @endDate ) 
AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
) END AS SettlementOffered, 

--SETTLEMENT IN LIMIT
CASE WHEN m.STATUS = 'SIF' AND .20 /* ((SELECT top 1 BlanketSif FROM customer WITH (NOLOCK) WHERE customer = m.customer) / 100)*/ < (ABS(m.paid) / dbo.NetOriginalRnd(m.number)) THEN 'Y'
WHEN .20 /*((SELECT top 1 BlanketSif FROM customer WITH (NOLOCK) WHERE customer = m.customer) / 100)*/ < (select top 1 SUM(amount) / dbo.NetOriginalRnd(m.number) FROM Promises WITH (NOLOCK) WHERE m.number = acctid 
--AND (Entered BETWEEN @startDate AND @endDate )
AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
) THEN 'Y' ELSE 'N' END AS SettlementInLimit, 

--AGENCY MANAGER APPROVAL
CASE WHEN DATEDIFF(MM, (select TOP 1 CONVERT(VARCHAR(8), DueDate, 112) FROM Promises WITH (NOLOCK) WHERE m.number = acctid 
--AND (Entered BETWEEN @startDate AND @endDate ) 
AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
ORDER BY DueDate ASC), (select TOP 1 CONVERT(VARCHAR(8), DueDate, 112) FROM Promises WITH (NOLOCK) WHERE m.number = acctid 
--AND (Entered BETWEEN @startDate AND @endDate ) 
AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
ORDER BY DueDate DESC)) > 18 THEN 'Y ' + (SELECT top 1 ISNULL(u.UserName, 'Not Available') FROM desk d WITH (NOLOCK) INNER JOIN Teams t WITH (NOLOCK) ON d.TeamID = t.ID INNER JOIN Users u WITH (NOLOCK) ON t.SupervisorID = u.ID
 WHERE d.code = m.desk) ELSE 'N' END AS AgencyMGRExcpApprove, 
--SETTLEMENT NEEDS USB APPROVAL
CASE WHEN DATEDIFF(MM, (select TOP 1 CONVERT(VARCHAR(8), DueDate, 112) FROM Promises WITH (NOLOCK) WHERE m.number = acctid 
--AND (Entered BETWEEN @startDate AND @endDate ) 
AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
ORDER BY DueDate ASC), (select TOP 1 CONVERT(VARCHAR(8), DueDate, 112) FROM Promises WITH (NOLOCK) WHERE m.number = acctid 
--AND (Entered BETWEEN @startDate AND @endDate )
AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
ORDER BY DueDate DESC)) > 18 AND (SELECT top 1 result FROM notes WITH (NOLOCK) WHERE number = m.number 
--AND created BETWEEN @startdate AND @enddate 
AND action = 'CO' AND result = 'APPRV') = 'APPRV' THEN 'Y ' + 'USB Manager' ELSE 'N' END AS StlmtNeedsUSBApprov, 

--SETTLEMENT START DATE
(select TOP 1 CONVERT(VARCHAR(8), Entered, 112) FROM Promises WITH (NOLOCK) WHERE m.number = acctid 
--AND (Entered BETWEEN @startDate AND @endDate ) 
AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
ORDER BY DueDate ASC) AS SettlementStartDate, 

--NUMBER OF PAYMENTS
--(select top 1 CONVERT(VARCHAR(13), COUNT(*)) FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND (Entered BETWEEN @startDate AND @endDate ) ) AS NumofPayments, 
(select top 1 CONVERT(VARCHAR(13), COUNT(*)) FROM Promises WITH (NOLOCK) WHERE m.number = acctid 
--AND Entered BETWEEN @startDate AND @endDate 
AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
--AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))
) AS NumofPayments, 

--PROJECTED END DATE
dbo.fnGetEndDatePromisesUSB(m.number, p.entered, p.entered) AS ProjEndDate, 


--DATE SETTLEMENT TAKEN
CONVERT(VARCHAR(8), GETDATE(), 112) AS DateSettlementTaken,

--SETTLEMNT PERCENT OF BALANCE PPA
LEFT(CONVERT(VARCHAR(14), 
REPLACE( 
ROUND( 
CAST( 
(CASE WHEN m.STATUS = 'SIF' THEN ABS(m.paid)	
 ELSE (select top 1 SUM(ISNULL(amount, 0)) + ISNULL((SELECT SUM(ISNULL(totalpaid, 0)) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate)), 0)
 FROM Promises WITH (NOLOCK) WHERE m.number = AcctID 
 --AND DateCreated BETWEEN @startDate AND @endDate
AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
 ) END) 
 AS DECIMAL (9,3))
 / 
CAST(
(CASE WHEN m.STATUS = 'SIF' THEN m.current0 + ABS(m.paid)
	WHEN m.STATUS <> 'SIF' AND m.lastpaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate) THEN m.current0 + 
	(SELECT SUM(totalpaid) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate)) 
	ELSE m.current0 END) 
AS DECIMAL (9,3))
, 4)  * 100
, '.', '')
)
, 8)
AS SettlementPercOfBalance, 

--AMOUNT FORGIVEN
CASE WHEN m.STATUS = 'SIF' THEN REPLACE(CONVERT(VARCHAR(14), dbo.NetOriginalRnd(m.number) - ABS(m.paid)), '.', '') + '0000'
--WHEN m.STATUS <> 'SIF' AND m.lastpaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate) THEN REPLACE(CONVERT(VARCHAR(14), dbo.NetOriginalRnd(m.number) - 
--	(SELECT SUM(totalpaid) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate))), '.', '') + '0000'
ELSE REPLACE(CONVERT(VARCHAR(14), (SELECT top 1 dbo.NetOriginalRnd(m.number) - (SUM(amount) + ABS(m.paid)) FROM Promises WITH (NOLOCK) WHERE m.number = acctid 
--AND (DateCreated BETWEEN @startDate AND @endDate ) 
AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
)), '.', '') + '0000' END AS AmountForgiven, 

--SETTLEMENT NEW, UPDATE, PRO
--CASE WHEN m.account NOT IN (SELECT account FROM dbo.Custom_USBank_CACS_SIF_History WITH (NOLOCK) WHERE account = m.account AND DateAdded > @endDate	) THEN 'SETTLNEW' 
--	WHEN m.account IN (SELECT account FROM dbo.Custom_USBank_CACS_SIF_History cubcsh WITH (NOLOCK) WHERE account = m.account AND DateAdded > @endDate) AND dbo.fnGetEndDatePromisesUSB(m.number, p.entered, p.entered)
--		= (SELECT TOP 1 projectedenddate FROM dbo.Custom_USBank_CACS_SIF_History cubcsh WITH (NOLOCK) WHERE Account = m.account AND DateAdded > @endDate ORDER BY DateAdded DESC)
--		AND CASE WHEN m.STATUS = 'SIF' THEN REPLACE(CONVERT(VARCHAR(14), ABS(m.paid)), '.', '') + '0000'	
-- ELSE (select top 1 SUM(ISNULL(amount, 0)) + ISNULL((SELECT SUM(ISNULL(totalpaid, 0)) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype IN ('PU', 'PC') AND datepaid BETWEEN @startDate AND DATEADD(dd, 1, @endDate)), 0)
-- FROM dbo.Promises WITH (NOLOCK) WHERE m.number = AcctID AND DateCreated BETWEEN @startDate AND @endDate AND Active = 1) END
--	= (SELECT TOP 1 settlementamount FROM dbo.Custom_USBank_CACS_SIF_History WITH (NOLOCK) WHERE Account = m.account AND DateAdded < @endDate ORDER BY DateAdded DESC) THEN 'SETTLPRO' ELSE 'SETTLUPD' END AS SettlementUpdate,
'SETTLNEW'	AS SettlementUpdate,

--SSN VERIFIED
CASE WHEN m.ssn <> '' THEN 'Y' ELSE 'N' END AS SSNVerified, 
--ADDRESS VERIFIED
CASE WHEN (SELECT top 1 MR FROM debtors  WITH (NOLOCK) WHERE number = m.number AND seq = 0) = 'Y' THEN 'N' ELSE 'Y' END AS AddressVerified, 
'Settlement Offered' AS SettlementNotes,
--INSTALLMENT INFORMATION
'+' AS DelqSign,

ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY DueDate ASC), '') AS Installment1Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) ORDER BY DueDate ASC), 0) AS Installment1Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 1 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment2Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 1 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment2Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 2 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment3Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 2 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment3Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 3 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment4Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 3 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment4Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 4 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment5Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 4 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment5Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 5 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment6Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 5 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment6Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 6 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment7Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 6 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment7Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 7 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment8Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 7 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment8Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 8 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment9Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 8 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment9Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 9 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment10Date,
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 9 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment10Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 10 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment11Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 10 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment11Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 11 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment12Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 11 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment12Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 12 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment13Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 12 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment13Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 13 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment14Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 13 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment14Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 14 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment15Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 14 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment15Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 15 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment16Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 15 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment16Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 16 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment17Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 16 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment17Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 17 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment18Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 17 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment18Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 18 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment19Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 18 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment19Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 19 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment20Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 19 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment20Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 20 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment21Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 20 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment21Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 21 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment22Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 21 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment22Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 22 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment23Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 22 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment23Amt, 
ISNULL((select TOP 1 CASE WHEN ID = dbo.fnGetEndUIDPromisesUSB(m.number, p.entered, p.entered) THEN CONVERT(VARCHAR(8), DATEADD(dd, 5, DueDate), 112) ELSE CONVERT(VARCHAR(8), DueDate, 112) END FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 23 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '') AS Installment24Date, 
ISNULL((select TOP 1 REPLACE(CONVERT(VARCHAR(14), amount), '.', '') + '0000' FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif')) AND ID NOT IN (SELECT TOP 23 ID  FROM Promises WITH (NOLOCK) WHERE m.number = acctid AND PromiseMode IN (6,7) AND (Suspended = 0 OR Suspended IS NULL) AND Active = 1
AND (Suspended = 0 OR Suspended IS NULL) AND (Active = 1 OR (Active = 0 AND m.status = 'sif'))  ORDER BY DueDate ASC)), '0') AS Installment24Amt,
'' AS Filler
from master m WITH (NOLOCK) INNER JOIN Promises p WITH (NOLOCK) ON m.number = p.acctid
WHERE m.customer IN (2569, 2570, 2571, 3089)
AND p.PromiseMode IN (6,7) 
AND (p.Suspended = 0 OR p.Suspended IS NULL)
AND (p.Active = 1 OR (p.Active = 0 AND m.status = 'sif'))
AND (closed IS NULL OR closed > '20230704')END
GO
