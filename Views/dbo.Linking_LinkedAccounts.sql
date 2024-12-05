SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[Linking_LinkedAccounts]
AS

SELECT [master].[number],
	[master].[link] AS [link],
	[linked].[number] AS [linked_number],
	CASE
		WHEN [master].[link] IS NOT NULL AND [master].[link] <> 0
		THEN CAST(1 AS BIT)
		ELSE CAST(0 AS BIT)
	END AS [linked],
	CASE
		WHEN [master].[link] IS NOT NULL AND [master].[link] <> 0
		THEN (
			SELECT TOP 1 [drivers].[number]
			FROM [dbo].[master] AS [drivers]
			WHERE [drivers].[link] = [master].[link]
			ORDER BY CASE
					WHEN [drivers].[qlevel] IN ('998', '999') THEN 0
					ELSE 1
				END DESC,
				[drivers].[LinkDriver] DESC,
				[drivers].[received] ASC
			)
		ELSE [master].[number]
	END AS [driver]
FROM [dbo].[master]
INNER JOIN [dbo].[master] AS [linked]
ON ([master].[link] IS NOT NULL
	AND [master].[link] <> 0
	AND [master].[link] = [linked].[link])
UNION ALL

SELECT [master].[number],
	[master].[link] AS [link],
	[master].[number] AS [linked_number],
	CAST(0 AS BIT)AS [linked],
	[master].[number] AS [driver]
FROM [dbo].[master]
WHERE [dbo].[master].[link] IS NULL 
OR [dbo].[master].[link] = 0


GO
