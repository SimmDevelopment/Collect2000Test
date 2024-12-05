SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE                procedure [dbo].[AIM_Payment_SelectAgenciesReadyForFile]
@transactionTypeID int
AS

BEGIN

SET NOCOUNT ON;

-- Changed by KAR on 11/05/2012 Exclude duplicates by marking transactionstatustypeid as negative 1.
UPDATE AIM_accounttransaction
SET transactionstatustypeid = -1
WHERE	transactiontypeid = @transactionTypeID
	AND transactionstatustypeid = 1
	AND AgencyID IS NOT NULL 
AND AccountTransactionID NOT IN
(SELECT MAX(ATR2.AccountTransactionID)
FROM AIM_accounttransaction ATR2 WITH (NOLOCK)
WHERE	ATR2.transactiontypeid = @transactionTypeID
	AND ATR2.transactionstatustypeid = 1
	AND ATR2.AgencyID IS NOT NULL 
GROUP BY ATR2.agencyid,ATR2.transactiontypeid,ATR2.transactionstatustypeid,ATR2.ForeignTableUniqueID)


SELECT
		A.AgencyID,
		A.AlphaCode,
		A.Name,
		COUNT(p.Number) as [Count],
		SUM(p.TotalPaid) AS [Value],
		SUM(p.Paid1) AS [principle],
		SUM(p.Paid2) AS [interest],
		SUM(p.Paid3) AS [other3],
		SUM(p.Paid4) AS [other4],
		SUM(p.Paid5) AS [other5],
		SUM(p.Paid6) AS [other6],
		SUM(p.Paid7) AS [other7],
		SUM(p.Paid8) AS [other8],
		SUM(p.Paid9) AS [other9]
	
	FROM
		AIM_AccountTransaction ATR WITH (NOLOCK) 
		JOIN AIM_Agency A WITH (NOLOCK)
		ON ATR.AgencyID = A.AgencyID
		JOIN AIM_AccountReference AR WITH (NOLOCK)
		ON ATR.AccountReferenceID = AR.AccountReferenceID 
		JOIN Payhistory P WITH (NOLOCK)
		ON P.UID = ATR.ForeignTableUniqueID
	WHERE
		TransactionTypeID = @transactionTypeID
		AND TransactionStatusTypeID = 1
		AND ATR.AgencyID IS NOT NULL
	GROUP BY  
		A.AgencyID,
		A.AlphaCode,
		A.Name
END
GO
