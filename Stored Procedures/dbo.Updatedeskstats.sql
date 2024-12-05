SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO





Create procedure [dbo].[Updatedeskstats]
	@desk varchar (50),
	@theDate datetime,
	@worked int,
	@contacted int,
	@touched int,
	@returnSts int output
as
BEGIN TRANSACTION
update deskstats set worked=@worked,contacted=@contacted,touched=@touched where desk = @desk and thedate = @thedate
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
