SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_DebtorAttorney_GetByAccountID*/
CREATE Procedure [dbo].[sp_DebtorAttorney_GetByAccountID]
	@AccountID int
AS

SELECT *
FROM DebtorAttorneys
WHERE AccountID = @AccountID

GO
