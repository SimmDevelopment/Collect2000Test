SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_LetterRole_Add*/
CREATE  Procedure [dbo].[sp_LetterRole_Add]
@LetterRoleID int OUTPUT,
@LetterID int,
@RoleID int
AS

INSERT INTO LetterRoles
(
LetterID,
RoleID
)
VALUES
(
@LetterID,
@RoleID
)

SET @LetterRoleID = SCOPE_IDENTITY()



GO
