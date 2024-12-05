SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_RequestAndResponse_Process]
 @file_number INT,
 @request_code CHAR(5),
 @response_code CHAR(5),
 @request_id INT,
 @text VARCHAR(500),
 @agencyid INT
  AS
 BEGIN
 

DECLARE @qcode VARCHAR(5)
DECLARE @date DATETIME
DECLARE @masterNumber INT,@currentAgencyId INT
SELECT @masterNumber = Number,@currentAgencyId = AIMAgency
FROM dbo.master WITH (NOLOCK) WHERE Number = @file_number
 
 --validate account exists and placed with this agency
 IF(@masterNumber IS NULL)
	BEGIN
		RAISERROR('15001',16,1)
		RETURN
	END
 -- Changed by KAR on 04/25/2011 send 15004	The account is currently not placed with this agency
 IF(@currentAgencyId IS NULL OR (@currentAgencyId <> @agencyId))
	BEGIN
		RAISERROR('15004',16,1)
		RETURN
	END
IF(ISNULL(@request_id,0) <= 0)
	BEGIN
		RAISERROR('There is not a Request ID IN THE ARAR Record',16,1)
		RETURN
	END


--Request or Response?
IF EXISTS(SELECT * FROM AIM_RequestsAndResponses WITH (NOLOCK) WHERE AccountID = @file_number AND ID = @request_id)
BEGIN
--Response to internal request
	 DECLARE @responseID INT
	 SELECT @responseID  = ID FROM AIM_ResponseCode WITH (NOLOCK) WHERE Code = @response_code
	 IF(@responseID IS NULL)
	 BEGIN
		RAISERROR('Response Code is not valid, it does not exist in the AIM Response Code table',16,1)
		RETURN
	 END

	 UPDATE AIM_RequestsAndResponses
	 SET
	 ResponseID = @responseID,
	 ResponseText = (SELECT TOP 1 ISNULL(DefaultText,'') + @text FROM AIM_ResponseCode WHERE ID = @responseID),
	 Responded = GETDATE()
	 WHERE ID = @request_id
	

	SELECT @qcode = q.Code FROM QLevel q WITH (NOLOCK) JOIN AIM_ResponseCode rc 
		ON rc.QLevel = q.Code WHERE rc.ID = @responseID
	IF (@qcode IS NOT NULL)
	BEGIN
	EXEC [dbo].[SupportQueueItem_Insert] @file_number,@qcode,0,NULL,1,'AIM','AIM Response received from outside entity',0
	EXEC [dbo].[spNote_AddV5] @file_number,@date,'AIM','CC',@qcode,'AIM Response received from outside entity',0,0
	END
	
END
ELSE --IF EXISTS(SELECT * FROM AIM_RequestsAndResponses WITH (NOLOCK) WHERE AccountID = @file_number AND OutsideRequestID = @request_id)
BEGIN
	--Response
	DECLARE @requestID INT
	SELECT @requestID = ID FROM AIM_RequestCode WITH (NOLOCK) WHERE Code = @request_code
	IF(@requestID IS NULL)
	BEGIN
	RAISERROR('Request Code is not valid, it does not exist in the AIM Request Code table',16,1)
	END

	  --Insert Request
	INSERT INTO AIM_RequestsAndResponses
	([RequestOrigination],
	[AccountID] ,
	[AgencyID] ,
	[RequestID] ,
	[ResponseID] ,
	[Requested] ,
	[Responded] ,
	[RequestText],
	[ResponseText],
	[OutsideRequestID] )
	SELECT
	@agencyid,@file_number,@agencyid,@requestID,NULL,GETDATE(),NULL,
	ISNULL(DefaultText,'') + @text,NULL,@request_id
	FROM AIM_RequestCode WHERE ID = @requestID

	SET @date = GETDATE()
	SELECT @qcode = q.Code FROM QLevel q WITH (NOLOCK) JOIN AIM_RequestCode rc 
		ON rc.QLevel = q.Code WHERE rc.ID = @requestID
	IF (@qcode IS NOT NULL)
	BEGIN
		EXEC [dbo].[SupportQueueItem_Insert] @file_number,@qcode,0,NULL,1,'AIM','AIM Request received from outside entity',0
		EXEC [dbo].[spNote_AddV5] @file_number,@date,'AIM','CC',@qcode,'AIM Request received from outside entity',0,0
	END
END




END

GO
