SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE   VIEW [dbo].[MasterTimeZones]
AS
SELECT [Debtors].[number],
	MIN([EarlyTimeZone]) AS [EarlyTimeZone],
	MAX([LateTimeZone]) AS [LateTimeZone],
	CASE
		WHEN DATEPART(HOUR, GETUTCDATE()) BETWEEN 6 AND 18
		THEN MIN([EarlyTimeZone])
		ELSE MAX([LateTimeZone])
	END AS [TimeZone]
FROM [dbo].[Debtors]
GROUP BY [Debtors].[number]



GO
