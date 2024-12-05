SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_Judgment_UpdateAccountsReadyForFile]
AS
BEGIN
DECLARE @lastRunDateTime DATETIME
SELECT @lastRunDateTime = ISNULL(MAX(CompletedDateTime),'1900-01-01 00:00:00.000') FROM AIM_Batch b WITH (NOLOCK)
JOIN AIM_BatchFileHistory bft WITH (NOLOCK) ON b.BatchId = bft.BatchId 
WHERE BatchFileTypeId = 24

INSERT INTO AIM_AccountTransaction
(AccountReferenceId,TransactionTypeId,TransactionStatusTypeID,CreatedDateTime,AgencyId,CommissionPercentage,
Balance,FeeSchedule,ForeignTableUniqueID)
SELECT
AR.AccountReferenceID,32,1,GETDATE(),AR.CurrentlyPlacedAgencyID,AR.CurrentCommissionPercentage,
M.Current0,AR.FeeSchedule,CC.CourtCaseID
FROM [CourtCases] CC WITH (NOLOCK) JOIN AIM_AccountReference AR WITH (NOLOCK) ON CC.AccountID = AR.ReferenceNumber
JOIN [Master] M WITH (NOLOCK) ON M.Number = AR.ReferenceNumber
WHERE
CC.DateUpdated > @lastRunDateTime AND CC.DateUpdated > AR.LastPlacementDate
AND CC.UpdatedBy <> -1
END

GO
