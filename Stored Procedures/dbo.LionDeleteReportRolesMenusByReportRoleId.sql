SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionDeleteReportRolesMenusByReportRoleId    Script Date: 3/26/2007 9:52:00 AM ******/
CREATE PROCEDURE [dbo].[LionDeleteReportRolesMenusByReportRoleId]
(
	@ReportRoleId int
)
AS
	SET NOCOUNT OFF;
Delete From LionReportRolesMenus Where ReportRoleId=@ReportRoleId
GO
