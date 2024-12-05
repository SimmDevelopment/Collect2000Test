SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*spNewBizRenumber*/
CREATE PROCEDURE [dbo].[spNewBizRenumber] 
	@TotalRead INTEGER 
AS 
DECLARE @NextDebtorID INTEGER 
BEGIN TRANSACTION 
SELECT @NextDebtorID = [nextdebtor] FROM [ControlFile] WITH (XLOCK, TABLOCK) 
IF @NextDebtorID IS NULL 
BEGIN 
	RAISERROR('Control File is empty.', 16, 1) 
	RETURN -1 
End 
Update [ControlFile] SET [nextdebtor] = @NextDebtorID + @TotalRead 
COMMIT TRANSACTION 
Update [NewBizBMaster] SET [number] = [number] + @NextDebtorID - 1 
Update [NewBizBDebtors] SET [number] = [number] + @NextDebtorID - 1 
Update [NewBizBMiscExtra] SET [number] = [number] + @NextDebtorID - 1 
Update [NewBizBNotes] SET [number] = [number] + @NextDebtorID - 1 
Update [NewBizBExtraData] SET [number] = [number] + @NextDebtorID - 1 
Update [NewBizBDebtBuyerItems] SET [number] = [number] + @NextDebtorID - 1 
RETURN 0

GO
