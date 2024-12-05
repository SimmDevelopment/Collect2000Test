SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO











CREATE  procedure [dbo].[addnote]
	@number int,
	@desk varchar (7),
	@ac varchar (5),
	@rc varchar(5),
	@note varchar(90),
	@returnSts int output
as 
BEGIN TRANSACTION
insert into notes 
	(number,ctl,created,user0,action,result,comment)
values 
	(@number,'ctl',getdate(),@desk,@ac,@rc,@note)
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
