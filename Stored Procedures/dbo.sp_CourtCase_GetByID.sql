SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_CourtCase_GetByID*/
CREATE Procedure [dbo].[sp_CourtCase_GetByID]
@CourtCaseID INT
AS

SELECT *
FROM CourtCases
WHERE CourtCaseID = @CourtCaseID

GO
