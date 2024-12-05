SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*spNewBizRenumberv4*/
CREATE PROCEDURE [dbo].[spNewBizRenumberv4] @Table_Identifier varchar(100), @TotalRead INTEGER AS 
DECLARE @NextDebtorID INTEGER DECLARE @Table_Name varchar(500) DECLARE @SQL varchar(1000)
BEGIN TRANSACTION 
SELECT @NextDebtorID = [nextdebtor] FROM [ControlFile] WITH (XLOCK, TABLOCK) IF @NextDebtorID IS NULL BEGIN RAISERROR('Control File is empty.', 16, 1) RETURN -1 End 
UPDATE [ControlFile] SET [nextdebtor] = @NextDebtorID + @TotalRead 
COMMIT TRANSACTION 
SET @Table_Name = 'NewBizBMaster' + @Table_Identifier 
SET @SQL = 'UPDATE ' + @Table_Name + ' SET [number] = [number] +' + cast(@NextDebtorID - 1 as varchar(20))
EXEC(@SQL) 
SET @Table_Name = 'NewBizBDebtors' + @Table_Identifier 
SET @SQL = 'UPDATE ' + @Table_Name + ' SET [number] = [number] +' + cast(@NextDebtorID - 1 as varchar(20))
EXEC(@SQL) 
SET @Table_Name = 'NewBizBMiscExtra' + @Table_Identifier 
SET @SQL = 'UPDATE ' + @Table_Name + ' SET [number] = [number] +' + cast(@NextDebtorID - 1 as varchar(20))
EXEC(@SQL) 
SET @Table_Name = 'NewBizBNotes' + @Table_Identifier 
SET @SQL = 'UPDATE ' + @Table_Name + ' SET [number] = [number] +' + cast(@NextDebtorID - 1 as varchar(20))
EXEC(@SQL) 
SET @Table_Name = 'NewBizBExtraData' + @Table_Identifier 
SET @SQL = 'UPDATE ' + @Table_Name + ' SET [number] = [number] +' + cast(@NextDebtorID - 1 as varchar(20))
EXEC(@SQL) 
SET @Table_Name = 'NewBizBDebtBuyerItems' + @Table_Identifier 
SET @SQL = 'UPDATE ' + @Table_Name + ' SET [number] = [number] +' + cast(@NextDebtorID - 1 as varchar(20))
EXEC(@SQL) 
RETURN 0

GO
