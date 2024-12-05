SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Stored Procedure dbo.spls_AddResponse    Script Date: 12/21/2005 4:22:07 PM ******/

/*dbo.spls_AddResponse*/
CREATE proc [dbo].[spls_AddResponse]
	@ServiceId int, @ProfileID uniqueidentifier, @ProfileName varchar(256), @BatchID uniqueidentifier, 
	@Filename varchar(256), @XPathForRequestID varchar(256), @doc ntext
AS
-- Name:		spls_AddResponse
-- Function:		This procedure will insert servicehistory response record from outside service
-- Creation:		10/15/2004 jc
--			Used by Latitude Scheduler.
-- Change History:	
	declare @idoc int, @RequestID int, @DebtorID int, @Number int, @DebtorSeq int, @DebtorName varchar(30)
		
	-- Create an internal representation of the XML document.
	exec sp_xml_preparedocument @idoc output, @doc
	if (@@error != 0) goto ErrHandler

	--retrieve servicehistory requestid from xml using passed in XPath to retrieve requestid
	select @RequestID = RequestID from openxml (@idoc, @XPathForRequestID, 3) with (RequestID int)
	if (@@error != 0) goto ErrHandler

	--assign locals
	select @Number = d.number, @DebtorID = d.debtorid, @DebtorSeq = d.seq, @DebtorName = isnull(d.Name,'') from debtors d with(nolock) 
	inner join servicehistory sh with(nolock) on sh.debtorid = d.debtorid
	where sh.requestid = @RequestID
	if (@@error != 0) goto ErrHandler
	if @Number is null begin
		RAISERROR('Could not find a file number for requestid %d.  spls_AddResponse failed.', 11, 1, @RequestID)
    		goto ErrHandler
  	end
  	else begin
		--only proceed if an existing servicehistory record 
		if (select count(*) from ServiceHistory 
		where RequestId = @RequestID and ServiceId = @ServiceId and ProfileID = @ProfileID 
		and BatchID = @BatchID) > 0 begin

			--update service history 
			update ServiceHistory 
				set ReturnedDate = getdate(),
				Processed = 99,
				XmlInfoReturned = @doc 
			where RequestId = @RequestID and ServiceId = @ServiceId and ProfileID = @ProfileID and BatchID = @BatchID
			if (@@error != 0) goto ErrHandler
	
			--insert service history response
			insert into ServiceHistory_RESPONSES (RequestID, FileName, DateReturned, XmlInfoReturned)
			values (@RequestID, @Filename, getdate(), @doc)
			if (@@error != 0) goto ErrHandler

			--insert note
			insert into notes (number,created,user0,action,result,comment)
				values (@number,getdate(),'OutsideSvc','OSVC','IF','Debtor('+rtrim(ltrim(@DebtorName))+') ' + @ProfileName + ': Response loaded.')
			if (@@error != 0) goto ErrHandler
		end

	-- Remove the document from memory */ 
	exec sp_xml_removedocument @idoc
	if (@@error != 0) goto ErrHandler
  	end
cuExit:
	if (@@error != 0) goto ErrHandler
	Return	

ErrHandler:
	RAISERROR('Error encountered in spls_AddResponse for requestid %d.  spls_AddResponse failed.', 11, 1, @RequestID)
	Return


GO
