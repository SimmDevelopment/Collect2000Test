SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Receiver_ProcessRequestResponse]
@client_id int,
@file_number int,
@agency_id int,
@request_code varchar(5),
@response_code varchar(5),
@request_id int,
@text varchar(500)
AS
BEGIN
	/*<RequestAndResponse>
	<record_type>CRAR</record_type>
	<file_number>23760</file_number>
	<request_code>DSP</request_code>
	<request_id>31</request_id>
	<text>Debtor is disputing this debt please provide mediasadfdddddddsadfsdfsfd</text>
	</RequestAndResponse>
	*/
	DECLARE @receiverNumber INT
	SELECT @receivernumber = max(receivernumber) FROM receiver_reference WITH (NOLOCK) 
	WHERE sendernumber = @file_number and clientid = @client_id

	IF(@receivernumber is null)
	BEGIN
		RAISERROR ('15001', 16, 1)
		RETURN
	END
	
	DECLARE @Qlevel varchar(5)
	SELECT @QLevel = [QLevel] FROM [dbo].[Master] WITH (NOLOCK)
	WHERE [number] = @receiverNumber
	IF(@QLevel = '999') 
		BEGIN
		RAISERROR('Account has been returned, QLevel 999.',16,1)
		RETURN
	END

	DECLARE @responseID int
	DECLARE @lookUpRequestID int
	DECLARE @runDate datetime 

	SET @runDate = getdate()
	-- Do we need error checking when we can't find the lookup codes
	IF(@request_code IS NOT NULL)
	BEGIN
		SELECT @lookUpRequestID = [ID] 
		FROM [dbo].[Receiver_RequestCode] WITH (NOLOCK)
		WHERE [Code] = @request_code AND [ClientID] = @client_id

		IF(@lookUpRequestID IS NULL) 
		BEGIN
			RAISERROR('Request Code is not valid, it does not exist in the Receiver Request Code table',16,1)
			RETURN
		END
	END
	
	IF(@response_code IS NOT NULL) 
	BEGIN
		SELECT @responseID = [ID]
		FROM [dbo].[Receiver_ResponseCode] WITH (NOLOCK)
		WHERE [Code] = @response_code AND [ClientID] = @client_id
		IF(@responseID IS NULL) 
		BEGIN
			RAISERROR('Response Code is not valid, it does not exist in the Receiver Response Code table',16,1)
			RETURN
		END 
	END
	
	-- Is this a Request or a Response?
	IF(@lookUpRequestID IS NOT NULL AND @responseID IS NULL) 
	BEGIN
		-- Insert a record
		INSERT INTO [dbo].[Receiver_RequestsAndResponses]
		([ClientID],
		[RequestOrigination],
		[AccountID],
		[AgencyID],
		[RequestID],
		[ResponseID],
		[Requested],
		[Responded],
		[RequestText],
		[ResponseText],
		[OutsideRequestID])
		VALUES
		(@client_id, -- ClientID
		@client_id, -- RequestOrigination
		@receiverNumber, -- AccountID
		@agency_id, -- AgencyID
		@lookUpRequestID, -- RequestID
		NULL, -- ResponseID
		@runDate, -- Requested
		NULL, -- Responded
		@text, -- RequestText
		NULL, -- ResponseText
		@request_id -- OutsideRequestID
		)
	END

	-- Otherwise we have an update
	IF(@responseID IS NOT NULL) 
	BEGIN
		-- We have to have a matching RequestID to update
		IF(@lookUpRequestID IS NULL) 
		BEGIN
			RAISERROR('Request Code is not valid, it does not exist in the Receiver Request Code table',16,1)
			RETURN
		END
		-- We need to find the Record in [dbo].[Receiver_RequestsAndResponses] to Update
		DECLARE @existingRequestID int
		SELECT @existingRequestID = [ID]
		FROM [dbo].[Receiver_RequestsAndResponses] rr WITH (NOLOCK)
		WHERE [ClientID] = @client_id 
		AND [RequestID] = @lookUpRequestID
		--AND [ResponseID] = @responseID
		AND [AccountID] = @receiverNumber
		AND [ID] = @request_id

		-- Did we find a record to update?
		IF(@existingRequestID IS NULL) 
		BEGIN
			RAISERROR('Cannot find Request Response record to update, it does not exist in the Receiver Request Response table',16,1)
			RETURN
		END
	
		UPDATE [dbo].[Receiver_RequestsAndResponses]
		SET [ResponseID] = @responseID,
		[ResponseText] = @text,
		[Responded] = @runDate
		WHERE [ID] = @existingRequestID
	END
END

GO
