SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_Complaints_UpdateAccountsReadyForFile]
AS
BEGIN
	DECLARE @lastRunDateTime DATETIME
	SELECT @lastRunDateTime = ISNULL(MAX(CompletedDateTime),'1900-01-01 00:00:00.000') FROM AIM_Batch b WITH (NOLOCK)
	JOIN AIM_BatchFileHistory bft WITH (NOLOCK) ON b.BatchId = bft.BatchId 
	WHERE BatchFileTypeId = 30

	--DECLARE TEMP TABLE
	DECLARE  @tempComplaints TABLE(
		[OurID] [int],
		[ReceiverId] [int],
		[Source] [varchar](30),
		[AccountId] [int]
	) 
	
	INSERT INTO AIM_AccountTransaction
	(AccountReferenceId,TransactionTypeId,TransactionStatusTypeID,CreatedDateTime,AgencyId,CommissionPercentage,
	Balance,FeeSchedule,ForeignTableUniqueID)
	
	-- Find Complaints we already sent that were updated.
	SELECT
	AR.AccountReferenceID,41,1,GETDATE(),AR.CurrentlyPlacedAgencyID,AR.CurrentCommissionPercentage,
	M.Current0,AR.FeeSchedule,[Complaint].[ComplaintId]

	--INSERT INTO @tempComplaints([OurID], [ReceiverId], [Source])
	--SELECT [Complaint].[Complaintid], NULL, 'AIMUPDATED'
	
	FROM [dbo].[AIM_AccountReference] AS AR WITH (NOLOCK) 
	INNER JOIN [dbo].[AIM_Complaint] AS [AIM_Complaint] WITH (NOLOCK)
		ON AR.ReferenceNumber = [AIM_Complaint].[AccountId] AND [AIM_Complaint].[AgencyID] = AR.CurrentlyPlacedAgencyID
	INNER JOIN [dbo].[Complaint] AS [Complaint] WITH (NOLOCK)	
		ON [AIM_Complaint].[ComplaintId] = [Complaint].[ComplaintId] AND [AIM_Complaint].[ReceiverComplaintId] IS NULL AND [AIM_Complaint].[Source] = 'AIM'
	INNER JOIN dbo.ComplaintCategory AS [ComplaintCategory] WITH (NOLOCK)
		ON Complaint.Category = ComplaintCategory.Code
	INNER JOIN [Master] M WITH (NOLOCK) 
		ON M.Number = AR.ReferenceNumber

	WHERE AR.IsPlaced = 1 AND 
	[Complaint].[ModifiedWhen] >
		CASE @lastRunDateTime 
			WHEN '1900-01-01 00:00:00.000' THEN AR.LastPlacementDate
			ELSE @lastRunDateTime
		END
	AND [Complaint].[ModifiedBy] NOT IN ('RECEIVER','AIM')

	-- Find Complaints that we received from Receiver that we updated.
	UNION ALL 

	--SELECT [Complaint].[Complaintid], NULL, 'RECEIVERUPDATED'

	SELECT
	AR.AccountReferenceID,41,1,GETDATE(),AR.CurrentlyPlacedAgencyID,AR.CurrentCommissionPercentage,
	M.Current0,AR.FeeSchedule,[Complaint].[ComplaintId]

	FROM [dbo].[AIM_AccountReference] AS AR WITH (NOLOCK) 
	INNER JOIN [dbo].[AIM_Complaint] AS [AIM_Complaint] WITH (NOLOCK)
		ON AR.ReferenceNumber = [AIM_Complaint].[AccountId] AND [AIM_Complaint].[AgencyID] = AR.CurrentlyPlacedAgencyID
	INNER JOIN [dbo].[Complaint] AS [Complaint] WITH (NOLOCK)	
		ON [AIM_Complaint].[ComplaintId] = [Complaint].[ComplaintId] AND [AIM_Complaint].[ReceiverComplaintId] IS NOT NULL AND [AIM_Complaint].[Source] = 'Receiver'
	INNER JOIN dbo.ComplaintCategory AS [ComplaintCategory] WITH (NOLOCK)
		ON Complaint.Category = ComplaintCategory.Code
	INNER JOIN [Master] M WITH (NOLOCK) 
		ON M.Number = AR.ReferenceNumber

	WHERE AR.IsPlaced = 1 AND 
	[Complaint].[ModifiedWhen] >
		CASE @lastRunDateTime 
			WHEN '1900-01-01 00:00:00.000' THEN AR.LastPlacementDate
			ELSE @lastRunDateTime
		END
	AND [Complaint].[ModifiedBy] NOT IN ('RECEIVER','AIM')
	
	-- Find New Complaints that were not sent in the placement file.
	UNION ALL 

	SELECT
	AR.AccountReferenceID,41,1,GETDATE(),AR.CurrentlyPlacedAgencyID,AR.CurrentCommissionPercentage,
	M.Current0,AR.FeeSchedule,[Complaint].[ComplaintId]
	--SELECT [Complaint].[Complaintid], NULL, 'AIMNEW'
	
	FROM [dbo].[AIM_AccountReference] AS AR WITH (NOLOCK) 
	INNER JOIN [Master] M WITH (NOLOCK) 
		ON M.Number = AR.ReferenceNumber
	INNER JOIN [dbo].[Complaint] AS [Complaint] WITH (NOLOCK)	
		ON [Complaint].[AccountId] = M.[number]
	INNER JOIN dbo.ComplaintCategory AS [ComplaintCategory] WITH (NOLOCK)
		ON Complaint.Category = ComplaintCategory.Code

	WHERE AR.IsPlaced = 1 
	AND [ComplaintId] NOT IN (SELECT [AIM_Complaint].[ComplaintId] FROM [dbo].[AIM_Complaint] AS [AIM_Complaint]
	                          WHERE [AIM_Complaint].[AccountId] = AR.ReferenceNumber)
							  
	--SELECT * FROM @tempComplaints		
END
GO
