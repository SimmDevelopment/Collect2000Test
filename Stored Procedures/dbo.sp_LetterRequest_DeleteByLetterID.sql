SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_LetterRequest_DeleteByLetterID*/
CREATE Procedure [dbo].[sp_LetterRequest_DeleteByLetterID]
	@LetterID int
AS

UPDATE LetterRequest
SET DELETED = 1
WHERE LetterID = @LetterID AND DateProcessed = '1/1/1753 12:00:00' AND Deleted = 0

GO
