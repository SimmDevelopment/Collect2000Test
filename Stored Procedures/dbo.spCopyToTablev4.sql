SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*spCopyToTablev4*/
CREATE   PROCEDURE [dbo].[spCopyToTablev4] @srctable VARCHAR(256), @desttable VARCHAR(256) 
AS 
DECLARE @columns TABLE ( [Name] VARCHAR(256) ) -- Select all column names from the destination table that are not an identity column 
INSERT INTO @columns ([Name]) 
SELECT [name] 
FROM [syscolumns] 
WHERE [id] = OBJECT_ID(@desttable) 
AND NOT ([xtype] = 56 AND (NOT [autoval] IS NULL OR COLUMNPROPERTY(OBJECT_ID(@desttable), [syscolumns].[name], 'IsIdentity')=1))
AND [iscomputed] = 0

DECLARE @name VARCHAR(256)
DECLARE @columnnames VARCHAR(2500) 
SET @columnnames = '' -- Loop through the column names to generate an SQL string that contains the names comma seperated 
DECLARE cnames CURSOR LOCAL FORWARD_ONLY READ_ONLY STATIC FOR 
SELECT [Name] FROM @columns 
OPEN cnames 
FETCH NEXT FROM cnames INTO @name 
WHILE @@FETCH_STATUS = 0 BEGIN  
      SET @columnnames = @columnnames + '[' + @name + '], '  
      FETCH NEXT FROM cnames INTO @name  
END
CLOSE cnames 
DEALLOCATE cnames  
SET @columnnames = LEFT(@columnnames, LEN(@columnnames) - 1) 
DECLARE @sql VARCHAR(8000) 
SET @sql = 'INSERT INTO ' + @desttable + ' (' + @columnnames + ') 
SELECT ' + @columnnames + ' FROM ' + @srctable 
-- Execute the SQL batch to insert the data 
EXECUTE ('' + @sql)


GO
