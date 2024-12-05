SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionInsertReportRole    Script Date: 3/26/2007 9:52:01 AM ******/
-- =============================================
-- Author:		Ibrahim Hashimi
-- Create date: 12/07/2006
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[LionInsertReportRole]
	-- Add the parameters for the stored procedure here
	@roleName varchar(100),
	@description varchar(255),
	@roleId int output
AS
BEGIN
	SET NOCOUNT ON;

	Set @roleId=-1

	Insert into LionReportRoles([RoleName],[Description])
	Values(@roleName,@description);

	Select @roleId=SCOPE_IDENTITY()    
END

GO
