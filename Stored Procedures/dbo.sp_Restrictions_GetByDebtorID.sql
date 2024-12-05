SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Restrictions_GetByDebtorID*/
CREATE Procedure [dbo].[sp_Restrictions_GetByDebtorID]
	@DebtorID int
AS

SELECT *
FROM restrictions
WHERE DebtorID = @DebtorID
GO
