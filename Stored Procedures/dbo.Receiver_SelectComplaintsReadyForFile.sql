SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Receiver_SelectComplaintsReadyForFile]
@clientid int
as
BEGIN
	DECLARE @lastFileSentDT datetime
	select @lastFileSentDT = dbo.Receiver_GetLastFileDate(30,@clientid)
	--DECLARE TEMP TABLE
	DECLARE  @tempComplaints TABLE(
		[OurID] [int],
		[AIMID] [int],
		[Source] [varchar](30),
		[AccountId] [int]
	) 
	
	--Find Complaints that we received from AIM that were updated.
	INSERT INTO @tempComplaints ([OurID], [AIMID], [Source], [AccountId])
	SELECT
		[Receiver_Complaint].[ID], [Receiver_Complaint].[AIMComplaintID], 'AIMUPDATED', [Complaint].[AccountId]
	FROM [dbo].[Receiver_Complaint] AS [Receiver_Complaint]
	INNER JOIN [dbo].[Complaint] AS [Complaint]
		ON [Complaint].[ComplaintId] = [Receiver_Complaint].[ComplaintId] AND [Receiver_Complaint].[ClientID] = @clientId AND [Source] = 'AIM'
	INNER JOIN [dbo].[Receiver_Reference] AS [Receiver_Reference]
		ON [Receiver_Reference].[ReceiverNumber] = [Complaint].[AccountId] AND [Receiver_Reference].[ClientId] = @clientId
	WHERE [Complaint].[ModifiedWhen] >
		CASE @lastFileSentDT
			WHEN '1900-01-01 00:00:00.000' THEN [Complaint].[CreatedWhen]
			ELSE @lastFileSentDT
		END
	AND [Complaint].[ModifiedBy] NOT IN ('RECEIVER','AIM')
	
	-- If not the first attempt...
	IF (@lastFileSentDT != '1900-01-01 00:00:00.000')
	BEGIN
		-- Find complaints created by Receiver that were updated since the last time sent.
		INSERT INTO @tempComplaints ([OurID], [AIMID], [Source], [AccountId])
		SELECT
			[Complaint].[ComplaintId], NULL, 'RECEIVERUPDATED', [Complaint].[AccountId]
		FROM [dbo].[Receiver_Complaint] AS [Receiver_Complaint]
		INNER JOIN [dbo].[Complaint] AS [Complaint]
			ON [Complaint].[ComplaintId] = [Receiver_Complaint].[ComplaintId] AND [Receiver_Complaint].[ClientID] = @clientId AND [Source] = 'Receiver'
		INNER JOIN [dbo].[Receiver_Reference] AS [Receiver_Reference]
			ON [Receiver_Reference].[ReceiverNumber] = [Complaint].[AccountId] AND [Receiver_Reference].[ClientId] = @clientId
		WHERE [Complaint].[ModifiedWhen] > @lastFileSentDT
		AND [Complaint].[ModifiedBy] NOT IN ('RECEIVER','AIM')
	END
	
	-- Find new Complaint Records 
	INSERT INTO @tempComplaints ([OurID], [AIMID], [Source], [AccountId])
	SELECT
		[Complaint].[ComplaintId], NULL, 'RECEIVERNEW', [Complaint].[AccountId]
	FROM [dbo].[Complaint] AS [Complaint]
	INNER JOIN [dbo].[Receiver_Reference] AS [Receiver_Reference]
			ON [Receiver_Reference].[ReceiverNumber] = [Complaint].[AccountId] AND [Receiver_Reference].[ClientId] = @clientId
	WHERE [Complaint].[ComplaintId] NOT IN (SELECT [ComplaintId] FROM [dbo].[Receiver_Complaint] WHERE [AccountId] = [Receiver_Reference].[ReceiverNumber] AND [ClientId] = @clientid)

	-- Insert into the Receiver_Complaint table.
	INSERT INTO [dbo].[Receiver_Complaint]([Source], [AccountID], [ClientId], [ComplaintID], [AIMComplaintID])
	SELECT 'RECEIVER', [Complaint].[AccountId], @clientid, [Complaint].[ComplaintId], NULL
		FROM [dbo].[Complaint] AS [Complaint]
		INNER JOIN [dbo].[Receiver_Reference] AS [Receiver_Reference]
			ON [Receiver_Reference].[ReceiverNumber] = [Complaint].[AccountId] AND [Receiver_Reference].[ClientId] = @clientId
	WHERE [Complaint].[ComplaintId] IN (SELECT [OurId] FROM @tempComplaints WHERE [Source] = 'RECEIVERNEW')
	
	--select * from @tempComplaints
	
	-- Find all records which were created by AIM.
	SELECT 
		'ACPT' as record_type,
		[Receiver_Reference].[SenderNumber] as [file_number],
		[Receiver_DebtorReference].[SenderDebtorId] AS [debtor_number],
		[Receiver_Complaint].[Source] AS [source],
		[Receiver_Complaint].[AIMComplaintId] AS [id],
		NULL AS [receiver_complaint_id],
		Custom_ListDataComplaintAgainst.Code AS [against_code],
		Custom_ListDataComplaintAgainst.Description AS [against],
		[Complaint].[Against] AS [against_entity],
		ComplaintCategory.Code AS [category],
		[Complaint].[CompensationAmount] AS [compensation_amount],
		[Complaint].[Conclusion] AS [conclusion],
		[Complaint].[DateClosed] AS [date_closed],
		[Complaint].[DateInAdmin] AS [date_in_admin],
		[Complaint].[DateReceived] AS [date_received],
		CASE ISNULL([Complaint].[Deleted],0) WHEN 0 THEN 'N' ELSE 'Y' END  AS [deleted],
		[Complaint].[Details] AS [details],
		CASE ISNULL([Complaint].[Dissatisfaction],0) WHEN 0 THEN 'N' ELSE 'Y' END AS [dissatisfaction],
		[Complaint].[DissatisfactionDate] AS [dissatisfaction_date],
		[Complaint].[Grievances] AS [grievances],
		[Complaint].[InvestigationCommentsToDate] AS [investigation_comments_to_date],
		Custom_ListDataComplaintJustified.Code AS [justified_code],
		Custom_ListDataComplaintJustified.Description AS [justified],
		Custom_LIstDataComplaintOutcome.Code AS [outcome_code],
		Custom_LIstDataComplaintOutcome.Description AS [outcome],
		[Complaint].[Owner] AS [owner],
		[Complaint].[RecourseDate] AS [recourse_date],
		[Complaint].[ReferredBy] AS [referred_by],
		Custom_ListDataComplaintRoot.Code AS [root_cause_code],
		Custom_ListDataComplaintRoot.Description AS [root_cause],
		[Complaint].[SLADays] AS [sla_days],
		Custom_ListDataComplaintStatus.Code AS [status_code],
		Custom_ListDataComplaintStatus.Description AS [status],
		Custom_ListDataComplaintType.Code AS [type_code],
		Custom_ListDataComplaintType.Description AS [type]		

	FROM [dbo].[Receiver_Complaint] AS [Receiver_Complaint]
	INNER JOIN [dbo].[Complaint] AS [Complaint] WITH (NOLOCK)
		ON [Receiver_Complaint].[ComplaintId] = [Complaint].[ComplaintId]
	INNER JOIN [dbo].[Receiver_Reference] AS [Receiver_Reference]
		ON [Receiver_Reference].[ReceiverNumber] = [Complaint].[AccountId] AND [Receiver_Reference].[ClientId] = @clientid
	INNER JOIN [dbo].[Debtors] AS [Debtors]
		ON [Debtors].[Number] = [Receiver_Reference].[ReceiverNumber] AND [Debtors].[SEQ] = 0
	INNER JOIN [dbo].[Receiver_DebtorReference] AS [Receiver_DebtorReference]
		ON [Receiver_DebtorReference].[ReceiverDebtorId] = [Debtors].[DebtorId] AND [Receiver_DebtorReference].[ClientId] = @clientid
	LEFT OUTER JOIN Custom_ListData AS [Custom_ListDataComplaintAgainst] WITH (NOLOCK)
		ON Custom_ListDataComplaintAgainst.Code = Complaint.AgainstType AND Custom_ListDataComplaintAgainst.ListCode = 'COMPLTAGST'
	INNER JOIN dbo.ComplaintCategory AS [ComplaintCategory] WITH (NOLOCK)
		ON Complaint.Category = ComplaintCategory.Code
	LEFT OUTER JOIN Custom_ListData AS [Custom_ListDataComplaintJustified] WITH (NOLOCK)
		ON Custom_ListDataComplaintJustified.Code = Complaint.Justified AND Custom_ListDataComplaintJustified.ListCode = 'COMPLTJST'
	LEFT OUTER JOIN Custom_ListData AS [Custom_ListDataComplaintOutcome] WITH (NOLOCK)
		ON Custom_ListDataComplaintOutcome.Code = Complaint.Outcome AND Custom_ListDataComplaintOutcome.ListCode = 'COMPLTOUT'
	LEFT OUTER JOIN Custom_ListData AS [Custom_ListDataComplaintRoot] WITH (NOLOCK)
		ON Custom_ListDataComplaintRoot.Code = Complaint.RootCause AND Custom_ListDataComplaintRoot.ListCode = 'COMPLTROOT'
	LEFT OUTER JOIN Custom_ListData AS [Custom_ListDataComplaintStatus] WITH (NOLOCK)
		ON Custom_ListDataComplaintStatus.Code = Complaint.Status AND Custom_ListDataComplaintStatus.ListCode = 'COMPLTSTAT'
	LEFT OUTER JOIN Custom_ListData AS [Custom_ListDataComplaintType] WITH (NOLOCK)
		ON Custom_ListDataComplaintType.Code = Complaint.Type AND Custom_ListDataComplaintType.ListCode = 'COMPLTTYPE'
	WHERE [Complaint].[ComplaintID] IN (SELECT [OurID] FROM @tempComplaints WHERE [Source] = 'AIMUPDATED')
	
	UNION ALL 
	
	-- Find all records which were created by Receiver.
	SELECT 
		'ACPT' as record_type,
		[Receiver_Reference].[SenderNumber] as [file_number],
		[Receiver_DebtorReference].[SenderDebtorId] AS [debtor_number],
		[Receiver_Complaint].[Source] AS [source],
		[Receiver_Complaint].[AIMComplaintId] AS [id],
		[Complaint].[ComplaintID] AS [receiver_complaint_id],
		Custom_ListDataComplaintAgainst.Code AS [against_code],
		Custom_ListDataComplaintAgainst.Description AS [against],
		[Complaint].[Against] AS [against_entity],
		ComplaintCategory.Code AS [category],
		[Complaint].[CompensationAmount] AS [compensation_amount],
		[Complaint].[Conclusion] AS [conclusion],
		[Complaint].[DateClosed] AS [date_closed],
		[Complaint].[DateInAdmin] AS [date_in_admin],
		[Complaint].[DateReceived] AS [date_received],
		CASE ISNULL([Complaint].[Deleted],0) WHEN 0 THEN 'N' ELSE 'Y' END  AS [deleted],
		[Complaint].[Details] AS [details],
		CASE ISNULL([Complaint].[Dissatisfaction],0) WHEN 0 THEN 'N' ELSE 'Y' END AS [dissatisfaction],
		[Complaint].[DissatisfactionDate] AS [dissatisfaction_date],
		[Complaint].[Grievances] AS [grievances],
		[Complaint].[InvestigationCommentsToDate] AS [investigation_comments_to_date],
		Custom_ListDataComplaintJustified.Code AS [justified_code],
		Custom_ListDataComplaintJustified.Description AS [justified],
		Custom_LIstDataComplaintOutcome.Code AS [outcome_code],
		Custom_LIstDataComplaintOutcome.Description AS [outcome],
		[Complaint].[Owner] AS [owner],
		[Complaint].[RecourseDate] AS [recourse_date],
		[Complaint].[ReferredBy] AS [referred_by],
		Custom_ListDataComplaintRoot.Code AS [root_cause_code],
		Custom_ListDataComplaintRoot.Description AS [root_cause],
		[Complaint].[SLADays] AS [sla_days],
		Custom_ListDataComplaintStatus.Code AS [status_code],
		Custom_ListDataComplaintStatus.Description AS [status],
		Custom_ListDataComplaintType.Code AS [type_code],
		Custom_ListDataComplaintType.Description AS [type]		
	
	FROM [dbo].[Receiver_Complaint] AS [Receiver_Complaint]
	INNER JOIN [dbo].[Complaint] AS [Complaint] WITH (NOLOCK)
		ON [Receiver_Complaint].[ComplaintId] = [Complaint].[ComplaintId]
	INNER JOIN [dbo].[Receiver_Reference] AS [Receiver_Reference]
		ON [Receiver_Reference].[ReceiverNumber] = [Complaint].[AccountId]  AND [Receiver_Reference].[ClientId] = @clientid
	INNER JOIN [dbo].[Debtors] AS [Debtors]
		ON [Debtors].[Number] = [Receiver_Reference].[ReceiverNumber] AND [Debtors].[SEQ] = 0
	INNER JOIN [dbo].[Receiver_DebtorReference] AS [Receiver_DebtorReference]
		ON [Receiver_DebtorReference].[ReceiverDebtorId] = [Debtors].[DebtorId] AND [Receiver_DebtorReference].[ClientId] = @clientid
	LEFT OUTER JOIN Custom_ListData AS [Custom_ListDataComplaintAgainst] WITH (NOLOCK)
		ON Custom_ListDataComplaintAgainst.Code = Complaint.AgainstType AND Custom_ListDataComplaintAgainst.ListCode = 'COMPLTAGST'
	INNER JOIN dbo.ComplaintCategory AS [ComplaintCategory] WITH (NOLOCK)
		ON Complaint.Category = ComplaintCategory.Code
	LEFT OUTER JOIN Custom_ListData AS [Custom_ListDataComplaintJustified] WITH (NOLOCK)
		ON Custom_ListDataComplaintJustified.Code = Complaint.Justified AND Custom_ListDataComplaintJustified.ListCode = 'COMPLTJST'
	LEFT OUTER JOIN Custom_ListData AS [Custom_ListDataComplaintOutcome] WITH (NOLOCK)
		ON Custom_ListDataComplaintOutcome.Code = Complaint.Outcome AND Custom_ListDataComplaintOutcome.ListCode = 'COMPLTOUT'
	LEFT OUTER JOIN Custom_ListData AS [Custom_ListDataComplaintRoot] WITH (NOLOCK)
		ON Custom_ListDataComplaintRoot.Code = Complaint.RootCause AND Custom_ListDataComplaintRoot.ListCode = 'COMPLTROOT'
	LEFT OUTER JOIN Custom_ListData AS [Custom_ListDataComplaintStatus] WITH (NOLOCK)
		ON Custom_ListDataComplaintStatus.Code = Complaint.Status AND Custom_ListDataComplaintStatus.ListCode = 'COMPLTSTAT'
	LEFT OUTER JOIN Custom_ListData AS [Custom_ListDataComplaintType] WITH (NOLOCK)
		ON Custom_ListDataComplaintType.Code = Complaint.Type AND Custom_ListDataComplaintType.ListCode = 'COMPLTTYPE'
	WHERE [Complaint].[ComplaintID] IN (SELECT [OurID] FROM @tempComplaints WHERE [Source] LIKE 'RECEIVER%')
	
END
GO
