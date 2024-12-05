SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Action_StopAllWorkFlows]
AS
SET NOCOUNT ON;

DELETE [dbo].[WorkFlow_Execution]
FROM [dbo].[WorkFlow_Execution]
INNER JOIN #WorkFlowExec AS [WorkFlowExec]
ON [WorkFlowExec].[AccountID] = [WorkFlow_Execution].[AccountID]
AND [WorkFlowExec].[ExecID] != [WorkFlow_Execution].[ID];

RETURN 0;
GO
