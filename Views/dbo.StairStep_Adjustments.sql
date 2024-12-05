SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[StairStep_Adjustments]
WITH SCHEMABINDING
AS
SELECT [payhistory].[customer] AS [Customer],
	[dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1) AS [PlacementMonth],
	COUNT_BIG(*) AS [AdjustmentTransactions],
	SUM(CASE
		WHEN [payhistory].[batchtype] LIKE '__R'
		THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
		ELSE -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
	END) AS [AmountAdjusted]
FROM [dbo].[payhistory] WITH (NOLOCK)
INNER JOIN [dbo].[master] WITH (NOLOCK)
ON [payhistory].[number] = [master].[number]
INNER JOIN [dbo].[status]
ON [master].[status] = [status].[code]
WHERE [payhistory].[batchtype] LIKE 'D%'
AND [status].[ReduceStats] = 0
GROUP BY [payhistory].[customer], sysyear, sysmonth
--	[dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1)
GO
