SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[sp_ProcessImportNotes]
	@UID int,
	@AcctID int,
	@ReturnStatus int Output
AS

INSERT INTO Notes(Number, Created, User0, action, result, comment)
SELECT @AcctID, CreatedDate, UserID, actionCode, ResultCode, Comment FROM ImportNotes
WHERE UID = @UID

IF (@@Error=0) BEGIN
	Set @ReturnStatus=0
	Return 0
END
ELSE BEGIN
	Set @ReturnStatus=@@Error
	Return @@Error
END
GO
