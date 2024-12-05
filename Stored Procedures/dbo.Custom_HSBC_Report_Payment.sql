SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO






CREATE       PROCEDURE [dbo].[Custom_HSBC_Report_Payment]
@invoices varchar(8000)
AS


SELECT m.account, datepaid, InvoicedPaid totalpaid, 
	InvoicedFee totalfee,
	CASE batchtype
		WHEN 'PU' THEN '524'
		WHEN 'PUR' THEN '224'
	END PayType
FROM Custom_PaymentsView p INNER JOIN master m
	ON p.number = m.number
WHERE p.invoice IN (SELECT string FROM dbo.StringToSet(@invoices, ',')) AND batchtype IN ('PU', 'PUR') AND AdjInvoicedPaid <> 0




GO
