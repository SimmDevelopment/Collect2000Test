SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_HasActiveArrangement] @AccountID INTEGER, @HasArrangement INTEGER OUTPUT
AS
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @LinkID INT;
	DECLARE @ArrangementIds TABLE (
		[ArrangementId] INTEGER NOT NULL PRIMARY KEY CLUSTERED
	);
	
	DECLARE @AccountIds TABLE (
		[AccountId] INTEGER NOT NULL PRIMARY KEY CLUSTERED
	);
	SELECT @LinkID = ISNULL([link],0) FROM [dbo].[master] WHERE [number] = @AccountId;
	IF @LinkID IS NOT NULL AND @LinkID <> 0 BEGIN

		INSERT INTO @AccountIDs ([AccountID])
		SELECT [master].[number]
		FROM [dbo].[master]
		WHERE [master].[link] = @LinkID;
	
	END;
	ELSE BEGIN
		INSERT INTO @AccountIDs ([AccountID])
		SELECT [master].[number]
		FROM [dbo].[master]
		WHERE [master].[number] = @AccountID;
	END;
	
--	select top 1 * from dbo.promises    active = 1 and suspended != 1
--select top 1 * from dbo.debtorcreditcards isactive = 1 and OnHoldDate is NULL
--select top 1 * from dbo.pdc active and onHold is null
	
	INSERT INTO @ArrangementIds ([ArrangementId])
	SELECT DISTINCT A.[ArrangementId]
	FROM (
		SELECT [ArrangementId]
		FROM [dbo].[debtorcreditcards] AS d
		INNER JOIN [dbo].[debtorcreditcarddetails] AS dd
			ON dd.[DebtorCreditCardId] = d.[ID]
		WHERE [ArrangementId] IS NOT NULL AND [IsActive] = 1 
		--AND [OnHoldDate] IS NULL //(LAT-10650 Fix- Since we set the OnHoldDate flag to true of remaining debtorcreditcards in case of an NSF, we need to fetch those CCs as well. So commenting the onhold check here)
		AND [AccountId] IN (SELECT [AccountId] FROM @AccountIds)
		GROUP BY [ArrangementId]
		  
		UNION ALL 
		
		SELECT [ArrangementId]
		FROM [dbo].[pdc] AS p
		INNER JOIN [dbo].[pdcdetails] AS d
		ON d.[PdcId] = p.[UID]
		WHERE [ArrangementId] IS NOT NULL AND [active] = 1  
		--AND [onHold] IS NULL  //(LAT-10650 Fix- Since we set the onhold flag to true of remaining PDCs in case of an NSF, we need to fetch those PDCs as well. So commenting the onhold check here)
		AND [AccountId] IN (SELECT [AccountId] FROM @AccountIds)
		GROUP BY [ArrangementId]

		UNION ALL 
		
		SELECT [ArrangementId]
		FROM [dbo].[promises] AS p
		INNER JOIN [dbo].[promisedetails] AS d
			ON d.[PromiseId] = p.[Id]
		WHERE [ArrangementId] IS NOT NULL AND [active] = 1  
		--AND ISNULL([suspended],0) = 0  //(LAT-10650 Fix- Since we set the suspended flag to true of remaining promises in case of an NSF, we need to fetch those promises as well. So commenting the suspended check here)
		AND [AccountId] IN (SELECT [AccountId] FROM @AccountIds)
		GROUP BY [ArrangementId]
) AS A;
		
	SELECT @HasArrangement = COUNT(*) FROM @ArrangementIds;
	RETURN 0;

GO
