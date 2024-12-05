SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Account_ShouldAccountQueue] @AccountID INTEGER, @SetHold BIT, @ShouldQueue BIT OUTPUT, @PermitRestricted BIT = 0, @EnforceTimeZoneRestrictions BIT = 1, @EnforceCollectorRestrictions BIT = 1
WITH RECOMPILE
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET XACT_ABORT ON;

DECLARE @UTC DATETIME;
SET @UTC = GETUTCDATE();

UPDATE [dbo].[master] WITH (ROWLOCK)
SET [QueueHold] = CASE @SetHold
		WHEN 1 THEN { fn CURDATE() }
		ELSE NULL
	END
WHERE [master].[number] = @AccountID
AND (([master].[qlevel] NOT IN ('000', '599', '998', '999')
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
	OR @EnforceTimeZoneRestrictions = 0);

IF @@ROWCOUNT = 1
	SET @ShouldQueue = 1;
ELSE
	SET @ShouldQueue = 0;

RETURN 0;


GO
