SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

CREATE  PROCEDURE [dbo].[Custom_IDT_Report_Payment_HSBC]
@invoice varchar(8000)

AS


SELECT distinct c.account, c.InvoicedPaid, 'PMT' trancode, c.datepaid, case p.checknbr when null then '0' when '' then '0' else '0' end as ref_no, CASE c.paymethod
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
	END paytype, m.originalcreditor Portfolio, '35.00' Fee, m.received [Placed], m.state [State]
FROM (select string as invoices from dbo.CustomStringToSet(@invoice, '|')) i
			inner join custom_paymentsview c with (nolock) on c.invoice = i.invoices
			inner JOIN  master m with (nolock) ON m.Number=c.Number
			inner join payhistory p with (nolock) on p.number = c.number
WHERE c.customer in (select customerid from fact with (nolock) where customgroupid = 96)  AND c.batchtype = 'PU' AND c.InvoicedPaid > 0
GO
