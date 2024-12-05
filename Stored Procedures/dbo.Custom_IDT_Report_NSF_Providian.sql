SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

CREATE  PROCEDURE [dbo].[Custom_IDT_Report_NSF_Providian]
@invoice varchar(255)
AS


SELECT account, InvoicedPaid, 'RET' trancode, datepaid, 20 paytype, number
FROM Custom_PaymentsView
WHERE customer = '0000976' AND invoice in (select string from dbo.CustomStringToSet(@invoice, '|')) AND batchtype = 'PUR' AND InvoicedPaid > 0
GO
