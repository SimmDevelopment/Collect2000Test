SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_Placement_SelectAgenciesReadyForFile]
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
		SUM(ROUND(m.Current1,2)+ROUND(m.Current2,2)+ROUND(m.Current3,2)+ROUND(m.Current4,2)+ROUND(m.Current5,2)
		+ROUND(m.Current6,2)+ROUND(m.Current7,2)+ROUND(m.Current8,2)+ROUND(m.Current9,2)) as [Value]
	FROM
		AIM_AccountTransaction ATR WITH (NOLOCK) 
		JOIN AIM_Agency A WITH (NOLOCK)
		ON ATR.AgencyID = A.AgencyID
		JOIN AIM_AccountReference AR WITH (NOLOCK)
		ON ATR.AccountReferenceID = AR.AccountReferenceID
		JOIN [Master] M WITH (NOLOCK)
		ON M.Number = AR.ReferenceNumber
	WHERE
		TransactionTypeID = 1 
		AND TransactionStatusTypeID = 1
		AND ATR.AgencyID IS NOT NULL
	GROUP BY  
		A.AgencyID,
		A.AlphaCode,
		A.Name
END

GO
