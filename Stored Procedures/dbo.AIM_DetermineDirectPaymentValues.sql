SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[AIM_DetermineDirectPaymentValues]
@number INT
AS

SELECT TOP 1
AR.CurrentlyPlacedAgencyID as [AIMAgencyID],
CASE WHEN ISNULL(AR.CurrentCommissionPercentage,0) > 0 THEN 'CommissionPercentage' ELSE 'FeeSchedule' END as [CommissionType],
ISNULL(AR.CurrentCommissionPercentage,0) as [CommissionPercentage],
AR.FeeSchedule,
BFH.BatchID as [AIMBatchID],
A.NetOrGross

FROM AIM_AccountReference AR WITH (NOLOCK)
JOIN AIM_Agency A WITH (NOLOCK) ON A.AgencyID = AR.CurrentlyPlacedAgencyID
JOIN AIM_AccountTransaction ATR WITH (NOLOCK) ON AR.AccountReferenceID = ATR.AccountReferenceID
JOIN AIM_BatchFileHistory BFH WITH (NOLOCK) ON BFH.BatchFileHistoryID = ATR.BatchFileHistoryID
	AND ATR.AgencyID = AR.CurrentlyPlacedAgencyID
WHERE
AR.ISPlaced = 1 AND ATR.TransactionTypeID = 1 AND ATR.TransactionStatusTypeID = 3
AND ATR.ValidPlacement = 1 AND AR.ReferenceNumber = @number
ORDER BY AccountTransactionID DESC

GO
