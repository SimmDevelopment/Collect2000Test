SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_DebtorAttorney_GetByDebtorID*/
CREATE Procedure [dbo].[sp_DebtorAttorney_GetByDebtorID]
	@DebtorID int
AS

SELECT *
FROM DebtorAttorneys
WHERE DebtorID = @DebtorID

GO
