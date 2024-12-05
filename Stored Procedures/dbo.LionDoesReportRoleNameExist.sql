SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionDoesReportRoleNameExist    Script Date: 3/26/2007 9:52:00 AM ******/
-- =============================================
-- Author:		Ibrahim Hashimmi
-- Create date: 12/06/2006
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[LionDoesReportRoleNameExist]
	-- Add the parameters for the stored procedure here
	@roleName varchar(50),
	@exists bit output
AS
BEGIN
	SET NOCOUNT ON;

	set @exists = 1

	if not exists(select * from LionReportRoles with (nolock) where RoleName=@roleName)
		set @exists=0
END


GO
