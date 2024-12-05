SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddPromise]
	@number int,
	@AmtDue money,
	@DateDue datetime,
	@rm varchar(1),
	@ltrcode varchar(5),
	@ltrcodeanddesc varchar(50),
	@promtype varchar(10),
        	@returnSts bit output  AS
BEGIN TRANSACTION
INSERT INTO future (number, amtdue, duedate, action, suspend, sendrm, lettercode, letterdesc, promisetype, entered, requested)
VALUES (@number, @AmtDue, @DateDue, 'Promise', 0, @rm, @ltrcode, @ltrcodeanddesc, @promtype, getdate(), getdate())

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
