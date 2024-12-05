SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [dbo].[ExtraDelete]
	@number int,
	@ExtraCode varchar(2) ,
	@returnSts bit output  AS
BEGIN TRANSACTION
Delete from ExtraData where number = @number and Extracode = @extracode
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
