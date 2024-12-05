SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[FixExtra]
	@number int,
	@extracode varchar (2),
	@line1 varchar (128),
	@returnSts int output
as 
BEGIN TRANSACTION
SET LOCK_TIMEOUT 1800
update extradata set line1=@line1 where number =@number and extracode =@extracode
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
