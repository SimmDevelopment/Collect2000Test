SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Receiver_SelectRequestResponseReadyForFile]
@clientid int
AS
BEGIN
	DECLARE @lastFileSentDT datetime
	SELECT @lastFileSentDT = dbo.Receiver_GetLastFileDate(24,@clientid) --- TO DO Have to figure out what to pass to this function.

	-- Find the Responses to a Request 
	SELECT 'ARAR' as record_type,
	r.[SenderNumber] as file_number,
	req.[Code] as request_code,
	res.[Code] as response_code,
	arar.[OutSideRequestID] as request_id,
	arar.[ResponseText] as text
	FROM [dbo].[Receiver_RequestsAndResponses] arar WITH (NOLOCK)
	INNER JOIN [dbo].[receiver_reference] r WITH (NOLOCK)
	ON arar.[AccountID] = r.[ReceiverNumber]
	INNER JOIN [dbo].[Receiver_ResponseCode] res WITH (NOLOCK)
	ON res.[ID] = arar.[ResponseID]
	INNER JOIN [dbo].[Receiver_RequestCode] req WITH (NOLOCK)
	ON req.[ID] = arar.[RequestID]
	WHERE arar.ResponseID IS NOT NULL AND arar.[Responded] > @lastFileSentDT
		AND arar.clientID = @clientid
		AND [RequestOrigination] = @clientid
	
	UNION ALL
	
	-- Find the Request generated at the agency
	SELECT 'ARAR' as record_type,
	r.[SenderNumber] as file_number,
	req.[Code] as request_code,
	NULL as response_code,
	arar.[ID] as request_id,
	arar.[RequestText] as text
	FROM [dbo].[Receiver_RequestsAndResponses] arar WITH (NOLOCK)
	INNER JOIN [dbo].[receiver_reference] r WITH (NOLOCK)
	ON arar.[AccountID] = r.[ReceiverNumber]
	INNER JOIN [dbo].[Receiver_RequestCode] req WITH (NOLOCK)
	ON req.[ID] = arar.[RequestID]
	WHERE  arar.RequestID IS NOT NULL AND arar.[Requested] > @lastFileSentDT
		AND arar.clientID = @clientid
		AND [RequestOrigination] IS NULL

END
GO
