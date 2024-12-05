SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_CustomCustGroupLetter_GetByID*/
CREATE Procedure [dbo].[sp_CustomCustGroupLetter_GetByID]
@CustomCustGroupLetterID INT
AS

SELECT *
FROM CustomCustGroupLetter
WHERE CustomCustGroupLetterID = @CustomCustGroupLetterID

GO
