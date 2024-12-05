SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[sp_AddImportMiscExtra]
	@BatchID int,
	@ImportAcctID int,
	@Title varchar (30),
	@TheData varchar (100),
	@ReturnStatus int Output,
	@ReturnUID int Output

 AS

	INSERT INTO ImportMiscExtra(BatchID, ImportAcctID, Title, TheData)
	VALUES (@BatchID, @ImportAcctID, @Title, @TheData)

	IF(@@Error=0) BEGIN
		Select @ReturnUID = SCOPE_IDENTITY()
		SET @ReturnStatus = 0
	END
	ELSE 
		SET @ReturnStatus = @@Error

GO
