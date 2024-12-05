SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO




CREATE     VIEW [dbo].[Custom_PaymentsView]
AS

SELECT p.number, p.uid, m.account, p.customer, batchtype, paytype, paymethod, p.desk, totalpaid, entered, datepaid, invoiced, invoice,
	fee1 + fee2 + fee3 + fee4 + fee5 + fee6 + fee7 + fee8 + fee9 TotalFee,
	CASE WHEN batchtype LIKE '%R' THEN -totalpaid ELSE totalpaid END AdjTotalPaid,
	CASE WHEN batchtype LIKE '%R' THEN -(fee1 + fee2 + fee3 + fee4 + fee5 + fee6 + fee7 + fee8 + fee9)
		ELSE fee1 + fee2 + fee3 + fee4 + fee5 + fee6 + fee7 + fee8 + fee9 END AdjTotalFee,
	CASE WHEN SUBSTRING(InvoiceFlags, 1, 1) = '1' THEN p.paid1 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 2, 1) = '1' THEN p.paid2 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 3, 1) = '1' THEN p.paid3 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 4, 1) = '1' THEN p.paid4 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 5, 1) = '1' THEN p.paid5 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 6, 1) = '1' THEN p.paid6 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 7, 1) = '1' THEN p.paid7 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 8, 1) = '1' THEN p.paid8 ELSE 0 END + 
		CASE WHEN SUBSTRING(InvoiceFlags, 9, 1) = '1' THEN p.paid9 ELSE 0 END InvoicedPaid,
	CASE WHEN SUBSTRING(InvoiceFlags, 1, 1) = '1' THEN p.fee1 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 2, 1) = '1' THEN p.fee2 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 3, 1) = '1' THEN p.fee3 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 4, 1) = '1' THEN p.fee4 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 5, 1) = '1' THEN p.fee5 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 6, 1) = '1' THEN p.fee6 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 7, 1) = '1' THEN p.fee7 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 8, 1) = '1' THEN p.fee8 ELSE 0 END + 
		CASE WHEN SUBSTRING(InvoiceFlags, 9, 1) = '1' THEN p.fee9 ELSE 0 END InvoicedFee,
	CASE WHEN batchtype NOT LIKE '%R' THEN
		CASE WHEN SUBSTRING(InvoiceFlags, 1, 1) = '1' THEN p.paid1 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 2, 1) = '1' THEN p.paid2 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 3, 1) = '1' THEN p.paid3 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 4, 1) = '1' THEN p.paid4 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 5, 1) = '1' THEN p.paid5 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 6, 1) = '1' THEN p.paid6 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 7, 1) = '1' THEN p.paid7 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 8, 1) = '1' THEN p.paid8 ELSE 0 END + 
		CASE WHEN SUBSTRING(InvoiceFlags, 9, 1) = '1' THEN p.paid9 ELSE 0 END 
	ELSE 
		-(CASE WHEN SUBSTRING(InvoiceFlags, 1, 1) = '1' THEN p.paid1 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 2, 1) = '1' THEN p.paid2 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 3, 1) = '1' THEN p.paid3 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 4, 1) = '1' THEN p.paid4 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 5, 1) = '1' THEN p.paid5 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 6, 1) = '1' THEN p.paid6 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 7, 1) = '1' THEN p.paid7 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 8, 1) = '1' THEN p.paid8 ELSE 0 END + 
		CASE WHEN SUBSTRING(InvoiceFlags, 9, 1) = '1' THEN p.paid9 ELSE 0 END) 
	END AdjInvoicedPaid,
	CASE WHEN batchtype NOT LIKE '%R' THEN
		CASE WHEN SUBSTRING(InvoiceFlags, 1, 1) = '1' THEN p.fee1 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 2, 1) = '1' THEN p.fee2 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 3, 1) = '1' THEN p.fee3 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 4, 1) = '1' THEN p.fee4 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 5, 1) = '1' THEN p.fee5 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 6, 1) = '1' THEN p.fee6 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 7, 1) = '1' THEN p.fee7 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 8, 1) = '1' THEN p.fee8 ELSE 0 END + 
		CASE WHEN SUBSTRING(InvoiceFlags, 9, 1) = '1' THEN p.fee9 ELSE 0 END 
	ELSE
		-(CASE WHEN SUBSTRING(InvoiceFlags, 1, 1) = '1' THEN p.fee1 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 2, 1) = '1' THEN p.fee2 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 3, 1) = '1' THEN p.fee3 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 4, 1) = '1' THEN p.fee4 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 5, 1) = '1' THEN p.fee5 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 6, 1) = '1' THEN p.fee6 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 7, 1) = '1' THEN p.fee7 ELSE 0 END +
		CASE WHEN SUBSTRING(InvoiceFlags, 8, 1) = '1' THEN p.fee8 ELSE 0 END + 
		CASE WHEN SUBSTRING(InvoiceFlags, 9, 1) = '1' THEN p.fee9 ELSE 0 END)
	END AdjInvoicedFee
FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON
	p.number = m.number





GO
