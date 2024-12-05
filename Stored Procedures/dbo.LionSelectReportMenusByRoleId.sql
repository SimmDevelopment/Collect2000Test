SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionSelectReportMenusByRoleId    Script Date: 3/26/2007 9:52:01 AM ******/
CREATE PROCEDURE [dbo].[LionSelectReportMenusByRoleId]
(
	@ReportRoleId int
)
AS
	SET NOCOUNT ON;
SELECT ID, ReportRoleId, MenuId 
FROM LionReportRolesMenus
Where ReportRoleId=@ReportRoleId
GO
