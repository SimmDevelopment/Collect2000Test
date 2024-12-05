SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.spls_DoSkipTraceXml    Script Date: 12/21/2005 4:22:08 PM ******/



/*dbo.spls_DoSkipTraceXml*/
CREATE  proc [dbo].[spls_DoSkipTraceXml]
	@RequestID int, @BatchID uniqueidentifier, 
	@XPathMatchRequestID varchar(256), @CompletionDesk varchar(10)
AS
-- Name:		spls_DoSkipTraceXml
-- Function:		This procedure will process returned skip trace info from outside service
-- Creation:		10/22/2004 jc
--			Used by Latitude Scheduler.
-- Change History:	
--			02/26/2005 jc if ncoa deliverable code returned is N,G,or K set mail return to Y
--			04/12/2005 jc changed to process pcoa/ncoa link instead of ncoa/nixie codes
	declare @idoc int, @doc varchar(8000), @xmlRequestID int, 
	@DebtorID int, @Number int, @DebtorSeq int, @DebtorName varchar(30), @customer varchar(7),
	@SkipTraceReturned int

	--assign xmlinforeturned to local variable
	select @doc = xmlinforeturned from servicehistory where requestid = @RequestID
	if @doc is null begin
		RAISERROR('Invalid xml info returned for requestid %d. spls_DoSkipTraceXml failed.', 11, 1, @RequestID)
		goto ErrHandler
	end

	-- Create an internal representation of the XML document.
	exec sp_xml_preparedocument @idoc output, @doc
	if (@@error != 0) goto ErrHandler

	--look for skiptrace data retrieve servicehistory requestid from xml
	select @xmlRequestID = RequestID
	from openxml (@idoc, @XPathMatchRequestID, 3)
	with (RequestID int)
	if (@@error != 0) goto ErrHandler

	if @xmlRequestID is null begin
		RAISERROR('SkipTrace: Invalid RequestId contained in xml data for requestid %d xmlrequestid %d. spls_DoSkipTraceXml failed.', 11, 1, @RequestID, @xmlRequestID)
		goto ErrHandler
	end
	else begin
		if @RequestID = @xmlRequestID begin
			--skip trace info returned
			set @SkipTraceReturned = 1
		end
		else begin
			RAISERROR('SkipTrace: RequestId contained in xml data does not match passed in requestid %d xmlrequestid %d. spls_DoSkipTraceXml failed.', 11, 1, @RequestID, @xmlRequestID)
			goto ErrHandler
		end
	end

	--assign locals
	select @Number = d.number, @DebtorID = d.debtorid, @DebtorSeq = d.seq, @DebtorName = isnull(d.Name,'') from debtors d with(nolock) 
	inner join servicehistory sh with(nolock) on sh.debtorid = d.debtorid
	where sh.requestid = @RequestID
	if (@@error != 0) goto ErrHandler
	select @customer = customer from master with (nolock) where number = @Number
	if (@@error != 0) goto ErrHandler
	if @Number is null begin
		RAISERROR('Could not find a file number for debtor id %d. spls_DoSkipTraceXml failed. ', 11, 1, @RequestID)
    		goto ErrHandler
  	end

	--update service history response
	update ServiceHistory_RESPONSES 
		set DateProcessed = getdate()
	where RequestID = @RequestID
	if (@@error != 0) goto ErrHandler

	--update service history 
	update ServiceHistory 
		set Processed = case @SkipTraceReturned when 0 then 2 else 3 end
	where RequestId = @RequestID and BatchID = @BatchID
	if (@@error != 0) goto ErrHandler

	--update master account (desk)
	update master set desk = @CompletionDesk where number = @number
	if (@@error != 0) goto ErrHandler

	if @SkipTraceReturned = 0 begin
		--no skiptrace info returned
		--insert note	
		insert into notes (number,created,user0,action,result,comment)
			values (@number,getdate(),'SkipSvc','SKIP','IF','Debtor('+rtrim(ltrim(@DebtorName))+') No skiptrace information found.')
		if (@@error != 0) goto ErrHandler
		goto cuExit
	end

	--skiptrace info returned
