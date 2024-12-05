SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE   PROCEDURE [dbo].[QueueEngine_PieQueue_GetUpdatedAccounts] @accounts IMAGE, @littleEndian BIT, @desks TEXT
WITH RECOMPILE
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

DECLARE @AccountsTable TABLE (
	[AccountID] INTEGER NOT NULL PRIMARY KEY NONCLUSTERED
);

DECLARE @DesksTable TABLE (
	[Desk] VARCHAR(10) NOT NULL PRIMARY KEY CLUSTERED
);

INSERT INTO @AccountsTable ([AccountID])
SELECT [value]
FROM [dbo].[fnExtractIds](@accounts, @littleEndian)
GROUP BY [value];

INSERT INTO @DesksTable ([Desk])
SELECT CAST([value] AS VARCHAR(10))
FROM [dbo].[fnExtractFixedStrings](@desks, 10)
GROUP BY CAST([value] AS VARCHAR(10))
ORDER BY CAST([value] AS VARCHAR(10));

SELECT [number]
FROM [dbo].[master]
INNER JOIN @AccountsTable AS [Accounts]
ON [master].[number] = [Accounts].[AccountID]
LEFT OUTER JOIN @DesksTable AS [Desks]
ON [master].[desk] = [Desks].[Desk]
WHERE [master].[qlevel] NOT BETWEEN '001' AND '558'
OR [master].[ShouldQueue] = 0
OR [master].[Worked] >= CAST({ fn CURDATE() } AS DATETIME)
OR [Desks].[Desk] IS NULL;

RETURN 0;


GO
