SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_LetterRole_Update*/
CREATE Procedure [dbo].[sp_LetterRole_Update]
@LetterRoleID int,
@LetterID int,
@RoleID int
AS

UPDATE LetterRoles
SET
LetterID = @LetterID,
RoleID = @RoleID
WHERE LetterRoleID = @LetterRoleID

GO