--	declare @NCOAFlag char(1), @precise char(1), @imprecise char(1), @ncoaDeliverableCode char(1)
--	select @NCOAFlag = NCOAFlag, @precise = NixieA, @imprecise = NixieB, @ncoaDeliverableCode = NCOADeliverableCode
--	from openxml (@idoc, '//account', 2)
--	with (NCOAFlag char(1) 'Type1/NCOAFlag', NixieA char(1) 'Type1C/@NixieA', NixieB char(1) 'Type1C/@NixieB', NCOADeliverableCode char(1) 'Type1C/@NCOADeliverableCode')
--	if (@@error != 0) goto ErrHandler

	declare @NCOAIndicator char(1), @NcoaLinkA char(1), @PCOAConfidenceCode char(1), @DPVCode char(1)
	select @NCOAIndicator = NCOAIndicator, @NcoaLinkA = NcoaLinkA, @PCOAConfidenceCode = PCOAConfidenceCode, @DPVCode = DPVCode
	from openxml (@idoc, '//account', 2)
	with (NCOAIndicator char(1) 'Type1/NCOAIndicator', NcoaLinkA char(1) 'Type1C/@NcoaLinkA', PCOAConfidenceCode char(1) 'Type1C/@PCOAConfidenceCode', DPVCode char(1) 'Type1C/@DPVCode')
	if (@@error != 0) goto ErrHandler

	--PCOA validation
	if @NCOAIndicator = 'P' begin
		--PCOA match returned
		if @PCOAConfidenceCode = '1' or @PCOAConfidenceCode = '2' begin
			--ensure confidence code is 1 or 2
			--insert AddressHistory (move current debtor address to AddressHistory table)
			insert into AddressHistory(AccountID, DebtorID, DateChanged, UserChanged, 
			OldStreet1, OldStreet2, OldCity, OldState, OldZipcode, NewStreet1, NewStreet2,
			NewCity, NewState, NewZipcode)
			select d.number, d.debtorid, getdate(), 'SkipSvc', isnull(d.Street1,''), isnull(d.Street2,''), isnull(d.City,''), isnull(d.State,''), isnull(d.Zipcode,''), 
				x.Address, '', x.City, x.State, case when len(x.ZipPlus4) > 0 then x.Zip+'-'+x.Zipplus4 else x.Zip end
			from openxml (@idoc, '//account/Type1',2) 
				with (RequestID int, Address varchar(30), City varchar(30), State varchar(2), Zip varchar(5), ZipPlus4 varchar(4)) x
			inner join servicehistory sh with(nolock) on sh.RequestID = x.RequestID
			inner join debtors d with(nolock) on d.debtorid = sh.debtorid
			if (@@error != 0) goto ErrHandler
	
			--update debtor address with returned address
			update debtors
				set debtors.Street1 = x.Address, debtors.Street2 = '', debtors.City = x.City, debtors.State = x.State, debtors.Zipcode = case when len(x.ZipPlus4) > 0 then x.Zip+'-'+x.Zipplus4 else x.Zip end
			from openxml (@idoc, '//account/Type1',2) 
				with (Address varchar(30), City varchar(30), State varchar(2), Zip varchar(5), ZipPlus4 varchar(4)) x
			where debtors.debtorid = @DebtorID
			if (@@error != 0) goto ErrHandler
	
			--update master address with returned address if this is debtor zero
			if @DebtorSeq = '0' begin
				update master
					set master.Street1 = x.Address, master.Street2 = '', master.City = x.City, master.State = x.State, master.Zipcode = case when len(x.ZipPlus4) > 0 then x.Zip+'-'+x.Zipplus4 else x.Zip end
				from openxml (@idoc, '//account/Type1',2) 
					with (Address varchar(30), City varchar(30), State varchar(2), Zip varchar(5), ZipPlus4 varchar(4)) x
				where master.number = @Number
				if (@@error != 0) goto ErrHandler
			end
	
			--insert note	
			insert into notes (number,created,user0,action,result,comment)
				values (@number,getdate(),'SkipSvc','PCOA','IF','Debtor('+rtrim(ltrim(@DebtorName))+') PCOA match returned. Debtor address updated.')
			if (@@error != 0) goto ErrHandler
		end
		else begin
			--insert note	
			insert into notes (number,created,user0,action,result,comment)
				values (@number,getdate(),'SkipSvc','PCOA','IF','Debtor('+rtrim(ltrim(@DebtorName))+') PCOA returned with an improper confidence code. Debtor address not updated.')
			if (@@error != 0) goto ErrHandler
		end
	end

	--NCOA validation
	if @NCOAIndicator = 'N' begin
		if @NcoaLinkA = 'A' begin
			--NCOA match returned
			--check ncoa DPV code - if code is N or blank then set debtors mail return to 'Y'
			if @DPVCode is null or @DPVCode = 'N' begin
				--update debtor mail return
				update debtors set debtors.MR = 'Y' where debtors.debtorid = @DebtorID
				if (@@error != 0) goto ErrHandler
		
				--update master mail return if this is debtor zero
				if @DebtorSeq = '0' begin
					update master set master.MR = 'Y' where master.number = @Number
					if (@@error != 0) goto ErrHandler
				end
	
				--insert note	
				insert into notes (number,created,user0,action,result,comment)
					values (@number,getdate(),'SkipSvc','NCOA','IF','Debtor('+rtrim(ltrim(@DebtorName))+') NCOA returned. DPV code = (' + @DPVCode + '). Mail return set')
				if (@@error != 0) goto ErrHandler
			end

			if @DPVCode = 'Y' or @DPVCode = 'S' begin
				--insert AddressHistory (move current debtor address to AddressHistory table)
				insert into AddressHistory(AccountID, DebtorID, DateChanged, UserChanged, 
				OldStreet1, OldStreet2, OldCity, OldState, OldZipcode, NewStreet1, NewStreet2,
				NewCity, NewState, NewZipcode)
				select d.number, d.debtorid, getdate(), 'SkipSvc', isnull(d.Street1,''), isnull(d.Street2,''), isnull(d.City,''), isnull(d.State,''), isnull(d.Zipcode,''), 
					x.Address, '', x.City, x.State, case when len(x.ZipPlus4) > 0 then x.Zip+'-'+x.Zipplus4 else x.Zip end
				from openxml (@idoc, '//account/Type1',2) 
					with (RequestID int, Address varchar(30), City varchar(30), State varchar(2), Zip varchar(5), ZipPlus4 varchar(4)) x
				inner join servicehistory sh with(nolock) on sh.RequestID = x.RequestID
				inner join debtors d with(nolock) on d.debtorid = sh.debtorid
				if (@@error != 0) goto ErrHandler
		
				--update debtor address with returned address
				update debtors
					set debtors.Street1 = x.Address, debtors.Street2 = '', debtors.City = x.City, debtors.State = x.State, debtors.Zipcode = case when len(x.ZipPlus4) > 0 then x.Zip+'-'+x.Zipplus4 else x.Zip end
				from openxml (@idoc, '//account/Type1',2) 
					with (Address varchar(30), City varchar(30), State varchar(2), Zip varchar(5), ZipPlus4 varchar(4)) x
				where debtors.debtorid = @DebtorID
				if (@@error != 0) goto ErrHandler
		
				--update master address with returned address if this is debtor zero
				if @DebtorSeq = '0' begin
					update master
						set master.Street1 = x.Address, master.Street2 = '', master.City = x.City, master.State = x.State, master.Zipcode = case when len(x.ZipPlus4) > 0 then x.Zip+'-'+x.Zipplus4 else x.Zip end
					from openxml (@idoc, '//account/Type1',2) 
						with (Address varchar(30), City varchar(30), State varchar(2), Zip varchar(5), ZipPlus4 varchar(4)) x
					where master.number = @Number
					if (@@error != 0) goto ErrHandler
				end
		
				--insert note	
				insert into notes (number,created,user0,action,result,comment)
					values (@number,getdate(),'SkipSvc','NCOA','IF','Debtor('+rtrim(ltrim(@DebtorName))+') NCOA returned. DPV code = (' + @DPVCode + '). Debtor address updated.')
				if (@@error != 0) goto ErrHandler
			end
			else begin
				--insert note	
				insert into notes (number,created,user0,action,result,comment)
					values (@number,getdate(),'SkipSvc','NCOA','IF','Debtor('+rtrim(ltrim(@DebtorName))+') NCOA returned. DPV code = (' + @DPVCode + '). Debtor address not updated.')
				if (@@error != 0) goto ErrHandler
			end
		end
		else begin
			--insert note	
			insert into notes (number,created,user0,action,result,comment)
				values (@number,getdate(),'SkipSvc','NCOA','IF','Debtor('+rtrim(ltrim(@DebtorName))+') NCOA returned with improper NCOA link code. Debtor address not updated.')
			if (@@error != 0) goto ErrHandler
		end
	end

	--EDA validation
	if (select count(*) from openxml (@idoc, '//account/Type4D',1) 
		with (ReturnCode char(1), Phone varchar(10))) = 0 begin
		if (@@error != 0) goto ErrHandler

		--insert note	
		insert into notes (number,created,user0,action,result,comment)
			values (@number,getdate(),'SkipSvc','EDA','IF','Debtor('+rtrim(ltrim(@DebtorName))+') No EDA match returned.')
		if (@@error != 0) goto ErrHandler
	end
	else if (select count(*) from openxml (@idoc, '//account/Type4D',1) 
		with (ReturnCode char(1), Phone varchar(10))
		where ReturnCode in ('A','B','C','D','E')
		and Phone not in (select OldNumber from PhoneHistory where debtorid = @DebtorID)) > 0 begin
		if (@@error != 0) goto ErrHandler

		--declare temp variables
		declare @newPhone as varchar(10), @returnCode char(1), @note varchar(256)		
		select top 1 @newPhone = x.Phone, @returnCode = ReturnCode,
		@note = case 
			when x.ReturnCode = 'A' then 'Debtor('+rtrim(ltrim(@DebtorName))+') EDA match (Debtor match tight). '
			when x.ReturnCode = 'B' then 'Debtor('+rtrim(ltrim(@DebtorName))+') EDA match (Debtor match tight). '
			when x.ReturnCode = 'C' then 'Debtor('+rtrim(ltrim(@DebtorName))+') EDA match (Relative/Surname match tight). '
			when x.ReturnCode = 'D' then 'Debtor('+rtrim(ltrim(@DebtorName))+') EDA match (Debtor match loose). '
			when x.ReturnCode = 'E' then 'Debtor('+rtrim(ltrim(@DebtorName))+') EDA match (Debtor match loose). '
			end
		from openxml (@idoc, '//account/Type4D',1) 
		with (ReturnCode char(1), Phone varchar(10)) x
		where x.ReturnCode in ('A','B','C','D','E')
		and x.Phone not in (select OldNumber from PhoneHistory where debtorid = @DebtorID)
		order by x.ReturnCode asc
		if (@@error != 0) goto ErrHandler

		if (select count(*) from debtors 
			where debtorid = @DebtorID and homephone = @newPhone) > 0 begin
			if (@@error != 0) goto ErrHandler

			--homephone matches returned EDA phone. make no changes
			--insert note	
			insert into notes (number,created,user0,action,result,comment)
				values (@number,getdate(),'SkipSvc','EDA','IF', @note + ' Home phone already set to '+@newPhone +'.')
			if (@@error != 0) goto ErrHandler
			goto cuExit
		end

		--insert PhoneHistory (move current debtor home phone to PhoneHistory table)
		insert into PhoneHistory (AccountID, DebtorID, DateChanged, UserChanged, PhoneType, OldNumber, NewNumber)
		select number, debtorid, getdate(), 'SkipSvc', 1, isnull(homephone,''), @newPhone from debtors  
		where debtorid = @DebtorID
		if (@@error != 0) goto ErrHandler

		--update debtor home phone with returned EDA phone
		update debtors
			set homephone = @newPhone
		where debtorid = @DebtorID
		if (@@error != 0) goto ErrHandler

		--update master home phone with returned EDA phone if this is debtor zero
		if @DebtorSeq = '0' begin
			update master
				set homephone = @newPhone
			where number = @Number
			if (@@error != 0) goto ErrHandler
		end

		--insert note	
		insert into notes (number,created,user0,action,result,comment)
			values (@number,getdate(),'SkipSvc','EDA','IF', @note + ' Home phone updated to '+@newPhone +'.')
		if (@@error != 0) goto ErrHandler
	end

	else if (select count(*) from openxml (@idoc, '//account/Type4D',1) 
		with (ReturnCode char(1), Phone varchar(10)) 
		where ReturnCode in ('A','B','C','D','E')
		and Phone in (select OldNumber from PhoneHistory where debtorid = @DebtorID)) > 0 begin
		if (@@error != 0) goto ErrHandler

		--insert note	
		insert into notes (number,created,user0,action,result,comment)
			values (@number,getdate(),'SkipSvc','EDA','IF','Debtor('+rtrim(ltrim(@DebtorName))+') EDA matches number in phone history. Phone number not updated.')
		if (@@error != 0) goto ErrHandler
	end

	else if (select count(*) from openxml (@idoc, '//account/Type4D',1) 
		with (ReturnCode char(1), Phone varchar(10))
		where ReturnCode not in ('A','B','C','D','E')) > 0 begin
		if (@@error != 0) goto ErrHandler

		--insert note	
		insert into notes (number,created,user0,action,result,comment)
			values (@number,getdate(),'SkipSvc','EDA','IF','Debtor('+rtrim(ltrim(@DebtorName))+') EDA match returned. Invalid return code to update phone.')
		if (@@error != 0) goto ErrHandler
	end

	-- Remove the document from memory */ 
	exec sp_xml_removedocument @idoc
	if (@@error != 0) goto ErrHandler

cuExit:
	if (@@error != 0) goto ErrHandler
	Return	
ErrHandler:
	RAISERROR('Error encountered in spls_DoSkipTraceXml for debtor id %d.  spls_DoSkipTraceXml failed.', 11, 1, @DebtorID)
	Return




GO
