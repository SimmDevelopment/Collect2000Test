SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Linking_FindDeskConflicts]
AS
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET NOCOUNT ON;
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET QUOTED_IDENTIFIER ON;
SET NUMERIC_ROUNDABORT OFF;

IF NOT OBJECT_ID('tempdb..#Linking_EffectiveConfiguration') IS NULL BEGIN
	DROP TABLE #Linking_EffectiveConfiguration;
END;

SELECT * INTO #Linking_EffectiveConfiguration FROM [dbo].[Linking_EffectiveConfiguration];

CREATE TABLE #Conflicts  (
	[ID] INTEGER NOT NULL IDENTITY(1, 1) PRIMARY KEY CLUSTERED,
	[LinkID] INTEGER NOT NULL
);
DECLARE @Index INTEGER;
DECLARE @Link INTEGER;

INSERT INTO #Conflicts ([LinkID])
SELECT [master].[link]
FROM [dbo].[master]
INNER JOIN [dbo].[desk]
ON [desk].[code] = [master].[desk]
LEFT OUTER JOIN #Linking_EffectiveConfiguration AS [Linking_EffectiveConfiguration]
ON [master].[customer] = [Linking_EffectiveConfiguration].[customer]
WHERE [master].[link] > 0
AND [master].[qlevel] < '998'
AND [desk].[desktype] = 'Collector'
AND NOT EXISTS (SELECT *
	FROM [dbo].[SupportQueueItems]
	INNER JOIN [dbo].[master] AS [linked]
	ON [SupportQueueItems].[AccountID] = [linked].[number]
	WHERE [linked].[link] = [master].[link]
	AND [SupportQueueItems].[QueueCode] = [Linking_EffectiveConfiguration].[DeskConflictSupervisorQueueLevel])
GROUP BY [master].[link]
HAVING COUNT(DISTINCT [desk].[code]) > 1;

SET @Index = 1;

WHILE EXISTS (SELECT * FROM #Conflicts WHERE [ID] = @Index) BEGIN
	SELECT @Link = [LinkID]
	FROM #Conflicts
	WHERE [ID] = @Index;

	EXEC [dbo].[Linking_ShuffleAccounts] @Link = @Link;

	SET @Index = @Index + 1;
END;

RETURN 0;

GO
