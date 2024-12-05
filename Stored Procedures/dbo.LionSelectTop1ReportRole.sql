SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionSelectTop1ReportRole    Script Date: 3/26/2007 9:52:01 AM ******/
-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 12/07/2006
-- Description:	This will select the first record in teh LionReportRoles table
--				this is handy for when a LionReportRoles record gets deleted.
-- =============================================
CREATE PROCEDURE [dbo].[LionSelectTop1ReportRole]
AS
BEGIN
	SET NOCOUNT ON;

    SELECT TOP 1 ID, RoleName, Description FROM dbo.LionReportRoles with (nolock) order by ID
END

GO
