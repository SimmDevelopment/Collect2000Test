SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Changes: 03/09/2023 BGM Added with nolock to temp table sub query insert for the master table that gets the link number
-- =============================================

CREATE PROCEDURE [dbo].[Account_GetNextDueDate] @AccountID INTEGER, @DueDate DATETIME OUTPUT, @DueType VARCHAR(100) OUTPUT, @Expired BIT OUTPUT
AS
SET NOCOUNT ON;

SET @Expired = 0;

IF OBJECT_ID('tempdb.dbo.#AccountIds', 'U') IS NOT NULL
  DROP TABLE #AccountIds; 
--Populate all linked accounts 
SELECT [master].[number] INTO #AccountIds
FROM [dbo].[master] WITH (NOLOCK)
WHERE 
 [master].[link] IS NOT NULL  AND
(
 ([master].[link]<>0) AND (link IN (SELECT [link] FROM [dbo].[master] WITH (NOLOCK) WHERE [number] = @AccountID))
 OR
 (([master].[link]=0) AND ([number] = @AccountID))
 )

SELECT TOP 1  @DueDate=PDU.DueDate,
	 @DueType=PDU.DueType FROM 
(SELECT DepositDate AS DueDate, 'Next post-dated credit card is due' AS DueType, 1 AS DisplayOrder FROM [DebtorCreditCards] AS DCC WITH (NOLOCK) 
INNER JOIN DebtorCreditCardDetails AS DCCD WITH (NOLOCK)  ON DCC.ID=DCCD.DebtorCreditCardID 
INNER JOIN #AccountIDs AS acts on acts.[number]=DCCD.AccountID 
WHERE  DCC.[IsActive] = 1
	AND DCC.[OnHoldDate] IS NULL 
	

UNION 

	SELECT deposit AS DueDate, 'Next post-dated check is due' AS DueType, 2 AS DisplayOrder FROM [pdc] WITH (NOLOCK)  
	INNER JOIN  PdcDetails  AS PDCD WITH (NOLOCK) 
	ON [pdc].[UID]=PDCD.PdcID 
	INNER JOIN #AccountIDs AS acts on acts.[number]=PDCD.AccountID
	WHERE
	[pdc].Active = 1
	AND [pdc].onhold IS NULL



UNION

SELECT DueDate AS DueDate, 'Next promise is due' AS DueType, 3 AS DisplayOrder FROM [Promises]  AS p WITH (NOLOCK) 
INNER JOIN PromiseDetails AS pdt WITH (NOLOCK)
ON p.ID=pdt.PromiseID
INNER JOIN  #AccountIDs AS acts on acts.[number]=pdt.AccountID
WHERE p.[Active] = 1
	AND (p.[Suspended] IS NULL
	OR p.[Suspended] = 0)) PDU
ORDER BY PDU.DueDate, PDU.DisplayOrder


IF @DueDate IS NOT NULL BEGIN
	RETURN 0;
END;

IF NOT EXISTS (
	SELECT number
	FROM [dbo].[master] WITH (NOLOCK)
	INNER JOIN [dbo].[Settlement] WITH (NOLOCK)
	ON [master].[number] = [Settlement].[AccountID]
	AND [master].[SettlementID] = [master].[SettlementID]
	WHERE [Settlement].[SettlementAmount] IS NOT NULL) 
	BEGIN

	SELECT TOP 1 @DueDate = [LetterRequest].[DueDate],
		@DueType = 'Settlement offer due',
		@Expired = CASE
			WHEN [LetterRequest].[DueDate] < { fn CURDATE() } THEN 1
		END
	FROM [dbo].[LetterRequest] WITH (NOLOCK)
	INNER JOIN [dbo].[letter] WITH (NOLOCK)
	ON [LetterRequest].[LetterID] = [letter].[LetterID]
	WHERE [LetterRequest].[AccountID] = @AccountID
	AND [letter].[type] = 'SIF'
	ORDER BY [LetterRequest].[DueDate] DESC;

	IF @DueDate IS NOT NULL BEGIN
		RETURN 0;
		
	END;
END;

RETURN 1;
GO
