SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create Procedure [dbo].[Custom_MoveAcctToNewCust]
	/* Param List */
	@OldCustomer varchar(7) = null,
	@NewCustomer varchar(7) = null,
	@receivedDate datetime,
	@UndoMove bit
AS
BEGIN
/******************************************************************************
**		File: 
**		Name: MoveAcctToNewCust
**		Desc: This procedure will move accounts from one customer to another.
**
**		This template can be customized:
**              
**		Return values:
** **		Called by:   
**              
**		Parameters:
**		Input							Output
**     ----------							-----------
**
**		Auth: jsb
**		Date: 08/2/2006
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**		--------		--------				-------------------------------------------
**    
*******************************************************************************/
declare @CommitThreshold Integer
declare @CommitCount Integer
declare @TranStartCurPos integer;
declare @CurPos integer;
declare @LockRetryCnt integer;
declare @LockLimit integer;
declare @trans integer;
declare @LockOut bit;
declare @SqlCode integer;
declare @LockTimeOutErr integer;

declare @Master cursor;
declare @MastNumber integer;
declare @MastCustomer varchar(7); 

begin transaction;
if not exists (select * from dbo.sysobjects where id = object_id(N'[Aud_AcctCustChange]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  begin
	create table dbo.Aud_AcctCustChange (
		number	integer,
		oldcustomer varchar(7),
		newcustomer varchar(7));
end;
commit transaction;
		
set cursor_close_on_commit off;
set lock_timeout 3000;

set @LockTimeOutErr = 1222;
set @CommitThreshold = 300; --can be lower 
set @CurPos = 0;
set @LockOut = 0;
set @trans = @@trancount;
set @SqlCode = 0;
set @LockRetryCnt = 0;
set @LockLimit = 10;

begin transaction; 
set @trans = @trans + 1

if @UndoMove = 0
  begin
	set @Master = cursor local dynamic scroll 	
	for
		select	m.number,
			m.customer
		from	master m
			
		where 	m.customer = @OldCustomer 
		and 	m.received = @receivedDate
		
		--	account is not sold if field is null

   end
else
  begin
	set @Master = cursor local dynamic scroll	
	for
		select	number,
			oldcustomer
		from	Aud_AcctCustChange 
		for update
end;

open @Master

fetch next from @Master into @MastNumber,@MastCustomer
set @SqlCode = @@error
set @CurPos = @CurPos + 1

set @NewCustomer = 
  case
	when @UndoMove = 0 then @NewCustomer  
	else @MastCustomer
  end
	

while @@fetch_status = 0 
	begin

	if @SqlCode = 0
	  begin
	    if @UndoMove = 0			--even though logic is identical for update vs rollback
		  begin				--this conditional is left in for any situations that would require
		    update master		--slightly different logic or multiple cases for master target select
			set	customer = @NewCustomer
			where 	number = @MastNumber
		
			set @SqlCode = @@error

		  end
	    else
	      begin
	      	update master
			set	customer = @NewCustomer
			where number = @Mastnumber
		
			set @SqlCode = @@error
	    end
	end;

	if @SqlCode = 0
	begin
		if exists (select * from dbo.sysobjects where id = object_id(N'[payhistory]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
		begin
		  update payhistory
			set	customer = @NewCustomer
			where	number = @MastNumber
		  set @SqlCode = @@error
		end
	end
	
	if @SqlCode = 0
	begin
		if exists (select * from dbo.sysobjects where id = object_id(N'[PDC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
		begin
		  update PDC
			set	customer = @NewCustomer
			where	number = @MastNumber
		  set @SqlCode = @@error
		end
	end
			
	if @SqlCode = 0
	begin	
		if exists (select * from dbo.sysobjects where id = object_id(N'[promises]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
		begin
		  update promises
			set	customer = @NewCustomer
			where	AcctID = @MastNumber
		  set @SqlCode = @@error
		end
	end
		
	if @SqlCode = 0
	begin
		if exists (select * from dbo.sysobjects where id = object_id(N'[letterrequest]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
		begin
		  update letterrequest
			set	customercode = @NewCustomer
			where	AccountID = @MastNumber
		  set @SqlCode = @@error
		end
	end		
	
	if @SqlCode = 0
	begin
		if exists (select * from dbo.sysobjects where id = object_id(N'[debtorpayments]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
		begin
		  update debtorpayments
			set	customer = @NewCustomer
			where	number = @MastNumber
		  set @SqlCode = @@error
		end
	end		
		
	if @SqlCode = 0
	begin
		if exists (select * from dbo.sysobjects where id = object_id(N'[pdcdeleted]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
		begin
		  update pdcdeleted
			set		customer = @NewCustomer
			where	number = @MastNumber
		  set @SqlCode = @@error
		end
	end		
	
	if @SqlCode = 0
	begin
		if exists (select * from dbo.sysobjects where id = object_id(N'[cbrhistory]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
		begin
		  update cbrhistory
			set	customer = @NewCustomer
			where	number = @MastNumber
		  set @SqlCode = @@error
		end
	end		


	if @SqlCode = 0
	begin
		INSERT INTO Notes(
		Number, 
		Created, 
		User0, 
		Action, 
		Result, 
		Comment)

		VALUES 	(
		@MastNumber, 
		GETDATE(), 
		'SYSTEM', 
		'CUST', 
		'CHNG', 
		'Customer Changed from ' + @MastCustomer + ' to ' + @NewCustomer)
	
		set @SqlCode = @@error
	end

	if @SqlCode = 0
	  begin
		if @UndoMove = 0
		  begin
		    insert into Aud_AcctCustChange (
				number,
				oldcustomer,
				newcustomer)
		
				values	(
				@MastNumber,
				@MastCustomer,
				@NewCustomer)
		
				set @SqlCode = @@error
		   end
		 else
		   begin
		     delete from Aud_AcctCustChange
		     where	current of @Master
		     
		     set @SqlCode = @@error
		 end
	end;
	
	if @SqlCode = 0
	  begin
		set @CommitCount = @CommitCount + 1
		if  @CommitCount >= @CommitThreshold 
		  begin
		    commit transaction 
		    set @trans = @trans - 1
		    set @CommitCount = 0
		    set @TranStartCurPos = @CurPos
		    begin transaction 
		    set @trans = @trans + 1
		end 
	  end
	else 
	  if @SqlCode = @LockTimeOutErr
	    begin
		  rollback transaction
		  waitfor delay '000:00:03'  --3 seconds
		  set @LockRetryCnt = @LockRetryCnt + 1
		  begin transaction 
		  set @CurPos = @TranStartCurPos
		  fetch absolute @TranStartCurPos from @Master into @MastNumber,@MastCustomer
		  set @SqlCode = @@error
	    end
	  else 
	    begin
		  break	--raise fatal error
	end
	
--next master

	if @SqlCode = 0 and @LockRetryCnt <= @LockLimit
	  begin
		fetch next from @Master into @MastNumber,@MastCustomer
		set @SqlCode = @@error
		set @CurPos = @CurPos + 1
		set @newCustomer = 
		  case
			when @UndoMove = 0 then @newCustomer  --'0001302'
			else @MastCustomer
		  end
	  end		
	else 
	  begin
	    break	--raise max locks error
	end
		
	
end -- while
	
close @Master
deallocate @Master

if @SqlCode = 0 
begin
	commit transaction
	
end
else begin
	raiserror('Error encountered in procedure. MoveAcctToNewCust', 11, 1, 'ERROR')
	rollback transaction
	
end

set lock_timeout -1  
               
return

END



GO
