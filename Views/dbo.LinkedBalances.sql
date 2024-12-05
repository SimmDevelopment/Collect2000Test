SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   VIEW [dbo].[LinkedBalances]
AS
SELECT [master].[link],
	SUM([master].[original]) AS [original],
	SUM([master].[original1]) AS [original1],
	SUM([master].[original2]) AS [original2],
	SUM([master].[original3]) AS [original3],
	SUM([master].[original4]) AS [original4],
	SUM([master].[original5]) AS [original5],
	SUM([master].[original6]) AS [original6],
	SUM([master].[original7]) AS [original7],
	SUM([master].[original8]) AS [original8],
	SUM([master].[original9]) AS [original9],
	SUM([master].[original10]) AS [original10],
	SUM([master].[paid]) AS [paid],
	SUM([master].[paid1]) AS [paid1],
	SUM([master].[paid2]) AS [paid2],
	SUM([master].[paid3]) AS [paid3],
	SUM([master].[paid4]) AS [paid4],
	SUM([master].[paid5]) AS [paid5],
	SUM([master].[paid6]) AS [paid6],
	SUM([master].[paid7]) AS [paid7],
	SUM([master].[paid8]) AS [paid8],
	SUM([master].[paid9]) AS [paid9],
	SUM([master].[paid10]) AS [paid10],
	SUM([master].[current0]) AS [current0],
	SUM([master].[current1]) AS [current1],
	SUM([master].[current2]) AS [current2],
	SUM([master].[current3]) AS [current3],
	SUM([master].[current4]) AS [current4],
	SUM([master].[current5]) AS [current5],
	SUM([master].[current6]) AS [current6],
	SUM([master].[current7]) AS [current7],
	SUM([master].[current8]) AS [current8],
	SUM([master].[current9]) AS [current9],
	SUM([master].[current10]) AS [current10],
	SUM(([master].[current0] - [master].[paid]) - [master].[original]) AS [accrued],
	SUM(([master].[current1] - [master].[paid1]) - [master].[original1]) AS [accrued1],
	SUM(([master].[current2] - [master].[paid2]) - [master].[original2]) AS [accrued2],
	SUM(([master].[current3] - [master].[paid3]) - [master].[original3]) AS [accrued3],
	SUM(([master].[current4] - [master].[paid4]) - [master].[original4]) AS [accrued4],
	SUM(([master].[current5] - [master].[paid5]) - [master].[original5]) AS [accrued5],
	SUM(([master].[current6] - [master].[paid6]) - [master].[original6]) AS [accrued6],
	SUM(([master].[current7] - [master].[paid7]) - [master].[original7]) AS [accrued7],
	SUM(([master].[current8] - [master].[paid8]) - [master].[original8]) AS [accrued8],
	SUM(([master].[current9] - [master].[paid9]) - [master].[original9]) AS [accrued9],
	SUM(([master].[current10] - [master].[paid10]) - [master].[original10]) AS [accrued10],
	SUM(COALESCE([Settlement].[SettlementAmount], [dbo].NetOriginal([master].[number]) + [Master].[Accrued2], 0)) AS [SettlementAmount],
	SUM(COALESCE([Settlement].[SettlementTotalAmount], [dbo].NetOriginal([master].[number]) + [Master].[Accrued2], 0)) AS [SettlementTotalAmount],
	SUM(COALESCE([Settlement].[SettlementTotalAmount] + [master].[Paid] - [master].[Paid10], [master].[current0], 0)) AS [SettlementRemainingAmount],
	SUM(CASE ISNULL([Master].[IsInterestDeferred],0)
		WHEN 0 THEN 0
		ELSE ISNULL([Master].[DeferredInterest],0)
	END) AS [DeferredInterest],
	SUM(CASE ISNULL([Master].[IsInterestDeferred],0)
		WHEN 0 THEN 0
		ELSE ISNULL([Master].[DeferredInterest],0)
	END + [master].[Accrued2]) AS [AccruedAndDeferredInterest]
FROM [dbo].[master] WITH (NOLOCK) LEFT OUTER JOIN [dbo].[Settlement] WITH (NOLOCK)
			ON [master].[number] = [Settlement].[AccountID] AND [master].[SettlementID] = [Settlement].[ID]
WHERE [master].[link] <> 0
AND [master].[qlevel] < '998'
GROUP BY [master].[link]

GO
