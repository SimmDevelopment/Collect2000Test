SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE   PROCEDURE [dbo].[Custom_Insert_ServiceHistory_RequestId_bak]
@requestId as int,	
@manifestId as uniqueidentifier,
@historyXml as text,
@responseBatchId as uniqueidentifier
AS
BEGIN
	Declare @originalRequestId int
	Declare @errorId int
	Declare @tranzName varchar(32)
	
	set @errorId = 0
	set @tranzName = 'DeleteServicesCTDupes'
	Declare @err int

	set @originalRequestId=@requestId

	BEGIN TRANSACTION @tranzName
	--See if it is already in ServiceHistory table
	IF exists( select requestid from ServiceHistory with (nolock) where requestid=@requestId and XmlInfoReturned is not null )
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
			Select @originalRequestId,[FileName],GETDATE(),GETDATE(),@historyXml
			From ServiceHistory with (nolock) where requestId=@requestId

			SELECT @errorId = @@ERROR
			IF (@errorId <> 0) GOTO ERRORHANDLER
			
			--Insert into ServiceHistory_RESPONSES([RequestId],[FileName

			SELECT @errorId = @@ERROR
			IF (@errorId <> 0) GOTO ERRORHANDLER
		END

	--Else
	--	BEGIN	
	Update ServiceHistory Set XMLInfoReturned=@historyXml,returnedDate=GETDATE(),Processed = 3,ResponseBatchId = @responseBatchId Where RequestId=@requestId	

	SELECT @errorId = @@ERROR IF (@errorId <> 0) GOTO ERRORHANDLER
	--	END

	COMMIT TRANSACTION @tranzName
	return


	ERRORHANDLER:
	if( @errorId != 0 )
	BEGIN
		ROLLBACK TRANSACTION @tranzName
		RAISERROR (N'Unable to insert into ServiceHistory Table. Error id %d',15,1, @errorId);
	END
	
END



GO
