SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_AFF_Export_Payment_old]
	-- Add the parameters for the stored procedure here
	@invoice varchar(8000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.id1 AS outSourcerAccountId, CONVERT(varCHAR(30), p.datetimeentered, 127) + '0000Z' AS eventTime , 'Payment' AS comment
	, p.UID AS [eventData.payment.transaction], CONVERT(varCHAR(30), p.datetimeentered, 127) + '0000Z' AS[eventData.payment.transactionDate],
	'principal' AS [eventData.payment.bucket1Title], --REPLACE(CONVERT(VARCHAR(10), p.paid1), '.', '') 
	p.paid1 AS [eventData.payment.bucket1Value], 
	'interest' AS [eventData.payment.bucket2Title], --REPLACE(CONVERT(VARCHAR(10), p.paid2), '.', '') 
	p.paid2 AS [eventData.payment.bucket2Value], 
	'costs' AS [eventData.payment.bucket3Title], --REPLACE(CONVERT(VARCHAR(10), p.paid3), '.', '') 
	p.paid3 AS [eventData.payment.bucket3Value], 
	'fees' AS [eventData.payment.bucket4Title], --REPLACE(CONVERT(VARCHAR(10), p.paid4), '.', '') 
	p.paid4 AS [eventData.payment.bucket4Value], 
	--REPLACE(CONVERT(VARCHAR(10), p.CollectorFee), '.', '') 
	p.CollectorFee AS [eventData.payment.reportedCommission]--, '' AS [eventData.payment.outSourcerAccountHolderId]
FROM master m WITH (NOLOCK) INNER JOIN payhistory p WITH (NOLOCK) ON m.number = p.number
WHERE m.customer = '0001070' AND batchtype = 'pu' AND Invoice in (select string from dbo.CustomStringToSet(@invoice, '|'))

END
GO
