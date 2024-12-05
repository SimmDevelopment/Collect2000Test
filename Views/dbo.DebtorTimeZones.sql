SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  VIEW [dbo].[DebtorTimeZones]
AS
SELECT [Debtors].[DebtorID], [Debtors].[number], [Debtors].[Seq],
	CASE
		WHEN DATEPART(HOUR, GETUTCDATE()) BETWEEN 6 AND 18
		THEN [Debtors].[EarlyTimeZone]
		ELSE [Debtors].[LateTimeZone]
	END AS [TimeZone]
FROM [dbo].[Debtors]


GO
