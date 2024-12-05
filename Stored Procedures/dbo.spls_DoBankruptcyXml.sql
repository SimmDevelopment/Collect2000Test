SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.spls_DoBankruptcyXml    Script Date: 12/21/2005 4:22:07 PM ******/

/*dbo.spls_DoBankruptcyXml*/
CREATE  proc [dbo].[spls_DoBankruptcyXml]
	@RequestID int, @BatchID uniqueidentifier, 
	@XPathMatchRequestID varchar(256), @XPathNoMatchRequestID varchar(256),
	@BankruptcyDesk varchar(10), @NoBankruptcyDesk varchar(10),
	@BankoStatus varchar(5), @BankoQlevel varchar(3)
AS
-- Name:		spls_DoBankruptcyXml
-- Function:		This procedure will process returned bankruptcy xml data from outside service
-- Creation:		10/18/2004 jc
--			Used by Latitude Scheduler.
--			SERVICE: LexisNexis Banko.Bankruptcy
-- Change History:	
--			02/26/2005 jc changed local variable @qlevel from int to varchar(3)
--			12/06/2005 jc changed bankruptcy table insert to include court info.
	declare @idoc int, @doc varchar(8000), @xmlRequestID int, 
	@DebtorID int, @Number int, @DebtorSeq int, @DebtorName varchar(30), 
	@customer varchar(7), @status varchar(5), @qlevel varchar(3), 
	@ContractDate datetime, @CliDlp datetime, @ChargeOffDate datetime, @IsPurchased bit,
	@BankruptcyReturned int

	--assign xmlinforeturned to local variable
	select @doc = xmlinforeturned from servicehistory where requestid = @RequestID
	if @doc is null begin
		RAISERROR('Invalid xml info returned for requestid %d.  spls_DoBankruptcyXml failed.', 11, 1, @RequestID)
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
			RAISERROR('No Bankruptcy: Invalid RequestId contained in xml data for requestid %d xmlrequestid %d.  spls_DoBankruptcyXml failed.', 11, 1, @RequestID, @xmlRequestID)
			goto ErrHandler
		end
		else begin
			if @RequestID = @xmlRequestID begin
				--no bankruptcy found
				set @BankruptcyReturned = 0
			end
			else begin
				RAISERROR('No Bankruptcy: RequestId contained in xml data does not match passed in requestid %d xmlrequestid %d.  spls_DoBankruptcyXml failed.', 11, 1, @RequestID, @xmlRequestID)
				goto ErrHandler
			end
		end
	end
	else begin
		if @RequestID = @xmlRequestID begin
			--bankruptcy found
			set @BankruptcyReturned = 1
		end
		else begin
			RAISERROR('Bankruptcy: RequestId contained in xml data does not match passed in requestid %d xmlrequestid %d.  spls_DoBankruptcyXml failed.', 11, 1, @RequestID, @xmlRequestID)
			goto ErrHandler
		end
	end

	--assign locals
	select @Number = d.number, @DebtorID = d.debtorid, @DebtorSeq = d.seq, @DebtorName = isnull(d.Name,'') from debtors d with(nolock) 
	inner join servicehistory sh with(nolock) on sh.debtorid = d.debtorid
	where sh.requestid = @RequestID
	if (@@error != 0) goto ErrHandler

	select @customer = customer,  @qlevel = qlevel, @status = status,
		@ContractDate = ContractDate, @CliDlp = CliDlp, @ChargeOffDate = ChargeOffDate 
		from master with(nolock) where number = @Number
	if (@@error != 0) goto ErrHandler

	select @IsPurchased = IsPrincipleCust from Customer with(nolock) where customer = @customer
	if (@@error != 0) goto ErrHandler
	if @Number is null begin
		RAISERROR('Could not find a file number for requestid %d.  spls_DoBankruptcyXml failed.', 11, 1, @RequestID)
    		goto ErrHandler
  	end
  	else begin
		--update service history response
		update ServiceHistory_RESPONSES 
			set DateProcessed = getdate()
		where RequestID = @RequestID
		if (@@error != 0) goto ErrHandler

		--update service history 
		update ServiceHistory 
			set Processed = case @BankruptcyReturned when 0 then 2 else 3 end
		where RequestId = @RequestID and BatchID = @BatchID
		if (@@error != 0) goto ErrHandler

		if @BankruptcyReturned=0 begin
			--no bankruptcy info returned
			
			--insert note	
			insert into notes (number,created,user0,action,result,comment)
				values (@number,getdate(),'BankoSvc','BNKO','IF','Debtor('+rtrim(ltrim(@DebtorName))+') No bankruptcy information found.')
			if (@@error != 0) goto ErrHandler


			--update master account desk only if not yet set
			if (select count(*) from master m 
				where m.number = @number and m.desk <> @BankruptcyDesk
				and m.desk <> @NoBankruptcyDesk) > 0 begin

				--update master account (desk)
				update master set desk = @NoBankruptcyDesk where number = @number
				if (@@error != 0) goto ErrHandler			
				goto cuExit
			end
		end
		else begin
			--bankruptcy info returned

			--assign local variables from xml data
			declare @chapter char(2), @disposition char(2),
			@fileddate datetime, @statusdate datetime,
			@attorneyExists bit

			select @chapter = Chapter, @disposition = DispositionCode, 
				@fileddate = isnull(cast(FileDate as datetime),null),
				@statusdate = isnull(cast(StatusDate as datetime),null),
				@attorneyExists = case when len(AttorneyName) > 0 then 1 else 0 end
 			from openxml (@idoc, @XPathMatchRequestID, 3)
		        with (Chapter char(2), DispositionCode char(2),
				FileDate datetime, StatusDate varchar(20),
				AttorneyName varchar(35))
			if (@@error != 0) goto ErrHandler

			--search for an existing bankruptcy record
	    		declare @BankruptcyFound int
	    		select @BankruptcyFound = debtorid from Bankruptcy where debtorid = @DebtorID
			if (@@error != 0) goto ErrHandler

			--search for an existing debtor attorney record
			declare @DebtorAttorneyFound int
	    		select @DebtorAttorneyFound = debtorid from debtorattorneys where debtorid = @DebtorID and accountid = @number
			if (@@error != 0) goto ErrHandler

			--proceed based on disposition code
			if @disposition = '02' begin -- bankruptcy filed
		    		if @BankruptcyFound is not null begin
					--bankruptcy found - move to notes and delete
					exec spls_BankruptcyToNotes @DebtorID
					if (@@error != 0) goto ErrHandler
		    		end

				if @statusdate is not null begin
					if @ContractDate is not null begin
						if @statusdate < @ContractDate begin
							--insert note with bankruptcy info
							insert into notes (number,created,user0,action,result,comment)
								values (@number,getdate(),'BankoSvc','BNKO','IF','Debtor('+rtrim(ltrim(@DebtorName))+') Bankruptcy Filed: status date '+convert(varchar(10), @statusdate, 101)+' before Contract date '+convert(varchar(10), @ContractDate, 101)+'. ')
							if (@@error != 0) goto ErrHandler
	
							--update master account (desk)
							update master set desk = @NoBankruptcyDesk where number = @number
							if (@@error != 0) goto ErrHandler
							goto cuExit
						end
					end
					else if @CliDlp is not null begin
						if @statusdate < @CliDlp begin
							--insert note with bankruptcy info
							insert into notes (number,created,user0,action,result,comment)
								values (@number,getdate(),'BankoSvc','BNKO','IF','Debtor('+rtrim(ltrim(@DebtorName))+') Bankruptcy Filed: status date '+convert(varchar(10), @statusdate, 101)+' before CliDlp date '+convert(varchar(10), @CliDlp, 101)+'. ')
							if (@@error != 0) goto ErrHandler
	
							--update master account (desk)
							update master set desk = @NoBankruptcyDesk where number = @number
							if (@@error != 0) goto ErrHandler			
							goto cuExit
						end
					end
					else if @ChargeOffDate is not null begin
						if @statusdate < @ChargeOffDate begin
							--insert note with bankruptcy info
							insert into notes (number,created,user0,action,result,comment)
								values (@number,getdate(),'BankoSvc','BNKO','IF','Debtor('+rtrim(ltrim(@DebtorName))+') Bankruptcy Filed: status date '+convert(varchar(10), @statusdate, 101)+' before ChargedOffDate date '+convert(varchar(10), @ChargeOffDate, 101)+'. ')
							if (@@error != 0) goto ErrHandler
	
							--update master account (desk)
							update master set desk = @NoBankruptcyDesk where number = @number
							if (@@error != 0) goto ErrHandler			
							goto cuExit
						end
					end
				end
				else begin
					RAISERROR('Returned bankruptcy status date is invalid for debtor id %d.  spls_DoBankruptcyXml failed.', 11, 1, @DebtorID)
			    		goto ErrHandler
				end

				--insert bankruptcy record using xml input parameter @doc
				-- Execute an INSERT statement using OPENXML rowset provider.
				insert into Bankruptcy (AccountID,DebtorID,Chapter,DateFiled,
					CaseNumber,CourtCity,CourtDistrict,CourtDivision,CourtPhone,CourtStreet1,
					CourtStreet2,CourtState,CourtZipcode,Trustee,TrusteeStreet1,TrusteeStreet2,
					TrusteeCity,TrusteeState,TrusteeZipcode,TrusteePhone,Has341Info,DateTime341,
					Location341,Comments,Status)
				select @Number, @DebtorID, case Chapter 
								when '06' then '13'
								when '52' then '7'
								when '53' then '11'
								when '54' then '12'
							end,
					isnull(cast(FileDate as datetime),null)FileDate, 
					CaseNumber, isnull(CityFiled,''), isnull(CourtDistrict,''), '', isnull(CourtPhone,''), 
					isnull(CourtAddress1,''), isnull(CourtAddress2,''), isnull(StateFiled,''), isnull(CourtZip,''), 
					Trustee, TrusteeAddress, '', TrusteeCity, TrusteeState, TrusteeZip, TrusteePhone, 
					case Location341 when '' then 0 else 1 end,
					case 
						when isdate(Date341) = 1 then 
							case 
								when isdate(Date341+' '+Time341) = 1 then CONVERT(datetime, Date341 +' '+ Time341)
								else CONVERT(datetime, Date341)
							end
						else null
					end DateTime341, Location341, '', ''
				from openxml (@idoc, @XPathMatchRequestID, 3)
			        with (Screen varchar(20), CaseNumber varchar(20), Chapter tinyint,
					FileDate datetime, StatusDate varchar(20), DispositionCode varchar(20),
					Address varchar(20), ZipCode varchar(20), SSN varchar(20), CityFiled varchar(50),
					StateFiled varchar(3), County varchar(20), FirstName varchar(20), MiddleName varchar(20),
					LastName varchar(20), Business varchar(20), Business2 varchar(20), Business3 varchar(20),
					DebtorsCity varchar(20), DebtorsState varchar(20), ECOA varchar(20), LawFirm varchar(20),
					AttorneyName varchar(20), AttorneyAddress varchar(20), AttorneyCity varchar(20),
					AttorneyState varchar(20), AttorneyZip varchar(20), AttorneyPhone varchar(20),
					Date341 varchar(30), Time341 varchar(30), Location341 varchar(200), Trustee varchar(50),
					TrusteeAddress varchar(50), TrusteeCity varchar(100), TrusteeState varchar(3),
					TrusteeZip varchar(10), TrusteePhone varchar(30), JudgesInitials varchar(20),
					Funds varchar(20), BarDate varchar(20), MatchCode varchar(20), ClientCode varchar(20),
					CourtDistrict varchar(200), CourtAddress1 varchar(50), CourtAddress2 varchar(50), 
					CourtMailingCity varchar(20), CourtZip varchar(20), CourtPhone varchar(50), 
					DebtorPhone varchar(20), VolInvDismissal varchar(20), ProofOfClaimDate varchar(20))
				if (@@error != 0) goto ErrHandler
				
				-- insert debtor attorney record if present in xml data
				if @attorneyExists = 1 begin
			    		if @DebtorAttorneyFound is not null begin
						--debtor attorney found - move to notes and delete
						exec spls_DebtorAttorneyToNotes @DebtorID
						if (@@error != 0) goto ErrHandler
					end
					--insert debtor attorney record using xml input parameter @doc
					-- Execute an INSERT statement using OPENXML rowset provider.
					insert into DebtorAttorneys (AccountID,DebtorID,Name,Firm,
						Addr1,Addr2,City,State,Zipcode,Phone,
						Fax,Email,Comments,DateCreated,DateUpdated)
					select @number, @DebtorID, AttorneyName, isnull(LawFirm,''), isnull(AttorneyAddress,''), '', 
						isnull(AttorneyCity,''), isnull(AttorneyState,''), isnull(AttorneyZip,''),
						isnull(AttorneyPhone,''), '', '', '', getdate(), getdate()
					from openxml (@idoc, @XPathMatchRequestID, 3)
				        with (LawFirm varchar(50), AttorneyName varchar(35), 
						AttorneyAddress varchar(32), AttorneyCity varchar(25), AttorneyState varchar(2), 
						AttorneyZip varchar(10), AttorneyPhone varchar(10))
					if (@@error != 0) goto ErrHandler
				end

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
					values (@number,getdate(),'BankoSvc','BNKO','IF','Debtor('+rtrim(ltrim(@DebtorName))+') Bankruptcy Filed.')
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

				if @IsPurchased = 1 begin
					--purchased account
					if @qlevel < '998' begin
						--update qlevel
						update master 
							set qlevel = @BankoQlevel, 
							desk = @BankruptcyDesk
						where number = @number
						if (@@error != 0) goto ErrHandler
					end
					else begin
						--update master account (desk)
						update master set desk = @BankruptcyDesk where number = @number
						if (@@error != 0) goto ErrHandler			
					end
				end
				else begin
					--contingency account
					-- close account
					update master 
						set status = @BankoStatus, 
						qlevel = '998', 
						desk = @BankruptcyDesk, 
						closed = getdate() 
					where number=@number
					if (@@error != 0) goto ErrHandler
				end						
				goto cuExit
			end
			else if @disposition = '15' begin -- bankruptcy dismissed
		    		if @BankruptcyFound is not null begin
					-- bankruptcy found - move to notes and delete
					exec spls_BankruptcyToNotes @DebtorID
					if (@@error != 0) goto ErrHandler
		    		end

				--insert note with bankruptcy info
				insert into notes (number,created,user0,action,result,comment)
					values (@number,getdate(),'BankoSvc','BNKO','IF','Debtor('+rtrim(ltrim(@DebtorName))+') Bankruptcy Dismissed. ')
				if (@@error != 0) goto ErrHandler

				--update master account desk only if not yet set
				if (select count(*) from master m 
					where m.number = @number and m.desk <> @BankruptcyDesk
					and m.desk <> @NoBankruptcyDesk) > 0 begin
	
					--update master account (desk)
					update master set desk = @NoBankruptcyDesk where number = @number
					if (@@error != 0) goto ErrHandler			
					goto cuExit
				end
			end
			else if @disposition = '20' begin -- bankruptcy discharged
		    		if @BankruptcyFound is not null begin
					--bankruptcy found - move to notes and delete
					exec spls_BankruptcyToNotes @DebtorID
					if (@@error != 0) goto ErrHandler
		    		end

				if @statusdate is not null begin
					if @ContractDate is not null begin
						if @statusdate < @ContractDate begin
							--insert note with bankruptcy info
							insert into notes (number,created,user0,action,result,comment)
								values (@number,getdate(),'BankoSvc','BNKO','IF','Debtor('+rtrim(ltrim(@DebtorName))+') Bankruptcy Discharged: status date '+convert(varchar(10), @statusdate, 101)+' before Contract date '+convert(varchar(10), @ContractDate, 101)+'. ')
							if (@@error != 0) goto ErrHandler
	
							--update master account (desk)
							update master set desk = @NoBankruptcyDesk where number = @number
							if (@@error != 0) goto ErrHandler
							goto cuExit
						end
					end
					else if @CliDlp is not null begin
						if @statusdate < @CliDlp begin
							--insert note with bankruptcy info
							insert into notes (number,created,user0,action,result,comment)
								values (@number,getdate(),'BankoSvc','BNKO','IF','Debtor('+rtrim(ltrim(@DebtorName))+') Bankruptcy Discharged: status date '+convert(varchar(10), @statusdate, 101)+' before CliDlp date '+convert(varchar(10), @CliDlp, 101)+'. ')
							if (@@error != 0) goto ErrHandler
	
							--update master account (desk)
							update master set desk = @NoBankruptcyDesk where number = @number
							if (@@error != 0) goto ErrHandler			
							goto cuExit
						end
					end
					else if @ChargeOffDate is not null begin
						if @statusdate < @ChargeOffDate begin
							--insert note with bankruptcy info
							insert into notes (number,created,user0,action,result,comment)
								values (@number,getdate(),'BankoSvc','BNKO','IF','Debtor('+rtrim(ltrim(@DebtorName))+') Bankruptcy Discharged: status date '+convert(varchar(10), @statusdate, 101)+' before ChargedOffDate date '+convert(varchar(10), @ChargeOffDate, 101)+'. ')
							if (@@error != 0) goto ErrHandler
	
							--update master account (desk)
							update master set desk = @NoBankruptcyDesk where number = @number
							if (@@error != 0) goto ErrHandler			
							goto cuExit
						end
					end
				end
				else begin
					RAISERROR('Returned bankruptcy status date is invalid for debtor id %d.  spls_DoBankruptcyXml failed.', 11, 1, @DebtorID)
			    		goto ErrHandler
				end

				--insert bankruptcy record using xml input parameter @doc
				-- Execute an INSERT statement using OPENXML rowset provider.
				insert into Bankruptcy (AccountID,DebtorID,Chapter,DateFiled,
					CaseNumber,CourtCity,CourtDistrict,CourtDivision,CourtPhone,CourtStreet1,
					CourtStreet2,CourtState,CourtZipcode,Trustee,TrusteeStreet1,TrusteeStreet2,
					TrusteeCity,TrusteeState,TrusteeZipcode,TrusteePhone,Has341Info,DateTime341,
					Location341,Comments,Status)
				select @Number, @DebtorID, case Chapter 
								when '06' then '13'
								when '52' then '7'
								when '53' then '11'
								when '54' then '12'
							end,
					isnull(cast(FileDate as datetime),null)FileDate, 
					CaseNumber, isnull(CityFiled,''), isnull(CourtDistrict,''), '', isnull(CourtPhone,''), 
					isnull(CourtAddress1,''), isnull(CourtAddress2,''), isnull(StateFiled,''), isnull(CourtZip,''), 
					Trustee, TrusteeAddress, '', TrusteeCity, TrusteeState, TrusteeZip, TrusteePhone, 
					case Location341 when '' then 0 else 1 end,
					case 
						when isdate(Date341) = 1 then 
							case 
								when isdate(Date341+' '+Time341) = 1 then CONVERT(datetime, Date341 +' '+ Time341)
								else CONVERT(datetime, Date341)
							end
						else null
					end DateTime341, Location341, '', ''
				from openxml (@idoc, @XPathMatchRequestID, 3)
			        with (Screen varchar(20), CaseNumber varchar(20), Chapter tinyint,
					FileDate datetime, StatusDate varchar(20), DispositionCode varchar(20),
					Address varchar(20), ZipCode varchar(20), SSN varchar(20), CityFiled varchar(50),
					StateFiled varchar(3), County varchar(20), FirstName varchar(20), MiddleName varchar(20),
					LastName varchar(20), Business varchar(20), Business2 varchar(20), Business3 varchar(20),
					DebtorsCity varchar(20), DebtorsState varchar(20), ECOA varchar(20), LawFirm varchar(20),
					AttorneyName varchar(20), AttorneyAddress varchar(20), AttorneyCity varchar(20),
					AttorneyState varchar(20), AttorneyZip varchar(20), AttorneyPhone varchar(20),
					Date341 varchar(30), Time341 varchar(30), Location341 varchar(200), Trustee varchar(50),
					TrusteeAddress varchar(50), TrusteeCity varchar(100), TrusteeState varchar(3),
					TrusteeZip varchar(10), TrusteePhone varchar(30), JudgesInitials varchar(20),
					Funds varchar(20), BarDate varchar(20), MatchCode varchar(20), ClientCode varchar(20),
					CourtDistrict varchar(200), CourtAddress1 varchar(50), CourtAddress2 varchar(50), 
					CourtMailingCity varchar(20), CourtZip varchar(20), CourtPhone varchar(50), 
					DebtorPhone varchar(20), VolInvDismissal varchar(20), ProofOfClaimDate varchar(20))
				if (@@error != 0) goto ErrHandler

				-- insert debtor attorney record if present in xml data
				if @attorneyExists = 1 begin
			    		if @DebtorAttorneyFound is not null begin
						--debtor attorney found - move to notes and delete
						exec spls_DebtorAttorneyToNotes @DebtorID
						if (@@error != 0) goto ErrHandler
					end
					--insert debtor attorney record using xml input parameter @doc
					-- Execute an INSERT statement using OPENXML rowset provider.
					insert into DebtorAttorneys (AccountID,DebtorID,Name,Firm,
						Addr1,Addr2,City,State,Zipcode,Phone,
						Fax,Email,Comments,DateCreated,DateUpdated)
					select @number, @DebtorID, AttorneyName, isnull(LawFirm,''), isnull(AttorneyAddress,''), '', 
						isnull(AttorneyCity,''), isnull(AttorneyState,''), isnull(AttorneyZip,''),
						isnull(AttorneyPhone,''), '', '', '', getdate(), getdate()
					from openxml (@idoc, @XPathMatchRequestID, 3)
				        with (LawFirm varchar(50), AttorneyName varchar(35), 
						AttorneyAddress varchar(32), AttorneyCity varchar(25), AttorneyState varchar(2), 
						AttorneyZip varchar(10), AttorneyPhone varchar(10))
					if (@@error != 0) goto ErrHandler
				end

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
					values (@number,getdate(),'BankoSvc','BNKO','IF','Debtor('+rtrim(ltrim(@DebtorName))+') Bankruptcy Discharged: status date '+convert(varchar(10), @statusdate, 101)+'. ')

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

				if @IsPurchased = 1 begin
					-- verify purchased account's banko status
					if (select count(*) from status where code = @status and IsBankruptcy = 1) > 0 begin
						-- re-open account
						update master 
							set status = 'ACT', 
							qlevel = @BankoQlevel, 
							desk = @BankruptcyDesk,
							closed = null, 
							returned = null 
						where number=@number
						if (@@error != 0) goto ErrHandler
					end
					else begin
						--stop here - proceed no further
						--update master account (desk)
						update master 
							set desk = @BankruptcyDesk 
						where number = @number
						if (@@error != 0) goto ErrHandler			
					end
				end
				else begin
					-- close contingency account
					update master 
						set status = @BankoStatus, 
						qlevel = '998', 
						desk = @BankruptcyDesk, 
						closed = getdate() 
					where number=@number
					if (@@error != 0) goto ErrHandler
				end						

				goto cuExit
			end
			else if @disposition = '30' begin -- bankruptcy conversion
				--insert note with bankruptcy info
				insert into notes (number,created,user0,action,result,comment)
					values (@number,getdate(),'BankoSvc','BNKO','IF','Debtor('+rtrim(ltrim(@DebtorName))+') Bankruptcy Conversion. ')
				if (@@error != 0) goto ErrHandler

				--update master account (desk)
				update master set desk = @NoBankruptcyDesk where number = @number
				if (@@error != 0) goto ErrHandler			
				goto cuExit
			end
			else if @disposition = '99' begin -- bankruptcy closed
				--insert note with bankruptcy info
				insert into notes (number,created,user0,action,result,comment)
					values (@number,getdate(),'BankoSvc','BNKO','IF','Debtor('+rtrim(ltrim(@DebtorName))+') Bankruptcy Closed. ')
				if (@@error != 0) goto ErrHandler

				--update master account (desk)
				update master set desk = @NoBankruptcyDesk where number = @number
				if (@@error != 0) goto ErrHandler			
				goto cuExit
			end
			else begin
	      			RAISERROR('Unrecognized disposition code for Debtor #%d.', 11, 1, @DebtorID)
				goto ErrHandler
			end
		end
	-- Remove the document from memory 
	exec sp_xml_removedocument @idoc
	if (@@error != 0) goto ErrHandler
  	end
cuExit:
	if (@@error != 0) goto ErrHandler
	Return	

ErrHandler:
	RAISERROR('Error encountered in spls_DoBankruptcyXml for debtor id %d.  spls_DoBankruptcyXml failed.', 11, 1, @DebtorID)
	Return


GO
