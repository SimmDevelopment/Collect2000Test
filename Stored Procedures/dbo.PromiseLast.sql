SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO



create procedure [dbo].[PromiseLast]
	@number int,
	@Qdate [varchar](8),
	@returnSts int output
as
BEGIN TRANSACTION
update master set Qdate=@qdate,promamt=null,promdue=null,qlevel='013',Status='ACT' where number=@number
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
