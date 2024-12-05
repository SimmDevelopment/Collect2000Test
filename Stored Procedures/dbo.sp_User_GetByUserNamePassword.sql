SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*sp_User_GetByUserNamePassword*/
CREATE  Procedure [dbo].[sp_User_GetByUserNamePassword]
	@UserName varchar(50),
	@Password varchar(128)
AS

SELECT *
FROM Users
WHERE LoginName = @UserName AND Password = @Password


GO
