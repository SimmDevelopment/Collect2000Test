SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[QueueEngine_CustomQueue_Complete] @TableID INTEGER, @AccountID INTEGER, @Done CHAR(1) = 'Y'
WITH RECOMPILE
AS
SET NOCOUNT ON;

DECLARE @user SYSNAME;
DECLARE @table SYSNAME;
DECLARE @sql NVARCHAR(4000);

SELECT @user = [sysusers].[name],
	@table = [sysobjects].[name]
FROM [dbo].[sysobjects]
INNER JOIN [dbo].[sysusers]
ON [sysobjects].[uid] = [sysusers].[uid]
WHERE [sysobjects].[id] = @TableID
AND [sysobjects].[type] = 'U';

IF @@ROWCOUNT = 0 BEGIN
	RETURN 0;
END;

SET @sql = N'UPDATE ' + QUOTENAME(@user) + '.' + QUOTENAME(@table) + ' WITH (ROWLOCK, XLOCK)
SET [Done] = @Done
WHERE [Number] = @AccountID;';

EXEC [dbo].[sp_executesql] @stmt = @sql, @params = N'@AccountID INTEGER, @Done CHAR(1)', @AccountID = @AccountID, @Done = @Done;

RETURN 0;

GO
