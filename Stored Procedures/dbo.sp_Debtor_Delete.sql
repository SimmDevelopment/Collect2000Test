SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Debtor_Delete*/
CREATE Procedure [dbo].[sp_Debtor_Delete]
@DebtorID int
AS

DELETE FROM Debtors
WHERE DebtorID = @DebtorID

GO
