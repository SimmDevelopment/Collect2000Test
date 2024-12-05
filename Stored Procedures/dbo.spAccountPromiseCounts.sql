SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*spAccountPromiseCounts*/
CREATE PROCEDURE [dbo].[spAccountPromiseCounts]
	@AccountID int,
	@ItemType tinyint	--1=Promises, 2=PDCs, 3=CreditCards
WITH RECOMPILE
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

DECLARE @Count INTEGER;
SET @Count = 0;

IF @ItemType = 1 BEGIN
	SELECT @Count = COUNT(*)
	FROM [dbo].[Promises]
	LEFT OUTER JOIN [dbo].[PromiseDetails]
	ON [Promises].[ID] = [PromiseDetails].[PromiseID]
	WHERE ([Promises].[AcctID] = @AccountID
		OR [PromiseDetails].[AccountID] = @AccountID)
	AND [Promises].[Active] = 1
	AND [Promises].[ApprovedBy] IS NOT NULL
	AND ([Promises].[Suspended] IS NULL
		OR [Promises].[Suspended] = 0); 
END;
ELSE IF @ItemType = 2 BEGIN
	SELECT COUNT(*)
	FROM [dbo].[pdc]
	LEFT OUTER JOIN [dbo].[PdcDetails]
	ON [pdc].[Number] = [PdcDetails].[AccountID]
	WHERE ([pdc].[Number] = @AccountID
		OR [PdcDetails].[AccountID] = @AccountID)
	AND [pdc].[Active] = 1
	AND [pdc].[OnHold] IS NULL;
END;
ELSE IF @ItemType = 3 BEGIN
	SELECT COUNT(*)
	FROM [dbo].[DebtorCreditCards]
	LEFT OUTER JOIN [dbo].[DebtorCreditCardDetails]
	ON [DebtorCreditCards].[Number] = [DebtorCreditCardDetails].[AccountID]
	WHERE ([DebtorCreditCards].[Number] = @AccountID
		OR [DebtorCreditCardDetails].[AccountID] = @AccountID)
	AND [DebtorCreditCards].[IsActive] = 1;
END;

RETURN @Count;


GO
