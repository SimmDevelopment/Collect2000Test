SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*spNewBizDuplicateCheck*/
CREATE PROCEDURE [dbo].[spNewBizDuplicateCheck]
AS

-- Return recordset of the duplicate records for
-- logging purposes
SELECT [account], [name], [original], [status]
FROM [NewBizBMaster]
WHERE EXISTS (SELECT TOP 1 number
	FROM [master]
	WHERE [master].[account] = [NewBizBMaster].[account])

-- Mark accounts as duplicate if they have a record
-- in the master table
UPDATE [NewBizBMaster]
SET [status] = 'DUP'
WHERE EXISTS (SELECT TOP 1 number
	FROM [master]
	WHERE [master].[account] = [NewBizBMaster].[account])


BEGIN TRANSACTION

-- Copy duplicates to new business duplicate table
INSERT INTO [NewbizDupes] ([account], [name], [customer], [received], [original])
SELECT [account], [name], [customer], [received], [original]
FROM [NewBizBMaster]
WHERE [status] = 'DUP'

-- Remove duplicate accounts from new business tables
DELETE FROM [NewBizBMaster]
WHERE [status] = 'DUP'

DELETE FROM [NewBizBDebtors]
WHERE NOT EXISTS (SELECT TOP 1 [number]
	FROM [NewBizBMaster]
	WHERE [NewBizBMaster].[number] = [NewBizBDebtors].[number])

DELETE FROM [NewBizBMiscExtra]
WHERE NOT EXISTS (SELECT TOP 1 [number]
	FROM [NewBizBMaster]
	WHERE [NewBizBMaster].[number] = [NewBizBMiscExtra].[number])

DELETE FROM [NewBizBNotes]
WHERE NOT EXISTS (SELECT TOP 1 [number]
	FROM [NewBizBMaster]
	WHERE [NewBizBMaster].[number] = [NewBizBNotes].[number])

COMMIT TRANSACTION


GO
