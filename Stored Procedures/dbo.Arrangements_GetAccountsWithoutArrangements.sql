SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_GetAccountsWithoutArrangements] @AccountID INTEGER, @LinkID INTEGER
WITH RECOMPILE
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @AccountIDs TABLE (
		[AccountID] INTEGER NOT NULL PRIMARY KEY CLUSTERED
	);

	DECLARE @PromiseIDs TABLE (
		[PromiseID] INTEGER NOT NULL PRIMARY KEY CLUSTERED
	);

	DECLARE @PdcIDs TABLE (
		[PdcID] INTEGER NOT NULL PRIMARY KEY CLUSTERED
	);

	DECLARE @PccIDs TABLE (
		[PccID] INTEGER NOT NULL PRIMARY KEY CLUSTERED
	);

	IF @LinkID IS NOT NULL AND @LinkID <> 0 BEGIN
		
		INSERT INTO @AccountIDs ([AccountID])
		SELECT [master].[number]
		FROM [dbo].[master]
		WHERE [master].[link] = @LinkID;
		
		INSERT INTO @PromiseIDs ([PromiseID])
		SELECT [Promises].[ID]
		FROM [dbo].[Promises]
		INNER JOIN [dbo].[master]
		ON [Promises].[AcctID] = [master].[number]
		WHERE [master].[link] = @LinkID
		AND [Promises].[Active] = 1;

		INSERT INTO @PdcIDs ([PdcID])
		SELECT [pdc].[UID]
		FROM [dbo].[pdc]
		INNER JOIN [dbo].[master]
		ON [pdc].[number] = [master].[number]
		WHERE [master].[link] = @LinkID
		AND [pdc].[active] = 1;

		INSERT INTO @PccIDs ([PccID])
		SELECT [DebtorCreditCards].[ID]
		FROM [dbo].[DebtorCreditCards]
		INNER JOIN [dbo].[master]
		ON [DebtorCreditCards].[Number] = [master].[number]
		WHERE [master].[link] = @LinkID
		AND [DebtorCreditCards].[IsActive] = 1;
	END;
	ELSE BEGIN
		INSERT INTO @AccountIDs ([AccountID])
		SELECT [master].[number]
		FROM [dbo].[master]
		WHERE [master].[number] = @AccountID;

		INSERT INTO @PromiseIDs ([PromiseID])
		SELECT [Promises].[ID]
		FROM [dbo].[Promises]
		WHERE [Promises].[AcctID] = @AccountID
		AND [Promises].[Active] = 1;

		INSERT INTO @PdcIDs ([PdcID])
		SELECT [pdc].[UID]
		FROM [dbo].[pdc]
		WHERE [pdc].[number] = @AccountID
		AND [pdc].[active] = 1;

		INSERT INTO @PccIDs ([PccID])
		SELECT [DebtorCreditCards].[ID]
		FROM [dbo].[DebtorCreditCards]
		WHERE [DebtorCreditCards].[Number] = @AccountID
		AND [DebtorCreditCards].[IsActive] = 1;
	END;

	SELECT * FROM @AccountIDs
	WHERE [AccountId] NOT IN 
	(	SELECT DISTINCT [number]
		FROM [dbo].[PDC]
		INNER JOIN @PdcIDs AS [P]
		ON [PDC].[UID] = [P].[PdcID]
	 
		UNION ALL 
	 
		SELECT DISTINCT [AccountId]
		FROM [dbo].[PDCDetails]
		INNER JOIN @PdcIDs AS [P]
		ON [PDCDetails].[PdcID] = [P].[PdcID]
	 
		UNION ALL 
		
		SELECT DISTINCT [AcctId]
		FROM [dbo].[Promises]
		INNER JOIN @PromiseIDs AS [P]
		ON [Promises].[ID] = [P].[PromiseID]
	 
		UNION ALL 
	 
		SELECT DISTINCT [AccountId]
		FROM [dbo].[PromiseDetails]
		INNER JOIN @PromiseIDs AS [P]
		ON [PromiseDetails].[PromiseID] = [P].[PromiseID]
		
		UNION ALL 
		
		SELECT DISTINCT [number]
		FROM [dbo].[DebtorCreditCards]
		INNER JOIN @PccIDs AS [P]
		ON [DebtorCreditCards].[ID] = [P].[PccID]
	 
		UNION ALL 
	 
		SELECT DISTINCT [AccountId]
		FROM [dbo].[DebtorCreditCardDetails]
		INNER JOIN @PccIDs AS [P]
		ON [DebtorCreditCardDetails].[DebtorCreditCardID] = [P].[PccID]
		
	);
	RETURN 0;
END
SET ANSI_NULLS ON
GO
