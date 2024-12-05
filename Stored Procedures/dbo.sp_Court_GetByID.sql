SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Court_GetByID*/
CREATE Procedure [dbo].[sp_Court_GetByID]
@CourtID INT
AS

SELECT *
FROM Courts
WHERE CourtID = @CourtID

GO
