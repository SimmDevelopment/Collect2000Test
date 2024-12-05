SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.ImportNBNotes_Insert    Script Date: 5/5/2004 4:36:55 PM ******/
CREATE PROCEDURE [dbo].[ImportNBNotes_Insert]
	@AccountID int,
	@created Datetime,
	@user0 Varchar(10),
	@action Varchar(6),
	@result Varchar(6),
	@comment text
AS
INSERT INTO ImportNBNotes (number, Created, User0, action, result, comment)
Values (@AccountID, @created, @user0, @action, @result, @comment)

Return @@Error
	
GO
