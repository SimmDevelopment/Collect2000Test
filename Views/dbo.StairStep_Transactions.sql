SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[StairStep_Transactions]
WITH SCHEMABINDING
AS
SELECT [payhistory].[customer] AS [Customer],
	[dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1) AS [PlacementMonth],
	[dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1) AS [TransactionMonth],
	COUNT_BIG(*) AS [Transactions],
	SUM(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_R'
		THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
		ELSE ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
	END) AS [Paid],
	SUM(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_R'
		THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
		ELSE ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
	END) AS [Fee],
	SUM(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_R'
		THEN -([payhistory].[paid1])
		ELSE ([payhistory].[paid1])
	END) AS [PrincipalPaid],
	SUM(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_R'
		THEN -([payhistory].[fee1])
		ELSE ([payhistory].[fee1])
	END) AS [PrincipalFee],
	SUM(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_R'
		THEN -(CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 1, 1) NOT IN ('', '0') THEN [payhistory].[paid1] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 2, 1) NOT IN ('', '0') THEN [payhistory].[paid2] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 3, 1) NOT IN ('', '0') THEN [payhistory].[paid3] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 4, 1) NOT IN ('', '0') THEN [payhistory].[paid4] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 5, 1) NOT IN ('', '0') THEN [payhistory].[paid5] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 6, 1) NOT IN ('', '0') THEN [payhistory].[paid6] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 7, 1) NOT IN ('', '0') THEN [payhistory].[paid7] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 8, 1) NOT IN ('', '0') THEN [payhistory].[paid8] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 9, 1) NOT IN ('', '0') THEN [payhistory].[paid9] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 10, 1) NOT IN ('', '0') THEN [payhistory].[paid10] ELSE 0 END)
		ELSE (CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 1, 1) NOT IN ('', '0') THEN [payhistory].[paid1] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 2, 1) NOT IN ('', '0') THEN [payhistory].[paid2] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 3, 1) NOT IN ('', '0') THEN [payhistory].[paid3] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 4, 1) NOT IN ('', '0') THEN [payhistory].[paid4] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 5, 1) NOT IN ('', '0') THEN [payhistory].[paid5] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 6, 1) NOT IN ('', '0') THEN [payhistory].[paid6] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 7, 1) NOT IN ('', '0') THEN [payhistory].[paid7] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 8, 1) NOT IN ('', '0') THEN [payhistory].[paid8] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 9, 1) NOT IN ('', '0') THEN [payhistory].[paid9] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 10, 1) NOT IN ('', '0') THEN [payhistory].[paid10] ELSE 0 END)
	END) AS [InvoicablePaid],
	SUM(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_R'
		THEN -(CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 1, 1) NOT IN ('', '0') THEN [payhistory].[fee1] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 2, 1) NOT IN ('', '0') THEN [payhistory].[fee2] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 3, 1) NOT IN ('', '0') THEN [payhistory].[fee3] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 4, 1) NOT IN ('', '0') THEN [payhistory].[fee4] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 5, 1) NOT IN ('', '0') THEN [payhistory].[fee5] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 6, 1) NOT IN ('', '0') THEN [payhistory].[fee6] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 7, 1) NOT IN ('', '0') THEN [payhistory].[fee7] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 8, 1) NOT IN ('', '0') THEN [payhistory].[fee8] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 9, 1) NOT IN ('', '0') THEN [payhistory].[fee9] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 10, 1) NOT IN ('', '0') THEN [payhistory].[fee10] ELSE 0 END)
		ELSE (CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 1, 1) NOT IN ('', '0') THEN [payhistory].[fee1] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 2, 1) NOT IN ('', '0') THEN [payhistory].[fee2] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 3, 1) NOT IN ('', '0') THEN [payhistory].[fee3] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 4, 1) NOT IN ('', '0') THEN [payhistory].[fee4] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 5, 1) NOT IN ('', '0') THEN [payhistory].[fee5] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 6, 1) NOT IN ('', '0') THEN [payhistory].[fee6] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 7, 1) NOT IN ('', '0') THEN [payhistory].[fee7] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 8, 1) NOT IN ('', '0') THEN [payhistory].[fee8] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 9, 1) NOT IN ('', '0') THEN [payhistory].[fee9] ELSE 0 END +
			CASE WHEN SUBSTRING([payhistory].[InvoiceFlags], 10, 1) NOT IN ('', '0') THEN [payhistory].[fee10] ELSE 0 END)
	END) AS [InvoicableFee]
FROM [dbo].[payhistory] WITH (NOLOCK)
INNER JOIN [dbo].[master] WITH (NOLOCK)
ON [payhistory].[number] = [master].[number]
INNER JOIN [dbo].[status] WITH (NOLOCK)
ON [master].[status] = [status].[code]
WHERE [payhistory].[batchtype] LIKE 'P_%'
AND [status].[ReduceStats] = 0
GROUP BY [payhistory].[customer],master.sysyear, master.sysmonth, payhistory.systemyear, payhistory.systemmonth
	--[dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1),
	--[dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)
GO
