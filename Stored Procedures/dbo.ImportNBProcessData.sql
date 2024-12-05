SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






/****** Object:  Stored Procedure dbo.ImportNBProcessData    Script Date: 2/5/2004 4:36:56 PM ******/

CREATE  PROCEDURE [dbo].[ImportNBProcessData]
	@Srctable NVARCHAR(256), 
	@Desttable NVARCHAR(256),
	@FirstAcctID int,
	@LastAcctID int
AS

DECLARE @columns TABLE ([Name] SYSNAME)

-- Select all column names from the destination table
-- that are not an identity column
INSERT INTO @columns ([Name])
SELECT [name]
FROM [syscolumns]
WHERE [id] = OBJECT_ID(@Desttable)
AND NOT ([xtype] = 56 AND NOT [autoval] IS NULL)

DECLARE @name SYSNAME
DECLARE @columnnames NVARCHAR(2000)

SET @columnnames = ''

-- Loop through the column names to generate an SQL string
-- that contains the names comma seperated
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

DECLARE @sql NVARCHAR(4000)

SET @sql = 'INSERT INTO ' + @desttable + ' (' + @columnnames + ') 
SELECT ' + @columnnames + ' FROM ' + @srctable + ' WHERE Number BETWEEN ' + 
convert(varchar,@FirstAcctID) + ' AND ' + convert(varchar, @LastAcctID)

-- Execute the SQL batch to insert the data
EXECUTE ('' + @sql)
GO
