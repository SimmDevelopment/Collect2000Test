SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[ManagerStats_GetStatistics]
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

DECLARE @MaxRanks INTEGER;
SET @MaxRanks = 5;

DECLARE @CurrentMonth DATETIME;

DECLARE @Months TABLE (
	[Date] DATETIME NOT NULL PRIMARY KEY CLUSTERED,
	[Month] AS CAST(DATEPART(MONTH, [Date]) AS TINYINT),
	[Year] AS CAST(DATEPART(YEAR, [Date]) AS SMALLINT)
);

SET @CurrentMonth = [dbo].[GetCurrentMonthScalar]();

SELECT TOP 1
	[Company],
	[SoftwareVersion],
	@CurrentMonth AS [CurrentMonth]
FROM [dbo].[controlFile];

INSERT INTO @Months ([Date])
SELECT DATEADD(MONTH, -6, @CurrentMonth)
UNION ALL
SELECT DATEADD(MONTH, -5, @CurrentMonth)
UNION ALL
SELECT DATEADD(MONTH, -4, @CurrentMonth)
UNION ALL
SELECT DATEADD(MONTH, -3, @CurrentMonth)
UNION ALL
SELECT DATEADD(MONTH, -2, @CurrentMonth)
UNION ALL
SELECT DATEADD(MONTH, -1, @CurrentMonth)
UNION ALL
SELECT @CurrentMonth;

DECLARE @Placements TABLE (
	[Month] DATETIME NOT NULL,
	[Customer] VARCHAR(7) NOT NULL,
	[Balance] MONEY NOT NULL
);

INSERT INTO @Placements ([Month], [Customer], [Balance])
SELECT [Months].[Date],
	[StairStep].[customer],
	[StairStep].[NetDollarsPlaced] AS [Balance]
FROM @Months AS [Months]
INNER JOIN [dbo].[StairStep]
ON [Months].[Month] = [StairStep].[SSMonth]
AND [Months].[Year] = [StairStep].[SSYear];

DECLARE @TopPlacers TABLE (
	[ID] INTEGER NOT NULL IDENTITY(1, 1),
	[Name] VARCHAR(75) NOT NULL
);

SET ROWCOUNT @MaxRanks;

INSERT INTO @TopPlacers ([Name])
SELECT [customer].[name]
FROM @Placements AS [Placements]
INNER JOIN [dbo].[customer]
ON [Placements].[Customer] = [customer].[customer]
GROUP BY [customer].[name]
ORDER BY SUM([Placements].[Balance]) DESC;

SET ROWCOUNT 0;

SELECT COALESCE([TopPlacers].[ID], 9999999) AS [ID],
	COALESCE([TopPlacers].[Name], 'Others') AS [Name],
	[Placements].[Month],
	SUM([Placements].[Balance]) AS [Balance]
FROM @Placements AS [Placements]
INNER JOIN [dbo].[customer]
ON [Placements].[customer] = [customer].[customer]
LEFT OUTER JOIN @TopPlacers AS [TopPlacers]
ON [customer].[name] = [TopPlacers].[Name]
GROUP BY COALESCE([TopPlacers].[ID], 9999999),
	COALESCE([TopPlacers].[Name], 'Others'),
	[Placements].[Month]
ORDER BY [ID],
	[Name],
	[Month];

DECLARE @Payments TABLE (
	[Month] DATETIME NOT NULL,
	[Customer] VARCHAR(7) NOT NULL,
	[Paid] MONEY NOT NULL,
	[Fee] MONEY NOT NULL
);

INSERT INTO @Payments ([Month], [Customer], [Paid], [Fee])
SELECT [Months].[Date],
	[payhistory].[customer],
	SUM(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
		ELSE ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
	END) AS [Paid],
	SUM(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_R' THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
		ELSE ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
	END) AS [Fee]
FROM @Months AS [Months]
INNER JOIN [dbo].[payhistory]
ON [Months].[Year] = [payhistory].[SystemYear]
AND [Months].[Month] = [payhistory].[SystemMonth]
WHERE [payhistory].[batchtype] LIKE 'P_%'
GROUP BY [Months].[Date],
	[payhistory].[customer];

DECLARE @TopPayers TABLE (
	[ID] INTEGER NOT NULL IDENTITY(1, 1),
	[Name] VARCHAR(75) NOT NULL
);

SET ROWCOUNT @MaxRanks;

INSERT INTO @TopPayers ([Name])
SELECT [customer].[name]
FROM @Payments AS [Payments]
INNER JOIN [dbo].[customer]
ON [Payments].[Customer] = [customer].[customer]
GROUP BY [customer].[name]
ORDER BY SUM([Payments].[Fee]) DESC;

SET ROWCOUNT 0;

SELECT COALESCE([TopPayers].[ID], 9999999) AS [ID],
	COALESCE([TopPayers].[Name], 'Others') AS [Name],
	[Payments].[Month],
	SUM([Payments].[Paid]) AS [Paid],
	SUM([Payments].[Fee]) AS [Fee]
FROM @Payments AS [Payments]
INNER JOIN [dbo].[customer]
ON [Payments].[customer] = [customer].[customer]
LEFT OUTER JOIN @TopPayers AS [TopPayers]
ON [customer].[name] = [TopPayers].[Name]
GROUP BY COALESCE([TopPayers].[ID], 9999999),
	COALESCE([TopPayers].[Name], 'Others'),
	[Payments].[Month]
ORDER BY [ID],
	[Name],
	[Month];

RETURN 0;


GO
