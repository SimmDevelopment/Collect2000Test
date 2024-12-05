SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[sp_ProcessImportEDO]
	@UID int,
	@AcctID int,
	@ReturnStatus int Output
 AS
INSERT INTO ExtraData(number, extracode, line1, line2, line3, line4, line5)
SELECT @AcctID, ExtraCode, Line1, Line2, Line3, Line4, Line5 FROM ImportExtraData 
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
