SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[User_CreateHistoryTable] @LoginName VARCHAR(10)
AS
SET NOCOUNT ON;

DECLARE @ObjectName SYSNAME;
DECLARE @SQL NVARCHAR(250);

SET @ObjectName = '[dbo].' + QUOTENAME('history' + RTRIM(@LoginName));
PRINT @ObjectName;

IF NOT EXISTS (SELECT * FROM [dbo].[sysobjects] WHERE [type] = 'U' AND [id] = OBJECT_ID(@ObjectName)) BEGIN
	SET @SQL = 'CREATE TABLE ' + @ObjectName + ' ([Number] INTEGER NOT NULL, [Name] VARCHAR(50) NULL, [TheDate] DATETIME NOT NULL);';
	PRINT @SQL;
	EXEC [dbo].[sp_executesql] @stmt = @SQL;
END;

RETURN 0;

GO
