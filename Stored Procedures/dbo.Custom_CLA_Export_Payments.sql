SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 9/4/2019
-- Description:	Export Placement Acknowledgement File
-- =============================================
CREATE PROCEDURE [dbo].[Custom_CLA_Export_Payments]
	-- Add the parameters for the stored procedure here
	@invoice varchar(8000),
	@startDate DATETIME,
	@endDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT (SELECT customtext1 FROM customer WITH (NOLOCK) WHERE customer = m.customer) AS AgencyCode,
m.id2 AS PlacementID,
(SELECT TOP 1 REPLACE(thedata, '-', '/') FROM MiscExtra WITH (NOLOCK) WHERE Number = m.number AND title = 'pla.0.DatePlaced') AS PlaceDate,
m.id1 AS AccountNumber, 
m.account AS OriginalAccount, 
CASE WHEN batchtype = 'PU' THEN 'PMT' WHEN batchtype = 'PUR' AND IsCorrection = 0 THEN 'RET' WHEN batchtype = 'PUR' AND IsCorrection = 1 THEN 'ERR' ELSE 'MC' END AS TransCode,
CONVERT(VARCHAR(10), ph.datepaid, 101) AS TransDate, 
CASE WHEN batchtype LIKE '%r' THEN -(ph.totalpaid) ELSE ph.totalpaid END AS TransAmt, 
CASE ph.paymethod WHEN 'CASH' THEN '7' WHEN 'CHECK' THEN '1' WHEN 'PAPER DRAFT' THEN '1' WHEN 'MONEY ORDER' THEN '2' WHEN 'WESTERN UNION' THEN '4'
	WHEN 'CREDIT CARD' THEN '3' WHEN 'ACH DEBIT' THEN '21' WHEN 'POST-DATED CHECK' THEN '5' WHEN 'BANK WIRE' THEN '6' WHEN 'SAVINGS ACH' THEN '21'
	WHEN 'MONEY GRAM' THEN '2' ELSE '21' END AS PayTypeID,
'2' AS TransSource, 
CASE WHEN batchtype LIKE '%r' THEN -(ph.CollectorFee) ELSE ph.collectorfee END AS CollectorCommission, 
CASE WHEN batchtype = 'PU' THEN 'Y' WHEN batchtype = 'PUR' AND IsCorrection = 0 THEN 'Y' WHEN batchtype = 'PUR' AND IsCorrection = 1 THEN 'Y' ELSE 'N' END AS DueAgency
FROM payhistory ph WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON ph.number = m.number
WHERE m.customer = '0001101' AND batchtype LIKE 'PU%'
AND ph.Invoice IN (select string from dbo.CustomStringToSet(@invoice, '|'))

UNION ALL

	SELECT (SELECT customtext1 FROM customer WITH (NOLOCK) WHERE customer = m.customer) AS AgencyCode,
m.id2 AS PlacementID,
(SELECT TOP 1 REPLACE(thedata, '-', '/') FROM MiscExtra WITH (NOLOCK) WHERE Number = m.number AND title = 'pla.0.DatePlaced') AS PlaceDate,
m.id1 AS AccountNumber, 
m.account AS OriginalAccount, 
'MC' AS TransCode,
CONVERT(VARCHAR(10), GETDATE(), 101) AS TransDate, 
m.current0 AS TransAmt, 
'27' AS PayTypeID,
'2' AS TransSource, 
0 AS CollectorCommission, 
'N' AS DueAgency
FROM payhistory ph WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON ph.number = m.number
WHERE m.customer = '0001101' AND batchtype LIKE 'PU%' AND m.status = 'SIF' AND CAST(m.closed AS DATE) BETWEEN CAST(DATEADD(dd, -14, @startDate) AS DATE) AND CAST(DATEADD(dd, -14, @endDate) AS DATE)
AND invoiced IS NOT NULL

END
GO
