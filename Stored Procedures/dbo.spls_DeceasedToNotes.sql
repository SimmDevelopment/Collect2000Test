SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.spls_DeceasedToNotes    Script Date: 12/21/2005 4:22:07 PM ******/

/*dbo.spls_DeceasedToNotes*/
CREATE  proc [dbo].[spls_DeceasedToNotes]
	@DebtorID int
AS
-- Name:		spls_DeceasedToNotes
-- Function:		This procedure will write a concatenated deceased record to the notes table
--			then delete the deceased record all in a transaction.
-- Creation:		06/04/2004 jc
--			Used by Latitude Scheduler.
-- Change History:	
	declare @number int, @DebtorSeq int
	select @number = number, @DebtorSeq = seq from debtors with (nolock) where debtorid = @DebtorID
	if @number is null begin
		RAISERROR('Could not find a file number for debtor id %d.  spls_DeceasedToNotes failed.', 11, 1, @DebtorID)
    		RETURN
  	end
	BEGIN TRANSACTION
		--concatenate all columns into local variable
		declare @temp varchar(1000)
		set @temp = ''
		select @temp='Debtor('+cast(@DebtorSeq as varchar)+') Deceased record archived '+convert(varchar, getdate(),120)+': id='+isnull(cast(id as varchar),'null')
			+'|accountid='+isnull(cast(accountid as varchar),'null')
			+'|debtorid='+isnull(cast(debtorid as varchar),'null')
			+'|ssn='+isnull(cast(ssn as varchar),'null')
			+'|firstname='+isnull(cast(firstname as varchar),'null')
			+'|lastname='+isnull(cast(lastname as varchar),'null')
			+'|state='+isnull(cast(state as varchar),'null')
			+'|postalcode='+isnull(cast(postalcode as varchar),'null')
			+'|dob='+isnull(convert(varchar, dob, 101),'null')
			+'|dod='+isnull(convert(varchar, dod, 101),'null')
			+'|matchcode='+isnull(cast(matchcode as varchar),'null')
			+'|transmitteddate='+isnull(convert(varchar, transmitteddate, 101),'null')
		from deceased with (nolock) where debtorid = @DebtorID
		if (@@error != 0) goto ErrHandler

		if len(@temp) > 0 begin
			--insert note	
			insert into notes (number,created,user0,action,result,comment)
				values (@number,getdate(),'DecdSvc','DECD','IF',@temp)
			if (@@error != 0) goto ErrHandler

			--delete deceased
			delete deceased where debtorid = @DebtorID
			if (@@error != 0) goto ErrHandler
		end
	if (@@error != 0) goto ErrHandler
	COMMIT TRANSACTION		
	Return	
ErrHandler:
	RAISERROR('Error encountered in spls_DeceasedToNotes for debtor id %d.  spls_DeceasedToNotes failed.', 11, 1, @DebtorID)
	ROLLBACK TRANSACTION
	Return


GO
