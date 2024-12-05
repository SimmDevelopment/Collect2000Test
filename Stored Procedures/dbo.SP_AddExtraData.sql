SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[SP_AddExtraData]
	@AcctID int,
	@ExtraCode varchar(2),
	@ReturnStatus smallint output
AS
	Select number from ExtraData Where number = @AcctID and ExtraCode = @ExtraCode

	IF(@@Rowcount=0)
		Insert Into ExtraData(Number, extracode, Line1, Line2, Line3, Line4,Line5)
		Values(@AcctID, @ExtraCode,'','','','','')
	
	IF (@@error=0)
		Set @ReturnStatus = 1
	ELSE
		Set @ReturnStatus = -1

GO
