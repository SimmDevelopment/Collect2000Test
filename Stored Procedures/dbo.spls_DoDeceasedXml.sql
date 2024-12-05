SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/****** Object:  Stored Procedure dbo.spls_DoDeceasedXml    Script Date: 12/21/2005 4:22:07 PM ******/

/*dbo.spls_DoDeceasedXml*/
CREATE  proc [dbo].[spls_DoDeceasedXml]
	@RequestID int, @BatchID uniqueidentifier, 
	@XPathMatchRequestID varchar(256), @XPathNoMatchRequestID varchar(256),
	@DeceasedDesk varchar(10), @NoDeceasedDesk varchar(10),
	@DeceasedStatus varchar(5), @DeceasedQlevel varchar(3)
AS
-- Name:		spls_DoDeceasedXml
-- Function:		This procedure will process returned deceased info from outside service
-- Creation:		10/22/2004 jc
--			Used by Latitude Scheduler.
-- Change History:	4/5/2005 jc corrected error in deceased insert due to case sensitive openxml
	declare @idoc int, @doc varchar(8000), @xmlRequestID int, 
	@DebtorID int, @Number int, @DebtorSeq int, @DebtorName varchar(30), 
	@customer varchar(7), @IsPurchased bit,
	@DeceasedReturned int

	--assign xmlinforeturned to local variable
	select @doc = xmlinforeturned from servicehistory where requestid = @RequestID
	if @doc is null begin
		RAISERROR('Invalid xml info returned for requestid %d.  spls_DoDeceasedXml failed.', 11, 1, @RequestID)
		goto ErrHandler
	end

	-- Create an internal representation of the XML document.
	exec sp_xml_preparedocument @idoc output, @doc
	if (@@error != 0) goto ErrHandler

	--look for bankruptcy data retrieve servicehistory requestid from xml
	select @xmlRequestID = RequestID
	from openxml (@idoc, @XPathMatchRequestID, 3)
	with (RequestID int)
	if (@@error != 0) goto ErrHandler

	if @xmlRequestID is null begin
		--look for no bankruptcy data retrieve servicehistory requestid from xml
		select @xmlRequestID = RequestID
		from openxml (@idoc, @XPathNoMatchRequestID, 3)
		with (RequestID int)
		if (@@error != 0) goto ErrHandler

		if @xmlRequestID is null begin
			RAISERROR('No Deceased: Invalid RequestId contained in xml data for requestid %d xmlrequestid %d.  spls_DoDeceasedXml failed.', 11, 1, @RequestID, @xmlRequestID)
			goto ErrHandler
		end
		else begin
			if @RequestID = @xmlRequestID begin
				--no bankruptcy found
				set @DeceasedReturned = 0
			end
			else begin
				RAISERROR('No Deceased: RequestId contained in xml data does not match passed in requestid %d xmlrequestid %d.  spls_DoDeceasedXml failed.', 11, 1, @RequestID, @xmlRequestID)
				goto ErrHandler
			end
		end
	end
	else begin
		if @RequestID = @xmlRequestID begin
			--bankruptcy found
			set @DeceasedReturned = 1
		end
		else begin
			RAISERROR('Deceased: RequestId contained in xml data does not match passed in requestid %d xmlrequestid %d.  spls_DoDeceasedXml failed.', 11, 1, @RequestID, @xmlRequestID)
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
	select @IsPurchased = IsPrincipleCust from Customer with (nolock) where customer = @customer
	if (@@error != 0) goto ErrHandler
	if @Number is null begin
		RAISERROR('Could not find a file number for debtor id %d.  spls_DoDeceasedXml failed.', 11, 1, @DebtorID)
    		goto ErrHandler
  	end

	--update service history response
	update ServiceHistory_RESPONSES 
		set DateProcessed = getdate()
	where RequestID = @RequestID
	if (@@error != 0) goto ErrHandler

	--update service history 
	update ServiceHistory 
		set Processed = case @DeceasedReturned when 0 then 2 else 3 end
	where RequestId = @RequestID and BatchID = @BatchID
	if (@@error != 0) goto ErrHandler

	if @DeceasedReturned=0 begin
		--no deceased info returned
		--insert note	
		insert into notes (number,created,user0,action,result,comment)
			values (@number,getdate(),'DecdSvc','DECD','IF','Debtor('+rtrim(ltrim(@DebtorName))+') No deceased information found.')
		if (@@error != 0) goto ErrHandler

		--update master account desk only if not yet set
		if (select count(*) from master m 
			where m.number = @number and m.desk <> @DeceasedDesk
			and m.desk <> @NoDeceasedDesk) > 0 begin

			--update master account (desk)
			update master set desk = @NoDeceasedDesk where number = @number
			if (@@error != 0) goto ErrHandler			
			goto cuExit
		end
	end
	else begin
		--deceased info returned
		--ensure there is not an existing deceased record
    		declare @DeceasedFound int
    		select @DeceasedFound = debtorid from Deceased where debtorid = @DebtorID
		if (@@error != 0) goto ErrHandler

    		if @DeceasedFound is not null begin
			-- deceased found - move to notes and delete
			exec spls_DeceasedToNotes @DebtorID
			if (@@error != 0) goto ErrHandler
    		end

		--insert deceased record using xml input parameter @doc
		-- Execute an INSERT statement using OPENXML rowset provider.
		insert into Deceased (AccountID,DebtorID,SSN,FirstName,
			LastName,State,PostalCode,DOB,DOD,MatchCode,
			TransmittedDate)
		select @number, @DebtorID, SSN, ClientFirstName, ClientLastName,
			DeceasedState, DeceasedZip, 
			case
				when (isdate(substring(DateofBirth,1,2)+'/'+substring(DateofBirth,3,2)+'/'+substring(DateofBirth,5,4)) = 0) then null
				else cast(substring(DateofBirth,1,2)+'/'+substring(DateofBirth,3,2)+'/'+substring(DateofBirth,5,4) as datetime)
			end as DateofBirth,
			case
				when (isdate(substring(DateofDeath,1,2)+'/'+case when substring(DateofDeath,3,2) = '00' then '01' else substring(DateofDeath,3,2) end +'/'+substring(DateofDeath,5,4)) = 0) then null
				else cast(substring(DateofDeath,1,2)+'/'+case when substring(DateofDeath,3,2) = '00' then '01' else substring(DateofDeath,3,2) end +'/'+substring(DateofDeath,5,4) as datetime)
			end as DateofDeath,
			MatchCode, getdate()
		from openxml (@idoc, @XPathMatchRequestID, 3)
	        with (ClientFirstName varchar(30),
			ClientLastName varchar(30),
			SSN varchar(15),
			FirstName varchar(30),
			LastName varchar(30),
			Address varchar(60),
			City varchar(30),
			DeceasedState varchar(30),
			DeceasedZip varchar(20),
			DateOfBirth varchar(10),
			DateOfDeath varchar(10),
			MatchCode varchar(5))
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
			values (@number,getdate(),'DecdSvc','DECD','IF','Debtor('+rtrim(ltrim(@DebtorName))+') Deceased information found.')
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

		if @IsPurchased = 1 begin
			--update purchased account 
			update master 
				set qlevel = @DeceasedQlevel,
				desk = @DeceasedDesk
			where number = @number
			if (@@error != 0) goto ErrHandler
			goto cuExit
		end
		else begin
			--close contingency account 
			update master 
				set status = @DeceasedStatus,
				qlevel = '998',
				desk = @DeceasedDesk,
				closed=getdate()
			where number = @number
			if (@@error != 0) goto ErrHandler
			goto cuExit
		end
	end
	-- Remove the document from memory 
	exec sp_xml_removedocument @idoc
	if (@@error != 0) goto ErrHandler
cuExit:
	if (@@error != 0) goto ErrHandler
	Return	
ErrHandler:
	RAISERROR('Error encountered in spls_DoDeceasedXml for debtor id %d.  spls_DoDeceasedXml failed.', 11, 1, @DebtorID)
	Return



GO
