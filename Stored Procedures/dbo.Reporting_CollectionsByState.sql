SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Reporting_CollectionsByState] @StartDate DATETIME, @EndDate DATETIME
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT COALESCE([master].[state], '  ') AS [State],
	SUM(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_'
		THEN ([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
		WHEN [payhistory].[batchtype] LIKE 'P_R'
		THEN -([payhistory].[paid1] + [payhistory].[paid2] + [payhistory].[paid3] + [payhistory].[paid4] + [payhistory].[paid5] + [payhistory].[paid6] + [payhistory].[paid7] + [payhistory].[paid8] + [payhistory].[paid9] + [payhistory].[paid10])
		ELSE 0
	END) AS [NetPaid],
	SUM(CASE
		WHEN [payhistory].[batchtype] LIKE 'P_'
		THEN ([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
		WHEN [payhistory].[batchtype] LIKE 'P_R'
		THEN -([payhistory].[fee1] + [payhistory].[fee2] + [payhistory].[fee3] + [payhistory].[fee4] + [payhistory].[fee5] + [payhistory].[fee6] + [payhistory].[fee7] + [payhistory].[fee8] + [payhistory].[fee9] + [payhistory].[fee10])
		ELSE 0
	END) AS [NetFee]
FROM [dbo].[master]
INNER JOIN [dbo].[payhistory]
ON [master].[number] = [payhistory].[number]
WHERE [payhistory].[batchtype] LIKE 'P%'
AND [payhistory].[datepaid] >= @StartDate
AND [payhistory].[datepaid] < DATEADD(DAY, 1, @EndDate)
GROUP BY COALESCE([master].[state], '  ')
ORDER BY COALESCE([master].[state], '  ');

RETURN 0;

GO
