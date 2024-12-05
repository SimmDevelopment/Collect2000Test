SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Switch_RestoreActivityVariables] @ConditionActivityID UNIQUEIDENTIFIER
AS
SET NOCOUNT ON;

UPDATE [WorkFlowAcct]
SET [ActivityVariable] = [WorkFlow_SwitchActivityVariables].[Variable]
FROM #WorkFlowAcct AS [WorkFlowAcct]
INNER JOIN [dbo].[WorkFlow_SwitchActivityVariables]
ON [WorkFlowAcct].[ExecID] = [WorkFlow_SwitchActivityVariables].[ExecID]
AND [WorkFlowAcct].[AccountID] = [WorkFlow_SwitchActivityVariables].[AccountID]
WHERE [WorkFlow_SwitchActivityVariables].[ConditionActivityID] = @ConditionActivityID;

RETURN 0;
GO
