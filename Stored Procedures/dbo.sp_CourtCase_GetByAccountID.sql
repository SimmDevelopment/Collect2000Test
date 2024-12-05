SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_CourtCase_GetByAccountID*/
CREATE Procedure [dbo].[sp_CourtCase_GetByAccountID]
	@AccountID int
AS

SELECT *
FROM CourtCases
WHERE AccountID = @AccountID

GO
