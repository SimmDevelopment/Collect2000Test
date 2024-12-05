SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 CREATE PROCEDURE [dbo].[AIM_Disputes_UpdateAccountsReadyForFile]
 AS
 BEGIN
 	DECLARE @lastRunDateTime DATETIME
 	SELECT @lastRunDateTime = ISNULL(MAX(CompletedDateTime),'1900-01-01 00:00:00.000') FROM AIM_Batch b WITH (NOLOCK)
 	JOIN AIM_BatchFileHistory bft WITH (NOLOCK) ON b.BatchId = bft.BatchId 
 	WHERE BatchFileTypeId = 32
 	INSERT INTO AIM_AccountTransaction
 	(AccountReferenceId,TransactionTypeId,TransactionStatusTypeID,CreatedDateTime,AgencyId,CommissionPercentage,
 	Balance,FeeSchedule,ForeignTableUniqueID)
 	
 	-- Find Disputes we already sent that were updated.
 	SELECT
 	AR.AccountReferenceID,43,1,GETDATE(),AR.CurrentlyPlacedAgencyID,AR.CurrentCommissionPercentage,
 	M.Current0,AR.FeeSchedule,[Dispute].[DisputeId]
 	FROM [dbo].[AIM_AccountReference] AS AR WITH (NOLOCK) 
 	INNER JOIN [dbo].[AIM_Dispute] AS [AIM_Dispute] WITH (NOLOCK)
 		ON AR.ReferenceNumber = [AIM_Dispute].[AccountID] AND [AIM_Dispute].[AgencyID] = AR.CurrentlyPlacedAgencyID
 	INNER JOIN [dbo].[Dispute] AS [Dispute] WITH (NOLOCK)	
 		ON [AIM_Dispute].[DisputeId] = [Dispute].[DisputeId] AND [AIM_Dispute].[ReceiverDisputeID] IS NULL AND [AIM_Dispute].[Source] = 'AIM'
 	INNER JOIN [Master] M WITH (NOLOCK) 
 		ON M.Number = AR.ReferenceNumber
 	WHERE AR.IsPlaced = 1 AND 
 	[Dispute].[ModifiedWhen] >
 		CASE @lastRunDateTime 
 			WHEN '1900-01-01 00:00:00.000' THEN AR.LastPlacementDate
 			ELSE @lastRunDateTime
 		END
 	AND [Dispute].[ModifiedBy] != 'RECEIVER'
 	-- Find New Disputes that were not sent in the placement file.
 	UNION ALL 
 	SELECT
 	AR.AccountReferenceID,43,1,GETDATE(),AR.CurrentlyPlacedAgencyID,AR.CurrentCommissionPercentage,
 	M.Current0,AR.FeeSchedule,[Dispute].[DisputeId]
 	FROM [dbo].[AIM_AccountReference] AS AR WITH (NOLOCK) 
 	INNER JOIN [Master] M WITH (NOLOCK) 
 		ON M.Number = AR.ReferenceNumber
 	INNER JOIN [dbo].[Dispute] AS [Dispute] WITH (NOLOCK)	
 		ON [Dispute].[Number] = M.[number]
 	WHERE AR.IsPlaced = 1 
 	AND [DisputeId] NOT IN (SELECT [AIM_Dispute].[DisputeId] FROM [dbo].[AIM_Dispute] AS [AIM_Dispute]
 	                          WHERE [AIM_Dispute].[AccountId] = AR.ReferenceNumber)
	
	UNION ALL 
 	SELECT
 	AR.AccountReferenceID,41,1,GETDATE(),AR.CurrentlyPlacedAgencyID,AR.CurrentCommissionPercentage,
 	M.Current0,AR.FeeSchedule,[Dispute].[DisputeId]
 	FROM [dbo].[AIM_AccountReference] AS AR WITH (NOLOCK) 
 	INNER JOIN [dbo].[AIM_Dispute] AS [AIM_Dispute] WITH (NOLOCK)
 		ON AR.ReferenceNumber = [AIM_Dispute].[AccountId] AND [AIM_Dispute].[AgencyID] = AR.CurrentlyPlacedAgencyID
 	INNER JOIN [dbo].[Dispute] AS [Dispute] WITH (NOLOCK)	
 		ON [AIM_Dispute].[DisputeId] = [Dispute].[DisputeId] AND [AIM_Dispute].[ReceiverDisputeId] IS NOT NULL AND [AIM_Dispute].[Source] = 'Receiver'
 	INNER JOIN [Master] M WITH (NOLOCK) 
 		ON M.Number = AR.ReferenceNumber
 	WHERE AR.IsPlaced = 1 AND 
 	[Dispute].[ModifiedWhen] >
 		CASE @lastRunDateTime 
 			WHEN '1900-01-01 00:00:00.000' THEN AR.LastPlacementDate
 			ELSE @lastRunDateTime
 		END
 	AND [Dispute].[ModifiedBy] != 'RECEIVER'

 END
GO
