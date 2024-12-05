SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_LetterRole_Delete*/
CREATE Procedure [dbo].[sp_LetterRole_Delete]
@LetterRoleID INT
AS

DELETE FROM LetterRoles
WHERE LetterRoleID = @LetterRoleID

GO
