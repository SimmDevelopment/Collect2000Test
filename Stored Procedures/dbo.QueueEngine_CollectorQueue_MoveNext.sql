SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   PROCEDURE [dbo].[QueueEngine_CollectorQueue_MoveNext] @desk VARCHAR(10), @RestrictedAccess BIT = 0, @customers TEXT = NULL, @qlevels TEXT = NULL, @qdates TEXT = NULL, @qtimes TEXT = NULL, @remaining INTEGER OUTPUT
WITH RECOMPILE
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET NOCOUNT ON;
DECLARE @UTC DATETIME;

SET @UTC = GETUTCDATE();

SELECT [master].[number], [master].[qdate], [master].[qlevel], [master].[TotalViewed]
FROM [dbo].[master] WITH (NOLOCK)
WHERE [master].[desk] = @desk
AND [master].[qlevel] NOT IN ('000', '998', '999')
AND [master].[ShouldQueue] = 1
AND ([master].[RestrictedAccess] = 0
	OR @RestrictedAccess = 1)
AND ([master].[contacted] IS NULL
	OR [master].[contacted] < { fn CURDATE() })
AND ([master].[QueueHold] IS NULL
	OR [master].[QueueHold] < { fn CURDATE() })
AND [master].[current0] > 0.00
AND EXISTS (SELECT *
	FROM [dbo].[Debtors]
	INNER JOIN [dbo].[GetCallableTimeZones](@UTC) AS [Callable]
	ON CASE WHEN DATEPART(HOUR, GETUTCDATE()) BETWEEN 6 AND 18
		THEN [Debtors].[EarlyTimeZone]
		ELSE [Debtors].[LateTimeZone]
	END = [Callable].[TimeZone]
	OR ([Debtors].[EarlyTimeZone] IS NULL
		AND [Callable].[TimeZone] IS NULL)
	WHERE [Debtors].[Number] = [master].[number])
AND (@customers IS NULL
	OR [master].[customer] IN (SELECT CAST([value] AS VARCHAR(7)) FROM [dbo].[fnExtractFixedStrings](@customers, 7)))
AND (@qdates IS NULL
	OR [master].[qdate] IN (SELECT CAST([value] AS VARCHAR(8)) FROM [dbo].[fnExtractFixedStrings](@qdates, 8)))
AND (@qtimes IS NULL
	OR [master].[qtime] IN (SELECT CAST([value] AS VARCHAR(4)) FROM [dbo].[fnExtractFixedStrings](@qtimes, 4)))
AND (@qlevels IS NULL
	OR [master].[qlevel] IN (SELECT CAST([value] AS VARCHAR(3)) FROM [dbo].[fnExtractFixedStrings](@qlevels, 3))
	OR [master].[qlevel] LIKE '?%' AND EXISTS (SELECT CAST([value] AS VARCHAR(3)) FROM [dbo].[fnExtractFixedStrings](@qlevels, 3) WHERE [value] = '599'))	
AND master.[number] in
	(
		SELECT [number] from CallPreferences WITH (NOLOCK) where [WHEN] = 'Today' and DoNotCall = 0 and AllowedNow = 1
	);

SET @remaining = @@ROWCOUNT;

RETURN 0;

GO
