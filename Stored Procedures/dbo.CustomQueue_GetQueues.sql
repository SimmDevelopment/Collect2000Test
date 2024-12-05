SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[CustomQueue_GetQueues]
AS
SET NOCOUNT ON;

SELECT [sysobjects].[id] AS [QueueID],
	SUBSTRING([sysobjects].[name], 4, 255) AS [QueueName],
	QUOTENAME([sysusers].[name]) + '.' + QUOTENAME([sysobjects].[name]) AS [ObjectName],
	[sysobjects].[crdate] AS [CreatedDate]
FROM [dbo].[sysobjects]
INNER JOIN [dbo].[sysusers]
ON [sysobjects].[uid] = [sysusers].[uid]
WHERE [sysobjects].[type] = 'U'
AND [sysobjects].[name] LIKE 'tmp%'
AND EXISTS (SELECT *
	FROM [dbo].[syscolumns]
	INNER JOIN [dbo].[systypes]
	ON [syscolumns].[xtype] = [systypes].[xtype]
	WHERE [syscolumns].[id] = [sysobjects].[id]
	AND [syscolumns].[name] = 'Number'
	AND [systypes].[name] = 'int')
AND EXISTS (SELECT *
	FROM [dbo].[syscolumns]
	INNER JOIN [dbo].[systypes]
	ON [syscolumns].[xtype] = [systypes].[xtype]
	WHERE [syscolumns].[id] = [sysobjects].[id]
	AND [syscolumns].[name] = 'DONE'
	AND [systypes].[name] IN ('char', 'nchar', 'varchar', 'nvarchar'))
AND EXISTS (SELECT *
	FROM [dbo].[syscolumns]
	INNER JOIN [dbo].[systypes]
	ON [syscolumns].[xtype] = [systypes].[xtype]
	WHERE [syscolumns].[id] = [sysobjects].[id]
	AND [syscolumns].[name] = 'SetFollowUp'
	AND [systypes].[name] = 'bit')
AND EXISTS (SELECT *
	FROM [dbo].[syscolumns]
	INNER JOIN [dbo].[systypes]
	ON [syscolumns].[xtype] = [systypes].[xtype]
	WHERE [syscolumns].[id] = [sysobjects].[id]
	AND [syscolumns].[name] = 'LastAccessed'
	AND [systypes].[name] = 'datetime')
ORDER BY [QueueName];

RETURN 0;


GO
