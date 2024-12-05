SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[LionEnableUser]
	@lionUserId int
AS
BEGIN

	declare @transId varchar(20)
	set @transId = (SELECT CAST(ABS(CAST(CAST(NEWID() AS VARBINARY) AS INT)) AS varchar(20)))

	BEGIN TRANSACTION @transId
		UPDATE LionUsers
		SET Enabled = 1
		WHERE UserID=@lionUserId
	IF (@@ERROR <> 0) GOTO ErrorHandler
	COMMIT TRANSACTION @transId
	RETURN

	ErrorHandler:
	ROLLBACK TRANSACTION @transId
	RAISERROR (N'Unable to enable user account. Error ID %d', 15, 1, @@ERROR)

END
GO
