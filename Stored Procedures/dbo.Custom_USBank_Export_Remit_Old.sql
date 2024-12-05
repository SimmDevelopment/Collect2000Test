SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*



*/


--ALTER  the procedure.
CREATE PROCEDURE [dbo].[Custom_USBank_Export_Remit_Old]

@invoice varchar(8000)

AS

SELECT c.CustomText1 AS [Agency], m.account AS [Account Number], 
CASE WHEN batchtype LIKE '%R' THEN -(p.paid1) ELSE p.paid1 END AS [Gross payment Amt], CASE WHEN batchtype LIKE '%R' THEN -(p.paid1 - p.CollectorFee) ELSE (p.paid1 - p.CollectorFee) END AS [Net payment Amt], 
CASE WHEN batchtype LIKE '%R' THEN -(p.CollectorFee) ELSE p.CollectorFee END AS [Fee],
fsd.Fee1 AS [Commission Rate]
FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.number = m.number 
INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
INNER JOIN FeeScheduleDetails fsd WITH (NOLOCK) ON c.FeeSchedule = fsd.Code
WHERE m.customer IN ('0001747', '0001748', '0001749') AND returned IS NULL AND batchtype LIKE 'P%'
AND invoice IN (select string from dbo.CustomStringToSet(@invoice,'|'))
GO
