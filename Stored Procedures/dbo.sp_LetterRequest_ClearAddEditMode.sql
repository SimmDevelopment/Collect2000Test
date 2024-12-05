SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*sp_LetterRequest_ClearAddEditMode*/
CREATE Procedure [dbo].[sp_LetterRequest_ClearAddEditMode]
	@AccountID int
AS

UPDATE LetterRequest
SET AddEditMode = 0
WHERE AccountID = @AccountID

GO
