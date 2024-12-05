SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_Master_GetSettlementOrNonSettlementAgreement] @AccountID INTEGER
AS
SET NOCOUNT ON
	-- If there is a settlement record, then return those values, otherwise return appropriate values for a pif.
	SELECT COALESCE([Settlement].[SettlementAmount], [dbo].NetOriginal([master].[number]) + [Master].[Accrued2], 0) AS [SettlementAmount],
		COALESCE([Settlement].[SettlementTotalAmount], [dbo].NetOriginal([master].[number]) + [Master].[Accrued2], 0) AS [SettlementTotalAmount],
		COALESCE([Settlement].[SettlementTotalAmount] + [master].[Paid] - [master].[Paid10], [master].[current0], 0) AS [SettlementRemainingAmount],
		CASE ISNULL([Master].[IsInterestDeferred],0)
			WHEN 0 THEN 0
			ELSE ISNULL([Master].[DeferredInterest],0)
		END AS [DeferredInterest]
	FROM [dbo].[master] WITH (NOLOCK) LEFT OUTER JOIN [dbo].[Settlement] WITH (NOLOCK)
			ON [master].[number] = [Settlement].[AccountID] AND [master].[SettlementID] = [Settlement].[ID]
	WHERE [master].[number] = @AccountID AND [master].[qlevel] < '998'

RETURN 0;

GO
