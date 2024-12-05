SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.spls_DebtorAttorneyToNotes    Script Date: 12/21/2005 4:22:07 PM ******/

/*dbo.spls_DebtorAttorneyToNotes*/
CREATE  proc [dbo].[spls_DebtorAttorneyToNotes]
	@DebtorID int
AS
-- Name:		spls_DebtorAttorneyToNotes
-- Function:		This procedure will write a concatenated DebtorAttorneys record to the notes table
--			then delete the DebtorAttorneys record all in a transaction.
-- Creation:		06/04/2004 jc
--			Used by Latitude Scheduler.
-- Change History:	
	declare @number int, @DebtorSeq int
	select @number = number, @DebtorSeq = seq from debtors with (nolock) where debtorid = @DebtorID
	if @number is null begin
		RAISERROR('Could not find a file number for debtor id %d.  spls_DebtorAttorneyToNotes failed.', 11, 1, @DebtorID)
    		RETURN
  	end
	BEGIN TRANSACTION
		--concatenate all columns into local variable
		declare @temp varchar(1000)
		set @temp = ''
		select @temp='Debtor('+cast(@DebtorSeq as varchar)+') Attorney record archived '+convert(varchar, getdate(),120)+': id='+isnull(cast(id as varchar),'null')
			+'|accountid='+isnull(cast(accountid as varchar),'null')
			+'|debtorid='+isnull(cast(debtorid as varchar),'null')
			+'|name='+isnull(cast(name as varchar),'null')
			+'|firm='+isnull(cast(firm as varchar),'null')
			+'|addr1='+isnull(cast(addr1 as varchar),'null')
			+'|addr2='+isnull(cast(addr2 as varchar),'null')
			+'|city='+isnull(cast(city as varchar),'null')
			+'|state='+isnull(cast(state as varchar),'null')
			+'|zipcode='+isnull(cast(zipcode as varchar),'null')
			+'|phone='+isnull(cast(phone as varchar),'null')
			+'|fax='+isnull(cast(fax as varchar),'null')
			+'|email='+isnull(cast(email as varchar),'null')
			+'|comments='+isnull(convert(varchar, comments, 101),'null')
			+'|datecreated='+isnull(convert(varchar, datecreated, 101),'null')
			+'|dateupdated='+isnull(convert(varchar, dateupdated, 101),'null')
		from DebtorAttorneys with (nolock) where debtorid = @DebtorID and accountid = @number
		if (@@error != 0) goto ErrHandler

		if len(@temp) > 0 begin
			--insert note	
			insert into notes (number,created,user0,action,result,comment)
				values (@number,getdate(),'BankoSvc','BNKO','IF',@temp)
			if (@@error != 0) goto ErrHandler

			--delete DebtorAttorneys
			delete DebtorAttorneys where debtorid = @DebtorID and accountid = @number
			if (@@error != 0) goto ErrHandler

		end
	if (@@error != 0) goto ErrHandler
	COMMIT TRANSACTION		
	Return	
ErrHandler:
	RAISERROR('Error encountered in spls_DebtorAttorneyToNotes for debtor id %d.  spls_DebtorAttorneyToNotes failed.', 11, 1, @DebtorID)
	ROLLBACK TRANSACTION
	Return


GO
