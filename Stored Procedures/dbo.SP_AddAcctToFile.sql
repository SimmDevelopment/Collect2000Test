SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SP_AddAcctToFile]
	@FileID int,
	@AcctID int,
	@ReturnValue int output
 AS
	
	UPDATE Master Set Link = @FileID
	WHERE Number = @AcctID

	IF (@@error=0) BEGIN
		Set @ReturnValue =  1
	END
	ELSE BEGIN
		Set @ReturnValue = -1
	END
GO
