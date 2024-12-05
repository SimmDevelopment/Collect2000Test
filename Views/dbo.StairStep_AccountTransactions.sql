SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  VIEW [dbo].[StairStep_AccountTransactions]
AS
SELECT [master].[number] AS [AccountID],
	[dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1) AS [PlacementMonth],
	ISNULL(SUM(ISNULL(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
		WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
		ELSE 0
	END, 0)), 0) AS [Total],
	ISNULL(SUM(ISNULL(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
		WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
		ELSE 0
	END, 0)), 0) AS [TotalFee],
	ISNULL(SUM(ISNULL(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
		WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
		ELSE 0
	END, 0)), 0) AS [InvoicableTotal],
	ISNULL(SUM(ISNULL(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
		WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
		ELSE 0
	END, 0)), 0) AS [InvoicableTotalFee],
	ISNULL(SUM(ISNULL(CASE
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1), [ControlFile].[CurrentMonth]) <= 0
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CurrentMonth],
	ISNULL(SUM(ISNULL(CASE
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1), [ControlFile].[CurrentMonth]) <= 0
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CurrentMonthFee],
	ISNULL(SUM(ISNULL(CASE
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1), [ControlFile].[CurrentMonth]) <= 0
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableCurrentMonth],
	ISNULL(SUM(ISNULL(CASE
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1), [ControlFile].[CurrentMonth]) <= 0
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableCurrentMonthFee],
	ISNULL(SUM(ISNULL(CASE
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1), [ControlFile].[CurrentMonth]) = 1
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [LastMonth],
	ISNULL(SUM(ISNULL(CASE
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1), [ControlFile].[CurrentMonth]) = 1
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [LastMonthFee],
	ISNULL(SUM(ISNULL(CASE
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1), [ControlFile].[CurrentMonth]) = 1
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableLastMonth],
	ISNULL(SUM(ISNULL(CASE
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1), [ControlFile].[CurrentMonth]) = 1
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableLastMonthFee],
	ISNULL(SUM(ISNULL(CASE
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) <= 0
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month1],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 1
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month2],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 2
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month3],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 3
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month4],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 4
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month5],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 5
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month6],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 6
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0

	END, 0)), 0) AS [Month7],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 7
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month8],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 8
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month9],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 9
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month10],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 10
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month11],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 11
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month12],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 12
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month13],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 13
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month14],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 14
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month15],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 15
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month16],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 16
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month17],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 17
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month18],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 18
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month19],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 19
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month20],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 20
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month21],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 21
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month22],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 22
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month23],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 23
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month24],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) > 23
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month99],
	ISNULL(SUM(ISNULL(CASE
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) <= 0
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month1Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 1
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month2Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 2
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month3Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 3
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month4Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 4
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month5Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 5
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month6Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 6
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0

	END, 0)), 0) AS [Month7Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 7
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month8Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 8
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month9Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 9
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month10Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 10
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month11Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 11
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month12Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 12
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month13Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 13
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month14Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 14
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month15Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 15
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month16Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 16
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month17Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 17
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month18Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 18
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month19Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 19
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month20Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 20
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month21Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 21
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month22Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 22
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month23Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 23
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month24Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) > 23
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [Month99Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 1
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth1],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 2
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth2],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 3
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth3],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 4
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth4],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 5
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth5],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 6
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth6],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 7
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth7],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 8
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth8],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 9
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth9],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 10
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth10],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 11
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth11],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 12
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth12],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 13
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth13],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 14
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth14],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 15
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth15],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 16
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth16],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 17
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth17],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 18
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth18],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 19
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth19],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 20
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth20],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 21
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth21],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 22
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth22],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 23
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth23],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 24
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth24],
	ISNULL(SUM(ISNULL(CASE 
		WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
		WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth99],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 1
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth1Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 2
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth2Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 3
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth3Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 4
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth4Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 5
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth5Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 6
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth6Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 7
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth7Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 8
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth8Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 9
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth9Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 10
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth10Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 11
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth11Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 12
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth12Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 13
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth13Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 14
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth14Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 15
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth15Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 16

		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth16Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 17
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth17Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 18
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth18Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 19
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth19Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 20
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth20Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 21
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth21Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 22
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth22Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 23
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth23Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 24
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth24Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN [payhistory].[batchtype] LIKE 'P_' THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
		WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
		ELSE 0
	END, 0)), 0) AS [CumulativeMonth99Fee],
	ISNULL(SUM(ISNULL(CASE
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) <= 0
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth1],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 1
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth2],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 2
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth3],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))

		WHEN 3
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth4],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 4
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth5],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 5
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth6],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 6
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth7],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 7
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth8],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 8
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth9],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 9
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth10],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 10
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth11],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 11
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth12],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 12
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth13],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 13
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth14],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 14
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth15],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 15
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth16],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 16
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth17],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 17
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth18],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 18
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth19],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 19
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth20],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 20
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth21],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 21
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth22],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 22
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth23],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 23
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth24],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) > 23
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth99],
	ISNULL(SUM(ISNULL(CASE
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) <= 0
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth1Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 1
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth2Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 2
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth3Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 3
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth4Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 4
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth5Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 5
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth6Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 6
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth7Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 7
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth8Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 8
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth9Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 9
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth10Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 10
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth11Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 11
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth12Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 12
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth13Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 13
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth14Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 14
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth15Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 15
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth16Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 16
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth17Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 17
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth18Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 18
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth19Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 19
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth20Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 20
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth21Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 21
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth22Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 22
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth23Fee],
	ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1))
		WHEN 23
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth24Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) > 23
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [InvoicableMonth99Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 1
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth1],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 2
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth2],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 3
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth3],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 4
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth4],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 5
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth5],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 6
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth6],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 7
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth7],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 8
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth8],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 9
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth9],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 10
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth10],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 11
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth11],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 12
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth12],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 13
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth13],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 14
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth14],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 15
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth15],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 16
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth16],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 17
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth17],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 18
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth18],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 19
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth19],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 20
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth20],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 21
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth21],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 22
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth22],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 23
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth23],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 24
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth24],
	ISNULL(SUM(ISNULL(CASE 
		WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
		WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[paid1], [payhistory].[paid2], [payhistory].[paid3], [payhistory].[paid4], [payhistory].[paid5], [payhistory].[paid6], [payhistory].[paid7], [payhistory].[paid8], [payhistory].[paid9], [payhistory].[paid10])
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth99],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 1
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth1Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 2
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth2Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 3
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth3Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 4
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth4Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 5
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth5Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 6
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth6Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 7
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth7Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 8
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth8Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 9
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth9Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 10
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth10Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 11
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth11Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 12
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth12Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 13
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth13Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 14
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth14Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 15
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth15Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 16
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth16Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 17
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth17Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 18
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth18Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 19
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth19Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 20
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth20Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 21
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth21Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 22
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth22Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 23
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth23Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN DATEDIFF(MONTH, [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1), [dbo].[DateSerial]([payhistory].[systemyear], [payhistory].[systemmonth], 1)) < 24
		THEN CASE
			WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
			ELSE 0
		END
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth24Fee],
	ISNULL(SUM(ISNULL(CASE 
		WHEN [payhistory].[batchtype] LIKE 'P_' THEN [dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
		WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -[dbo].[DetermineInvoicedAmount](ISNULL([payhistory].[InvoiceFlags], '0000000000'), [payhistory].[fee1], [payhistory].[fee2], [payhistory].[fee3], [payhistory].[fee4], [payhistory].[fee5], [payhistory].[fee6], [payhistory].[fee7], [payhistory].[fee8], [payhistory].[fee9], [payhistory].[fee10])
		ELSE 0
	END, 0)), 0) AS [CumulativeInvoicableMonth99Fee]
FROM [dbo].[master] WITH (NOLOCK)
CROSS JOIN [dbo].[GetCurrentMonthTable]() AS [ControlFile]
LEFT OUTER JOIN [dbo].[payhistory] WITH (NOLOCK)
ON [master].[number] = [payhistory].[number]
AND [payhistory].[batchtype] LIKE 'P_%'
GROUP BY [master].[number],
	[master].[customer],
	[dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1)



GO
