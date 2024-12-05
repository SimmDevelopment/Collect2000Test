SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*MiscExtra_Insert*/
CREATE  Procedure [dbo].[MiscExtra_Insert]
	@Number int,
	@Title varchar(30),
	@TheData varchar(100),
	@ReturnID int Output

AS

INSERT INTO MiscExtra
(
Number,
Title,
TheData
)
VALUES
(
@Number,
@Title,
@TheData
)


If @@Error = 0 BEGIN
	Select @ReturnID = SCOPE_IDENTITY();
	Return 0
END
Else Return @@Error


GO
