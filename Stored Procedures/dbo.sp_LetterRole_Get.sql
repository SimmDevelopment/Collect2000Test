SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_LetterRole_Get*/
CREATE Procedure [dbo].[sp_LetterRole_Get]
	@KeyID int
AS

SELECT *
FROM LetterRoles
WHERE LetterID = @KeyID

GO
