SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[RolePermissionsView]
AS
SELECT     dbo.Roles.RoleName, dbo.Permissions.ModuleName, dbo.Permissions.PermissionName
FROM         dbo.Permissions RIGHT OUTER JOIN
                      dbo.Fact ON dbo.Permissions.ID = dbo.Fact.PermissionID LEFT OUTER JOIN
                      dbo.Roles ON dbo.Fact.RoleID = dbo.Roles.ID
WHERE     (dbo.Permissions.PermissionName IS NOT NULL)
GO
