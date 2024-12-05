SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO





Create procedure [dbo].[adddeskstats]
	@desk varchar (50),
	@theDate datetime,
	@worked int,
	@contacted int,
	@touched int,
	@returnSts int output
as
BEGIN TRANSACTION
insert into deskstats
	(desk,thedate,worked,contacted,touched)
values
	(@desk,@thedate,@worked,@contacted,@touched)
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
