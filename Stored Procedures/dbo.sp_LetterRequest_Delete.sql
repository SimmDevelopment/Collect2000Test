SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_LetterRequest_Delete*/
CREATE Procedure [dbo].[sp_LetterRequest_Delete]
@LetterRequestID INT
AS

--LetterRequests do not get physically deleted
UPDATE LetterRequest
SET Deleted = 1
WHERE LetterRequestID = @LetterRequestID

GO
