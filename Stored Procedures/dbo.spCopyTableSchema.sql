SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[spCopyTableSchema] 
@srctable NVARCHAR(256), 
@desttable NVARCHAR(256) 
AS 
DECLARE @TableID INTEGER 
SELECT @TableID = [id] 
From [sysobjects] 
WHERE [id] = OBJECT_ID(@srctable) AND OBJECTPROPERTY([id], N'IsUserTable') = 1 

IF @TableID IS NULL BEGIN 
	RAISERROR('User table %s does not exist.', 16, 1, @srctable) 
	RETURN -1 
End 

DECLARE @SQL VARCHAR(8000) 
DECLARE @columns TABLE
([colid] INTEGER PRIMARY KEY, 
 [name] varchar(100) NOT NULL,
 [type] varchar(100) NOT NULL,
 [status] INTEGER NOT NULL,
 [length] INTEGER NOT NULL,
 [isnullable] INTEGER NOT NULL,
 [default] VARCHAR(2000) NULL ) 
 INSERT INTO @columns ([colid], [name], [type], [status], [length], [isnullable], [default]) 
 SELECT [syscolumns].[colid] AS [colid], 
        [syscolumns].[name] AS [name], 
		[systypes].[name] AS [type], 
		[systypes].[status] AS [status], 
		[syscolumns].[length] AS [length], 
		[syscolumns].[isnullable] AS [isnullable], 
		[syscomments].[text] AS [default] 
From [syscolumns] 
INNER JOIN [systypes] 
ON [syscolumns].[xtype] = [systypes].[xtype] 
LEFT OUTER JOIN [sysconstraints] 
ON [sysconstraints].[id] = [syscolumns].[id] AND [sysconstraints].[colid] = [syscolumns].[colid]
LEFT OUTER JOIN [sysobjects] 
ON [sysconstraints].[constid] = [sysobjects].[id] AND [sysobjects].[xtype] = 'D' 
LEFT OUTER JOIN [syscomments] ON [syscomments].[id] = [sysobjects].[id]
WHERE [syscolumns].[id] = @TableID 
AND NOT ([syscolumns].[xtype] IN (56, 127) AND (NOT [syscolumns].[autoval] IS NULL OR COLUMNPROPERTY(@TableId, [syscolumns].[name], 'IsIdentity')=1))
ORDER BY [syscolumns].[colid] 

DECLARE cschema CURSOR LOCAL FORWARD_ONLY READ_ONLY STATIC FOR 
SELECT [name], [type], [status], [length], [isnullable], [default] 
FROM @columns ORDER BY [colid] 

OPEN cschema 
DECLARE @name varchar(100) 
DECLARE @type varchar(200)
DECLARE @status INTEGER 
DECLARE @length INTEGER 
DECLARE @isnullable INTEGER 
DECLARE @default VARCHAR(2000) 

FETCH NEXT FROM cschema INTO @name, @type, @status, @length, @isnullable, @default 

WHILE @@FETCH_STATUS = 0 BEGIN 
	IF @SQL IS NULL 
		SET @SQL = 'CREATE TABLE dbo.' + @desttable + '(' 
	Else 
		SET @SQL = @SQL + ',' 
	
	SET @SQL = @SQL + '[' + @name + '] ' + @type 
	
	IF @type IN ('char','nchar','varbinary','varchar','binary') 
		SET @SQL = @SQL + '(' + CAST(@length AS VARCHAR) + ')' 
	
	IF @isnullable = 0  
		SET @SQL = @SQL + ' NOT NULL' 
	
	IF NOT @default IS NULL  
		SET @SQL = @SQL + ' DEFAULT ' + @default 
		
	FETCH NEXT FROM cschema INTO @name, @type, @status, @length, @isnullable, @default 
End 
SET @SQL = @SQL + ')' 
Close cschema 
DEALLOCATE cschema 

EXECUTE (@SQL)

RETURN 0

GO
