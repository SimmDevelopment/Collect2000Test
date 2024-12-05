SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[Custom_AppliedCard_Report_EOM]
@startDate datetime,
@endDate datetime,
@customer varchar(8000)

AS


SELECT 'Payment' Type, m.account Account, InvoicedPaid Amount, datepaid Date, m.Name AccountName
FROM Custom_PaymentsView p INNER JOIN master m
	ON p.number = m.number
WHERE datepaid BETWEEN @startDate AND @endDate AND p.customer = @customer and batchtype IN ('PU', 'PC')

UNION

SELECT 'PDC', m.account Account, Amount, deposit Date, m.Name AccountName
FROM pdc p INNER JOIN master m
	ON p.Number = m.number
WHERE deposit BETWEEN @startDate AND @endDate AND p.customer = @customer AND active = 1
GO
