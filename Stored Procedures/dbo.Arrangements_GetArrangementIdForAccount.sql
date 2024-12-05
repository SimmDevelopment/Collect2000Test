SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_GetArrangementIdForAccount] @AccountID INTEGER
WITH RECOMPILE
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @AccountIDs TABLE (
		[AccountID] INTEGER NOT NULL PRIMARY KEY CLUSTERED
	);

	DECLARE @PromiseIDs TABLE (
		[PromiseID] INTEGER NOT NULL PRIMARY KEY CLUSTERED,
		[AccountId]  INTEGER
	);

	DECLARE @PromiseDetails TABLE (
		[PromiseID] INTEGER,
		[AccountId]  INTEGER
	);

	DECLARE @PdcIDs TABLE (
		[PdcID] INTEGER NOT NULL PRIMARY KEY CLUSTERED,
		[AccountId]  INTEGER
	);

	DECLARE @PdcDetails TABLE (
		[PdcID] INTEGER,
		[AccountId]  INTEGER
	);

	DECLARE @PccIDs TABLE (
		[PccID] INTEGER NOT NULL PRIMARY KEY CLUSTERED,
		[AccountId]  INTEGER
	);

	DECLARE @PccDetails TABLE (
		[PccID] INTEGER,
		[AccountId]  INTEGER
	);
	
	DECLARE @LinkID INT;
	SELECT @LinkID = ISNULL([link],0) FROM [dbo].[master] WHERE [number] = @AccountId;
	
	IF @LinkID IS NOT NULL AND @LinkID <> 0 BEGIN
		
		INSERT INTO @AccountIDs ([AccountID])
		SELECT [master].[number]
		FROM [dbo].[master]
		WHERE [master].[link] = @LinkID;
		
		INSERT INTO @PromiseIDs ([PromiseID], [AccountId])
		SELECT [Promises].[ID], [Promises].[AcctId]
		FROM [dbo].[Promises]
		INNER JOIN [dbo].[master]
		ON [Promises].[AcctID] = [master].[number]
		WHERE [master].[link] = @LinkID
		AND [Promises].[Active] = 1;
		
		INSERT INTO @PromiseDetails ([PromiseID], [AccountId])
		SELECT [Details].[PromiseID], [Details].[AccountId]
		FROM @PromiseIDs AS [p]
		INNER JOIN [dbo].[PromiseDetails] AS [Details]
		ON [p].[promiseId] = [Details].[PromiseId] 
		WHERE [Details].[AccountId] = @AccountId;
		
		INSERT INTO @PdcIDs ([PdcID], [AccountId])
		SELECT [pdc].[UID], [pdc].[Number]
		FROM [dbo].[pdc]
		INNER JOIN [dbo].[master]
		ON [pdc].[number] = [master].[number]
		WHERE [master].[link] = @LinkID
		AND [pdc].[active] = 1;

		INSERT INTO @PDCDetails ([PdcID], [AccountId])
		SELECT [Details].[PdcID], [Details].[AccountId]
		FROM @PdcIDs AS [p]
		INNER JOIN [dbo].[PDCDetails] AS [Details]
		ON [p].[PDCId] = [Details].[PDCId] 
		WHERE [Details].[AccountId] = @AccountId;
		
		INSERT INTO @PccIDs ([PccID], [AccountId])
		SELECT [DebtorCreditCards].[ID],[DebtorCreditCards].[Number]
		FROM [dbo].[DebtorCreditCards]
		INNER JOIN [dbo].[master]
		ON [DebtorCreditCards].[Number] = [master].[number]
		WHERE [master].[link] = @LinkID
		AND [DebtorCreditCards].[IsActive] = 1;
		
		INSERT INTO @PccDetails ([PccID], [AccountId])
		SELECT [Details].[DebtorCreditCardID], [Details].[AccountId]
		FROM @PccIDs AS [p]
		INNER JOIN [dbo].[DebtorCreditCardDetails] AS [Details]
		ON [p].[PccID] = [Details].[DebtorCreditCardID] 
		WHERE [Details].[AccountId] = @AccountId;
		
	END;
	ELSE BEGIN
		INSERT INTO @AccountIDs ([AccountID])
		SELECT [master].[number]
		FROM [dbo].[master]
		WHERE [master].[number] = @AccountID;

		INSERT INTO @PromiseIDs ([PromiseID], [AccountId])
		SELECT [Promises].[ID], [Promises].[AcctId]
		FROM [dbo].[Promises]
		WHERE [Promises].[AcctID] = @AccountID
		AND [Promises].[Active] = 1;

		INSERT INTO @PromiseDetails ([PromiseID], [AccountId])
		SELECT [Details].[PromiseID], [Details].[AccountId]
		FROM @PromiseIDs AS [p]
		INNER JOIN [dbo].[PromiseDetails] AS [Details]
		ON [p].[promiseId] = [Details].[PromiseId] 
		WHERE [Details].[AccountId] = @AccountId;

		INSERT INTO @PdcIDs ([PdcID], [AccountId])
		SELECT [pdc].[UID], [pdc].[Number]
		FROM [dbo].[pdc]
		WHERE [pdc].[number] = @AccountID
		AND [pdc].[active] = 1;
		
		INSERT INTO @PDCDetails ([PdcID], [AccountId])
		SELECT [Details].[PdcID], [Details].[AccountId]
		FROM @PdcIDs AS [p]
		INNER JOIN [dbo].[PDCDetails] AS [Details]
		ON [p].[PDCId] = [Details].[PDCId] 
		WHERE [Details].[AccountId] = @AccountId;

		INSERT INTO @PccIDs ([PccID], [AccountId])
		SELECT [DebtorCreditCards].[ID],[DebtorCreditCards].[Number]
		FROM [dbo].[DebtorCreditCards]
		WHERE [DebtorCreditCards].[Number] = @AccountID
		AND [DebtorCreditCards].[IsActive] = 1;

		INSERT INTO @PccDetails ([PccID], [AccountId])
		SELECT [Details].[DebtorCreditCardID], [Details].[AccountId]
		FROM @PccIDs AS [p]
		INNER JOIN [dbo].[DebtorCreditCardDetails] AS [Details]
		ON [p].[PccID] = [Details].[DebtorCreditCardID] 
		WHERE [Details].[AccountId] = @AccountId;
				
	END;

	SELECT [Id] FROM [dbo].[Arrangements] WHERE [Id] IN 
	(	SELECT [ArrangementId]
		FROM [dbo].[PDC]
		INNER JOIN @PdcIDs AS [P]
		ON [PDC].[UID] = [P].[PdcID]
		INNER JOIN @PdcDetails AS [d]
		ON [P].[PdcID] = [d].[PdcID]
		WHERE [P].[AccountId] = @AccountId OR [d].[AccountID] = @AccountID
	 
		UNION ALL 

		SELECT [ArrangementId]
		FROM [dbo].[Promises]
		INNER JOIN @PromiseIDs AS [P]
		ON [Promises].[ID] = [P].[PromiseID]
		INNER JOIN @PromiseDetails AS [d]
		ON [P].[PromiseID] = [d].[PromiseID]
		WHERE [P].[AccountId] = @AccountId OR [d].[AccountID] = @AccountID
		
	 
		UNION ALL 
	 
		SELECT [ArrangementId]
		FROM [dbo].[DebtorCreditCards]
		INNER JOIN @PccIDs AS [P]
		ON [DebtorCreditCards].[ID] = [P].[PccID]
		INNER JOIN @PCCDetails AS [d]
		ON [P].[PccID] = [d].[PccID]
		WHERE [P].[AccountId] = @AccountId OR [d].[AccountID] = @AccountID
		
	)
	GROUP BY [ID];
	
	RETURN 0;
END
GO
