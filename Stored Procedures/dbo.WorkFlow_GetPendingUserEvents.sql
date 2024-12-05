SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_GetPendingUserEvents]
AS
SET NOCOUNT ON;

SELECT [ID], [Name], [Conditions], [MinimumDays], [MaximumDays], [ReoccurDays]
FROM [dbo].[WorkFlow_Events]
WHERE [SystemEvent] = 0
AND [Enabled] = 1
AND [Conditions] IS NOT NULL
AND [NextEvaluateDelay] > 0
AND ([NextEvaluateDate] <= GETDATE()
	OR [NextEvaluateDate] IS NULL)
ORDER BY [LastEvaluated] ASC;

RETURN 0;
GO
