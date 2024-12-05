SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO





create procedure [dbo].[ContactedUpdate]
	@number int,
	@Count int,
	@returnSts int output
as
BEGIN TRANSACTION
update master set totalcontacted=@count where number=@number
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
