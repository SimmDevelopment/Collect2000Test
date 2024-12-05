SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[StairStep_Placements]
WITH SCHEMABINDING
AS
SELECT [master].[customer] AS [Customer],
	[dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1) AS [PlacementMonth],
	COUNT_BIG(*) AS [AccountsPlaced],
	SUM([master].[original]) AS [GrossDollarsPlaced]
FROM [dbo].[master] WITH (NOLOCK)
INNER JOIN [dbo].[status] WITH (NOLOCK)
ON [master].[status] = [status].[code]
WHERE [status].[ReduceStats] = 0
GROUP BY [master].[customer],sysyear, sysmonth
	--[dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1)
GO
