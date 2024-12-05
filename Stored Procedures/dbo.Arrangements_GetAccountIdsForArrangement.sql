SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_GetAccountIdsForArrangement] @ArrangementId INTEGER
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @AccountIDs TABLE (
		[AccountID] INTEGER
	);
		
	INSERT INTO @AccountIDs ([AccountID])
	
	SELECT [Promises].[AcctId]
	FROM [dbo].[Promises]
	WHERE [Promises].[ArrangementId] = @ArrangementId
	AND [Promises].[Active] = 1
	
	UNION ALL
		
	SELECT [Details].[AccountId]
	FROM [dbo].[Promises]
	INNER JOIN [dbo].[PromiseDetails] AS [Details]
	ON [Promises].[Id] = [Details].[PromiseId] 
	WHERE [Promises].[ArrangementId] = @ArrangementId
	AND [Promises].[Active] = 1
	
	UNION ALL
	
	SELECT [pdc].[Number]
	FROM [dbo].[pdc]
	WHERE [pdc].[ArrangementId] = @ArrangementId
	AND ( [pdc].[active] = 1
	OR   ([pdc].[active] = 0 AND [pdc].[NSFCount] = 1))

	UNION ALL
	
	SELECT [Details].[AccountId]
	FROM [dbo].[pdc]
	INNER JOIN [dbo].[PDCDetails] AS [Details]
	ON [pdc].[UID] = [Details].[PDCId] 
	WHERE [pdc].[ArrangementId] = @ArrangementId
	AND ( [pdc].[active] = 1
	OR   ([pdc].[active] = 0 AND [pdc].[NSFCount] = 1))
	
	UNION ALL
	
	SELECT [DebtorCreditCards].[Number]
	FROM [dbo].[DebtorCreditCards]
	WHERE [DebtorCreditCards].[ArrangementId] = @ArrangementId
	AND ([DebtorCreditCards].[IsActive] = 1
	OR (([DebtorCreditCards].[AuthErrCode] = 1 AND [NSFCount] >= 0) OR [NSFCount] = 1))

	UNION ALL
		
	SELECT [Details].[AccountId]
	FROM [dbo].[DebtorCreditCards]
	INNER JOIN [dbo].[DebtorCreditCardDetails] AS [Details]
	ON [DebtorCreditCards].[ID] = [Details].[DebtorCreditCardID] 
	WHERE [DebtorCreditCards].[ArrangementId] = @ArrangementId
	AND ([DebtorCreditCards].[IsActive] = 1
	OR (([DebtorCreditCards].[AuthErrCode] = 1 AND [NSFCount] >= 0) OR [NSFCount] = 1))
	
	SELECT DISTINCT [AccountId] FROM @AccountIds;
	
	RETURN 0;
END
GO
