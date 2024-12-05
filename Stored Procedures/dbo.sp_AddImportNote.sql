SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[sp_AddImportNote]
	@BatchID int,
	@ImportAcctID int,
	@CreatedDate datetime,
	@UserID varchar (10),
	@ActionCode varchar (5),
	@ResultCode varchar (5),
	@Comment varchar (100), 
	@ReturnStatus int Output,
	@ReturnUID int Output
AS

	INSERT INTO ImportNotes(BatchID, ImportAcctID, CreatedDate, UserID, ActionCode, ResultCode, Comment)
	VALUES(@BatchID, @ImportAcctID, @CreatedDate, @UserID, @ActionCode, @ResultCode, @Comment)

	IF (@@Error = 0)BEGIN
		Select @ReturnUID = SCOPE_IDENTITY()
		Set @ReturnStatus = 0
	END
	ELSE 
		Set @ReturnStatus = @@Error



GO
