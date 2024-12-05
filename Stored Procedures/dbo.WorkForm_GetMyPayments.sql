SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[WorkForm_GetMyPayments] @Desk VARCHAR(10), @Range TINYINT = 0
WITH RECOMPILE
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

DECLARE @SystemYear SMALLINT;
DECLARE @SystemMonth TINYINT;

SELECT TOP 1
	@SystemYear = [CurrentYear],
	@SystemMonth = [CurrentMonth]
FROM [dbo].[ControlFile];

IF @Range = 0
	SELECT [payhistory].[number] AS [number],
		COALESCE([Debtors].[Name], [master].[Name], '') AS [name],
		[payhistory].[batchtype],
		[payhistory].[IsCorrection],
		[payhistory].[totalpaid],
		([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10]) AS [agencyfee],
		[payhistory].[collectorfee] AS [collectorfee],
		[payhistory].[datepaid],
		[payhistory].[customer],
		ISNULL([payhistory].[comment], '') AS [comment]
	FROM [dbo].[payhistory]
	INNER JOIN [dbo].[master]
	ON [payhistory].[number] = [master].[number]
	LEFT OUTER JOIN [dbo].[Debtors]
	ON [payhistory].[number] = [Debtors].[number]
	AND [payhistory].[SEQ] = [Debtors].[Seq]
	WHERE [payhistory].[batchtype] LIKE 'P%'
	AND [payhistory].[desk] = @Desk
	AND [payhistory].[entered] >= CAST({ fn CURDATE() } AS DATETIME)
	ORDER BY [datepaid] ASC;
ELSE IF @Range = 1
	SELECT [payhistory].[number] AS [number],
		COALESCE([Debtors].[Name], [master].[Name], '') AS [name],
		[payhistory].[batchtype],
		[payhistory].[IsCorrection],
		[payhistory].[totalpaid],
		([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10]) AS [agencyfee],
		[payhistory].[collectorfee] AS [collectorfee],
		[payhistory].[datepaid],
		[payhistory].[customer],
		ISNULL([payhistory].[comment], '') AS [comment]
	FROM [dbo].[payhistory]
	INNER JOIN [dbo].[master]
	ON [payhistory].[number] = [master].[number]
	LEFT OUTER JOIN [dbo].[Debtors]
	ON [payhistory].[number] = [Debtors].[number]
	AND [payhistory].[SEQ] = [Debtors].[Seq]
	WHERE [payhistory].[batchtype] LIKE 'P%'
	AND [payhistory].[desk] = @Desk
	AND [payhistory].[systemyear] = @SystemYear
	AND [payhistory].[systemmonth] = @SystemMonth
	ORDER BY [datepaid] ASC;
ELSE
	SELECT [payhistory].[number] AS [number],
		COALESCE([Debtors].[Name], [master].[Name], '') AS [name],
		[payhistory].[batchtype],
		[payhistory].[IsCorrection],
		[payhistory].[totalpaid],
		([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10]) AS [agencyfee],
		[payhistory].[collectorfee] AS [collectorfee],
		[payhistory].[datepaid],
		[payhistory].[customer],
		ISNULL([payhistory].[comment], '') AS [comment]
	FROM [dbo].[payhistory]
	INNER JOIN [dbo].[master]
	ON [payhistory].[number] = [master].[number]
	LEFT OUTER JOIN [dbo].[Debtors]
	ON [payhistory].[number] = [Debtors].[number]
	AND [payhistory].[SEQ] = [Debtors].[Seq]
	WHERE [payhistory].[batchtype] LIKE 'P%'
	AND [payhistory].[desk] = @Desk
	AND [payhistory].[systemyear] = @SystemYear
	ORDER BY [datepaid] ASC;

RETURN 0;



GO
