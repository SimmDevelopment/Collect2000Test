SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE	 Procedure [dbo].[Email_GetForLinkedDebtors]  
 @AccountID int  
AS  

SET NOCOUNT ON;      

BEGIN 

	WITH cteLinkedAccts (AccountId) 
	AS
	(
		SELECT [AccountID] FROM [dbo].[fnGetLinkedAccounts](@AccountID, NULL)
	)

	SELECT CAST(cte.[AccountId] AS VARCHAR) + ' - ' + deb.[Name] AS [Key],
		deb.[DebtorID] AS [Text]
	FROM cteLinkedAccts cte
		INNER JOIN [Debtors] deb
			ON cte.AccountId = deb.Number
	WHERE cte.[AccountId] <> @AccountID
		AND deb.Seq = 0

END 
GO
