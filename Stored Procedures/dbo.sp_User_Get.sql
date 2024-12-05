SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*sp_User_Get*/
CREATE Procedure [dbo].[sp_User_Get]
	@KeyID int
AS

SELECT *
FROM Users
WHERE RoleID = @KeyID
GO
