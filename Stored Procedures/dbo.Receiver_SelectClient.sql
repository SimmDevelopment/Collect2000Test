SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  procedure [dbo].[Receiver_SelectClient]
	@clientId int
AS
	select
		*
	from
		Receiver_Client
	where
		clientid = @clientId

	select
		dbo.Receiver_GetLastFileDate(1,@clientId) as LastPlacementReceived
		,dbo.Receiver_GetLastFileDate(2,@clientId) as LastPendingRecallReceived
		,dbo.Receiver_GetLastFileDate(3,@clientId) as LastRecallObjectionSent
		,dbo.Receiver_GetLastFileDate(4,@clientId) as LastFinalRecallReceived
		,dbo.Receiver_GetLastFileDate(5,@clientId) as LastPaymentReceived
		,dbo.Receiver_GetLastFileDate(6,@clientId) as LastPaymentSent
		,dbo.Receiver_GetLastFileDate(7,@clientId) as LastDemographicReceived
		,dbo.Receiver_GetLastFileDate(8,@clientId) as LastDemographicSent
		,dbo.Receiver_GetLastFileDate(9,@clientId) as LastCloseSent
		,dbo.Receiver_GetLastFileDate(10,@clientId) as LastBankruptcySent
		,dbo.Receiver_GetLastFileDate(11,@clientId) as LastDeceasedSent
		,dbo.Receiver_GetLastFileDate(12,@clientId) as LastReconciliationSent
		-- Added by KAR on 04/12/2010
		,dbo.Receiver_GetLastFileDate(13,@clientId) as LastNotesReceived--13
	    ,dbo.Receiver_GetLastFileDate(14,@clientId) as LastMiscExtraReceived--14
		,dbo.Receiver_GetLastFileDate(15,@clientId) as LastPostDatedTransactionsSent--15
		,dbo.Receiver_GetLastFileDate(16,@clientId) as LastAcknowledgmentSent--16
		,dbo.Receiver_GetLastFileDate(17,@clientId) as LastNotesSent--17
		,dbo.Receiver_GetLastFileDate(18,@clientId) as LastEquipmentReceived--18
		,dbo.Receiver_GetLastFileDate(19,@clientId) as LastAssetReceived--19
		,dbo.Receiver_GetLastFileDate(20,@clientId) as LastJudgmentReceived--20
		,dbo.Receiver_GetLastFileDate(21,@clientId) as LastRequestResponseReceived--21
		,dbo.Receiver_GetLastFileDate(22,@clientId) as LastAssetSent--22
		,dbo.Receiver_GetLastFileDate(23,@clientId) as LastJudgmentSent--23
		,dbo.Receiver_GetLastFileDate(24,@clientId) as LastRequestResponseSent--24
		,dbo.Receiver_GetLastFileDate(25,@clientId) as LastBankruptcyReceived--25
		,dbo.Receiver_GetLastFileDate(26,@clientId) as LastDeceasedReceived--26
		,dbo.Receiver_GetLastFileDate(27,@clientId) as LastActivityNotesSent--27
		,dbo.Receiver_GetLastFileDate(28,@clientId) as LastWorkEffortsSent--28
		,dbo.Receiver_GetLastFileDate(29,@clientId) as LastComplaintReceived--29
		,dbo.Receiver_GetLastFileDate(30,@clientId) as LastComplaintSent--30
		,dbo.Receiver_GetLastFileDate(31,@clientId) as LastDisputeReceived--31
		,dbo.Receiver_GetLastFileDate(32,@clientId) as LastDisputeSent--32
	select
	*
	FROM
	Receiver_StatusLookup
	WHERE
	clientid = @clientid

	SELECT
	*
	FROM 
	Receiver_CustomerLookup
	WHERE 
	clientid = @clientid

	select *
	FROM Receiver_ASTSConfig
	WHERE 
	clientid = @clientid

	select *
	FROM Receiver_RequestCode
	WHERE 
	clientid = @clientid

	select *
	from Receiver_ResponseCode
	WHERE 
	clientid = @clientid
	
	select * from [dbo].[Receiver_LetterRequestsWorkEffortConfig]
	WHERE 
	clientid = @clientid	
	
	select * from [dbo].[Receiver_NotesWorkEffortConfig]
	WHERE 
	clientid = @clientid	
	
GO
