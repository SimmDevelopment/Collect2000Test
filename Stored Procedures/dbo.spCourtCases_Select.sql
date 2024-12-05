SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*spCourtCases_Select*/
CREATE   PROCEDURE [dbo].[spCourtCases_Select]
	@AccountID int
AS
SET NOCOUNT ON;

SELECT [CourtCases].*,
	[payhistory].[paid1] AS [Adjustment1],
	[payhistory].[paid2] AS [Adjustment2],
	[payhistory].[paid3] AS [Adjustment3],
	[payhistory].[paid4] AS [Adjustment4],
	[payhistory].[paid5] AS [Adjustment5],
	[payhistory].[paid6] AS [Adjustment6],
	[payhistory].[paid7] AS [Adjustment7],
	[payhistory].[paid8] AS [Adjustment8],
	[payhistory].[paid9] AS [Adjustment9],
	[payhistory].[paid10] AS [Adjustment10],
	[payhistory].[balance1] AS [Balance1],
	[payhistory].[balance2] AS [Balance2],
	[payhistory].[balance3] AS [Balance3],
	[payhistory].[balance4] AS [Balance4],
	[payhistory].[balance5] AS [Balance5],
	[payhistory].[balance6] AS [Balance6],
	[payhistory].[balance7] AS [Balance7],
	[payhistory].[balance8] AS [Balance8],
	[payhistory].[balance9] AS [Balance9],
	[payhistory].[balance10] AS [Balance10]
FROM [dbo].[CourtCases] WITH (NOLOCK)
LEFT OUTER JOIN [dbo].[payhistory] WITH (NOLOCK)
ON [CourtCases].[JudgementPayhistoryUID] = payhistory.UID
AND [payhistory].[batchtype] = 'LJ'
WHERE [CourtCases].[AccountID] = @AccountID;

Return @@Error



GO
