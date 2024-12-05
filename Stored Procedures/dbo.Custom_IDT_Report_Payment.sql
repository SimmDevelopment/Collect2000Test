SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[Custom_IDT_Report_Payment]
@startDate datetime,
@endDate datetime
AS


SELECT c.account, c.InvoicedPaid, 'PMT' trancode, c.datepaid, CASE c.paymethod
	WHEN 'CHECK' THEN 1
	WHEN 'MONEY ORDER' THEN 2
	WHEN 'CREDIT CARD' THEN 3
	WHEN 'WESTERN UNION' THEN 4
	WHEN 'BANK WIRE' THEN 6
	WHEN 'CASH' THEN 7
	WHEN 'DIRECT PAYMENT' THEN 8
	WHEN 'Legal Judgment' THEN 9
	WHEN 'Money Gram' THEN 22
	WHEN 'ACH DEBIT' THEN 16
	ELSE 11 --"Non Cash" as default
	END paytype, m.originalcreditor Portfolio, '33.33' Fee, m.received [Placed], m.state [State]
FROM Custom_PaymentsView c inner join master m with (nolock) on c.number = m.number
WHERE c.customer = '0000915' AND c.entered BETWEEN @startDate AND @endDate AND c.batchtype = 'PU' AND c.InvoicedPaid > 0
GO
