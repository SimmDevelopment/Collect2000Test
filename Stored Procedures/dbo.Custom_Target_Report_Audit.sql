SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[Custom_Target_Report_Audit]
AS
SELECT account, dbo.FormatIBMNumeric(current1, 10) Balance, 
	dbo.FormatIBMNumeric(lastpaidamt, 10) LastPaidAmt,
	received, lastpaid
--,CASE status	WHEN 'B07' THEN '07'	WHEN 'B11' THEN '11'	WHEN 'B13' THEN '13'	ELSE '  ' END Chapter
FROM master WITH (NOLOCK) INNER JOIN status WITH (NOLOCK)
	ON status = code
WHERE customer = '0000856' and statustype = '0 - Active'

SELECT dbo.FormatIBMNumeric(SUM(current1), 10) TotalMoney
FROM master WITH (NOLOCK) INNER JOIN status WITH (NOLOCK)
	ON status = code
WHERE customer = '0000856' and statustype = '0 - Active'
GO
