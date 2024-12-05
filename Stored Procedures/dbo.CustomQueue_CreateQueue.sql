SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[CustomQueue_CreateQueue] @QueueName VARCHAR(200), @Overwrite BIT = 0, @ObjectName SYSNAME OUTPUT, @QueueID INTEGER OUTPUT
AS
SET NOCOUNT ON;

DECLARE @IndexNumberName SYSNAME;
DECLARE @IndexDoneTZName SYSNAME;
DECLARE @SQL NVARCHAR(4000);

IF @QueueName IS NULL BEGIN
	RAISERROR('@QueueName can not be NULL.', 16, 1);
	RETURN 1;
END;
SET @QueueName = LTRIM(RTRIM(@QueueName));
IF LEN(@QueueName) = 0 BEGIN
	RAISERROR('@QueueName can not be an empty string.', 16, 1);
	RETURN 1;
END;
SET @ObjectName = '[dbo].' + QUOTENAME('tmp' + @QueueName);
SET @IndexNumberName = QUOTENAME('idx_CQ_' + @QueueName + '_Number');
SET @IndexDoneTZName = QUOTENAME('idx_CQ_' + @QueueName + '_Done_TZ');

IF EXISTS (SELECT * FROM [dbo].[sysobjects] WHERE [id] = OBJECT_ID(@ObjectName) AND OBJECTPROPERTY([id], N'IsUserTable') = 1) BEGIN
	IF @Overwrite = 0 BEGIN
		SET @QueueID = OBJECT_ID(@ObjectName);
		RETURN 0;
	END;
	SET @SQL = 'DROP TABLE ' + @ObjectName + ';';
	EXEC(@SQL);
END;

SET @SQL = 'CREATE TABLE ' + @ObjectName + ' ([Number] INTEGER NOT NULL, [Done] CHAR(1) NOT NULL DEFAULT(''N''), [Zipcode] VARCHAR(5) NULL, [SetFollowup] BIT NOT NULL DEFAULT(''0''), [LastAccessed] DATETIME NOT NULL DEFAULT(GETDATE()), [tz] ROWVERSION NOT NULL); CREATE INDEX ' + @IndexNumberName + ' ON ' + @ObjectName + ' ([Number] ASC); CREATE INDEX ' + @IndexDoneTZName + ' ON ' + @ObjectName + ' ([Done] ASC, [tz] ASC);';
EXECUTE(@SQL);
SET @QueueID = OBJECT_ID(@ObjectName);

RETURN 0;

GO
