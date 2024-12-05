SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_LetterRequestRecipient_Delete*/
CREATE Procedure [dbo].[sp_LetterRequestRecipient_Delete]
@LetterRequestRecipientID INT
AS

DELETE FROM LetterRequestRecipient
WHERE LetterRequestRecipientID = @LetterRequestRecipientID

GO
