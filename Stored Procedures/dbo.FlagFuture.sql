SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO







CREATE PROCEDURE [dbo].[FlagFuture]
@JobName varchar (25),
@lettercode varchar (5),
	@returnSts int output
as
BEGIN TRANSACTION
update future  set Action = @jobname WHERE action = 'LETTER' and lettercode = @lettercode
if (@@error <>0)
BEGIN
GoTo abort_this_transaction
End
/* Transaction Completed Ok */
Normal_Exit:
Commit tran
set @returnSts = 0
Return @ReturnSts
/* TransAction Aborted */
abort_this_transaction:
rollback tran
set @returnSts = 1
Return @returnSts





GO
