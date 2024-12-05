SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[QueueEngine_CollectorQueue_GetDeskTotals] @desk VARCHAR(10), @RestrictedAccess BIT = 0, @customers TEXT = NULL
WITH RECOMPILE
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 
IF @customers IS NULL OR DATALENGTH(@customers) = 0
	IF @RestrictedAccess = 1
		SELECT CAST([master].[qdate] AS DATETIME) AS [QueueDate],
			CASE
				WHEN [master].[qlevel] LIKE '?__' THEN '599'
				ELSE [master].[qlevel]
			END AS [QueueCode],
			CASE
				WHEN [master].[qlevel] LIKE '?__' OR [master].[qlevel] = '599' THEN 'ACCOUNT WORKED'
				WHEN [qlevel].[QName] IS NULL THEN 'UNKNOWN QUEUE'
				ELSE [qlevel].[QName]
			END AS [QueueName],
			CASE [master].[qtime]
				WHEN '0600' THEN '0600'
				WHEN '1200' THEN '1200'
				WHEN '1800' THEN '1800'
				ELSE '0000'
			END AS [QueueTime],
			COUNT(*) AS [Accounts],
			SUM([master].[current0]) AS [Balance],
			SUM(CASE
				WHEN [master].[worked] >= CAST({ fn CURDATE() } AS DATETIME)
				THEN 1
				ELSE 0
			END) AS [Worked]
		FROM [dbo].[master]
		LEFT OUTER JOIN [dbo].[QLevel]
		ON [master].[qlevel] = [QLevel].[code]
		WHERE [master].[desk] = @desk
		AND [master].[qlevel] LIKE '[0-9?][0-9][0-9]'
		AND [master].[qlevel] NOT IN ('000', '998', '999')
		AND ISDATE([master].[qdate]) = 1
		AND [master].[ShouldQueue] = 1
		AND [master].[current0] > 0.00
		AND [master].[number] in (
				select number from CallPreferences WITH (NOLOCK)
				WHERE [CallPreferences].[When] = 'Today' AND [CallPreferences].DoNotCall = 0 AND [CallPreferences].AllowedToday = 1
		)
		GROUP BY CAST([master].[qdate] AS DATETIME),
			CASE
				WHEN [master].[qlevel] LIKE '?__' THEN '599'
				ELSE [master].[qlevel]
			END,
			CASE
				WHEN [master].[qlevel] LIKE '?__' OR [master].[qlevel] = '599' THEN 'ACCOUNT WORKED'
				WHEN [qlevel].[QName] IS NULL THEN 'UNKNOWN QUEUE'
				ELSE [qlevel].[QName]
			END,
			CASE [master].[qtime]
				WHEN '0600' THEN '0600'
				WHEN '1200' THEN '1200'
				WHEN '1800' THEN '1800'
				ELSE '0000'
			END;
	ELSE
		SELECT CAST([master].[qdate] AS DATETIME) AS [QueueDate],
			CASE
				WHEN [master].[qlevel] LIKE '?__' THEN '599'
				ELSE [master].[qlevel]
			END AS [QueueCode],
			CASE
				WHEN [master].[qlevel] LIKE '?__' OR [master].[qlevel] = '599' THEN 'ACCOUNT WORKED'
				WHEN [qlevel].[QName] IS NULL THEN 'UNKNOWN QUEUE'
				ELSE [qlevel].[QName]
			END AS [QueueName],
			CASE [master].[qtime]
				WHEN '0600' THEN '0600'
				WHEN '1200' THEN '1200'
				WHEN '1800' THEN '1800'
				ELSE '0000'
			END AS [QueueTime],
			COUNT(*) AS [Accounts],
			SUM([master].[current0]) AS [Balance],
			SUM(CASE
				WHEN [master].[worked] >= CAST({ fn CURDATE() } AS DATETIME)
				THEN 1
				ELSE 0
			END) AS [Worked]
		FROM [dbo].[master]
		LEFT OUTER JOIN [dbo].[QLevel]
		ON [master].[qlevel] = [QLevel].[code]
		WHERE [master].[desk] = @desk
		AND [master].[qlevel] LIKE '[0-9?][0-9][0-9]'
		AND [master].[qlevel] NOT IN ('000', '998', '999')
		AND ISDATE([master].[qdate]) = 1
		AND [master].[ShouldQueue] = 1
		AND [master].[RestrictedAccess] = 0
		AND [master].[current0] > 0.00
		AND [master].[number] in (
				select number from CallPreferences WITH (NOLOCK)
				WHERE [CallPreferences].[When] = 'Today' AND [CallPreferences].DoNotCall = 0 AND [CallPreferences].AllowedToday = 1
		)
		GROUP BY CAST([master].[qdate] AS DATETIME),
			CASE
				WHEN [master].[qlevel] LIKE '?__' THEN '599'
				ELSE [master].[qlevel]
			END,
			CASE
				WHEN [master].[qlevel] LIKE '?__' OR [master].[qlevel] = '599' THEN 'ACCOUNT WORKED'
				WHEN [qlevel].[QName] IS NULL THEN 'UNKNOWN QUEUE'
				ELSE [qlevel].[QName]
			END,
			CASE [master].[qtime]
				WHEN '0600' THEN '0600'
				WHEN '1200' THEN '1200'
				WHEN '1800' THEN '1800'
				ELSE '0000'
			END;
 
