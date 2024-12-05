SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[LetterAdd1]
	@number int,
	@ctl varchar(3),
	@entered datetime,
	@requested datetime,
	@letterdesc varchar(25),
	@lettercode varchar(5),
	@action varchar(6),
	@returnSts bit output  AS
BEGIN TRANSACTION
INSERT INTO future (number,ctl,entered, requested,letterdesc,lettercode,action)
VALUES (@number, @ctl,@entered, @requested,  @letterdesc, @lettercode, @action)

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
