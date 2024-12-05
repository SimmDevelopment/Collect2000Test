SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_Complaint_SelectTransactionsReadyForFile]
@agencyId int,
@transactionTypeID int
AS

BEGIN
	CREATE TABLE #AIMExecutingExportTransactions (AccountTransactionID INT PRIMARY KEY, ForeignTableUniqueId INT)
	EXEC dbo.AIM_InsertExecutingTransactions @transactionTypeID,@agencyId

	-- We need to insert records into AIM_Complaint for which we don't already have records.
	INSERT INTO [dbo].[AIM_Complaint]([Source], [AccountID], [AgencyID], [ComplaintID])
	SELECT 'AIM', [Complaint].[AccountId], @agencyId, [Complaint].[ComplaintId]
	
	FROM #AIMExecutingExportTransactions [temp]		
	INNER JOIN [dbo].[Complaint] AS [Complaint] WITH (NOLOCK)
		ON [temp].[ForeignTableUniqueID] = [Complaint].[ComplaintId]	
	
	WHERE [ComplaintId] NOT IN (SELECT [AIM_Complaint].[ComplaintId] FROM [dbo].[AIM_Complaint] AS [AIM_Complaint]
								WHERE [AIM_Complaint].[AccountId] = [Complaint].[AccountId] AND [AIM_Complaint].[AgencyId] = @agencyId)	
	
	SELECT 
		'CCPT' as record_type,
		[Complaint].[AccountId] as [file_number],
		[Complaint].[DebtorId] AS [debtor_number],
		[AIM_Complaint].[Source] AS [source],
		[Complaint].[ComplaintId] AS [id],
		[AIM_Complaint].[ReceiverComplaintId] AS [receiver_complaint_id],
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

	FROM #AIMExecutingExportTransactions [temp]		
	INNER JOIN [dbo].[AIM_Complaint] AS [AIM_Complaint]
		ON [AIM_Complaint].[ComplaintId] = [temp].[ForeignTableUniqueID]
	INNER JOIN [dbo].[Complaint] AS [Complaint] WITH (NOLOCK)
		ON [AIM_Complaint].[ComplaintId] = [Complaint].[ComplaintId]
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
	ORDER BY [Complaint].[ComplaintId]

	
	UPDATE AIM_AccountTransaction
	SET TransactionStatusTypeID = 4
	FROM AIM_AccountTransaction ATR WITH (NOLOCK)
	JOIN #AIMExecutingExportTransactions a ON a.accounttransactionid = ATR.AccountTransactionID
	WHERE ATR.TransactionStatusTypeID = 1

	DROP TABLE #AIMExecutingExportTransactions
END
GO
