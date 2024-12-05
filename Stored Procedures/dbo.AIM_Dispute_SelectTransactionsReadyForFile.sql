SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 CREATE PROCEDURE [dbo].[AIM_Dispute_SelectTransactionsReadyForFile]
 @agencyId int,
 @transactionTypeID int
 AS
 BEGIN
 	CREATE TABLE #AIMExecutingExportTransactions (AccountTransactionID INT PRIMARY KEY, ForeignTableUniqueId INT)
 	EXEC dbo.AIM_InsertExecutingTransactions @transactionTypeID,@agencyId

	INSERT INTO [dbo].[AIM_Dispute] (   [AccountID] ,
	                                    [AgencyID] ,
	                                    [DisputeID] ,
	                                    [ReceiverDisputeID] ,
										[Source]
	                                )
	SELECT d.[Number],
			@agencyId,
			d.[DisputeId],
			NULL,
			'AIM'
	FROM [#AIMExecutingExportTransactions] temp
	INNER JOIN [dbo].[Dispute] d
	ON d.[DisputeId] = temp.[ForeignTableUniqueId]
	WHERE d.[DisputeId] NOT IN (SELECT ad.[DisputeID]
	                            FROM [dbo].[AIM_Dispute] ad
								WHERE ad.[AccountID] = d.[Number] AND ad.[AgencyID] = @agencyId)

	SELECT 
		'CDIS' [record_type],
		d.[Number] [file_number],
		d.[DebtorId] [debtor_number],
		[aim_d].[Source] [source],
		d.[DisputeId] [id],
		[aim_d].[ReceiverDisputeID] [receiver_dispute_id],
		d.[Type] [type_code],
		dtype.[Description] [type],
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
	FROM [#AIMExecutingExportTransactions] temp
	INNER JOIN [dbo].[AIM_Dispute] aim_d
	ON [aim_d].[DisputeID] = temp.[ForeignTableUniqueId]
	INNER JOIN [dbo].[Dispute] d
	ON d.[DisputeId] = [aim_d].[DisputeID]
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
	ORDER BY d.[DisputeId]

	UPDATE [dbo].[AIM_AccountTransaction]
	SET [TransactionStatusTypeId] = 4
	FROM [dbo].[AIM_AccountTransaction] atr
	INNER JOIN [#AIMExecutingExportTransactions] temp
	ON temp.[AccountTransactionID] = atr.[AccountTransactionId]
	WHERE atr.[TransactionStatusTypeId] = 1

	DROP TABLE [#AIMExecutingExportTransactions]

END
GO
