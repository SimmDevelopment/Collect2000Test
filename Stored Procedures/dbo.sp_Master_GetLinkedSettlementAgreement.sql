SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_Master_GetLinkedSettlementAgreement] @AccountID INTEGER
AS
SET NOCOUNT ON

DECLARE @LinkID integer

SELECT @LinkID = ISNULL(link, 0) FROM master WHERE number = @AccountID

IF @LinkID IS NOT NULL AND @LinkID <> 0 BEGIN
	SELECT SUM([Settlement].[SettlementAmount]) AS [SettlementTotalAmount],
		SUM([Settlement].[SettlementTotalAmount] + [master].[Paid]) AS [SettlementRemainingAmount]
	FROM [dbo].[master] WITH (NOLOCK) INNER JOIN [dbo].[Settlement] WITH (NOLOCK)
		ON [master].[number] = [Settlement].[AccountID] AND [master].[SettlementID] = [Settlement].[ID]
	WHERE [master].[link] = @LinkID;
END
ELSE 
BEGIN
	SELECT [Settlement].[SettlementAmount] AS [SettlementTotalAmount],
		[Settlement].[SettlementTotalAmount] + [master].[Paid] AS [SettlementRemainingAmount]
	FROM [dbo].[master] WITH (NOLOCK) INNER JOIN [dbo].[Settlement] WITH (NOLOCK)
		ON [master].[number] = [Settlement].[AccountID]	AND [master].[SettlementID] = [Settlement].[ID]
	WHERE [master].[number] = @AccountID
END

RETURN 0;

GO
