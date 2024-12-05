SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[Custom_Insert_ServiceHistory_RequestId]
@requestId int,	
@manifestId uniqueidentifier,
@historyXml text,
@responseBatchId uniqueidentifier,
@createNewRecord bit = 1
AS
BEGIN
	DECLARE @givenRequestID as int
	Declare @errorId int
	Declare @tranzName varchar(32)
	set @errorId = 0
	set @tranzName = 'InsertServiceHistory'
	SET @givenRequestID = @requestId
	Declare @err int
	declare @existingXmlInfoReturnedExist as bit
	
	BEGIN TRANSACTION @tranzName
	--See if it is already in ServiceHistory table
	IF exists( select requestid from ServiceHistory with (nolock) where requestid=@requestId and XmlInfoReturned is not null )
	BEGIN

		IF(@createNewRecord = 1)
		BEGIN
			--Create a new row and update that
			Insert Into ServiceHistory([AcctId],[DebtorId],[CreationDate],[ReturnedDate],[ServiceID],[RequestedBy],[RequestedProgram],[Processed],[XmlInfoRequested],[FileName],
							[Cost],[SystemYear],[SystemMonth],[ServiceBatch],[VerifiedBy],[VerifiedDate],[BatchId],[ProfileId])
			Select [AcctId],[DebtorId],[CreationDate],[ReturnedDate],[ServiceID],[RequestedBy],[RequestedProgram],[Processed],[XmlInfoRequested],[FileName],
							[Cost],[SystemYear],[SystemMonth],[ServiceBatch],[VerifiedBy],[VerifiedDate],[BatchId],[ProfileId]
			From ServiceHistory with (nolock) where requestid=@requestId and XmlInfoReturned is not null
			
			--update the requestid here
			Select @requestId=Scope_identity()

			SELECT @errorId = @@ERROR
			IF (@errorId <> 0) GOTO ERRORHANDLER
			
			Insert into ServiceHistory_RESPONSES([RequestId],[FileName],[DateReturned],[DateProcessed],[XmlInfoReturned])
			Select @requestId,[FileName],GETDATE(),GETDATE(),@historyXml
			From ServiceHistory with (nolock) where requestId=@requestId

			SELECT @errorId = @@ERROR
			IF (@errorId <> 0) GOTO ERRORHANDLER
			
			

			SELECT @errorId = @@ERROR
			IF (@errorId <> 0) GOTO ERRORHANDLER
		END
	END

	INSERT INTO notes(number,created,user0,action,result,comment)
	SELECT sh.AcctID,getdate(),'FUSION','REC','REC',
	RTRIM(LTRIM(s.description)) + ' returned.'
	FROM ServiceHistory sh (nolock)
	INNER JOIN Services s (nolock)
	ON sh.ServiceId = s.ServiceId
	WHERE sh.RequestId = @RequestId

	-- This means XMLInfoReturned was NULL so we update the record for the given requestid which was changed above.
	IF(@givenRequestID != @requestId)
	BEGIN
		Update ServiceHistory Set XMLInfoReturned=@historyXml,returnedDate=GETDATE(),Processed = 3,ResponseBatchId = @responseBatchId Where RequestId=@requestId	
	END
	ELSE -- This means we are not adding a new record OR the XMLInfoReturned was not set for the given requestid
	BEGIN
		SELECT @existingXmlInfoReturnedExist =
		CASE WHEN XMLInfoReturned IS NULL THEN 0 ELSE 1 END
		FROM ServiceHistory WITH (NOLOCK)
		WHERE RequestId=@requestId	

		IF(@existingXmlInfoReturnedExist = 0)
		BEGIN
			Update ServiceHistory Set XMLInfoReturned=@historyXml,returnedDate=GETDATE(),Processed = 3,ResponseBatchId = @responseBatchId Where RequestId=@requestId	
		END
		ELSE -- Otherwise we append the @historyXML to XMLInfoReturned.
		BEGIN
			DECLARE @dataRowXMLBeginTag int
			DECLARE @dataRowsXMLEndTag int
			DECLARE @ptrval binary(16)

			-- We are adjusting the XmlInfoReturned here. We want to remove the porition that looks like this:
			-- <?xml version="1.0"?><DataRows> so we find the first occurance of the <DataRow> xml element tag.
			SELECT @dataRowXMLBeginTag = PATINDEX('%<DataRow>%',XMLInfoReturned)-1
			FROM [dbo].[ServiceHistory] WITH (NOLOCK)
			WHERE [RequestId] = @requestID

			-- Establish a pointer into the Text Field for this request.
			SELECT @ptrval = TEXTPTR([xmlinforeturned])
			FROM [dbo].[ServiceHistory]
			WHERE [RequestId] = @requestID

			-- Replace the existing text with an empty string.
			UPDATETEXT [dbo].[ServiceHistory].[xmlinforeturned] @ptrval 1 @dataRowXMLBeginTag ''
			-- Prepend the given historyXMl to the beginning.
			UPDATETEXT [dbo].[ServiceHistory].[xmlinforeturned] @ptrval 0 0 @historyXMl

			-- We now have two </DataRows> xml element closing tags, establish an index to the first one.
			SELECT @dataRowsXMLEndTag = PATINDEX('%</DataRows>%',XMLInfoReturned)-1
			FROM [dbo].[ServiceHistory] WITH (NOLOCK)
			WHERE [RequestId] = @requestID

			-- Now remove the duplicate </DataRows> xml element closing tag.
			UPDATETEXT [dbo].[ServiceHistory].[xmlinforeturned] @ptrval @dataRowsXMLEndTag 11 ''
		END
	END

	SELECT @errorId = @@ERROR IF (@errorId <> 0) GOTO ERRORHANDLER
	

	COMMIT TRANSACTION @tranzName
	return


	ERRORHANDLER:
	if( @errorId != 0 )
	BEGIN
		ROLLBACK TRANSACTION @tranzName
		RAISERROR (N'Unable to insert into ServiceHistory Table. Error id %d',15,1, @errorId);
	END
	
END 



SET ANSI_NULLS ON
GO
