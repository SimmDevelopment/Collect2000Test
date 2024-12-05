SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_UpdateExecutionVariables]
AS
SET NOCOUNT ON;

DECLARE @ActivityVariableName VARCHAR(50);
SET @ActivityVariableName = '(ActivityVariable)';

DELETE [dbo].[WorkFlow_ExecutionVariables]
FROM [dbo].[WorkFlow_ExecutionVariables]
INNER JOIN #WorkFlowExec AS [WorkFlowExec]
ON [WorkFlowExec].[ExecID] = [WorkFlow_ExecutionVariables].[ExecID]
AND [WorkFlowExec].[ActivityID] = [WorkFlow_ExecutionVariables].[ActivityID]
INNER JOIN #WorkFlowAcct AS [WorkFlowAcct]
ON [WorkFlowAcct].[ExecID] = [WorkFlowExec].[ExecID]
AND [WorkFlowAcct].[AccountID] = [WorkFlow_ExecutionVariables].[AccountID]
WHERE [WorkFlow_ExecutionVariables].[Name] = @ActivityVariableName
AND ([WorkFlowExec].[NextActivityID] IS NOT NULL
	OR [WorkFlowAcct].[ActivityVariable] IS NULL);

UPDATE [dbo].[WorkFlow_ExecutionVariables]
SET [Variable] = [WorkFlowAcct].[ActivityVariable]
FROM [dbo].[WorkFlow_ExecutionVariables]
INNER JOIN #WorkFlowExec AS [WorkFlowExec]
ON [WorkFlowExec].[ExecID] = [WorkFlow_ExecutionVariables].[ExecID]
AND [WorkFlowExec].[ActivityID] = [WorkFlow_ExecutionVariables].[ActivityID]
INNER JOIN #WorkFlowAcct AS [WorkFlowAcct]
ON [WorkFlowAcct].[ExecID] = [WorkFlowExec].[ExecID]
AND [WorkFlowAcct].[AccountID] = [WorkFlow_ExecutionVariables].[AccountID]
WHERE [WorkFlowExec].[NextActivityID] IS NULL
AND [WorkFlowAcct].[ActivityVariable] IS NOT NULL
AND [WorkFlow_ExecutionVariables].[Name] = @ActivityVariableName;

INSERT INTO [dbo].[WorkFlow_ExecutionVariables] ([ExecID], [AccountID], [ActivityID], [Name], [Variable])
SELECT [WorkFlowExec].[ExecID], [WorkFlowAcct].[AccountID], [WorkFlowExec].[ActivityID], @ActivityVariableName, [WorkFlowAcct].[ActivityVariable]
FROM #WorkFlowExec AS [WorkFlowExec]
INNER JOIN #WorkFlowAcct AS [WorkFlowAcct]
ON [WorkFlowAcct].[ExecID] = [WorkFlowExec].[ExecID]
LEFT OUTER JOIN [dbo].[WorkFlow_ExecutionVariables]
ON [WorkFlow_ExecutionVariables].[ExecID] = [WorkFlowExec].[ExecID]
AND [WorkFlow_ExecutionVariables].[ActivityID] = [WorkFlowExec].[ActivityID]
AND [WorkFlow_ExecutionVariables].[AccountID] = [WorkFlowAcct].[AccountID]
AND [WorkFlow_ExecutionVariables].[Name] = @ActivityVariableName
WHERE [WorkFlowExec].[NextActivityID] IS NULL
AND [WorkFlowAcct].[ActivityVariable] IS NOT NULL
AND [WorkFlow_ExecutionVariables].[ExecID] IS NULL;

RETURN 0;
GO
