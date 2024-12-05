SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ExtraUpdate]
	@number int,
	@ExtraCode varchar(2) ,
	@line1 varchar(128),
	@line2 varchar(128),
	@line3 varchar(128),
	@line4 varchar(128),
	@line5 varchar(128),
	@returnSts bit output  AS
BEGIN TRANSACTION
Update ExtraData set line1=@line1,Line2=@line2,Line3=@line3,Line4=@line4,line5=@line5 where number = @number and extracode = @extracode
if (@@error <> 0)
begin
goto abort_this_transaction
end
/* Transaction Completed Ok */
Normal_Exit:
Commit Tran
set @returnSts = 0
Return @ReturnSts
/* TransAction Aborted */
abort_this_transaction:
	rollback tran
	set @returnSts = 1
	Return @returnSts
GO
