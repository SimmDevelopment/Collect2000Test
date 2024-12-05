SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[sp_ProcessImportCustNotes]
	@UID int,
	@AcctID int,
	@ReturnStatus int Output
AS

INSERT INTO CustomerNotes(Number, NoteDate, NoteText)
SELECT @AcctID, NoteDate, NoteText FROM ImportCustNotes
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
