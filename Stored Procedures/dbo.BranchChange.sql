SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO



Create procedure [dbo].[BranchChange]
	@number int,
	@qlevel varchar (3),
	@qdate varchar (8),
	@newbranch varchar (5),
	@returnSts int output
as 
BEGIN TRANSACTION
update master set qlevel=@qlevel,qdate=@qdate,branch=@newbranch where number =@number
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
