SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[QueueEngine_GetNextQueuableAccount] @Image IMAGE, @LittleEndian BIT = 1, @AccountID INTEGER OUTPUT, @Index INTEGER OUTPUT, @SetHold BIT = 1, @PermitRestricted BIT = 0, @EnforceTimeZoneRestrictions BIT = 1, @EnforceCollectorRestrictions BIT = 1
WITH RECOMPILE
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET NOCOUNT ON;

DECLARE @UTC DATETIME;
SET @UTC = GETUTCDATE();

BEGIN TRANSACTION;

SELECT TOP 1 @AccountID = [Accounts].[value],
	@Index = [Accounts].[RowId]
FROM [dbo].[fnExtractIds](@Image, @LittleEndian) AS [Accounts]
INNER JOIN [dbo].[master] WITH (ROWLOCK, UPDLOCK, READPAST)
ON [Accounts].[value] = [master].[number]
WHERE (([master].[qlevel] NOT IN ('000', '599', '998', '999')
			AND [master].[qlevel] NOT LIKE '?%')
		AND ([master].[contacted] < { fn CURDATE() }
			OR [master].[contacted] IS NULL
			OR [master].[qlevel] BETWEEN '400' AND '404')
		AND ([master].[QueueHold] < { fn CURDATE() }
			OR [master].[QueueHold] IS NULL)
		AND ([master].[ShouldQueue] = 1)
	OR @EnforceCollectorRestrictions = 0)
AND ([master].[RestrictedAccess] = 0
	OR @PermitRestricted = 1)
AND (EXISTS (SELECT *
	FROM [dbo].[Debtors]
	INNER JOIN [dbo].[GetCallableTimeZones](@UTC) AS [Callable]
	ON CASE WHEN DATEPART(HOUR, GETUTCDATE()) BETWEEN 6 AND 18
		THEN ISNULL([Debtors].[EarlyTimeZone], [dbo].[fnGetTimeZoneEx]([Debtors].[State], [Debtors].[ZipCode], [Debtors].[HomePhone], '8:00 AM'))
		ELSE ISNULL([Debtors].[LateTimeZone], [dbo].[fnGetTimeZoneEx]([Debtors].[State], [Debtors].[ZipCode], [Debtors].[HomePhone], '8:00 PM'))
	END = [Callable].[TimeZone]
	OR ([Debtors].[EarlyTimeZone] IS NULL
		AND [Callable].[TimeZone] IS NULL)
	WHERE [Debtors].[Number] = [master].[number])
	OR @EnforceTimeZoneRestrictions = 0)
ORDER BY [Accounts].[RowId] ASC;

IF @AccountID IS NOT NULL AND @SetHold = 1
	UPDATE [dbo].[master]
	SET [QueueHold] = GETDATE()
	WHERE [number] = @AccountID;

COMMIT TRANSACTION;

RETURN 0;


GO
