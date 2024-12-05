SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_Master_GetLinkedSettlementAndNonSettlementAgreement] @AccountID INTEGER
AS
-- SET NOCOUNT ON

DECLARE @LinkID integer

SELECT @LinkID = ISNULL(link, 0) FROM master WHERE number = @AccountID

IF @LinkID IS NOT NULL AND @LinkID <> 0 BEGIN
	SELECT SUM(COALESCE([Settlement].[SettlementAmount], [dbo].NetOriginal([master].[number]) + [Master].[Accrued2], 0)) AS [SettlementAmount],
		SUM(COALESCE([Settlement].[SettlementTotalAmount], [dbo].NetOriginal([master].[number]) + [Master].[Accrued2], 0)) AS [SettlementTotalAmount],
		SUM(COALESCE([Settlement].[SettlementTotalAmount] + [master].[Paid] - [master].[Paid10], [master].[current0], 0)) AS [SettlementRemainingAmount],
		SUM(CASE ISNULL([Master].[IsInterestDeferred],0)
			WHEN 0 THEN 0
			ELSE ISNULL([Master].[DeferredInterest],0)
		END) AS [DeferredInterest]
	FROM [dbo].[master] WITH (NOLOCK) LEFT OUTER JOIN [dbo].[Settlement] WITH (NOLOCK)
			ON [master].[number] = [Settlement].[AccountID] AND [master].[SettlementID] = [Settlement].[ID]
	WHERE [master].[link] = @LinkID AND [master].[qlevel] < '998'
END
ELSE 
BEGIN
	EXECUTE [dbo].[sp_Master_GetSettlementOrNonSettlementAgreement] @AccountID
END



RETURN 0;

GO
