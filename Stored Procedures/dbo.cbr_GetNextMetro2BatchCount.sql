SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
----------------------------------------------------------------
CREATE  PROCEDURE [dbo].[cbr_GetNextMetro2BatchCount] @ReportChangesOnly BIT = 1
WITH RECOMPILE
AS

IF NOT EXISTS (SELECT TOP 1 * FROM cbrCustomGroup)

	SELECT COUNT(DISTINCT [a].[accountID])
	FROM [dbo].[cbr_accounts] AS [a]
	INNER JOIN [dbo].[Master] AS [m]
		ON [a].[accountID] = [m].[number]
	INNER JOIN [dbo].[status] AS [s] 
		ON [m].[status] = [s].[code]
	LEFT OUTER JOIN [dbo].[cbr_debtors] AS [d]	
		ON [a].[accountID] = [d].[accountID]
	WHERE [a].[written] = 0
	AND [m].[cbrPrevent] = 0
	AND [s].[cbrReport] = 1
	AND (@ReportChangesOnly = 0
		OR [a].[lastUpdated] > coalesce([a].[lastReported],'01/01/1900')
		OR [d].[lastUpdated] > coalesce([a].[lastReported],'01/01/1900'))
ELSE
		
	SELECT COUNT(DISTINCT [a].[accountID])
	FROM [dbo].[cbr_accounts] AS [a]
	INNER JOIN cbrCustomGroup AS [g] 
		ON [g].[number] = [a].[accountID]
	INNER JOIN [dbo].[Master] AS [m]
		ON [g].[number] = [m].[number]
	INNER JOIN [dbo].[status] AS [s] 
		ON [m].[status] = [s].[code]
	LEFT OUTER JOIN [dbo].[cbr_debtors] AS [d]	
		ON [m].[number] = [d].[accountID]
	WHERE [a].[written] = 0
	AND [m].[cbrPrevent] = 0
	AND [s].[cbrReport] = 1
	AND (@ReportChangesOnly = 0
		OR [a].[lastUpdated] > coalesce([a].[lastReported],'01/01/1900')
		OR [d].[lastUpdated] > coalesce([a].[lastReported],'01/01/1900'));


RETURN 0;
GO
