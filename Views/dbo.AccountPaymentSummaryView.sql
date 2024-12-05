SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  VIEW [dbo].[AccountPaymentSummaryView]
AS
SELECT [number] AS [AccountID],
	COUNT_BIG(*) AS [Transactions],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN 1
		ELSE 0
	END), 0) AS [Payments],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN 1
		ELSE 0
	END), 0) AS [PaymentsToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN 1
		ELSE 0
	END), 0) AS [PaymentsToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN 1
		ELSE 0
	END), 0) AS [PaymentsToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_R' AND ([IsCorrection] IS NULL OR [IsCorrection] = 0) THEN 1
		ELSE 0
	END), 0) AS [Reversals],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PUR' AND ([IsCorrection] IS NULL OR [IsCorrection] = 0) THEN 1
		ELSE 0
	END), 0) AS [ReversalsToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PCR' AND ([IsCorrection] IS NULL OR [IsCorrection] = 0) THEN 1
		ELSE 0
	END), 0) AS [ReversalsToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PAR' AND ([IsCorrection] IS NULL OR [IsCorrection] = 0) THEN 1
		ELSE 0
	END), 0) AS [ReversalsToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_R' AND [IsCorrection] = 1 THEN 1
		ELSE 0
	END), 0) AS [Corrections],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PUR' AND [IsCorrection] = 1 THEN 1
		ELSE 0
	END), 0) AS [CorrectionsToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PCR' AND [IsCorrection] = 1 THEN 1
		ELSE 0
	END), 0) AS [CorrectionsToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PAR' AND [IsCorrection] = 1 THEN 1
		ELSE 0
	END), 0) AS [CorrectionsToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN [totalpaid]
		WHEN [batchtype] LIKE 'P_R' THEN -[totalpaid]
		ELSE 0
	END), 0) AS [TotalPaid],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN [OverPaidAmt]
		WHEN [batchtype] LIKE 'P_R' THEN -[OverPaidAmt]
		ELSE 0
	END), 0) AS [OverPayments],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN [paid1] + [paid2] + [paid3] + [paid4] + [paid5] + [paid6] + [paid7] + [paid8] + [paid9] + [paid10]
		WHEN [batchtype] LIKE 'P_R' THEN -([paid1] + [paid2] + [paid3] + [paid4] + [paid5] + [paid6] + [paid7] + [paid8] + [paid9] + [paid10])
		ELSE 0
	END), 0) AS [Paid],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN [paid1]
		WHEN [batchtype] LIKE 'P_R' THEN -[paid1]
		ELSE 0
	END), 0) AS [Paid1],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN [paid2]
		WHEN [batchtype] LIKE 'P_R' THEN -[paid2]
		ELSE 0
	END), 0) AS [Paid2],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN [paid3]
		WHEN [batchtype] LIKE 'P_R' THEN -[paid3]
		ELSE 0
	END), 0) AS [Paid3],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN [paid4]
		WHEN [batchtype] LIKE 'P_R' THEN -[paid4]
		ELSE 0
	END), 0) AS [Paid4],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN [paid5]
		WHEN [batchtype] LIKE 'P_R' THEN -[paid5]
		ELSE 0
	END), 0) AS [Paid5],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN [paid6]
		WHEN [batchtype] LIKE 'P_R' THEN -[paid6]
		ELSE 0
	END), 0) AS [Paid6],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN [paid7]
		WHEN [batchtype] LIKE 'P_R' THEN -[paid7]
		ELSE 0
	END), 0) AS [Paid7],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN [paid8]
		WHEN [batchtype] LIKE 'P_R' THEN -[paid8]
		ELSE 0
	END), 0) AS [Paid8],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN [paid9]
		WHEN [batchtype] LIKE 'P_R' THEN -[paid9]
		ELSE 0
	END), 0) AS [Paid9],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN [paid10]
		WHEN [batchtype] LIKE 'P_R' THEN -[paid10]
		ELSE 0
	END), 0) AS [Paid10],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN [fee1] + [fee2] + [fee3] + [fee4] + [fee5] + [fee6] + [fee7] + [fee8] + [fee9] + [fee10]
		WHEN [batchtype] LIKE 'P_R' THEN -([fee1] + [fee2] + [fee3] + [fee4] + [fee5] + [fee6] + [fee7] + [fee8] + [fee9] + [fee10])
		ELSE 0
	END), 0) AS [Fee],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN [fee1]
		WHEN [batchtype] LIKE 'P_R' THEN -[fee1]
		ELSE 0
	END), 0) AS [Fee1],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN [fee2]
		WHEN [batchtype] LIKE 'P_R' THEN -[fee2]
		ELSE 0
	END), 0) AS [Fee2],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN [fee3]
		WHEN [batchtype] LIKE 'P_R' THEN -[fee3]
		ELSE 0
	END), 0) AS [Fee3],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN [fee4]
		WHEN [batchtype] LIKE 'P_R' THEN -[fee4]
		ELSE 0
	END), 0) AS [Fee4],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN [fee5]
		WHEN [batchtype] LIKE 'P_R' THEN -[fee5]
		ELSE 0
	END), 0) AS [Fee5],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN [fee6]
		WHEN [batchtype] LIKE 'P_R' THEN -[fee6]
		ELSE 0
	END), 0) AS [Fee6],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN [fee7]
		WHEN [batchtype] LIKE 'P_R' THEN -[fee7]
		ELSE 0
	END), 0) AS [Fee7],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN [fee8]
		WHEN [batchtype] LIKE 'P_R' THEN -[fee8]
		ELSE 0
	END), 0) AS [Fee8],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN [fee9]
		WHEN [batchtype] LIKE 'P_R' THEN -[fee9]
		ELSE 0
	END), 0) AS [Fee9],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN [fee10]
		WHEN [batchtype] LIKE 'P_R' THEN -[fee10]
		ELSE 0
	END), 0) AS [Fee10],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), [paid1], [paid2], [paid3], [paid4], [paid5], [paid6], [paid7], [paid8], [paid9], [paid10]), 0)
		WHEN [batchtype] LIKE 'P_R' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), [paid1], [paid2], [paid3], [paid4], [paid5], [paid6], [paid7], [paid8], [paid9], [paid10]), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), [paid1], 0, 0, 0, 0, 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] LIKE 'P_R' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), [paid1], 0, 0, 0, 0, 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid1],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, [paid2], 0, 0, 0, 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] LIKE 'P_R' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, [paid2], 0, 0, 0, 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid2],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, [paid3], 0, 0, 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] LIKE 'P_R' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, [paid3], 0, 0, 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid3],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, [paid4], 0, 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] LIKE 'P_R' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, [paid4], 0, 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid4],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, [paid5], 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] LIKE 'P_R' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, [paid5], 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid5],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, [paid6], 0, 0, 0, 0), 0)
		WHEN [batchtype] LIKE 'P_R' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, [paid6], 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid6],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, [paid7], 0, 0, 0), 0)
		WHEN [batchtype] LIKE 'P_R' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, [paid7], 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid7],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, [paid8], 0, 0), 0)
		WHEN [batchtype] LIKE 'P_R' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, [paid8], 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid8],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, 0, [paid9], 0), 0)
		WHEN [batchtype] LIKE 'P_R' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, 0, [paid9], 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid9],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, 0, 0, [paid10]), 0)
		WHEN [batchtype] LIKE 'P_R' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, 0, 0, [paid10]), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid10],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), [fee1], [fee2], [fee3], [fee4], [fee5], [fee6], [fee7], [fee8], [fee9], [fee10]), 0)
		WHEN [batchtype] LIKE 'P_R' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), [fee1], [fee2], [fee3], [fee4], [fee5], [fee6], [fee7], [fee8], [fee9], [fee10]), 0)
		ELSE 0
	END), 0) AS [InvoicableFee],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), [fee1], 0, 0, 0, 0, 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] LIKE 'P_R' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), [fee1], 0, 0, 0, 0, 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee1],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, [fee2], 0, 0, 0, 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] LIKE 'P_R' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, [fee2], 0, 0, 0, 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee2],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, [fee3], 0, 0, 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] LIKE 'P_R' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, [fee3], 0, 0, 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee3],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, [fee4], 0, 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] LIKE 'P_R' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, [fee4], 0, 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee4],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, [fee5], 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] LIKE 'P_R' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, [fee5], 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee5],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, [fee6], 0, 0, 0, 0), 0)
		WHEN [batchtype] LIKE 'P_R' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, [fee6], 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee6],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, [fee7], 0, 0, 0), 0)
		WHEN [batchtype] LIKE 'P_R' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, [fee7], 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee7],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, [fee8], 0, 0), 0)
		WHEN [batchtype] LIKE 'P_R' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, [fee8], 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee8],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, 0, [fee9], 0), 0)
		WHEN [batchtype] LIKE 'P_R' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, 0, [fee9], 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee9],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, 0, 0, [fee10]), 0)
		WHEN [batchtype] LIKE 'P_R' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, 0, 0, [fee10]), 0)
		ELSE 0
	END), 0) AS [InvoicableFee10],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN ISNULL([CollectorFee], 0)
		WHEN [batchtype] LIKE 'P_R' THEN ISNULL(-[CollectorFee], 0)
		ELSE 0
	END), 0) AS [CollectorFee],
	ISNULL(SUM(CASE
		WHEN [batchtype] LIKE 'P_' THEN ISNULL([AIMAgencyFee], 0)
		WHEN [batchtype] LIKE 'P_R' THEN ISNULL(-[AIMAgencyFee], 0)
		ELSE 0
	END), 0) AS [AgencyFee],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN [totalpaid]
		WHEN [batchtype] = 'PUR' THEN -[totalpaid]
		ELSE 0
	END), 0) AS [TotalPaidToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN [OverPaidAmt]
		WHEN [batchtype] = 'PUR' THEN -[OverPaidAmt]
		ELSE 0
	END), 0) AS [OverPaymentsToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN [paid1] + [paid2] + [paid3] + [paid4] + [paid5] + [paid6] + [paid7] + [paid8] + [paid9] + [paid10]
		WHEN [batchtype] = 'PUR' THEN -([paid1] + [paid2] + [paid3] + [paid4] + [paid5] + [paid6] + [paid7] + [paid8] + [paid9] + [paid10])
		ELSE 0
	END), 0) AS [PaidToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN [paid1]
		WHEN [batchtype] = 'PUR' THEN -[paid1]
		ELSE 0
	END), 0) AS [Paid1ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN [paid2]
		WHEN [batchtype] = 'PUR' THEN -[paid2]
		ELSE 0
	END), 0) AS [Paid2ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN [paid3]
		WHEN [batchtype] = 'PUR' THEN -[paid3]
		ELSE 0
	END), 0) AS [Paid3ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN [paid4]
		WHEN [batchtype] = 'PUR' THEN -[paid4]
		ELSE 0
	END), 0) AS [Paid4ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN [paid5]
		WHEN [batchtype] = 'PUR' THEN -[paid5]
		ELSE 0
	END), 0) AS [Paid5ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN [paid6]
		WHEN [batchtype] = 'PUR' THEN -[paid6]
		ELSE 0
	END), 0) AS [Paid6ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN [paid7]
		WHEN [batchtype] = 'PUR' THEN -[paid7]
		ELSE 0
	END), 0) AS [Paid7ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN [paid8]
		WHEN [batchtype] = 'PUR' THEN -[paid8]
		ELSE 0
	END), 0) AS [Paid8ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN [paid9]
		WHEN [batchtype] = 'PUR' THEN -[paid9]
		ELSE 0
	END), 0) AS [Paid9ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN [paid10]
		WHEN [batchtype] = 'PUR' THEN -[paid10]
		ELSE 0
	END), 0) AS [Paid10ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN [fee1] + [fee2] + [fee3] + [fee4] + [fee5] + [fee6] + [fee7] + [fee8] + [fee9] + [fee10]
		WHEN [batchtype] = 'PUR' THEN -([fee1] + [fee2] + [fee3] + [fee4] + [fee5] + [fee6] + [fee7] + [fee8] + [fee9] + [fee10])
		ELSE 0
	END), 0) AS [FeeToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN [fee1]
		WHEN [batchtype] = 'PUR' THEN -[fee1]
		ELSE 0
	END), 0) AS [Fee1ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN [fee2]
		WHEN [batchtype] = 'PUR' THEN -[fee2]
		ELSE 0
	END), 0) AS [Fee2ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN [fee3]
		WHEN [batchtype] = 'PUR' THEN -[fee3]
		ELSE 0
	END), 0) AS [Fee3ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN [fee4]
		WHEN [batchtype] = 'PUR' THEN -[fee4]
		ELSE 0
	END), 0) AS [Fee4ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN [fee5]
		WHEN [batchtype] = 'PUR' THEN -[fee5]
		ELSE 0
	END), 0) AS [Fee5ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN [fee6]
		WHEN [batchtype] = 'PUR' THEN -[fee6]
		ELSE 0
	END), 0) AS [Fee6ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN [fee7]
		WHEN [batchtype] = 'PUR' THEN -[fee7]
		ELSE 0
	END), 0) AS [Fee7ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN [fee8]
		WHEN [batchtype] = 'PUR' THEN -[fee8]
		ELSE 0
	END), 0) AS [Fee8ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN [fee9]
		WHEN [batchtype] = 'PUR' THEN -[fee9]
		ELSE 0
	END), 0) AS [Fee9ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN [fee10]
		WHEN [batchtype] = 'PUR' THEN -[fee10]
		ELSE 0
	END), 0) AS [Fee10ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), [paid1], [paid2], [paid3], [paid4], [paid5], [paid6], [paid7], [paid8], [paid9], [paid10]), 0)
		WHEN [batchtype] = 'PUR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), [paid1], [paid2], [paid3], [paid4], [paid5], [paid6], [paid7], [paid8], [paid9], [paid10]), 0)
		ELSE 0
	END), 0) AS [InvoicablePaidToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), [paid1], 0, 0, 0, 0, 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PUR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), [paid1], 0, 0, 0, 0, 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid1ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, [paid2], 0, 0, 0, 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PUR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, [paid2], 0, 0, 0, 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid2ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, [paid3], 0, 0, 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PUR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, [paid3], 0, 0, 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid3ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, [paid4], 0, 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PUR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, [paid4], 0, 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid4ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, [paid5], 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PUR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, [paid5], 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid5ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, [paid6], 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PUR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, [paid6], 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid6ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, [paid7], 0, 0, 0), 0)
		WHEN [batchtype] = 'PUR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, [paid7], 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid7ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, [paid8], 0, 0), 0)
		WHEN [batchtype] = 'PUR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, [paid8], 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid8ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, 0, [paid9], 0), 0)
		WHEN [batchtype] = 'PUR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, 0, [paid9], 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid9ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, 0, 0, [paid10]), 0)
		WHEN [batchtype] = 'PUR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, 0, 0, [paid10]), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid10ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), [fee1], [fee2], [fee3], [fee4], [fee5], [fee6], [fee7], [fee8], [fee9], [fee10]), 0)
		WHEN [batchtype] = 'PUR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), [fee1], [fee2], [fee3], [fee4], [fee5], [fee6], [fee7], [fee8], [fee9], [fee10]), 0)
		ELSE 0
	END), 0) AS [InvoicableFeeToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), [fee1], 0, 0, 0, 0, 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PUR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), [fee1], 0, 0, 0, 0, 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee1ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, [fee2], 0, 0, 0, 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PUR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, [fee2], 0, 0, 0, 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee2ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, [fee3], 0, 0, 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PUR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, [fee3], 0, 0, 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee3ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, [fee4], 0, 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PUR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, [fee4], 0, 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee4ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, [fee5], 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PUR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, [fee5], 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee5ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, [fee6], 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PUR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, [fee6], 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee6ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, [fee7], 0, 0, 0), 0)
		WHEN [batchtype] = 'PUR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, [fee7], 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee7ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, [fee8], 0, 0), 0)
		WHEN [batchtype] = 'PUR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, [fee8], 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee8ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, 0, [fee9], 0), 0)
		WHEN [batchtype] = 'PUR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, 0, [fee9], 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee9ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, 0, 0, [fee10]), 0)
		WHEN [batchtype] = 'PUR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, 0, 0, [fee10]), 0)
		ELSE 0
	END), 0) AS [InvoicableFee10ToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN ISNULL([CollectorFee], 0)
		WHEN [batchtype] = 'PUR' THEN ISNULL(-[CollectorFee], 0)
		ELSE 0
	END), 0) AS [CollectorFeeToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PU' THEN ISNULL([AIMAgencyFee], 0)
		WHEN [batchtype] = 'PUR' THEN ISNULL(-[AIMAgencyFee], 0)
		ELSE 0
	END), 0) AS [AgencyFeeToUs],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN [totalpaid]
		WHEN [batchtype] = 'PCR' THEN -[totalpaid]
		ELSE 0
	END), 0) AS [TotalPaidToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN [OverPaidAmt]
		WHEN [batchtype] = 'PCR' THEN -[OverPaidAmt]
		ELSE 0
	END), 0) AS [OverPaymentsToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN [paid1] + [paid2] + [paid3] + [paid4] + [paid5] + [paid6] + [paid7] + [paid8] + [paid9] + [paid10]
		WHEN [batchtype] = 'PCR' THEN -([paid1] + [paid2] + [paid3] + [paid4] + [paid5] + [paid6] + [paid7] + [paid8] + [paid9] + [paid10])
		ELSE 0
	END), 0) AS [PaidToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN [paid1]
		WHEN [batchtype] = 'PCR' THEN -[paid1]
		ELSE 0
	END), 0) AS [Paid1ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN [paid2]
		WHEN [batchtype] = 'PCR' THEN -[paid2]
		ELSE 0
	END), 0) AS [Paid2ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN [paid3]
		WHEN [batchtype] = 'PCR' THEN -[paid3]
		ELSE 0
	END), 0) AS [Paid3ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN [paid4]
		WHEN [batchtype] = 'PCR' THEN -[paid4]
		ELSE 0
	END), 0) AS [Paid4ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN [paid5]
		WHEN [batchtype] = 'PCR' THEN -[paid5]
		ELSE 0
	END), 0) AS [Paid5ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN [paid6]
		WHEN [batchtype] = 'PCR' THEN -[paid6]
		ELSE 0
	END), 0) AS [Paid6ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN [paid7]
		WHEN [batchtype] = 'PCR' THEN -[paid7]
		ELSE 0
	END), 0) AS [Paid7ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN [paid8]
		WHEN [batchtype] = 'PCR' THEN -[paid8]
		ELSE 0
	END), 0) AS [Paid8ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN [paid9]
		WHEN [batchtype] = 'PCR' THEN -[paid9]
		ELSE 0
	END), 0) AS [Paid9ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN [paid10]
		WHEN [batchtype] = 'PCR' THEN -[paid10]
		ELSE 0
	END), 0) AS [Paid10ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN [fee1] + [fee2] + [fee3] + [fee4] + [fee5] + [fee6] + [fee7] + [fee8] + [fee9] + [fee10]
		WHEN [batchtype] = 'PCR' THEN -([fee1] + [fee2] + [fee3] + [fee4] + [fee5] + [fee6] + [fee7] + [fee8] + [fee9] + [fee10])
		ELSE 0
	END), 0) AS [FeeToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN [fee1]
		WHEN [batchtype] = 'PCR' THEN -[fee1]
		ELSE 0
	END), 0) AS [Fee1ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN [fee2]
		WHEN [batchtype] = 'PCR' THEN -[fee2]
		ELSE 0
	END), 0) AS [Fee2ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN [fee3]
		WHEN [batchtype] = 'PCR' THEN -[fee3]
		ELSE 0
	END), 0) AS [Fee3ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN [fee4]
		WHEN [batchtype] = 'PCR' THEN -[fee4]
		ELSE 0
	END), 0) AS [Fee4ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN [fee5]
		WHEN [batchtype] = 'PCR' THEN -[fee5]
		ELSE 0
	END), 0) AS [Fee5ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN [fee6]
		WHEN [batchtype] = 'PCR' THEN -[fee6]
		ELSE 0
	END), 0) AS [Fee6ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN [fee7]
		WHEN [batchtype] = 'PCR' THEN -[fee7]
		ELSE 0
	END), 0) AS [Fee7ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN [fee8]
		WHEN [batchtype] = 'PCR' THEN -[fee8]
		ELSE 0
	END), 0) AS [Fee8ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN [fee9]
		WHEN [batchtype] = 'PCR' THEN -[fee9]
		ELSE 0
	END), 0) AS [Fee9ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN [fee10]
		WHEN [batchtype] = 'PCR' THEN -[fee10]
		ELSE 0
	END), 0) AS [Fee10ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), [paid1], [paid2], [paid3], [paid4], [paid5], [paid6], [paid7], [paid8], [paid9], [paid10]), 0)
		WHEN [batchtype] = 'PCR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), [paid1], [paid2], [paid3], [paid4], [paid5], [paid6], [paid7], [paid8], [paid9], [paid10]), 0)
		ELSE 0
	END), 0) AS [InvoicablePaidToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), [paid1], 0, 0, 0, 0, 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PCR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), [paid1], 0, 0, 0, 0, 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid1ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, [paid2], 0, 0, 0, 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PCR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, [paid2], 0, 0, 0, 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid2ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, [paid3], 0, 0, 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PCR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, [paid3], 0, 0, 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid3ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, [paid4], 0, 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PCR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, [paid4], 0, 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid4ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, [paid5], 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PCR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, [paid5], 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid5ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, [paid6], 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PCR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, [paid6], 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid6ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, [paid7], 0, 0, 0), 0)
		WHEN [batchtype] = 'PCR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, [paid7], 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid7ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, [paid8], 0, 0), 0)
		WHEN [batchtype] = 'PCR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, [paid8], 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid8ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, 0, [paid9], 0), 0)
		WHEN [batchtype] = 'PCR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, 0, [paid9], 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid9ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, 0, 0, [paid10]), 0)
		WHEN [batchtype] = 'PCR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, 0, 0, [paid10]), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid10ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), [fee1], [fee2], [fee3], [fee4], [fee5], [fee6], [fee7], [fee8], [fee9], [fee10]), 0)
		WHEN [batchtype] = 'PCR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), [fee1], [fee2], [fee3], [fee4], [fee5], [fee6], [fee7], [fee8], [fee9], [fee10]), 0)
		ELSE 0
	END), 0) AS [InvoicableFeeToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), [fee1], 0, 0, 0, 0, 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PCR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), [fee1], 0, 0, 0, 0, 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee1ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, [fee2], 0, 0, 0, 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PCR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, [fee2], 0, 0, 0, 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee2ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, [fee3], 0, 0, 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PCR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, [fee3], 0, 0, 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee3ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, [fee4], 0, 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PCR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, [fee4], 0, 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee4ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, [fee5], 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PCR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, [fee5], 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee5ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, [fee6], 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PCR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, [fee6], 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee6ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, [fee7], 0, 0, 0), 0)
		WHEN [batchtype] = 'PCR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, [fee7], 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee7ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, [fee8], 0, 0), 0)
		WHEN [batchtype] = 'PCR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, [fee8], 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee8ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, 0, [fee9], 0), 0)
		WHEN [batchtype] = 'PCR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, 0, [fee9], 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee9ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, 0, 0, [fee10]), 0)
		WHEN [batchtype] = 'PCR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, 0, 0, [fee10]), 0)
		ELSE 0
	END), 0) AS [InvoicableFee10ToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN ISNULL([CollectorFee], 0)
		WHEN [batchtype] = 'PCR' THEN ISNULL(-[CollectorFee], 0)
		ELSE 0
	END), 0) AS [CollectorFeeToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PC' THEN ISNULL([AIMAgencyFee], 0)
		WHEN [batchtype] = 'PCR' THEN ISNULL(-[AIMAgencyFee], 0)
		ELSE 0
	END), 0) AS [AgencyFeeToClient],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN [totalpaid]
		WHEN [batchtype] = 'PAR' THEN -[totalpaid]
		ELSE 0
	END), 0) AS [TotalPaidToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN [OverPaidAmt]
		WHEN [batchtype] = 'PAR' THEN -[OverPaidAmt]
		ELSE 0
	END), 0) AS [OverPaymentsToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN [paid1] + [paid2] + [paid3] + [paid4] + [paid5] + [paid6] + [paid7] + [paid8] + [paid9] + [paid10]
		WHEN [batchtype] = 'PAR' THEN -([paid1] + [paid2] + [paid3] + [paid4] + [paid5] + [paid6] + [paid7] + [paid8] + [paid9] + [paid10])
		ELSE 0
	END), 0) AS [PaidToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN [paid1]
		WHEN [batchtype] = 'PAR' THEN -[paid1]
		ELSE 0
	END), 0) AS [Paid1ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN [paid2]
		WHEN [batchtype] = 'PAR' THEN -[paid2]
		ELSE 0
	END), 0) AS [Paid2ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN [paid3]
		WHEN [batchtype] = 'PAR' THEN -[paid3]
		ELSE 0
	END), 0) AS [Paid3ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN [paid4]
		WHEN [batchtype] = 'PAR' THEN -[paid4]
		ELSE 0
	END), 0) AS [Paid4ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN [paid5]
		WHEN [batchtype] = 'PAR' THEN -[paid5]
		ELSE 0
	END), 0) AS [Paid5ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN [paid6]
		WHEN [batchtype] = 'PAR' THEN -[paid6]
		ELSE 0
	END), 0) AS [Paid6ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN [paid7]
		WHEN [batchtype] = 'PAR' THEN -[paid7]
		ELSE 0
	END), 0) AS [Paid7ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN [paid8]
		WHEN [batchtype] = 'PAR' THEN -[paid8]
		ELSE 0
	END), 0) AS [Paid8ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN [paid9]
		WHEN [batchtype] = 'PAR' THEN -[paid9]
		ELSE 0
	END), 0) AS [Paid9ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN [paid10]
		WHEN [batchtype] = 'PAR' THEN -[paid10]
		ELSE 0
	END), 0) AS [Paid10ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN [fee1] + [fee2] + [fee3] + [fee4] + [fee5] + [fee6] + [fee7] + [fee8] + [fee9] + [fee10]
		WHEN [batchtype] = 'PAR' THEN -([fee1] + [fee2] + [fee3] + [fee4] + [fee5] + [fee6] + [fee7] + [fee8] + [fee9] + [fee10])
		ELSE 0
	END), 0) AS [FeeToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN [fee1]
		WHEN [batchtype] = 'PAR' THEN -[fee1]
		ELSE 0
	END), 0) AS [Fee1ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN [fee2]
		WHEN [batchtype] = 'PAR' THEN -[fee2]
		ELSE 0
	END), 0) AS [Fee2ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN [fee3]
		WHEN [batchtype] = 'PAR' THEN -[fee3]
		ELSE 0
	END), 0) AS [Fee3ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN [fee4]
		WHEN [batchtype] = 'PAR' THEN -[fee4]
		ELSE 0
	END), 0) AS [Fee4ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN [fee5]
		WHEN [batchtype] = 'PAR' THEN -[fee5]
		ELSE 0
	END), 0) AS [Fee5ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN [fee6]
		WHEN [batchtype] = 'PAR' THEN -[fee6]
		ELSE 0
	END), 0) AS [Fee6ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN [fee7]
		WHEN [batchtype] = 'PAR' THEN -[fee7]
		ELSE 0
	END), 0) AS [Fee7ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN [fee8]
		WHEN [batchtype] = 'PAR' THEN -[fee8]
		ELSE 0
	END), 0) AS [Fee8ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN [fee9]
		WHEN [batchtype] = 'PAR' THEN -[fee9]
		ELSE 0
	END), 0) AS [Fee9ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN [fee10]
		WHEN [batchtype] = 'PAR' THEN -[fee10]
		ELSE 0
	END), 0) AS [Fee10ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), [paid1], [paid2], [paid3], [paid4], [paid5], [paid6], [paid7], [paid8], [paid9], [paid10]), 0)
		WHEN [batchtype] = 'PAR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), [paid1], [paid2], [paid3], [paid4], [paid5], [paid6], [paid7], [paid8], [paid9], [paid10]), 0)
		ELSE 0
	END), 0) AS [InvoicablePaidToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), [paid1], 0, 0, 0, 0, 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PAR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), [paid1], 0, 0, 0, 0, 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid1ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, [paid2], 0, 0, 0, 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PAR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, [paid2], 0, 0, 0, 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid2ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, [paid3], 0, 0, 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PAR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, [paid3], 0, 0, 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid3ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, [paid4], 0, 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PAR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, [paid4], 0, 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid4ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, [paid5], 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PAR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, [paid5], 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid5ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, [paid6], 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PAR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, [paid6], 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid6ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, [paid7], 0, 0, 0), 0)
		WHEN [batchtype] = 'PAR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, [paid7], 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid7ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, [paid8], 0, 0), 0)
		WHEN [batchtype] = 'PAR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, [paid8], 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid8ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, 0, [paid9], 0), 0)
		WHEN [batchtype] = 'PAR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, 0, [paid9], 0), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid9ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, 0, 0, [paid10]), 0)
		WHEN [batchtype] = 'PAR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, 0, 0, [paid10]), 0)
		ELSE 0
	END), 0) AS [InvoicablePaid10ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), [fee1], [fee2], [fee3], [fee4], [fee5], [fee6], [fee7], [fee8], [fee9], [fee10]), 0)
		WHEN [batchtype] = 'PAR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), [fee1], [fee2], [fee3], [fee4], [fee5], [fee6], [fee7], [fee8], [fee9], [fee10]), 0)
		ELSE 0
	END), 0) AS [InvoicableFeeToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), [fee1], 0, 0, 0, 0, 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PAR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), [fee1], 0, 0, 0, 0, 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee1ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, [fee2], 0, 0, 0, 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PAR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, [fee2], 0, 0, 0, 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee2ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, [fee3], 0, 0, 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PAR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, [fee3], 0, 0, 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee3ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, [fee4], 0, 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PAR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, [fee4], 0, 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee4ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, [fee5], 0, 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PAR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, [fee5], 0, 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee5ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, [fee6], 0, 0, 0, 0), 0)
		WHEN [batchtype] = 'PAR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, [fee6], 0, 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee6ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, [fee7], 0, 0, 0), 0)
		WHEN [batchtype] = 'PAR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, [fee7], 0, 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee7ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, [fee8], 0, 0), 0)
		WHEN [batchtype] = 'PAR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, [fee8], 0, 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee8ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, 0, [fee9], 0), 0)
		WHEN [batchtype] = 'PAR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, 0, [fee9], 0), 0)
		ELSE 0
	END), 0) AS [InvoicableFee9ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN ISNULL([dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, 0, 0, [fee10]), 0)
		WHEN [batchtype] = 'PAR' THEN ISNULL(-[dbo].[DetermineInvoicedAmount](ISNULL([InvoiceFlags], '0000000000'), 0, 0, 0, 0, 0, 0, 0, 0, 0, [fee10]), 0)
		ELSE 0
	END), 0) AS [InvoicableFee10ToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN ISNULL([CollectorFee], 0)
		WHEN [batchtype] = 'PAR' THEN ISNULL(-[CollectorFee], 0)
		ELSE 0
	END), 0) AS [CollectorFeeToAgency],
	ISNULL(SUM(CASE
		WHEN [batchtype] = 'PA' THEN ISNULL([AIMAgencyFee], 0)
		WHEN [batchtype] = 'PAR' THEN ISNULL([AIMAgencyFee], 0)
		ELSE 0
	END), 0) AS [AgencyFeeToAgency]
FROM [dbo].[payhistory] WITH (NOLOCK)
WHERE [payhistory].[batchtype] LIKE 'P_%'
GROUP BY [number]

GO
