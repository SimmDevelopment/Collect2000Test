SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


Create procedure [dbo].[AddressChange1]
	@number int,
	@seq int ,
	@Street1 varchar (30),
	@Street2 varchar (30),
	@city varchar (20),
	@state varchar (3),
	@zipcode varchar (10),
	@returnSts int output
as 
BEGIN TRANSACTION
update master set street1=@street1,street2=@street2,city=@city,state=@state,zipcode=@zipcode where number =@number 
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
