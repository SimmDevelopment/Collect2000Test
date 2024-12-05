SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[WorkFlow_Switch_SaveActivityVariables] @ConditionActivityID UNIQUEIDENTIFIER
AS
SET NOCOUNT ON;

BEGIN TRANSACTION;

DELETE [dbo].[WorkFlow_SwitchActivityVariables] WITH (TABLOCKX)
FROM [dbo].[WorkFlow_SwitchActivityVariables]
INNER JOIN #WorkFlowAcct AS [WorkFlowAcct]
ON [WorkFlowAcct].[ExecID] = [WorkFlow_SwitchActivityVariables].[ExecID]
AND [WorkFlowAcct].[AccountID] = [WorkFlow_SwitchActivityVariables].[AccountID]
WHERE [WorkFlow_SwitchActivityVariables].[ConditionActivityID] = @ConditionActivityID
AND [WorkFlowAcct].[ActivityVariable] IS NULL;

UPDATE [dbo].[WorkFlow_SwitchActivityVariables] WITH (TABLOCKX)
SET [Variable] = [WorkFlowAcct].[ActivityVariable]
FROM [dbo].[WorkFlow_SwitchActivityVariables]
INNER JOIN #WorkFlowAcct AS [WorkFlowAcct]
ON [WorkFlowAcct].[ExecID] = [WorkFlow_SwitchActivityVariables].[ExecID]
AND [WorkFlowAcct].[AccountID] = [WorkFlow_SwitchActivityVariables].[AccountID]
WHERE [WorkFlow_SwitchActivityVariables].[ConditionActivityID] = @ConditionActivityID
AND [WorkFlowAcct].[ActivityVariable] IS NOT NULL;

INSERT INTO [dbo].[WorkFlow_SwitchActivityVariables] ([ExecID], [AccountID], [ConditionActivityID], [Variable])
SELECT [WorkFlowAcct].[ExecID], [WorkFlowAcct].[AccountID], @ConditionActivityID, [WorkFlowAcct].[ActivityVariable]
FROM #WorkFlowAcct AS [WorkFlowAcct]
LEFT OUTER JOIN [dbo].[WorkFlow_SwitchActivityVariables]
ON [WorkFlowAcct].[ExecID] = [WorkFlow_SwitchActivityVariables].[ExecID]
AND [WorkFlowAcct].[AccountID] = [WorkFlow_SwitchActivityVariables].[AccountID]
AND [WorkFlow_SwitchActivityVariables].[ConditionActivityID] = @ConditionActivityID
WHERE [WorkFlowAcct].[ActivityVariable] IS NOT NULL
AND [WorkFlow_SwitchActivityVariables].[ExecID] IS NULL;

COMMIT TRANSACTION;

RETURN 0;
GO
