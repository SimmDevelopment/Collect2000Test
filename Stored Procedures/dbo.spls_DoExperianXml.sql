SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.spls_DoExperianXml    Script Date: 12/21/2005 4:22:07 PM ******/





/****** Object:  Stored Procedure dbo.spls_DoExperianXml    Script Date: 9/8/2005 8:49:13 AM ******/

/*dbo.spls_DoExperianXml*/
CREATE  proc [dbo].[spls_DoExperianXml]
	@RequestID int, @BatchID uniqueidentifier, 
	@XPathMatchRequestID varchar(256), @CompletionDesk varchar(10), @doc ntext
AS
-- Name:		spls_DoExperianXml
-- Function:		This procedure will process returned experian info from outside service
-- Creation:		02/02/2005 jc
--			Used by Latitude Scheduler.
-- Change History:	4/6/2005 jc revised inserts of street1 and city due to data truncation 
--			6/15/2005 jc Experian change in bankruptcy code doc: changed BK 7-FILE code 36 to 23			
--			9/8/2005 jc per Carl, comment out all updates to latitude debtor data.
	declare @idoc int, @xmlRequestID int, 
	@DebtorID int, @Number int, @DebtorSeq int, @DebtorName varchar(30), @customer varchar(7),
	@ExperianReturned int

	--assign xmlinforeturned to local variable
	if @doc is null begin
		RAISERROR('Invalid xml info for requestid %d. spls_DoExperianXml failed.', 11, 1, @RequestID)
		goto ErrHandler
	end

	-- Create an internal representation of the XML document.
	exec sp_xml_preparedocument @idoc output, @doc
	if (@@error != 0) goto ErrHandler

	--look for experian data retrieve servicehistory requestid from xml
	select @xmlRequestID = RequestID
	from openxml (@idoc, @XPathMatchRequestID, 3)
	with (RequestID int)
	if (@@error != 0) goto ErrHandler

	if @xmlRequestID is null begin
		RAISERROR('Experian: Invalid RequestId contained in xml data for requestid %d xmlrequestid %d. spls_DoExperianXml failed.', 11, 1, @RequestID, @xmlRequestID)
		goto ErrHandler
	end
	else begin
		if @RequestID = @xmlRequestID begin
			--experian info returned
			set @ExperianReturned = 1
		end
		else begin
			RAISERROR('Experian: RequestId contained in xml data does not match passed in requestid %d xmlrequestid %d. spls_DoExperianXml failed.', 11, 1, @RequestID, @xmlRequestID)
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
		RAISERROR('Could not find a file number for debtor id %d. spls_DoExperianXml failed. ', 11, 1, @RequestID)
    		goto ErrHandler
  	end

	/*
	declare @processedFlag int
	select @processedFlag = processed from ServiceHistory with (nolock) where RequestID = @RequestID
	if (@@error != 0) goto ErrHandler
	if @processedFlag is null begin
		RAISERROR('Invalid processed flag value for debtor id %d. spls_DoExperianXml failed. ', 11, 1, @RequestID)
    		goto ErrHandler
  	end
	--Request already processed
	if @processedFlag = 3 begin
		goto cuExit
	end
	*/

	--update service history response
	update ServiceHistory_RESPONSES 
		set DateProcessed = getdate()
	where RequestID = @RequestID
	if (@@error != 0) goto ErrHandler

	--update service history 
	update ServiceHistory 
		set Processed = case @ExperianReturned when 0 then 2 else 3 end
	where RequestId = @RequestID and BatchID = @BatchID
	if (@@error != 0) goto ErrHandler

	--update master account (desk)
	--update master set desk = @CompletionDesk where number = @number
	--update master set desk1 = null where number = @number
	if (@@error != 0) goto ErrHandler

	if @ExperianReturned = 0 begin
		--no Experian info returned
		--insert note	
		insert into notes (number,created,user0,action,result,comment)
			values (@number,getdate(),'ExprSvc','SKIP','IF','Debtor('+rtrim(ltrim(@DebtorName))+') No Experian information found.')
		if (@@error != 0) goto ErrHandler
		goto cuExit
	end

	--check result code
	declare @f4 char(2), @f5 char(3)

	select @f4 = [f4-FileOneResultCode], @f5 = [f5-ExperianFileOneErrorCode] from openxml (@idoc, '//account', 1)
	with ([f4-FileOneResultCode] char(2), [f5-ExperianFileOneErrorCode] char(3))
	if @f4 is null begin
		--invalid file one result code
		RAISERROR('Invalid file one result code returned for requestid %d. spls_DoExperianXml failed.', 11, 1, @RequestID)
		goto ErrHandler
	end
	if @f4 = 'ER' begin
		declare @errorDescription varchar(50)
		if @f5 is null begin
			set @errorDescription = 'Invalid Experian File One Error Code'
		end
		else if @f5 = '045' begin
			set @errorDescription = 'Error Code ' + @f5 + ': Invalid Surname C'
		end
		else if @f5 = '403' begin
			set @errorDescription = 'Error Code ' + @f5 + ': SS# Required to access consumers file'
		end
		else if @f5 = '407' begin
			set @errorDescription = 'Error Code ' + @f5 + ': Unable to standardize current address'
		end
		else if @f5 = '633' begin
			set @errorDescription = 'Error Code ' + @f5 + ': Curr/Billing address line exceeds max size'
		end
		else begin
			set @errorDescription = 'Error Code ' + @f5 + ': occurred'
		end
		--error on input (client not charged no billing)
		--insert note	
		insert into notes (number,created,user0,action,result,comment)
			values (@number,getdate(),'ExprSvc','ECA','IF','Debtor('+rtrim(ltrim(@DebtorName))+') Experian error. ' + @errorDescription)
		if (@@error != 0) goto ErrHandler
		goto cuExit
	end

	--Experian info returned
	if @ExperianReturned = 1 begin
		--Experian info returned
		--insert note	
		insert into notes (number,created,user0,action,result,comment)
			values (@number,getdate(),'ExprSvc','SKIP','IF','Debtor('+rtrim(ltrim(@DebtorName))+') Experian information returned.')
		if (@@error != 0) goto ErrHandler
		goto cuExit
	end
	----------------------------------------------------------------------------------------------------------
