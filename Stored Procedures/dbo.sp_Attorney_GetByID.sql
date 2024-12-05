SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Attorney_GetByID*/
CREATE Procedure [dbo].[sp_Attorney_GetByID]
	@AttorneyID int
AS

SELECT *
FROM attorney
WHERE AttorneyID = @AttorneyID

GO
