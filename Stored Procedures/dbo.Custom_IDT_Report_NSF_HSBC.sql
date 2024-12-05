SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

CREATE  PROCEDURE [dbo].[Custom_IDT_Report_NSF_HSBC]
@invoice varchar(8000)
AS


SELECT account, InvoicedPaid, 'RET' trancode, datepaid, 20 paytype, number
FROM Custom_PaymentsView
WHERE customer in (select customerid from fact with (nolock) where customgroupid = 96)  AND invoice in (select string from dbo.CustomStringToSet(@invoice, '|')) AND batchtype = 'PUR' AND InvoicedPaid > 0
GO
