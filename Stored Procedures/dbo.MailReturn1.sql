SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


create procedure [dbo].[MailReturn1]
	@number int,
	@seq int ,
	@mr varchar (1),
	@returnSts int output
as 
BEGIN TRANSACTION
update debtors set mr=@mr where number =@number and seq =@seq
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
