SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_SelectAgenciesReadyForFile]
@transactionTypeID int
AS

BEGIN
	SELECT
		A.AgencyID,
		A.AlphaCode,
		A.Name,
		COUNT(m.Number) as [Count],
		CASE @transactionTypeID WHEN 1 THEN SUM(m.Current0) ELSE 0 END AS [Value]
	FROM
		AIM_AccountTransaction ATR WITH (NOLOCK) 
		JOIN AIM_Agency A WITH (NOLOCK)
		ON ATR.AgencyID = A.AgencyID
		JOIN AIM_AccountReference AR WITH (NOLOCK)
		ON ATR.AccountReferenceID = AR.AccountReferenceID 
		AND AR.CurrentlyPlacedAgencyID = ATR.AgencyID
		JOIN [Master] M WITH (NOLOCK)
		ON M.Number = AR.ReferenceNumber
	WHERE
		TransactionTypeID = @transactionTypeID
		AND TransactionStatusTypeID = 1
		AND ATR.AgencyID IS NOT NULL
		AND ATR.CreatedDateTime > AR.LastPlacementDate
		AND AR.IsPlaced = 1
	GROUP BY  
		A.AgencyID,
		A.AlphaCode,
		A.Name

END

GO
