SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*AcctMoverPresets_Insert*/
CREATE  PROCEDURE [dbo].[AcctMoverPresets_Insert]
	@Name varchar(50),
	@Description varchar (500),
	@XML varchar (4000),
	@ID int Output
AS

INSERT INTO AcctMoverPresets(Name, Description, XML)
VALUES(@Name, @Description, @XML)

IF @@Error = 0 
	Select @ID = SCOPE_IDENTITY()
	
Return @@Error

GO
