SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Attorney_Delete*/
CREATE Procedure [dbo].[sp_Attorney_Delete]
	@AttorneyID int
AS

DELETE FROM attorney
WHERE AttorneyID = @AttorneyID

GO
