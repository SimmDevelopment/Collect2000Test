SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Switch_TimeoutAccounts] @TimeoutActivityID UNIQUEIDENTIFIER, @Duration BIGINT, @RetryDelay BIGINT
AS
SET NOCOUNT ON;

UPDATE #WorkFlowExec
SET [NextActivityID] = @TimeoutActivityID
WHERE [NextActivityID] IS NULL
AND [EnteredDate] < DATEADD(MINUTE, -@Duration, GETDATE());

UPDATE #WorkFlowExec
SET [NextEvaluateDate] = DATEADD(MINUTE, @RetryDelay, GETDATE())
WHERE [NextActivityID] IS NULL;

DELETE [dbo].[WorkFlow_SwitchActivityVariables]
FROM [dbo].[WorkFlow_SwitchActivityVariables]
INNER JOIN #WorkFlowExec AS [WorkFlowExec]
ON [WorkFlow_SwitchActivityVariables].[ExecID] = [WorkFlowExec].[ExecID]
WHERE [WorkFlowExec].[NextActivityID] IS NOT NULL;

RETURN 0;
GO
