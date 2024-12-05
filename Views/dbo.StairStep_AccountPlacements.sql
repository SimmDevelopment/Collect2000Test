SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  VIEW [dbo].[StairStep_AccountPlacements]
AS
SELECT [master].[number] AS [AccountID],
	[dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1) AS [PlacementMonth],
	[master].[original] AS [GrossDollarsPlaced],
	ISNULL(SUM(ISNULL(CASE
		WHEN [payhistory].[batchtype] LIKE 'D_' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
		WHEN [payhistory].[batchtype] LIKE 'D_R' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
		ELSE 0
	END, 0)), 0) AS [Adjustments],
	[master].[original] +
	ISNULL(SUM(ISNULL(CASE
		WHEN [payhistory].[batchtype] LIKE 'D_' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
		WHEN [payhistory].[batchtype] LIKE 'D_R' THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
		ELSE 0
	END, 0)), 0) AS [NetDollarsPlaced]
FROM [dbo].[master] WITH (NOLOCK)
LEFT OUTER JOIN [dbo].[payhistory] WITH (NOLOCK)
ON [master].[number] = [payhistory].[number]
AND [payhistory].[batchtype] LIKE 'D_%'
GROUP BY [master].[number],
	[dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1),
	[master].[original]

GO
