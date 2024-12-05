SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO



CREATE    PROCEDURE [dbo].[Custom_FirstPremier_Report_SIFPIF]
@startDate datetime,
@endDate datetime

AS

/*
SELECT status Type, account [Account Number], current0 Balance, 
	CASE current0 + lastpaidamt WHEN 0 THEN 0 ELSE lastpaidamt/(current0 + lastpaidamt) * 100 END [Settlement%], 
	lastpaidamt [Payment Amount]
FROM master
WHERE customer = '0000905' AND status IN ('SIF', 'PIF') AND closed BETWEEN @startDate AND @endDate
*/

SELECT status Type, account [Account Number], current0 Balance, 
	p.paid/(current0 + p.paid) * 100 [Settlement%], 
	p.paid [Payment Amount]
FROM master m INNER JOIN 
	(SELECT p.number, SUM(AdjInvoicedPaid) paid 
	FROM Custom_PaymentsView p INNER JOIN master m
		ON p.number = m.number
	WHERE datepaid >= DATEADD(day, -90, m.lastpaid) AND batchtype LIKE 'P%' AND p.customer = '0000905' --AND invoiced IS NOT NULL
	GROUP BY p.number) p ON
	m.number = p.number
WHERE customer = '0000905' AND status IN ('SIF', 'PIF') AND closed BETWEEN @startDate AND @endDate and p.paid > 0

GO
