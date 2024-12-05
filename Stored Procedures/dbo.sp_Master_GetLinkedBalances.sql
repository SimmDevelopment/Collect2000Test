SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*sp_Master_GetLinkedBalances*/
CREATE Procedure [dbo].[sp_Master_GetLinkedBalances] @AccountID INTEGER
AS

SELECT
	COALESCE([lb].[original], [m].[original], 0) AS [original],
	COALESCE([lb].[original1], [m].[original1], 0) AS [original1],
	COALESCE([lb].[original2], [m].[original2], 0) AS [original2],
	COALESCE([lb].[original3], [m].[original3], 0) AS [original3],
	COALESCE([lb].[original4], [m].[original4], 0) AS [original4],
	COALESCE([lb].[original5], [m].[original5], 0) AS [original5],
	COALESCE([lb].[original6], [m].[original6], 0) AS [original6],
	COALESCE([lb].[original7], [m].[original7], 0) AS [original7],
	COALESCE([lb].[original8], [m].[original8], 0) AS [original8],
	COALESCE([lb].[original9], [m].[original9], 0) AS [original9],
	COALESCE([lb].[original10], [m].[original10], 0) AS [original10],
	COALESCE([lb].[accrued2], [m].[accrued2], 0) AS [accrued2],
	COALESCE([lb].[accrued10], [m].[accrued10], 0) AS [accrued10],
	COALESCE([lb].[paid], [m].[paid], 0) AS [paid],
	COALESCE([lb].[paid1], [m].[paid1], 0) AS [paid1],
	COALESCE([lb].[paid2], [m].[paid2], 0) AS [paid2],
	COALESCE([lb].[paid3], [m].[paid3], 0) AS [paid3],
	COALESCE([lb].[paid4], [m].[paid4], 0) AS [paid4],
	COALESCE([lb].[paid5], [m].[paid5], 0) AS [paid5],
	COALESCE([lb].[paid6], [m].[paid6], 0) AS [paid6],
	COALESCE([lb].[paid7], [m].[paid7], 0) AS [paid7],
	COALESCE([lb].[paid8], [m].[paid8], 0) AS [paid8],
	COALESCE([lb].[paid9], [m].[paid9], 0) AS [paid9],
	COALESCE([lb].[paid10], [m].[paid10], 0) AS [paid10],
	COALESCE([lb].[current0], [m].[current0], 0) AS [current0],
	COALESCE([lb].[current1], [m].[current1], 0) AS [current1],
	COALESCE([lb].[current2], [m].[current2], 0) AS [current2],
	COALESCE([lb].[current3], [m].[current3], 0) AS [current3],
	COALESCE([lb].[current4], [m].[current4], 0) AS [current4],
	COALESCE([lb].[current5], [m].[current5], 0) AS [current5],
	COALESCE([lb].[current6], [m].[current6], 0) AS [current6],
	COALESCE([lb].[current7], [m].[current7], 0) AS [current7],
	COALESCE([lb].[current8], [m].[current8], 0) AS [current8],
	COALESCE([lb].[current9], [m].[current9], 0) AS [current9],
	COALESCE([lb].[current10], [m].[current10], 0) AS [current10]
FROM [dbo].[master] AS [m] WITH (NOLOCK)
LEFT OUTER JOIN [dbo].[LinkedBalances] AS [lb] WITH (NOLOCK)
ON [m].[link] = [lb].[link]
WHERE [m].[number] = @AccountID;

RETURN 0;

GO
