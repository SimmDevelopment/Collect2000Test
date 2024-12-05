SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[QueueEngine_CustomQueue_MoveNext] @TableID INTEGER, @RestrictedAccess BIT = 0, @EnforceCollectorQueueRules BIT = 1, @EnforceTimeZoneRules BIT = 1, @AccountID INTEGER OUTPUT, @SetFollowUp BIT OUTPUT, @Remaining INTEGER OUTPUT
WITH RECOMPILE
AS
SET NOCOUNT ON;

DECLARE @user SYSNAME;
DECLARE @table SYSNAME;
DECLARE @index SYSNAME;
DECLARE @TimeZoneSQL NVARCHAR(4000);
DECLARE @CollectorRulesSQL NVARCHAR(4000);
DECLARE @sql NVARCHAR(4000);
DECLARE @UTC DATETIME;

SELECT @user = [sysusers].[name],
	@table = [sysobjects].[name]
FROM [dbo].[sysobjects]
INNER JOIN [dbo].[sysusers]
ON [sysobjects].[uid] = [sysusers].[uid]
WHERE [sysobjects].[id] = @TableID
AND [sysobjects].[type] = 'U';

IF @@ROWCOUNT = 0 BEGIN
	SET @Remaining = 0;
	RETURN 0;
END;

IF NOT EXISTS (SELECT * FROM [dbo].[syscolumns] WHERE [syscolumns].[id] = @TableID AND [syscolumns].[name] = 'tz') BEGIN
	SET @index = QUOTENAME('idx_CQ_' + @table + '_Done_TZ');
	SET @sql = 'ALTER TABLE ' + QUOTENAME(@user) + '.' + QUOTENAME(@table) + ' ADD [tz] ROWVERSION NOT NULL; CREATE INDEX ' + @index + ' ON ' + QUOTENAME(@user) + '.' + QUOTENAME(@table) + ' ([Done] ASC, [tz] ASC);';
	EXEC [dbo].[sp_executesql] @stmt = @sql;
END;

SET @EnforceCollectorQueueRules = ISNULL(@EnforceCollectorQueueRules, 1);
SET @EnforceTimeZoneRules = ISNULL(@EnforceTimeZoneRules, 1);

IF @EnforceCollectorQueueRules = 1
	SET @CollectorRulesSQL = 'AND [master].[qlevel] BETWEEN ''001'' AND ''598''
AND [master].[ShouldQueue] = 1
AND ([master].[RestrictedAccess] = 0
	OR @RestrictedAccess = 1)
AND ([master].[contacted] IS NULL
	OR [master].[contacted] < { fn CURDATE() })';
ELSE
	SET @CollectorRulesSQL = '';

IF @EnforceTimeZoneRules = 1
	SET @TimeZoneSQL = 'AND EXISTS (SELECT *
	FROM [dbo].[Debtors]
	INNER JOIN [dbo].[GetCallableTimeZones](@UTC) AS [Callable]
	ON CASE WHEN DATEPART(HOUR, GETUTCDATE()) BETWEEN 6 AND 18
		THEN [Debtors].[EarlyTimeZone]
		ELSE [Debtors].[LateTimeZone]
	END = [Callable].[TimeZone]
	OR ([Debtors].[EarlyTimeZone] IS NULL
		AND [Callable].[TimeZone] IS NULL)
	WHERE [Debtors].[Number] = [master].[number])';
ELSE
	SET @TimeZoneSQL = '';

SET @sql = 'BEGIN TRANSACTION;

SELECT TOP 1 @AccountID = [master].[number],
	@SetFollowUp = [CQ].[SetFollowUp]
FROM [dbo].[master] WITH (NOLOCK)
INNER JOIN ' + QUOTENAME(@user) + '.' + QUOTENAME(@table) + ' AS [CQ] WITH (ROWLOCK, UPDLOCK)
ON [master].[number] = [CQ].[Number]
WHERE [CQ].[Done] = ''N''
AND ([master].[RestrictedAccess] = 0
	OR @RestrictedAccess = 1)
AND ([master].[QueueHold] IS NULL
	OR [master].[QueueHold] < { fn CURDATE() })
' + @CollectorRulesSQL + '
' + @TimeZoneSQL + '
ORDER BY [CQ].[tz] ASC;

IF @AccountID IS NOT NULL
	UPDATE ' + QUOTENAME(@user) + '.' + QUOTENAME(@table) + '
	SET [Done] = ''Q'',
		[LastAccessed] = GETDATE()
	WHERE [Number] = @AccountID;

COMMIT TRANSACTION;

SELECT @Remaining = COUNT(*)
FROM [dbo].[master] WITH (NOLOCK)
INNER JOIN ' + QUOTENAME(@user) + '.' + QUOTENAME(@table) + ' AS [CQ] WITH (NOLOCK)
ON [master].[number] = [CQ].[Number]
WHERE [CQ].[Done] = ''N''
' + @CollectorRulesSQL + ';';

SET @UTC = GETUTCDATE();

EXEC [dbo].[sp_executesql] @stmt = @sql, @params = N'@UTC DATETIME, @RestrictedAccess BIT, @AccountID INTEGER OUTPUT, @SetFollowUp BIT OUTPUT, @Remaining INTEGER OUTPUT', @UTC = @UTC, @RestrictedAccess = @RestrictedAccess, @AccountID = @AccountID OUTPUT, @SetFollowUp = @SetFollowUp OUTPUT, @Remaining = @Remaining OUTPUT;

RETURN 0;

GO
