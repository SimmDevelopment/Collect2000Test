SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Custom_Report_IDTBatch]
AS

SELECT MONTH(received) ReceivedMonth, YEAR(received) ReceivedYear, SUM(original) PlacedAmount, COUNT(*) PlacedNum
INTO #Accounts
FROM master m WITH (NOLOCK)
WHERE customer = '0000915'
GROUP BY MONTH(received), YEAR(received)

SELECT MONTH(entered) MonthEntered, YEAR(entered) YearEntered, SUM(AdjInvoicedPaid) Paid
INTO #Payments
FROM Custom_PaymentsView p
WHERE customer = '0000915' 
GROUP BY MONTH(entered), YEAR(entered)

SELECT COALESCE(ReceivedMonth, MonthEntered) [Month], COALESCE(ReceivedYear, YearEntered) [Year],
	PlacedAmount PlacedAmt, PlacedNum PlacedCount, Paid
FROM #Accounts FULL JOIN #Payments
ON ReceivedMonth = MonthEntered AND ReceivedYear = YearEntered
ORDER BY [Year], [Month]

DROP TABLE #Accounts
DROP TABLE #Payments

GO
