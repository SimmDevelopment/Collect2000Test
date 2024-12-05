SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_CourtCase_Delete*/
CREATE Procedure [dbo].[sp_CourtCase_Delete]
@CourtCaseID INT
AS

DELETE FROM CourtCases
WHERE CourtCaseID = @CourtCaseID

GO
