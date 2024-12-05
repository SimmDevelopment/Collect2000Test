SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_Demographic_SelectAgenciesReadyForFile]
@transactionTypeID int
AS
BEGIN

/* *************************************************************************
*  This proc gets a list of agencies ready to be placed.
*
***********************************************************************/

	SELECT
		A.AgencyID,
		A.AlphaCode,
		A.Name,
		COUNT(m.Number) as [Count],
		SUM(m.Current0) as [Value]
	FROM
		AIM_AccountTransaction ATR WITH (NOLOCK) 
		JOIN AIM_Agency A WITH (NOLOCK)
		ON ATR.AgencyID = A.AgencyID
		JOIN AIM_AccountReference AR WITH (NOLOCK)
		ON ATR.AccountReferenceID = AR.AccountReferenceID
		JOIN [Master] M WITH (NOLOCK)
		ON M.Number = AR.ReferenceNumber
	WHERE
		TransactionTypeID IN (36,37,38,46)
		AND TransactionStatusTypeID = 1
		AND ATR.AgencyID IS NOT NULL
	GROUP BY  
		A.AgencyID,
		A.AlphaCode,
		A.Name
END
GO
