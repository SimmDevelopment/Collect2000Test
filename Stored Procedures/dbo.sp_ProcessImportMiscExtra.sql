SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[sp_ProcessImportMiscExtra]
	@UID int,
	@AcctID int,
	@ReturnStatus int Output
AS

INSERT INTO MiscExtra(Number, Title, TheData)
SELECT @AcctID, Title, TheData FROM ImportMiscExtra
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
