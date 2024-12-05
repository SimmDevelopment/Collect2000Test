SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Condition_EventRaised] @EventID UNIQUEIDENTIFIER
AS
SET NOCOUNT ON;

UPDATE [WorkFlowAcct]
SET [True] = 1
FROM #WorkFlowAcct AS [WorkFlowAcct]
INNER JOIN #WorkFlowExec AS [WorkFlowExec]
ON [WorkFlowAcct].[ExecID] = [WorkFlowExec].[ExecID]
INNER JOIN [dbo].[WorkFlow_EventHistory]
ON [WorkFlowAcct].[AccountID] = [WorkFlow_EventHistory].[AccountID]
WHERE [WorkFlow_EventHistory].[Occurred] >= [WorkFlowExec].[EnteredDate]
AND [WorkFlow_EventHistory].[EventID] = @EventID;

RETURN 0;
GO
