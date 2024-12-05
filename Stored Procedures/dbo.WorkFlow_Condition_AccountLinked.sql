SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Condition_AccountLinked] @LinkDriverActivityID UNIQUEIDENTIFIER, @LinkFollowerActivityID UNIQUEIDENTIFIER, @NotLinkedActivityID UNIQUEIDENTIFIER
AS
SET NOCOUNT ON;

UPDATE [WorkFlowExec]
SET [NextActivityID] = CASE
	WHEN [master].[link] > 0 AND [master].[LinkDriver] = 1 THEN @LinkDriverActivityID
	WHEN [master].[link] > 0 THEN @LinkFollowerActivityID
	WHEN [master].[link] = 0 THEN @NotLinkedActivityID
END,
	[NextEvaluateDate] = DATEADD(MINUTE, 15, GETDATE())
FROM #WorkFlowExec AS [WorkFlowExec]
INNER JOIN [dbo].[master] WITH (NOLOCK)
ON [WorkFlowExec].[AccountID] = [master].[number];

RETURN 0;
GO
