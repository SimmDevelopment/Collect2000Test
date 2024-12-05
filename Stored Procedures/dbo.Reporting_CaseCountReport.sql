SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Reporting_CaseCountReport] @IncludeNonQueuing BIT = 0
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT [desk].[code] AS [DeskCode],
	[desk].[name] AS [DeskName],
	[customer].[customer] AS [CustomerCode],
	[customer].[name] AS [CustomerName],
	COUNT([master].[number]) AS [TotalAccounts],
	SUM([master].[current0]) AS [TotalBalance],
	AVG([master].[current0]) AS [AverageBalance]
FROM [dbo].[master]
INNER JOIN [dbo].[desk]
ON [master].[desk] = [desk].[code]
INNER JOIN [dbo].[customer]
ON [master].[customer] = [customer].[customer]
WHERE [master].[qlevel] NOT IN ('998', '999')
AND ([master].[ShouldQueue] = 1
	OR @IncludeNonQueuing = 1)
GROUP BY [desk].[code], [desk].[name], [customer].[customer], [customer].[name]
ORDER BY [desk].[code], [customer].[customer];

RETURN 0;

GO