/*
	--ssn information 
	declare @f79 char(2), @f80 char(1), @f81 char(2), @f82 char(9), @f83 char(9), @f84 char(9)
	select @f79 = [f79-Seg01-SsnValidationResultCode], 
		@f80 = [f80-Seg01-SsnIssuedSocialFraudShieldResultCode],
		@f81 = [f81-Seg01-SsnAppendResultCode],
		@f82 = [f82-Seg01-BestFileOneSsn],
		@f83 = [f83-Seg01-AdditionalFileOneSsn],
		@f84 = [f84-Seg01-AdditionalFileOneSsn]
	from openxml (@idoc, '//account', 1)
	with ([f79-Seg01-SsnValidationResultCode] char(2), 
		[f80-Seg01-SsnIssuedSocialFraudShieldResultCode] char(1),
		[f81-Seg01-SsnAppendResultCode] char(2),
		[f82-Seg01-BestFileOneSsn] char(9),
		[f83-Seg01-AdditionalFileOneSsn] char(9),
		[f84-Seg01-AdditionalFileOneSsn] char(9))
	--check ssn validation result code
	if @f79 is not null begin
		declare @ssnResult varchar(256)
		--validate ssn
		if ltrim(rtrim(@f79)) = 'V' begin
			set @ssnResult = 'Input SSN verified with Best File One SSN. ' 
		end
		if ltrim(rtrim(@f79)) = 'M' begin
			set @ssnResult = 'Input SSN matched other File One SSN. '
		end
		if ltrim(rtrim(@f79)) = 'N' begin
			set @ssnResult = 'Input SSN did not match Experian. '
		end
		if ltrim(rtrim(@f79)) = 'Z' begin
			set @ssnResult = 'Input SSN could not be verified (not provided). '
		end
		if ltrim(rtrim(@f79)) = 'K' begin
			set @ssnResult = 'Verify resulted in SSN Append (no SSN input). '
		end
		if ltrim(rtrim(@f79)) = 'X' begin
			set @ssnResult = 'Verify resulted in SSN Append (no match). '
		end
		--check for ssn issued social fraud shield result code
		if @f80 is not null begin
			if @f80 = 'Y' begin
				--insert note	
				insert into notes (number,created,user0,action,result,comment)
					values (@number,getdate(),'EcaSvc','EcaSvc','IF','Debtor('+rtrim(ltrim(@DebtorName))+') SSN Issued Social Fraud Alert')
				if (@@error != 0) goto ErrHandler
			end
			else if @f80 = 'N' begin
				--insert note	
				insert into notes (number,created,user0,action,result,comment)
					values (@number,getdate(),'EcaSvc','EcaSvc','IF','Debtor('+rtrim(ltrim(@DebtorName))+') SSN Fraud not found')
				if (@@error != 0) goto ErrHandler
			end
		end
		--append returned ssn's
		if @f81 is not null begin
			if @f82 is not null begin
				set @ssnResult = @ssnResult + 'Best File One SSN = [' + @f82 + ']. '
			end
			if @f83 is not null begin
				set @ssnResult = @ssnResult + 'Additional File One SSN = [' + @f83 + ']. '
			end
			if @f84 is not null begin
				set @ssnResult = @ssnResult + 'Additional File One SSN = [' + @f84 + ']. '
			end
		end
		--insert note	
		insert into notes (number,created,user0,action,result,comment)
			values (@number,getdate(),'EcaSvc','EcaSvc','IF','Debtor('+rtrim(ltrim(@DebtorName))+') ' + @ssnResult)
		if (@@error != 0) goto ErrHandler
	end
	----------------------------------------------------------------------------------------------------------
	--address information
	declare @AddressToUse int, @f108 char(8), @f362 char(8)
	select @f108 = [f108-Seg02-DateAddressLastUpdated], @f362 = [f362-PhoneCoa-DateAddressLastUpdated]
	from openxml (@idoc, '//account', 1)
	with ([f108-Seg02-DateAddressLastUpdated] char(8), [f362-PhoneCoa-DateAddressLastUpdated] char(8))
	--set date last updated local variables	
	if @f108 is null and @f362 is null begin
		--no addresses returned
		set @AddressToUse = 0
	end
	else if @f108 is not null begin
		--use best name and address
		set @AddressToUse = 1
	end
	else if @f362 is not null begin
		--use coa address
		set @AddressToUse = 2
	end
	else begin
		--compare datetime of best name and address last update to change of address last update
		--use address most recently updated
		--assign dates to local variables
		declare @date1 datetime, @date2 datetime
		set @date1 = convert(datetime, SUBSTRING(@f108, 5, 4) + SUBSTRING(@f108, 1, 4), 112)
		set @date2 = convert(datetime, SUBSTRING(@f362, 5, 4) + SUBSTRING(@f362, 1, 4), 112)
		if @date1 >= @date2 begin
			--use best name and address
			set @AddressToUse = 1
		end
		else begin
			--use coa address
			set @AddressToUse = 2
		end
	end


	if @AddressToUse = 1 begin

		--verify good data for best name and address
		declare @f99 varchar(60), @f100 varchar(32), @f101 varchar(2), @f102 varchar(9)
		select @f99 = x.[f99-Seg02-BestStreetAddress], @f100 = x.[f100-Seg02-BestCity], 
			@f101 = x.[f101-Seg02-BestState], @f102 = x.[f102-Seg02-BestZipCode]
		from openxml (@idoc, '//account', 1)
		with (RequestID int, [f99-Seg02-BestStreetAddress] varchar(60), [f100-Seg02-BestCity] varchar(32), 
			[f101-Seg02-BestState] varchar(2), [f102-Seg02-BestZipCode] varchar(9)) x
		inner join servicehistory sh with(nolock) on sh.RequestID = x.RequestID
		inner join debtors d with(nolock) on d.debtorid = sh.debtorid
		if (@@error != 0) goto ErrHandler

		--only process this address if street1, city, state, and zip are all not null
		if @f99 is not null and @f100 is not null and @f101 is not null and @f102 is not null begin
			--use best name and address
			--insert AddressHistory (move current debtor address to AddressHistory table)
			insert into AddressHistory(AccountID, DebtorID, DateChanged, UserChanged, 
			OldStreet1, OldStreet2, OldCity, OldState, OldZipcode, NewStreet1, NewStreet2,
			NewCity, NewState, NewZipcode)
			select d.number, d.debtorid, getdate(), 'EcaSvc', isnull(d.Street1,''), isnull(d.Street2,''), isnull(d.City,''), d.State, d.Zipcode, 
				substring(x.[f99-Seg02-BestStreetAddress],1,50), '', x.[f100-Seg02-BestCity], 
				x.[f101-Seg02-BestState], x.[f102-Seg02-BestZipCode]
			from openxml (@idoc, '//account', 1)
			with (RequestID int, [f99-Seg02-BestStreetAddress] varchar(60), [f100-Seg02-BestCity] varchar(32), 
				[f101-Seg02-BestState] varchar(2), [f102-Seg02-BestZipCode] varchar(9)) x
			inner join servicehistory sh with(nolock) on sh.RequestID = x.RequestID
			inner join debtors d with(nolock) on d.debtorid = sh.debtorid
			if (@@error != 0) goto ErrHandler
			--update debtor address with returned best name and address address
			update debtors
				set debtors.Street1 = substring(x.[f99-Seg02-BestStreetAddress],1,30), debtors.Street2 = '', 
				debtors.City = substring(x.[f100-Seg02-BestCity],1,30), debtors.State = x.[f101-Seg02-BestState], 
				debtors.Zipcode = x.[f102-Seg02-BestZipCode]
			from openxml (@idoc, '//account', 1) 
				with (RequestID int, [f99-Seg02-BestStreetAddress] varchar(60), [f100-Seg02-BestCity] varchar(32), 
				[f101-Seg02-BestState] varchar(2), [f102-Seg02-BestZipCode] varchar(9)) x
			where debtors.debtorid = @DebtorID
			if (@@error != 0) goto ErrHandler
			--update master address with returned best name and address if this is debtor zero
			if @DebtorSeq = '0' begin
				update master
					set master.Street1 = substring(x.[f99-Seg02-BestStreetAddress],1,30), master.Street2 = '', 
					master.City = substring(x.[f100-Seg02-BestCity],1,20), master.State = x.[f101-Seg02-BestState], 
					master.Zipcode = x.[f102-Seg02-BestZipCode]
				from openxml (@idoc, '//account', 1) 
					with ([f99-Seg02-BestStreetAddress] varchar(60), [f100-Seg02-BestCity] varchar(32), 
					[f101-Seg02-BestState] varchar(2), [f102-Seg02-BestZipCode] varchar(9)) x
				where master.number = @Number
				if (@@error != 0) goto ErrHandler
			end
			--insert note	
			insert into notes (number,created,user0,action,result,comment)
				values (@number,getdate(),'EcaSvc','EcaSvc','IF','Debtor('+rtrim(ltrim(@DebtorName))+') Best Name and Address match returned. Debtor address updated.')
			if (@@error != 0) goto ErrHandler
		end
		else begin
			--insert note	
			insert into notes (number,created,user0,action,result,comment)
				values (@number,getdate(),'EcaSvc','EcaSvc','IF','Debtor('+rtrim(ltrim(@DebtorName))+') Best Address match returned but incomplete. Debtor address not updated.')
			if (@@error != 0) goto ErrHandler
		end
	end
	else if @AddressToUse = 2 begin	
		--use coa address
		declare @f343 varchar(15), @f344 varchar(10), @f345 varchar(32), @f346 varchar(10), @f347 varchar(10) 
		declare @f348 varchar(10), @f349 varchar(15), @f352 varchar(5), @f353 varchar(4)
		select @f343 = [f343-PhoneCoa-HouseNumber], @f344 = [f344-PhoneCoa-PreDirectional],
			@f345 = [f345-PhoneCoa-StreetName], @f346 = [f346-PhoneCoa-PostDirectional],
			@f347 = [f347-PhoneCoa-Suffix], @f348 = [f348-PhoneCoa-UnitDesignator],
			@f349 = [f349-PhoneCoa-UnitNumber], @f352 = [f352-PhoneCoa-ZipCode],
			@f353 = [f353-PhoneCoa-ZipPlus4]
		from openxml (@idoc, '//account', 1)
		with ([f343-PhoneCoa-HouseNumber] varchar(15), [f344-PhoneCoa-PreDirectional] varchar(10), 
			[f345-PhoneCoa-StreetName] varchar(32), [f346-PhoneCoa-PostDirectional] varchar(10),
			[f347-PhoneCoa-Suffix] varchar(10), [f348-PhoneCoa-UnitDesignator] varchar(10),
			[f349-PhoneCoa-UnitNumber] varchar(15), [f352-PhoneCoa-ZipCode] varchar(5),
			[f353-PhoneCoa-ZipPlus4] varchar(4))
		--print 'coa address update'
		declare @coaAddress varchar(256)
		declare @coaZip varchar(9)
		set @coaAddress = ltrim(rtrim(isnull(@f343,''))) + ' ' + ltrim(rtrim(isnull(@f344,''))) + ' ' + ltrim(rtrim(isnull(@f345,''))) + ' ' + ltrim(rtrim(isnull(@f346,''))) + ' ' + ltrim(rtrim(isnull(@f347,''))) + ' ' + ltrim(rtrim(isnull(@f348,''))) + ' ' + ltrim(rtrim(isnull(@f349,''))) 
		while (charindex('  ',@coaAddress) <> 0) 
		begin 
		  set @coaAddress = replace(@coaAddress,'  ',' ') 
		end 
		set @coaZip = ltrim(rtrim(isnull(@f352,''))) + ' ' + ltrim(rtrim(isnull(@f353,''))) 
		set @coaZip = ltrim(rtrim(isnull(@coaZip,''))) 
		--insert AddressHistory (move current debtor address to AddressHistory table)
		insert into AddressHistory(AccountID, DebtorID, DateChanged, UserChanged, 
		OldStreet1, OldStreet2, OldCity, OldState, OldZipcode, NewStreet1, NewStreet2,
		NewCity, NewState, NewZipcode)
		select d.number, d.debtorid, getdate(), 'EcaSvc', isnull(d.Street1,''), isnull(d.Street2,''), isnull(d.City,''), d.State, d.Zipcode, 
			substring(@coaAddress,1,50), '', x.[f350-PhoneCoa-City], x.[f351-PhoneCoa-State], @coaZip
		from openxml (@idoc, '//account', 1)
		with (RequestID int, [f350-PhoneCoa-City] varchar(32), [f351-PhoneCoa-State] varchar(2)) x
		inner join servicehistory sh with(nolock) on sh.RequestID = x.RequestID
		inner join debtors d with(nolock) on d.debtorid = sh.debtorid
		if (@@error != 0) goto ErrHandler
		--update debtor address with returned best name and address address
		update debtors
			set debtors.Street1 = substring(@coaAddress,1,30), debtors.Street2 = '', 
			debtors.City = substring(x.[f350-PhoneCoa-City],1,30), debtors.State = x.[f351-PhoneCoa-State], 
			debtors.Zipcode = @coaZip
		from openxml (@idoc, '//account', 1) 
			with ([f350-PhoneCoa-City] varchar(32), [f351-PhoneCoa-State] varchar(2)) x
		where debtors.debtorid = @DebtorID
		if (@@error != 0) goto ErrHandler
		--update master address with returned best name and address if this is debtor zero
		if @DebtorSeq = '0' begin
			update master
				set master.Street1 = substring(@coaAddress,1,30), master.Street2 = '', 
				master.City = substring(x.[f350-PhoneCoa-City],1,20), master.State = x.[f351-PhoneCoa-State], 
				master.Zipcode = @coaZip
			from openxml (@idoc, '//account', 1) 
				with ([f350-PhoneCoa-City] varchar(32), [f351-PhoneCoa-State] varchar(2)) x
			where master.number = @Number
			if (@@error != 0) goto ErrHandler
		end
		--insert note	
		insert into notes (number,created,user0,action,result,comment)
			values (@number,getdate(),'EcaSvc','EcaSvc','IF','Debtor('+rtrim(ltrim(@DebtorName))+') Change of Address match returned. Debtor address updated.')
		if (@@error != 0) goto ErrHandler
	end
	else begin
		--insert note	
		insert into notes (number,created,user0,action,result,comment)
			values (@number,getdate(),'EcaSvc','EcaSvc','IF','Debtor('+rtrim(ltrim(@DebtorName))+') No address match returned.')
		if (@@error != 0) goto ErrHandler
	end
	----------------------------------------------------------------------------------------------------------
	--employment information
	--if any existing debtor employee information exists then write the experian employment info to notes
	-- otherwise update debtor jobname with experian employer name and experian returned address and 
	-- date last updated to debtor jobmemo. Given the way experian returns employer address info it is not
	-- possible to properly update debtor jobaddr1, jobaddr2, and jobcsz. 
	declare @f146 char(2), @f147 varchar(30), @f148 varchar(32), @f149 varchar(32), @f150 varchar(32), @f151 varchar(9), @f153 char(8)
	select @f146 = [f146-Seg05-EmploymentResultCode], 
		@f147 = [f147-Seg05-EmployerName],
		@f148 = [f148-Seg05-EmployerAddress1],
		@f149 = [f149-Seg05-EmployerAddress2],
		@f150 = [f150-Seg05-EmployerAddress3],
		@f151 = [f151-Seg05-EmployerZipCode],
		@f153 = [f153-Seg05-DateLastUpdated]
	from openxml (@idoc, '//account', 1)
	with ([f146-Seg05-EmploymentResultCode] char(2), 
		[f147-Seg05-EmployerName] varchar(30),
		[f148-Seg05-EmployerAddress1] varchar(32),
		[f149-Seg05-EmployerAddress2] varchar(32),
		[f150-Seg05-EmployerAddress3] varchar(32),
		[f151-Seg05-EmployerZipCode] varchar(9),
		[f153-Seg05-DateLastUpdated] char(8))
	--check employment result code
	if @f146 is not null begin
		--check for appended employment info
		if ltrim(rtrim(@f146)) = 'Y' begin
			declare @empAddress varchar(256)
			declare @empCSZ varchar(256)
			declare @empUpdated varchar(256)
			set @empAddress = ltrim(rtrim(isnull(@f148,''))) + ' ' + ltrim(rtrim(isnull(@f149,''))) + ' ' + ltrim(rtrim(isnull(@f150,''))) + ' ' + ltrim(rtrim(isnull(@f151,'')))   
			set @empCSZ = ltrim(rtrim(isnull(@f150,''))) + ' ' + ltrim(rtrim(isnull(@f151,'')))   
			if @f153 is not null begin
				set @empUpdated = 'Employer info last updated ' + substring(@f153, 1, 2) + '/' + substring(@f153, 3, 2) + '/' + substring(@f153, 5, 4) + '. '
			end
			while (charindex('  ',@empAddress) <> 0) 

			begin 
			  set @empAddress = replace(@empAddress,'  ',' ') 
			end 
			while (charindex('  ',@empCSZ) <> 0) 
			begin 
			  set @empCSZ = replace(@empCSZ,'  ',' ') 
			end 
			if (select count(*) from debtors d with(nolock) 
				where d.debtorid = @DebtorID and len( ltrim(rtrim(d.jobname)) + ltrim(rtrim(d.jobaddr1)) + ltrim(rtrim(d.jobaddr2)) + ltrim(rtrim(d.jobcsz))) > 0) > 0 begin
				if (@@error != 0) goto ErrHandler

				--debtor has existing employer info so concatenate employer name to address variable in
				--order to insert into notes
				set @empAddress = ltrim(rtrim(isnull(@f147,''))) + ' ' + @empAddress 

				--insert employment note	
				insert into notes (number,created,user0,action,result,comment)
					values (@number,getdate(),'EcaSvc','EcaSvc','IF','Debtor('+rtrim(ltrim(@DebtorName))+') Employment info returned but debtor already has employer info. ' + @empAddress)
				if (@@error != 0) goto ErrHandler
			end
			else begin
				--debtor has no existing employer info so update debtor jobname and jobmemo.
				update debtors
					set debtors.jobname = @f147, 
					debtors.jobaddr1 = ltrim(rtrim(isnull(@f148,''))),
					debtors.jobaddr2 = ltrim(rtrim(isnull(@f149,''))),
					debtors.jobcsz = ltrim(rtrim(isnull(@f150,''))),
					debtors.jobmemo = @empUpdated
				where debtors.debtorid = @DebtorID
				if (@@error != 0) goto ErrHandler

				--insert employment note	
				insert into notes (number,created,user0,action,result,comment)
					values (@number,getdate(),'EcaSvc','EcaSvc','IF','Debtor('+rtrim(ltrim(@DebtorName))+') Employment info returned. Debtor employment updated.')
				if (@@error != 0) goto ErrHandler
			end
		end
	end
	----------------------------------------------------------------------------------------------------------
	--1st mortgage information
	--update debtor assets with experian returned 1st mortgage info contained in 33 credit attributes
	declare @f187 varchar(9), @f188 varchar(9)
	select @f187 = [f187-Seg07-Q24TMT11], 
		@f188 = [f188-Seg07-Q24TMT12]
	from openxml (@idoc, '//account', 1)
	with ([f187-Seg07-Q24TMT11] varchar(9), 
		[f188-Seg07-Q24TMT12] varchar(9))
	--check for mortgage info
	if @f187 is not null begin
		--look for a non-zero value fro f187
		--assign value to local variable
		--declare @1mortgage money
		--set @1mortgage = cast (@f187 as money)
		--if @1mortgage > 0 begin
	if @f187 <> '000000000' begin
		--check for appended employment info
		declare @f187desc varchar(256)
		declare @f188desc varchar(256)
		set @f187desc = 'Sum of credit amount = ' + ltrim(rtrim(isnull(@f187,''))) + '. '
		set @f188desc = 'Sum of balance amount = ' + ltrim(rtrim(isnull(@f188,''))) + '. '

		if (select count(*) from debtor_assets da with(nolock) 
			where da.debtorid = @DebtorID 
			and da.name = '1st Mortgage - Experian Collection Advantage'
			) > 0 begin
			if (@@error != 0) goto ErrHandler

			--update debtor asset
			update debtor_assets
				set accountid = @number, assettype = 2, description = @f187desc + @f188desc
			where debtorid = @DebtorID
			and name = '1st Mortgage - Experian Collection Advantage'

			--insert note
			insert into notes (number,created,user0,action,result,comment)
				values (@number,getdate(),'EcaSvc','EcaSvc','IF','Debtor('+rtrim(ltrim(@DebtorName))+') 1st mortgage info returned. Debtor asset updated.')
			if (@@error != 0) goto ErrHandler
		end
		else begin
			--insert debtor asset
			insert into debtor_assets (accountid, debtorid, name, assettype, description, valueverified, lienverified)
				values (@number, @DebtorID, '1st Mortgage - Experian Collection Advantage', 2, @f187desc + @f188desc, 0, 0)
			if (@@error != 0) goto ErrHandler

			--insert note
			insert into notes (number,created,user0,action,result,comment)
				values (@number,getdate(),'EcaSvc','EcaSvc','IF','Debtor('+rtrim(ltrim(@DebtorName))+') 1st mortgage info returned. Debtor asset inserted.')
			if (@@error != 0) goto ErrHandler
		end
	end
	end

	----------------------------------------------------------------------------------------------------------
	--2nd mortgage information
	--update debtor assets with experian returned 2nd mortgage info contained in 33 credit attributes
	declare @f189 varchar(9), @f190 varchar(9)
	select @f189 = [f189-Seg07-Q24THE11], 
		@f190 = [f190-Seg07-Q24THE12]
	from openxml (@idoc, '//account', 1)
	with ([f189-Seg07-Q24THE11] varchar(9), 
		[f190-Seg07-Q24THE12] varchar(9))
	--check for mortgage info
	if @f189 is not null begin
	if @f189 <> '000000000' begin
		--check for appended employment info
		declare @f189desc varchar(256)
		declare @f190desc varchar(256)
		set @f189desc = 'Sum of credit amount = ' + ltrim(rtrim(isnull(@f189,''))) + '. '
		set @f190desc = 'Sum of balance amount = ' + ltrim(rtrim(isnull(@f190,''))) + '. '

		if (select count(*) from debtor_assets da with(nolock) 
			where da.debtorid = @DebtorID 
			and da.name = '2nd Mortgage - Experian Collection Advantage'
			) > 0 begin
			if (@@error != 0) goto ErrHandler

			--update debtor asset
			update debtor_assets
				set accountid = @number, assettype = 2, description = @f189desc + @f190desc
			where debtorid = @DebtorID
			and name = '2nd Mortgage - Experian Collection Advantage'

			--insert note
			insert into notes (number,created,user0,action,result,comment)
				values (@number,getdate(),'EcaSvc','EcaSvc','IF','Debtor('+rtrim(ltrim(@DebtorName))+') 2nd mortgage info returned. Debtor asset updated.')
			if (@@error != 0) goto ErrHandler
		end
		else begin
			--insert debtor asset
			insert into debtor_assets (accountid, debtorid, name, assettype, description, valueverified, lienverified)
				values (@number, @DebtorID, '2nd Mortgage - Experian Collection Advantage', 2, @f189desc + @f190desc, 0, 0)
			if (@@error != 0) goto ErrHandler

			--insert note
			insert into notes (number,created,user0,action,result,comment)
				values (@number,getdate(),'EcaSvc','EcaSvc','IF','Debtor('+rtrim(ltrim(@DebtorName))+') 2nd mortgage info returned. Debtor asset inserted.')
			if (@@error != 0) goto ErrHandler
		end
	end
	end

	----------------------------------------------------------------------------------------------------------
	--auto loan information
	--update debtor assets with experian returned auto loan info contained in 33 credit attributes
	declare @f197 varchar(9), @f198 varchar(9)
	select @f197 = [f197-Seg07-Q24TAU12], 
		@f198 = [f198-Seg07-Q24TAU13]
	from openxml (@idoc, '//account', 1)
	with ([f197-Seg07-Q24TAU12] varchar(9), 
		[f198-Seg07-Q24TAU13] varchar(9))
	--check for mortgage info
	if @f197 is not null begin
	if @f197 <> '000000000' begin
		--check for appended employment info
		declare @f197desc varchar(256)
		declare @f198desc varchar(256)
		set @f197desc = 'Sum of balance amount = ' + ltrim(rtrim(isnull(@f197,''))) + '. '
		set @f198desc = '% of credit utilization = ' + ltrim(rtrim(isnull(@f198,''))) + '. '

		if (select count(*) from debtor_assets da with(nolock) 
			where da.debtorid = @DebtorID 
			and da.name = 'Auto Loan - Experian Collection Advantage'
			) > 0 begin
			if (@@error != 0) goto ErrHandler

			--update debtor asset
			update debtor_assets
				set accountid = @number, assettype = 1, description = @f197desc + @f198desc
			where debtorid = @DebtorID
			and name = 'Auto Loan - Experian Collection Advantage'

			--insert note
			insert into notes (number,created,user0,action,result,comment)
				values (@number,getdate(),'EcaSvc','EcaSvc','IF','Debtor('+rtrim(ltrim(@DebtorName))+') Auto loan info returned. Debtor asset updated.')
			if (@@error != 0) goto ErrHandler
		end
		else begin
			--insert debtor asset
			insert into debtor_assets (accountid, debtorid, name, assettype, description, valueverified, lienverified)
				values (@number, @DebtorID, 'Auto Loan - Experian Collection Advantage', 1, @f197desc + @f198desc, 0, 0)
			if (@@error != 0) goto ErrHandler

			--insert note
			insert into notes (number,created,user0,action,result,comment)
				values (@number,getdate(),'EcaSvc','EcaSvc','IF','Debtor('+rtrim(ltrim(@DebtorName))+') Auto loan info returned. Debtor asset inserted.')
			if (@@error != 0) goto ErrHandler
		end
	end
	end

	----------------------------------------------------------------------------------------------------------
	--bankruptcy information
	declare @BankruptcyReturned varchar(2)
	select @BankruptcyReturned = x.[f211-Seg09-BankruptcyScreenResultCode] from openxml (@idoc, '//account',1) 
	with ([f211-Seg09-BankruptcyScreenResultCode] varchar(2)) x
	if (@@error != 0) goto ErrHandler

	--check for bankruptcy info
	if @BankruptcyReturned is not null begin
	if @BankruptcyReturned = 'Y' begin
		--bankruptcy info returned
		declare @BankruptcyValid int
		set @BankruptcyValid = 1
		--assign local variables from account dates 
		declare @ContractDate datetime, @CliDlp datetime, @ChargeOffDate datetime
		select @ContractDate = ContractDate, @CliDlp = CliDlp, @ChargeOffDate = ChargeOffDate 
			from master with(nolock) where number = @Number
		if (@@error != 0) goto ErrHandler

		--assign local variables from xml data
		declare @statuscode char(2), @statusdate datetime
		select @statuscode = x.[f212-Seg09-StatusCode], 
			@statusdate = cast(substring(x.[f213-Seg09-StatusDate],5,4)+substring(x.[f213-Seg09-StatusDate],1,2)+substring(x.[f213-Seg09-StatusDate],3,2) as datetime)
			from openxml (@idoc, @XPathMatchRequestID, 3)
	        with ([f212-Seg09-StatusCode] char(2), [f213-Seg09-StatusDate] varchar(10)) x
		if (@@error != 0) goto ErrHandler
	
		--search for an existing bankruptcy record
    		declare @BankruptcyExists int
    		select @BankruptcyExists = debtorid from Bankruptcy where debtorid = @DebtorID
		if (@@error != 0) goto ErrHandler

		--proceed based on status code
		if @statuscode in('13', '25', '27', '23') begin
			--bankruptcy filed
	    		if @BankruptcyExists is not null begin
				--bankruptcy exists - move to notes and delete
				exec spls_BankruptcyToNotes @DebtorID
				if (@@error != 0) goto ErrHandler
	    		end
			if @statusdate is not null begin
				if @ContractDate is not null begin
					if @statusdate < @ContractDate begin
						--insert note with bankruptcy info
						insert into notes (number,created,user0,action,result,comment)
							values (@number,getdate(),'EcaSvc','EcaSvc','IF','Debtor('+rtrim(ltrim(@DebtorName))+') Bankruptcy Filed: status date '+convert(varchar(10), @statusdate, 101)+' before Contract date '+convert(varchar(10), @ContractDate, 101)+'. ')
						if (@@error != 0) goto ErrHandler
						--bankruptcy not current
						set @BankruptcyValid = 0
					end
				end
				else if @CliDlp is not null begin
					if @statusdate < @CliDlp begin
						--insert note with bankruptcy info
						insert into notes (number,created,user0,action,result,comment)
							values (@number,getdate(),'EcaSvc','EcaSvc','IF','Debtor('+rtrim(ltrim(@DebtorName))+') Bankruptcy Filed: status date '+convert(varchar(10), @statusdate, 101)+' before CliDlp date '+convert(varchar(10), @CliDlp, 101)+'. ')
						if (@@error != 0) goto ErrHandler
						--bankruptcy not current
						set @BankruptcyValid = 0
					end
				end
				else if @ChargeOffDate is not null begin
					if @statusdate < @ChargeOffDate begin
						--insert note with bankruptcy info
						insert into notes (number,created,user0,action,result,comment)
							values (@number,getdate(),'EcaSvc','EcaSvc','IF','Debtor('+rtrim(ltrim(@DebtorName))+') Bankruptcy Filed: status date '+convert(varchar(10), @statusdate, 101)+' before ChargedOffDate date '+convert(varchar(10), @ChargeOffDate, 101)+'. ')
						if (@@error != 0) goto ErrHandler
						--bankruptcy not current
						set @BankruptcyValid = 0
					end
				end
			end
			else begin
				--insert note with bankruptcy error info
				insert into notes (number,created,user0,action,result,comment)
					values (@number,getdate(),'EcaSvc','EcaSvc','IF','Debtor('+rtrim(ltrim(@DebtorName))+') Returned bankruptcy status date is invalid: ('+convert(varchar(10), @statusdate, 101)+'). ')
				if (@@error != 0) goto ErrHandler
				--bankruptcy not current
				set @BankruptcyValid = 0
			end
		end
		else if @statuscode in('15', '17', '26', '28') begin
			--bankruptcy discharged
	    		if @BankruptcyExists is not null begin
				--bankruptcy exists - move to notes and delete
				exec spls_BankruptcyToNotes @DebtorID
				if (@@error != 0) goto ErrHandler
	    		end
			if @statusdate is not null begin
				if @ContractDate is not null begin
					if @statusdate < @ContractDate begin
						--insert note with bankruptcy info
						insert into notes (number,created,user0,action,result,comment)
							values (@number,getdate(),'EcaSvc','EcaSvc','IF','Debtor('+rtrim(ltrim(@DebtorName))+') Bankruptcy Discharged: status date '+convert(varchar(10), @statusdate, 101)+' before Contract date '+convert(varchar(10), @ContractDate, 101)+'. ')
						if (@@error != 0) goto ErrHandler
						--bankruptcy not current
						set @BankruptcyValid = 0
					end
				end
				else if @CliDlp is not null begin
					if @statusdate < @CliDlp begin
						--insert note with bankruptcy info
						insert into notes (number,created,user0,action,result,comment)
							values (@number,getdate(),'EcaSvc','EcaSvc','IF','Debtor('+rtrim(ltrim(@DebtorName))+') Bankruptcy Discharged: status date '+convert(varchar(10), @statusdate, 101)+' before CliDlp date '+convert(varchar(10), @CliDlp, 101)+'. ')
						if (@@error != 0) goto ErrHandler
						--bankruptcy not current
						set @BankruptcyValid = 0
					end
				end
				else if @ChargeOffDate is not null begin
					if @statusdate < @ChargeOffDate begin
						--insert note with bankruptcy info
						insert into notes (number,created,user0,action,result,comment)
							values (@number,getdate(),'EcaSvc','EcaSvc','IF','Debtor('+rtrim(ltrim(@DebtorName))+') Bankruptcy Discharged: status date '+convert(varchar(10), @statusdate, 101)+' before ChargedOffDate date '+convert(varchar(10), @ChargeOffDate, 101)+'. ')
						if (@@error != 0) goto ErrHandler
						--bankruptcy not current
						set @BankruptcyValid = 0
					end
				end
			end
			else begin
				--insert note with bankruptcy error info
				insert into notes (number,created,user0,action,result,comment)
					values (@number,getdate(),'EcaSvc','EcaSvc','IF','Debtor('+rtrim(ltrim(@DebtorName))+') Returned bankruptcy status date is invalid: ('+convert(varchar(10), @statusdate, 101)+'). ')
				if (@@error != 0) goto ErrHandler
				--bankruptcy not current
				set @BankruptcyValid = 0
			end
		end
		else if @statuscode in('16', '22', '24', '29') begin
			--bankruptcy dismissed
	    		if @BankruptcyExists is not null begin
				-- bankruptcy found - move to notes and delete
				exec spls_BankruptcyToNotes @DebtorID
				if (@@error != 0) goto ErrHandler
	    		end

			--insert note with bankruptcy info
			insert into notes (number,created,user0,action,result,comment)
				values (@number,getdate(),'EcaSvc','EcaSvc','IF','Debtor('+rtrim(ltrim(@DebtorName))+') Bankruptcy Dismissed. ')
			if (@@error != 0) goto ErrHandler
			--bankruptcy not current
			set @BankruptcyValid = 0
		end

		if @BankruptcyValid = 1 begin
			--insert bankruptcy record using xml input parameter @doc
			-- Execute an INSERT statement using OPENXML rowset provider.
			insert into Bankruptcy (AccountID,DebtorID,Chapter,DateFiled,
				CaseNumber,CourtCity,CourtDistrict,CourtDivision,CourtPhone,CourtStreet1,
				CourtStreet2,CourtState,CourtZipcode,Trustee,TrusteeStreet1,TrusteeStreet2,
				TrusteeCity,TrusteeState,TrusteeZipcode,TrusteePhone,Has341Info,DateTime341,
				Location341,Comments,Status)
			select @Number, @DebtorID, 
				case x.[f212-Seg09-StatusCode] 
					when '13' then '13'
					when '17' then '13'
					when '23' then '7'
					when '15' then '7'
					when '25' then '11'
					when '26' then '11'
					when '27' then '12'
					when '28' then '12'
				end,
				isnull(cast(substring(x.[f225-Seg09-OriginalFilingDate],1,2)+'/'+substring(x.[f225-Seg09-OriginalFilingDate],3,2)+'/'+substring(x.[f225-Seg09-OriginalFilingDate],5,4) as datetime),null)FileDate,
				x.[f216-Seg09-DocketNumber], '', '', '', '', '', 
				'', '', '', '',	'', '', 
				'', '', '', '', '', null, 
				'', 
				case when x.[f214-Seg09-CourtCode] is not null then 'CourtCode='+x.[f214-Seg09-CourtCode]+' ' else '' end+
				case when x.[f215-Seg09-CourtName] is not null then 'CourtName='+x.[f215-Seg09-CourtName]+' ' else '' end+
				case when x.[f217-Seg09-CreditorName] is not null then 'CreditorName='+x.[f217-Seg09-CreditorName]+' ' else '' end+
				case when x.[f218-Seg09-ECOACode] is not null then 'ECOACode='+x.[f218-Seg09-ECOACode]+' ' else '' end+
				case when x.[f219-Seg09-AssetAmount] is not null then 'AssetAmount='+x.[f219-Seg09-AssetAmount]+' ' else '' end+
				case when x.[f220-Seg09-LiabilitiesAmount] is not null then 'LiabilitiesAmount='+x.[f220-Seg09-LiabilitiesAmount]+' ' else '' end+
				case when x.[f221-Seg09-RepaymentPct] is not null then 'RepaymentPct='+x.[f221-Seg09-RepaymentPct]+' ' else '' end+
				case when x.[f222-Seg09-AdjustmentPct] is not null then 'AdjustmentPct='+x.[f222-Seg09-AdjustmentPct]+' ' else '' end+
				case when x.[f223-Seg09-BookPage] is not null then 'BookPage='+x.[f223-Seg09-BookPage]+' ' else '' end+
				case when x.[f224-Seg09-VolInVolBKIndicator] is not null then 'VolInVolBKIndicator='+x.[f224-Seg09-VolInVolBKIndicator]+' ' else '' end+
				case when x.[f226-Seg09-AttorneyName] is not null then 'AttorneyName='+x.[f226-Seg09-AttorneyName]+' ' else '' end+
				case when x.[f227-Seg09-AttorneyPhone] is not null then 'AttorneyPhone='+x.[f227-Seg09-AttorneyPhone]+' ' else '' end,
				case x.[f212-Seg09-StatusCode] 
					when '13' then 'BK 13-FILE'
					when '17' then 'BK 13-DISC'
					when '23' then 'BK 7-FILE'
					when '15' then 'BK 7-DISC'
					when '25' then 'BK 11-FILE'
					when '26' then 'BK 11-DISC'
					when '27' then 'BK 12-FILE'
					when '28' then 'BK 12-DISC'
				end
			from openxml (@idoc, @XPathMatchRequestID, 3)
		        with ([f212-Seg09-StatusCode] varchar(2), 
				[f225-Seg09-OriginalFilingDate] varchar(10), 
				[f216-Seg09-DocketNumber] varchar(24), 
				[f214-Seg09-CourtCode] varchar(7), 
				[f215-Seg09-CourtName] varchar(24),
				[f217-Seg09-CreditorName] varchar(32), 
				[f218-Seg09-ECOACode] varchar(1), 
				[f219-Seg09-AssetAmount] varchar(8), 
				[f220-Seg09-LiabilitiesAmount] varchar(8),
				[f221-Seg09-RepaymentPct] varchar(3), 
				[f222-Seg09-AdjustmentPct] varchar(2), 
				[f223-Seg09-BookPage] varchar(24), 
				[f224-Seg09-VolInVolBKIndicator] varchar(1),
				[f226-Seg09-AttorneyName] varchar(60), 
				[f227-Seg09-AttorneyPhone] varchar(10)) x
			if (@@error != 0) goto ErrHandler
			
			--update pending letters as deleted for this debtor
			if (select count(*) from letterrequest lr 
				inner join letterrequestrecipient lrr on lrr.letterrequestid = lr.letterrequestid 
				where lrr.debtorid = @DebtorID and lr.AccountID = @number and dateprocessed = '1753-01-01 12:00:00.000') > 0 begin
					--update letterrequests 
					update letterrequest 
						set deleted = 1, errordescription = 'Bankruptcy info returned '+convert(varchar(10), getdate(), 101)
					where accountid = @number and dateprocessed = '1753-01-01 12:00:00.000' 
					if (@@error != 0) goto ErrHandler
			end

			--insert note
			insert into notes (number,created,user0,action,result,comment)
				values (@number,getdate(),'EcaSvc','EcaSvc','IF','Debtor('+rtrim(ltrim(@DebtorName))+') Debtor bankruptcy info updated.')
			if (@@error != 0) goto ErrHandler

			--set suppress letters restriction on bankrupt accounts
			if @DebtorSeq is not null begin
				if (select count(*) from restrictions where debtorid = @DebtorID and number = @number) > 0 begin
					--update restrictions
					update restrictions set suppressletters = 1 where debtorid = @DebtorID and number = @number
					if (@@error != 0) goto ErrHandler
				end
				else begin
					--insert restrictions
					insert into restrictions(number, debtorid, suppressletters) values( @number, @DebtorID, 1)
					if (@@error != 0) goto ErrHandler
				end									
			end
		end
	end
	else begin
		--no bankruptcy info returned
		--insert note	
		insert into notes (number,created,user0,action,result,comment)
			values (@number,getdate(),'EcaSvc','EcaSvc','IF','Debtor('+rtrim(ltrim(@DebtorName))+') No bankrupcty info returned.')
		if (@@error != 0) goto ErrHandler
	end
	end

	----------------------------------------------------------------------------------------------------------
	--deceased information
	declare @DeceasedReturned varchar(2)
	select @DeceasedReturned = x.[f113-Seg03-SsnDeceasedResultCode] from openxml (@idoc, '//account',1) 
	with ([f113-Seg03-SsnDeceasedResultCode] varchar(2)) x
	if (@@error != 0) goto ErrHandler

	--check for deceased info
	if @DeceasedReturned is not null begin
	if @DeceasedReturned = 'Y' begin
		--deceased info returned
		--ensure there is not an existing deceased record
    		declare @DeceasedExists int
    		select @DeceasedExists = debtorid from Deceased where debtorid = @DebtorID
		if (@@error != 0) goto ErrHandler

    		if @DeceasedExists is not null begin
			-- deceased found - move to notes and delete
			exec spls_DeceasedToNotes @DebtorID
			if (@@error != 0) goto ErrHandler
    		end

		--insert deceased record using xml input parameter @doc
		-- Execute an INSERT statement using OPENXML rowset provider.
		insert into Deceased (AccountID,DebtorID,PostalCode,DOB,DOD,TransmittedDate)
		select @number, @DebtorID, x.[f117-Seg03-ZipLastKnownResidence], 
			case
				when (isdate(substring(x.[f114-Seg03-DateOfBirthDeceased],1,2)+'/'+substring(x.[f114-Seg03-DateOfBirthDeceased],3,2)+'/'+substring(x.[f114-Seg03-DateOfBirthDeceased],5,4)) = 0) then null
				else cast(substring(x.[f114-Seg03-DateOfBirthDeceased],1,2)+'/'+substring(x.[f114-Seg03-DateOfBirthDeceased],3,2)+'/'+substring(x.[f114-Seg03-DateOfBirthDeceased],5,4) as datetime)
			end as DateofBirth,
			case
				when (isdate(substring(x.[f115-Seg03-DateOfDeath],1,2)+'/'+case when substring(x.[f115-Seg03-DateOfDeath],3,2) = '00' then '01' else substring(x.[f115-Seg03-DateOfDeath],3,2) end +'/'+substring(x.[f115-Seg03-DateOfDeath],5,4)) = 0) then null
				else cast(substring(x.[f115-Seg03-DateOfDeath],1,2)+'/'+case when substring(x.[f115-Seg03-DateOfDeath],3,2) = '00' then '01' else substring(x.[f115-Seg03-DateOfDeath],3,2) end +'/'+substring(x.[f115-Seg03-DateOfDeath],5,4) as datetime)
			end as DateofDeath,
			getdate()
		from openxml (@idoc, @XPathMatchRequestID, 3)
	        with ( [f114-Seg03-DateOfBirthDeceased] varchar(10),
			[f115-Seg03-DateOfDeath] varchar(10),
			[f117-Seg03-ZipLastKnownResidence] varchar(5)) x
		if (@@error != 0) goto ErrHandler
	
		--update pending letters as deleted for this debtor
		if (select count(*) from letterrequest lr 
			inner join letterrequestrecipient lrr on lrr.letterrequestid = lr.letterrequestid 
			where lrr.debtorid = @DebtorID and lr.AccountID = @number and dateprocessed = '1753-01-01 12:00:00.000') > 0 begin
				--update letterrequests 
				update letterrequest 
					set deleted = 1, errordescription = 'Deceased info returned '+convert(varchar(10), getdate(), 101)
				where accountid = @number and dateprocessed = '1753-01-01 12:00:00.000' 
				if (@@error != 0) goto ErrHandler
		end

		--insert note	
		insert into notes (number,created,user0,action,result,comment)
			values (@number,getdate(),'EcaSvc','EcaSvc','IF','Debtor('+rtrim(ltrim(@DebtorName))+') Debtor deceased info updated.')
		if (@@error != 0) goto ErrHandler

		--set suppress letters restriction on deceased accounts
		if @DebtorSeq is not null begin
			if (select count(*) from restrictions where debtorid = @DebtorID and number = @number) > 0 begin
				--update restrictions
				update restrictions set suppressletters = 1 where debtorid = @DebtorID and number = @number
				if (@@error != 0) goto ErrHandler
			end
			else begin
				--insert restrictions
				insert into restrictions(number, debtorid, suppressletters) values( @number, @DebtorID, 1)
				if (@@error != 0) goto ErrHandler
			end									
		end
	end
	else begin
		--no deceased info returned
		--insert note	
		insert into notes (number,created,user0,action,result,comment)
			values (@number,getdate(),'EcaSvc','EcaSvc','IF','Debtor('+rtrim(ltrim(@DebtorName))+') No deceased info returned.')
		if (@@error != 0) goto ErrHandler
	end
	end

	----------------------------------------------------------------------------------------------------------
	--phone information
		--declare temp variables
		declare @newPhone as varchar(10), @notePhone varchar(256), @listingTypePhone varchar(2), @oldPhone as varchar(10)
	if (select count(*) from openxml (@idoc, '//account',1) 
		with ([f320-Seg28-MetroNetPhoneAppendResultCode] varchar(2), [f121-Seg04-FileOnePhoneAppendResultCode] varchar(2))
		where ([f320-Seg28-MetroNetPhoneAppendResultCode] is not null and rtrim(ltrim([f320-Seg28-MetroNetPhoneAppendResultCode])) <> '0')
		or ([f121-Seg04-FileOnePhoneAppendResultCode] is not null and rtrim(ltrim([f121-Seg04-FileOnePhoneAppendResultCode])) <> '0')) = 0 begin
		if (@@error != 0) goto ErrHandler
		
		--no phone info returned
		--insert note	
		insert into notes (number,created,user0,action,result,comment)
			values (@number,getdate(),'EcaSvc','EcaSvc','IF','Debtor('+rtrim(ltrim(@DebtorName))+') No phone info returned.')
		if (@@error != 0) goto ErrHandler
	end

	else if (select count(*) from openxml (@idoc, '//account',1) 
		with ([f320-Seg28-MetroNetPhoneAppendResultCode] varchar(2), [f330-PhoneCoa-BestPhoneNumberAreaCode] varchar(3), [f331-PhoneCoa-BestPhoneNumber] varchar(7))
		where [f320-Seg28-MetroNetPhoneAppendResultCode] is not null 
		and rtrim(ltrim([f320-Seg28-MetroNetPhoneAppendResultCode])) = 'M'
		and [f331-PhoneCoa-BestPhoneNumber] is not null
		and isnull([f330-PhoneCoa-BestPhoneNumberAreaCode],'') + [f331-PhoneCoa-BestPhoneNumber] not in (select OldNumber from PhoneHistory where debtorid = @DebtorID)) > 0 begin
		if (@@error != 0) goto ErrHandler

		--first - metronet phone info returned
		select @newPhone = isnull(x.[f330-PhoneCoa-BestPhoneNumberAreaCode],'') + x.[f331-PhoneCoa-BestPhoneNumber] ,
		@listingTypePhone = x.[f329-PhoneCoa-EdaListingType] ,
		@notePhone = case when rtrim(ltrim(x.[f320-Seg28-MetroNetPhoneAppendResultCode])) = 'M' then 'Debtor('+rtrim(ltrim(@DebtorName))+') 1 MetroNet phone appended. ' end
		from openxml (@idoc, '//account',1) 
		with ([f320-Seg28-MetroNetPhoneAppendResultCode] varchar(2), [f329-PhoneCoa-EdaListingType] varchar(2),
			[f330-PhoneCoa-BestPhoneNumberAreaCode] varchar(3), [f331-PhoneCoa-BestPhoneNumber] varchar(7)) x
		where  [f320-Seg28-MetroNetPhoneAppendResultCode] is not null 
		and rtrim(ltrim([f320-Seg28-MetroNetPhoneAppendResultCode])) = 'M'
		and [f330-PhoneCoa-BestPhoneNumberAreaCode] + [f331-PhoneCoa-BestPhoneNumber] not in (select OldNumber from PhoneHistory where debtorid = @DebtorID)
		if (@@error != 0) goto ErrHandler

		if rtrim(ltrim(@listingTypePhone)) = 'NP' begin
			--Non published number
			--insert note	
			insert into notes (number,created,user0,action,result,comment)
				values (@number,getdate(),'EcaSvc','EcaSvc','IF', @notePhone + ' Non-Published number. No number returned. '+@newPhone +'.')
			if (@@error != 0) goto ErrHandler
			goto cuExit
		end

		if (select count(*) from debtors 
			where debtorid = @DebtorID and homephone = @newPhone) > 0 begin
			if (@@error != 0) goto ErrHandler

			--homephone matches returned phone. make no changes
			--insert note	
			insert into notes (number,created,user0,action,result,comment)
				values (@number,getdate(),'EcaSvc','EcaSvc','IF', @notePhone + ' Home phone already set to '+@newPhone +'.')
			if (@@error != 0) goto ErrHandler
			goto cuExit
		end

		--assign old number to local variable
		select @oldPhone = isnull(homephone,'')from debtors where debtorid = @DebtorID
		if (@@error != 0) goto ErrHandler

		--insert PhoneHistory (move current debtor home phone to PhoneHistory table)
		insert into PhoneHistory (AccountID, DebtorID, DateChanged, UserChanged, PhoneType, OldNumber, NewNumber)
		select number, debtorid, getdate(), 'EcaSvc', 1, @oldPhone, @newPhone from debtors  
		where debtorid = @DebtorID
		if (@@error != 0) goto ErrHandler

		--update debtor home phone with returned phone
		update debtors
			set homephone = @newPhone
		where debtorid = @DebtorID
		if (@@error != 0) goto ErrHandler

		--update master home phone with returned phone if this is debtor zero
		if @DebtorSeq = '0' begin
			update master
				set homephone = @newPhone
			where number = @Number
			if (@@error != 0) goto ErrHandler
		end

		--insert note	
		insert into notes (number,created,user0,action,result,comment)
			values (@number,getdate(),'EcaSvc','EcaSvc','IF', @notePhone + ' Home phone updated from '+@oldPhone+' to '+@newPhone +'.')
		if (@@error != 0) goto ErrHandler
	end

	else if (select count(*) from openxml (@idoc, '//account',1) 
		with ([f121-Seg04-FileOnePhoneAppendResultCode] varchar(2), [f122-Seg04-Phone1AreaCode] varchar(3), [f123-Seg04-Phone1Number] varchar(7))
		where [f121-Seg04-FileOnePhoneAppendResultCode] is not null 
		and rtrim(ltrim([f121-Seg04-FileOnePhoneAppendResultCode])) in ('1','2','3')
		and [f123-Seg04-Phone1Number] is not null
		and isnull([f122-Seg04-Phone1AreaCode],'') + [f123-Seg04-Phone1Number] not in (select OldNumber from PhoneHistory where debtorid = @DebtorID)) > 0 begin
		if (@@error != 0) goto ErrHandler

		--second - file one phone info returned
		select @newPhone = isnull(x.[f122-Seg04-Phone1AreaCode],'') + x.[f123-Seg04-Phone1Number] ,
		@notePhone = case 
				when rtrim(ltrim(x.[f121-Seg04-FileOnePhoneAppendResultCode])) = '1' then 'Debtor('+rtrim(ltrim(@DebtorName))+') 1 File One phone appended. ' 
				when rtrim(ltrim(x.[f121-Seg04-FileOnePhoneAppendResultCode])) = '2' then 'Debtor('+rtrim(ltrim(@DebtorName))+') 2 File One phones appended. ' 
				when rtrim(ltrim(x.[f121-Seg04-FileOnePhoneAppendResultCode])) = '3' then 'Debtor('+rtrim(ltrim(@DebtorName))+') 3 File One phones appended. ' 
				end
		from openxml (@idoc, '//account',1) 
		with ([f121-Seg04-FileOnePhoneAppendResultCode] varchar(2), [f122-Seg04-Phone1AreaCode] varchar(3), [f123-Seg04-Phone1Number] varchar(7)) x
		where  [f121-Seg04-FileOnePhoneAppendResultCode] is not null 
		and rtrim(ltrim([f121-Seg04-FileOnePhoneAppendResultCode])) in ('1','2','3')
		and [f122-Seg04-Phone1AreaCode] + [f123-Seg04-Phone1Number] not in (select OldNumber from PhoneHistory where debtorid = @DebtorID)
		if (@@error != 0) goto ErrHandler

		if (select count(*) from debtors 
			where debtorid = @DebtorID and homephone = @newPhone) > 0 begin
			if (@@error != 0) goto ErrHandler

			--homephone matches returned phone. make no changes
			--insert note	
			insert into notes (number,created,user0,action,result,comment)
				values (@number,getdate(),'EcaSvc','EcaSvc','IF', @notePhone + ' Home phone already set to '+@newPhone +'.')
			if (@@error != 0) goto ErrHandler
			goto cuExit
		end

		--assign old number to local variable
		select @oldPhone = isnull(homephone,'')from debtors where debtorid = @DebtorID
		if (@@error != 0) goto ErrHandler

		--insert PhoneHistory (move current debtor home phone to PhoneHistory table)
		insert into PhoneHistory (AccountID, DebtorID, DateChanged, UserChanged, PhoneType, OldNumber, NewNumber)
		select number, debtorid, getdate(), 'EcaSvc', 1, @oldPhone, @newPhone from debtors  
		where debtorid = @DebtorID
		if (@@error != 0) goto ErrHandler

		--update debtor home phone with returned phone
		update debtors
			set homephone = @newPhone
		where debtorid = @DebtorID
		if (@@error != 0) goto ErrHandler

		--update master home phone with returned phone if this is debtor zero
		if @DebtorSeq = '0' begin
			update master
				set homephone = @newPhone
			where number = @Number
			if (@@error != 0) goto ErrHandler
		end

		--insert note	
		insert into notes (number,created,user0,action,result,comment)
			values (@number,getdate(),'EcaSvc','EcaSvc','IF', @notePhone + ' Home phone updated from '+@oldPhone+' to '+@newPhone +'.')
		if (@@error != 0) goto ErrHandler
	end

	else if (select count(*) from openxml (@idoc, '//account',1) 
		with ([f320-Seg28-MetroNetPhoneAppendResultCode] varchar(2), [f330-PhoneCoa-BestPhoneNumberAreaCode] varchar(3), [f331-PhoneCoa-BestPhoneNumber] varchar(7))
		where [f320-Seg28-MetroNetPhoneAppendResultCode] is not null 
		and rtrim(ltrim([f320-Seg28-MetroNetPhoneAppendResultCode])) in ('1','2','3')
		and [f331-PhoneCoa-BestPhoneNumber] is not null
		and isnull([f330-PhoneCoa-BestPhoneNumberAreaCode],'') + [f331-PhoneCoa-BestPhoneNumber] not in (select OldNumber from PhoneHistory where debtorid = @DebtorID)) > 0 begin
		if (@@error != 0) goto ErrHandler

		--third - eda phone info returned
		select @newPhone = isnull(x.[f330-PhoneCoa-BestPhoneNumberAreaCode],'') + x.[f331-PhoneCoa-BestPhoneNumber] ,
		@listingTypePhone = x.[f329-PhoneCoa-EdaListingType] ,
		@notePhone = case 
				when rtrim(ltrim(x.[f320-Seg28-MetroNetPhoneAppendResultCode])) = '1' then 'Debtor('+rtrim(ltrim(@DebtorName))+') 1 EDA phone appended. ' 
				when rtrim(ltrim(x.[f320-Seg28-MetroNetPhoneAppendResultCode])) = '2' then 'Debtor('+rtrim(ltrim(@DebtorName))+') 2 EDA phones appended. ' 
				when rtrim(ltrim(x.[f320-Seg28-MetroNetPhoneAppendResultCode])) = '3' then 'Debtor('+rtrim(ltrim(@DebtorName))+') 3 EDA phones appended. ' 
				end
		from openxml (@idoc, '//account',1) 
		with ([f320-Seg28-MetroNetPhoneAppendResultCode] varchar(2), [f329-PhoneCoa-EdaListingType] varchar(2),
			[f330-PhoneCoa-BestPhoneNumberAreaCode] varchar(3), [f331-PhoneCoa-BestPhoneNumber] varchar(7)) x
		where  [f320-Seg28-MetroNetPhoneAppendResultCode] is not null 
		and rtrim(ltrim([f320-Seg28-MetroNetPhoneAppendResultCode])) in ('1','2','3')
		and [f330-PhoneCoa-BestPhoneNumberAreaCode] + [f331-PhoneCoa-BestPhoneNumber] not in (select OldNumber from PhoneHistory where debtorid = @DebtorID)
		if (@@error != 0) goto ErrHandler

		if rtrim(ltrim(@listingTypePhone)) = 'NP' begin
			--Non published number
			--insert note	
			insert into notes (number,created,user0,action,result,comment)
				values (@number,getdate(),'EcaSvc','EcaSvc','IF', @notePhone + ' Non-Published number. No number returned. '+@newPhone +'.')
			if (@@error != 0) goto ErrHandler
			goto cuExit
		end

		if (select count(*) from debtors 
			where debtorid = @DebtorID and homephone = @newPhone) > 0 begin
			if (@@error != 0) goto ErrHandler

			--homephone matches returned phone. make no changes
			--insert note	
			insert into notes (number,created,user0,action,result,comment)
				values (@number,getdate(),'EcaSvc','EcaSvc','IF', @notePhone + ' Home phone already set to '+@newPhone +'.')
			if (@@error != 0) goto ErrHandler
			goto cuExit
		end

		--assign old number to local variable
		select @oldPhone = isnull(homephone,'')from debtors where debtorid = @DebtorID
		if (@@error != 0) goto ErrHandler

		--insert PhoneHistory (move current debtor home phone to PhoneHistory table)
		insert into PhoneHistory (AccountID, DebtorID, DateChanged, UserChanged, PhoneType, OldNumber, NewNumber)
		select number, debtorid, getdate(), 'EcaSvc', 1, @oldPhone, @newPhone from debtors  
		where debtorid = @DebtorID
		if (@@error != 0) goto ErrHandler

		--update debtor home phone with returned phone
		update debtors
			set homephone = @newPhone
		where debtorid = @DebtorID
		if (@@error != 0) goto ErrHandler

		--update master home phone with returned phone if this is debtor zero
		if @DebtorSeq = '0' begin
			update master
				set homephone = @newPhone
			where number = @Number
			if (@@error != 0) goto ErrHandler
		end

		--insert note	
		insert into notes (number,created,user0,action,result,comment)
			values (@number,getdate(),'EcaSvc','EcaSvc','IF', @notePhone + ' Home phone updated from '+@oldPhone+' to '+@newPhone +'.')
		if (@@error != 0) goto ErrHandler
	end
	----------------------------------------------------------------------------------------------------------
*/
	-- Remove the document from memory  
	exec sp_xml_removedocument @idoc
	if (@@error != 0) goto ErrHandler

cuExit:
	if (@@error != 0) goto ErrHandler
	Return	
ErrHandler:
	RAISERROR('Error encountered in spls_DoExperianXml for debtor id %d.  spls_DoExperianXml failed.', 11, 1, @DebtorID)
	Return







GO
