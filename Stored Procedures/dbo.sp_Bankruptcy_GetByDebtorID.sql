SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_Bankruptcy_GetByDebtorID*/
CREATE Procedure [dbo].[sp_Bankruptcy_GetByDebtorID]
@DebtorID INT
AS

SELECT *
FROM Bankruptcy
WHERE DebtorID = @DebtorID
GO
