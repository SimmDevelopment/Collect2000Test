SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Court_Delete*/
CREATE Procedure [dbo].[sp_Court_Delete]
@CourtID INT
AS

DELETE FROM Courts
WHERE CourtID = @CourtID

GO
