SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[CustomQueue_GetQueueTotals] @QueueID INTEGER, @EnforceCollectorQueueRules BIT = 1
AS
SET NOCOUNT ON;

DECLARE @ObjectName SYSNAME;
DECLARE @SQL AS NVARCHAR(4000);

SELECT @ObjectName = QUOTENAME([sysusers].[name]) + '.' + QUOTENAME([sysobjects].[name])
FROM [dbo].[sysobjects]
INNER JOIN [dbo].[sysusers]
ON [sysobjects].[uid] = [sysusers].[uid]
WHERE [sysobjects].[type] = 'U'
AND [sysobjects].[id] = @QueueID;

IF @ObjectName IS NULL BEGIN
	SELECT CAST(0 AS BIGINT) AS [Total],
		CAST(0 AS BIGINT) AS [Available],
		CAST(0 AS BIGINT) AS [Completed],
		CAST(0 AS BIGINT) AS [ShouldNotQueue],
		CAST(0 AS BIGINT) AS [Worked];
	RETURN 0;
END;

IF @EnforceCollectorQueueRules = 1
	SET @SQL = N'SELECT CAST(COUNT_BIG(*) AS BIGINT) AS [Total],
	CAST(ISNULL(SUM(CASE
		WHEN [cq].[Done] = ''Y'' THEN 0
		WHEN [master].[qlevel] IN (''998'', ''999'') OR [master].[ShouldQueue] = 0 THEN 0
		WHEN [master].[worked] >= { fn CURDATE() } THEN 0
		ELSE 1
	END), 0) AS BIGINT) AS [Available],
	CAST(ISNULL(SUM(CASE
		WHEN [cq].[Done] = ''Y'' THEN 1
		ELSE 0
	END), 0) AS BIGINT) AS [Completed],
	CAST(ISNULL(SUM(CASE
		WHEN [cq].[Done] = ''Y'' THEN 0
		WHEN [master].[qlevel] IN (''998'', ''999'') OR [master].[ShouldQueue] = 0 THEN 1
		ELSE 0
	END), 0) AS BIGINT) AS [ShouldNotQueue],
	CAST(ISNULL(SUM(CASE
		WHEN [cq].[Done] = ''Y'' THEN 0
		WHEN [master].[qlevel] IN (''998'', ''999'') OR [master].[ShouldQueue] = 0 THEN 0
		WHEN [master].[worked] >= { fn CURDATE() } THEN 1
		ELSE 0
	END), 0) AS BIGINT) AS [Worked]
FROM ' + @ObjectName + ' AS [cq]
INNER JOIN [dbo].[master]
ON [cq].[Number] = [master].[number];';
ELSE
	SET @SQL = N'SELECT CAST(COUNT_BIG(*) AS BIGINT) AS [Total],
	CAST(ISNULL(SUM(CASE
		WHEN [cq].[Done] = ''Y'' THEN 0
		WHEN [master].[worked] >= { fn CURDATE() } THEN 0
		ELSE 1
	END), 0) AS BIGINT) AS [Available],
	CAST(ISNULL(SUM(CASE
		WHEN [cq].[Done] = ''Y'' THEN 1
		ELSE 0
	END), 0) AS BIGINT) AS [Completed],
	CAST(0 AS BIGINT) AS [ShouldNotQueue],
	CAST(ISNULL(SUM(CASE
		WHEN [cq].[Done] = ''Y'' THEN 0
		WHEN [master].[worked] >= { fn CURDATE() } THEN 1
		ELSE 0
	END), 0) AS BIGINT) AS [Worked]
FROM ' + @ObjectName + ' AS [cq]
INNER JOIN [dbo].[master]
ON [cq].[Number] = [master].[number];';

EXEC (@SQL);

RETURN 0;


GO
