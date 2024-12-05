SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Linking_FindQueuingConflicts]
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
	[Number] INTEGER NOT NULL,
	[QueueLevel] VARCHAR(3) NOT NULL,
	[LinkDriver] BIT NOT NULL,
	[DriverQueueLevel] VARCHAR(3) NULL,
	[FollowerQueueLevel] VARCHAR(3)
);
DECLARE @Index INTEGER;
DECLARE @Number INTEGER;
DECLARE @QueueLevel VARCHAR(3);
DECLARE @LinkDriver BIT;
DECLARE @DriverQueueLevel VARCHAR(3);
DECLARE @FollowerQueueLevel VARCHAR(3);

INSERT INTO #Conflicts ([Number], [QueueLevel], [LinkDriver], [DriverQueueLevel], [FollowerQueueLevel])
SELECT [master].[number], [master].[qlevel], [master].[LinkDriver], [Linking_EffectiveConfiguration].[DriverQueueLevel], [Linking_EffectiveConfiguration].[FollowerQueueLevel]
FROM [dbo].[master]
INNER JOIN #Linking_EffectiveConfiguration AS [Linking_EffectiveConfiguration]
ON [master].[customer] = [Linking_EffectiveConfiguration].[customer]
WHERE [master].[link] > 0
AND (([master].[LinkDriver] = 0
	AND NOT [master].[qlevel] IN ([Linking_EffectiveConfiguration].[FollowerQueueLevel], '998', '999')
	AND NOT [Linking_EffectiveConfiguration].[FollowerQueueLevel] = '')
OR ([master].[LinkDriver] = 1
	AND [master].[qlevel] = [Linking_EffectiveConfiguration].[FollowerQueueLevel]
	AND NOT [Linking_EffectiveConfiguration].[DriverQueueLevel] = ''));

SET @Index = 1;

WHILE EXISTS (SELECT * FROM #Conflicts WHERE [ID] = @Index) BEGIN
	SELECT @Number = [Number],
		@QueueLevel = [QueueLevel],
		@LinkDriver = [LinkDriver],
		@DriverQueueLevel = [DriverQueueLevel],
		@FollowerQueueLevel = [FollowerQueueLevel]
	FROM #Conflicts
	WHERE [ID] = @Index;

	IF @LinkDriver = 1 BEGIN
		UPDATE [dbo].[master]
		SET [qlevel] = @DriverQueueLevel,
			[ShouldQueue] = 1
		WHERE [master].[number] = @Number;
	END;
	ELSE BEGIN
		UPDATE [dbo].[master]
		SET [qlevel] = @FollowerQueueLevel,
			[ShouldQueue] = 0
		WHERE [master].[number] = @Number;
	END;

	SET @Index = @Index + 1;
END;

RETURN 0;

GO
