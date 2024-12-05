SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*sp_Role_GetPermissions*/
CREATE Procedure [dbo].[sp_Role_GetPermissions]
	@RoleID int
AS

SELECT *
FROM Permissions P
JOIN Fact F ON P.ID = F.PermissionID
WHERE F.RoleID = @RoleID
GO
