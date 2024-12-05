SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_Master_GetSettlementAgreement] @AccountID INTEGER
AS
SET NOCOUNT ON

SELECT [Settlement].[SettlementAmount] AS [SettlementTotalAmount],
	[Settlement].[SettlementTotalAmount] + [master].[Paid] AS [SettlementRemainingAmount]
FROM [dbo].[master] WITH (NOLOCK)
INNER JOIN [dbo].[Settlement] WITH (NOLOCK)
ON [master].[number] = [Settlement].[AccountID]
AND [master].[SettlementID] = [Settlement].[ID]
WHERE [master].[number] = @AccountID
AND [Settlement].[SettlementTotalAmount] IS NOT NULL
AND [Settlement].[SettlementTotalAmount] > 0;

RETURN 0;

GO
