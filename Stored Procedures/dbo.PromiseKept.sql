SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO



create procedure [dbo].[PromiseKept]
	@number int,
	@Qdate [varchar](8),
	@PromAmt [money],
	@PromDue [DateTime],	
	@returnSts int output
as
BEGIN TRANSACTION
update master set Qdate=@qdate,promamt=@promamt,promdue=@promdue,qlevel='820',Status='PPA' where number=@number
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
