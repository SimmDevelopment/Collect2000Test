SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_LetterRole_GetByID*/
CREATE Procedure [dbo].[sp_LetterRole_GetByID]
@LetterRoleID INT
AS

SELECT *
FROM LetterRoles
WHERE LetterRoleID = @LetterRoleID

GO
