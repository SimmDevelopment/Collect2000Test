SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_CourtCase_Get*/
CREATE Procedure [dbo].[sp_CourtCase_Get]
	@KeyID int
AS

SELECT *
FROM CourtCases
WHERE AccountID = @KeyID

GO
