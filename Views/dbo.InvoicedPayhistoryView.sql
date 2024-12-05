SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[InvoicedPayhistoryView]
AS
SELECT [payhistory].[UID],
	[dbo].[DetermineInvoicedAmount]([InvoiceFlags], [paid1], [paid2], [paid3], [paid4], [paid5], [paid6], [paid7], [paid8], [paid9], [paid10]) AS [totalpaid],
	[dbo].[DetermineInvoicedAmount]([InvoiceFlags], [paid1], 0, 0, 0, 0, 0, 0, 0, 0, 0) AS [paid1],
	[dbo].[DetermineInvoicedAmount]([InvoiceFlags], 0, [paid2], 0, 0, 0, 0, 0, 0, 0, 0) AS [paid2],
	[dbo].[DetermineInvoicedAmount]([InvoiceFlags], 0, 0, [paid3], 0, 0, 0, 0, 0, 0, 0) AS [paid3],
	[dbo].[DetermineInvoicedAmount]([InvoiceFlags], 0, 0, 0, [paid4], 0, 0, 0, 0, 0, 0) AS [paid4],
	[dbo].[DetermineInvoicedAmount]([InvoiceFlags], 0, 0, 0, 0, [paid5], 0, 0, 0, 0, 0) AS [paid5],
	[dbo].[DetermineInvoicedAmount]([InvoiceFlags], 0, 0, 0, 0, 0, [paid6], 0, 0, 0, 0) AS [paid6],
	[dbo].[DetermineInvoicedAmount]([InvoiceFlags], 0, 0, 0, 0, 0, 0, [paid7], 0, 0, 0) AS [paid7],
	[dbo].[DetermineInvoicedAmount]([InvoiceFlags], 0, 0, 0, 0, 0, 0, 0, [paid8], 0, 0) AS [paid8],
	[dbo].[DetermineInvoicedAmount]([InvoiceFlags], 0, 0, 0, 0, 0, 0, 0, 0, [paid9], 0) AS [paid9],
	[dbo].[DetermineInvoicedAmount]([InvoiceFlags], 0, 0, 0, 0, 0, 0, 0, 0, 0, [paid10]) AS [paid10],
	[dbo].[DetermineInvoicedAmount]([InvoiceFlags], [fee1], [fee2], [fee3], [fee4], [fee5], [fee6], [fee7], [fee8], [fee9], [fee10]) AS [totalfee],
	[dbo].[DetermineInvoicedAmount]([InvoiceFlags], [fee1], 0, 0, 0, 0, 0, 0, 0, 0, 0) AS [fee1],
	[dbo].[DetermineInvoicedAmount]([InvoiceFlags], 0, [fee2], 0, 0, 0, 0, 0, 0, 0, 0) AS [fee2],
	[dbo].[DetermineInvoicedAmount]([InvoiceFlags], 0, 0, [fee3], 0, 0, 0, 0, 0, 0, 0) AS [fee3],
	[dbo].[DetermineInvoicedAmount]([InvoiceFlags], 0, 0, 0, [fee4], 0, 0, 0, 0, 0, 0) AS [fee4],
	[dbo].[DetermineInvoicedAmount]([InvoiceFlags], 0, 0, 0, 0, [fee5], 0, 0, 0, 0, 0) AS [fee5],
	[dbo].[DetermineInvoicedAmount]([InvoiceFlags], 0, 0, 0, 0, 0, [fee6], 0, 0, 0, 0) AS [fee6],
	[dbo].[DetermineInvoicedAmount]([InvoiceFlags], 0, 0, 0, 0, 0, 0, [fee7], 0, 0, 0) AS [fee7],
	[dbo].[DetermineInvoicedAmount]([InvoiceFlags], 0, 0, 0, 0, 0, 0, 0, [fee8], 0, 0) AS [fee8],
	[dbo].[DetermineInvoicedAmount]([InvoiceFlags], 0, 0, 0, 0, 0, 0, 0, 0, [fee9], 0) AS [fee9],
	[dbo].[DetermineInvoicedAmount]([InvoiceFlags], 0, 0, 0, 0, 0, 0, 0, 0, 0, [fee10]) AS [fee10]
FROM [dbo].[payhistory]

GO
