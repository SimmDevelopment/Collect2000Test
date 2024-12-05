SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Receiver_SelectDisputesReadyForFile]
@clientid int
as
BEGIN
	DECLARE @lastFileSentDT datetime
	select @lastFileSentDT = dbo.Receiver_GetLastFileDate(32,@clientid)
	--DECLARE TEMP TABLE
	DECLARE  @tempDisputes TABLE(
		[OurID] [int],
		[AIMID] [int],
		[Source] [varchar](20),
		[AccountId] [int]
	) 
	
	--Find Disputes that we received from AIM that were updated.
	INSERT INTO @tempDisputes ([OurID], [AIMID], [Source], [AccountId])
	SELECT
		[Receiver_Dispute].[DisputeID], [Receiver_Dispute].[AIMDisputeID], 'AIM', [Dispute].[Number]
	FROM [dbo].[Receiver_Dispute] AS [Receiver_Dispute]
	INNER JOIN [dbo].[Dispute] AS [Dispute]
		ON [Dispute].[DisputeId] = [Receiver_Dispute].[DisputeId] AND [Receiver_Dispute].[ClientID] = @clientId AND [Receiver_Dispute].[Source] = 'AIM'
	INNER JOIN [dbo].[Receiver_Reference] AS [Receiver_Reference]
		ON [Receiver_Reference].[ReceiverNumber] = [Dispute].[Number] AND [Receiver_Reference].[ClientId] = @clientId
	WHERE [Dispute].[ModifiedWhen] >
		CASE @lastFileSentDT
			WHEN '1900-01-01 00:00:00.000' THEN [Dispute].[CreatedWhen]
			ELSE @lastFileSentDT
		END
	AND [Dispute].[ModifiedBy] != 'RECEIVER'
	
	-- If not the first attempt...
 	IF (@lastFileSentDT != '1900-01-01 00:00:00.000')
 	BEGIN
 		-- Find complaints created by Receiver that were updated since the last time sent.
 		INSERT INTO @tempDisputes (   [OurID] ,
 		                              [AIMID] ,
 		                              [Source] ,
 		                              [AccountId]
 		                          )
 		SELECT
 			d.[DisputeId], NULL, 'RECEIVER', d.[Number]
 		FROM [dbo].[Receiver_Dispute] AS rd
 		INNER JOIN [dbo].[Dispute] AS d
 			ON d.[DisputeId] = rd.[DisputeID] AND [rd].[ClientID] = @clientId AND [Source] = 'RECEIVER'
 		INNER JOIN [dbo].[Receiver_Reference] AS [Receiver_Reference]
 			ON [Receiver_Reference].[ReceiverNumber] = d.[Number] AND [Receiver_Reference].[ClientId] = @clientId
 		WHERE d.[ModifiedWhen] > @lastFileSentDT
 	END

	-- Find new Dispute Records 
	INSERT INTO @tempDisputes ([OurID], [AIMID], [Source], [AccountId])
	SELECT
		[Dispute].[DisputeId], NULL, 'RECEIVER', [Dispute].[Number]
	FROM [dbo].[Dispute] AS [Dispute]
	INNER JOIN [dbo].[Receiver_Reference] AS [Receiver_Reference]
			ON [Receiver_Reference].[ReceiverNumber] = [Dispute].[Number] AND [Receiver_Reference].[ClientId] = @clientId
	WHERE [Dispute].[DisputeId] NOT IN (SELECT [DisputeId] FROM [dbo].[Receiver_Dispute] WHERE [AccountId] = [Receiver_Reference].[ReceiverNumber] AND [ClientId] = @clientid)

	-- Insert into the Receiver_Dispute table.
	INSERT INTO [dbo].[Receiver_Dispute]([Source], [AccountID], [ClientId], [DisputeID], [AIMDisputeID])
	SELECT 'RECEIVER', [Dispute].[Number], @clientid, [Dispute].[DisputeId], NULL
		FROM [dbo].[Dispute] AS [Dispute]
		INNER JOIN [dbo].[Receiver_Reference] AS [Receiver_Reference]
			ON [Receiver_Reference].[ReceiverNumber] = [Dispute].[Number] AND [Receiver_Reference].[ClientId] = @clientId
	WHERE [Dispute].[DisputeId] IN (SELECT [OurId] FROM @tempDisputes WHERE [Source] = 'RECEIVER')
	
	-- Find all records which were created by AIM.
	SELECT 
		'ADIS' as record_type,
		[Receiver_Reference].[SenderNumber] as [file_number],
		[Receiver_DebtorReference].[SenderDebtorId] AS [debtor_number],
		[Receiver_Dispute].[Source] AS [source],
		[Receiver_Dispute].[AIMDisputeId] AS [id],
		NULL AS [receiver_dispute_id],
		d.[Type] [type_code],
		[dtype].[Description] [type],
		d.[DateReceived] [date_received],
		d.[ReferredBy] [referred_by_code],
		[listref].[Description] [referred_by],
		d.[Details] [details],
		d.[Category] [category_code],
		[listcat].[Description] [category],
		d.[Against] [against_code],
		[listagainst].[Description] [against],
		d.[DateClosed] [date_closed],
		d.[RecourseDate] [recourse_date],
		d.[Justified] [justified],
		d.[Outcome] [outcome_code],
		[listoutcome].[Description] [outcome],
		CASE WHEN ISNULL(d.[Deleted], 0) = 0 THEN 'N' ELSE 'Y' END [deleted],
		CASE WHEN ISNULL(d.[ProofRequired], 0) = 0 THEN 'N' ELSE 'Y' END [proof_required],
		CASE WHEN ISNULL(d.[ProofRequested], 0) = 0 THEN 'N' ELSE 'Y' END [proof_requested],
		CASE WHEN ISNULL(d.[InsufficientProofReceived], 0) = 0 THEN 'N' ELSE 'Y' END [insufficient_proof_received],
		CASE WHEN ISNULL(d.[ProofReceived], 0) = 0 THEN 'N' ELSE 'Y' END [proof_received]
	FROM [dbo].[Receiver_Dispute] AS [Receiver_Dispute]
	INNER JOIN [dbo].[Dispute] AS d WITH (NOLOCK)
		ON [Receiver_Dispute].[DisputeId] = d.[DisputeId]
	INNER JOIN [dbo].[Receiver_Reference] AS [Receiver_Reference]
		ON [Receiver_Reference].[ReceiverNumber] = d.[Number] AND [Receiver_Reference].[ClientId] = @clientid
	INNER JOIN [dbo].[Debtors] AS [Debtors]
		ON [Debtors].[Number] = [Receiver_Reference].[ReceiverNumber] AND [Debtors].[SEQ] = 0
	INNER JOIN [dbo].[Receiver_DebtorReference] AS [Receiver_DebtorReference]
		ON [Receiver_DebtorReference].[ReceiverDebtorId] = [Debtors].[DebtorId] AND [Receiver_DebtorReference].[ClientId] = @clientid
	LEFT OUTER JOIN [dbo].[DisputeType] dtype
	ON dtype.[Code] = d.[Type]
	LEFT OUTER JOIN [dbo].[Custom_ListData] listref
	ON listref.[Code] = d.[ReferredBy] AND listref.[ListCode] = 'DISPUTEREF'
	LEFT OUTER JOIN [dbo].[Custom_ListData] listcat
	ON listcat.[Code] = d.[Category] AND listcat.[ListCode] = 'DISPUTECAT'
	LEFT OUTER JOIN [dbo].[Custom_ListData] listagainst
	ON listagainst.[Code] = d.[Against] AND listagainst.[ListCode] = 'DISPUTEAGT'
	LEFT OUTER JOIN [dbo].[Custom_ListData] listoutcome
	ON listoutcome.[Code] = d.[Outcome] AND listoutcome.[ListCode] = 'DISPUTEOUT'
	WHERE d.[DisputeID] IN (SELECT [OurID] FROM @tempDisputes WHERE [Source] = 'AIM')
	
	UNION ALL 
	
	-- Find all records which were created by Receiver.
	SELECT 
		'ADIS' as record_type,
		[Receiver_Reference].[SenderNumber] as [file_number],
		[Receiver_DebtorReference].[SenderDebtorId] AS [debtor_number],
		[Receiver_Dispute].[Source] AS [source],
		[Receiver_Dispute].[AIMDisputeId] AS [id],
		d.[DisputeID] AS [receiver_dispute_id],
		d.[Type] [type_code],
		[dtype].[Description] [type],
		d.[DateReceived] [date_received],
		d.[ReferredBy] [referred_by_code],
		[listref].[Description] [referred_by],
		d.[Details] [details],
		d.[Category] [category_code],
		[listcat].[Description] [category],
		d.[Against] [against_code],
		[listagainst].[Description] [against],
		d.[DateClosed] [date_closed],
		d.[RecourseDate] [recourse_date],
		d.[Justified] [justified],
		d.[Outcome] [outcome_code],
		[listoutcome].[Description] [outcome],
		CASE WHEN ISNULL(d.[Deleted], 0) = 0 THEN 'N' ELSE 'Y' END [deleted],
		CASE WHEN ISNULL(d.[ProofRequired], 0) = 0 THEN 'N' ELSE 'Y' END [proof_required],
		CASE WHEN ISNULL(d.[ProofRequested], 0) = 0 THEN 'N' ELSE 'Y' END [proof_requested],
		CASE WHEN ISNULL(d.[InsufficientProofReceived], 0) = 0 THEN 'N' ELSE 'Y' END [insufficient_proof_received],
		CASE WHEN ISNULL(d.[ProofReceived], 0) = 0 THEN 'N' ELSE 'Y' END [proof_received]
	FROM [dbo].[Receiver_Dispute] AS [Receiver_Dispute]
	INNER JOIN [dbo].[Dispute] AS d WITH (NOLOCK)
		ON [Receiver_Dispute].[DisputeId] = d.[DisputeId]
	INNER JOIN [dbo].[Receiver_Reference] AS [Receiver_Reference]
		ON [Receiver_Reference].[ReceiverNumber] = d.[Number]  AND [Receiver_Reference].[ClientId] = @clientid
	INNER JOIN [dbo].[Debtors] AS [Debtors]
		ON [Debtors].[Number] = [Receiver_Reference].[ReceiverNumber] AND [Debtors].[SEQ] = 0
	INNER JOIN [dbo].[Receiver_DebtorReference] AS [Receiver_DebtorReference]
		ON [Receiver_DebtorReference].[ReceiverDebtorId] = [Debtors].[DebtorId] AND [Receiver_DebtorReference].[ClientId] = @clientid
	LEFT OUTER JOIN [dbo].[DisputeType] dtype
	ON dtype.[Code] = d.[Type]
	LEFT OUTER JOIN [dbo].[Custom_ListData] listref
	ON listref.[Code] = d.[ReferredBy] AND listref.[ListCode] = 'DISPUTEREF'
	LEFT OUTER JOIN [dbo].[Custom_ListData] listcat
	ON listcat.[Code] = d.[Category] AND listcat.[ListCode] = 'DISPUTECAT'
	LEFT OUTER JOIN [dbo].[Custom_ListData] listagainst
	ON listagainst.[Code] = d.[Against] AND listagainst.[ListCode] = 'DISPUTEAGT'
	LEFT OUTER JOIN [dbo].[Custom_ListData] listoutcome
	ON listoutcome.[Code] = d.[Outcome] AND listoutcome.[ListCode] = 'DISPUTEOUT'
	WHERE d.[DisputeID] IN (SELECT [OurID] FROM @tempDisputes WHERE [Source] = 'RECEIVER')
	
END
GO
