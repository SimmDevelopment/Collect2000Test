SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_Notes_UpdateAccountsReadyForFile]
AS
BEGIN
DECLARE @lastRunDateTime DATETIME
SELECT @lastRunDateTime = ISNULL(MAX(CompletedDateTime),'1900-01-01 00:00:00.000') FROM AIM_Batch b WITH (NOLOCK)
JOIN AIM_BatchFileHistory bft WITH (NOLOCK) ON b.BatchId = bft.BatchId 
WHERE BatchFileTypeId = 15

INSERT INTO AIM_AccountTransaction
(AccountReferenceId,TransactionTypeId,TransactionStatusTypeID,CreatedDateTime,AgencyId,CommissionPercentage,
Balance,FeeSchedule,ForeignTableUniqueID)
SELECT
AR.AccountReferenceID,21,1,GETDATE(),AR.CurrentlyPlacedAgencyID,AR.CurrentCommissionPercentage,
M.Current0,AR.FeeSchedule,N.UID
FROM [Notes] N WITH (NOLOCK) 
JOIN AIM_AccountReference AR WITH (NOLOCK) 
ON N.Number = AR.ReferenceNumber
JOIN [Master] M WITH (NOLOCK) 
ON M.Number = AR.ReferenceNumber
JOIN [Users] U WITH (NOLOCK) 
ON N.User0 = U.LoginName
WHERE
N.Created > @lastRunDateTime AND N.Created > AR.LastPlacementDate
AND N.User0 <> 'AIM' AND AR.IsPlaced = 1
END

GO
