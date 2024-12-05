SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_CustomCustGroupLetter_Delete*/
CREATE Procedure [dbo].[sp_CustomCustGroupLetter_Delete]
@CustomCustGroupLetterID INT
AS

DELETE FROM CustomCustGroupLetter
WHERE CustomCustGroupLetterID = @CustomCustGroupLetterID

GO
