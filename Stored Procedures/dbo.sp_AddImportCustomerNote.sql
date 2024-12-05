SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[sp_AddImportCustomerNote]
	@BatchID int,
	@ImportAcctID int,
	@NoteDate datetime,
	@NoteText varchar(255),
	@ReturnStatus int Output,
	@ReturnUID int Output


AS

	INSERT INTO ImportCustomerNotes (BatchID, ImportAcctID, NoteDate, NoteText)
	VALUES (@BatchID, @ImportAcctID, @NoteDate, @NoteText)

	IF (@@Error=0)BEGIN
		Select @ReturnUID = SCOPE_IDENTITY()
		SET @ReturnStatus = 0
		Return 0
	END
	ELSE BEGIN
		SET @ReturnStatus = @@Error
		Return @ReturnStatus
	END


/*
CREATE TABLE [dbo].[CustomerNotes] (
	[Number] [int] NULL ,
	[Seq] [int] NULL ,
	[NoteDate] [datetime] NULL ,
	[NoteText] [char] (255) NULL 

*/

GO
