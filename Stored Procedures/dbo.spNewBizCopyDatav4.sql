SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*spNewBizCopyDatav4*/
CREATE PROCEDURE [dbo].[spNewBizCopyDatav4] @Table_Identifier varchar(100) AS 
DECLARE @Table_Name    varchar(500) 

SET @Table_Name = 'NewBizBMaster' + @Table_Identifier 
EXEC spCopyToTablev4 @srctable = @Table_Name, @desttable = '[Master]'
IF NOT @@ERROR = 0 
BEGIN
   RAISERROR('Error copying Master table.', 16, 1)
   RETURN -1
END
SET @Table_Name = 'NewBizBDebtors' + @Table_Identifier 
EXEC spCopyToTablev4 @srctable = @Table_Name, @desttable = '[Debtors]' 
IF NOT @@ERROR = 0 BEGIN
   RAISERROR('Error copying debtors table.', 16, 1)
   RETURN -1
END
SET @Table_Name = 'NewBizBMiscExtra' + @Table_Identifier 
EXEC spCopyToTablev4 @srctable = @Table_Name, @desttable = '[MiscExtra]' 
IF NOT @@ERROR = 0 BEGIN
   RAISERROR('Error copying MiscExtra table.', 16, 1)
   RETURN -1
END
SET @Table_Name = 'NewBizBNotes' + @Table_Identifier 
EXEC spCopyToTablev4 @srctable = @Table_Name, @desttable = '[Notes]' 
IF NOT @@ERROR = 0 BEGIN
   RAISERROR('Error copying Notes table.', 16, 1)
   RETURN -1
END
SET @Table_Name = 'NewBizBDebtBuyerItems' + @Table_Identifier 
EXEC spCopyToTablev4 @srctable = @Table_Name, @desttable = '[DebtBuyerItems]' 
IF NOT @@ERROR = 0 BEGIN
   RAISERROR('Error copying DebtBuyerItems table.', 16, 1)
   RETURN -1
END
SET @Table_Name = 'NewBizBExtraData' + @Table_Identifier 
EXEC spCopyToTablev4 @srctable = @Table_Name, @desttable = '[ExtraData]' 
IF NOT @@ERROR = 0 BEGIN
   RAISERROR('Error copying ExtraData table.', 16, 1)
   RETURN -1
END
GO
