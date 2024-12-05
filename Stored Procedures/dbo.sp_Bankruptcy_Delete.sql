SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_Bankruptcy_Delete*/
CREATE Procedure [dbo].[sp_Bankruptcy_Delete]
@BankruptcyID INT
AS

DELETE FROM Bankruptcy
WHERE BankruptcyID = @BankruptcyID
GO
