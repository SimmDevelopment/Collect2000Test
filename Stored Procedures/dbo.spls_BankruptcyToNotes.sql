SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.spls_BankruptcyToNotes    Script Date: 12/21/2005 4:22:07 PM ******/

/*dbo.spls_BankruptcyToNotes*/
CREATE  proc [dbo].[spls_BankruptcyToNotes]
	@DebtorID int
AS
-- Name:		spls_BankruptcyToNotes
-- Function:		This procedure will write a concatenated bankruptcy record to the notes table
--			then delete the bankruptcy record all in a transaction.
-- Creation:		06/04/2004 jc
--			Used by Latitude Scheduler.
-- Change History:	
	declare @number int, @DebtorSeq int
	select @number = number, @DebtorSeq = seq from debtors with (nolock) where debtorid = @DebtorID
	if @number is null begin
		RAISERROR('Could not find a file number for debtor id %d.  spls_BankruptcyToNotes failed.', 11, 1, @DebtorID)
    		RETURN
  	end
	BEGIN TRANSACTION
		--concatenate all columns into local variable
		declare @temp varchar(2000)
		set @temp = ''
		select @temp='Debtor('+cast(@DebtorSeq as varchar)+') Bankruptcy record archived '+convert(varchar, getdate(),120)+': bankruptcyid='+isnull(cast(bankruptcyid as varchar),'null')
			+'|accountid='+isnull(cast(accountid as varchar),'null')
			+'|debtorid='+isnull(cast(debtorid as varchar),'null')
			+'|chapter='+isnull(cast(chapter as varchar),'null')
			+'|datefiled='+isnull(convert(varchar, datefiled, 101),'null')
			+'|casenumber='+isnull(cast(casenumber as varchar),'null')
			+'|courtcity='+isnull(cast(courtcity as varchar),'null')
			+'|courtdistrict='+isnull(cast(courtdistrict as varchar),'null')
			+'|courtdivision='+isnull(cast(courtdivision as varchar),'null')
			+'|courtphone='+isnull(cast(courtphone as varchar),'null')
			+'|courtstreet1='+isnull(cast(courtstreet1 as varchar),'null')
			+'|courtstreet2='+isnull(cast(courtstreet2 as varchar),'null')
			+'|courtstate='+isnull(cast(courtstate as varchar),'null')
			+'|courtzipcode='+isnull(cast(courtzipcode as varchar),'null')
			+'|trustee='+isnull(cast(trustee as varchar),'null')
			+'|trusteestreet1='+isnull(cast(trusteestreet1 as varchar),'null')
			+'|trusteestreet2='+isnull(cast(trusteestreet2 as varchar),'null')
			+'|trusteecity='+isnull(cast(trusteecity as varchar),'null')
			+'|trusteestate='+isnull(cast(trusteestate as varchar),'null')
			+'|trusteezipcode='+isnull(cast(trusteezipcode as varchar),'null')
			+'|trusteephone='+isnull(cast(trusteephone as varchar),'null')
			+'|has341info='+isnull(cast(has341info as varchar),'null')
			+'|datetime341='+isnull(convert(varchar, datetime341, 101),'null')
			+'|location341='+isnull(cast(location341 as varchar),'null')
			+'|comments='+isnull(cast(comments as varchar),'null')
			+'|status='+isnull(cast(status as varchar),'null')
			+'|transmitteddate='+isnull(convert(varchar, transmitteddate, 101),'null')
		from bankruptcy with (nolock) where debtorid = @DebtorID
		if (@@error != 0) goto ErrHandler

		if len(@temp) > 0 begin
			--insert note	
			insert into notes (number,created,user0,action,result,comment)
				values (@number,getdate(),'BankoSvc','BNKO','IF',@temp)
			if (@@error != 0) goto ErrHandler

			--delete bankruptcy
			delete bankruptcy where debtorid = @DebtorID
			if (@@error != 0) goto ErrHandler
		end
	if (@@error != 0) goto ErrHandler
	COMMIT TRANSACTION		
	Return	
ErrHandler:
	RAISERROR('Error encountered in spls_BankruptcyToNotes for debtor id %d.  spls_BankruptcyToNotes failed.', 11, 1, @DebtorID)
	ROLLBACK TRANSACTION
	Return


GO
