SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


Create procedure [dbo].[SSNChange1]
	@number int,
	@seq int ,
	@ssn varchar (15),
	@returnSts int output
as 
BEGIN TRANSACTION
update debtors set ssn=@ssn where number =@number and seq = @seq
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
