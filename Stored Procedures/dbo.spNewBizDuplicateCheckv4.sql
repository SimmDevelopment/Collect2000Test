SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*spNewBizDuplicateCheck*/
CREATE PROCEDURE [dbo].[spNewBizDuplicateCheckv4]
@Table_Identifier       varchar(100)
AS

--Variable declaration.
DECLARE @Table_Name     varchar(500)
DECLARE @SQL            varchar(1000)

SET @Table_Name = 'NewBizBMaster' + @Table_Identifier

-- Return recordset of the duplicate records for
-- logging purposes
SET @SQL = 'SELECT [account], [name], [original], [status] FROM [' + @Table_Name + ']'
SET @SQL = @SQL + 'WHERE EXISTS (SELECT TOP 1 number FROM [master]WHERE [master].[account] '
SET @SQL = @SQL + '= [' + @Table_Name + '].[account])'
EXEC (@SQL)

-- Mark accounts as duplicate if they have a record
-- in the master table

SET @SQL = 'UPDATE ' + @Table_Name   ---[NewBizBMaster]
SET @SQL = @SQL + ' Set [status] = ''DUP'' WHERE EXISTS (SELECT TOP 1 number '
SET @SQL = @SQL + 'FROM [master] WHERE [master].[account] = [' + @Table_Name + '].[account])'
EXEC (@SQL)

BEGIN TRANSACTION

--NewBizBMaster block
SET @Table_Name = 'NewBizBMaster' + @Table_Identifier
-- Copy duplicates to new business duplicate table
SET @SQL = 'INSERT INTO [NewbizDupes] ([account], [name], [customer], [received], [original]) '
SET @SQL = @SQL + 'SELECT [account], [name], [customer], [received], [original] '
SET @SQL = @SQL + 'FROM [' + @Table_Name + '] WHERE [status] = ''DUP'''
EXEC (@SQL)
Print 'Executed ' + @Table_Name


-- Remove duplicate accounts from new business tables
SET @SQL = 'DELETE FROM [' + @Table_Name + '] WHERE [status] = ''DUP'''
EXEC(@SQL)
Print 'Executed ' + @Table_Name


--NewBizBDebtors block
SET @Table_Name = 'NewBizBDebtors' + @Table_Identifier
SET @SQL = 'DELETE FROM ['+ @Table_Name + '] WHERE NOT EXISTS (SELECT TOP 1 [number] '
SET @SQL = @SQL + 'FROM [NewBizBMaster' + @Table_Identifier + '] WHERE '
SET @SQL = @SQL + '[NewBizBMaster' + @Table_Identifier + '].[number] = ['
SET @SQL = @SQL + @Table_Name + '].[number])'
EXEC(@SQL)


--NewBizBMiscExtra block
SET @Table_Name = 'NewBizBMiscExtra' + @Table_Identifier
SET @SQL = 'DELETE FROM [' + @Table_Name + '] WHERE NOT EXISTS (SELECT TOP 1 [number] '
SET @SQL = @SQL + 'FROM [NewBizBMaster' + @Table_Identifier + '] WHERE '
SET @SQL = @SQL + '[NewBizBMaster' + @Table_Identifier + '].[number] = ['
SET @SQL = @SQL + @Table_Name + '].[number])'
EXEC(@SQL)

--NewBizBNotes block
SET @Table_Name = 'NewBizBNotes' + @Table_Identifier
SET @SQL = 'DELETE FROM [' + @Table_Name + '] WHERE NOT EXISTS (SELECT TOP 1 [number] '
SET @SQL = @SQL + 'FROM [NewBizBMaster' + @Table_Identifier + '] WHERE '
SET @SQL = @SQL + '[NewBizBMaster' + @Table_Identifier + '].[number] = ['
SET @SQL = @SQL + @Table_Name + '].[number])'
EXEC(@SQL)

--NewBizBDebtBuyerItems
SET @Table_Name = 'NewBizBDebtBuyerItems' + @Table_Identifier
SET @SQL = 'DELETE FROM [' + @Table_Name + '] WHERE NOT EXISTS (SELECT TOP 1 [number] '
SET @SQL = @SQL + 'FROM [NewBizBMaster' + @Table_Identifier + '] WHERE '
SET @SQL = @SQL + '[NewBizBMaster' + @Table_Identifier + '].[number] = ['
SET @SQL = @SQL + @Table_Name + '].[number])'
EXEC(@SQL)

--NewBizBExtraData block
SET @Table_Name = 'NewBizBExtraData' + @Table_Identifier
SET @SQL = 'DELETE FROM [' + @Table_Name + '] WHERE NOT EXISTS (SELECT TOP 1 [number] '
SET @SQL = @SQL + 'FROM [NewBizBMaster' + @Table_Identifier + '] WHERE '
SET @SQL = @SQL + '[NewBizBMaster' + @Table_Identifier + '].[number] = ['
SET @SQL = @SQL + @Table_Name + '].[number])'
EXEC(@SQL)

COMMIT TRANSACTION
GO
