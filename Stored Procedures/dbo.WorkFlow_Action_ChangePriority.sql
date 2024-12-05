SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Action_ChangePriority] @Priority TINYINT
AS
SET NOCOUNT ON;

UPDATE #WorkFlowAcct
SET [Comment] = CASE [WorkFlow_Execution].[Priority]
	WHEN @Priority THEN 'Priority already set to ' + CAST([WorkFlow_Execution].[Priority] AS VARCHAR(3))
	ELSE 'Priority changed from ' + CAST([WorkFlow_Execution].[Priority] AS VARCHAR(3)) + ' to ' + CAST(@Priority AS VARCHAR(3))
END
FROM #WorkFlowAcct AS [WorkFlowAcct]
INNER JOIN [dbo].[WorkFlow_Execution]
ON [WorkFlow_Execution].[ID] = [WorkFlowAcct].[ExecID];

UPDATE [dbo].[WorkFlow_Execution]
SET [Priority] = @Priority
FROM [dbo].[WorkFlow_Execution]
INNER JOIN #WorkFlowExec AS [WorkFlowExec]
ON [WorkFlow_Execution].[ID] = [WorkFlowExec].[ExecID];

RETURN 0;
GO
