SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







/****** Object:  Stored Procedure dbo.ImportNBCustomerNotes_Insert    Script Date: 2/5/2004 4:36:55 PM ******/
CREATE PROCEDURE [dbo].[ImportNBCustomerNotes_Insert]
	@AccountID int,
	@seq int,
	@NoteDate smalldatetime,
	@NoteText char(255) 
AS

INSERT INTO ImportNBCustomerNotes (Number, seq, Notedate, Notetext)
VALUES (@AccountID, @seq, @NoteDate, @NoteText)

Return @@Error
	
GO
