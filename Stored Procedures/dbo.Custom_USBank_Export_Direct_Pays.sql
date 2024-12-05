SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
Changes:
	BGM 3/26/2019  removed condition to exclude returned accounts.


*/


--ALTER  the procedure.
CREATE PROCEDURE [dbo].[Custom_USBank_Export_Direct_Pays]

@invoice varchar(8000)

AS

SELECT c.CustomText1 AS [Agency Code], m.account AS [Account #], p.datepaid AS [Transaction Date],
CASE WHEN batchtype LIKE '%R' THEN -(p.paid1) ELSE p.paid1 END AS [Payment Amount], 
CASE WHEN batchtype LIKE '%R' THEN -(p.CollectorFee) ELSE p.CollectorFee END AS [Fee Amount],
CASE WHEN p.CollectorFee > 0 THEN fsd.Fee1 ELSE 0 end AS [Fee Percentage]
FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.number = m.number 
INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
INNER JOIN FeeScheduleDetails fsd WITH (NOLOCK) ON c.FeeSchedule = fsd.Code
WHERE m.customer IN ('0001747', '0001748', '0001749') AND batchtype LIKE 'PC%'
AND invoice IN (select string from dbo.CustomStringToSet(@invoice,'|'))
GO
