SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionSelectLionMenusByRoleId    Script Date: 3/26/2007 9:52:01 AM ******/
CREATE PROCEDURE [dbo].[LionSelectLionMenusByRoleId]
(
	@ReportRoleId int
)
AS
	SET NOCOUNT ON;
Select	menu.ID, 
		menu.Name, 
		menu.TreePath, 
		menu.URL, 
		menu.ReportDefinition, 
		menu.Target
From LionMenus menu with (nolock)
Join LionReportRolesMenus rolesMenus with (nolock) on rolesMenus.MenuId=menu.id
where rolesMenus.ReportRoleId=@ReportRoleId
GO
