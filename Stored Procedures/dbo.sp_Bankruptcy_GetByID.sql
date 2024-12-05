SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_Bankruptcy_GetByID*/
CREATE Procedure [dbo].[sp_Bankruptcy_GetByID]
@BankruptcyID INT
AS

SELECT *
FROM Bankruptcy
WHERE BankruptcyID = @BankruptcyID
GO