ELSE BEGIN
	DECLARE @CustomerTable TABLE (
		[Customer] VARCHAR(7) NOT NULL
	);
 
	INSERT INTO @CustomerTable ([Customer])
	SELECT [value]
	FROM [dbo].[fnExtractFixedStrings](@customers, 7);
 
	IF @RestrictedAccess = 1
		SELECT CAST([master].[qdate] AS DATETIME) AS [QueueDate],
			CASE
				WHEN [master].[qlevel] LIKE '?__' THEN '599'
				ELSE [master].[qlevel]
			END AS [QueueCode],
			CASE
				WHEN [master].[qlevel] LIKE '?__' OR [master].[qlevel] = '599' THEN 'ACCOUNT WORKED'
				WHEN [qlevel].[QName] IS NULL THEN 'UNKNOWN QUEUE'
				ELSE [qlevel].[QName]
			END AS [QueueName],
			CASE [master].[qtime]
				WHEN '0600' THEN '0600'
				WHEN '1200' THEN '1200'
				WHEN '1800' THEN '1800'
				ELSE '0000'
			END AS [QueueTime],
			COUNT(*) AS [Accounts],
			SUM([master].[current0]) AS [Balance],
			SUM(CASE
				WHEN [master].[worked] >= CAST({ fn CURDATE() } AS DATETIME)
				THEN 1
				ELSE 0
			END) AS [Worked]
		FROM [dbo].[master]
		INNER JOIN @CustomerTable AS [CustomerTable]
		ON [master].[customer] = [CustomerTable].[Customer]
		LEFT OUTER JOIN [dbo].[QLevel]
		ON [master].[qlevel] = [QLevel].[code]
		WHERE [master].[desk] = @desk
		AND [master].[qlevel] LIKE '[0-9?][0-9][0-9]'
		AND [master].[qlevel] NOT IN ('000', '998', '999')
		AND ISDATE([master].[qdate]) = 1
		AND [master].[ShouldQueue] = 1
		AND [master].[current0] > 0.00
		AND [master].[number] in (
				select number from CallPreferences WITH (NOLOCK)
				WHERE [CallPreferences].[When] = 'Today' AND [CallPreferences].DoNotCall = 0 AND [CallPreferences].AllowedToday = 1
		)
		GROUP BY CAST([master].[qdate] AS DATETIME),
			CASE
				WHEN [master].[qlevel] LIKE '?__' THEN '599'
				ELSE [master].[qlevel]
			END,
			CASE
				WHEN [master].[qlevel] LIKE '?__' OR [master].[qlevel] = '599' THEN 'ACCOUNT WORKED'
				WHEN [qlevel].[QName] IS NULL THEN 'UNKNOWN QUEUE'
				ELSE [qlevel].[QName]
			END,
			CASE [master].[qtime]
				WHEN '0600' THEN '0600'
				WHEN '1200' THEN '1200'
				WHEN '1800' THEN '1800'
				ELSE '0000'
			END;
	ELSE
		SELECT CAST([master].[qdate] AS DATETIME) AS [QueueDate],
			CASE
				WHEN [master].[qlevel] LIKE '?__' THEN '599'
				ELSE [master].[qlevel]
			END AS [QueueCode],
			CASE
				WHEN [master].[qlevel] LIKE '?__' OR [master].[qlevel] = '599' THEN 'ACCOUNT WORKED'
				WHEN [qlevel].[QName] IS NULL THEN 'UNKNOWN QUEUE'
				ELSE [qlevel].[QName]
			END AS [QueueName],
			CASE [master].[qtime]
				WHEN '0600' THEN '0600'
				WHEN '1200' THEN '1200'
				WHEN '1800' THEN '1800'
				ELSE '0000'
			END AS [QueueTime],
			COUNT(*) AS [Accounts],
			SUM([master].[current0]) AS [Balance],
			SUM(CASE
				WHEN [master].[worked] >= CAST({ fn CURDATE() } AS DATETIME)
				THEN 1
				ELSE 0
			END) AS [Worked]
		FROM [dbo].[master]
		INNER JOIN @CustomerTable AS [CustomerTable]
		ON [master].[customer] = [CustomerTable].[Customer]
		LEFT OUTER JOIN [dbo].[QLevel]
		ON [master].[qlevel] = [QLevel].[code]
		WHERE [master].[desk] = @desk
		AND [master].[qlevel] LIKE '[0-9?][0-9][0-9]'
		AND [master].[qlevel] NOT IN ('000', '998', '999')
		AND ISDATE([master].[qdate]) = 1
		AND [master].[ShouldQueue] = 1
		AND [master].[RestrictedAccess] = 0
		AND [master].[current0] > 0.00
		AND [master].[number] in (
				select number from CallPreferences WITH (NOLOCK)
				WHERE [CallPreferences].[When] = 'Today' AND [CallPreferences].DoNotCall = 0 AND [CallPreferences].AllowedToday = 1
		)
		GROUP BY CAST([master].[qdate] AS DATETIME),
			CASE
				WHEN [master].[qlevel] LIKE '?__' THEN '599'
				ELSE [master].[qlevel]
			END,
			CASE
				WHEN [master].[qlevel] LIKE '?__' OR [master].[qlevel] = '599' THEN 'ACCOUNT WORKED'
				WHEN [qlevel].[QName] IS NULL THEN 'UNKNOWN QUEUE'
				ELSE [qlevel].[QName]
			END,
			CASE [master].[qtime]
				WHEN '0600' THEN '0600'
				WHEN '1200' THEN '1200'
				WHEN '1800' THEN '1800'
				ELSE '0000'
			END;
END;
 
RETURN 0;
 
GO
