SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[Custom_IDT_Report_NSF]
@startDate datetime,
@endDate datetime
AS


SELECT account, InvoicedPaid, 'RET' trancode, datepaid, 20 paytype, number
FROM Custom_PaymentsView
WHERE customer = '0000915' AND entered BETWEEN @startDate AND @endDate AND batchtype = 'PUR' AND InvoicedPaid > 0



GO
