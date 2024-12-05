SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.LionDeleteReportRoleById    Script Date: 3/26/2007 9:52:00 AM ******/
CREATE PROCEDURE [dbo].[LionDeleteReportRoleById]
(
	@ReportRoleId int
)
AS
BEGIN
	SET NOCOUNT OFF;

	Declare @errorId int
	Declare @tranzName varchar(32)
	
	set @errorId = 0
	set @tranzName = 'DeleteReportRole'

	if not exists(select * from [LionReportRoles] where id=@ReportRoleId)
	BEGIN
		RAISERROR (N'Report role with id %d doesn''t exist',15,1, @ReportRoleId);
	END


	BEGIN TRANSACTION @tranzName

	DELETE FROM [dbo].[LionReportRoles] WHERE ID=@ReportRoleId
	
	SELECT @errorId = @@ERROR
	IF (@errorId <> 0) GOTO ERRORHANDLER
	
	--delete all associated	LionReportRolesMenus rows
	Delete from LionReportRolesMenus where ReportRoleId=@ReportRoleId

	COMMIT TRANSACTION @tranzName
	return
	ERRORHANDLER:
	if( @errorId != 0 )
	BEGIN
		--rollback the transaction
		ROLLBACK TRANSACTION @tranzName
		
		RAISERROR (N'Unable to delete report role %d. Error id %d',15,1, @ReportRoleId,@errorId);
	END
END



GO
