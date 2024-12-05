SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Letter_GetByID*/
CREATE Procedure [dbo].[sp_Letter_GetByID]
@LetterID int
AS

SELECT *
FROM letter
WHERE LetterID = @LetterID

GO
